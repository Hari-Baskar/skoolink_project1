import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skoolinq_project/Services/dbservice.dart';
import 'package:skoolinq_project/Services/loading.dart';
import 'package:rxdart/rxdart.dart';
class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController search = TextEditingController();
  DBService dbService = DBService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return StreamBuilder(
        stream: dbService.checkDocument(user!.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Loading();
          DocumentSnapshot documentSnapshots = snapshot.data;
          Map<String, dynamic> data =
          documentSnapshots.data() as Map<String, dynamic>;
          return Scaffold(
              body: SingleChildScrollView(child:Padding(padding:EdgeInsets.all(15), child:Column(
                children: [
                  SizedBox(height: 100,),
                  TextField(controller: search, decoration: InputDecoration(
                      hintText: "Search mentors , students",
                      border: OutlineInputBorder()
                  ),),
                   TextButton(onPressed: (){
                     setState(() {

                     });
                   }, child: Text('search')),


                   search.text.isEmpty? StreamBuilder(
                      stream: dbService.Mentors(Class: int.parse(data["class"])),
                      builder: (context, mentorSnapshot) {
                        if (!mentorSnapshot.hasData) return Loading();

                        QuerySnapshot mentorQuerySnapshot = mentorSnapshot.data;
                        List<DocumentSnapshot> mentorDocumentSnapshot =
                            mentorQuerySnapshot.docs;
                        print(mentorDocumentSnapshot.length);

                        return ListView.builder(
                          shrinkWrap: true,

                          itemCount:
                          mentorDocumentSnapshot.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> mentors =
                            mentorDocumentSnapshot[index]
                                .data()
                            as Map<String, dynamic>;
                            return !data["accepted"].contains(mentors["uid"])
                                ? Padding(
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
                                              onPressed: () async {
                                                // Handle request action
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                    "users")
                                                    .doc(mentors["uid"])
                                                    .update({
                                                  "requested": FieldValue
                                                      .arrayUnion([
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
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        child: Text(
                                            mentors["name"][0]),
                                        radius: screenWidth *
                                            0.08, // Adjust for screen size
                                      ),
                                      SizedBox(height: 5),
                                      Column(children:[
                                      Text(
                                        mentors['name'],
                                        style: TextStyle(
                                            ),
                                      ),
                                        Text(
                                          mentors['profession'],
                                          style: TextStyle(
                                              ),
                                        ),
                                        ]
                                      ),
                                    ],
                                  ),
                                ))
                                : SizedBox();
                          },
                        );
                      }
                  ):
                   StreamBuilder(
                       stream: dbService.search(search.text.toString()),
                       builder: (context, searchSnapshot) {
                         if (!searchSnapshot.hasData) return Loading();

                         final searchDocumentSnapshot = searchSnapshot.data?? [];

                         print(searchDocumentSnapshot.length);
                         return ListView.builder(
                           shrinkWrap: true,

                           itemCount:
                           searchDocumentSnapshot.length,
                           itemBuilder: (context, index) {
                             Map<String, dynamic> searchdata =
                             searchDocumentSnapshot[index]

                             as Map<String, dynamic>;
                             return data["uid"]!=searchdata["uid"]
                                 ? Padding(
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
                                               searchdata["name"]),
                                           content: Text(
                                               'Do you want to request ${searchdata['name']}'),
                                           actions: [
                                             TextButton(
                                               onPressed: () async {
                                                 // Handle request action
                                                 await FirebaseFirestore.instance
                                                     .collection(
                                                     "users")
                                                     .doc(searchdata["uid"])
                                                     .update({
                                                   "requested": FieldValue
                                                       .arrayUnion([
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
                                   child: Row(
                                     children: [
                                       CircleAvatar(
                                         child: Text(
                                             searchdata["name"][0]),
                                         radius: screenWidth *
                                             0.08, // Adjust for screen size
                                       ),
                                       SizedBox(height: 5),
                                       Column(children:[
                                         Text(
                                           searchdata['name'],
                                           style: TextStyle(
                                           ),
                                         ),
                                         Text(
                                           searchdata['profession']==null ? " ":"nx",
                                           style: TextStyle(
                                           ),
                                         ),
                                       ]
                                       ),
                                     ],
                                   ),
                                 ))
                                 : SizedBox();
                           },
                         );
                       }
                   )

                ],
              )
          )
              )
          );
        }
    );
  }
}

