import 'package:berbagi_catatan/widget/header.dart';
import 'detail_catatan.dart';
import 'package:flutter/material.dart';

class EditCatatanPage extends StatelessWidget {
  final String title;
  final String id;
  final String description;
  final List<ImageData> images;
  final List<String> tags;

  EditCatatanPage({
    required this.title,
    required this.id,
    required this.description,
    required this.images,
    required this.tags
  });

  @override
  Widget build(BuildContext context) {
    // Menggunakan TextEditingController untuk mengontrol nilai di TextField
    TextEditingController _descriptionController = TextEditingController(text: description);

    return Scaffold(
      appBar: CustomHeader(isHomePage: false,),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('ID: $id'),
              SizedBox(height: 20),
              // Textfield untuk description
              TextField(
                controller: _descriptionController, // Menggunakan controller
                maxLines: null, // Untuk mengizinkan lebih dari satu baris
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              // Tampilkan imageData jika diperlukan
            ],
          ),
        ),
      ),
    );
  }
}
