import 'package:flutter/material.dart';

class CustomScaleButton extends StatefulWidget {
  final Widget child;
  final double scale;
  final Duration duration;
  final VoidCallback? onTap;
  final HitTestBehavior behavior;

  const CustomScaleButton({
    super.key,
    required this.child,
    this.scale = 0.90,
    this.duration = const Duration(milliseconds: 100),
    this.onTap,
    this.behavior = HitTestBehavior.opaque,
  });

  @override
  State<CustomScaleButton> createState() => _CustomScaleButtonState();
}

class _CustomScaleButtonState extends State<CustomScaleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scale).animate(
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
    return GestureDetector(
      onTap: widget.onTap,
      behavior: widget.behavior,
      child: Listener(
        onPointerDown: (_) => _controller.forward(),
        onPointerUp: (_) => _controller.reverse(),
        onPointerCancel: (_) => _controller.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: widget.child,
        ),
      ),
    );
  }
}
