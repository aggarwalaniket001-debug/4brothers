import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});
  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  CameraController? _controller;
  bool _isFaceDetected = false;
  String _detectedGender = "Analyzing...";

  @override
  void initState() {
    super.initState();
    _initCam();
  }

  Future<void> _initCam() async {
    final cams = await availableCameras();
    _controller = CameraController(
      cams.firstWhere((c) => c.lensDirection == CameraLensDirection.front),
      ResolutionPreset.medium,
    );
    await _controller!.initialize();
    if (mounted) setState(() {});
    
    // Simulate AI detection logic
    await Future.delayed(const Duration(seconds: 3));
    
    // Simulate gender detection logic (e.g., based on simple randomization for demo)
    final predicted = (DateTime.now().second % 2 == 0) ? "Male" : "Female";
    
    if (mounted) {
      setState(() {
        _isFaceDetected = true;
        _detectedGender = predicted;
      });
    }
  }

  Future<void> _completeVerification() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      // Update the profile with verification status AND the detected gender
      await Supabase.instance.client.from('profiles').update({
        'is_verified': true,
        'karma_score': 100,
        'gender': _detectedGender, // Overwrites or confirms the gender in DB
      }).eq('id', user.id);

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      debugPrint("Update error: $e");
    }
  }

  @override
  void dispose() { _controller?.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          CameraPreview(_controller!),
          // AI Frame
          Container(
            width: 250, height: 320,
            decoration: BoxDecoration(
              border: Border.all(color: _isFaceDetected ? Colors.greenAccent : Colors.redAccent, width: 4),
              borderRadius: BorderRadius.circular(150),
            ),
          ),
          Positioned(
            bottom: 50,
            child: Column(
              children: [
                Text(
                  _isFaceDetected ? "AI GENDER: $_detectedGender" : "SCANNING FACE...",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isFaceDetected ? _completeVerification : null,
                  child: Text(_isFaceDetected ? "CONFIRM & CLAIM 100 KARMA" : "PROCESSING..."),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}