library pimp_my_button;

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// The bounding box for context in global coordinates.
Rect _globalBoundingBoxFor(BuildContext context) {
  final RenderBox box = context.findRenderObject();
  assert(box != null && box.hasSize);
  return MatrixUtils.transformRect(box.getTransformTo(null), Offset.zero & box.size);
}

class PimpedButton extends StatefulWidget {
  final WidgetBuilder widgetBuilder;

  const PimpedButton({Key key, this.widgetBuilder}) : super(key: key);

  @override
  PimpedButtonState createState() => new PimpedButtonState();
}

class PimpedButtonState extends State<PimpedButton> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext childContext) {
        return widget.widgetBuilder(childContext);
      },
    );
  }

  static Future playAnimation(BuildContext context, TickerProvider vsync) {
    PimpedButtonState state = context.ancestorStateOfType(const TypeMatcher<PimpedButtonState>());

    Rect bounds = _globalBoundingBoxFor(state.context);

    AnimationController controller = AnimationController(vsync: vsync, duration: Duration(milliseconds: 500));

    double progress = 0.0;
    OverlayEntry entry = OverlayEntry(
      builder: (context) {
        return Positioned.fromRect(
            rect: bounds.inflate(bounds.width),
            child: IgnorePointer(
              child: CustomPaint(
                painter: PimpPainter(progress: progress),
              ),
            ));
      },
    );

    Overlay.of(context).insert(entry);

    controller.addListener(() {
      progress = controller.value;
      entry.markNeedsBuild();
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed || status == AnimationStatus.completed) {
        entry.remove();
      }
    });

    controller.forward();
  }
}

class PimpPainter extends CustomPainter {
  final double progress;

  PimpPainter({@required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    IntervalParticle(
        interval: Interval(0.0,0.5, curve: Curves.easeIn),
        child: PositionedParticle(
          position: Offset(40.0, 100.0),
          child: PoppingCircle(
            color: Colors.black,
          ),
        )
    ).paint(canvas, size, progress);

    IntervalParticle(
      interval: Interval(0.2,0.5, curve: Curves.easeIn),
      child: PositionedParticle(
        position: Offset(-30.0, -40.0),
        child: PoppingCircle(
          color: Colors.black,
        ),
      )
    ).paint(canvas, size, progress);

    IntervalParticle(
        interval: Interval(0.4,0.8, curve: Curves.easeIn),
        child: PositionedParticle(
          position: Offset(50.0, -70.0),
          child: PoppingCircle(
            color: Colors.black,
          ),
        )
    ).paint(canvas, size, progress);

    IntervalParticle(
        interval: Interval(0.5,1.0, curve: Curves.easeIn),
        child: PositionedParticle(
          position: Offset(-50.0, 80.0),
          child: PoppingCircle(
            color: Colors.black,
          ),
        )
    ).paint(canvas, size, progress);


    Mirror(
      numberOfParticles: 6,
        child: MovingPositionedParticle(
          begin: Offset(0.0, 20.0),
          end: Offset(0.0, 60.0),
          child: FadingRect(
              width: 5.0,
              height: 15.0,
              color: Colors.pink
          ),
        ),
        initialRotation: -pi / 5
    ).paint(canvas, size, progress);

  }

  @override
  bool shouldRepaint(PimpPainter oldDelegate) => oldDelegate.progress != progress;
}

abstract class Particle {
  void paint(Canvas canvas, Size size, double progress);
}

class PoppingCircle extends Particle {
  final Color color;

  PoppingCircle({this.color});

  final double radius = 3.0;

  @override
  void paint(Canvas canvas, Size size, double progress) {
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
      ).paint(canvas, size, progress);
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
  void paint(Canvas canvas, Size size, double progress) {
    canvas.save();
    canvas.rotate(initialRotation);
    for (int i = 0; i < numberOfParticles; i++) {
      child.paint(canvas, size, progress);
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
  void paint(Canvas canvas, Size size, double progress) {
    canvas.drawRect(Rect.fromLTWH(-width / 2, height, width, height), Paint()..color = color.withOpacity(1 - progress));
  }
}

class FadingCircle extends Particle {

  final Color color;
  final double radius;

  FadingCircle({this.color, this.radius});

  @override
  void paint(Canvas canvas, Size size, double progress) {
    canvas.drawCircle(Offset.zero, radius, Paint()..color = color.withOpacity(1 - progress));
  }
}

class PositionedParticle extends Particle {

  PositionedParticle({this.position, this.child});

  final Particle child;

  final Offset position;

  @override
  void paint(Canvas canvas, Size size, double progress) {
    canvas.save();
    canvas.translate(position.dx, position.dy);
    child.paint(canvas, size, progress);
    canvas.restore();
  }
}

class MovingPositionedParticle extends Particle {

  MovingPositionedParticle({Offset begin, Offset end, this.child}): offsetTween = Tween<Offset>(begin: begin, end: end);

  final Particle child;


  final Tween<Offset> offsetTween;

  @override
  void paint(Canvas canvas, Size size, double progress) {
    canvas.save();
    canvas.translate(offsetTween.lerp(progress).dx, offsetTween.lerp(progress).dy);
    child.paint(canvas, size, progress);
    canvas.restore();
  }
}

class IntervalParticle extends Particle {

  final Interval interval;

  final Particle child;

  IntervalParticle({this.child, this.interval});

  @override
  void paint(Canvas canvas, Size size, double progress) {
    if(progress < interval.begin || progress > interval.end) return;
    child.paint(canvas, size, interval.transform(progress));
  }

}
