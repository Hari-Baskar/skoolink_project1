import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skoolinq_project/UserDetails/avatar.dart';
// Replace with actual import

class Class910 extends StatefulWidget {
  const Class910({super.key});

  @override
  State<Class910> createState() => _Class910State();
}

class _Class910State extends State<Class910> {


  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  String? selectedBoard;

  final _formKey = GlobalKey<FormState>(); // Key for form validation

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final user = Provider.of<User?>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF202124),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        // Dynamic padding based on screen width
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Assign form key to manage validation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.1),
                // Dynamic top spacing

                // Full name field
                TextFormField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Full name',
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0)),
                    fillColor: const Color(0xFFD9D9D9),
                    filled: true,
                    border: const OutlineInputBorder(),
                  ),
                  style: const TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Full name cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.03),
                // Dynamic spacing

                // Phone number field
                TextFormField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone number',
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0)),
                    fillColor: const Color(0xFFD9D9D9),
                    filled: true,
                    border: const OutlineInputBorder(),
                  ),
                  style: const TextStyle(color: Colors.black),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.03),
                // Dynamic spacing

                // School name field
                TextFormField(
                  controller: schoolNameController,
                  decoration: InputDecoration(
                    labelText: 'School name',
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0)),
                    fillColor: const Color(0xFFD9D9D9),
                    filled: true,
                    border: const OutlineInputBorder(),
                  ),
                  style: const TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'School name cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.03),
                // Dynamic spacing

                const Text(
                  'Date of Birth',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: screenHeight * 0.02),
                // Dynamic spacing

                // Date of Birth fields
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: dayController,
                        decoration: InputDecoration(
                          hintText: 'DD',
                          hintStyle: const TextStyle(color: Colors.black54),
                          fillColor: const Color(0xFFD9D9D9),
                          filled: true,
                          border: const OutlineInputBorder(),
                        ),
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Day cannot be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03), // Dynamic spacing
                    Expanded(
                      child: TextFormField(
                        controller: monthController,
                        decoration: InputDecoration(
                          hintText: 'MM',
                          hintStyle: const TextStyle(color: Colors.black54),
                          fillColor: const Color(0xFFD9D9D9),
                          filled: true,
                          border: const OutlineInputBorder(),
                        ),
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Month cannot be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03), // Dynamic spacing
                    Expanded(
                      child: TextFormField(
                        controller: yearController,
                        decoration: InputDecoration(
                          hintText: 'YYYY',
                          hintStyle: const TextStyle(color: Colors.black54),
                          fillColor: const Color(0xFFD9D9D9),
                          filled: true,
                          border: const OutlineInputBorder(),
                        ),
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Year cannot be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                // Dynamic spacing

                const Text(
                  'Board of Education',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: screenHeight * 0.02),
                // Dynamic spacing

                // Dropdown for Board of Education
                DropdownButtonFormField<String>(
                  value: selectedBoard,
                  items: ['CBSE', 'ICSE', 'STATE BOARD']
                      .map((board) =>
                      DropdownMenuItem(
                        value: board,
                        child: Text(
                          board,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBoard = value;
                    });
                  },
                  decoration: InputDecoration(
                    fillColor: const Color(0xFFD9D9D9),
                    filled: true,
                    border: const OutlineInputBorder(),
                    hintText: 'Select Board',
                    hintStyle: const TextStyle(color: Colors.black54),
                  ),
                  dropdownColor: const Color(0xFFD9D9D9),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a board';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.05),
                // Dynamic spacing before button

                // Continue Button
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // All fields are valid, proceed with the update
                        await FirebaseFirestore.instance.collection("users")
                            .doc(user!.uid)
                            .update({
                          "name": fullNameController.text.toString().toLowerCase(),
                          "dob": dayController.text.toString() + "-" +
                              monthController.text.toString() + "-" +
                              yearController.text.toString(),
                          "phone": phoneNumberController.text.toString(),
                          'schoolName': schoolNameController.text.toString().toLowerCase(),
                          "board": selectedBoard!.toString()

                          // Example of updating a value in Firestore
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              NextPage()), // Replace with actual next page
                        );
                      }
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
      ),
    );
  }
}

