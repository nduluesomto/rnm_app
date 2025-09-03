import 'package:flutter/material.dart';

class CharacterCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String status;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const CharacterCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.status,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
        title: Text(name),
        subtitle: Text(status),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.star : Icons.star_border,
            color: isFavorite ? Colors.amber : null,
          ),
          onPressed: onToggleFavorite,
        ),
      ),
    );
  }
}