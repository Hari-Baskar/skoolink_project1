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
            .where((mentor) =>
            mentor
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
        filteredStudents = students
            .where((student) =>
            student
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
          Map<String, dynamic> mentor = document.data() as Map<String, dynamic>;
          return Scaffold(
              backgroundColor: Color(0xFF202124),
              appBar: AppBar(
                backgroundColor: Color(0xFF202124),
                title: Text(
                  'Chats',
                  style: TextStyle(color: Colors.white),
                ),

              ),
              body: StreamBuilder(
                  stream: dbService.users(), builder: (context, snapshot) {
                if (!snapshot.hasData) return Loading();
                QuerySnapshot querySnapshot = snapshot.data;
                List<DocumentSnapshot> documents = querySnapshot.docs;

                return SingleChildScrollView(child: Column(
                  children: [
                    /* Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          hintText: 'Search',
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.2)),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    ),*/
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data = documents[index]
                            .data() as Map<String, dynamic>;
                        print(data["uid"]);
                        return mentor['requested'].contains(data["uid"])
                            ? InkWell(
                            onTap: () async {
                              await FirebaseFirestore.instance.collection(
                                  "users").doc(user!.uid).update({
                                "requested": FieldValue.arrayRemove(
                                    [data["uid"]]),
                                "accepted": FieldValue.arrayUnion(
                                    [data["uid"]]),
                              });
                              await FirebaseFirestore.instance.collection(
                                  "users").doc(data["uid"]).update({
                                "accepted": FieldValue.arrayUnion([user!.uid])
                              });
                              List docc = [data["uid"], user!.uid];
                              docc.sort();

                              // Combine all elements into a single string
                              String combinedString = docc.join("");
                              await FirebaseFirestore.instance.collection(
                                  combinedString);
                            },
                            child: ListTile(
                              leading: Icon(Icons.group, color: Colors.white),
                              title: Text(
                                data["name"]!,
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                "Status: Requested",
                                style: TextStyle(color: Colors.white),
                              ),

                            ))
                            : mentor["accepted"].contains(data["uid"])
                            ? InkWell(
                            onTap: () {},
                            child: ListTile(
                              leading: Icon(Icons.group, color: Colors.white),
                              title: Text(
                                data["name"]!,
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                "Status: Accepted",
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                // Navigate to the chat screen when a group is tapped
                                List docc = [data["uid"], user!.uid];
                                docc.sort();

                                // Combine all elements into a single string
                                String combinedString = docc.join("");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChatUI(name: data["name"],
                                              groupName: combinedString)
                                  ),
                                );
                              },
                            ))
                            :
                        SizedBox();
                      },
                    ),

                  ],
                )
                );
              }
              )
          );
        }
    );
  }

  // Filter Dialog


  // Status Dialog

}