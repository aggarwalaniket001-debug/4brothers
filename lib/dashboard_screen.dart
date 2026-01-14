import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// THE NAME BELOW MUST MATCH YOUR main.dart
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MIST Dashboard")),
      body: const Center(
        child: Text("Welcome to MIST"),
      ),
    );
  }
}