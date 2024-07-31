import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/login_page_widget.dart';
// Importa a página de login

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'My App',
      home: LoginPage(), // Usa a página de login
    );
  }
}