import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skoolinq_project/Services/dbservice.dart';
import 'package:skoolinq_project/Services/loading.dart';

class ChatUI extends StatefulWidget {
  final String groupName;
  final String name;

  const ChatUI({required this.name, required this.groupName, super.key});

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  DBService dbService = DBService();
  TextEditingController chatTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Scroll to the bottom when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottomInstantly();
    });
  }

  void _scrollToBottomInstantly() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _scrollToBottomSmoothly() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final user = Provider.of<User?>(context);

    return StreamBuilder(
      stream: dbService.chatUsers(widget.groupName),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Loading();

        QuerySnapshot querySnapshot = snapshot.data;
        List<DocumentSnapshot> chatDocuments = querySnapshot.docs;

        // Scroll to the bottom when new data arrives
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottomSmoothly();
        });

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Color(0xFF176ADA),
            title: Text(
              widget.name,
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            leading: IconButton(onPressed: (){Navigator.pop(context);}, icon:Icon(Icons.arrow_back,color: Colors.white,)),
          ),
          body: Column(
            children: [
              // Message list
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: chatDocuments.length,
                  itemBuilder: (context, index) {
                    // Skip the document with id "1" (as per your code)
                    if (chatDocuments[index].id == "1") return SizedBox();

                    Map<String, dynamic> chats =
                    chatDocuments[index].data() as Map<String, dynamic>;
                    bool isSentByMe = chats["uid"].toString() == user!.uid;

                    return Align(
                      alignment: isSentByMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.01,
                          horizontal: screenWidth * 0.03,
                        ),
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        decoration: BoxDecoration(
                          color: isSentByMe ? Colors.teal : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          chats["chat"],
                          style: TextStyle(
                            color: isSentByMe ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Input area
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.01,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5,
                      offset: Offset(0, -1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Text input field
                    Expanded(
                      child: TextField(
                        controller: chatTextController,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.01,
                            horizontal: screenWidth * 0.03,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),

                    // Send button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: () async {
                          // Add send functionality
                          if (chatTextController.text.isNotEmpty) {
                            await FirebaseFirestore.instance
                                .collection(widget.groupName)
                                .add({
                              "chat": chatTextController.text,
                              "uid": user!.uid,
                              "timeStamp": FieldValue.serverTimestamp(),
                            });
                            chatTextController.clear();

                            // Scroll to the bottom after sending a message
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _scrollToBottomSmoothly();
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
