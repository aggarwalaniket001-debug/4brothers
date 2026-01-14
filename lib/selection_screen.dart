import 'package:flutter/material.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Accessing screen dimensions for responsive layout
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A1A), Color(0xFF0F0F0F)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Branding Section
                const Icon(
                  Icons.blur_on,
                  size: 80,
                  color: Colors.redAccent,
                ),
                const SizedBox(height: 20),
                const Text(
                  "MIST",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "AUTHENTICITY-FIRST SOCIAL MEDIA",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 1.5,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: size.height * 0.1),

                // Primary Action: Social Account
                _buildOptionButton(
                  context,
                  title: "CREATE SOCIAL ACCOUNT",
                  subtitle: "Requires AI Face Verification",
                  icon: Icons.verified_user,
                  color: Colors.redAccent,
                  onTap: () => Navigator.pushNamed(context, '/setup'),
                ),

                const SizedBox(height: 20),

                // Secondary Action: Anonymous Browse
                _buildOptionButton(
                  context,
                  title: "BROWSE ANONYMOUSLY",
                  subtitle: "Limited Features • No Verified Badge",
                  icon: Icons.visibility_off,
                  color: Colors.white10,
                  textColor: Colors.white,
                  onTap: () => Navigator.pushNamed(context, '/feed'),
                ),
                
                const SizedBox(height: 40),
                
                // Trust Footer
                const Text(
                  "By continuing, you agree to MIST's high-trust community guidelines.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white38, fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable button widget for consistency
  Widget _buildOptionButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    Color textColor = Colors.white,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: color == Colors.redAccent 
            ? [BoxShadow(color: Colors.redAccent.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))]
            : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 30),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: textColor.withOpacity(0.5), size: 16),
          ],
        ),
      ),
    );
  }
}