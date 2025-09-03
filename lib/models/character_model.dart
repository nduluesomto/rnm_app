import 'package:hive/hive.dart';

part 'character_model.g.dart';

@HiveType(typeId: 0)
class Character extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final String status;

  Character({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      status: json['status'],
    );
  }
}




// class Character {
//   final int id;
//   final String name;
//   final String status; // Alive / Dead / unknown
//   final String species;
//   final String image;
//   final String origin;
//   final String location;
//
//
//   Character({
//     required this.id,
//     required this.name,
//     required this.status,
//     required this.species,
//     required this.image,
//     required this.origin,
//     required this.location,
//   });
//
//
//   factory Character.fromJson(Map<String, dynamic> json) => Character(
//     id: json['id'] as int,
//     name: json['name'] as String,
//     status: json['status'] as String? ?? 'unknown',
//     species: json['species'] as String? ?? 'unknown',
//     image: json['image'] as String? ?? '',
//     origin: (json['origin']?['name'] as String?) ?? 'unknown',
//     location: (json['location']?['name'] as String?) ?? 'unknown',
//   );
//
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'name': name,
//     'status': status,
//     'species': species,
//     'image': image,
//     'origin': {'name': origin},
//     'location': {'name': location},
//   };
// }