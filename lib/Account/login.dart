import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skoolinq_project/Services/authService.dart';
import 'otp.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
  final _auth=FirebaseAuth.instance;
  String? _verificationId;
  String formatPhoneNumber(String phone) {
    if (!phone.startsWith("+")) {
      // Example: Default to India country code (+91) if missing
      return "+91$phone";
    }
    return phone;
  }
  Future<void> _sendOtp() async {
    String phoneNumber = _phoneController.text.trim();

    if (phoneNumber.length == 10 && RegExp(r'^[0-9]+$').hasMatch(phoneNumber)) {
      final formattedPhone = formatPhoneNumber(_phoneController.text.trim());

      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Automatically signs in on Android devices
          await _auth.signInWithCredential(credential);
          print("Phone number automatically verified and user signed in.");
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OptScreen(verifyId: _verificationId!),
            ),
          );
          print("Code sent to ${_phoneController.text}");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Code auto retrieval timeout");
          setState(() {
            _verificationId = verificationId;
          });
        },
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF202124),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title text
            Text(
              "Enter your mobile number",
              style: TextStyle(
                color: Colors.white,
                fontSize: screenHeight * 0.022,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Phone number input
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "+91",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenHeight * 0.02,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: 'Enter your number',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),

            // "or" separator
            Row(
              children: [
                Expanded(
                  child: Divider(color: Colors.white.withOpacity(0.5)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                  child: Text(
                    "or",
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                ),
                Expanded(
                  child: Divider(color: Colors.white.withOpacity(0.5)),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),

            // Continue with Google
            ElevatedButton.icon(
              onPressed: () async{
                await AuthService().signInWithGoogle(context: context);

              },
              icon: Image.asset(
                'assets/google.png',
                width: screenHeight * 0.03,
                height: screenHeight * 0.03,
              ),
              label: Text(
                "Continue with Google",
                style: TextStyle(fontSize: screenHeight * 0.018),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),

            // Continue with LinkedIn
            ElevatedButton.icon(
              onPressed: () {
                print("Continue with LinkedIn tapped");
              },
              icon: Image.asset(
                'assets/LN.png',
                width: screenHeight * 0.03,
                height: screenHeight * 0.03,
              ),
              label: Text(
                "Continue with LinkedIn",
                style: TextStyle(fontSize: screenHeight * 0.018),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            // Send OTP button
            SizedBox(
              height: screenHeight * 0.06,
              child: ElevatedButton(
                onPressed: _sendOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF176ADA),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: const BorderSide(color: Colors.white, width: 2),
                ),
                child: Text(
                  "Send OTP",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenHeight * 0.02,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

