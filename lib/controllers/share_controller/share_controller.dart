// share_controller.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskapp/controllers/airline_controller/airline_controller.dart';

import '../../model/airport_model.dart';
import '../../model/post_model.dart';
import '../airport_controller/airport_controller.dart';
import '../class_controller/class_controller.dart';

class ShareController extends GetxController {
  Rx<DateTime?> travelDate = Rx<DateTime?>(null);
  RxDouble rating = 0.0.obs;
  RxBool isLoading = false.obs;

  Rxn<Airport> departureAirport = Rxn<Airport>();
  Rxn<Airport> arrivalAirport = Rxn<Airport>();
  final TextEditingController denatureAirportController =
      TextEditingController();
  final TextEditingController arrivalAirportController =
      TextEditingController();
  final TextEditingController airLineController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  // Images
  RxList<File> selectedImages = <File>[].obs;
  final picker = ImagePicker();

  Future<void> pickImages() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      selectedImages.addAll(pickedFiles.map((xfile) => File(xfile.path)));
    }
  }

  void setDepartureAirport(Airport airport) {
    departureAirport.value = airport;
    denatureAirportController.text =
        airport.name; // Just to keep in sync if needed
  }

  void setArrivalAirport(Airport airport) {
    arrivalAirport.value = airport;
    arrivalAirportController.text = airport.name;
  }

  Future<List<String>> uploadImages() async {
    List<String> downloadUrls = [];
    for (var image in selectedImages) {
      final ref = FirebaseStorage.instance.ref().child(
        'posts/${DateTime.now().millisecondsSinceEpoch}_${image.path.split("/").last}',
      );
      await ref.putFile(image);
      final url = await ref.getDownloadURL();
      downloadUrls.add(url);
    }
    return downloadUrls;
  }

  Future<void> submitPost() async {
    isLoading.value = true;
    if (departureAirport.value == null ||
        arrivalAirport.value == null ||
        airLineController.text.isEmpty ||
        classController.text.isEmpty ||
        messageController.text.isEmpty ||
        travelDate.value == null ||
        rating.value == 0.0 ||
        selectedImages.isEmpty) {
      Get.snackbar('Missing Data', 'Please complete all fields');
      isLoading.value = false;
      return;
    }

    try {
      final imageUrls = await uploadImages();

      final post = PostModel(
        departureAirport: departureAirport.value!.iata,
        arrivalAirport: arrivalAirport.value!.iata,
        airline: airLineController.text,
        travelClass: classController.text,
        message: messageController.text,
        travelDate: travelDate.value!.toIso8601String(),
        rating: rating.value,
        images: imageUrls,
      );

      print("the model is${post.toJson()}");

      await FirebaseFirestore.instance.collection('posts').add(post.toJson());

      Get.snackbar('Success', 'Your review has been shared!');
      isLoading.value = false;
      clearForm();
    } catch (e) {
      Get.snackbar('Error', 'Failed to share post');
      isLoading.value = false;
      print('Firestore Error: $e');
    }
  }

  void clearForm() {
    denatureAirportController.text = '';
    arrivalAirportController.text = '';
    airLineController.text = '';
    classController.text = '';
    travelDate.value = null;
    messageController.text = '';
    rating.value = 0.0;
    selectedImages.clear();
    try {
      final denatureController = Get.find<AirportController>(
        tag: denatureAirportController.hashCode.toString(),
      );
      denatureController.searchQuery.value = '';
      denatureController.filteredAirports.clear();
      denatureController.showDropdown.value = false;

      final arrivalController = Get.find<AirportController>(
        tag: arrivalAirportController.hashCode.toString(),
      );
      arrivalController.searchQuery.value = '';
      arrivalController.filteredAirports.clear();
      arrivalController.showDropdown.value = false;
      final airlineController = Get.find<AirlineController>(
        tag: airLineController.hashCode.toString(),
      );
      airlineController.searchQuery.value = '';
      airlineController.filteredAirlines.clear();
      airlineController.showDropdown.value = false;

      // Clear selected class
      final classController = Get.find<ClassController>();
      classController.selectedClass.value = null;
    } catch (e) {
      print('Error clearing AirportController states: $e');
    }
  }
}
