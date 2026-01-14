import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  bool _isLoading = false;

 
  Future<void> _signInAnonymously() async {
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client.auth.signInAnonymously();
      
      if (response.session != null && mounted) {
        // Successful anonymous session created
        Navigator.pushReplacementNamed(context, '/setup');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Anonymous Login Failed: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // 2. Force Test Account Login
  Future<void> _loginAsTestUser() async {
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: 'harshsawarn2005@gmail.com',
        password: 'harsh4august',
      );

      if (response.session != null && mounted) {
        // Check if this test user already has a profile
        final profile = await Supabase.instance.client
            .from('profiles')
            .select()
            .eq('id', response.user!.id)
            .maybeSingle();

        if (profile == null) {
          Navigator.pushReplacementNamed(context, '/setup');
        } else {
          Navigator.pushReplacementNamed(context, '/feed');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Test Login Failed: Check if user exists in Supabase")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: const BoxDecoration(
          color: Color(0xFF0F0F0F), // Dark background
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "MIST",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: 10,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 60),
            
            // Login Button
            _buildButton(
              text: "LOGIN",
              onPressed: () => Navigator.pushNamed(context, '/login'),
              isPrimary: true,
            ),
            const SizedBox(height: 15),
            
            // Signup Button
            _buildButton(
              text: "SIGNUP",
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              isPrimary: false,
            ),
            const SizedBox(height: 15),

            // Anonymous Button
            _buildButton(
              text: "GUEST MODE (ANONYMOUS)",
              onPressed: _isLoading ? null : _signInAnonymously,
              isPrimary: false,
              color: Colors.orangeAccent,
            ),
            
            const SizedBox(height: 40),
            const Text("OR", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),

            // Secret Test Button
            TextButton(
              onPressed: _isLoading ? null : _loginAsTestUser,
              child: const Text(
                "Use Developer Test Account",
                style: TextStyle(color: Colors.redAccent, decoration: TextDecoration.underline),
              ),
            ),
            
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(color: Colors.redAccent),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback? onPressed,
    required bool isPrimary,
    Color? color,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? (isPrimary ? Colors.redAccent : Colors.transparent),
          side: isPrimary ? null : const BorderSide(color: Colors.white24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}