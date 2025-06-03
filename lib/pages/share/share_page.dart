import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskapp/pages/share/widgets/message_field.dart';

import '../../common/common_button.dart';
import '../../common/searchale_airport_dropdown.dart';
import '../../controllers/share_controller/share_controller.dart';
import 'widgets/airline_drop_down.dart';
import 'widgets/class_drop_down.dart';
import 'widgets/date_picker_widget.dart';
import 'widgets/image_picker_upload.dart';
import 'widgets/rating_selector.dart';

class SharePage extends StatelessWidget {
  const SharePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ShareController controller = Get.put(ShareController());
    return Scaffold(
      appBar: AppBar(title: const Text('Share')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ImagePickerUpload(),
            SizedBox(height: 20),
            AirportSearchField(
              searchController: controller.denatureAirportController,
              hintText: 'Departure Airport',
              onSelected: (airport) {
                controller.setDepartureAirport(airport);
              },
            ),
            const SizedBox(height: 20),
            AirportSearchField(
              searchController: controller.arrivalAirportController,
              hintText: 'Arrival Airport',
              onSelected: (airport) {
                controller.setArrivalAirport(airport);
              },
            ),
            SizedBox(height: 20),
            AirLineSearchField(
              searchController: controller.airLineController,
              hintText: 'Airline',
            ),
            SizedBox(height: 20),
            ClassDropdownField(classController: controller.classController),
            SizedBox(height: 20),
            MessageTextField(controller: controller.messageController),
            SizedBox(height: 20),
            MonthYearPicker(),
            SizedBox(height: 20),
            RatingSelector(),
            SizedBox(height: 20),
            Obx(
              () => CommonButton(
                onTap: () => controller.submitPost(),
                text: 'Submit',
                loading: controller.isLoading.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
