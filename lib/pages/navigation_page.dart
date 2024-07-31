import 'package:flutter/material.dart';
import 'list_person.dart';
import 'list_farm.dart';
import 'form_farm.dart';
import 'form_person.dart';
import 'upload_image.dart';

class NavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navegação'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListFarm()),
              );
            },
            child: const Text('Lista de Fazendas'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListPerson()),
              );
            },
            child: const Text('Lista de Pessoas'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormFarmPage()),
              );
            },
            child: const Text('Formulário de Fazenda'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormPersonPage()),
              );
            },
            child: const Text('Formulário de Pessoa'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UploadImagePage()),
              );
            },
            child: const Text('Upload de Imagem'),
          ),
        ],
      ),
    );
  }
}
