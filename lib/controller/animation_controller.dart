import 'package:flutter/material.dart';

class AnimationHelper {
  // Create bounce animation
  static Animation<double> createBounceAnimation(AnimationController controller) {
    return TweenSequence<double>([
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
    ]).animate(controller);
  }
  
  // Create fade in animation
  static Animation<double> createFadeInAnimation(AnimationController controller) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
      ),
    );
  }
  
  // Create slide animation
  static Animation<Offset> createSlideAnimation(
    AnimationController controller, {
    Offset begin = const Offset(0, 0.1),
    Offset end = Offset.zero,
  }) {
    return Tween<Offset>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    ));
  }
  
  // Create count animation
  static Animation<int> createCountAnimation(
    AnimationController controller,
    int end, {
    int begin = 0,
    Curve curve = Curves.easeOutCubic,
  }) {
    return IntTween(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.2, 0.9, curve: curve),
      ),
    );
  }
}