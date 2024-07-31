
import 'farm.dart';
import 'person.dart';

class Photo {
  final int id;
  final String name;
  final String createdAt;
  final String imageUrl; // Caminho da imagem
  final Person person;
  final Farm farm;

  Photo({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.imageUrl,
    required this.person,
    required this.farm,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      imageUrl: json['image'], // Supondo que a API forneça o caminho da imagem
      person: Person.fromJson(json['person']),
      farm: Farm.fromJson(json['farm']),
    );
  }
}
