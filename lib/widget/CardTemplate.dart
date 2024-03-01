import 'dart:convert';
import 'package:flutter/material.dart';
import '../detail_catatan.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CardTemplate extends StatelessWidget {
  final Map<String, dynamic> catatanData;
  final double cardHeight;

  CardTemplate({
    Key? key,
    required this.catatanData,
    this.cardHeight = 185.0, // Default card height, adjust as needed
  }) : super(key: key);

  String calculateTimeDifference(String createdAt) {
    DateTime createdDateTime = DateTime.parse(createdAt);
    DateTime now = DateTime.now();
    Duration difference = now.difference(createdDateTime);

    if (difference.inDays > 365) {
      int years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'tahun' : 'tahun'} yang lalu';
    } else if (difference.inDays >= 30) {
      int months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'bulan' : 'bulan'} yang lalu';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} ${difference.inDays == 1
          ? 'hari'
          : 'hari'} yang lalu';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} ${difference.inHours == 1
          ? 'jam'
          : 'jam'} yang lalu';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} ${difference.inMinutes == 1
          ? 'menit'
          : 'menit'} yang lalu';
    } else {
      return 'Baru saja';
    }
  }

  Future<bool> isImageUrlLoaded(String imageUrl) async {
    try {
      bool success = await CachedNetworkImageProvider(imageUrl).evict();
      return success;
    } catch (error) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isImageUrlLoaded(catatanData['thumbnail']['image_url'] ?? ''),
      builder: (context, snapshot) {

        return SizedBox(
          height: cardHeight,
          child: Card(
            color: Colors.white,
            elevation: 0,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailCatatanPage(slug: catatanData['slug']),
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    width: 115,
                    height: cardHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        // Display image_preview
                    ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          base64.decode(catatanData['thumbnail']['image_preview']),
                          fit: BoxFit.cover,
                          width: 125,
                          height: cardHeight,
                        ),
                    ),
                        // Display image_url on top, hide it initially
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                       child: CachedNetworkImage(
                          imageUrl: catatanData['thumbnail']['image_url'],
                          placeholder: (context, url) => Container(),
                          errorWidget: (context, url, error) => Container(),
                          fit: BoxFit.cover,
                          width: 125,
                          height: cardHeight,
                        ),
                      ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          catatanData['title'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          catatanData['owner']['name'],
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 16,
                            color: Color(0xFF2D6A4F),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            if (catatanData['image_count'] != null)
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/article.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${catatanData['image_count']} Halaman',
                                    style: const TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 12,
                                      color: Color(0xFFA1A1A1),
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                Icon(Icons.access_time, size: 16, color: Color(0xFFA1A1A1)),
                                const SizedBox(width: 4),
                                Text(
                                  calculateTimeDifference(catatanData['created_at']),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 12,
                                    color: Color(0xFFA1A1A1),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
