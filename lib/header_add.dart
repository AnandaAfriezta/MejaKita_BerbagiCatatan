import 'package:flutter/material.dart';

class HeaderAdd extends StatelessWidget implements PreferredSizeWidget {
  const HeaderAdd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, top: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Add navigation logic to the previous page here
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'assets/images/berbagi-catatan-icon.png',
                    width: 30,
                    height: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Buat Catatan Baru', // Ubah teks Catatan menjadi Tambah Catatan
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF31B057),
                      ),
                    ),
                  ),
                ],
              ),
              // Add profile widget here
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80); // Set your preferred height
}
