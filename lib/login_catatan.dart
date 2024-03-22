import 'dart:convert';
import 'package:berbagi_catatan/register_catatan.dart';
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
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = 'Email belum diisi';
      });
      return;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Password belum diisi';
      });
      return;
    }

    final url = Uri.parse('https://service2.mejakita.com/login/user');
    final String basicAuth = 'Basic ' +
        base64Encode(utf8
            .encode('${_emailController.text}:${_passwordController.text}'));

    final response = await http.post(
      url,
      headers: <String, String>{'authorization': basicAuth},
    );

    final data = json.decode(response.body);

    if (data['messages'] == 'user.USER FOUND') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userData', jsonEncode(data));
      print(jsonEncode(data));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
      );
    } else if (data['messages'] == 'common.PASSWORD_FAILED') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Login Gagal',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              'password yang Anda masukkan salah.',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF31B057),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else if (data['messages'] == 'common.DATA_NOT_FOUND') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Login Gagal',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              'email yang Anda masukkan belum terdaftar.',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF31B057),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Field kosong',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              'Masih ada field yang masih kosong nih',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF31B057),
                  ),
                ),
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF31B057),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/images/kitty_halo.png',
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat datang',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF31B057),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'mejakitties',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF31B057),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Text(
              'Email',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.only(left: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFF3F4F6),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                      ),
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan email Anda',
                        hintStyle: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9CA3AF),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_emailError != null)
              const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 4.0),
                child: Text(
                  'Email Belum diisi',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.red,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            const Text(
              'Password',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.only(left: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFF3F4F6),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                      ),
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan password Anda',
                        hintStyle: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9CA3AF),
                        ),
                        border: InputBorder.none,
                      ),
                      obscureText: true,
                    ),
                  ),
                ],
              ),
            ),
            if (_passwordError != null)
              const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 4.0),
                child: Text(
                  'Password belum diisi',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.red,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Lupa password?',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9CA3AF),
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(vertical: 8),
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
                  onTap: _login,
                  child: const SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Masuk',
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
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Belum punya akun? ',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  Text(
                    'Daftar sekarang',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF31B057),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
