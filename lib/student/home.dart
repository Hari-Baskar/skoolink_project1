
import 'dart:convert';

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:skoolinq_project/Account/intro.dart';
import 'package:skoolinq_project/Services/authService.dart';
import 'package:skoolinq_project/Services/dbservice.dart';
import 'package:skoolinq_project/Services/loading.dart';
// Simulate server requests

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedFilterIndex = 0;
  //List<String> myPosts = [];
 // List<String> otherPosts = [];
  //List<Map<String, dynamic>> mentors = [];

  TextEditingController postController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }



  DBService dbService = DBService();

  @override
  Widget build(BuildContext context) {
    // Get screen width and height using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final user = Provider.of<User?>(context);
    return StreamBuilder(
        stream: dbService.checkDocument(user!.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Loading();
          DocumentSnapshot documentSnapshots = snapshot.data;
          Map<String, dynamic> data =
              documentSnapshots.data() as Map<String, dynamic>;
          return StreamBuilder(
              stream: dbService.posts(),
              builder: (context, snapshots) {
                if (!snapshots.hasData) return Loading();

                QuerySnapshot querySnapshot = snapshots.data;
                List<DocumentSnapshot> documentSnapshot = querySnapshot.docs;

                return StreamBuilder(
                    stream: dbService.Mentors(Class:data["class"]),
                    builder: (context, mentorSnapshot) {
                      if (!mentorSnapshot.hasData) return Loading();

                      QuerySnapshot mentorQuerySnapshot = mentorSnapshot.data;
                      List<DocumentSnapshot> mentorDocumentSnapshot =
                          mentorQuerySnapshot.docs;

                      return Scaffold(
                        appBar: AppBar(
                          backgroundColor: Color(0xFF176ADA),
                          title: InkWell(
                            onTap: () async {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>IntroScreen()));
                              await AuthService().SignOut();

                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: screenWidth * 0.02),
                                // Adjust based on screen size
                                CircleAvatar(
                                  backgroundImage: AssetImage(
                                      "assets/avatar_${data["avatar"]}.jpg"),
                                  backgroundColor: Colors.grey,
                                  child:
                                      Icon(Icons.person, color: Colors.white),
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  "WELCOME!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          centerTitle: true,
                          /*actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search),
                ),
              ],*/
                          automaticallyImplyLeading: false,
                        ),
                        body: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              color: Colors.black,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Mentor Connect",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  // Adjust for dynamic spacing
                                  Container(
                                    height: screenHeight * 0.15,
                                    // Adjust height based on screen size
                                    child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              mentorDocumentSnapshot.length,
                                          itemBuilder: (context, index) {
                                            Map<String, dynamic> mentors =
                                                mentorDocumentSnapshot[index]
                                                        .data()
                                                    as Map<String, dynamic>;
                                            return !data["accepted"].contains(mentors["uid"]) ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Request Mentor'),
                                                          content: Text(
                                                              'Do you want to request this mentor?'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () async{
                                                                // Handle request action
                                                                await FirebaseFirestore.instance.collection("users").doc(mentors["uid"]).update({
                                                                  "requested":FieldValue.arrayUnion([
                                                                    user!.uid
                                                                  ])
                                                                });
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(); // Close the dialog
                                                              },
                                                              child: Text(
                                                                  'Request'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                // Handle cancel action
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(); // Close the dialog
                                                              },
                                                              child: Text(
                                                                  'Cancel'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Column(
                                                    children: [
                                                      CircleAvatar(
                                                        child: Text(
                                                            mentors["name"][0]),
                                                        radius: screenWidth *
                                                            0.08, // Adjust for screen size
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        mentors['name'],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                )):SizedBox();
                                          },
                                        )

                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.black,
                                child: Column(
                                  children: [
                                    Text(
                                      "POSTS",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        FilterButton(
                                          label: "ALL",
                                          isSelected: selectedFilterIndex == 0,
                                          onTap: () => setState(
                                              () => selectedFilterIndex = 0),
                                        ),
                                        FilterButton(
                                          label: "POSTED BY ME",
                                          isSelected: selectedFilterIndex == 1,
                                          onTap: () => setState(
                                              () => selectedFilterIndex = 1),
                                        ),
                                        FilterButton(
                                          label: "POSTED BY OTHERS",
                                          isSelected: selectedFilterIndex == 2,
                                          onTap: () => setState(
                                              () => selectedFilterIndex = 2),
                                        ),
                                      ],
                                    ),
                                    selectedFilterIndex == 0
                                        ? Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  documentSnapshot.length,
                                              itemBuilder: (context, index) {
                                                Map<String, dynamic> data =
                                                    documentSnapshot[index]
                                                            .data()
                                                        as Map<String, dynamic>;

                                                return PostCard(
                                                  username: data['postedBy'],
                                                  content: data["post"], img: data["postImg"],
                                                );
                                              },
                                            ),
                                          )
                                        : selectedFilterIndex == 1
                                            ? Expanded(
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      documentSnapshot.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    Map<String, dynamic> data =
                                                        documentSnapshot[index]
                                                                .data()
                                                            as Map<String,
                                                                dynamic>;

                                                    if (user!.uid ==
                                                        data["uid"]) {
                                                      return PostCard(
                                                        username:
                                                            data['postedBy'],
                                                        content: data["post"], img: data["postImg"],
                                                      );
                                                    } else {
                                                      return SizedBox();
                                                    }
                                                  },
                                                ),
                                              )
                                            : Expanded(
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      documentSnapshot.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    Map<String, dynamic> data =
                                                        documentSnapshot[index]
                                                                .data()
                                                            as Map<String,
                                                                dynamic>;

                                                    if (user!.uid !=
                                                        data["uid"]) {
                                                      return PostCard(
                                                        username:
                                                            data['postedBy'],
                                                        content: data["post"], img: data["postImg"],

                                                      );
                                                    } else {
                                                      return SizedBox();
                                                    }
                                                  },
                                                ),
                                              )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              });
        });
  }
  PostCard({
    required String username,
    required String content,
    required String img,
  })

  {
    return Card(
      color: Colors.blue[900],
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFF003366), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text("mk"),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  username,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 10),
            if (RegExp(r'^[A-Za-z0-9+/]+={0,2}$').hasMatch(img))
              Builder(
                builder: (context) {
                  try {
                    return Image.memory(base64Decode(img),);
                  } catch (e) {
                    print("Error decoding image: $e");
                    return SizedBox.shrink(); // Show nothing or a placeholder
                  }
                },
              )
            else
              SizedBox.shrink(),

            Text(
              content,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.thumb_up, color: Colors.white),
                Icon(Icons.share, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );

  }

}

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  FilterButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF176ADA) : Colors.grey,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}

