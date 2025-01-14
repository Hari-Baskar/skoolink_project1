import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skoolinq_project/Account/checkDocument.dart';

class NextPage extends StatefulWidget {
  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  int? _selectedAvatarIndex; // Track the selected avatar index

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Check if the screen is small (mobile) or large (tablet/desktop)
    bool isSmallScreen = screenWidth < 600;
    final user=Provider.of<User?>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF202124),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(
              isSmallScreen ? 10.0 : 20.0), // Adjust padding for small screens
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            /*  const LabelWithInputBox(label: "Nick Name"),*/
              SizedBox(height: screenHeight * 0.02), // Dynamic spacing
              const LabelText(text: "Choose your avatar to continue journey"),
              SizedBox(height: screenHeight * 0.01), // Dynamic spacing
              AvatarGrid(
                screenWidth: screenWidth,
                selectedAvatarIndex: _selectedAvatarIndex,
                onAvatarSelected: (index) {
                  setState(() {
                    _selectedAvatarIndex = index; // Update selected avatar
                  });
                },
              ),
              SizedBox(height: screenHeight * 0.02), // Dynamic spacing
             /* const LabelWithInputBox(label: "Password"),
              const LabelWithInputBox(label: "Confirm Password"),*/
              SizedBox(height: screenHeight * 0.02), // Dynamic spacing
            /*  ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BottomBar()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF176ADA), // Inside color
                  side:
                      const BorderSide(color: Colors.white, width: 2), // Border
                  shape: const RoundedRectangleBorder(), // No corner radius
                  padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 50 : 100, vertical: 15),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    fontFamily: 'Inter', // Inter font
                    fontWeight: FontWeight.w600, // Semi-bold weight
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}

class LabelWithInputBox extends StatelessWidget {
  final String label;

  const LabelWithInputBox({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter', // Add Inter font family
              fontWeight: FontWeight.w600, // Semi-bold weight
              fontSize: 18, // Font size 18
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8), // Space between label and input
          Container(
            width: double.infinity, // Make it fill the available width
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white, // Background color white
              borderRadius: BorderRadius.circular(8), // Rounded corners 8
            ),
            child: TextField(
              decoration: const InputDecoration(
                border: InputBorder.none, // Remove border
                contentPadding: EdgeInsets.symmetric(horizontal: 10), // Padding
              ),
              style: const TextStyle(
                color: Colors.black, // Text color inside input field
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LabelText extends StatelessWidget {
  final String text;

  const LabelText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Inter', // Inter font
        fontWeight: FontWeight.w600, // Semi-bold weight
        fontSize: 18, // Font size 18
        color: Colors.white,
      ),
    );
  }
}

class AvatarGrid extends StatelessWidget {
  final double screenWidth;
  final int? selectedAvatarIndex;
  final Function(int) onAvatarSelected;

  const AvatarGrid({
    super.key,
    required this.screenWidth,
    required this.selectedAvatarIndex,
    required this.onAvatarSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Set the avatar size based on the screen width
    double avatarSize = screenWidth < 600 ? 60.0 : 80.0;
    final user=Provider.of<User?>(context);
    return GridView.builder(
      shrinkWrap: true, // Allows the grid to fit within its parent
      physics: const NeverScrollableScrollPhysics(), // Prevents scrolling
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 items per row
        mainAxisSpacing: 10, // Spacing between rows
        crossAxisSpacing: 10, // Spacing between columns
        childAspectRatio: 1, // Ensures items are square
      ),
      itemCount: 6, // Total number of avatars
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async{
            onAvatarSelected(index); // Notify when an avatar is clicked

            await  FirebaseFirestore.instance.collection("users").doc(user!.uid).update({
              "avatarChoosed":true,
              "accepted":[],
              "requested":[],
              "avatar":index+1
            });
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Checkdocument()));
          },
          child: ClipOval(
            child: Image.asset(
              'assets/avatar_${index + 1}.jpg', // Update file extension to .jpg
              fit: BoxFit.cover,
              width: avatarSize, // Dynamic avatar size
              height: avatarSize, // Dynamic avatar size
            ),
          ),
        );
      },
    );
  }
}
