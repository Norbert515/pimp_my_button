import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pimp_my_button/pimp_my_button.dart';

class DemoParticle extends Particle {
  @override
  void paint(Canvas canvas, Size size, progress, seed) {
    CenterParticle(
        child: ContainerParticle(children: [
          IntervalParticle(
              interval: Interval(0.0, 0.5, curve: Curves.easeIn),
              child: PositionedParticle(
                position: Offset(40.0 + randomOffset(seed, 40), 100.0 + randomOffset(seed, 40)),
                child: PoppingCircle(
                  color: Colors.deepOrangeAccent,
                ),
              )),
          IntervalParticle(
              interval: Interval(0.2, 0.5, curve: Curves.easeIn),
              child: PositionedParticle(
                position: Offset(-30.0 + randomOffset(seed, 40), -40.0 + randomOffset(seed, 40)),
                child: PoppingCircle(
                  color: Colors.green,
                ),
              )),
          IntervalParticle(
              interval: Interval(0.4, 0.8, curve: Curves.easeIn),
              child: PositionedParticle(
                position: Offset(50.0 + randomOffset(seed, 40), -70.0 + randomOffset(seed, 40)),
                child: PoppingCircle(
                  color: Colors.indigo,
                ),
              )),
          IntervalParticle(
              interval: Interval(0.5, 1.0, curve: Curves.easeIn),
              child: PositionedParticle(
                position: Offset(-50.0 + randomOffset(seed, 40), 80.0 + randomOffset(seed, 40)),
                child: PoppingCircle(
                  color: Colors.teal,
                ),
              )),
          Mirror(
              numberOfParticles: 6,
              child: MovingPositionedParticle(
                begin: Offset(0.0, 20.0),
                end: Offset(0.0, 60.0),
                child: FadingRect(width: 5.0, height: 15.0, color: Colors.pink),
              ),
              // division by 0 is not good ;)
              initialRotation: -pi / (Random(seed).nextInt(8) + 1)),
        ])).paint(canvas, size, progress, seed);
  }

  double randomOffset(int seed, int range) {
    return range / 2 - Random(seed).nextInt(range);
  }
}