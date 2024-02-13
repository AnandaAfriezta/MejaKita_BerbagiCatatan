import 'package:flutter/material.dart';
import 'header.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailCatatanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(isHomePage: false),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: YourContentWidget(),
      ),
    );
  }
}

class YourContentWidget extends StatefulWidget {
  @override
  _YourContentWidgetState createState() => _YourContentWidgetState();
}

class _YourContentWidgetState extends State<YourContentWidget> {
  List<String> imageUrls = [];
  String catatanTitle = '';
  String summary = '';
  String ownerName = '';
  String Description = '';
  List<String> tag = [];
  String avatarUrl = '';


  int currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPage, viewportFraction: 1.0);
    fetchDataUrls(); // Fetch image URLs when the widget is initialized
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Function to fetch image URLs from the API
  Future<void> fetchDataUrls() async {
    final Uri apiUrl = Uri.parse('https://service-catatan.mejakita.com/catatan/fastabiqul-khairat');

    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> catatanData = json.decode(response.body)['data']['catatanData'];
      setState(() {
        // Extract 'image_url' from each item in the 'images' list
        imageUrls = List<String>.from(catatanData['images'].map((item) => item['image_url']));
        catatanTitle = catatanData['title'];
        summary = catatanData['summary'];
        ownerName = catatanData['owner']['name'];
        Description = catatanData['description'];
        tag = List<String>.from(catatanData['tag']);
        avatarUrl = catatanData['owner']['photo_url'];
      });
    } else {
      throw Exception('Failed to load Data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = MediaQuery.of(context).size.width;
        double aspectRatio = screenWidth > 640 ? 1.41 / 1 : 1 / 1.41;

        int visibleImages = screenWidth > 640 ? 2 : 1; // Menentukan jumlah gambar yang terlihat

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
                        itemCount: screenWidth > 640 ? imageUrls.length - 1 : imageUrls.length,
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
                                        child: Image.network(
                                          imageUrls[index + i], // Use Image.network for remote images
                                          fit: BoxFit.cover,
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
                  itemCount: imageUrls.length,
                  currentPage: currentPage,
                  pageController: _pageController,
                  imageUrls: imageUrls,
                ),
                const SizedBox(height: 10),
                Text(
                  catatanTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                CollapsibleDescription(summary: summary,),
                const SizedBox(height: 10),
                AccountInfoWidget(ownerName: ownerName, avatarUrl: avatarUrl,),
                const SizedBox(height: 10),
                Text(
                  Description,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Nunito',
                    color: Color(0xFFA1A1A1),
                  ),
                ),
                const SizedBox(height: 10),
                Tag(tags: tag),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFullScreenImage(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageView(
          imageUrls: imageUrls,
          initialIndex: index,
        ),
      ),
    );
  }
}


class CollapsibleDescription extends StatefulWidget {
  final String summary;

  CollapsibleDescription({required this.summary});

  @override
  _CollapsibleDescriptionState createState() => _CollapsibleDescriptionState();
}

class _CollapsibleDescriptionState extends State<CollapsibleDescription> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Rangkuman by MejaKittyAI',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0096C7)),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      'assets/images/img_5.png',
                      width: 16,
                      height: 16,
                    ),
                  ],
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.summary, // Access shortDocs from the widget property
            style: TextStyle(fontSize: 12),
            maxLines: isExpanded ? 10000 : 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class AccountInfoWidget extends StatelessWidget {
  final String ownerName;
  final String avatarUrl;

  const AccountInfoWidget({super.key, required this.ownerName, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey,
          backgroundImage: NetworkImage(avatarUrl),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dibagikan Oleh',
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFB5B9BF),
                  fontFamily: 'Nunito'
              ),
            ),
            Text(
              ownerName,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 40)
      ],
    );
  }
}

class CustomPageIndicator extends StatefulWidget {
  final int itemCount;
  final int currentPage;
  final PageController pageController;
  final List<String> imageUrls; // Pass imageUrls as a parameter

  CustomPageIndicator({
    required this.itemCount,
    required this.currentPage,
    required this.pageController,
    required this.imageUrls,
  });

  @override
  _CustomPageIndicatorState createState() => _CustomPageIndicatorState();
}

class _CustomPageIndicatorState extends State<CustomPageIndicator> {
  double indicatorPosition = 0.0;

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(_updateIndicatorPosition);
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_updateIndicatorPosition);
    super.dispose();
  }

  void _updateIndicatorPosition() {
    setState(() {
      indicatorPosition = widget.pageController.page!.clamp(0.0, widget.itemCount - 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    double indicatorWidth = 50.0;
    double padding = 5.0;

    // Sesuaikan itemCount agar sesuai dengan jumlah gambar yang ditampilkan
    int adjustedItemCount = widget.itemCount;

    return Container(
      height: 70.0,
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: adjustedItemCount,
            itemBuilder: (context, index) {
              bool isLastImage = index == adjustedItemCount;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: GestureDetector(
                  onTap: () {
                    // Jika mengklik indicator gambar terakhir, pindahkan ke halaman terakhir tanpa animasi
                    if (isLastImage) {
                      widget.pageController.jumpToPage(adjustedItemCount - 1);
                    } else {
                      // Jika mengklik indicator lainnya, animasikan seperti biasa
                      widget.pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Container(
                    width: indicatorWidth,
                    height: 70.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: (indicatorPosition - (isLastImage ? adjustedItemCount - 1.0 : index)).abs() < 0.5
                            ? Colors.green
                            : Colors.white,
                        width: 2.0,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(widget.imageUrls[index]), // Use NetworkImage for API images
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class FullScreenImageView extends StatelessWidget {
  final List<String> imageUrls; // Pass imageUrls as a parameter
  final int initialIndex;

  FullScreenImageView({required this.imageUrls, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: imageUrls.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(imageUrls[index]), // Use NetworkImage for API images
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
            pageController: PageController(initialPage: initialIndex),
          ),
          Positioned(
            top: 40.0,
            left: 10.0,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.5),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Tag extends StatelessWidget {
  final List<String> tags;

  Tag({required this.tags});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: tags
          .map((tag) => Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF3A735A).withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          tag,
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'Nunito',
            color: Color(0xFF3A735A),
          ),
        ),
      ))
          .toList(),
    );
  }
}
