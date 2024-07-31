import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/widgets/person_widgets/list_person_widget.dart';
import '../models/urls.dart' as urls;

class ListPerson extends StatefulWidget {
  @override
  _ListPersonState createState() => _ListPersonState();
}

class _ListPersonState extends State<ListPerson> {
  late Future<List<Map<String, dynamic>>> futurePersons;

  @override
  void initState() {
    super.initState();
    futurePersons = fetchPersons();
  }

  Future<List<Map<String, dynamic>>> fetchPersons() async {
    String list_person = urls.Uri().list_person;
    try {
      var response = await http.get(Uri.parse(list_person));
      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        if (data['results'] is List) {
          return List<Map<String, dynamic>>.from(data['results']);
        } else {
          print('Erro: Os dados retornados não são uma lista');
          return [];
        }
      } else {
        print('Erro ao carregar as pessoas: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erro ao carregar as pessoas: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchFarmDetails(int farmId) async {
    String farm_detail = urls.Uri().list_farm;
    try {
      var response = await http.get(Uri.parse('$farm_detail$farmId'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Erro ao carregar os detalhes da fazenda: ${response.statusCode}');
        return {'name': 'Fazenda não encontrada'};
      }
    } catch (e) {
      print('Erro ao carregar os detalhes da fazenda: $e');
      return {'name': 'Erro ao carregar os detalhes da fazenda'};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Pessoas'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futurePersons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os dados'));
          } else {
            if (snapshot.data!.isEmpty) {
              return Center(child: Text('Não há pessoas cadastradas'));
            } else {
              return ListPersonWidget(
                persons: snapshot.data!,
                fetchPersons: fetchPersons,
                fetchFarmDetails: fetchFarmDetails,
              );
            }
          }
        },
      ),
    );
  }
}
