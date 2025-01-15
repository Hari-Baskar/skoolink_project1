import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skoolinq_project/Services/dbservice.dart';
import 'package:skoolinq_project/Services/loading.dart';
import 'chatui.dart'; // Import the chat screen

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {


  String filter = "All";
  String searchQuery = "";
  List<Map<String, String>> groups = [
    {"name": "Student 1", "status": "Accepted"},
    {"name": "Student 2", "status": "Requested"},
    {"name": "Student 3", "status": "Accepted"},
  ];
  DBService dbService = DBService();

  @override
  Widget build(BuildContext context) {
    // Filter groups based on search query

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
                          return mentor['requested'].contains(data["uid"]) ?InkWell(
                              onTap:()async {
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
                              child:ListTile(
                            leading: Icon(Icons.group, color: Colors.white),
                            title: Text(
                              data["name"]!,
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              "Status: Requested",
                              style: TextStyle(color: Colors.white),
                            ),

                          )) : mentor["accepted"].contains(data["uid"])  ?  InkWell(
                              onTap: (){},
                              child:ListTile(
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
                                     ChatUI(name: data["name"], groupName: combinedString)
                                ),
                              );
                            },
                          )) :
                          SizedBox() ;
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
  void _showFilterDialog() {
    showModalBottomSheet(
      backgroundColor: Color(0xFF393640),
      context: context,
      builder: (context) {
        return ListView(
          children: [
            ListTile(
              title: Text(
                "All",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                setState(() {
                  filter = "All";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                "View the Status",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                //  _showStatusDialog();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Status Dialog
  void _showStatusDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF393640),
          title: Text(
            "Group Status",
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: groups
                .map((group) =>
                ListTile(
                  title: Text(
                    group["name"]!,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    group["status"]!,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Close",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
