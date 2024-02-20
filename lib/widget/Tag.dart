import 'package:flutter/material.dart';

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
