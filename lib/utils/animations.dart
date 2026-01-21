import 'package:flutter/material.dart';

class CustomPageTransition<T> extends PageRouteBuilder<T> {
  CustomPageTransition({
    required Widget page,
    required Widget Function(
      BuildContext,
      Animation<double>,
      Animation<double>,
      Widget,
    ) transitionBuilder,
    Duration duration = const Duration(milliseconds: 300),
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: transitionBuilder,
  );
}

// Slide in from right
class SlideInFromRightRoute<T> extends PageRouteBuilder<T> {
  SlideInFromRightRoute({required Widget page, Duration? duration})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: duration ?? const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
        ),
        child: child,
      );
    },
  );
}

// Fade and scale
class FadeScaleRoute<T> extends PageRouteBuilder<T> {
  FadeScaleRoute({required Widget page, Duration? duration})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: duration ?? const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: child,
        ),
      );
    },
  );
}

// Slide up from bottom
class SlideUpRoute<T> extends PageRouteBuilder<T> {
  SlideUpRoute({required Widget page, Duration? duration})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: duration ?? const Duration(milliseconds: 350),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        ),
        child: child,
      );
    },
  );
}

// Loading spinner animation
class RotationAnimationWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const RotationAnimationWidget({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.curve = Curves.linear,
  });

  @override
  State<RotationAnimationWidget> createState() =>
      _RotationAnimationWidgetState();
}

class _RotationAnimationWidgetState extends State<RotationAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: widget.child,
    );
  }
}

// Pulse animation
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const PulseAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 1),
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

// Bounce animation for buttons
class BounceAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const BounceAnimation({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  State<BounceAnimation> createState() => _BounceAnimationState();
}

class _BounceAnimationState extends State<BounceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse();
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _animation,
        child: widget.child,
      ),
    );
  }
}

// Stagger animation for lists
class StaggerAnimation extends StatefulWidget {
  final List<Widget> children;
  final Duration duration;
  final Duration delay;

  const StaggerAnimation({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 500),
    this.delay = const Duration(milliseconds: 50),
  });

  @override
  State<StaggerAnimation> createState() => _StaggerAnimationState();
}

class _StaggerAnimationState extends State<StaggerAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.children.length,
      (index) => AnimationController(
        duration: widget.duration,
        vsync: this,
      ),
    );

    _animations = _controllers
        .asMap()
        .entries
        .map((entry) {
          AnimationController controller = entry.value;

          return Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: controller,
              curve: Curves.easeOut,
            ),
          );
        })
        .toList();

    _animateSequentially();
  }

  void _animateSequentially() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(widget.delay);
      if (mounted) {
        _controllers[i].forward();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        widget.children.length,
        (index) => FadeTransition(
          opacity: _animations[index],
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-0.1, 0.0),
              end: Offset.zero,
            ).animate(_animations[index]),
            child: widget.children[index],
          ),
        ),
      ),
    );
  }
}
