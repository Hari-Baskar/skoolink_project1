import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'avatar.dart'; // Import NextPage

class Class1112Page extends StatefulWidget {
  const Class1112Page({Key? key}) : super(key: key);

  @override
  _Class1112PageState createState() => _Class1112PageState();
}

class _Class1112PageState extends State<Class1112Page> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  String? selectedBoard;
  String? selectedExam;

  final List<String> boards = ['CBSE', 'ICSE', 'State Board'];
  final List<String> exams = ['JEE', 'NEET', 'CUET'];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isSmallScreen = screenWidth < 600;
    final user = Provider.of<User?>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF202124),
      body: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 10.0 : 20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Attach the Form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.05),
                TextFormField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Full name',
                    labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
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
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone number',
                    labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
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
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: schoolNameController,
                  decoration: InputDecoration(
                    labelText: 'School name',
                    labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
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
                SizedBox(height: screenHeight * 0.02),
                const Text(
                  'Date of Birth',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: screenHeight * 0.01),
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
                    SizedBox(width: screenWidth * 0.02),
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
                    SizedBox(width: screenWidth * 0.02),
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
                SizedBox(height: screenHeight * 0.02),
                DropdownButtonFormField<String>(
                  value: selectedBoard,
                  items: boards.map((board) {
                    return DropdownMenuItem(
                      value: board,
                      child: Text(board),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Select Board',
                    filled: true,
                    fillColor: const Color(0xFFD9D9D9),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a board';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      selectedBoard = value;
                    });
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                DropdownButtonFormField<String>(
                  value: selectedExam,
                  items: exams.map((exam) {
                    return DropdownMenuItem(
                      value: exam,
                      child: Text(exam),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Select Exam',
                    filled: true,
                    fillColor: const Color(0xFFD9D9D9),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an exam';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      selectedExam = value;
                    });
                  },
                ),
                SizedBox(height: screenHeight * 0.05),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(user!.uid)
                            .update({
                          "name": fullNameController.text.toLowerCase(),
                          "dob": '${dayController.text}-${monthController.text}-${yearController.text}',
                          "phone": phoneNumberController.text,
                          "schoolName": schoolNameController.text.toLowerCase(),
                          "board": selectedBoard!,
                          "selectedExam": selectedExam!,
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NextPage()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF176ADA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(color: Colors.white, width: 2),
                      minimumSize: Size(isSmallScreen ? 200 : 250, 50),
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
