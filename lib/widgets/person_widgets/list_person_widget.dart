import 'package:flutter/material.dart';

class ListPersonWidget extends StatelessWidget {
  final List<Map<String, dynamic>> persons;
  final Future<List<Map<String, dynamic>>> Function() fetchPersons;
  final Future<Map<String, dynamic>> Function(int) fetchFarmDetails;

  ListPersonWidget({
    Key? key,
    required this.persons,
    required this.fetchPersons,
    required this.fetchFarmDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: persons.length,
      itemBuilder: (context, index) {
        final person = persons[index];
        return ListTile(
          title: Text(
            person['name'],
            style: const TextStyle(fontSize: 16), // Reduzindo o tamanho da fonte
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CPF: ${person['cpf']}',
                style: const TextStyle(fontSize: 14), // Reduzindo o tamanho da fonte
              ),
              FutureBuilder<Map<String, dynamic>>(
                future: fetchFarmDetails(person['fk_farm']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Text(
                      'Erro ao carregar nome da fazenda',
                      style: TextStyle(fontSize: 14), // Reduzindo o tamanho da fonte
                    );
                  } else {
                    final farmDetails = snapshot.data!;
                    final farmName = farmDetails['name'];
                    return Text(
                      'Fazenda: $farmName',
                      style: TextStyle(fontSize: 14), // Reduzindo o tamanho da fonte
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
