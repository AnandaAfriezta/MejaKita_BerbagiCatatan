import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'widget/header.dart';
import 'edit_catatan.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'widget/CustomPageIndicator.dart';
import 'widget/CollapsibleDescription.dart';
import 'widget/AccountInfoWidget.dart';
import 'widget/Tag.dart';
import 'widget/FullScreenImageView.dart';
import 'catatanData.dart';
import 'api_constants.dart';

class DetailCatatanPage extends StatelessWidget {
  final String slug;
  final String? userToken;
  final String id;

  DetailCatatanPage({required this.slug,this.userToken, required this.id });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomHeader(isHomePage: false),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: DetailCatatanWidget(slug: slug, userToken: userToken, id: id),
        ),

      ),
    );
  }
}

class DetailCatatanWidget extends StatefulWidget {
  final String slug;
  final String? userToken;
  final String id;

  DetailCatatanWidget({required this.slug, this.userToken,required this.id});
  @override
  _DetailCatatanWidgetState createState() => _DetailCatatanWidgetState();
}

class _DetailCatatanWidgetState extends State<DetailCatatanWidget> {
  late Future<CatatanData> catatanDataFuture;
  int currentPage = 0;
  late PageController _pageController;
  bool? ownerShip;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPage, viewportFraction: 1.0);
    catatanDataFuture = fetchDataUrls();

  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Function to fetch data from the API
  Future<CatatanData> fetchDataUrls() async {
    final Uri apiUrl = Uri.parse('${ApiConstants.serviceCatatan}catatan/${widget.slug}');
    final headers = <String, String>{};
    // Tambahkan header Authorization jika userToken ada
    if (widget.userToken != null && widget.userToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer ${widget.userToken}';
    }

    final response = await http.get(apiUrl, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body)['data'];
      //final catatanData = CatatanData.fromJson(responseData['catatanData']);
      ownerShip = responseData['ownerShip'];
      return CatatanData.fromJson(responseData['catatanData']);
    } else {
      throw Exception('Failed to load Data');
    }
  }

  Future<void> _deleteCatatan() async {
    if (widget.userToken == null || widget.userToken!.isEmpty) {
      // Token tidak tersedia, tampilkan pesan ke pengguna
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User token is missing'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Menampilkan dialog konfirmasi
    bool deleteConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          titleTextStyle: const TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20
          ),
          content: const Text('Apakah Anda yakin ingin menghapus catatan ini?'),
          contentTextStyle: const TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontSize: 14
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Tombol "Batal"
                Navigator.of(context).pop(false);
              },
              child: const Text(
                'Batal',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                    fontSize: 16), // Warna teks "Batal"
              ),
            ),
            TextButton(
              onPressed: () {
                // Tombol "Hapus"
                Navigator.of(context).pop(true);
              },
              child: const Text(
                'Hapus',
                style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                    fontSize: 16), // Warna teks "Hapus"
              ),
            ),
          ],
        );
      },
    );

    if (!deleteConfirmed) {
      // Pengguna membatalkan penghapusan
      return;
    }

    final Uri apiUrl = Uri.parse('${ApiConstants.serviceCatatan}catatan/${widget.id}');
    final headers = <String, String>{'Authorization': 'Bearer ${widget.userToken}'};

    final response = await http.delete(apiUrl, headers: headers);

    if (response.statusCode == 200) {
      // Handle success, misalnya kembali ke halaman sebelumnya
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyApp(), // Gantilah dengan widget MyApp yang sesuai
        ),
      );

    } else {
      // Handle error, misalnya tampilkan snackbar dengan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete catatan',
              style: TextStyle(
              color: Colors.white,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.bold,
              fontSize: 16),),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: catatanDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Menampilkan widget loading ketika data masih diambil
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF31B057),
            ),
          );
        } else if (snapshot.hasError) {
          // Menampilkan pesan kesalahan jika terjadi kesalahan dalam pengambilan data
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          // Data sudah diambil, tampilkan konten utama
          final CatatanData? catatanData = snapshot.data as CatatanData?;
          if (catatanData == null) {
            // Jika catatanData null, tampilkan placeholder atau pesan kesalahan sesuai kebutuhan
            return const Center(
              child: Text('Data is null'),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              int itemCount = max(1, catatanData.images.length);
              double screenWidth = MediaQuery.of(context).size.width;
              double aspectRatio = screenWidth > 640 ?  1.41 / 1 : 1 / 1.41;

              if (screenWidth > 640 && catatanData.images.length > 1) {
                itemCount -= 1;
              }

              int visibleImages = min(catatanData.images.length, screenWidth > 640 ? 2 : 1);

              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: aspectRatio,
                            child: PageView.builder(
                              itemCount: itemCount,
                              controller: _pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  currentPage = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    for (int i = 0; i < visibleImages; i++)
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            _showFullScreenImage(context, index + i);
                                          },
                                          child: Hero(
                                            tag: 'image-${index + i}',
                                            child: buildImageWithFallback(
                                              catatanData.images[index + i].imageUrl,
                                              catatanData.images[index + i].imagePreview,
                                              itemCount,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      CustomPageIndicator(
                        itemCount: catatanData.images.where((image) => image.imageUrl != null).length,
                        currentPage: currentPage,
                        pageController: _pageController,
                        imageUrls: catatanData.images
                            .where((image) => image.imageUrl != null) // Filter yang memiliki imageUrl yang valid
                            .map((image) => image.imageUrl!) // Ambil imageUrl yang valid dan ubah menjadi String non-nullable
                            .toList(),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        catatanData.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Visibility(
                        visible: ownerShip == true, // Check if ownerShip is a boolean true
                        child: Row(

                          children: [
                            const SizedBox(height: 10),
                            // Edit button
                            InkWell(
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => EditCatatanPage(
                                        id: widget.id,
                                        title: catatanData.title,
                                        description: catatanData.description,
                                        images: catatanData.images,
                                        tags: catatanData.tag,
                                      )),
                                    );
                                  },
                                  child: const SizedBox(
                                    height: 40,
                                    width: 100, // Adjust the height and width as needed
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align to start and end
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(12, 0, 8, 0),
                                          child: Icon(
                                            Icons.edit,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Edit',
                                          style: TextStyle(
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10), // Add some spacing between buttons
                            // Delete button
                            InkWell(
                              child: Ink(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: const Color(0xFFFF4343),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0xFFBC3434),
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
                                    _deleteCatatan();
                                    // Handle edit button click
                                  },
                                  child: const SizedBox(
                                    height: 40,
                                    width: 120, // Adjust the height and width as needed
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align to start and end
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(12, 0, 8, 0),
                                          child: Icon(
                                            Icons.archive,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Delete',
                                          style: TextStyle(
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10)
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Visibility(
                        visible: catatanData.summary.isNotEmpty,
                        child: CollapsibleDescription(summary: catatanData.summary ?? ''),
                      ),
                      const SizedBox(height: 10),
                      AccountInfoWidget(ownerName: catatanData.owner.name, avatarUrl: catatanData.owner.photoUrl),
                      const SizedBox(height: 10),
                      Text(
                        catatanData.description,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Nunito',
                          color: Color(0xFFA1A1A1),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Tag(tags: catatanData.tag),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  void _showFullScreenImage(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageView(
          imageUrlsFuture: catatanDataFuture.then((data) => data.images
              .where((image) => image.imageUrl != null) // Filter yang memiliki imageUrl yang valid
              .map((image) => image.imageUrl!) // Ambil imageUrl yang valid dan ubah menjadi String non-nullable
              .toList()),
          initialIndex: index,
        ),
      ),
    );
  }


  Widget buildImageWithFallback(String? imageUrl, String? imagePreview, int itemCount) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSingleItem = itemCount == 1;

    if (imageUrl != null && imageUrl.isNotEmpty && imagePreview != null && imagePreview.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) {
          return Image.memory(
            base64Decode(imagePreview),
            fit: BoxFit.fitHeight,
            width: isSingleItem ? screenWidth : null,
            height: isSingleItem ? screenWidth / 1.41 : null,
          );
        },
        errorWidget: (context, url, error) {

          return Container(
            color: Colors.grey[300],
            width: isSingleItem ? screenWidth : null,
            height: isSingleItem ? screenWidth / 1.41 : null,
          );
        },
        fit: BoxFit.fitHeight,
        width: isSingleItem ? screenWidth : null,
      );
    } else {
      return Container(
        color: Colors.grey[300],
        width: isSingleItem ? screenWidth : null,
        height: isSingleItem ? screenWidth / 1.41 : null,
      );
    }
  }
}
