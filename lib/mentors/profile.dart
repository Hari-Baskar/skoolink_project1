import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:skoolinq_project/Services/authService.dart';
import 'package:skoolinq_project/Services/dbservice.dart';

import '../Services/loading.dart';
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late double divHeight, divWidth;
  DBService dbService=DBService();
  @override
  Widget build(BuildContext context) {
    divHeight = MediaQuery.of(context).size.height;
    divWidth = MediaQuery.of(context).size.width;
    final user = Provider.of<User?>(context);

    return StreamBuilder(
      stream: dbService.checkDocument(user!.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Loading();
        DocumentSnapshot document = snapshot.data;
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Padding(
              padding: EdgeInsets.all(25),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Profile',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                          color: Colors.white,
                            fontSize: divHeight*0.02,
                          ),

                      ),
                    ),
                    SizedBox(height: divHeight * 0.05),
                    CircleAvatar(
                      radius: 65,
                     // backgroundImage: NetworkImage(data["profilePic"]),
                    ),
                    SizedBox(height: divHeight * 0.015),
                    Text(
                      data["name"],
                      style:  TextStyle(
                          fontSize: divHeight*0.017,
                          fontWeight: FontWeight.bold,
                        color: Colors.white
                        ),

                    ),
                    SizedBox(height: divHeight * 0.015),
                    Text(
                     "nsj",
                      style:  TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,

                      ),
                    ),
                    Divider(height: divHeight * 0.05, thickness: 2.0),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Container(
                        width: divWidth * 0.90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              SizedBox(height: divHeight * 0.02),
                              Row(
                                children: [
                                  Icon(Icons.work_history_outlined),
                                  SizedBox(width: divWidth * 0.02),
                                  Text(
                                    "Profession : " +
                                  data["profession"],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                ],
                              ),
                              SizedBox(height: divHeight * 0.03),
                              Row(
                                children: [
                                  Icon(Icons.dialpad_rounded),
                                  SizedBox(width: divWidth * 0.020),
                                  Text(
                                  "Followers : "+ (data["requested"].length+data["accepted"].length).toString(),
                                    style:  TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                ],
                              ),
                              SizedBox(height: divHeight * 0.03),
                           /*   Row(
                                children: [
                                  Icon(data["gender"] == "Male"
                                      ? Icons.male
                                      : data["gender"] == "Female"
                                      ? Icons.female
                                      : Icons.transgender),
                                  SizedBox(width: divWidth * 0.02),
                                  Text(
                                    data["gender"],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,

                                    ),
                                  ),
                                ],
                              ),*/

                              Divider(
                                height: divHeight * 0.04,
                                thickness: 2.0,
                              ),

                             /* InkWell(
                                onTap: () {
                                 // Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
                                  //   Provider.of<ThemeProvider>(context,
                                  //   listen: false)
                                  //     .toggleTheme();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.dark_mode_outlined),
                                    SizedBox(width: divWidth * 0.020),
                                    Text(
                                      "Switch Theme",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,

                                      ),
                                    ),
                                    Spacer(),
                                    Icon(Icons.chevron_right),
                                    SizedBox(width: divWidth * 0.05),
                                  ],
                                ),
                              ),*/
                              SizedBox(height: divHeight * 0.03),
                              InkWell(
                                onTap: () async {
                                  EasyLoading.show(status: "Logging Out");
                                  await AuthService().SignOut();
                                  EasyLoading.dismiss();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.logout_outlined),
                                    SizedBox(width: divWidth * 0.020),
                                    Text(
                                      "Log Out",
                                      style:  TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,

                                      ),
                                    ),
                                    Spacer(),
                                    Icon(Icons.chevron_right),
                                    SizedBox(width: divWidth * 0.05),
                                  ],
                                ),
                              ),
                              SizedBox(height: divHeight * 0.03),
                              /*Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: divWidth * 0.020),
                                  Text(
                                    "Edit Profile",
                                    style:  TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                  Spacer(),
                                  Icon(Icons.chevron_right),
                                  SizedBox(width: divWidth * 0.05),
                                ],
                              ),*/
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}