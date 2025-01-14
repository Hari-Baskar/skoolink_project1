import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skoolinq_project/Account/intro.dart';
import 'package:skoolinq_project/Services/authService.dart';
import 'package:skoolinq_project/Services/dbservice.dart';
import 'package:skoolinq_project/Services/loading.dart';
class MentorHomePage extends StatefulWidget {
  const MentorHomePage({super.key});

  @override
  State<MentorHomePage> createState() => _MentorHomePageState();
}

class _MentorHomePageState extends State<MentorHomePage> {


  // List<String> otherPosts = [];
  //List<Map<String, dynamic>> mentors = [];

  TextEditingController postController = TextEditingController();
  int selectedFilterIndex = 0;
  @override
  void initState() {
    super.initState();

  }



  DBService dbService = DBService();
late double screenHeight,screenWidth;
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

                return  Scaffold(
                  backgroundColor: Colors.black,
                        appBar: AppBar(
                          automaticallyImplyLeading: false,

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
                        ),
                        body: Column(
                           crossAxisAlignment: CrossAxisAlignment.center,
                          children:[
                            Container(
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
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        FilterButton(
                                          labels: "ALL",
                                          isSelected: selectedFilterIndex == 0,
                                          onTap: () => setState(
                                                  () => selectedFilterIndex = 0),
                                        ),
                                        FilterButton(
                                          labels: "POSTED BY ME",
                                          isSelected: selectedFilterIndex == 1,
                                          onTap: () => setState(
                                                  () => selectedFilterIndex = 1),
                                        ),
                                        FilterButton(
                                          labels: "POSTED BY OTHERS",
                                          isSelected: selectedFilterIndex == 2,
                                          onTap: () => setState(
                                                  () => selectedFilterIndex = 2),
                                        ),
                                      ],
                                    ),
                                    ]
                                )),
                                    selectedFilterIndex == 0
                                        ? Expanded(child: ListView.builder(
                                     // physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount:
                                        documentSnapshot.length,
                                        itemBuilder: (context, index) {
                                          Map<String, dynamic> data =
                                          documentSnapshot[index]
                                              .data()
                                          as Map<String, dynamic>;
                                          print(data);
                                          return PostCard(
                                            username: data['postedBy'],
                                            content: data["post"],
                                            img: data["postImg"],

                                          );
                                        },
                                      )
                                    )


                                        : selectedFilterIndex == 1
                                        ?  Expanded(child: ListView.builder(
                                      //physics: NeverScrollableScrollPhysics(),
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
                                              content: data["post"],
                                              img: data["postImg"],
                                            );
                                          } else {
                                            return SizedBox(

                                            );
                                          }
                                        },
                                    )
                                      )

                                        : Expanded(child: ListView.builder(
                                      //physics: NeverScrollableScrollPhysics(),
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
                                            return SizedBox(

                                            );
                                          }
                                        },
                                      ),
                                    )

                                  ],
                                ),




                      );
                    });
              });

  }
  FilterButton({
    required String labels,
    required bool isSelected,
    required final VoidCallback onTap,
}){
    return  Padding(padding:EdgeInsets.symmetric(horizontal: 2), child:InkWell(
        onTap: onTap,
        child: Chip(
          backgroundColor:isSelected ?  Color(0xFF176ADA) : Colors.grey,
            label:Text(labels,style: TextStyle(
              color: isSelected  ?  Colors.white: Colors.black,
            ),))

    ));

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



