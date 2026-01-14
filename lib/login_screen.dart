import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // BYPASS LOGIC: Forces entry to the app without DB checks
  void _forceLogin(String mode) {
    setState(() => _isLoading = true);
    
    // Tiny delay to simulate a real authentication check
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        // Navigates to Feed and passes 'social' as the user type
        Navigator.pushNamedAndRemoveUntil(
          context, 
          '/feed', 
          (route) => false, 
          arguments: 'social'
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: const Text("LOGIN TO MIST"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 30),
            
            if (_isLoading) 
              const CircularProgressIndicator(color: Colors.redAccent)
            else ...[
              // Standard Login Button (Bypass Mode)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () => _forceLogin('social'),
                  child: const Text("LOGIN", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
              const Text("--- DEVELOPER BYPASS ---", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),

              // THE DEMO BUTTON: Log in as singhbaishnavi6@gmail.com instantly
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () => _forceLogin('social'),
                child: const Text(
                  "LOGIN AS DEV (SINGH BAISHNAVI)", 
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}