import 'package:flutter/material.dart';

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
                      'assets/images/mejakittyai.png',
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
          const SizedBox(height: 8),
          Text(
            widget.summary, // Access shortDocs from the widget property
            style: const TextStyle(fontSize: 12),
            maxLines: isExpanded ? 10000 : 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
