import 'package:flutter/material.dart';

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

    // Adjust itemCount to match the number of images displayed
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
                    // If clicking the last image indicator, move to the last page without animation
                    if (isLastImage) {
                      widget.pageController.jumpToPage(adjustedItemCount - 1);
                    } else {
                      // If clicking other indicators, animate as usual
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
