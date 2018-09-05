import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pimp_my_button/pimp_my_button.dart';

class DemoParticle extends Particle {
  @override
  void paint(Canvas canvas, Size size, progress, seed) {
    Random random = Random(seed);
    int randomMirrorOffset = random.nextInt(8) + 1;
    ContainerParticle(children: [
      FourRandomSlotParticle(children: [
        IntervalParticle(
          interval: Interval(0.0, 0.5, curve: Curves.easeIn),
          child: PoppingCircle(
            color: Colors.deepOrangeAccent,
          ),
        ),
        IntervalParticle(
          interval: Interval(0.2, 0.5, curve: Curves.easeIn),
          child: PoppingCircle(
            color: Colors.green,
          ),
        ),
        IntervalParticle(
          interval: Interval(0.4, 0.8, curve: Curves.easeIn),
          child: PoppingCircle(
            color: Colors.indigo,
          ),
        ),
        IntervalParticle(
          interval: Interval(0.5, 1.0, curve: Curves.easeIn),
          child: PoppingCircle(
            color: Colors.teal,
          ),
        ),
      ]),
      CircleMirror(
          numberOfParticles: 6,
          child: AnimatedPositionedParticle(
            begin: Offset(0.0, 20.0),
            end: Offset(0.0, 60.0),
            child: FadingRect(width: 5.0, height: 15.0, color: Colors.pink),
          ),
          // division by 0 is not good ;)
          initialRotation: -pi / randomMirrorOffset),
      CircleMirror.builder(
          numberOfParticles: 6,
          particleBuilder: (index) {
            return IntervalParticle(
                child: AnimatedPositionedParticle(
                  begin: Offset(0.0, 30.0),
                  end: Offset(0.0, 50.0 + (7.5 - 15 * random.nextDouble())),
                  child: FadingTriangle(
                      baseSize: 6.0 + random.nextDouble() * 4.0,
                      heightToBaseFactor: 1.0 + random.nextDouble(),
                      variation: random.nextDouble(),
                      color: Colors.green),
                ),
                interval: Interval(
                  0.0,
                  0.8,
                ));
          },
          // division by 0 is not good ;)
          initialRotation: -pi / randomMirrorOffset + 8),
    ]).paint(canvas, size, progress, seed);
  }

  double randomOffset(Random random, int range) {
    return range / 2 - random.nextInt(range);
  }
}

class RectangleDemoParticle extends Particle {
  @override
  void paint(Canvas canvas, Size size, progress, seed) {
    Random random = Random(seed);
    int randomMirrorOffset = random.nextInt(8) + 1;
    ContainerParticle(children: [
      FourRandomSlotParticle(children: [
        IntervalParticle(
          interval: Interval(0.0, 0.5, curve: Curves.easeIn),
          child: PoppingCircle(
            color: Colors.deepOrangeAccent,
          ),
        ),
        IntervalParticle(
          interval: Interval(0.2, 0.5, curve: Curves.easeIn),
          child: PoppingCircle(
            color: Colors.green,
          ),
        ),
        IntervalParticle(
          interval: Interval(0.4, 0.8, curve: Curves.easeIn),
          child: PoppingCircle(
            color: Colors.indigo,
          ),
        ),
        IntervalParticle(
          interval: Interval(0.5, 1.0, curve: Curves.easeIn),
          child: PoppingCircle(
            color: Colors.teal,
          ),
        ),
      ]),
      RectangleMirror.builder(
          numberOfParticles: 13,
          particleBuilder: (int) {
            return AnimatedPositionedParticle(
              begin: Offset(0.0, -10.0),
              end: Offset(0.0, -60.0),
              child: FadingRect(width: 5.0, height: 15.0, color: intToColor(int)),
            );
          },
          // division by 0 is not good ;)
          initialRotation: -pi / randomMirrorOffset),
      CircleMirror.builder(
          numberOfParticles: 6,
          particleBuilder: (index) {
            return IntervalParticle(
                child: AnimatedPositionedParticle(
                  begin: Offset(0.0, 30.0),
                  end: Offset(0.0, 50.0 + (7.5 - 15 * random.nextDouble())),
                  child: FadingTriangle(
                      baseSize: 6.0 + random.nextDouble() * 4.0,
                      heightToBaseFactor: 1.0 + random.nextDouble(),
                      variation: random.nextDouble(),
                      color: Colors.green),
                ),
                interval: Interval(
                  0.0,
                  0.8,
                ));
          },
          // division by 0 is not good ;)
          initialRotation: -pi / randomMirrorOffset + 8),
    ]).paint(canvas, size, progress, seed);
  }

  double randomOffset(Random random, int range) {
    return range / 2 - random.nextInt(range);
  }

  Color intToColor(int col) {
    col = col % 5;
    if (col == 0) return Colors.red;
    if (col == 1) return Colors.green;
    if (col == 2) return Colors.orange;
    if (col == 3) return Colors.blue;
    if (col == 4) return Colors.pink;
    if (col == 5) return Colors.brown;
    return Colors.black;
  }
}

class Rectangle2DemoParticle extends Particle {
  @override
  void paint(Canvas canvas, Size size, progress, seed) {
    Random random = Random(seed);
    int randomMirrorOffset = random.nextInt(8) + 1;
    ContainerParticle(children: [
      FourRandomSlotParticle(children: [
        IntervalParticle(
          interval: Interval(0.0, 0.5, curve: Curves.easeIn),
          child: PoppingCircle(
            color: Colors.deepOrangeAccent,
          ),
        ),
        IntervalParticle(
          interval: Interval(0.2, 0.5, curve: Curves.easeIn),
          child: PoppingCircle(
            color: Colors.green,
          ),
        ),
        IntervalParticle(
          interval: Interval(0.4, 0.8, curve: Curves.easeIn),
          child: PoppingCircle(
            color: Colors.indigo,
          ),
        ),
        IntervalParticle(
          interval: Interval(0.5, 1.0, curve: Curves.easeIn),
          child: PoppingCircle(
            color: Colors.teal,
          ),
        ),
      ]),
      RectangleMirror.builder(
          numberOfParticles: 6,
          particleBuilder: (int) {
            return AnimatedPositionedParticle(
              begin: Offset(0.0, -10.0),
              end: Offset(0.0, -60.0),
              child: FadingRect(width: 5.0, height: 15.0, color: intToColor(int)),
            );
          },
          // division by 0 is not good ;)
          initialRotation: -pi / randomMirrorOffset),
    ]).paint(canvas, size, progress, seed);
  }

  double randomOffset(Random random, int range) {
    return range / 2 - random.nextInt(range);
  }

  Color intToColor(int col) {
    col = col % 5;
    if (col == 0) return Colors.red;
    if (col == 1) return Colors.green;
    if (col == 2) return Colors.orange;
    if (col == 3) return Colors.blue;
    if (col == 4) return Colors.pink;
    if (col == 5) return Colors.brown;
    return Colors.black;
  }
}
