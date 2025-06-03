// rating_selector.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../controllers/share_controller/share_controller.dart';

class RatingSelector extends StatelessWidget {
  const RatingSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final ShareController controller = Get.find();
    return Obx(
      () => Row(
        children: [
          Text("Rating: ", style: TextStyle(fontWeight: FontWeight.w600)),
          RatingBar.builder(
            initialRating: controller.rating.value,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 30,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (rating) {
              controller.rating.value = rating;
            },
          ),
        ],
      ),
    );
  }
}
