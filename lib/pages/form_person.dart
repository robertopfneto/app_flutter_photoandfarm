import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/person_widgets/form_person_widget.dart';

class FormPersonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Pessoas'),
      ),
      body: PersonFormWidget(),
    );
  }
}
