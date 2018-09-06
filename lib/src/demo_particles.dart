import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pimp_my_button/src/pimp_my_button.dart';

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

class DemoParticle extends Particle {
  @override
  void paint(Canvas canvas, Size size, progress, seed) {
    Random random = Random(seed);
    int randomMirrorOffset = random.nextInt(8) + 1;
    CompositeParticle(children: [
      Firework(),
      CircleMirror(
          numberOfParticles: 6,
          child: AnimatedPositionedParticle(
            begin: Offset(0.0, 20.0),
            end: Offset(0.0, 60.0),
            child: FadingRect(width: 5.0, height: 15.0, color: Colors.pink),
          ),
          initialRotation: -pi / randomMirrorOffset),
      CircleMirror.builder(
          numberOfParticles: 6,
          particleBuilder: (index) {
            return IntervalParticle(
                child: AnimatedPositionedParticle(
                  begin: Offset(0.0, 30.0),
                  end: Offset(0.0, 50.0),
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
          initialRotation: -pi / randomMirrorOffset + 8),
    ]).paint(canvas, size, progress, seed);
  }
}

class RectangleDemoParticle extends Particle {
  @override
  void paint(Canvas canvas, Size size, progress, seed) {
    Random random = Random(seed);
    int randomMirrorOffset = random.nextInt(8) + 1;
    CompositeParticle(children: [
      Firework(),
      RectangleMirror.builder(
          numberOfParticles: 13,
          particleBuilder: (int) {
            return AnimatedPositionedParticle(
              begin: Offset(0.0, -10.0),
              end: Offset(0.0, -60.0),
              child: FadingRect(width: 5.0, height: 15.0, color: intToColor(int)),
            );
          },
          initialDistance: -pi / randomMirrorOffset),
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
          initialRotation: -pi / randomMirrorOffset + 8),
    ]).paint(canvas, size, progress, seed);
  }
}

class Rectangle2DemoParticle extends Particle {
  @override
  void paint(Canvas canvas, Size size, progress, seed) {
    Random random = Random(seed);
    int randomMirrorOffset = random.nextInt(8) + 1;
    CompositeParticle(children: [
      Firework(),
      RectangleMirror.builder(
          numberOfParticles: 6,
          particleBuilder: (int) {
            return AnimatedPositionedParticle(
              begin: Offset(0.0, -10.0),
              end: Offset(0.0, -60.0),
              child: FadingRect(width: 5.0, height: 15.0, color: intToColor(int)),
            );
          },
          initialDistance: -pi / randomMirrorOffset),
    ]).paint(canvas, size, progress, seed);
  }
}

class Rectangle3DemoParticle extends Particle {
  @override
  void paint(Canvas canvas, Size size, progress, seed) {
    Random random = Random(seed);
    int randomMirrorOffset = random.nextInt(8) + 1;
    CompositeParticle(children: [
      Firework(),
      RectangleMirror.builder(
          numberOfParticles: 6,
          particleBuilder: (int) {
            return AnimatedPositionedParticle(
                begin: Offset(0.0, -10.0),
                end: Offset(0.0, -50.0),
                child: RotationParticle(
                  rotation: random.nextDouble() * (2 * pi),
                  child: FadingTriangle(
                    baseSize: 12.0 + random.nextDouble(),
                    heightToBaseFactor: 0.8 + random.nextDouble(),
                    variation: random.nextDouble(),
                    color: intToColor(int),
                  ),
                ));
          },
          initialDistance: -pi / randomMirrorOffset),
      RectangleMirror.builder(
          numberOfParticles: 8,
          particleBuilder: (int) {
            return AnimatedPositionedParticle(
                begin: Offset(0.0, -10.0),
                end: Offset(0.0, -30.0),
                child: RotationParticle(
                  rotation: random.nextDouble() * (2 * pi),
                  child: FadingTriangle(
                    baseSize: 12.0 + random.nextDouble(),
                    heightToBaseFactor: 0.8 + random.nextDouble(),
                    variation: random.nextDouble(),
                    color: intToColor(int),
                  ),
                ));
          },
          initialDistance: 80.0),
    ]).paint(canvas, size, progress, seed);
  }

  double randomOffset(Random random, int range) {
    return range / 2 - random.nextInt(range);
  }
}

class ListTileDemoParticle extends Particle {
  @override
  void paint(Canvas canvas, Size size, progress, seed) {
    CompositeParticle(children: [
      Firework(),
      Firework(),
      Firework(),
      RectangleMirror.builder(
          numberOfParticles: 8,
          particleBuilder: (int) {
            return AnimatedPositionedParticle(
              begin: Offset(0.0, -30.0),
              end: Offset(0.0, -80.0),
              child: FadingRect(width: 5.0, height: 15.0, color: intToColor(int)),
            );
          },
          initialDistance: 0.0),
      RectangleMirror.builder(
          numberOfParticles: 5,
          particleBuilder: (int) {
            return AnimatedPositionedParticle(
              begin: Offset(0.0, -25.0),
              end: Offset(0.0, -60.0),
              child: FadingRect(width: 5.0, height: 15.0, color: intToColor(int)),
            );
          },
          initialDistance: 30.0),
      RectangleMirror.builder(
          numberOfParticles: 8,
          particleBuilder: (int) {
            return AnimatedPositionedParticle(
              begin: Offset(0.0, -40.0),
              end: Offset(0.0, -100.0),
              child: FadingRect(width: 5.0, height: 15.0, color: intToColor(int)),
            );
          },
          initialDistance: 80.0),
    ]).paint(canvas, size, progress, seed);
  }

}
