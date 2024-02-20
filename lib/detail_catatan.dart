import 'dart:math';

import 'package:flutter/material.dart';
import 'widget/header.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'widget/CustomPageIndicator.dart';
import 'widget/CollapsibleDescription.dart';
import 'widget/AccountInfoWidget.dart';
import 'widget/Tag.dart';
import 'widget/FullScreenImageView.dart';

class DetailCatatanPage extends StatelessWidget {
  final String slug;

  DetailCatatanPage({required this.slug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(isHomePage: false),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: DetailCatatanWidget(slug: slug),
      ),
    );
  }
}

class DetailCatatanWidget extends StatefulWidget {
  final String slug;

  DetailCatatanWidget({required this.slug});
  @override
  _DetailCatatanWidgetState createState() => _DetailCatatanWidgetState();
}

class _DetailCatatanWidgetState extends State<DetailCatatanWidget> {
  late Future<CatatanData> catatanDataFuture;
  int currentPage = 0;
  late PageController _pageController;

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
    final Uri apiUrl = Uri.parse('https://service-catatan.mejakita.com/catatan/${widget.slug}');

    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body)['data'];
      return CatatanData.fromJson(responseData['catatanData']);
    } else {
      throw Exception('Failed to load Data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: catatanDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Menampilkan widget loading ketika data masih diambil
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          );
        } else if (snapshot.hasError) {
          // Menampilkan pesan kesalahan jika terjadi kesalahan dalam pengambilan data
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          // Data sudah diambil, tampilkan konten utama
          final CatatanData catatanData = snapshot.data as CatatanData;
          print('Number of images: ${catatanData.images.length}');

          return LayoutBuilder(
            builder: (context, constraints) {
              int itemCount = max(1, catatanData.images.length);
              double screenWidth = MediaQuery.of(context).size.width;
              double aspectRatio = screenWidth > 640 ?  1.41 / 1 : 1 / 1.41;

              if (screenWidth > 640 && catatanData.images.length > 1) {
                itemCount -= 1;
              }

              int visibleImages = min(catatanData.images.length, screenWidth > 640 ? 2 : 1);
              print('ScreenWidth: $screenWidth, VisibleImages: $visibleImages');
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
                        itemCount: catatanData.images.length,
                        currentPage: currentPage,
                        pageController: _pageController,
                        imageUrls: catatanData.images.map((image) => image.imageUrl).toList(),
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
                      const SizedBox(height: 10),
                      CollapsibleDescription(summary: catatanData.summary),
                      const SizedBox(height: 10),
                      AccountInfoWidget(ownerName: catatanData.owner.name, avatarUrl: catatanData.owner.photoUrl),
                      const SizedBox(height: 10),
                      Text(
                        catatanData.description,
                        style: TextStyle(
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
          imageUrlsFuture: catatanDataFuture.then((data) => data.images.map((image) => image.imageUrl).toList()),
          initialIndex: index,
        ),
      ),
    );
  }

  Widget buildImageWithFallback(String imageUrl, String fallbackUrl) {
    print('Building image: $imageUrl');
    double screenWidth = MediaQuery.of(context).size.width;

    return Image.network(
      imageUrl,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
            ),
          );
        }
      },
      errorBuilder: (context, error, stackTrace) {
        print('Error loading image, falling back to: $fallbackUrl');
        return Image.network(
          fallbackUrl,
          fit: BoxFit.cover,
          width: screenWidth > 640 ? screenWidth / 2 : null,
          height: screenWidth > 640 ? null : screenWidth / 1.41,
        );
      },
    );
  }
}

class CatatanData {
  late String title;
  late String summary;
  late String description;
  late Owner owner;
  late List<ImageData> images;
  late List<String> tag;

  CatatanData({
    required this.title,
    required this.summary,
    required this.description,
    required this.owner,
    required this.images,
    required this.tag,
  });

  CatatanData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    summary = json['summary'];
    description = json['description'];
    owner = Owner.fromJson(json['owner']);
    images = List<ImageData>.from(json['images'].map((item) => ImageData.fromJson(item)));
    tag = List<String>.from(json['tag']);
  }
}

class Owner {
  late String name;
  late String photoUrl;

  Owner({required this.name, required this.photoUrl});

  Owner.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    photoUrl = json['photo_url'];
  }
}

class ImageData {
  late String imageUrl;
  late String imagePreview;

  ImageData({required this.imageUrl, required this.imagePreview});

  ImageData.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
    imagePreview = json['image_preview'];
  }
}