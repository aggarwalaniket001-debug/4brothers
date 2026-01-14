import 'package:flutter/material.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  bool _isProcessing = false;

  // PDF PATH: Social Account (Full Access)
  void _navigateToLogin() {
    Navigator.pushNamed(context, '/login');
  }

  // PDF PATH: Anonymous Account (Restricted Access)
  // This bypasses Supabase entirely for a stable demo.
  void _enterAsGuest() {
    setState(() => _isProcessing = true);
    
    // Simulate a brief "Authenticating" delay for the judges
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        // Pass 'anonymous' as an argument so the Feed knows to restrict features
        Navigator.pushNamedAndRemoveUntil(
          context, 
          '/feed', 
          (route) => false, 
          arguments: 'anonymous'
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF0F0F0F), // MIST Signature Dark Theme
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // MIST LOGO
              const Text(
                "MIST",
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 12,
                  color: Colors.white,
                ),
              ),
              const Text(
                "INDIA'S OWN SOCIAL MEDIA",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.redAccent,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 80),

              if (_isProcessing)
                const CircularProgressIndicator(color: Colors.redAccent)
              else ...[
                // SOCIAL LOGIN BUTTON (Step 1 of the PDF Auth Flow)
                _buildButton(
                  context,
                  text: "SOCIAL LOGIN",
                  onPressed: _navigateToLogin,
                  isPrimary: true,
                ),
                
                const SizedBox(height: 20),

                // GUEST MODE BUTTON (Anonymous bypass from PDF Page 4)
                _buildButton(
                  context,
                  text: "GUEST MODE (ANONYMOUS)",
                  onPressed: _enterAsGuest,
                  isPrimary: false,
                ),
              ],

              const SizedBox(height: 40),
              const Text(
                "By continuing, you agree to the MIST Terms of Service",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom Button Builder to keep code clean
  Widget _buildButton(BuildContext context, {
    required String text, 
    required VoidCallback onPressed, 
    required bool isPrimary
  }) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.redAccent : Colors.transparent,
          side: isPrimary ? null : const BorderSide(color: Colors.white24, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: isPrimary ? 5 : 0,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}