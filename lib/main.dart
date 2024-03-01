import 'package:flutter/material.dart';
import 'add_catatan.dart';
import 'widget/header.dart';
import 'detail_catatan.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: CustomBody(),
        floatingActionButton: CustomFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

class CustomBody extends StatefulWidget {
  const CustomBody({Key? key}) : super(key: key);

  @override
  _CustomBodyState createState() => _CustomBodyState();
}

class _CustomBodyState extends State<CustomBody> {
  late List<Map<String, dynamic>> catatanList = [];
  bool isLoading = true;
  int currentPage = 1;
  int itemsPerPage = 5;
  bool allDataLoaded = false;
  int availablePage = 1;

  @override
  void initState() {
    super.initState();
    fetchCatatanData();
  }

  Future<void> fetchCatatanData() async {
    final Uri apiUrl = Uri.parse(
        'https://service-catatan.mejakita.com/catatan?itemPerPage=$itemsPerPage&page=$currentPage'
    );
    print("API URL: $apiUrl");
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        // Append new data to the existing list
        catatanList.addAll(List<Map<String, dynamic>>.from(data['data']));
        availablePage = data['pagination']['availablePage'];
        isLoading = false;
        allDataLoaded = currentPage >= availablePage;
      });
    } else {
      throw Exception('Failed to load Data');
    }
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        notification.metrics.pixels == notification.metrics.maxScrollExtent &&
        !allDataLoaded) {
      setState(() {
        currentPage++;
      });
      fetchCatatanData();
      return true;
    }
    return false;
  }

  Widget _buildLoadingIndicator() {
    return const SizedBox(
      height: 80,
      child: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF31B057),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        const CustomHeader(isHomePage: true, isLoggedIn: false,),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 40,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[100],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Cari catatan...',
                      hintStyle: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16.0,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {},
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
                      // Tambahkan logika untuk tombol cari di sini
                    },
                    child: const SizedBox(
                      height: 45,
                      width: 80,
                      child: Center(
                        child: Text(
                          'Cari',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: isLoading
              ? const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF31B057),
            ),
          )
              : LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 640;
              int itemCount = isMobile
                  ? currentPage * itemsPerPage
                  : catatanList.length;

              return NotificationListener<ScrollNotification>(
                onNotification: _onScrollNotification,
                child: isMobile
                    ? ListView.builder(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: itemCount + (allDataLoaded ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index == catatanList.length &&
                        !allDataLoaded) {
                      return _buildLoadingIndicator();
                    }
                    return index < catatanList.length
                        ? CardTemplate(
                      catatanData: catatanList[index],
                    )
                        : null;
                  },
                )
                    : GridView.builder(
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 2.2,
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    if (index == itemCount - 1 && !allDataLoaded) {
                      return const SizedBox(
                        height: 80,
                        child: Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF31B057)),
                        ),
                      );
                    }
                    return index < catatanList.length
                        ? CardTemplate(
                      catatanData: catatanList[index],
                    )
                        : null; // Return null for the items beyond the list length
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF31B057),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF237D3E).withOpacity(1.0),
            offset: const Offset(0, 4),
            blurRadius: 0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          borderRadius: BorderRadius.circular(28.0),
          // Menyesuaikan dengan bentuk FAB
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddCatatanPage(),
              ),
            );
          },
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class CardTemplate extends StatelessWidget {
  final Map<String, dynamic> catatanData;
  final double cardHeight;

  const CardTemplate({
    Key? key,
    required this.catatanData,
    this.cardHeight = 175.0, // Default card height, adjust as needed
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
      return '${difference.inDays} ${difference.inDays == 1 ? 'hari' : 'hari'} yang lalu';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'jam' : 'jam'} yang lalu';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'menit' : 'menit'} yang lalu';
    } else {
      return 'Baru saja';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: cardHeight, // Set the height of the entire card
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
                width: 100,
                height: cardHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: catatanData['thumbnail'] != null && catatanData['thumbnail']['image_url'] != null
                      ? DecorationImage(
                    image: NetworkImage(catatanData['thumbnail']['image_url']),
                    fit: BoxFit.cover,
                  )
                      : null, // Check if the 'image_url' field is present
                ),
              ),
              const SizedBox(width: 20),
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
                            const Icon(Icons.access_time, size: 16, color: Color(0xFFA1A1A1)),
                            const SizedBox(width: 4),
                            Text(
                              calculateTimeDifference(catatanData['created_at']),
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
  }
}