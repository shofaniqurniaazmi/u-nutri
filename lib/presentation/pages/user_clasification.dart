import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutritrack/common/assets/assets.dart';

class UserClassificationScreen extends StatefulWidget {
  const UserClassificationScreen({super.key});

  @override
  _UserClassificationScreenState createState() =>
      _UserClassificationScreenState();
}

class _UserClassificationScreenState extends State<UserClassificationScreen> {
  int _selectedIndex = -1; // Track the index of the selected classification
  String _selectedClassification = ''; // Store the selected classification

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Classification'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildGridButton(context, ibuHamilImage, 'Ibu Hamil', 0),
                  _buildGridButton(context, balitaImage, 'Balita', 1),
                  _buildGridButton(context, dietImage, 'Diet', 2),
                  _buildGridButton(context, bulkingImage, 'Bulking', 3),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                if (_selectedClassification.isNotEmpty) {
                  print('Selected Classification: $_selectedClassification');
                  // Convert the selected classification to a query parameter
                  context.go('/user-clasification2?selected=$_selectedClassification');
                } else {
                  // Optionally, show a message indicating no selection
                  print('No classification selected.');
                }
              },
              child: const Text(
                'Next',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridButton(
      BuildContext context, String imagePath, String text, int index) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedIndex == index
            ? const Color.fromARGB(255, 82, 8, 85)
            : const Color.fromARGB(255, 230, 138, 253),
        shadowColor: Colors.grey,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: () {
        setState(() {
          if (_selectedIndex != index) {
            _selectedIndex = index;
            _selectedClassification = text;
          } else {
            _selectedIndex = -1; // Deselect if the same button is pressed
            _selectedClassification = '';
          }
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: 80,
                width: 80,
              ),
              const SizedBox(height: 10),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (_selectedIndex == index)
            const Positioned(
              top: 8,
              right: 8,
              child: Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }
}
