import 'dart:math';

import 'package:example/particles.dart';
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
      /*  body: new Center(
        child: PimpedButton(
          widgetBuilder: (childContext) {
            return FloatingActionButton(onPressed: () {
              PimpedButtonState.playAnimation(childContext, this);
            });
          },
          particle: DemoParticle(),
          duration: Duration(milliseconds: 500),
        ),
      ),*/
      body: Center(
        child: GridView(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        children: <Widget>[
          Center(
            child: PimpedButton(
              particle: DemoParticle(),
              pimpedWidgetBuilder: (context, controller) {
                return FloatingActionButton(onPressed: () {
                  controller.forward(from: 0.0);
                },);
              },
            ),
          ),
          Center(
            child: PimpedButton(
              particle: RectangleDemoParticle(),
              pimpedWidgetBuilder: (context, controller) {
                return RaisedButton(onPressed: () {
                  controller.forward(from: 0.0);
                },
                child: Text("Special button"),
                );
              },
            ),
          ),
          Center(
            child: PimpedButton(
              particle: Rectangle2DemoParticle(),
              pimpedWidgetBuilder: (context, controller) {
                return MaterialButton(onPressed: () {
                  controller.forward(from: 0.0);
                },
                  child: Text("Special button"),
                );
              },
            ),
          ),
        ],),
      ),
    );
  }
}

