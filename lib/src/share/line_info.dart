import 'package:flutter/material.dart';
import 'package:two_d_plan/two_d_plan.dart';

class LineInfo extends OntopInfo {
  final LineDirection direction;
  final double thickness;
  LineInfo({
    required super.x,
    required super.y,
    required this.direction,
    required double length,
    this.thickness = 1,
  }) : super(
          width: thickness,
          height: thickness,
          shap: Shap.rectangle,
          color: Colors.black,
        ) {
    this.length = length;
  }

  double get length => direction == LineDirection.vertical ? height : width;

  set length(double length) {
    if (direction == LineDirection.vertical) {
      super.height = length;
    } else {
      super.width = length;
    }
  }
}

enum LineDirection { vertical, horizontal }
