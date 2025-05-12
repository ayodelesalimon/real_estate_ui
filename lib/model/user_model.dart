  class User{
  final String id;
  final String name;
  final String avatarUrl;
  final String city;
  
  User({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.city,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      city: json['city'] ?? '',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'city': city,
    };
  }
}