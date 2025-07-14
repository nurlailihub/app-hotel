import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookingService {
  final String baseUrl = 'http://10.159.26.68:8000/api';

  Future<Map<String, dynamic>> createBooking({
    required int userId,
    required int roomId,
    required String checkInDate,
    required String checkOutDate,
    required double totalPrice,
    String status = 'pending',
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print('Booking URL: $baseUrl/bookings');
    final response = await http.post(
      Uri.parse('$baseUrl/bookings'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json', // <--- Tambahkan ini!
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'user_id': userId,
        'room_id': roomId,
        'check_in_date': checkInDate,
        'check_out_date': checkOutDate,
        'total_price': totalPrice,
        'status': status,
      }),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      print('Booking error: ${response.body}');
      throw Exception('Gagal melakukan booking');
    }
  }
} 