import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarTypeScreen extends StatelessWidget {
  const CarTypeScreen({super.key});

  // Function to get car type from Firestore
  Future<String> _getCarType() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          return data['car_type'] ?? data['carName'] ?? 'Unknown Car';
        } else {
          return 'No car data found';
        }
      } catch (e) {
        return 'Error: $e';
      }
    }
    return 'User not logged in';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Information'),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: _getCarType(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // While loading
            } else if (snapshot.hasError) {
              return const Text('An error occurred while fetching data');
            } else if (snapshot.hasData) {
              return Text(
                'Car Type: ${snapshot.data}',
                style: const TextStyle(fontSize: 20),
              );
            } else {
              return const Text('No data available');
            }
          },
        ),
      ),
    );
  }
}
