// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../controller/property_controller.dart';

import '../../config/routes.dart';
import 'widgets/animated_counter.dart';
import 'widgets/bottom_navs.dart';
import 'widgets/property_card.dart';
import 'widgets/property_card_row.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  //  Controllers
  final PropertyController _propertyController = PropertyController();

  // Animation controllers
  late AnimationController _fadeInController;
  late AnimationController _slideUpController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideUpAnimation;

  @override
  void initState() {
    super.initState();

    _fadeInController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _fadeInController,
      curve: Curves.easeIn,
    );

    _slideUpController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideUpAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideUpController,
      curve: Curves.easeOutCubic,
    ));

    _fadeInController.forward();
    _slideUpController.forward();

    _propertyController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    _slideUpController.dispose();
    super.dispose();
  }

  void _navigateToMap() {
    Navigator.pushNamed(context, AppRoutes.map);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.1),
              Theme.of(context).colorScheme.primary.withOpacity(0.2),
              Theme.of(context).colorScheme.primary.withOpacity(0.5),
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
              Theme.of(context).colorScheme.primary.withOpacity(0.4),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: FadeTransition(
                opacity: _fadeInAnimation,
                child: SlideTransition(
                  position: _slideUpAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildHeader(),
                      const SizedBox(height: 24),
                      _buildIntroSection(),
                      const SizedBox(height: 24),
                      _buildTabSelector(),
                      const SizedBox(height: 34),
                      _buildPropertiesSection(),
                      SizedBox(height: 26),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: FloatBottomNav(
        isMapView: false,
        onHomePressed: _navigateToMap,
        onChatPressed: () {
          Navigator.pushNamed(context, AppRoutes.map);
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _fadeInController,
              curve: Curves.easeOut,
            )),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-1, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _fadeInController,
                      curve: Curves.easeOut,
                    )),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 4),
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-1, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _fadeInController,
                      curve: Curves.easeOut,
                    )),
                    child: Text(
                      'Saint Petersburg',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _fadeInController,
              curve: Curves.easeOut,
            )),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: AssetImage('assets/images/agent1.jpg'),
                  fit: BoxFit.cover,
                ),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi, Marina',
            style: TextStyle(
              fontSize: 24,
              color: Colors.brown[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'let\'s select your\nperfect place',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: SizedBox(
        height: 170,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _propertyController.setSelectedType('BUY');
                },
                child: AnimatedCounter(
                  isBuy: true,
                  count: 1034,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _propertyController.setSelectedType('RENT');
                },
                child: AnimatedCounter(
                  isBuy: false,
                  count: 2212,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertiesSection() {
    if (_propertyController.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_propertyController.error != null) {
      return Center(child: Text(_propertyController.error!));
    }

    final properties = _propertyController.properties;

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          //  Feature property
          if (properties.isNotEmpty)
            PropertyCard(
              imageUrl: properties[0].imageUrl,
              address: properties[0].address,
              showAnimation: true,
            ),

          const SizedBox(height: 16),

          //  Property row
          if (properties.length > 1)
            Row(
              children: [
                Expanded(
                  child: PropertyCardRow(
                    imageUrl:
                        properties.length > 0 ? properties[0].imageUrl : '',
                    address: properties.length > 0 ? properties[0].address : '',
                    showAnimation: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: PropertyCardRow(
                    imageUrl:
                        properties.length > 1 ? properties[1].imageUrl : '',
                    address: properties.length > 1 ? properties[1].address : '',
                    showAnimation: false,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
