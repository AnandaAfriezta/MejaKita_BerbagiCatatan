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
        floatingActionButton: CustomFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
        // SearchBar ditambahkan di sini dengan margin
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 40, // Set the desired height
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[100],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search catatan...',
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
                onTap: () {
                  // Tambahkan logika untuk tombol cari di sini
                },
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
          borderRadius: BorderRadius.circular(28.0), // Menyesuaikan dengan bentuk FAB
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
                      cardData.sender,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        color: Color(0xFF2D6A4F),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/article.png',
                          width: 30,
                          height: 30,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${cardData.pages} Halaman',
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
    image: 'assets/images/epep.jpg',
    title: 'Tutorial Jamsut EPEP Terbaru auto headshot 2024',
    sender: 'Kairi_kumar40',
    pages: '150',
  ),
  CardData(
    image: 'assets/images/kerajinan.jpg',
    title: 'Kerajinan Bahan Dari Alam',
    sender: 'budi',
    pages: '7',
  ),
  CardData(
    image: 'assets/images/pohon.jpg',
    title: 'Tata Cara Menanam Pohon',
    sender: 'cintaalam',
    pages: '12',
  ),
  CardData(
    image: 'assets/images/saklar.png',
    title: 'Tutorial menyalakan lampu paling efektif, 5 Menit belajar langsung bisa',
    sender: 'asikin_NasiJagung',
    pages: '4',
  ),
  CardData(
    image: 'assets/images/ow.png',
    title: 'MATEMATIKA Kelas 14 buat yang ngulang semester',
    sender: 'pintarbersama',
    pages: '5',
  ),
  // Add more data as needed
];
