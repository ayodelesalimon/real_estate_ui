import 'dart:async';
import 'package:flutter/material.dart';
import '../model/property_model.dart';
import '../service/api_services.dart';


class PropertyController with ChangeNotifier {
  // Singleton instance
  static final PropertyController _instance = PropertyController._internal();
  factory PropertyController() => _instance;
  PropertyController._internal();
  
  // Dependencies
  final ApiService _apiService = ApiService();
  
  // State
  List<Property> _properties = [];
  List<Property> _filteredProperties = [];
  String _selectedType = 'BUY';
  bool _isLoading = false;
  String? _error;
  
  // Getters
  List<Property> get properties => _filteredProperties;
  String get selectedType => _selectedType;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get buyCount => _properties.where((p) => p.type == 'BUY').length;
  int get rentCount => _properties.where((p) => p.type == 'RENT').length;
  
  // Initialize controller
  Future<void> initialize() async {
    await loadProperties();
  }
  
  // Load all properties
  Future<void> loadProperties() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _properties = await _apiService.getProperties();
      _applyFilter();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
  
  // Apply filter based on selected type
  void _applyFilter() {
    if (_selectedType.isEmpty) {
      _filteredProperties = List.from(_properties);
    } else {
      _filteredProperties = _properties
          .where((property) => property.type == _selectedType)
          .toList();
    }
  }
  
  // Set selected type
  void setSelectedType(String type) {
    _selectedType = type;
    _applyFilter();
    notifyListeners();
  }
  
  // Get property by ID
  Property? getPropertyById(String id) {
    try {
      return _properties.firstWhere((property) => property.id == id);
    } catch (e) {
      return null;
    }
  }
}