import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../add_catatan.dart';
import '../login_catatan.dart'; // Gantilah dengan import yang sesuai untuk halaman login

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
          onTap: () async {
            // Retrieve login data from SharedPreferences
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            Map<String, dynamic>? loginData;
            String? loginDataString = prefs.getString('userData');

            // Check if login data is available
            if (loginDataString != null) {
              loginData = json.decode(loginDataString);
              print(loginDataString);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCatatanPage(loginData: loginData),
                ),
              );
            } else {
              // Redirect to login page if login data is not available
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            }
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