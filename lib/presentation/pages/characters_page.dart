import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rnm_app/presentation/cubits/favorities_cubit.dart';
import '../cubits/character_list_cubit.dart';
import '../widgets/character_card.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final cubit = context.read<CharacterListCubit>();
        final state = cubit.state;
        if (state is CharacterListLoaded && state.hasMore) {
          cubit.loadCharacters(nextPage: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterListCubit, CharacterListState>(
      builder: (context, state) {
        if (state is CharacterListLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CharacterListLoaded) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: state.characters.length,
            itemBuilder: (context, index) {
              final character = state.characters[index];
              final isFavorite =
              context.watch<FavoritesCubit>().isFavorite(character.id);

              return CharacterCard(
                name: character.name,
                imageUrl: character.image,
                status: character.status,
                isFavorite: isFavorite,
                onToggleFavorite: () {
                  context.read<FavoritesCubit>().toggleFavorite(character);
                },
              );
            },
          );
        } else if (state is CharacterListError) {
          return Center(child: Text("Error: ${state.message}"));
        } else {
          return const Center(child: Text("No data"));
        }
      },
    );
  }
}
