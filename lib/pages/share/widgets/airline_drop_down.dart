import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskapp/controllers/airline_controller/airline_controller.dart';

class AirLineSearchField extends StatefulWidget {
  final TextEditingController searchController;
  final String hintText;

  const AirLineSearchField({
    super.key,
    required this.searchController,
    required this.hintText,
  });

  @override
  State<AirLineSearchField> createState() => _AirLineSearchFieldState();
}

class _AirLineSearchFieldState extends State<AirLineSearchField> {
  late FocusNode _focusNode;
  late AirlineController controller;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    controller = Get.put(
      AirlineController(fieldId: widget.searchController.hashCode.toString()),
      tag: widget.searchController.hashCode.toString(),
    );

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        controller.filteredAirlines.assignAll(controller.airlines);
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
                          controller.filteredAirlines.clear();
                          controller.showDropdown.value = false;
                        },
                      ),
                    const Icon(Icons.keyboard_arrow_down),
                  ],
                );
              }),
            ),
            onChanged: controller.filterAirlines,
          ),
        ),
        Obx(() {
          return controller.showDropdown.value &&
                  controller.filteredAirlines.isNotEmpty
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
                    itemCount: controller.filteredAirlines.length,
                    itemBuilder: (context, index) {
                      final airport = controller.filteredAirlines[index];
                      return ListTile(
                        title: Text(
                          airport.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(airport.country),
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
