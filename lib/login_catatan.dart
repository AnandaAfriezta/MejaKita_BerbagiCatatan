import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  Future<void> _login() async {
    final url = Uri.parse('https://service2.mejakita.com/login/user');
    final String basicAuth = 'Basic ' + base64Encode(utf8.encode('${_emailController.text}:${_passwordController.text}'));

    final response = await http.post(
      url,
      headers: <String, String>{'authorization': basicAuth},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['messages'] == 'user.USER FOUND') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userData', jsonEncode(data));
        print(jsonEncode(data));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyApp()),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Login Gagal'),
              content: const Text('Email atau password yang Anda masukkan salah.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Terjadi kesalahan saat mengirim permintaan: ${response.reasonPhrase}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login dengan akun mejakita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: const OutlineInputBorder(),
                errorText: _emailError,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                errorText: _passwordError,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Masuk'),
            ),
          ],
        ),
      ),
    );
  }
}
