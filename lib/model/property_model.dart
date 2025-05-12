class Property {
  final String id;
  final String address;
  final String imageUrl;
  final double price;
  final String type; // 'BUY' or 'RENT'
  final double latitude;
  final double longitude;
  final String description;

  Property({
    required this.id,
    required this.address,
    required this.imageUrl,
    required this.price,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.description,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] ?? '',
      address: json['address'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      type: json['type'] ?? 'BUY',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'imageUrl': imageUrl,
      'price': price,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
    };
  }
}