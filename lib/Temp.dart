import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(MaterialApp(
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Color> _colors = [
    Colors.red,
    Colors.pink,
    Colors.blue,
    Colors.yellowAccent,
    Colors.teal
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Stacked list example"),
          backgroundColor: Colors.black,
        ),
        body: Container(
          height: _colors.length * 30,
          child: Stack(
              children: _colors.map((e) {
            int index = _colors.indexOf(e);
            return Padding(
              padding: EdgeInsets.only(top: index * 20),
              child: GestureDetector(
                  //     onTapDown: (TapDownDetails details) {
                  //   _showMenu(context, details.globalPosition);
                  // }
                  onTap: () {
                    setState(() {
                      var value = _colors[index];
                      _colors.remove(value);
                      _colors.insert(_colors.length, value);
                    });
                  },
                  child: AnimatedContainer(
                    padding: EdgeInsets.only(top: index*40),
                    duration: Duration(milliseconds: 500), // Adjust the duration as needed
                    height: 300,
                    color: e,
                  )),
            );
          }).toList()),
        ));
  }
}
