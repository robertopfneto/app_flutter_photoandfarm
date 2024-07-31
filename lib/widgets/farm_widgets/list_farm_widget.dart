import 'package:flutter/material.dart';

import '../../models/farm.dart';

class ListFarmWidget extends StatelessWidget {
  final List<Farm> farms;

   const ListFarmWidget({Key? key, required this.farms}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: farms.length,
      itemBuilder: (context, index) {
        final farm = farms[index];
        return ListTile(
          title: Text(farm.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rua: ${farm.rua}'),
              Text('Numero: ${farm.numero}'),
              Text('Bairro: ${farm.bairro}'),
            ],
          ),
        );
      },
    );
  }
}

