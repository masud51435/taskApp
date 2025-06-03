import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:taskapp/model/airline_model.dart';

class AirlineController extends GetxController {
  final String fieldId;

  AirlineController({required this.fieldId});

  var airlines = <AirLine>[].obs;
  var filteredAirlines = <AirLine>[].obs;
  var selectedAirline = Rxn<AirLine>();
  var searchQuery = ''.obs;
  var showDropdown = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAirlines();
  }

  /// Load airports from local JSON
  Future<void> loadAirlines() async {
    final String response = await rootBundle.loadString(
      'assets/airport/airlines.json',
    );
    final List<dynamic> data = json.decode(response);
    airlines.value = data.map((json) => AirLine.fromJson(json)).toList();
    filteredAirlines.assignAll(airlines);
  }

  /// Filter airports by name or IATA code
  void filterAirlines(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredAirlines.clear();
      showDropdown.value = false;
    } else {
      filteredAirlines.assignAll(
        airlines.where(
          (airport) =>
              airport.name.toLowerCase().contains(query.toLowerCase()) ||
              airport.iata.toLowerCase().contains(query.toLowerCase()),
        ),
      );
      showDropdown.value = true;
    }
  }

  /// Select an airport and update the search field
  void selectAirport(AirLine airline, TextEditingController searchController) {
    selectedAirline.value = airline;
    searchController.text = airline.name;
    searchQuery.value = airline.name;
    filteredAirlines.clear();
    showDropdown.value = false;
  }
}
