import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchNumber {
  final db = FirebaseFirestore.instance;

  Future<Object?> getData({String? number}) async {
    try {
      QuerySnapshot querySnapshot =
          await db.collection("Users").where("Number", isEqualTo: number).get();
      if (querySnapshot.docs.isNotEmpty) {
        // There might be multiple documents with the same number,
        // so we iterate through the results.
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          log('User Found with ID: ${documentSnapshot.id} ${documentSnapshot.data()}');
          return documentSnapshot.data();
        }
      }
      log('User not found');
      return null;
    } catch (e) {
      throw Exception("Exception: $e");
    }
  }
}
