import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';

// Import MentorHomePage

class WelcomeScreen extends StatefulWidget {
  final List<String> selectedClasses;

  WelcomeScreen({required this.selectedClasses}); // Constructor to accept selected classes

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  File? _profileImage;

  Future<void> _pickImage() async {
   // final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
   /* if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF202124),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF000000), // Black
                  Color(0xFF176ADA), // Blue
                ],
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF176ADA),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2),
              ),
              width: isSmallScreen ? screenWidth * 0.8 : 300,
              height: isSmallScreen ? screenHeight * 0.5 : 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  Text(
                    "Hi, ${_profileImage != null ? 'User' : '[name/avatar]'}!",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                      ),
                      InkWell(
                        onTap: _pickImage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(5),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "Selected Classes:\n${widget.selectedClasses.join(', ')}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD9D9D9),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      // Navigate to the MentorHomePage with selectedClasses

                    },
                    child: const Text("CLICK"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
