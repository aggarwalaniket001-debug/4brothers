import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<Map<String, dynamic>> _fetchProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return {};
    return await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();
  }

  Future<void> _signOut(BuildContext context) async {
    await Supabase.instance.client.auth.signOut(); //
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false); //
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MY IDENTITY"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchProfile(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!;
          
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified, color: Colors.blue, size: 100),
                const SizedBox(height: 10),
                Text(
                  "@${data['username'] ?? 'User'}",
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                // Displaying the AI-detected gender
                Chip(
                  label: Text("AI Detected: ${data['gender'] ?? 'N/A'}"),
                  backgroundColor: Colors.blue.withOpacity(0.2),
                ),
                const SizedBox(height: 40),
                const Text("100", style: TextStyle(fontSize: 80, color: Colors.redAccent, fontWeight: FontWeight.w900)),
                const Text("KARMA EARNED", style: TextStyle(letterSpacing: 2)),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/feed'),
                  child: const Text("GO TO COMMUNITY FEED"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
