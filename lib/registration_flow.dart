import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});
  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  String _selectedGender = 'Rather not say';

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      await Supabase.instance.client.from('profiles').update({
        'username': _usernameController.text,
        'full_name': _fullNameController.text,
        'gender': _selectedGender,
      }).eq('id', userId);
      
      if (mounted) Navigator.pushNamed(context, '/verify');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set Up Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "Username"),
                validator: (val) => val!.isEmpty ? "Enter a username" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: "Full Name"),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: ['Male', 'Female', 'Other', 'Rather not say']
                    .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedGender = val!),
                decoration: const InputDecoration(labelText: "Gender"),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text("Next: AI Face Verification"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}