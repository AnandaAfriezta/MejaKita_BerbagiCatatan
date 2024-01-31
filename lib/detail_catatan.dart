import 'package:flutter/material.dart';
import 'header.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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
  List<String> imageUrls = [
    'assets/images/img_1.png',
    'assets/images/img_2.png',
    'assets/images/img_3.png',
    'assets/images/img_3.png',
    'assets/images/img_3.png',
    'assets/images/img_3.png',
    'assets/images/img_3.png',
    'assets/images/img_3.png',
    'assets/images/img_3.png',
  ];

  int currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
                      aspectRatio: 1 / 1.41,
                      child: PageView.builder(
                        itemCount: imageUrls.length,
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _showFullScreenImage(context, index);
                            },
                            child: Hero(
                              tag: 'image-$index',
                              child: Image.asset(
                                imageUrls[index],
                                fit: BoxFit.cover,
                              ),
                            ),
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
                const Text(
                  'SISTEM PENCERNAAN MANUSIA - KELAS VIII',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                CollapsibleDescription(),
                const SizedBox(height: 10),
                AccountInfoWidget(),
                const SizedBox(height: 10),
                const Text(
                  'MATERI IPA ( BIOLOGI) SISTEM PENCERNAAN MANUSIA Kelas = 8 Semoga bermanfaat (0-0)',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Nunito',
                    color: Color(0xFFA1A1A1),
                  ),
                ),
                const SizedBox(height: 10),
                Tag(tags: ['#8 #IPA #pencernaan','IPA']),
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
  @override
  _CollapsibleDescriptionState createState() => _CollapsibleDescriptionState();
}

class _CollapsibleDescriptionState extends State<CollapsibleDescription> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16), // Add padding here
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
                    Text(
                      'Rangkuman by MejaKittyAI',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0096C7)),
                    ),
                    SizedBox(width: 8),
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
            'Berfungsi Mungunyah, menelan, mencerna makanan. Enzim petialit = Mengubah zat tepung ke glukosa. Berfungsi: Menghubungkan Fan mulut dengan lambung Membantu proses menelan makanan dan minuman.',
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
  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey,
          backgroundImage: AssetImage('assets/images/profile.png'),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dibagikan Oleh',
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFB5B9BF),
                  fontFamily: 'Nunito'
              ),
            ),
            Text(
              'adeliastudy',
              style: TextStyle(
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
  final List<String> imageUrls;

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
      indicatorPosition = widget.pageController.page!;
    });
  }

  @override
  Widget build(BuildContext context) {
    double indicatorWidth = 50.0;
    double padding = 5.0;

    return Container(
      height: 70.0,
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.itemCount,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: GestureDetector(
                  onTap: () {
                    widget.pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    width: indicatorWidth,
                    height: 70.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: index == widget.currentPage ? Colors.green : Colors.white,
                        width: 2.0,
                      ),
                      image: DecorationImage(
                        image: AssetImage(widget.imageUrls[index]),
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
  final List<String> imageUrls;
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
                imageProvider: AssetImage(imageUrls[index]),
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
