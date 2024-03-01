import 'package:berbagi_catatan/widget/header.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import header.dart di sini

class AddCatatanPage extends StatefulWidget {
  const AddCatatanPage({Key? key, required Map<String, dynamic>? loginData}) : super(key: key);

  @override
  _AddCatatanPageState createState() => _AddCatatanPageState();
}


class _AddCatatanPageState extends State<AddCatatanPage> {

  final List<File> _selectedImages = [];
  final picker = ImagePicker();
  final TextEditingController _tagController = TextEditingController();
  final List<String> _tags = [];

  Future<void> _selectImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
    }
  }

  void _deleteImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _moveImageLeft(int index) {
    if (index > 1) {
      setState(() {
        File temp = _selectedImages[index - 1];
        _selectedImages[index - 1] = _selectedImages[index - 2];
        _selectedImages[index - 2] = temp;
      });
    }
  }

  void _moveImageRight(int index) {
    if (index < _selectedImages.length) {
      setState(() {
        File temp = _selectedImages[index - 1];
        _selectedImages[index - 1] = _selectedImages[index];
        _selectedImages[index] = temp;
      });
    }
  }

  void _addTag(String tag) {
    setState(() {
      _tags.add(tag);
      _tagController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(isHomePage: false, isLoggedIn: false,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Judul Catatan
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Judul Catatan',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.only(left: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFFF3F4F6),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/news.png',
                          width: 17,
                          height: 17,
                        ),
                        const SizedBox(width: 16.0),
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Judul Catatan',
                              hintStyle: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF9CA3AF),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Gambar Catatan
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gambar Catatan',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 227,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return GestureDetector(
                            onTap: _selectImage,
                            child: Container(
                              width: 150,
                              height: 227,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0xFFF3F4F6),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  size: 40,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                            ),
                          );
                        }
                        return Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: 150,
                              height: 227,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0xFFF3F4F6),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _selectedImages[index - 1],
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (index > 1) // Tampilkan button "<" jika index gambar bukan yang pertama
                                    Center(
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 8, left: 16),
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: IconButton(
                                            icon: const Icon(Icons.arrow_back),
                                            onPressed: () => _moveImageLeft(index),
                                            iconSize: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  Expanded(
                                    child: Center(
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        height: 30,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF4343),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.white),
                                            onPressed: () => _deleteImage(index - 1),
                                            iconSize: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (index < _selectedImages.length) // Tampilkan button ">" jika index gambar bukan yang terakhir
                                    Center(
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 8, right: 16),
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: IconButton(
                                            icon: const Icon(Icons.arrow_forward),
                                            onPressed: () => _moveImageRight(index),
                                            iconSize: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Deskripsi Catatan
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Deskripsi Catatan',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Jelaskan isi catatan yang kamu berikan...',
                      hintStyle: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF9CA3AF),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Tags
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _tagController,
                    decoration: InputDecoration(
                      prefixIcon: Image.asset(
                        'assets/images/tag.png',
                        width: 17,
                        height: 17,
                      ),
                      hintText: 'Ketikkan Tags',
                      hintStyle: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF9CA3AF),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (tag) {
                      if (tag.isNotEmpty) {
                        _addTag(tag);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    children: _tags.map((tag) {
                      return Container(
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF31B057),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              tag,
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _tags.remove(tag);
                                });
                              },
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFFF5F5F5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFE2E2E2),
                      offset: Offset(0, 4),
                      blurRadius: 0,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: InkWell(
                  splashColor: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const SizedBox(
                    height: 45,
                    width: 80,
                    child: Center(
                      child: Text(
                        'Batal',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFF31B057),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF237D3E),
                      offset: Offset(0, 4),
                      blurRadius: 0,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: InkWell(
                  splashColor: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const SizedBox(
                    height: 45,
                    width: 150,
                    child: Center(
                      child: Text(
                        'Unggah Catatan',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}