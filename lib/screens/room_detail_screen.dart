import 'package:flutter/material.dart';
import '../services/room_service.dart';
import '../services/room_availability_service.dart';
import '../services/booking_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RoomDetailScreen extends StatefulWidget {
  final int roomId;
  final Map<String, dynamic> roomData;
  RoomDetailScreen({required this.roomId, required this.roomData});

  @override
  _RoomDetailScreenState createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  DateTime? checkInDate;
  DateTime? checkOutDate;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
        } else {
          checkOutDate = picked;
        }
      });
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Booking Gagal'),
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

  void showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Booking Berhasil'),
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

  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<void> checkAvailabilityAndBook() async {
    if (checkInDate == null || checkOutDate == null) {
      showErrorDialog('Silakan pilih tanggal check-in dan check-out.');
      return;
    }
    setState(() { isLoading = true; });
    try {
      final service = RoomAvailabilityService();
      final avail = await service.getAvailability(
        widget.roomId,
        checkInDate!.toIso8601String().split('T')[0],
        checkOutDate!.toIso8601String().split('T')[0],
      );
      bool tersedia = avail.any((a) => a['available_rooms'] > 0);
      if (!tersedia) {
        showErrorDialog('Kamar tidak tersedia pada tanggal yang dipilih.');
      } else {
        // Proses booking
        try {
          int? userId = await getUserId();
          print('User ID: $userId');
          if (userId == null) {
            showErrorDialog('User tidak ditemukan. Silakan login ulang.');
            setState(() { isLoading = false; });
            return;
          }
          double totalPrice = ((checkOutDate!.difference(checkInDate!).inDays) * (widget.roomData['price_per_night'] ?? 0)).toDouble();
          final bookingService = BookingService();
          await bookingService.createBooking(
            userId: userId,
            roomId: widget.roomId,
            checkInDate: checkInDate!.toIso8601String().split('T')[0],
            checkOutDate: checkOutDate!.toIso8601String().split('T')[0],
            totalPrice: totalPrice,
          );
          showSuccessDialog('Booking berhasil! Silakan lanjut ke pembayaran.');
        } catch (e) {
          // Ambil pesan error detail jika ada
          String errorMsg = 'Gagal melakukan booking.';
          if (e is Exception && e.toString().contains('Booking error:')) {
            try {
              final errorJson = e.toString().split('Booking error:')[1].trim();
              final errorData = json.decode(errorJson);
              if (errorData is Map && errorData['message'] != null) {
                errorMsg = errorData['message'].toString();
              } else if (errorData is Map && errorData.values.isNotEmpty) {
                errorMsg = errorData.values.first.toString();
              }
            } catch (_) {}
          }
          showErrorDialog(errorMsg);
        }
      }
    } catch (e) {
      showErrorDialog('Gagal cek ketersediaan kamar.');
    }
    setState(() { isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final room = widget.roomData;
    return Scaffold(
      appBar: AppBar(title: Text(room['room_type'] ?? 'Detail Kamar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (room['image_url'] != null)
                Center(
                  child: Image.network(room['image_url'], height: 180, fit: BoxFit.cover),
                ),
              SizedBox(height: 16),
              Text(room['room_type'] ?? '-', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Rp${room['price_per_night']} / malam', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text(room['description'] ?? '-'),
              SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tanggal Check-in'),
                    InkWell(
                      onTap: () => _selectDate(context, true),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Pilih tanggal check-in',
                        ),
                        child: Text(checkInDate == null ? '' : checkInDate!.toLocal().toString().split(' ')[0]),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text('Tanggal Check-out'),
                    InkWell(
                      onTap: () => _selectDate(context, false),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Pilih tanggal check-out',
                        ),
                        child: Text(checkOutDate == null ? '' : checkOutDate!.toLocal().toString().split(' ')[0]),
                      ),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : checkAvailabilityAndBook,
                        child: isLoading ? CircularProgressIndicator() : Text('Booking Sekarang'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 