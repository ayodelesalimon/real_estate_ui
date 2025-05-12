import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../main.dart';
import 'widgets/bottom_navs.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({Key? key}) : super(key: key);

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen>
    with TickerProviderStateMixin {
  final Completer<GoogleMapController> _controller = Completer();
  late AnimationController _markerAnimationController;
  late Animation<double> _markerScaleAnimation;
  bool _showListOfVariants = false;
  bool _isMapView = true;
  late Animation<double> _fadeAnimation;
  late AnimationController _animationController;

  final List<AnimationController> _markerControllers = [];
  final List<Animation<double>> _markerScales = [];

  static const CameraPosition _saintPetersburg = CameraPosition(
    target: LatLng(59.9342802, 30.3350986),
    zoom: 14,
  );

  // List of price markers with their positions and prices
  final List<PriceMarkerData> _markers = [
    PriceMarkerData(
      position: const LatLng(59.9342802, 30.3350986),
      price: "10.3 m ₽",
    ),
    PriceMarkerData(
      position: const LatLng(59.9392802, 30.3390986),
      price: "11 m ₽",
    ),
    PriceMarkerData(
      position: const LatLng(59.9292802, 30.3450986),
      price: "7.6 m ₽",
    ),
    PriceMarkerData(
      position: const LatLng(59.9362802, 30.3550986),
      price: "8.5 m ₽",
    ),
    PriceMarkerData(
      position: const LatLng(59.9322802, 30.3250986),
      price: "13.3 m ₽",
    ),
    PriceMarkerData(
      position: const LatLng(59.9272802, 30.3150986),
      price: "9.95 m ₽",
    ),
  ];
  void _toggleView() {
    setState(() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const RealEstateApp()));
      _isMapView = !_isMapView;
      _showListOfVariants = !_showListOfVariants;
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.value = 1.0; //
    _markerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _markerScaleAnimation = CurvedAnimation(
      parent: _markerAnimationController,
      curve: Curves.elasticOut,
    );

    for (int i = 0; i < _markers.length; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
      final animation = CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      );
      _markerControllers.add(controller);
      _markerScales.add(animation);

      Future.delayed(Duration(milliseconds: 200 * i), () {
        if (mounted) {
          controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _markerAnimationController.dispose();
    for (var controller in _markerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildPriceMarkers() {
    return Scaffold(
      body: Stack(
        children: _markers.asMap().entries.map((entry) {
          final index = entry.key;
          final marker = entry.value;

          return AnimatedBuilder(
            animation: _markerScales[index],
            builder: (context, child) {
              return Positioned(
                left: 50.0 +
                    (marker.position.longitude -
                            _saintPetersburg.target.longitude) *
                        3000,
                top: 300.0 -
                    (marker.position.latitude -
                            _saintPetersburg.target.latitude) *
                        3000,
                child: Transform.scale(
                  scale: _markerScales[index].value,
                  child: PriceMarkerWidget(
                    price: marker.price,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _saintPetersburg,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _setMapStyle(controller);
            },
            markers: <Marker>{},
          ),

          _buildPriceMarkers(),

          // UI Overlay
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildSearchBar(),
                ),
                const Spacer(),
                _buildActionButtons(),
                const SizedBox(height: 20),
              ],
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _showListOfVariants ? 80 : 20,
            left: 80,
            right: 20,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _showListOfVariants ? 1.0 : 0.0,
              child: Visibility(
                visible: _showListOfVariants,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF222222),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.list,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'List of variants',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _isMapView ? 0 : -80,
            left: 0,
            right: 0,
            child: FloatBottomNav(
              isMapView: _isMapView,
              onHomePressed: _toggleView,
              onChatPressed: _toggleView,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(
            Icons.search,
            color: Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Saint Petersburg',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 48,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.filter_list,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side buttons
          Column(
            children: [
              _buildActionButton(
                icon: Icons.bookmark_border,
                onTap: () {},
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                icon: Icons.location_searching,
                onTap: () {},
              ),
            ],
          ),

          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showListOfVariants = !_showListOfVariants;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: _showListOfVariants
                          ? Theme.of(context).primaryColor
                          : const Color(0xFF222222),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.list,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'List of variants',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.5, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.grey[800],
                size: 24,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _setMapStyle(GoogleMapController controller) async {
    // Set dark map style as shown in the video
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
        {
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#757575"
            }
          ]
        },
        {
          "elementType": "labels.text.stroke",
          "stylers": [
            {
              "color": "#212121"
            }
          ]
        },
        {
          "featureType": "administrative",
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#757575"
            }
          ]
        },
        {
          "featureType": "administrative.country",
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#9e9e9e"
            }
          ]
        },
        {
          "featureType": "administrative.land_parcel",
          "stylers": [
            {
              "visibility": "off"
            }
          ]
        },
        {
          "featureType": "administrative.locality",
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#bdbdbd"
            }
          ]
        },
        {
          "featureType": "poi",
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#757575"
            }
          ]
        },
        {
          "featureType": "poi.park",
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#181818"
            }
          ]
        },
        {
          "featureType": "poi.park",
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#616161"
            }
          ]
        },
        {
          "featureType": "poi.park",
          "elementType": "labels.text.stroke",
          "stylers": [
            {
              "color": "#1b1b1b"
            }
          ]
        },
        {
          "featureType": "road",
          "elementType": "geometry.fill",
          "stylers": [
            {
              "color": "#2c2c2c"
            }
          ]
        },
        {
          "featureType": "road",
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#8a8a8a"
            }
          ]
        },
        {
          "featureType": "road.arterial",
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#373737"
            }
          ]
        },
        {
          "featureType": "road.highway",
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#3c3c3c"
            }
          ]
        },
        {
          "featureType": "road.highway.controlled_access",
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#4e4e4e"
            }
          ]
        },
        {
          "featureType": "road.local",
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#616161"
            }
          ]
        },
        {
          "featureType": "transit",
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#757575"
            }
          ]
        },
        {
          "featureType": "water",
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#000000"
            }
          ]
        },
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

class PriceMarkerData {
  final LatLng position;
  final String price;

  PriceMarkerData({
    required this.position,
    required this.price,
  });
}

class PriceMarkerWidget extends StatelessWidget {
  final String price;

  const PriceMarkerWidget({
    Key? key,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        price,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
