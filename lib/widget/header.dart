import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login_catatan.dart';
import '../main.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool isHomePage;

  const CustomHeader({Key? key, required this.isHomePage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> userData = snapshot.data!;
          bool isLoggedIn = userData.isNotEmpty;

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
                              // Tambahkan logika navigasi ke halaman sebelumnya di sini
                            } else {
                              // Tambahkan logika navigasi untuk kembali ke halaman sebelumnya di sini
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
                    isLoggedIn
                        ? InkWell(
                      onTap: () {
                        _showProfileMenu(context);
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(userData['data']['user']['photo_url']),
                        backgroundColor: Colors.white,
                      ),
                    )
                        : InkWell(
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
        } else if (snapshot.hasError) {
          // Handle error case
          return Text('Error: ${snapshot.error}');
        } else {
          // Jika data masih dimuat, tampilkan loading atau indikator lainnya
          return CircularProgressIndicator();
        }
      },
    );
  }

  Future<Map<String, dynamic>> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');
    if (userDataString != null && userDataString.isNotEmpty) {
      return Map<String, dynamic>.from(json.decode(userDataString));
    } else {
      return {};
    }
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');

    // Tambahkan logika untuk mereload halaman
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  void _showProfileMenu(BuildContext context) async {
    Map<String, dynamic> userData = await _getUserData();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('${userData['data']['user']['name']}'),
              ),
              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(color: Colors.red), // Teks menjadi merah
                ),
                onTap: () {
                  _logout(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
