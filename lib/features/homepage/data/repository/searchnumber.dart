import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchNumberResult {
  final bool? userFound;
  final Object? userData;

  SearchNumberResult({this.userFound, this.userData});
}

class SearchNumber {
  final db = FirebaseFirestore.instance;

  Future<SearchNumberResult?> getData({String? number}) async {
    try {
      QuerySnapshot querySnapshot =
          await db.collection("Users").where("number", isEqualTo: number).get();
      if (querySnapshot.docs.isNotEmpty) {
        // There might be multiple documents with the same number,
        // so we iterate through the results.
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          log('User Found with ID: ${documentSnapshot.id} ${documentSnapshot.data()}');

          return SearchNumberResult(
              userFound: true, userData: documentSnapshot.data());
        }
      }
      log('User not found');
      return SearchNumberResult(userFound: false, userData: null);
    } catch (e) {
      throw Exception("Exception: $e");
    }
  }
}
