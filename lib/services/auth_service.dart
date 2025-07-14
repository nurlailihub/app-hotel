import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://10.159.26.68:8000/api';

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login?email=$email&password=$password'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token'] ?? '');
      await prefs.setString('role', data['user']?['role'] ?? '');
      // Simpan user_id ke SharedPreferences
      if (data['user'] != null && data['user']['id'] != null) {
        await prefs.setInt('user_id', data['user']['id']);
      }
      return data;
    } else {
      return null;
    }
  }
} 