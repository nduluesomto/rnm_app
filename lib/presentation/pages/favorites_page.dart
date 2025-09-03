import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rnm_app/presentation/cubits/favorities_cubit.dart';
import '../widgets/character_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        if (state.favorites.isEmpty) {
          return const Center(child: Text("No favorites yet"));
        }

        return ListView.builder(
          itemCount: state.favorites.length,
          itemBuilder: (context, index) {
            final character = state.favorites[index];
            return CharacterCard(
              name: character.name,
              imageUrl: character.image,
              status: character.status,
              isFavorite: true,
              onToggleFavorite: () {
                context.read<FavoritesCubit>().toggleFavorite(character);
              },
            );
          },
        );
      },
    );
  }
}