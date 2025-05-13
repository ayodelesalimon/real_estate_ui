# Real Estate App

![Real Estate App Banner](https://via.placeholder.com/1200x300/FFA726/FFFFFF?text=Real+Estate+App)

## 📱 Overview

A modern, beautifully designed real estate application built with Flutter using the MVC (Model-View-Controller) architecture pattern. This app allows users to browse properties for sale or rent, view property details, and explore properties on an interactive map.

## ✨ Features

- **Property Listings**: Browse through properties for sale or rent
- **Map View**: Explore properties on an interactive map with price markers
- **Animations**: Smooth, engaging animations throughout the app
- **Beautiful UI**: Clean, modern interface inspired by latest design trends

## 📱 Screenshots

<div style="display: flex; flex-direction: row; justify-content: space-around;">
  <img src="https://via.placeholder.com/250x500/FFF8E1/000000?text=Home+Screen" width="250" />
  <img src="https://via.placeholder.com/250x500/000000/FFFFFF?text=Map+Screen" width="250" />
  <img src="https://via.placeholder.com/250x500/FFF8E1/000000?text=Property+Details" width="250" />
</div>

## 🏗️ Architecture

This project implements the MVC (Model-View-Controller) architecture pattern to ensure separation of concerns and maintainability.

### Structure

```
lib/
├── main.dart                       
├── config/                       
│   ├── constants.dart              
│   ├── routes.dart                
│   └── theme.dart                 
├── models/                        
│   ├── property.dart              
│   └── user.dart                   
├── views/                          
│   ├── screens/                    
│   │   ├── home_screen.dart        
│   │   └── map_screen.dart         
│   └── widgets/                    
│       ├── animated_counter.dart   
│       ├── bottom_navigation.dart 
│       ├── property_card.dart      
│       ├── property_card_row.dart  
│       └── price_marker.dart       
├── controllers/                    
│   ├── property_controller.dart    
│   ├── map_controller.dart         
│   └── animation_controller.dart   
└── services/                       
    ├── api_service.dart            
    └── location_service.dart       
```

### MVC Implementation Details

1. **Models**:
   - Represent the data structures used in the application
   - Simple classes that define properties and methods for data manipulation
   - Handle data validation and conversion

2. **Views**:
   - Responsible for UI rendering
   - Communicate with controllers to fetch data and trigger events
   - Include screens (full UI pages) and widgets (reusable UI components)

3. **Controllers**:
   - Contain business logic
   - Act as intermediaries between models and views
   - Manage state and handle user interactions
   - Coordinate data flow between different parts of the application

## 🚀 Getting Started

### Prerequisites

- Flutter (2.10.0 or higher)
- Dart (2.16.0 or higher)
- Android Studio / VS Code
- Android / iOS emulator or physical device

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/ayodelesalimon/real-estate-app.git
   ```

2. Navigate to the project directory:
   ```bash
   cd real-estate-app
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## 🎯 Key Components

### Property Card Animation

The property cards feature a sliding animation where the arrow icon slides from left to right across the card, followed by a fade-in effect for the property address.

```dart
// Animation for icon sliding from left to right
_iconPositionAnimation = Tween<double>(
  begin: 0.0,
  end: 1.0,
).animate(
  CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
  ),
);

// Animation for text fading in after icon reaches the right
_textFadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
  CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
  ),
);
```

### Counter Animation

The animated counters in the category selection display feature complex animations with bounce effects and counting animations:

```dart
// Create bounce animation
_bounceAnimation = TweenSequence<double>([
  TweenSequenceItem<double>(
    tween: Tween<double>(begin: 0.0, end: 1.1)
        .chain(CurveTween(curve: Curves.bounceOut)),
    weight: 20.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(begin: 1.1, end: 0.9)
        .chain(CurveTween(curve: Curves.easeIn)),
    weight: 20.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(begin: 0.9, end: 1.0)
        .chain(CurveTween(curve: Curves.easeOut)),
    weight: 20.0,
  ),
  TweenSequenceItem<double>(
    tween: ConstantTween<double>(1.0),
    weight: 40.0,
  ),
]).animate(_controller);
```

### Map Integration

The app integrates Google Maps for an interactive map experience, displaying properties with custom markers:

```dart
GoogleMap(
  mapType: MapType.normal,
  initialCameraPosition: MapController.defaultLocation,
  myLocationButtonEnabled: false,
  zoomControlsEnabled: false,
  onMapCreated: (GoogleMapController controller) {
    _mapController.mapCompleter.complete(controller);
    _mapController.setMapStyle(controller);
  },
  markers: _mapController.createMarkers(properties),
)
```

## 🧩 Controllers

### PropertyController

Manages property data and filtering functionality:

```dart
class PropertyController with ChangeNotifier {
  // Singleton instance
  static final PropertyController _instance = PropertyController._internal();
  factory PropertyController() => _instance;
  PropertyController._internal();
  
  // State
  List<Property> _properties = [];
  List<Property> _filteredProperties = [];
  String _selectedType = 'BUY';
  
  // Methods to manage properties
  Future<void> loadProperties() async {
    // Load properties from API
  }
  
  void setSelectedType(String type) {
    _selectedType = type;
    _applyFilter();
    notifyListeners();
  }
}

```

## 🎨 UI Components

### Property Card

The property card displays property information with an animated address bar:

```dart
class PropertyCard extends StatefulWidget {
  final String imageUrl;
  final String address;
  final bool showAnimation;

  const PropertyCard({
    Key? key,
    required this.imageUrl,
    required this.address,
    this.showAnimation = false,
  }) : super(key: key);

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}
```

### Animated Counter

Displays animated counting numbers with bounce effects:

```dart
class AnimatedCounter extends StatefulWidget {
  final bool isBuy;
  final int count;
  
  const AnimatedCounter({
    Key? key, 
    required this.isBuy,
    required this.count,
  }) : super(key: key);

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}
```

### Bottom Navigation Bar

Custom navigation bar with animated button states:

```dart
class BottomNavigationBar extends StatelessWidget {
  final bool isMapView;
  final VoidCallback onHomePressed;
  final VoidCallback onChatPressed;

  const BottomNavigationBar({
    Key? key,
    required this.isMapView,
    required this.onHomePressed,
    required this.onChatPressed,
  }) : super(key: key);
```

## 📱 Screens

### Home Screen

The main screen featuring property listings and category selection:

```dart
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
```

### Map Screen

Interactive map displaying property locations with price markers:

```dart
class MapViewScreen extends StatefulWidget {
  const MapViewScreen({Key? key}) : super(key: key);

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}
```

## 🛠️ Technical Implementation

### Animations

The app uses a variety of animations to enhance the user experience:

1. **Fade Animations**: Used for smooth transitions between screens and UI elements
2. **Slide Animations**: Used for the property card address bars and UI elements
3. **Bounce Animations**: Used for the counter widgets and map markers
4. **Count Animations**: Used to animate number changes in the counter widgets

### State Management

The app uses a combination of:

1. **ChangeNotifier**: For controllers to notify views of state changes
2. **AnimationController**: For managing complex animations
3. **setState**: For local widget state

### Navigation

The app implements a simple navigation system using named routes:

```dart
class AppRoutes {
  static const String home = '/';
  static const String map = '/map';
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Generate routes based on route name
  }
}
```

## 🙏 Acknowledgements

- [Flutter](https://flutter.dev/)
- [Google Maps Flutter](https://pub.dev/packages/google_maps_flutter)
- [Google Fonts](https://pub.dev/packages/google_fonts)
- [Material Design Icons](https://material.io/resources/icons/)
