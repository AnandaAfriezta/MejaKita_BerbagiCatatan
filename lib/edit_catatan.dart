import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:berbagi_catatan/widget/header.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'catatanData.dart';
import 'main.dart';

class EditCatatanPage extends StatefulWidget {
  final String title;
  final String id;
  final String description;
  final List<ImageData>? images;
  final List<String> tags;

  EditCatatanPage({
    required this.title,
    required this.id,
    required this.description,
    this.images,
    required this.tags,
  });

  @override
  _EditCatatanPageState createState() => _EditCatatanPageState();
}

class _EditCatatanPageState extends State<EditCatatanPage> {
  late TextEditingController _descriptionController;
  late List<int> orders;
  late TextEditingController _tagController;
  List<String> _tags = [];
  String? _deskripsiError;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.description);
    orders = List<int>.generate(widget.images!.length, (index) => index);
    _tagController = TextEditingController();
    _tags = List<String>.from(widget.tags);
  }

  void _moveImageLeft(int index) {
    if (index > 0) {
      setState(() {
        int tempOrder = orders[index];
        orders[index] = orders[index - 1];
        orders[index - 1] = tempOrder;

      });
    }
  }

  void _moveImageRight(int index) {
    if (index < widget.images!.length - 1) {
      setState(() {
        int tempOrder = orders[index];
        orders[index] = orders[index + 1];
        orders[index + 1] = tempOrder;

      });
    }
  }

  String _getTokenFromUserData(String userData) {
    // Parsing data login untuk mendapatkan nilai token
    Map<String, dynamic> data = json.decode(userData);
    String? token = data['data']['token'];
    return token ?? '';
  }

  void _updateCatatan(BuildContext context) async {
    setState(() {
      _deskripsiError = null;
    });

    String trimmedDescription = _descriptionController.text.trim();
    if (trimmedDescription.isEmpty) {
      setState(() {
        _deskripsiError = 'Deskripsi belum diisi';
      });
      return;
    }else if (trimmedDescription.length < 5){
      setState(() {
        _deskripsiError = 'Deskripsi harus memiliki setidaknya 5 karakter';
      });
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('userData');
    String token = _getTokenFromUserData(userData!);

    // URL endpoint untuk pembaruan catatan
    String apiUrl = 'https://service-catatan.mejakita.com/catatan/${widget.id}';

    // Konversi list of int (orders) menjadi string
    String ordersString = orders.map((order) => 'orders[]=$order').join('&');

    // Konversi tags menjadi string
    String tagsString = _tags.map((tag) => 'tags[]=$tag').join('&');

    // Data untuk dikirim dalam request PUT
    String requestBody = 'description=${Uri.encodeQueryComponent(_descriptionController.text)}&$ordersString&$tagsString';

    // Konfigurasi header dengan token Bearer
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token',
    };

    // Kirim request PUT ke API
    http.Response response = await http.put(
      Uri.parse(apiUrl),
      headers: headers,
      body: requestBody,
    );

    // Cek apakah request berhasil
    if (response.statusCode == 200) {

      // Pindah ke halaman MyApp
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()), // Sesuaikan dengan nama class MyApp Anda
      );
    } else {
      // Tampilkan popup
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Gagal Memperbarui Catatan'),
            content: const Text('Terjadi kesalahan saat memperbarui catatan. Silakan coba lagi.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  color: Colors.black
                ),),
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                },
              ),
            ],
          );
        },
      );
    }
  }



  void _addTag(String tag) {
    if (tag.isNotEmpty) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
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
            Text(
            widget.title,
            style: const TextStyle(
              fontSize: 24,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.bold,
            ),
          ),
              const SizedBox(height: 20,),
              const Text(
                'Ubah Urutan Catatan',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height: 227,
                child: ListView.builder(
                  key: UniqueKey(),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.images?.length,
                  itemBuilder: (BuildContext context, int index) {
                    final int imageIndex = orders[index];
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
                            child: Image.network(
                              widget.images![imageIndex].imageUrl ?? '',
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (index > 0)
                          Positioned(
                            bottom: 8,
                            left: 8,
                            child: IconButton(
                              onPressed: () => _moveImageLeft(index),
                              icon: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.arrow_back),
                              ),
                            ),
                          ),
                        if (index < widget.images!.length - 1)
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: IconButton(
                              onPressed: () => _moveImageRight(index),
                              icon: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.arrow_forward),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Ubah Deskripsi Catatan',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
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
              if (_deskripsiError != null && _deskripsiError!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                  child: Text(
                    _deskripsiError!,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.red,
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tags',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _tagController,
                    decoration: InputDecoration(
                      prefixIcon: Image.asset(
                        'assets/images/tag.png',
                        width: 17,
                        height: 17,
                      ),
                      hintText: 'Ketikkan Tags (enter untuk submit)',
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
                  onTap: () => _updateCatatan(context),
                  child: const SizedBox(
                    height: 45,
                    width: 150,
                    child: Center(
                      child: Text(
                        'Edit Catatan',
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

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
