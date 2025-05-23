import 'package:flutter/material.dart';
import '../../controller/animation_controller.dart';

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

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _fadeInAnimation;
  late Animation<int> _counterAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    // Use AnimationHelper to create animations
    _bounceAnimation = AnimationHelper.createBounceAnimation(_controller);
    _fadeInAnimation = AnimationHelper.createFadeInAnimation(_controller);
    _counterAnimation = AnimationHelper.createCountAnimation(
      _controller,
      widget.count,
    );

    _controller.forward();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _bounceAnimation.value,
      child: Container(
        padding: EdgeInsets.all(5),
        width: 200,
        height: 250,
        decoration: BoxDecoration(
          shape: widget.isBuy ? BoxShape.circle : BoxShape.rectangle,
          color: widget.isBuy
              ? Theme.of(context).primaryColor
              : Theme.of(context).cardColor,
          borderRadius: widget.isBuy ? null : BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.isBuy ? 'BUY' : 'RENT',
              style: TextStyle(
                color: widget.isBuy ? Colors.white : Colors.brown[300],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${_counterAnimation.value.toString().substring(0, 1)} ${_counterAnimation.value.toString().substring(1)}',
              style: TextStyle(
                color: widget.isBuy ? Colors.white : Colors.brown[300],
                fontSize: 40,
                fontWeight: FontWeight.w800,
              ),
            ),
            // const SizedBox(height: 10),
            Text(
              'Offers',
              style: TextStyle(
                color: widget.isBuy ? Colors.white : Colors.brown[300],
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
