import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TesFirestore extends StatefulWidget {
  const TesFirestore({super.key});

  @override
  State<TesFirestore> createState() => _TestFirestoreState();
}

class _TestFirestoreState extends State<TesFirestore> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _addUserToFirestore(); // Add user to Firestore when the widget initializes
  }

  // Function to add user data to Firestore
  Future<void> _addUserToFirestore() async {
    final user = <String, dynamic>{
      "first": "Ada",
      "last": "Lovelace",
      "born": 1815
    };

    try {
      // Add a new document with a generated ID
      DocumentReference docRef = await db.collection("users").add(user);
      print('DocumentSnapshot added with ID: ${docRef.id}'); // Log the document ID
    } catch (e) {
      print('Error adding document: $e'); // Handle any errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Firestore"),
      ),
      body: const Center(
        child: Text("User added to Firestore."),
      ),
    );
  }
}
