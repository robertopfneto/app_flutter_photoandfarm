import 'package:flutter/material.dart';
import '../widgets/farm_widgets/form_farm_widget.dart';

class FormFarmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Fazenda'),
      ),
      body: FarmFormWidget(),
    );
  }
}
