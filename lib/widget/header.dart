import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool isHomePage;

  const CustomHeader({Key? key, required this.isHomePage}) : super(key: key);

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
              // Add profile widget here
              const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/profile.png'),
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
