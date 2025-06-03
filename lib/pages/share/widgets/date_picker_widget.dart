import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/share_controller/share_controller.dart';
import 'package:intl/intl.dart';

class MonthYearPicker extends StatelessWidget {
  const MonthYearPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final ShareController controller = Get.find();

    return Obx(() {
      final date = controller.travelDate.value;
      final text = date == null
          ? 'Travel Date'
          : DateFormat('MMMM yyyy').format(date);

      return GestureDetector(
        onTap: () => _showMonthYearPicker(context, controller),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          width: Get.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 1,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              Text(text, style: const TextStyle(fontSize: 16)),
              Spacer(),
              const Icon(Icons.calendar_month, color: Colors.grey),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _showMonthYearPicker(
    BuildContext context,
    ShareController controller,
  ) async {
    final now = DateTime.now();
    int selectedYear = controller.travelDate.value?.year ?? now.year;
    int selectedMonth = controller.travelDate.value?.month ?? now.month;

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Select Month and Year"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<int>(
                value: selectedMonth,
                isExpanded: true,
                items: List.generate(12, (index) {
                  final month = DateFormat.MMMM().format(
                    DateTime(0, index + 1),
                  );
                  return DropdownMenuItem(value: index + 1, child: Text(month));
                }),
                onChanged: (value) {
                  if (value != null) selectedMonth = value;
                },
              ),
              DropdownButton<int>(
                value: selectedYear,
                isExpanded: true,
                items: List.generate(50, (index) {
                  final year = now.year - 25 + index;
                  return DropdownMenuItem(value: year, child: Text('$year'));
                }),
                onChanged: (value) {
                  if (value != null) selectedYear = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                controller.travelDate.value = DateTime(
                  selectedYear,
                  selectedMonth,
                );
                Get.back();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
