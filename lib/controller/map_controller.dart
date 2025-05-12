import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/property_model.dart';


class MapController with ChangeNotifier {
  // Singleton instance
  static final MapController _instance = MapController._internal();
  factory MapController() => _instance;
  MapController._internal();
  
  // State
  final Completer<GoogleMapController> mapCompleter = Completer();
  bool isMapView = true;
  bool showListOfVariants = false;
  
  // Saint Petersburg coordinates
  static const CameraPosition defaultLocation = CameraPosition(
    target: LatLng(59.9342802, 30.3350986),
    zoom: 14,
  );
  
  // Toggle between map and list view
  void toggleView() {
    isMapView = !isMapView;
    showListOfVariants = !showListOfVariants;
    notifyListeners();
  }
  
  // Toggle list of variants visibility
  void toggleListOfVariants() {
    showListOfVariants = !showListOfVariants;
    notifyListeners();
  }
  
  // Create markers from properties
  Set<Marker> createMarkers(List<Property> properties) {
    return properties.map((property) {
      return Marker(
        markerId: MarkerId(property.id),
        position: LatLng(property.latitude, property.longitude),
        infoWindow: InfoWindow(
          title: property.address,
          snippet: '${(property.price / 1000000).toStringAsFixed(1)} m ₽',
        ),
      );
    }).toSet();
  }
  
  // Set custom map style
  Future<void> setMapStyle(GoogleMapController controller) async {
    // Dark map style
    String mapStyle = '''
      [
        {
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#212121"
            }
          ]
        },
        {
          "elementType": "labels.icon",
          "stylers": [
            {
              "visibility": "off"
            }
          ]
        },
        /* More map style JSON */
        {
          "featureType": "water",
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#3d3d3d"
            }
          ]
        }
      ]
    ''';

    await controller.setMapStyle(mapStyle);
  }
}