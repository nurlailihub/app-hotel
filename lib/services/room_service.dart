import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RoomService {
  final String baseUrl = 'http://10.159.26.68:8000/api';

  Future<List<dynamic>> getRooms() async {
    final response = await http.get(Uri.parse('$baseUrl/rooms'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal memuat data kamar');
    }
  }

  Future<Map<String, dynamic>> getRoomDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/rooms/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal memuat detail kamar');
    }
  }

  Future<Map<String, dynamic>> createRoom(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.post(
      Uri.parse('$baseUrl/rooms'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: data,
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal menambah kamar');
    }
  }

  Future<Map<String, dynamic>> updateRoom(int id, Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.put(
      Uri.parse('$baseUrl/rooms/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: data,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal mengupdate kamar');
    }
  }

  Future<void> deleteRoom(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.delete(
      Uri.parse('$baseUrl/rooms/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus kamar');
    }
  }
} 