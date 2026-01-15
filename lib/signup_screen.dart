import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async'; // <--- THIS FIXES THE 'Timer' ERROR

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isVerifying = false;
  bool _isVerified = false;
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 1000)
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  // --- PDF FEATURE: AI IDENTITY VERIFICATION FLOW ---
  void _simulateAiVerify() {
    setState(() => _isVerifying = true);
    
    // Timer now works because of the dart:async import
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isVerifying = false;
          _isVerified = true;
        });
      }
    });
  }

  void _finishSignup() {
    setState(() => _showSuccess = true);
    
    // Wait for the "Success" animation to play before going to feed
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
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
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildBackground(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    const Text("JOIN MIST", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 4)),
                    const SizedBox(height: 10),
                    const Text("Secure. Indian. Verified.", style: TextStyle(color: Colors.white54)),
                    const SizedBox(height: 40),
                    _buildSignupCard(),
                    const SizedBox(height: 20),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
          
          // AI SCANNING OVERLAY
          if (_isVerifying) _buildScanningOverlay(),

          // SUCCESS REWARD OVERLAY (50 Karma)
          if (_showSuccess) _buildSuccessOverlay(),
        ],
      ),
    );
  }

  Widget _buildSuccessOverlay() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Container(
        width: double.infinity,
        color: Colors.black87,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 800),
              builder: (context, double val, child) {
                return Transform.scale(
                  scale: val,
                  child: const Icon(Icons.stars, color: Colors.amber, size: 100),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text("WELCOME TO MIST", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const Text("+50 KARMA SIGNUP BONUS", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildScanningOverlay() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(radius: 80, backgroundColor: Colors.white10, child: Icon(Icons.person, size: 100, color: Colors.white24)),
                  _ScannerLine(),
                ],
              ),
              const SizedBox(height: 30),
              const Text("A.I. ANALYZING FACE DATA", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, letterSpacing: 2)),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI PIECES (Card, Input, Button) ---
  Widget _buildSignupCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              _buildInput(Icons.person_outline, "Full Name"),
              const SizedBox(height: 15),
              _buildInput(Icons.email_outlined, "Email"),
              const SizedBox(height: 15),
              _buildInput(Icons.lock_outline, "Password", obscure: true),
              const SizedBox(height: 30),

              if (!_isVerified)
                _buildBtn("A.I. IDENTITY VERIFY", Icons.face, Colors.blueAccent, _simulateAiVerify)
              else
                _buildBtn("FINISH SIGNUP", Icons.check_circle, Colors.greenAccent, _finishSignup),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(IconData i, String h, {bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        prefixIcon: Icon(i, color: Colors.white38, size: 20),
        hintText: h,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildBtn(String t, IconData i, Color c, VoidCallback tap) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(colors: [c, c.withOpacity(0.7)]),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(i, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.8, -0.6),
          radius: 1.2,
          colors: [Color(0xFF0D1B2A), Colors.black],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text("Already have an account? Login", style: TextStyle(color: Colors.white54)),
    );
  }
}

// Scanner Line Animation
class _ScannerLine extends StatefulWidget {
  const _ScannerLine();
  @override
  _ScannerLineState createState() => _ScannerLineState();
}

class _ScannerLineState extends State<_ScannerLine> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) => Positioned(
        top: _ctrl.value * 160,
        child: Container(
          width: 160, height: 2,
          decoration: BoxDecoration(color: Colors.blueAccent, boxShadow: [BoxShadow(color: Colors.blueAccent.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)]),
        ),
      ),
    );
  }
}