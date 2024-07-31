import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/photo_widgets/image_upload_widget.dart'; // Importe o widget ImageUploadWidget

class UploadImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload de Imagem'),
      ),
      body: Center(
        child: ImageUploadWidget(),
      ),
    );
  }
}
