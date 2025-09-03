import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:rnm_app/models/character_model.dart';


abstract class CharacterListState {}

class CharacterListLoading extends CharacterListState {}

class CharacterListLoaded extends CharacterListState {
  final List<Character> characters;
  final bool hasMore;

  CharacterListLoaded(this.characters, {this.hasMore = true});
}

class CharacterListError extends CharacterListState {
  final String message;
  CharacterListError(this.message);
}

class CharacterListCubit extends Cubit<CharacterListState> {
  final Box<Character> cacheBox;
  int _page = 1;
  bool _isLoading = false;

  CharacterListCubit(this.cacheBox) : super(CharacterListLoading()) {
    _loadFromCache();
    loadCharacters();
  }

  Future<void> _loadFromCache() async {
    final cached = cacheBox.values.toList();
    if (cached.isNotEmpty) {
      emit(CharacterListLoaded(cached, hasMore: true));
    }
  }

  Future<void> loadCharacters({bool nextPage = false}) async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      if (!nextPage) _page = 1;

      final response = await http
          .get(Uri.parse("https://rickandmortyapi.com/api/character?page=$_page"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final List<dynamic> results = data['results'];
        final List<Character> characters =
        results.map<Character>((c) => Character.fromJson(c)).toList();

        // Сохраняем в кеш Hive
        if (!nextPage) await cacheBox.clear();
        await cacheBox.addAll(characters);

        // Получаем уже загруженные персонажи (если подгружаем следующую страницу)
        final List<Character> currentState =
        state is CharacterListLoaded ? (state as CharacterListLoaded).characters : [];

        final List<Character> updated =
        nextPage ? [...currentState, ...characters] : characters;

        emit(CharacterListLoaded(
          updated,
          hasMore: data['info']['next'] != null,
        ));

        _page++;
      } else {
        emit(CharacterListError("Error: ${response.statusCode}"));
      }
    } catch (e) {
      emit(CharacterListError(e.toString()));
    } finally {
      _isLoading = false;
    }
  }
}
