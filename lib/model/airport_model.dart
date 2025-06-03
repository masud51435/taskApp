class Airport {
  final String name;
  final String iata;
  final String iso;
  final String continent;
  final String size;
  final String type;
  final int status;
  final String lat;
  final String lon;

  Airport({
    required this.name,
    required this.iata,
    required this.iso,
    required this.continent,
    required this.size,
    required this.type,
    required this.status,
    required this.lat,
    required this.lon,
  });

  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      name: json['name'] ?? '',
      iata: json['iata'] ?? '',
      iso: json['iso'] ?? '',
      continent: json['continent'] ?? '',
      size: json['size'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? 0,
      lat: json['lat'] ?? '',
      lon: json['lon'] ?? '',
    );
  }
}
