import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskapp/core/app_colors.dart';
import '../../../controllers/share_controller/share_controller.dart';

class ImagePickerUpload extends StatelessWidget {
  const ImagePickerUpload({super.key});

  @override
  Widget build(BuildContext context) {
    final ShareController controller = Get.put(ShareController());
    return Obx(() {
      return DottedBorder(
        options: RoundedRectDottedBorderOptions(
          dashPattern: [10, 5],
          radius: Radius.circular(16),
          color: greyColor,
        ),
        child: Container(
          height: 150,
          width: Get.width,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 246, 246, 255),
            borderRadius: BorderRadius.circular(16),
          ),
          child: controller.selectedImages.isEmpty
              ? GestureDetector(
                  onTap: () => controller.pickImages(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_outlined, size: 50, color: greyColor),
                      const SizedBox(height: 8),
                      Text("Drop your Image Here Or Browse"),
                    ],
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(8),
                  itemCount: controller.selectedImages.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    if (index < controller.selectedImages.length) {
                      final file = controller.selectedImages[index];
                      return Center(
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                file,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  controller.selectedImages.removeAt(index);
                                },
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.red,
                                  child: Icon(
                                    Icons.close,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: GestureDetector(
                          onTap: () => controller.pickImages(),
                          child: Container(
                            width: 100,
                            height: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: const Icon(Icons.add, color: Colors.grey),
                          ),
                        ),
                      );
                    }
                  },
                ),
        ),
      );
    });
  }
}
