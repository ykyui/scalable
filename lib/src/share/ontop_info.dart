import 'package:flutter/material.dart';

class OntopInfo {
  double x;
  double y;
  double width;
  double hight;
  double ratio;
  Shap shap;
  Color? color;
  Widget? context;

  OntopInfo({
    required this.x,
    required this.y,
    required this.width,
    required this.hight,
    this.ratio = 0,
    this.shap = Shap.circle,
    this.color,
    this.context,
  });
}

enum Shap { rectangle, circle }
