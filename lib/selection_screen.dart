import 'package:flutter/material.dart';

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
              const Text("MIST", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)), 
              const Text("INDIA'S OWN SOCIAL MEDIA", style: TextStyle(fontSize: 12)), 
              const SizedBox(height: 60),
              
              
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                 
                },
                child: const Text("CREATE SOCIAL ACCOUNT"),
              ),
              const SizedBox(height: 20),
              
             
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                 
                },
                child: const Text("BROWSE ANONYMOUSLY"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}