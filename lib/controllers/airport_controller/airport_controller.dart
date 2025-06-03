import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../model/airport_model.dart';

class AirportController extends GetxController {
  final String fieldId;

  AirportController({required this.fieldId});

  var airports = <Airport>[].obs;
  var filteredAirports = <Airport>[].obs;
  var selectedAirport = Rxn<Airport>();
  var searchQuery = ''.obs;
  var showDropdown = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAirports();
  }

  /// Load airports from local JSON
  Future<void> loadAirports() async {
    final String response = await rootBundle.loadString(
      'assets/airport/airports.json',
    );
    final List<dynamic> data = json.decode(response);
    airports.value = data.map((json) => Airport.fromJson(json)).toList();
    filteredAirports.assignAll(airports);
  }

  /// Filter airports by name or IATA code
  void filterAirports(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredAirports.clear();
      showDropdown.value = false;
    } else {
      filteredAirports.assignAll(
        airports.where(
          (airport) =>
              airport.name.toLowerCase().contains(query.toLowerCase()) ||
              airport.iata.toLowerCase().contains(query.toLowerCase()),
        ),
      );
      showDropdown.value = true;
    }
  }

  /// Select an airport and update the search field
  void selectAirport(Airport airport, TextEditingController searchController) {
    selectedAirport.value = airport;
    searchController.text = airport.name;
    searchQuery.value = airport.name;
    filteredAirports.clear();
    showDropdown.value = false;
  }
}
