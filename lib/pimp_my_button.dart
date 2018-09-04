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
      if (status == AnimationStatus.forward || status == AnimationStatus.reverse) {
        seed = random.nextInt(10000000);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        if (controller.status == AnimationStatus.forward || controller.status == AnimationStatus.reverse) {
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
    canvas.translate(size.width / 2, size.height / 2);
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
      CircleMirror(
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

typedef ParticleBuilder = Particle Function(int index);

/// Mirrors a given particle around a circle.
///
/// When using the default constructor you specify one [Particle], this particle
/// is going to be used on its own, this implies that
/// all mirrored particles are identical (expect for the rotation around the circle)
class CircleMirror extends Particle {
  final ParticleBuilder particleBuilder;

  final double initialRotation;

  final int numberOfParticles;

  CircleMirror.builder({this.particleBuilder, this.initialRotation, this.numberOfParticles});

  CircleMirror({Particle child, this.initialRotation, this.numberOfParticles}) : this.particleBuilder = ((index) => child);

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    canvas.save();
    canvas.rotate(initialRotation);
    for (int i = 0; i < numberOfParticles; i++) {
      particleBuilder(i).paint(canvas, size, progress, seed);
      canvas.rotate(pi / (numberOfParticles / 2));
    }
    canvas.restore();
  }
}

/// Mirrors a given particle around a circle.
///
/// When using the default constructor you specify one [Particle], this particle
/// is going to be used on its own, this implies that
/// all mirrored particles are identical (expect for the rotation around the circle)
class RectangleMirror extends Particle {
  final ParticleBuilder particleBuilder;

  final double initialRotation;

  final int numberOfParticles;


  RectangleMirror.builder({this.particleBuilder, this.initialRotation, this.numberOfParticles});

  RectangleMirror({Particle child, this.initialRotation, this.numberOfParticles}) : this.particleBuilder = ((index) => child);

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    canvas.save();
    double totalLength = size.width * 2 + size.height * 2;
    double distanceBetweenParticles = totalLength / numberOfParticles;

    bool onHorizontalAxis = true;
    int side = 0;

    double currentDistance = 0.0;
    assert((distanceBetweenParticles * numberOfParticles).round() == totalLength.round());


    for (int i = 0; i < numberOfParticles; i++) {

      currentDistance += distanceBetweenParticles;
      while(true) {
        if(onHorizontalAxis? currentDistance > size.width : currentDistance > size.height) {
        //  canvas.rotate(pi / 2);
          currentDistance -= onHorizontalAxis? size.width : size.height;
          onHorizontalAxis = !onHorizontalAxis;
          side ++;
        } else {
          if(side == 0) {
            assert(onHorizontalAxis);
            moveTo(canvas, size, currentDistance, 0.0, (){
              particleBuilder(i).paint(canvas, size, progress, seed);
            });
          } else if(side == 1) {
            assert(!onHorizontalAxis);
            moveTo(canvas, size, size.width, currentDistance, (){
              particleBuilder(i).paint(canvas, size, progress, seed);
            });
          } else if(side == 2) {
            assert(onHorizontalAxis);
            moveTo(canvas, size, -currentDistance, size.height, (){
              particleBuilder(i).paint(canvas, size, progress, seed);
            });
          } else if(side == 3) {
            assert(!onHorizontalAxis);
            moveTo(canvas, size, 0.0, -currentDistance, (){
              particleBuilder(i).paint(canvas, size, progress, seed);
            });
          }
          break;
        }
      }


    }

    canvas.restore();
  }


  void moveTo(Canvas canvas, Size size, double x, double y, VoidCallback painter) {
    canvas.save();
    canvas.translate(x - size.width / 2, y - size.height / 2);
    painter();
    canvas.restore();
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

/// Geometry
///
/// These are some basic geometric classes which also fade out as time goes on
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

class FadingTriangle extends Particle {
  /// This controls the shape of the triangle.
  ///
  /// Value between 0 and 1
  final double variation;

  final Color color;

  /// The size of the base side of the triangle.
  final double baseSize;

  /// This is the factor of how much bigger then length than the width is
  final double heightToBaseFactor;

  FadingTriangle({this.variation, this.color, this.baseSize, this.heightToBaseFactor});

  @override
  void paint(Canvas canvas, Size size, double progress, int seed) {
    Path path = Path();
    path.moveTo(0.0, 0.0);
    path.lineTo(baseSize * variation, baseSize * heightToBaseFactor);
    path.lineTo(baseSize, 0.0);
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }
}

class FadingSnake extends Particle {
  @override
  void paint(Canvas canvas, Size size, double progress, int seed) {
    // TODO: implement paint
  }

}