import 'package:firebase_auth/firebase_auth.dart';

String getCurrentUserId() {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid;
  } else {
    throw Exception('No user is currently signed in.');
  }
}
