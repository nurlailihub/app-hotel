import 'package:flutter/material.dart';
import 'rooms_screen.dart';

class CustomerHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Customer')),
      body: RoomsScreen(),
    );
  }
} 