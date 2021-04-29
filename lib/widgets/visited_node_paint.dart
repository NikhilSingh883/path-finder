import 'package:flutter/material.dart';
import 'package:path_finder/widgets/painters.dart';

class VisitedNodePaintWidget extends StatefulWidget {
  final double unitSize;
  final int i;
  final int j;
  final Color color;
  final Function(int i, int j, Color color) callback;
  VisitedNodePaintWidget(
      {this.unitSize, Key key, this.i, this.j, this.callback, this.color})
      : super(key: key);
  @override
  _VisitedNodePaintWidgetState createState() => _VisitedNodePaintWidgetState();
}

class _VisitedNodePaintWidgetState extends State<VisitedNodePaintWidget>
    with SingleTickerProviderStateMixin {
  double fraction = 0;
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      animationBehavior: AnimationBehavior.preserve,
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.callback(widget.i, widget.j, widget.color);
        }
      });

    animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear))
      ..addListener(() {
        setState(() {
          fraction = animation.value;
        });
      });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: VisitedNodePainter(widget.unitSize, fraction, widget.color));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
