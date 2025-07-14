import 'package:flutter/material.dart';
import 'rooms_screen.dart';

class AdminHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40),
            Text('Selamat datang, Admin!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            ElevatedButton.icon(
              icon: Icon(Icons.meeting_room),
              label: Text('Lihat Data Kamar'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => RoomsScreen()));
              },
              style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 18)),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.person),
              label: Text('Profil (Coming Soon)'),
              onPressed: null, // Fitur belum aktif
              style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 18)),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.logout),
              label: Text('Logout'),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 18), backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
} 