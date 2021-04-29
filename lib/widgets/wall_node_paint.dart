import 'package:flutter/material.dart';
import 'package:path_finder/widgets/painters.dart';

class WallNodePaintWidget extends StatefulWidget {
  final double unitSize;
  final int i;
  final int j;
  final Color color;
  final Function(int i, int j, Color rect) callback;
  WallNodePaintWidget(
      {this.unitSize, this.i, this.j, this.callback, Key key, this.color})
      : super(key: key);
  @override
  _WallNodePaintWidgetState createState() => _WallNodePaintWidgetState();
}

class _WallNodePaintWidgetState extends State<WallNodePaintWidget>
    with SingleTickerProviderStateMixin {
  double fraction = 0;
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      animationBehavior: AnimationBehavior.preserve,
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.callback(widget.i, widget.j, widget.color);
        }
      });

    animation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.elasticOut))
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
        painter: WallNodePainter(widget.unitSize, fraction, widget.color));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
