import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

 
  await Supabase.initialize(
    url: 'https://noqlvqfaomhjuxozdulw.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5vcWx2cWZhb21oanV4b3pkdWx3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgzNzc3MTAsImV4cCI6MjA4Mzk1MzcxMH0.xGltGWYUYWdXKi4Z_Eb0U4flmzvvo1aaRpY2zvACyQ8',
  );

  runApp(const MaterialApp(
    home: Scaffold(
      body: Center(child: Text("MIST: India's Own Social Media")),
    ),
  ));
}

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("MIST", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)), // [cite: 1]
            const Text("INDIA'S OWN SOCIAL MEDIA", style: TextStyle(letterSpacing: 2)), // [cite: 2]
            const SizedBox(height: 60),
            
            // Social Account - Required for full features and monetization [cite: 20, 41]
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                // Next Commit: AI Selfie Verification 
              },
              child: const Text("CREATE SOCIAL ACCOUNT"),
            ),
            const SizedBox(height: 20),
            
            // Anonymous Account - Restricted access [cite: 19]
            OutlinedButton(
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 60)),
              onPressed: () {
                // Proceed with restricted random username [cite: 19]
              },
              child: const Text("BROWSE ANONYMOUSLY"),
            ),
          ],
        ),
      ),
    );
  }
}