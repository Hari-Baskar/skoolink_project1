

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class DBService{
  final firestore=FirebaseFirestore.instance;
  Future<bool> checkDocumentExists(String uid) async {
    try {
      var docSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      // Check if the document exists
      return docSnapshot.exists;
    } catch (e) {
      // Handle any errors (e.g., network issues, Firestore errors)
      print("Error checking document existence: $e");
      return false;
    }
  }
Stream checkDocument(String uid){
    return firestore.collection("users").doc(uid).snapshots();
}
Stream posts(){
    return firestore.collection("posts").orderBy("timestamp",descending: true).snapshots();
}
Stream chatUsers(String chat){
    return firestore.collection(chat).orderBy("timeStamp",descending: false).snapshots();
}
Stream users(){
    return firestore.collection("users").snapshots();
}
Stream Mentors({
    required int Class
}){
    return firestore.collection("users").where("role",isEqualTo: "Mentor").where("classes",arrayContains: Class).snapshots();
}

Stream<List<Map<String, dynamic>>> search(String word) {
    final roleStream = FirebaseFirestore.instance
        .collection("users")
        .where("role", isGreaterThanOrEqualTo: word)
        .where("role", isLessThanOrEqualTo: word + '\uf8ff')
        .snapshots();

    final professionStream = FirebaseFirestore.instance
        .collection("users")
        .where("profession", isGreaterThanOrEqualTo: word)
        .where("profession", isLessThanOrEqualTo: word + '\uf8ff')
        .snapshots();

    final nameStream = FirebaseFirestore.instance
        .collection("users")
        .where("name", isGreaterThanOrEqualTo: word)
        .where("name", isLessThanOrEqualTo: word + '\uf8ff')
        .snapshots();

    final schoolNameStream = FirebaseFirestore.instance
        .collection("users")
        .where("schoolName", isGreaterThanOrEqualTo: word)
        .where("schoolName", isLessThanOrEqualTo: word + '\uf8ff')
        .snapshots();

    return CombineLatestStream.list([
      roleStream,
      professionStream,
      nameStream,
      schoolNameStream,
    ]).map((snapshots) {
      // Combine all the results into a single list
      final List<Map<String, dynamic>> results = [];
      for (QuerySnapshot snapshot in snapshots) {
        for (QueryDocumentSnapshot doc in snapshot.docs) {
          results.add(doc.data() as Map<String, dynamic>);
        }
      }

      // Optionally, remove duplicates based on a unique field like `id`
      final uniqueResults = results.toSet().toList();

      return uniqueResults;
    });
  }
}