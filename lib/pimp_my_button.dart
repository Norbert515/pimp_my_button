library pimp_my_button;

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// The bounding box for context in global coordinates.
Rect _globalBoundingBoxFor(BuildContext context) {
  final RenderBox box = context.findRenderObject();
  assert(box != null && box.hasSize);
  return box.localToGlobal(Offset.zero) & box.size;
}

typedef PimpedWidgetBuilder = Widget Function(BuildContext context, AnimationController controller);

class PimpedButton extends StatefulWidget {
  final PimpedWidgetBuilder pimpedWidgetBuilder;

  final Particle particle;

  final Duration duration;

  const PimpedButton({
    Key key,
    @required this.particle,
    this.duration = const Duration(milliseconds: 500),
    @required this.pimpedWidgetBuilder,
  }) : super(key: key);

  @override
  PimpedButtonState createState() => new PimpedButtonState();
}

class PimpedButtonState extends State<PimpedButton> with SingleTickerProviderStateMixin {
  AnimationController controller;

  Random random;
  int seed;

  @override
  void initState() {
    super.initState();
    random = Random();
    seed = random.nextInt(100000000);
    controller = AnimationController(vsync: this, duration: widget.duration);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.forward ||  status == AnimationStatus.reverse) {
        seed = random.nextInt(10000000);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        if(controller.status == AnimationStatus.forward || controller.status == AnimationStatus.reverse) {
          return CustomPaint(
            painter: PimpPainter(
              particle: widget.particle,
              seed: seed,
              controller: controller,
            ),
            child: child,
          );
        } else {
          return child;
        }
      },
      child: widget.pimpedWidgetBuilder(context, controller),
    );
  }
/*
  static Future playAnimation(BuildContext context, TickerProvider vsync) {
    PimpedButtonState state = context.ancestorStateOfType(const TypeMatcher<PimpedButtonState>());

    Rect bounds = _globalBoundingBoxFor(state.context);

    AnimationController controller = AnimationController(vsync: vsync, duration: state.widget.duration);

    int seed = Random().nextInt(100000);
    OverlayEntry entry = OverlayEntry(
      builder: (context) {
        return Positioned.fromRect(
            rect: bounds.inflate(bounds.width),
            child: IgnorePointer(
              child: CustomPaint(
                painter: PimpPainter(
                  particle: state.widget.particle,
                  seed: seed,
                  controller: controller,
                ),
              ),
            ));
      },
    );

    Overlay.of(context).insert(entry);

    controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed || status == AnimationStatus.completed) {
        entry.remove();
      }
    });

    controller.forward();
  }*/
}

class PimpPainter extends CustomPainter {
  PimpPainter({this.particle, this.seed, this.controller}) : super(repaint: controller);

  final Particle particle;
  final int seed;
  final AnimationController controller;

  @override
  void paint(Canvas canvas, Size size) {

    particle.paint(canvas, size, controller.value, seed);
  }

  @override
  bool shouldRepaint(PimpPainter oldDelegate) => true;
}

abstract class Particle {
  void paint(Canvas canvas, Size size, double progress, int seed);
}

class PoppingCircle extends Particle {
  final Color color;

  PoppingCircle({this.color});

  final double radius = 3.0;

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    if (progress < 0.5) {
      canvas.drawCircle(
          Offset.zero,
          radius + (progress * 8),
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 5.0 - progress * 2);
    } else {
      Mirror(
        numberOfParticles: 4,
        child: FadingRect(
          color: color,
          height: 7.0,
          width: 2.0,
        ),
        initialRotation: pi / 4,
      ).paint(canvas, size, progress, seed);
    }
  }
}

/// Mirrors a [Particle] four times.
///
/// Steps are in 90 degrees - pi / 2 radian
class Mirror extends Particle {
  final Particle child;

  final double initialRotation;

  final int numberOfParticles;

  Mirror({this.child, this.initialRotation, this.numberOfParticles});

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    canvas.save();
    canvas.rotate(initialRotation);
    for (int i = 0; i < numberOfParticles; i++) {
      child.paint(canvas, size, progress, seed);
      canvas.rotate(pi / (numberOfParticles / 2));
    }
    canvas.restore();
  }
}

class FadingRect extends Particle {
  final Color color;
  final double width;
  final double height;

  FadingRect({this.color, this.width, this.height});

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    canvas.drawRect(Rect.fromLTWH(-width / 2, height, width, height), Paint()..color = color.withOpacity(1 - progress));
  }
}

class FadingCircle extends Particle {
  final Color color;
  final double radius;

  FadingCircle({this.color, this.radius});

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    canvas.drawCircle(Offset.zero, radius, Paint()..color = color.withOpacity(1 - progress));
  }
}

class PositionedParticle extends Particle {
  PositionedParticle({this.position, this.child});

  final Particle child;

  final Offset position;

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    canvas.save();
    canvas.translate(position.dx, position.dy);
    child.paint(canvas, size, progress, seed);
    canvas.restore();
  }
}

class MovingPositionedParticle extends Particle {
  MovingPositionedParticle({Offset begin, Offset end, this.child}) : offsetTween = Tween<Offset>(begin: begin, end: end);

  final Particle child;

  final Tween<Offset> offsetTween;

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    canvas.save();
    canvas.translate(offsetTween.lerp(progress).dx, offsetTween.lerp(progress).dy);
    child.paint(canvas, size, progress, seed);
    canvas.restore();
  }
}

class IntervalParticle extends Particle {
  final Interval interval;

  final Particle child;

  IntervalParticle({this.child, this.interval});

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    if (progress < interval.begin || progress > interval.end) return;
    child.paint(canvas, size, interval.transform(progress), seed);
  }
}

/// Does nothing else than holding a list of particles and painting them in that order
class ContainerParticle extends Particle {
  final List<Particle> children;

  ContainerParticle({this.children});

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    for (Particle particle in children) {
      particle.paint(canvas, size, progress, seed);
    }
  }
}

class CenterParticle extends Particle {
  final Particle child;

  CenterParticle({this.child});

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    child.paint(canvas, size, progress, seed);
    canvas.restore();
  }
}

class RotationParticle extends Particle {

  final Particle child;

  final double rotation;

  RotationParticle({this.child, this.rotation});

  @override
  void paint(Canvas canvas, Size size, double progress, int seed) {
    canvas.save();
    canvas.rotate(rotation);
    child.paint(canvas, size, progress, seed);
    canvas.restore();
  }

}

class AnimatingRotationParticle extends Particle {

  final Particle child;

  final Tween<double> rotation;

  AnimatingRotationParticle({this.child, double begin, double end}) : rotation = Tween<double>(begin: begin, end: end);

  @override
  void paint(Canvas canvas, Size size, double progress, int seed) {
    canvas.save();
    canvas.rotate(rotation.lerp(progress));
    child.paint(canvas, size, progress, seed);
    canvas.restore();
  }

}