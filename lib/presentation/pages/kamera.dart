import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:nutritrack/common/config/env.dart';
import 'package:nutritrack/presentation/pages/detail_kamera1.dart';
import 'package:nutritrack/presentation/widget/laoding_dialog.dart';
import 'package:nutritrack/service/firebase/storage_service.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController? cameraController;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      cameraController = CameraController(cameras[0], ResolutionPreset.max);
      await cameraController!.initialize();
      if (mounted) {
        setState(() {});
      }
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _takePicture() async {
    if (!cameraController!.value.isInitialized) return;

    try {
      final XFile picture = await cameraController!.takePicture();
      setState(() {
        imagePath = picture.path;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailCamera1(imagePath: picture.path, image: picture),
        ),
      );
    } on CameraException catch (e) {
      print('Error taking picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil gambar: $e')),
      );
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
            width: 40.0,
          ),
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Nutri',
              style: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            Text(
              'Track',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: CameraPreview(cameraController!),
                ),
                Positioned.fill(
                  child: Container(
                    color: Colors.purple.withOpacity(0.5), // Semi-transparent purple overlay
                  ),
                ),
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white, // White scanning box
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.image, color: Colors.black),
                  onPressed: () {
                    // Add functionality to pick an image from the gallery
                  },
                ),
                FloatingActionButton(
                  onPressed: _takePicture,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.camera_alt_rounded, color: Colors.purple),
                ),
                IconButton(
                  icon: const Icon(Icons.loop, color: Colors.black),
                  onPressed: () {
                    // Add functionality to flip the camera (front/back)
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
