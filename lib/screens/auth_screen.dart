// File: lib/screens/auth_screen.dart
import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/database_service.dart';

// ============================================================================
// 1. MÀN HÌNH ĐĂNG NHẬP (LOGIN SCREEN)
// ============================================================================
class LoginScreen extends StatefulWidget {
  final ValueChanged<UserProfile> onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _isObscure = true;
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final user = await DatabaseService.loginUser(
      _usernameController.text,
      _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (user != null) {
      widget.onLoginSuccess(user);
    } else {
      setState(() {
        _errorMessage = 'Sai tên đăng nhập hoặc mật khẩu!';
      });
    }
  }

  void _openRegisterScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterScreen(
          onRegisteredUsername: (newUsername) {
            _usernameController.text = newUsername;
            _passwordController.clear();
            setState(() => _errorMessage = '');
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade800, Colors.teal.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.teal,
                        child: Icon(
                          Icons.fitness_center,
                          size: 38,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'ĐĂNG NHẬP HỆ THỐNG',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'PNP Fitness • Phát - Phong - Nam',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 22),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: const Icon(Icons.person, color: Colors.teal),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập Username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock, color: Colors.teal),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() => _isObscure = !_isObscure);
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập Password';
                          }
                          return null;
                        },
                      ),
                      if (_errorMessage.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          _errorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'ĐĂNG NHẬP',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Chưa có tài khoản?'),
                          TextButton(
                            onPressed: _openRegisterScreen,
                            child: const Text(
                              'Đăng ký tài khoản mới',
                              style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      const Text(
                        'Điền nhanh tài khoản có sẵn trong Database:',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          ActionChip(
                            label: const Text('Phát (phat)'),
                            onPressed: () {
                              _usernameController.text = 'phat';
                              _passwordController.text = '123456';
                            },
                          ),
                          ActionChip(
                            label: const Text('Phong (phong)'),
                            onPressed: () {
                              _usernameController.text = 'phong';
                              _passwordController.text = '123456';
                            },
                          ),
                          ActionChip(
                            label: const Text('Nam (nam)'),
                            onPressed: () {
                              _usernameController.text = 'nam';
                              _passwordController.text = '123456';
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 2. MÀN HÌNH ĐĂNG KÝ RIÊNG BIỆT (REGISTER SCREEN)
// ============================================================================
class RegisterScreen extends StatefulWidget {
  final ValueChanged<String>? onRegisteredUsername;

  const RegisterScreen({super.key, this.onRegisteredUsername});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _weightController =
      TextEditingController(text: '65');
  final TextEditingController _heightController =
      TextEditingController(text: '1.70');

  String _successMessage = '';
  bool _isSuccess = false;

  Future<void> _onRegisterPressed() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final fullName = _fullNameController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _isSuccess = false;
        _successMessage = 'Vui lòng nhập đầy đủ thông tin!';
      });
      return;
    }

    final newUser = UserProfile(
      id: 'U${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
      username: username,
      password: password,
      name: fullName.isEmpty ? username : fullName,
      weight: double.tryParse(_weightController.text) ?? 65.0,
      height: double.tryParse(_heightController.text) ?? 1.70,
    );

    final created = await DatabaseService.registerUser(newUser);

    if (!mounted) return;

    if (created) {
      setState(() {
        _isSuccess = true;
        _successMessage = 'Đã đăng ký thành công';
      });
      widget.onRegisteredUsername?.call(username);
    } else {
      setState(() {
        _isSuccess = false;
        _successMessage = 'Username "$username" đã tồn tại trong Database!';
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đăng ký tài khoản',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_add_alt_1, size: 56, color: Colors.teal),
            const SizedBox(height: 12),
            const Text(
              'Tạo tài khoản mới vào Database',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 20),

            // Ô nhập Username (TextFormField theo chuẩn yêu cầu bài tập)
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username (*)',
                prefixIcon: Icon(Icons.person, color: Colors.teal),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Ô nhập Password
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password (*)',
                prefixIcon: Icon(Icons.lock, color: Colors.teal),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Ô nhập Họ và tên hiển thị ở Tab Hồ sơ
            TextFormField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                labelText: 'Họ và tên hiển thị',
                prefixIcon: Icon(Icons.badge, color: Colors.teal),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Cân nặng & Chiều cao ban đầu
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Cân nặng (kg)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Chiều cao (m)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Nút Elevated Button Đăng ký
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onRegisterPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Đăng ký',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Dòng chữ hiển thị thông báo ở dưới ("Đã đăng ký thành công")
            if (_successMessage.isNotEmpty) ...[
              Text(
                _successMessage,
                style: TextStyle(
                  color: _isSuccess ? Colors.green : Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              if (_isSuccess) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.login, color: Colors.teal),
                  label: const Text('Quay lại màn hình Đăng nhập'),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}