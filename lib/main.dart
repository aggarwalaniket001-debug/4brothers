import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'selection_screen.dart';
import 'login_screen.dart';
import 'feed_screen.dart';
import 'profile_setup_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // We keep the initialization so the app doesn't crash, 
  // but we won't rely on it for the login flow.
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
      debugShowCheckedModeBanner: false,
      title: 'MIST',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.redAccent,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
      ),
      // Direct start at Selection for the demo
      home: const SelectionScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/feed': (context) => const FeedScreen(),
        '/setup': (context) => const ProfileSetupScreen(),
      },
    );
  }
}