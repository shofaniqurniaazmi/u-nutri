import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutritrack/common/assets/assets.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0), // Hide the app bar
        child: AppBar(
          backgroundColor: Colors.transparent, // Make app bar transparent
          elevation: 0, // Remove app bar elevation
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              welcomeImage, // Ensure this path is correct
              fit: BoxFit.cover,
            ),
          ),
          // Purple transparent container at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200, // Adjust the height as needed
              decoration: BoxDecoration(
                color: const Color(0xFF670274)
                    .withOpacity(0.8), // Purple color with opacity
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), // Rounded top left corner
                  topRight: Radius.circular(30), // Rounded top right corner
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome to',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'NutriTrack',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Make information about the food you are going to eat!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () => context.go('/login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.white, // Update to backgroundColor
                          foregroundColor:
                              const Color(0xFF670274), // Update to foregroundColor
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            color: Color(0xFF670274),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
