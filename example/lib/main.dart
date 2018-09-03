import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pimp_my_button/pimp_my_button.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: PimpedButton(
          widgetBuilder: (childContext) {
            return FloatingActionButton(onPressed: () {
              PimpedButtonState.playAnimation(childContext, this);
            });
          },
          particle: DemoParticle(),
          duration: Duration(milliseconds: 500),
        ),
      ),
    );
  }
}

class DemoParticle extends Particle {
  @override
  void paint(Canvas canvas, Size size, progress) {
    CenterParticle(
        child: ContainerParticle(children: [
      IntervalParticle(
          interval: Interval(0.0, 0.5, curve: Curves.easeIn),
          child: PositionedParticle(
            position: Offset(40.0, 100.0),
            child: PoppingCircle(
              color: Colors.black,
            ),
          )),
      IntervalParticle(
          interval: Interval(0.2, 0.5, curve: Curves.easeIn),
          child: PositionedParticle(
            position: Offset(-30.0, -40.0),
            child: PoppingCircle(
              color: Colors.black,
            ),
          )),
      IntervalParticle(
          interval: Interval(0.4, 0.8, curve: Curves.easeIn),
          child: PositionedParticle(
            position: Offset(50.0, -70.0),
            child: PoppingCircle(
              color: Colors.black,
            ),
          )),
      IntervalParticle(
          interval: Interval(0.5, 1.0, curve: Curves.easeIn),
          child: PositionedParticle(
            position: Offset(-50.0, 80.0),
            child: PoppingCircle(
              color: Colors.black,
            ),
          )),
      Mirror(
          numberOfParticles: 6,
          child: MovingPositionedParticle(
            begin: Offset(0.0, 20.0),
            end: Offset(0.0, 60.0),
            child: FadingRect(width: 5.0, height: 15.0, color: Colors.pink),
          ),
          initialRotation: -pi / 5),
    ])).paint(canvas, size, progress);
  }
}
