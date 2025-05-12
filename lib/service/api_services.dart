import 'dart:convert';
import 'dart:async';
import '../model/property_model.dart';


class ApiService {
  // Mock API delay
  final Duration delay = const Duration(milliseconds: 800);
  
  // Get all properties (mock data)
  Future<List<Property>> getProperties() async {
    // Simulate network delay
    await Future.delayed(delay);
    
    // Return mock data
    return [
      Property(
        id: '1',
        address: 'Gladkova St., 25',
        imageUrl: 'https://images.unsplash.com/photo-1484154218962-a197022b5858',
        price: 10300000,
        type: 'BUY',
        latitude: 59.9342802,
        longitude: 30.3350986,
        description: 'Beautiful apartment in the center of Saint Petersburg',
      ),
      Property(
        id: '2',
        address: 'Trefoleva St., 43',
        imageUrl: 'https://images.unsplash.com/photo-1484154218962-a197022b5858',
        price: 8500000,
        type: 'BUY',
        latitude: 59.9392802,
        longitude: 30.3390986,
        description: 'Cozy apartment with a great view',
      ),
      Property(
        id: '3',
        address: 'Lenina St., 15',
        imageUrl: 'https://images.unsplash.com/photo-1484154218962-a197022b5858',
        price: 7600000,
        type: 'RENT',
        latitude: 59.9292802,
        longitude: 30.3450986,
        description: 'Modern apartment in a new building',
      ),
      Property(
        id: '4',
        address: 'Mira Ave., 76',
        imageUrl: 'https://images.unsplash.com/photo-1484154218962-a197022b5858',
        price: 9500000,
        type: 'RENT',
        latitude: 59.9272802,
        longitude: 30.3150986,
        description: 'Spacious apartment with a balcony',
      ),
    ];
  }
}
