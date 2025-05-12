import 'package:flutter/material.dart';

class AnimatedCounterContainer extends StatefulWidget {
  final bool isBuy;
  const AnimatedCounterContainer({Key? key, required this.isBuy})
      : super(key: key);

  @override
  State<AnimatedCounterContainer> createState() =>
      _AnimatedCounterContainerState();
}

class _AnimatedCounterContainerState extends State<AnimatedCounterContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _fadeOutAnimation;
  late Animation<int> _counterAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

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
        tween: Tween<double>(begin: 1.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 20.0,
      ),
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(1.0),
        weight: 80.0,
      ),
    ]).animate(_controller);

   
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.1, curve: Curves.easeIn),
      ),
    );
    _counterAnimation = IntTween(begin: 0, end: 1000).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.9, curve: Curves.easeOutCubic),
      ),
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
        width: 200,
        height: 250,
        decoration: BoxDecoration(
          color: widget.isBuy
              ? Theme.of(context).primaryColor
              : Theme.of(context).cardColor,
          borderRadius: widget.isBuy
              ? BorderRadius.circular(360)
              : BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              widget.isBuy ? 'BUY' : 'RENT',
              style: TextStyle(
                color:
                    widget.isBuy ? Colors.white : Color.fromARGB(255, 0, 0, 0),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Center(
              child: Text(
                _counterAnimation.value.toString(),
                style: TextStyle(
                  color: widget.isBuy
                      ? Colors.white
                      : Color.fromARGB(255, 0, 0, 0),
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Offers',
              style: TextStyle(
                color:
                    widget.isBuy ? Colors.white : Color.fromARGB(255, 0, 0, 0),
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
