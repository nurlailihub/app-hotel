import 'dart:convert';
import 'package:http/http.dart' as http;

class RoomAvailabilityService {
  final String baseUrl = 'http://10.159.26.68:8000/api';

  Future<List<dynamic>> getAvailability(int roomId, String checkIn, String checkOut) async {
    final response = await http.get(
      Uri.parse('$baseUrl/room-availability?room_id=$roomId&check_in=$checkIn&check_out=$checkOut'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal memuat data ketersediaan kamar');
    }
  }
} 