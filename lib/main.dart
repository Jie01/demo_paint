import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class DrawingArea {
  Offset point;
  Paint areaPaint;
  DrawingArea({this.point, this.areaPaint});
}

class _HomePageState extends State<HomePage> {
  List<DrawingArea> point = [];

  Color sColor;
  double sWidth;

  @override
  void initState() {
    sColor = Colors.black;
    sWidth = 2.0;
    super.initState();
  }

  void selectColor() {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Color Picker"),
        content: SingleChildScrollView(
          child: ColorPicker(
              pickerColor: sColor,
              onColorChanged: (color) {
                this.setState(() {
                  sColor = color;
                });
              }),
        ),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Got it"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(138, 35, 135, 1.0),
                  Color.fromRGBO(233, 64, 87, 1.0),
                  Color.fromRGBO(242, 113, 33, 1.0),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width * 0.85,
                  height: height * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onPanDown: (d) {
                      this.setState(() {
                        point.add(DrawingArea(
                            point: d.localPosition,
                            areaPaint: Paint()
                              ..strokeCap = StrokeCap.round
                              ..strokeWidth = sWidth
                              ..isAntiAlias = true
                              ..color = sColor));
                      });
                    },
                    onPanUpdate: (d) {
                      this.setState(() {
                        point.add(DrawingArea(
                            point: d.localPosition,
                            areaPaint: Paint()
                              ..strokeCap = StrokeCap.round
                              ..strokeWidth = sWidth
                              ..isAntiAlias = true
                              ..color = sColor));
                      });
                    },
                    onPanEnd: (d) {
                      this.setState(() {
                        point.add(null);
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CustomPaint(
                        painter: MyCustomPaint(points: point),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconsBtn(
                        icon: Icons.color_lens,
                        press: () {
                          selectColor();
                        },
                        color: sColor,
                      ),
                      Expanded(
                        child: Slider(
                          min: 1.0,
                          max: 7.0,
                          activeColor: sColor,
                          value: sWidth,
                          inactiveColor: sColor.withOpacity(0.4),
                          onChanged: (v) {
                            this.setState(() {
                              sWidth = v;
                            });
                          },
                        ),
                      ),
                      Text("${sWidth.toStringAsFixed(1)}"),
                      IconsBtn(
                        icon: Icons.layers_clear,
                        press: () {
                          this.setState(() {
                            point.clear();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyCustomPaint extends CustomPainter {
  List<DrawingArea> points;

  MyCustomPaint({@required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint bacground = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTRB(0, 0, size.width, size.height);
    canvas.drawRect(rect, bacground);

    for (int a = 0; a < points.length - 1; a++) {
      if (points[a] != null && points[a + 1] != null) {
        Paint paint = points[a].areaPaint;

        canvas.drawLine(points[a].point, points[a + 1].point, paint);
      } else if (points[a] != null && points[a + 1] == null) {
        Paint paint = points[a].areaPaint;

        canvas.drawPoints(PointMode.points, [points[a].point], paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint

    return true;
  }
}

class IconsBtn extends StatelessWidget {
  final IconData icon;
  final Function press;
  final Color color;

  const IconsBtn({
    Key key,
    @required this.icon,
    @required this.press,
    this.color = Colors.black87,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: press,
      child: Icon(
        icon,
        color: color,
      ),
      padding: EdgeInsets.all(7),
      height: 5,
      minWidth: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
    );
  }
}
