import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final emailControllers = TextEditingController();
  final passwordControllers = TextEditingController();
  GlobalKey<FormState> formKeys = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool toggle = true.obs;
  RxBool loading = false.obs;

  setToggle() {
    toggle.value = !toggle.value;
  }

  setLoading(bool value) {
    loading.value = value;
  }

  void login() async {
    try {
      setLoading(true);
      await _auth
          .signInWithEmailAndPassword(
            email: emailControllers.text.trim(),
            password: passwordControllers.text.trim(),
          )
          .then((value) {
            Get.snackbar('Login', 'Login Successfully');
            setLoading(false);
            Get.offAllNamed('/homePage');
          })
          .onError((error, stackTrace) {
            setLoading(false);
            Get.snackbar('Error', error.toString());
          });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Error', 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Wrong password provided for that user.');

        setLoading(false);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());

      setLoading(false);
    }
  }
}
