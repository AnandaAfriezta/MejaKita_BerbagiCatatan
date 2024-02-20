import 'package:flutter/material.dart';

class AccountInfoWidget extends StatelessWidget {
  final String ownerName;
  final String avatarUrl;

  const AccountInfoWidget({super.key, required this.ownerName, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey,
          backgroundImage: NetworkImage(avatarUrl),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dibagikan Oleh',
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFB5B9BF),
                  fontFamily: 'Nunito'
              ),
            ),
            Text(
              ownerName,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 40)
      ],
    );
  }
}
