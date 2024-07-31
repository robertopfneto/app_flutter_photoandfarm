import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../models/farm.dart';
import '../../models/urls.dart' as url;

class Url {
  static String listPerson = url.Uri().list_person;
  static String listFarm = url.Uri().list_farm;
  static String createPerson = url.Uri().create_person;
  static String createFarm = url.Uri().create_farm;
  static String uploadPhoto = url.Uri().upload_photo;
}

class ImageUploadWidget extends StatefulWidget {
  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  File? picture;
  final _picker = ImagePicker();
  bool showSpinner = false;
  String? selectedFarm;
  String? selectedPerson;
  TextEditingController photoNameController = TextEditingController();
  List<Farm> farmList = [];
  List<String> personList = [];
  int? selectedPersonId;

  @override
  void initState() {
    super.initState();
    fetchFarms();
    fetchPersons().then((names) {
      setState(() {
        personList = names;
      });
    });
  }

  Future<void> fetchPersonId(String name) async {
    try {
      var response = await http.get(Uri.parse('${Url.listPerson}?name=$name'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['results'];
        if (data.isNotEmpty) {
          var personId = data[0]['id'] as int;
          // Atribui o ID da pessoa selecionada como chave estrangeira
          selectedPersonId = personId;
        }
      } else {
        print('Erro ao buscar ID da pessoa: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar ID da pessoa: $e');
    }
  }

  Future<void> fetchFarms() async {
    try {
      var response = await http.get(Uri.parse(Url.listFarm));
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

  Future<List<String>> fetchPersons() async {
    List<String> personNames = [];
    try {
      var response = await http.get(Uri.parse(Url.listPerson));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['results'];
        for (var personData in data) {
          personNames.add(personData['name'] as String);
        }
      } else {
        print('Erro ao carregar as pessoas: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar as pessoas: $e');
    }
    return personNames;
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

  Future<void> uploadImage(File imageFile) async {
    setState(() {
      showSpinner = true;
    });

    try {
      var selectedFarmId = farmList.firstWhere((farm) => farm.name == selectedFarm).id;

      // Busca o ID da pessoa selecionada
      if (selectedPerson != null) {
        await fetchPersonId(selectedPerson!);
      }

      var uri = Uri.parse(Url.uploadPhoto);
      var request = http.MultipartRequest('POST', uri)
        ..fields['name'] = photoNameController.text
        ..fields['created_at'] = DateTime.now().toIso8601String()
        ..fields['fk_farm'] = selectedFarmId.toString()
        // Adiciona o ID da pessoa selecionada
        ..fields['fk_person'] = selectedPersonId.toString();

      // Adiciona a imagem ao corpo da solicitação
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print('Status Code: ${response.statusCode}');
      print('Response Body: $responseBody');

      if (response.statusCode == 201) {
        _showSuccessMessage('Imagem enviada com sucesso');
      } else {
        _showErrorMessage('Erro ao enviar imagem: $responseBody');
      }
    } catch (e) {
      _showErrorMessage('Erro ao enviar imagem: $e');
    }

    setState(() {
      showSpinner = false;
    });
  }

  Future<void> getImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        picture = File(pickedFile.path);
      });
    } else {
      print('Nenhuma imagem selecionada');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upload de Imagem'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: getImage,
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[300],
                  child: picture == null
                      ? const Center(child: Text('Selecione uma imagem'))
                      : Image.file(
                          picture!,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
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
                    value: farm.name,
                    child: Text(farm.name),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Fazenda',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedPerson,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPerson = newValue;
                  });
                },
                items: personList.map<DropdownMenuItem<String>>((personName) {
                  return DropdownMenuItem<String>(
                    value: personName,
                    child: Text(personName),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Pessoa',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: photoNameController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Foto',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (picture != null &&
                      selectedFarm != null &&
                      selectedPerson != null &&
                      photoNameController.text.isNotEmpty) {
                    uploadImage(picture!);
                  } else {
                    _showErrorMessage('Por favor, preencha todos os campos');
                  }
                },
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
