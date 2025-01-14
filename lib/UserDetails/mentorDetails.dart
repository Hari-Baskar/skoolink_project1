import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'class.dart'; // Import the Avatar page (NextPage)

class MentorDetails extends StatefulWidget {
  const MentorDetails({super.key});

  @override
  State<MentorDetails> createState() => _MentorDetailsState();
}

class _MentorDetailsState extends State<MentorDetails> {


  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  String? selectedBoard;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final user=Provider.of<User?>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF202124),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05), // Dynamic padding based on screen width
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.1), // Dynamic top spacing
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full name',
                  labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  fillColor: const Color(0xFFD9D9D9),
                  filled: true,
                  border: const OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              SizedBox(height: screenHeight * 0.03), // Dynamic spacing
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Profession',
                  labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  fillColor: const Color(0xFFD9D9D9),
                  filled: true,
                  border: const OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.black),

              ),
              SizedBox(height: screenHeight * 0.03), // Dynamic spacing

              
              SizedBox(height: screenHeight * 0.05), // Dynamic spacing before button
              Center(
                child: ElevatedButton(
                  onPressed: () async{
                    // Navigate to the Avatar Page (NextPage)
                    await FirebaseFirestore.instance.collection("users").doc(user!.uid).update({
                      "name":fullNameController.text.toString().toLowerCase(),

                          "profession":phoneNumberController.text.toString().toLowerCase(),
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ClassSelectorPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF176ADA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(color: Colors.white, width: 2),
                    minimumSize: Size(screenWidth * 0.7,
                        screenHeight * 0.08), // Dynamic button size
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
