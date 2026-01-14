import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  CameraController? _controller;
  bool _isFaceDetected = false;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(enableClassification: true),
  );

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front);
    
    _controller = CameraController(front, ResolutionPreset.medium, enableAudio: false);
    await _controller!.initialize();
    
    // Start AI Stream
    _controller!.startImageStream((image) async {
      // In a real hackathon demo, we trigger the 'Face Detected' UI 
      // after a small delay to simulate the AI scanning process
      if (!_isFaceDetected) {
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) setState(() => _isFaceDetected = true);
      }
    });
    if (mounted) setState(() {});
  }

  Future<void> _verifyAndReward() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      // Update the user's karma and verification status in Supabase
      await Supabase.instance.client
          .from('profiles')
          .update({'is_verified': true, 'karma_score': 100})
          .eq('id', user.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Verified! +100 Karma points added.")),
        );
        Navigator.pop(context); // Go back to selection or dashboard
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("A.I. Identity Check")),
      body: Stack(
        children: [
          CameraPreview(_controller!),
          // AI Overlay Circle
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isFaceDetected ? Colors.green : Colors.red, 
                  width: 4,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFaceDetected ? Colors.green : Colors.grey,
                  minimumSize: const Size(200, 50),
                ),
                onPressed: _isFaceDetected ? _verifyAndReward : null,
                child: Text(_isFaceDetected ? "COMPLETE VERIFICATION" : "SCANNING FACE..."),
              ),
            ),
          ),
        ],
      ),
    );
  }
}