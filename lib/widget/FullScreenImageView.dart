import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullScreenImageView extends StatelessWidget {
  final Future<List<String>> imageUrlsFuture; // Change to Future<List<String>> type
  final int initialIndex;

  FullScreenImageView({required this.imageUrlsFuture, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: imageUrlsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          final List<String> imageUrls = snapshot.data as List<String>;

          return Scaffold(
            body: Stack(
              children: [
                PhotoViewGallery.builder(
                  itemCount: imageUrls.length,
                  builder: (context, index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(imageUrls[index]),
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
      },
    );
  }
}
