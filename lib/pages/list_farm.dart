import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/widgets/farm_widgets/list_farm_widget.dart';

import '../models/farm.dart';
import '../models/urls.dart' as urls;

class ListFarm extends StatefulWidget {
  @override
  _ListFarmState createState() => _ListFarmState();
}

class _ListFarmState extends State<ListFarm> {
  List<Farm> farms = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFarms();
  }

  Future<void> fetchFarms() async {
    String list_farm = urls.Uri().list_farm;
    try {
      var response = await http.get(Uri.parse(list_farm));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        List<dynamic> data = jsonResponse['results']; // Accessing the 'results' key in JSON
        List<Farm> fetchedFarms = data.map((json) => Farm.fromJson(json)).toList();

        setState(() {
          farms = fetchedFarms;
          isLoading = false;
        });
      } else {
        print('Erro ao carregar as fazendas: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Erro ao carregar as fazendas: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Fazendas'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Mostra o indicador de carregamento enquanto está buscando os dados
          : farms.isEmpty
              ? Center(child: Text('Não há fazendas cadastradas')) // Mostra a mensagem quando não houver fazendas
              : ListFarmWidget(farms: farms), // Mostra a lista de fazendas se houver
    );
  }
}
