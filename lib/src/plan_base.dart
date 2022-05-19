import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:two_d_plan/src/ontop_widget.dart';
import 'package:two_d_plan/two_d_plan.dart';

class PlanBase extends StatelessWidget {
  final double width;
  final double height;
  final List<OntopInfo> onTopList;
  final bool scrollable;
  final Function(OntopInfo moveTager, Offset delta)? onTopMove;

  const PlanBase({
    Key? key,
    required this.width,
    required this.height,
    this.onTopMove,
    this.onTopList = const [],
    this.scrollable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => _PlanBase(
        constraints: constraints,
        width: width,
        height: height,
        onTopList: onTopList,
        scrollable: scrollable,
        onTopMove: onTopMove,
      ),
    );
  }
}

class _PlanBase extends StatefulWidget {
  final BoxConstraints constraints;
  final double width;
  final double height;
  final List<OntopInfo> onTopList;
  final bool scrollable;
  final Function(OntopInfo moveTager, Offset delta)? onTopMove;
  const _PlanBase({
    Key? key,
    required this.constraints,
    required this.width,
    required this.height,
    required this.onTopList,
    required this.scrollable,
    required this.onTopMove,
  }) : super(key: key);

  @override
  State<_PlanBase> createState() => __PlanBaseState();
}

class __PlanBaseState extends State<_PlanBase> {
  late double scale;
  late double startingScale;
  Offset planDelta = Offset.zero;

  late Offset startingPoint;

  double get baseScale {
    return min(widget.constraints.maxHeight / widget.height,
        widget.constraints.maxWidth / widget.width);
  }

  void reSetBaseInfo() {
    scale = .9;
    startingScale = scale;
  }

  @override
  void initState() {
    super.initState();
    reSetBaseInfo();
  }

  @override
  void didUpdateWidget(covariant _PlanBase oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.constraints != oldWidget.constraints) {
      reSetBaseInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent && widget.scrollable) {
          if (scale > 1 || pointerSignal.scrollDelta.dy < 0) {
            scale = scale + -pointerSignal.scrollDelta.dy / 1000 * scale;
          }
          setState(() {});
        }
      },
      child: Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.center,
        children: [
          GestureDetector(
            onScaleStart: (details) {
              startingScale = scale;
              startingPoint = details.localFocalPoint - planDelta * scale;
            },
            onScaleUpdate: (details) {
              setState(() {
                if (details.scale != 1) {
                  final temp =
                      scale + (details.scale * startingScale - scale) * 0.5;
                  if (temp > 0.9) {
                    scale = temp;
                  }
                } else {
                  planDelta = (details.localFocalPoint - startingPoint) / scale;
                }
              });
            },
            onScaleEnd: (details) => setState(() {
              startingScale = scale;
            }),
            child: ClipRect(
              child: Transform.scale(
                scale: scale,
                child: Transform.translate(
                  offset: planDelta,
                  child: FittedBox(
                    child: Container(
                      width: widget.width,
                      height: widget.height,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.blue,
                            Colors.red,
                          ],
                        ),
                      ),
                      child: Stack(
                          children: widget.onTopList
                              .map((e) => OntopWidget(
                                    scale: startingScale * baseScale,
                                    ontopInfo: e,
                                    move: (detail) {
                                      if (widget.onTopMove != null &&
                                          e.x + e.width + detail.dx <=
                                              widget.width &&
                                          e.y + e.hight + detail.dy <=
                                              widget.height) {
                                        widget.onTopMove!(e, detail);
                                      }
                                    },
                                  ))
                              .toList()),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
