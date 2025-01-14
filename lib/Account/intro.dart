import 'package:flutter/material.dart';
import 'login.dart'; // Ensure this file exists and has the LoginScreen widget

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF202124), // Updated black color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Image.asset(
              'assets/skoolinq logo2.png',
              width: screenWidth * 0.5, // Scaled dynamically
              height: screenWidth * 0.5, // Maintain aspect ratio
            ),

            // Subtitle
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.02),
              child: Text(
                'Connect Learn Succeed',
                style: TextStyle(
                  fontSize: screenHeight * 0.025, // Adjust font size
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.1),

            // Get Started Button
            SizedBox(
              width: screenWidth * 0.6,
              height: screenHeight * 0.06,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to LoginScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF176ADA), // Updated blue color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: const BorderSide(color: Colors.white, width: 2),
                ),
                child: Text(
                  'Get Started  >',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenHeight * 0.02, // Adjust font size
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            // Sign-in Link
            GestureDetector(
              onTap: () {
                print('Sign in tapped');
              },
              child: Text(
                'Already have an account?\nWelcome Back!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenHeight * 0.018, // Adjust font size
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
