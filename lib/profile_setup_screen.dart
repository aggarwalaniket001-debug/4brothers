import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});
  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  
  File? _imageFile;
  bool _isUsernameValid = false;
  bool _isLoading = false;

  // 1. SIGN OUT LOGIC: Clears the persistent session
  Future<void> _signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      // The StreamBuilder in main.dart will automatically see the 'null' session
      // and redirect you to the SelectionScreen instantly.
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout Failed: $e")),
      );
    }
  }

  Future<void> _checkUsername(String val) async {
    if (val.length < 3) return;
    try {
      final res = await Supabase.instance.client
          .from('profiles')
          .select('username')
          .eq('username', val.trim())
          .maybeSingle();
      if (mounted) setState(() => _isUsernameValid = (res == null));
    } catch (e) {
      if (mounted) setState(() => _isUsernameValid = true); 
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No active session found."))
      );
      return;
    }

    try {
      String? imageUrl;
      if (_imageFile != null) {
        final path = '${user.id}/pfp.jpg';
        await Supabase.instance.client.storage.from('avatars').upload(
            path, _imageFile!, fileOptions: const FileOptions(upsert: true)
        );
        imageUrl = Supabase.instance.client.storage.from('avatars').getPublicUrl(path);
      }

      // Upsert logic to handle both anonymous and registered profiles
      await Supabase.instance.client.from('profiles').upsert({
        'id': user.id,
        'username': _usernameController.text.trim(),
        'full_name': _fullNameController.text.trim(),
        'phone_number': _phoneController.text.trim(),
        'city': _cityController.text.trim(),
        if (imageUrl != null) 'profile_pic_url': imageUrl,
      });

      if (mounted) Navigator.pushReplacementNamed(context, '/feed');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FINISH PROFILE"),
        centerTitle: true,
        // 2. LOGOUT BUTTON IN APPBAR
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: _signOut,
            tooltip: "Logout to Selection Screen",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                final file = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (file != null) setState(() => _imageFile = File(file.path));
              },
              child: CircleAvatar(
                radius: 50, 
                backgroundColor: Colors.white10,
                backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null, 
                child: _imageFile == null ? const Icon(Icons.add_a_photo) : null
              ),
            ),
            const SizedBox(height: 20),
            TextField(controller: _usernameController, onChanged: _checkUsername, decoration: const InputDecoration(labelText: "Username")),
            TextField(controller: _fullNameController, decoration: const InputDecoration(labelText: "Full Name")),
            TextField(controller: _phoneController, decoration: const InputDecoration(labelText: "Phone Number")),
            TextField(controller: _cityController, decoration: const InputDecoration(labelText: "City")),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55), 
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
              ),
              onPressed: _isUsernameValid && !_isLoading ? _saveProfile : null,
              child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text("FINISH & ENTER MIST", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}