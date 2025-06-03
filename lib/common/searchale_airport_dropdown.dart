import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/airport_controller/airport_controller.dart';
import '../model/airport_model.dart';

class AirportSearchField extends StatefulWidget {
  final TextEditingController searchController;
  final String hintText;
  final void Function(Airport) onSelected;

  const AirportSearchField({
    super.key,
    required this.searchController,
    required this.hintText,
    required this.onSelected,
  });

  @override
  State<AirportSearchField> createState() => _AirportSearchFieldState();
}

class _AirportSearchFieldState extends State<AirportSearchField> {
  late FocusNode _focusNode;
  late AirportController controller;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    controller = Get.put(
      AirportController(fieldId: widget.searchController.hashCode.toString()),
      tag: widget.searchController.hashCode.toString(),
    );

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        controller.filteredAirports.assignAll(controller.airports);
        controller.showDropdown.value = true;
      } else {
        controller.showDropdown.value = false;
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
          child: TextField(
            controller: widget.searchController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: widget.hintText,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 10,
              ),
              suffixIcon: Obx(() {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (controller.searchQuery.value.isNotEmpty &&
                        widget.searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          widget.searchController.clear();
                          controller.searchQuery.value = '';
                          controller.filteredAirports.clear();
                          controller.showDropdown.value = false;
                        },
                      ),
                    const Icon(Icons.keyboard_arrow_down),
                  ],
                );
              }),
            ),
            onChanged: controller.filterAirports,
          ),
        ),
        Obx(() {
          return controller.showDropdown.value &&
                  controller.filteredAirports.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.only(top: 5),
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 1,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.filteredAirports.length,
                    itemBuilder: (context, index) {
                      final airport = controller.filteredAirports[index];
                      return ListTile(
                        title: Text(
                          airport.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(airport.type),
                        trailing: Text(
                          airport.iata,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        onTap: () {
                          controller.selectAirport(
                            airport,
                            widget.searchController,
                          );
                          widget.onSelected.call(airport);
                          _focusNode.unfocus();
                        },
                      );
                    },
                  ),
                )
              : const SizedBox();
        }),
      ],
    );
  }
}
