import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../pages/login/login.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool toggle = true.obs;
  RxBool loading = false.obs;

  setToggle() {
    toggle.value = !toggle.value;
  }

  setLoading(bool value) {
    loading.value = value;
  }

  void signUp() async {
    try {
      setLoading(true);
      await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          )
          .then((value) {
            Get.snackbar('SignUp', 'SignUp Successfully');
            setLoading(false);
            Get.offAllNamed('/homePage');
          })
          .onError((error, stackTrace) {
            setLoading(false);
            Get.snackbar('Error', error.toString());
          });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar('Error', 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar('Error', 'The account already exists for that email.');

        setLoading(false);
        Get.off(() => const Login());
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', e.toString());

      setLoading(false);
    }
  }
}
