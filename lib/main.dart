import 'package:flutter/material.dart';
import 'add_catatan.dart';
import 'header.dart';

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
        floatingActionButton: CustomFloatingActionButton(), // Tambahkan ini
        floatingActionButtonLocation: FloatingActionButtonLocation
            .endFloat, // Sesuaikan lokasi floating action button
      ),
    );
  }
}

class CustomBody extends StatelessWidget {
  const CustomBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomHeader(),
        const SizedBox(height: 10),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: cardDataList.length,
            itemBuilder: (context, index) {
              return CardTemplate(
                cardData: cardDataList[index],
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
    return FloatingActionButton(
      onPressed: () {
        // Tambahkan logika untuk pindah ke halaman AddCatatanPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddCatatanPage(),
          ),
        );
      },
      backgroundColor: Colors.green,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28.0),
      ),
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}

class CardData {
  final String image;
  final String title;
  final String sender;
  final String pages;

  CardData({
    required this.image,
    required this.title,
    required this.sender,
    required this.pages,
  });
}

class CardTemplate extends StatelessWidget {
  final CardData cardData;

  const CardTemplate({
    Key? key,
    required this.cardData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 175,
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 175,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(cardData.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cardData.title,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      cardData.sender,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Pages: ${cardData.pages}',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        color: Colors.grey,
                      ),
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

final List<CardData> cardDataList = [
  CardData(
    image: 'assets/images/kerajinan.jpg',
    title: 'Qwerty uiop asdf (ghjkl)',
    sender: 'Atta',
    pages: '100',
  ),
  CardData(
    image: 'assets/images/kerajinan.jpg',
    title: 'qq',
    sender: 'budi',
    pages: '50',
  ),
  // Add more data as needed
];
