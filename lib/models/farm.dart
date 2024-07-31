

class Farm{
  final int id;
  final String name;
  final String rua;
  final int numero;
  final String bairro;

  Farm({
    required this.id,
    required this.name,
    required this.rua,
    required this.numero,
    required this.bairro,

  });

 factory Farm.fromJson(Map<String, dynamic> json) {
    return Farm(
      id: json['id'],
      name: json['name'],
      rua: json['rua'],
      numero: json['numero'],
      bairro: json['bairro'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rua': rua,
      'numero': numero,
      'bairro': bairro,
    };
  }


  
}