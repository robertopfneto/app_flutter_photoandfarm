import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../models/urls.dart' as urls;

class FarmFormWidget extends StatefulWidget {
  @override
  State<FarmFormWidget> createState() => _FarmFormWidgetState();
}

class _FarmFormWidgetState extends State<FarmFormWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ruaController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  bool showSpinner = false;

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> createFarm() async {

    String create_farm = urls.Uri().create_farm;

    setState(() {
      showSpinner = true;
    });

    try {
      var uri = Uri.parse(create_farm);
      var response = await http.post(
        uri,
        body: jsonEncode({
          'name': nameController.text,
          'rua': ruaController.text,
          'numero': numeroController.text,
          'bairro': bairroController.text,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      var responseBody = response.body;
      log('Status Code: ${response.statusCode}');
      log('Response Body: $responseBody');

      if (response.statusCode == 201) {
        _showSuccessMessage('Fazenda criada com sucesso');
        nameController.clear();
        ruaController.clear();
        numeroController.clear();
        bairroController.clear();
      } else {
        _showErrorMessage('Erro ao criar fazenda:' );
      }
    } catch (e) {
      _showErrorMessage('Erro ao criar fazenda: $e');
    }

    setState(() {
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cadastrar Fazenda'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Fazenda',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: ruaController,
                decoration: const InputDecoration(
                  labelText: 'Rua da Fazenda',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: numeroController,
                keyboardType: TextInputType.number, // Define o teclado para números
                inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Permite apenas dígitos
                decoration: const InputDecoration(
                  labelText: 'Numero da Fazenda',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: bairroController,
                decoration: const InputDecoration(
                  labelText: 'Bairro da Fazenda',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: createFarm,
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
