import 'dart:math';

import 'package:flutter/material.dart';

class OntopInfo {
  double x;
  double y;
  double width;
  double height;
  double ratio;
  Shap shap;
  Color? color;
  Widget? context;

  OntopInfo({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.ratio = 0,
    this.shap = Shap.circle,
    this.color,
    this.context,
  });

  double get maxLine => max(width, height);
}

enum Shap { rectangle, circle }
