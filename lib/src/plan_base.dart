import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:two_d_plan/src/ontop_widget.dart';
import 'package:two_d_plan/two_d_plan.dart';

class PlanBase extends StatelessWidget {
  final Image? image;
  final double width;
  final double height;
  final List<Color> color;
  final List<OntopInfo> onTopList;
  final bool scrollable;
  final Function(OntopInfo moveTager, Offset delta)? onTopMove;
  final Function(OntopInfo reSizeTager, Offset delta)? onTopReSize;

  PlanBase({
    Key? key,
    this.image,
    List<Color> color = const [],
    required this.width,
    required this.height,
    this.onTopMove,
    this.onTopList = const [],
    this.scrollable = true,
    this.onTopReSize,
  })  : color = color.length < 2
            ? color.isEmpty
                ? [Colors.transparent, Colors.transparent]
                : [...color, ...color]
            : color,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => _PlanBase(
        image: image,
        color: color,
        constraints: constraints,
        width: width,
        height: height,
        onTopList: onTopList,
        scrollable: scrollable,
        onTopMove: onTopMove,
        onTopReSize: onTopReSize,
      ),
    );
  }
}

class _PlanBase extends StatefulWidget {
  final Image? image;
  final List<Color> color;
  final BoxConstraints constraints;
  final double width;
  final double height;
  final List<OntopInfo> onTopList;
  final bool scrollable;
  final Function(OntopInfo moveTager, Offset delta)? onTopMove;
  final Function(OntopInfo reSizeTager, Offset delta)? onTopReSize;
  const _PlanBase({
    Key? key,
    required this.image,
    required this.color,
    required this.constraints,
    required this.width,
    required this.height,
    required this.onTopList,
    required this.scrollable,
    required this.onTopMove,
    required this.onTopReSize,
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
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: widget.color,
                        ),
                      ),
                      child: Stack(children: [
                        if (widget.image != null) widget.image!,
                        ...widget.onTopList
                            .map((e) => OntopWidget(
                                  scale: startingScale * baseScale,
                                  ontopInfo: e,
                                  move: (detail) {
                                    if (widget.onTopMove == null) return;
                                    final maxX = widget.width - e.width;
                                    final maxY = widget.height - e.height;
                                    widget.onTopMove!(
                                        e,
                                        Offset((e.x + detail.dx).clamp(0, maxX),
                                            (e.y + detail.dy).clamp(0, maxY)));
                                  },
                                  reSize: widget.onTopReSize != null
                                      ? (detail) {
                                          if (e.x + e.width + detail.dx <
                                                  widget.width &&
                                              e.y + e.height + detail.dy <
                                                  widget.height) {
                                            widget.onTopReSize!(e, detail);
                                          }
                                        }
                                      : null,
                                ))
                            .toList(),
                      ]),
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
