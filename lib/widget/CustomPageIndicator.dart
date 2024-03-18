import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomPageIndicator extends StatefulWidget {
  final int itemCount;
  final int currentPage;
  final PageController pageController;
  final List<String>? imageUrls; // Pass imageUrls as a parameter

  CustomPageIndicator({
    required this.itemCount,
    required this.currentPage,
    required this.pageController,
    this.imageUrls,
  });

  @override
  _CustomPageIndicatorState createState() => _CustomPageIndicatorState();
}

class _CustomPageIndicatorState extends State<CustomPageIndicator> {
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
    // No need to update the state here
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
          child: widget.imageUrls != null && widget.imageUrls!.isNotEmpty
              ? ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.itemCount,
            itemBuilder: (context, index) {
              String? imageUrl = widget.imageUrls![index];
              bool isCurrentPage = index == widget.currentPage;
              print(imageUrl);

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
                        color: isCurrentPage ? Colors.green : Colors.white,
                        width: 2.0,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl!,
                        placeholder: (context, url) => _buildPlaceholder(),
                        errorWidget: (context, url, error) => _buildErrorWidget(),
                        width: indicatorWidth - 4.0,
                        height: 66.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          )
              : _buildPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    // You can customize this placeholder widget
    return Container(
      color: Colors.grey[300],
      width: 50.0, // Sesuaikan dengan lebar indikator
      height: 70.0,
    );
  }

  Widget _buildErrorWidget() {
    // You can customize this error widget
    return Container(
      color: Colors.grey,
      width: 50.0, // Sesuaikan dengan lebar indikator
      height: 70.0,
    );
  }
}
