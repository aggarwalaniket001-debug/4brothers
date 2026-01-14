import 'package:flutter/material.dart';
import 'verification_screen.dart'; 

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("MIST", 
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.redAccent)), 
              const Text("INDIA'S OWN SOCIAL MEDIA", 
                style: TextStyle(fontSize: 12, letterSpacing: 1.2)), 
              const SizedBox(height: 60),
              
              
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const VerificationScreen()),
                  );
                },
                child: const Text("CREATE SOCIAL ACCOUNT"),
              ),
              
              const SizedBox(height: 20),
              
              
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                 
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Entering as Anonymous User...")),
                  );
                },
                child: const Text("BROWSE ANONYMOUSLY", style: TextStyle(color: Colors.redAccent)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}