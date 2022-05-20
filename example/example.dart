import 'package:flutter/material.dart';
import 'package:two_d_plan/two_d_plan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
          body: PlanBase(
        border: Border.all(width: .3),
        width: 100,
        height: 100,
        onTopList: [
          OntopInfo(
            x: 10,
            y: 10,
            width: 20,
            height: 20,
            context: const Text("1"),
          ),
          OntopInfo(
            x: 80,
            y: 70,
            width: 20,
            height: 20,
            context: const Text("2"),
          ),
          OntopInfo(
            x: 5,
            y: 65,
            width: 30,
            height: 30,
            context: const Text("3"),
          ),
        ],
        lineList: [
          LineInfo(
            x: 40,
            y: 0,
            direction: LineDirection.vertical,
            length: 40,
          ),
          LineInfo(
            x: 0,
            y: 40,
            direction: LineDirection.horizontal,
            length: 30,
          ),
          LineInfo(
            x: 70,
            y: 60,
            direction: LineDirection.vertical,
            length: 40,
          )
        ],
        onTopMove: (info, delta) {
          info.x = delta.dx;
          info.y = delta.dy;
        },
        onTopReSize: (info, delta) {
          info.width += delta.dx;
          info.height += delta.dy;
        },
      )),
    );
  }
}
