import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

import 'package:nutritrack/common/config/storage.dart';
import 'package:nutritrack/service/firebase/authentication_service.dart';

class UserClassificationNext extends StatefulWidget {
  const UserClassificationNext({super.key});

  @override
  _UserClassificationNextState createState() => _UserClassificationNextState();
}

class _UserClassificationNextState extends State<UserClassificationNext> {
  // Controllers for the text fields
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final AuthenticationService _firebaseAuth = AuthenticationService();
  late String clasification;

  // Variable to manage the selected gender
  String? _selectedGender;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = GoRouterState.of(context);
    final selected = state.uri.queryParameters['selected'] ?? '';
    print(
        'Selected classifications in user classification 2 $selected');
    clasification = selected;
  }

  void handleSubmitClasification() async {
    final weight = double.tryParse(_weightController.text) ?? 0.0;
    final height = double.tryParse(_heightController.text) ?? 0.0;
    final age = int.tryParse(_ageController.text) ?? 0;
    final userId =
        await SecureStorage().getUserId(); // Await the Future<String?>

    if (weight > 0 &&
        height > 0 &&
        age > 0 &&
        _selectedGender != null &&
        userId != null) {
      await _firebaseAuth.submitUserClassification(
        userId: userId,
        weight: weight,
        height: height,
        classification: clasification,
        age: age,
        gender: _selectedGender!,
        context: context,
      );
      _showSuccessDialog(context);
    } else {
      print('Please fill out all fields correctly or userId is null.');
      // Optionally, show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: const Color(0xFF670274), // Purple background color
            child: const Text(
              'Determine Your Goal!!!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFormField('Berat Badan (kg)', _weightController),
                  const SizedBox(height: 20.0),
                  _buildFormField('Tinggi Badan (cm)', _heightController),
                  const SizedBox(height: 20.0),
                  _buildFormField('Usia', _ageController),
                  const SizedBox(height: 20.0),
                  _buildGenderField(),
                  const SizedBox(height: 50.0),
                  ElevatedButton(
                    onPressed: () {
                      print('bb : ${_weightController.text}');
                      print('tb : ${_heightController.text}');
                      print('age : ${_ageController.text}');
                      print('gender : ${_selectedGender!}');
                      print(
                          'Selected classifications in user classification 2 $clasification');
                      handleSubmitClasification();
                      // _showSuccessDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Green button color
                      padding:
                          const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Simpan',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () {
                      context.go('/user-clasification');
                    },
                    child: const Text('Kembali ke user Classification'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 100,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 50,
                ),
                SizedBox(height: 10),
                Text('Berhasil Disimpan'),
              ],
            ),
          ),
        );
      },
    );

    Timer(const Duration(seconds: 3), () {
      context.go('/home');
    });
  }

  Widget _buildFormField(String label, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[300], // Gray box color
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        controller: controller,
        keyboardType:TextInputType.number,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
        ),
      ),
    );
  }

  Widget _buildGenderField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[300], // Gray box color
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          border: InputBorder.none,
          labelText: 'Gender',
        ),
        value: _selectedGender,
        items: ['Male', 'Female'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedGender = newValue;
          });
        },
      ),
    );
  }
}
