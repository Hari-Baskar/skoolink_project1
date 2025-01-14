import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:skoolinq_project/Services/dbservice.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  late double divHeight, divWidth;
  TextEditingController post = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? pickedImage;

  // Function to pick an image from the gallery
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? selectedFile = await picker.pickImage(source: ImageSource.gallery);
    if (selectedFile != null) {
      setState(() {
        pickedImage = File(selectedFile.path); // Convert XFile to File
      });
    } else {
      print('No image selected.');
    }
  }

  // Function to resize and compress the image before encoding
  Future<File> resizeImage(File imageFile) async {
    img.Image? image = img.decodeImage(await imageFile.readAsBytes());
    img.Image resizedImage =
        img.copyResize(image!, width: 600); // Resize to a smaller width (600px)
    return File(imageFile.path)
      ..writeAsBytesSync(
          img.encodeJpg(resizedImage)); // Compress and write back
  }

  // Function to encode image to Base64
  Future<String> encodeImageToBase64(File imageFile) async {
    File resizedImage = await resizeImage(imageFile);
    final Uint8List imageBytes = await resizedImage.readAsBytes();
    return base64Encode(imageBytes); // Return the Base64 encoded string
  }

  DBService dbService = DBService();

  @override
  Widget build(BuildContext context) {
    divHeight = MediaQuery.of(context).size.height;
    divWidth = MediaQuery.of(context).size.width;
    final user = Provider.of<User?>(context);

    return StreamBuilder(
        stream: dbService.checkDocument(user!.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Scaffold(
              body: Center(child: Text("loading")),
            );

          DocumentSnapshot documentSnapshot = snapshot.data;
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;

          return Scaffold(
            backgroundColor: const Color(0xFF202124),
            body: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: pickImage, // Call the pickImage method
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.white),
                        ),
                        height: divHeight * 0.4,
                        width: divWidth,
                        child: pickedImage != null
                            ? Image.file(pickedImage!, fit: BoxFit.cover)
                            : Center(
                                child: Text(
                                  "Tap here to Pick Image From gallery",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: divHeight * 0.02),
                    TextFormField(
                      controller: post,
                      decoration: InputDecoration(
                        labelText: 'Post Content',
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0)),
                        fillColor: const Color(0xFFD9D9D9),
                        filled: true,
                        border: const OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Post Content cannot be empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: divHeight * 0.02),
                    ElevatedButton(
                      onPressed: () async {
                        EasyLoading.show(status: "Posting");
                        if (pickedImage != null &&
                            formKey.currentState!.validate()) {
                          // Encode the image to Base64
                          EasyLoading.show(status: "Posting");
                          String base64Image =
                              await encodeImageToBase64(pickedImage!);

                          // Store the post and the Base64 image string in Firestore
try {
  await FirebaseFirestore.instance
      .collection("posts")
      .add({
    "post": post.text.toString(),
    "uid": user!.uid,
    "postedBy": data["name"],
    "avatar": data["avatar"],
    "postImg": base64Image,
    "like": 0,
    "timestamp": FieldValue.serverTimestamp(),
  });
  EasyLoading.dismiss();
  post.clear();
  setState(() {
    pickedImage=null;
  });
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 3),
      backgroundColor: Colors.green,
      content: Center(
        child: Text(
          "Post Added Successfully",
          style: TextStyle(
              color: Colors.white, fontSize: 17),
        ),
      ),
    ),
  );
}catch(e){
  EasyLoading.showError("Compress the Image Please");
}



                        }
                        else {
                          EasyLoading.showError("please check the fields");
                        }
                      },
                      child: Text("Add Post"),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
