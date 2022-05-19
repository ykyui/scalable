import 'package:flutter/material.dart';
import 'package:two_d_plan/two_d_plan.dart';

class OntopWidget extends StatefulWidget {
  final double scale;
  final OntopInfo ontopInfo;
  final Function(Offset offset) move;
  const OntopWidget({
    Key? key,
    required this.scale,
    required this.ontopInfo,
    required this.move,
  }) : super(key: key);

  @override
  State<OntopWidget> createState() => _OntopWidgetState();
}

class _OntopWidgetState extends State<OntopWidget> {
  Offset delta = Offset.zero;
  Offset localPosition = Offset.zero;
  OntopInfo get ontopInfo => widget.ontopInfo;
  Offset get centerDelta =>
      localPosition - Offset(ontopInfo.width, ontopInfo.hight) / 2;

  @override
  void didUpdateWidget(covariant OntopWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scale != widget.scale) setState(() {});
  }

  Widget get onTopWidget => Container(
        width: ontopInfo.width,
        height: ontopInfo.hight,
        decoration: BoxDecoration(
          color: ontopInfo.color,
          border: Border.all(),
          shape: ontopInfo.shap == Shap.circle
              ? BoxShape.circle
              : BoxShape.rectangle,
        ),
        child: FittedBox(child: ontopInfo.context),
      );

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: ontopInfo.x,
      top: ontopInfo.y,
      child: Draggable(
        onDragStarted: () => delta = Offset.zero,
        onDragUpdate: (details) => delta += details.delta,
        onDragEnd: (details) {
          widget.move((delta + centerDelta) / widget.scale);
          setState(() {});
        },
        feedbackOffset: centerDelta,
        feedback: Card(
          color: Colors.transparent,
          elevation: 0,
          child: Opacity(
            opacity: .8,
            child: Transform.scale(
              scale: widget.scale,
              child: onTopWidget,
            ),
          ),
        ),
        child: MouseRegion(
          onHover: (event) => setState(() {
            localPosition = event.localPosition;
          }),
          child: onTopWidget,
        ),
      ),
    );
  }
}
