import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'selection_screen.dart';
import 'verification_screen.dart';
import 'dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Your Mumbai-based project connection
  await Supabase.initialize(
    url: 'https://noqlvqfaomhjuxozdulw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5vcWx2cWZhb21oanV4b3pkdWx3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgzNzc3MTAsImV4cCI6MjA4Mzk1MzcxMH0.xGltGWYUYWdXKi4Z_Eb0U4flmzvvo1aaRpY2zvACyQ8',
  );

  runApp(const MistApp());
}

class MistApp extends StatelessWidget {
  const MistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIST',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.redAccent,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F), // Dark sleek background
      ),
      // Named routes for easy navigation
      initialRoute: '/',
      routes: {
        '/': (context) => const SelectionScreen(),
        '/verify': (context) => const VerificationScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}