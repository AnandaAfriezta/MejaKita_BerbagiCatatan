import 'package:flutter/material.dart';

import '../login_catatan.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool isHomePage;
  final bool isLoggedIn; // Tambahkan variabel untuk menentukan status login

  const CustomHeader({Key? key, required this.isHomePage, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 40, 15, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (isHomePage) {
                        // Add navigation logic to the previous page here
                      } else {
                        // Add navigation logic to go back here
                        Navigator.pop(context);
                      }
                    },
                    icon: isHomePage
                        ? const Icon(Icons.home)
                        : const Icon(Icons.arrow_back),
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
                      'Catatan',
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
              // Tambahkan kondisi untuk menampilkan dropdown hanya jika pengguna sudah login
              isLoggedIn ? DropdownButton<String>(
                items: <String>['Profile', 'Logout'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // Tambahkan logika untuk masing-masing item dropdown di sini
                },
              ) : InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/guest.png'),
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
