import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skoolinq_project/Services/dbservice.dart';
import 'package:skoolinq_project/Services/loading.dart';

import 'package:skoolinq_project/mentors/chatui.dart';


class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isMentorSelected = true;
  TextEditingController searchController = TextEditingController();
  List<String> mentors = List.generate(10, (index) => 'Mentor ${index + 1}');
  List<String> students = List.generate(10, (index) => 'Student ${index + 1}');
  List<String> filteredMentors = [];
  List<String> filteredStudents = [];
  late Timer updateTimer; // Timer for simulated updates

  @override
  void initState() {
    super.initState();
    filteredMentors = mentors;
    filteredStudents = students;

    // Update filtered list based on search input
    searchController.addListener(() {
      filterList();
    });

    // Simulate real-time updates
    updateTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      _simulateNewJoiner();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    updateTimer.cancel();
    super.dispose();
  }

  // Filter the list based on the search query
  void filterList() {
    setState(() {
      if (searchController.text.isEmpty) {
        filteredMentors = mentors;
        filteredStudents = students;
      } else {
        filteredMentors = mentors
            .where((mentor) => mentor
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
        filteredStudents = students
            .where((student) => student
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
      }
    });
  }

  // Simulate a new mentor or student joining
  void _simulateNewJoiner() {
    setState(() {
      if (isMentorSelected) {
        mentors.add('Mentor ${mentors.length + 1}');
        filteredMentors = mentors;
      } else {
        students.add('Student ${students.length + 1}');
        filteredStudents = students;
      }
    });
  }

  DBService dbService = DBService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return StreamBuilder(
        stream: dbService.checkDocument(user!.uid),
        builder: (context, snapshota) {
          if (!snapshota.hasData) return Loading();

          DocumentSnapshot document = snapshota.data;
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          return Scaffold(
              backgroundColor: Color(0xFF343434),

              body: StreamBuilder(
                  stream: dbService.users(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Loading();
                    QuerySnapshot querySnapshot = snapshot.data;
                    List<DocumentSnapshot> users = querySnapshot.docs;

                    return SafeArea(child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Chats ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          // Tabs for "Mentors" and "Students"
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> usersdata =
                                    users[index].data() as Map<String, dynamic>;
                                return data["accepted"]
                                        .contains(usersdata["uid"])
                                    ? InkWell(
                                        onTap: () {
                                          List docc=[user!.uid,usersdata["uid"]];
                                          docc.sort();
                                          String combinedString = docc.join("");
                                          print(combinedString);
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatUI(groupName: combinedString,name:usersdata["name"])));
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.all(15),
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                  child: usersdata["role"] ==
                                                          "Student"
                                                      ? Text("S")
                                                      : Text("M")),
                                              title: Text(
                                                usersdata["name"],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )))
                                    : SizedBox();
                              })
                        ],
                      ),
                    )
                    );
                  }));
        });
  }
}
