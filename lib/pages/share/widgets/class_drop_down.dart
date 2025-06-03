import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/class_controller/class_controller.dart';

class ClassDropdownField extends StatelessWidget {
  final TextEditingController classController;

  const ClassDropdownField({super.key, required this.classController});

  @override
  Widget build(BuildContext context) {
    final ClassController controller = Get.put(ClassController());

    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedClass.value,
            hint: const Text("Select Class"),
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: controller.classOptions.map((String classType) {
              return DropdownMenuItem<String>(
                value: classType,
                child: Text(classType),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                classController.clear();
                classController.text = value;
              }
            },
          ),
        ),
      );
    });
  }
}
