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
      name: json['name'] as String,
      iconName: json['iconName'] as String,
      coordinates: json['coordinates'] as List,
    );
  }
}
