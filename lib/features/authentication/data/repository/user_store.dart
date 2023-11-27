import 'package:chat_app/config/routes/route.dart';
import 'package:chat_app/core/constants/key.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreUserData {
  Future<String> storeUserData(
      {String? name, String? number, String? imagePath, String? bio}) async {
    try {
      // Call the user's CollectionReference to add a new user
      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');
      await users.doc(number).set(
          {'name': name, 'number': number, 'photo': imagePath, "about": bio});
      navigatorKey.currentState?.pushReplacementNamed(Routes.homeScreen,
          arguments: [false, false, '', '', '', '']);
      return 'success';
    } catch (e) {
      return 'Error adding user';
    }
  }
}
