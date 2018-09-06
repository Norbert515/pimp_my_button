
import 'package:pimp_my_button/pimp_my_button.dart';
import 'package:flutter/material.dart';

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
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: PimpedButton(
                        particle: DemoParticle(),
                        pimpedWidgetBuilder: (context, controller) {
                          return FloatingActionButton(onPressed: () {
                            controller.forward(from: 0.0);
                          },);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
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
                  ),
                  Expanded(
                    child: Center(
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
                  ),
                ],
              ),
            ),
            PimpedButton(
              particle: ListTileDemoParticle(),
              pimpedWidgetBuilder: (context, controller) {
                return ListTile(
                  title: Text("ListTile"),
                  subtitle: Text("Some nice subtitle"),
                  trailing: Icon(Icons.add),
                  onTap: () {
                    controller.forward(from: 0.0);
                  },
                );
              },
            ),
            Center(
              child: PimpedButton(
                particle: Rectangle2DemoParticle(),
                pimpedWidgetBuilder: (context, controller) {
                  return IconButton(
                    icon: Icon(Icons.favorite_border),
                    color: Colors.indigo,
                    onPressed: () {
                      controller.forward(from: 0.0);
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: Center(
                child: PimpedButton(
                  particle: Rectangle3DemoParticle(),
                  pimpedWidgetBuilder: (context, controller) {
                    return RaisedButton(onPressed: () {
                      controller.forward(from: 0.0);
                    },
                      child: Text("Rectangles"),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

