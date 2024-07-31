import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../models/urls.dart' as urls;
import '../../models/farm.dart';



class PersonFormWidget extends StatefulWidget {
  @override
  State<PersonFormWidget> createState() => _PersonFormWidgetState();
}

class _PersonFormWidgetState extends State<PersonFormWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  String? selectedFarm;
  bool showSpinner = false;
  List<Farm> farmList = [];

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
        List<dynamic> data = jsonDecode(response.body)['results'];
        List<Farm> fetchedFarms = data.map((json) => Farm.fromJson(json)).toList();

        setState(() {
          farmList = fetchedFarms;
        });
      } else {
        print('Erro ao carregar as fazendas: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar as fazendas: $e');
    }
  }

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

Future<void> createPerson() async {
  String create_person = urls.Uri().create_person;
  
  setState(() {
    showSpinner = true;
  });

  try {
    var selectedFarmId = farmList.firstWhere((farm) => farm.name == selectedFarm).id;

    var uri = Uri.parse(create_person);
    var response = await http.post(
      uri,
      body: jsonEncode({
        'name': nameController.text,
        'cpf': cpfController.text,
        'fk_farm': selectedFarmId, // Enviando o ID da fazenda
      }),
      headers: {'Content-Type': 'application/json'},
    );

    var responseBody = jsonDecode(response.body);
    print('Status Code: ${response.statusCode}');
    print('Response Body: $responseBody');

    if (response.statusCode == 201) {
      _showSuccessMessage('Pessoa criada com sucesso');
      nameController.clear();
      cpfController.clear();
      selectedFarm = null;
    } else {
      if (response.statusCode == 400 && responseBody['error'] == 'Pessoa com CPF já cadastrado') {
        _showErrorMessage('Pessoay cadastrada no banco');
      } else {
        _showErrorMessage('Erro ao criar pessoa: ${responseBody['error']}');
      }
    }
  } catch (e) {
    _showErrorMessage('Erro ao criar pessoa: $e');
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
          title: const Text('Cadastrar Pessoa'),
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
                  labelText: 'Nome da Pessoa',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: cpfController,
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedFarm,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedFarm = newValue;
                  });
                },
                items: farmList.map<DropdownMenuItem<String>>((farm) {
                  return DropdownMenuItem<String>(
                    value: farm.name, // Usando o nome da fazenda como valor
                    child: Text(farm.name),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Fazenda',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: createPerson,
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
