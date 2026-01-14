import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile_setup_screen.dart';
import 'feed_screen.dart';
import 'selection_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://noqlvqfaomhjuxozdulw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5vcWx2cWZhb21oanV4b3pkdWx3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgzNzc3MTAsImV4cCI6MjA4Mzk1MzcxMH0.xGltGWYUYWdXKi4Z_Eb0U4flmzvvo1aaRpY2zvACyQ8',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce, // Ensures session persistence across restarts
    ),
  );

  runApp(const MistApp());
}

class MistApp extends StatelessWidget {
  const MistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      // Gatekeeper: Listens for Auth changes
      home: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          final session = snapshot.data?.session;

          // 1. If no session, show Selection/Login
          if (session == null) {
            return const SelectionScreen();
          }

          // 2. If session exists, check if profile is already complete
          return FutureBuilder(
            future: Supabase.instance.client
                .from('profiles')
                .select('username')
                .eq('id', session.user.id)
                .maybeSingle(),
            builder: (context, profileSnapshot) {
              if (profileSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }

              final profileData = profileSnapshot.data;

              // If username is found, go to Feed. Otherwise, Setup.
              if (profileData != null && profileData['username'] != null) {
                return const FeedScreen();
              } else {
                return const ProfileSetupScreen();
              }
            },
          );
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/setup': (context) => const ProfileSetupScreen(),
        '/feed': (context) => const FeedScreen(),
      },
    );
  }
}