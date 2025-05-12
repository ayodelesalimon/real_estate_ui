import 'package:flutter/material.dart';

import '../views/home_screen.dart';
import '../views/map_screen.dart';
import '../views/mzp_screen.dart';


class AppRoutes {
  static const String home = '/';
  static const String map = '/map';
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case map:
        return MaterialPageRoute(builder: (_) => const MapViewScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}