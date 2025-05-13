import 'package:flutter/material.dart';

class PropertyCardRow extends StatefulWidget {
  final String imageUrl;
  final String address;
  final bool showAnimation;

  const PropertyCardRow({
    Key? key,
    required this.imageUrl,
    required this.address,
    this.showAnimation = false,
  }) : super(key: key);

  @override
  State<PropertyCardRow> createState() => _PropertyCardRowState();
}

class _PropertyCardRowState extends State<PropertyCardRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconPositionAnimation;
  late Animation<double> _textFadeInAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _iconPositionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );
    
    _textFadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );
    
    if (widget.showAnimation) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _controller.forward();
        }
      });
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4/5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 50),
                      ),
                    );
                  },
                ),
              ),
              
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Stack(
                          children: [
                            Container(
                              height: 56,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEEE5D6),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(24),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16, right: 48),
                                child: Opacity(
                                  opacity: _textFadeInAnimation.value,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.address,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                            Positioned(
                              top: 8,
                              bottom: 8,
                              left: _calculateIconPosition(_iconPositionAnimation.value, constraints.maxWidth),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  double _calculateIconPosition(double progress, double containerWidth) {
    const iconWidth = 40.0;
    const padding = 8.0;
    const startPosition = 16.0;
    final endPosition = containerWidth - iconWidth - padding;
    return startPosition + (endPosition - startPosition) * progress;
  }
}