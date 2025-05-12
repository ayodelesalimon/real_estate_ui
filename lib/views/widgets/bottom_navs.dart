import 'package:flutter/material.dart';

class FloatBottomNav extends StatelessWidget {
  final bool isMapView;
  final VoidCallback onHomePressed;
  final VoidCallback onChatPressed;

  const FloatBottomNav({
    Key? key,
    required this.isMapView,
    required this.onHomePressed,
    required this.onChatPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(
            context,
            Icons.chat_bubble_outline,
            !isMapView,
            onChatPressed,
          ),
          _buildNavItem(
            context,
            Icons.message_outlined,
            false,
            () {},
          ),
          _buildNavItem(
            context,
            Icons.home,
            true,
            onHomePressed,
            isCenter: true,
          ),
          _buildNavItem(
            context,
            Icons.favorite_border,
            false,
            () {},
          ),
          _buildNavItem(
            context,
            Icons.person_outline,
            false,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    bool isActive,
    VoidCallback onTap, {
    bool isCenter = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: isCenter ? 50 : 40,
        height: isCenter ? 50 : 40,
        decoration: BoxDecoration(
          color: isCenter ? Theme.of(context).primaryColor : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isActive || isCenter ? Colors.white : Colors.grey[400],
          size: isCenter ? 26 : 24,
        ),
      ),
    );
  }
}