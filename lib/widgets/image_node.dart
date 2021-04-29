import 'package:flutter/material.dart';

class NodeImageWidget extends StatefulWidget {
  final double boxSize;
  final String asset;
  // final Function(Image img) callback;
  NodeImageWidget(
    this.boxSize,
    this.asset,
  ); //this.callback);
  @override
  _NodeImageWidgetState createState() => _NodeImageWidgetState();
}

class _NodeImageWidgetState extends State<NodeImageWidget>
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
    );
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
    return Transform.scale(
      scale: fraction,
      child: Image.asset(
        widget.asset,
        width: widget.boxSize,
        height: widget.boxSize,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
