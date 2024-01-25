import 'package:flutter/material.dart';

class AddCatatanPage extends StatelessWidget {
  const AddCatatanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Catatan'),
      ),
      body: const Center(
        child: Text('Halaman Tambah Catatan'),
      ),
    );
  }
}
