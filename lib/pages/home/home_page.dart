import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:taskapp/pages/home/widgets/airline_review_appbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AirlineReviewAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextButton(
                onPressed: () => Get.toNamed('/share'),
                child: Text('Add Review'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
