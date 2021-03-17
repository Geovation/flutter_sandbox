class Placemarks {
  final String name, iconName;
  final List coordinates;

  Placemarks({
    this.name,
    this.iconName,
    this.coordinates,
  });

  factory Placemarks.fromJson(Map<String, dynamic> json) {
    return new Placemarks(
      name: json['name'].toString(),
      iconName: json['iconName'].toString(),
      coordinates: json['coordinates'].toList(),
    );
  }
}
