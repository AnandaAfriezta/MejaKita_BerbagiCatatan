import 'package:berbagi_catatan/login_catatan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  Future<void> _register() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _nameError = null;
      _confirmPasswordError = null;
    });
    if (_nameController.text.isEmpty) {
      setState(() {
        _nameError = 'Username belum diisi';
      });
      return;
    }
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
    if (_confirmPasswordController.text.isEmpty) {
      setState(() {
        _confirmPasswordError = 'Ketikkan ulang password';
      });
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _confirmPasswordError = 'Password tidak sama';
      });
      return;
    }

    final url = Uri.parse('${ApiConstants.serviceMejakita}register');
    final Map<String, String> body = {
      'name': _nameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'birth_date': '2000-01-01',
      'province_id': '35',
      'regency_id': '3573',
      'education_level_id': '1',
    };
    // Melakukan permintaan POST ke API
    final response = await http.post(
      url,
      body: body,
    );

    if (response.statusCode == 201) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Registrasi Berhasil',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              'Anda berhasil mendaftar.',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w400,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Jika gagal, Anda dapat menangani kasus tersebut di sini
      // Menampilkan pesan kesalahan dari respons API
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Registrasi Gagal',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              'Terjadi kesalahan saat melakukan registrasi',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w400,
              ),
            ),
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
        title: const Text(
          'Register',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF31B057),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
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
                          'Daftarkan akun',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF31B057),
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ],
                ),
                const Text(
                  'Nama',
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
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: 'Masukkan nama Anda',
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
                if (_nameError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                    child: Text(
                      _nameError!,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.red,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                    child: Text(
                      _emailError!,
                      style: const TextStyle(
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
                          decoration: InputDecoration(
                            hintText: 'Masukkan password Anda',
                            hintStyle: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF9CA3AF),
                            ),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color(0xFF9CA3AF),
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_passwordVisible,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_passwordError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                    child: Text(
                      _passwordError!,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.red,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                const Text(
                  'Ulangi Password',
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
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            hintText: 'Ketikkan ulang password',
                            hintStyle: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF9CA3AF),
                            ),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _confirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color(0xFF9CA3AF),
                              ),
                              onPressed: () {
                                setState(() {
                                  _confirmPasswordVisible =
                                  !_confirmPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_confirmPasswordVisible,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_confirmPasswordError != null &&
                    _passwordController.text != _confirmPasswordController.text)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                    child: Text(
                      _confirmPasswordError!,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.red,
                      ),
                    ),
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
                      onTap: _register,
                      child: const SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Daftar',
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
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sudah punya akun? ',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                      Text(
                        'Login sekarang',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF31B057),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
