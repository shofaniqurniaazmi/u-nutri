import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:nutritrack/common/config/env.dart';
import 'dart:io';

import 'package:nutritrack/presentation/pages/detail_kamera2.dart';
import 'package:nutritrack/presentation/widget/laoding_dialog.dart';

class DetailCamera1 extends StatefulWidget {
  final String imagePath;
  final XFile image;

  const DetailCamera1({super.key, required this.imagePath, required this.image});

  @override
  _DetailCamera1State createState() => _DetailCamera1State();
}

class _DetailCamera1State extends State<DetailCamera1> {
  int? selectedPortion;

  Future<String?> _processImageWithGemini(XFile image) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKeyGemini,
    );

    try {
      var response = await model.generateContent({
        Content.multi([
          TextPart("Describe this image:"),
          DataPart("image/jpg", File(image.path).readAsBytesSync())
        ])
      });
      print('Gemini AI response: ${response.text}');
      return response.text;
    } catch (e) {
      print('Error processing image with Gemini: $e');
    }
    return null;
  }

  void handleSubmit() async {
    // LoadingDialog.showLoadingDialog(context, "Loading...");
    String? responseGemini = await _processImageWithGemini(widget.image);
    // LoadingDialog.hideLoadingDialog(context);

    if (selectedPortion != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailCamera2(
            imagePath: widget.imagePath,
            responseGemini: responseGemini!,
            image: widget.image,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Portion Size'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.file(File(widget.imagePath)),
          ),
          Expanded(
            child: ListView(
              children: List.generate(5, (index) {
                int portion = index + 1;
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.purple, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: Text(
                      '$portion Porsi',
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: selectedPortion == portion
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedPortion = portion;
                      });
                      print(selectedPortion);
                      handleSubmit();
                      // Ensure selectedPortion is not null
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}