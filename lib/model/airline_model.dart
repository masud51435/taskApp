class AirLine {
  final String name;
  final String iata;
  final String icao;
  final String id;
  final String alias;
  final String callsign;
  final String country;
  final String active;

  AirLine({
    required this.name,
    required this.iata,
    required this.icao,
    required this.id,
    required this.alias,
    required this.callsign,
    required this.country,
    required this.active,
  });

  factory AirLine.fromJson(Map<String, dynamic> json) {
    return AirLine(
      name: json['name'] ?? '',
      iata: json['iata'] ?? '',
      icao: json['icao'] ?? '',
      id: json['id'] ?? '',
      alias: json['alias'] ?? '',
      callsign: json['callsign'] ?? '',
      country: json['country'] ?? '',
      active: json['active'] ?? '',
    );
  }
}
