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
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  
  File? _imageFile;
  bool _isUsernameValid = false;
  bool _isLoading = false;

  // Real-time Username Check
  Future<void> _checkUsername(String val) async {
    if (val.length < 3) {
      setState(() => _isUsernameValid = false);
      return;
    }
    try {
      final res = await Supabase.instance.client
          .from('profiles')
          .select('username')
          .eq('username', val.trim())
          .maybeSingle();
      if (mounted) setState(() => _isUsernameValid = (res == null));
    } catch (e) {
      if (mounted) setState(() => _isUsernameValid = true); // Safety for demo
    }
  }

  // THE WORKING SAVE LOGIC
  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);

    // 1. Session Guard: Try to get session, wait if null
    var session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      await Future.delayed(const Duration(milliseconds: 800)); // Wait for SDK sync
      session = Supabase.instance.client.auth.currentSession;
    }

    final user = session?.user;

    // 2. Fallback: If still null, stop the crash
    if (user == null) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: User session not found. Try logging in again.")),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    }

    try {
      String? imageUrl;
      // Handle Profile Pic Upload
      if (_imageFile != null) {
        final path = '${user.id}/avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
        await Supabase.instance.client.storage.from('avatars').upload(
          path, _imageFile!, fileOptions: const FileOptions(upsert: true)
        );
        imageUrl = Supabase.instance.client.storage.from('avatars').getPublicUrl(path);
      }

      // 3. Update the Profile in Database
      await Supabase.instance.client.from('profiles').update({
        'username': _usernameController.text.trim(),
        'phone_number': _phoneController.text.trim(),
        'city': _cityController.text.trim(),
        if (imageUrl != null) 'profile_pic_url': imageUrl,
      }).eq('id', user.id);

      if (mounted) Navigator.pushReplacementNamed(context, '/verify');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Save Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FINISH PROFILE"), centerTitle: true),
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
                radius: 55,
                backgroundColor: Colors.white10,
                backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                child: _imageFile == null ? const Icon(Icons.add_a_photo) : null,
              ),
            ),
            const SizedBox(height: 30),
            TextField(controller: _usernameController, onChanged: _checkUsername, decoration: const InputDecoration(labelText: "Username")),
            const SizedBox(height: 15),
            TextField(controller: _phoneController, decoration: const InputDecoration(labelText: "Phone"), keyboardType: TextInputType.phone),
            const SizedBox(height: 15),
            TextField(controller: _cityController, decoration: const InputDecoration(labelText: "City")),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: _isUsernameValid ? Colors.redAccent : Colors.grey[800]),
                onPressed: _isUsernameValid && !_isLoading ? _saveProfile : null,
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("FINISH & VERIFY FACE"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}