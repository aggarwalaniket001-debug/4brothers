import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'selection_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'profile_setup_screen.dart';
import 'verification_screen.dart';
import 'feed_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Crucial for plugins

  await Supabase.initialize(
   url: 'https://noqlvqfaomhjuxozdulw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5vcWx2cWZhb21oanV4b3pkdWx3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgzNzc3MTAsImV4cCI6MjA4Mzk1MzcxMH0.xGltGWYUYWdXKi4Z_Eb0U4flmzvvo1aaRpY2zvACyQ8',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce, // Best for mobile persistence
    ),
  );

  runApp(const MistApp());
}

class MistApp extends StatelessWidget {
  const MistApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if user is already logged in at boot
    final session = Supabase.instance.client.auth.currentSession;

    return MaterialApp(
      title: 'MIST',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: session != null ? '/feed' : '/', // Auto-login logic
      routes: {
        '/': (context) => const SelectionScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/setup': (context) => const ProfileSetupScreen(),
        '/verify': (context) => const VerificationScreen(),
        '/feed': (context) => const FeedScreen(),
      },
    );
  }
}