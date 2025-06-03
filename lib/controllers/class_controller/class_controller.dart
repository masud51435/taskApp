import 'package:get/get.dart';

class ClassController extends GetxController {
  final classOptions = ['Economy', 'Premium Economy', 'Business', 'First', 'Any'];
  var selectedClass = RxnString();

  void selectClass(String value) {
    selectedClass.value = value;
  }
}
