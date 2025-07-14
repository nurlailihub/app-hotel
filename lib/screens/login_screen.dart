import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'admin_home.dart';
import 'customer_home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMsg;

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Gagal'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void login() async {
    setState(() {
      isLoading = true;
      errorMsg = null;
    });
    final auth = AuthService();
    final result = await auth.login(emailController.text, passwordController.text);
    setState(() {
      isLoading = false;
    });
    if (result != null) {
      String role = result['user']['role'];
      // Navigasi sesuai role
      if (role == 'admin') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminHome()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CustomerHome()));
      }
    } else {
      showErrorDialog("Email atau password salah. Silakan coba lagi.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 20),
            if (isLoading) CircularProgressIndicator(),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: isLoading ? null : login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
} 