import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:rnm_app/models/character_model.dart';

class FavoritesState {
  final List<Character> favorites;
  FavoritesState(this.favorites);
}

class FavoritesCubit extends Cubit<FavoritesState> {
  final Box<Character> favoritesBox;

  FavoritesCubit(this.favoritesBox) : super(FavoritesState(favoritesBox.values.toList()));

  void toggleFavorite(Character character) {
    if (isFavorite(character.id)) {
      favoritesBox.delete(character.id);
    } else {
      //новый объект для избранного
      final favoriteCharacter = Character(
        id: character.id,
        name: character.name,
        image: character.image,
        status: character.status,
      );
      favoritesBox.put(favoriteCharacter.id, favoriteCharacter);
    }

    emit(FavoritesState(favoritesBox.values.toList()));
  }

  bool isFavorite(int id) {
    return favoritesBox.containsKey(id);
  }
}