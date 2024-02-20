import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'widget/header.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'dart:math';

class AddCatatanPage extends StatefulWidget {
  const AddCatatanPage({Key? key}) : super(key: key);

  @override
  _AddCatatanPageState createState() => _AddCatatanPageState();
}

class _AddCatatanPageState extends State<AddCatatanPage> {
  final List<File> _selectedImages = [];
  int _currentPage = 0;
  PageController _pageController = PageController();

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(isHomePage: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                  ElevatedButton(
                    onPressed: _selectImage,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFFF3F4F6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload_file,
                          color: Color(0xFF9CA3AF),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Pilih File',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_selectedImages.isNotEmpty)
                    Column(
                      children: [
                        SizedBox(
                          height: 300, // Adjust the height as needed
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: _selectedImages.length,
                            onPageChanged: (int page) {
                              setState(() {
                                _currentPage = page;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  Center(
                                    child: ImageContainer(imageFile: _selectedImages[_currentPage]),
                                  ),
                                  // Button Back ("<")
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: IconButton(
                                      icon: const Icon(Icons.arrow_back),
                                      onPressed: () {
                                        if (_currentPage > 0) {
                                          setState(() {
                                            _selectedImages.insert(
                                              _currentPage - 1,
                                              _selectedImages.removeAt(_currentPage),
                                            );
                                            _currentPage--;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  // Button Delete
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          _selectedImages.removeAt(_currentPage);
                                          _pageController = PageController(initialPage: 0);
                                          if (_currentPage > 0) {
                                            _currentPage--;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  // Button Front (">")
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: IconButton(
                                      icon: const Icon(Icons.arrow_forward),
                                      onPressed: () {
                                        if (_currentPage < _selectedImages.length - 1) {
                                          setState(() {
                                            _selectedImages.insert(
                                              _currentPage + 1,
                                              _selectedImages.removeAt(_currentPage),
                                            );
                                            _currentPage++;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        DotsIndicator(
                          dotsCount: _selectedImages.length,
                          position: _currentPage.toDouble(),
                          decorator: DotsDecorator(
                            size: const Size.square(8.0),
                            activeSize: const Size(20.0, 8.0),
                            activeShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 16),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
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
                  ),
                  const SizedBox(height: 8),
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

// Widget untuk menampilkan gambar dalam wadah dengan frame
class ImageContainer extends StatelessWidget {
  final File imageFile;
  final double width;
  final double height;

  const ImageContainer({
    Key? key,
    required this.imageFile,
    this.width = 160,
    this.height = 227,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200], // Warna latar belakang frame
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Transform.rotate(
          angle: -90 * (pi / 180), // Rotate gambar jika perlu
          child: Image.file(
            imageFile,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
