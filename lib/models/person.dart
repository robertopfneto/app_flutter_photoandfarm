import 'farm.dart';

class Person {
  final String id;
  final String name;
  final String cpf;
  final Farm farm;

  Person({
    required this.id,
    required this.name,
    required this.cpf,
    required this.farm
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
      cpf: json['cpf'],
      farm: Farm.fromJson(json['farm']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'farm': farm.toJson(),
    };
  }
}