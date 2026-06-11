import 'dart:async';

import 'package:flutter/material.dart';

enum SharedEntranceType { fade, fadeUp, fadeDown, fadeLeft, fadeRight, scale }

class SharedEntranceAnimation extends StatefulWidget {
  final Widget child;
  final SharedEntranceType type;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final double distance;
  final double beginScale;

  const SharedEntranceAnimation({
    super.key,
    required this.child,
    this.type = SharedEntranceType.fadeUp,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 350),
    this.curve = Curves.easeOut,
    this.distance = 24,
    this.beginScale = 0.96,
  });

  @override
  State<SharedEntranceAnimation> createState() =>
      _SharedEntranceAnimationState();
}

class _SharedEntranceAnimationState extends State<SharedEntranceAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    final curved = CurvedAnimation(parent: _controller, curve: widget.curve);
    _opacity = Tween<double>(begin: 0, end: 1).animate(curved);
    _offset = Tween<Offset>(
      begin: _offsetFor(widget.type, widget.distance),
      end: Offset.zero,
    ).animate(curved);
    _scale = Tween<double>(
      begin: widget.type == SharedEntranceType.scale ? widget.beginScale : 1,
      end: 1,
    ).animate(curved);
    unawaited(_start());
  }

  Future<void> _start() async {
    if (widget.delay > Duration.zero) {
      await Future<void>.delayed(widget.delay);
    }
    if (mounted) {
      _controller.forward();
    }
  }

  Offset _offsetFor(SharedEntranceType type, double distance) {
    return switch (type) {
      SharedEntranceType.fadeUp => Offset(0, distance),
      SharedEntranceType.fadeDown => Offset(0, -distance),
      SharedEntranceType.fadeLeft => Offset(distance, 0),
      SharedEntranceType.fadeRight => Offset(-distance, 0),
      _ => Offset.zero,
    };
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final translated = Transform.translate(
          offset: _offset.value,
          child: Transform.scale(scale: _scale.value, child: child),
        );
        return Opacity(opacity: _opacity.value, child: translated);
      },
      child: widget.child,
    );
  }
}
