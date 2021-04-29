import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_finder/logic/algorithms.dart';

class StaticNodePainter extends CustomPainter {
  final List<List<Color>> staticNodes;
  final double unitSize;

  StaticNodePainter(this.staticNodes, this.unitSize);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    for (var i = 0; i < staticNodes.length; i++)
      for (var j = 0; j < staticNodes[0].length; j++) {
        if (staticNodes[i][j] != null) {
          canvas.drawRect(
              Rect.fromLTWH((unitSize + 1) * i, (unitSize + 1) * j,
                  unitSize + 2, unitSize + 2),
              paint..color = staticNodes[i][j]);
        }
      }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class GridPainter extends CustomPainter {
  GridPainter(this.rows, this.columns, this.unitSize, this.width, this.height,
      this.context);
  final BuildContext context;
  final int rows;
  final int columns;
  final double unitSize;
  final double width;
  final double height;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    var background = Rect.fromLTWH(0, 0, size.width, size.height);
    paint.color = Theme.of(context).scaffoldBackgroundColor;
    canvas.drawRect(background, paint);

    paint.color = Theme.of(context).primaryColorLight;
    paint.strokeWidth = 1;

    for (var i = 0; i < rows + 1; i++) {
      canvas.drawLine(Offset(i.toDouble() * (unitSize + 1) + 0.5, 0),
          Offset(i.toDouble() * (unitSize + 1) + 0.5, height), paint);
    }

    for (var i = 0; i < columns + 1; i++) {
      canvas.drawLine(Offset(0, i.toDouble() * (unitSize + 1) + 0.5),
          Offset(width, i.toDouble() * (unitSize + 1) + 0.5), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class PathPainter extends CustomPainter {
  PathPainter(this.currentNode, this.unitSize);
  final double unitSize;
  final Node currentNode;
  Node drawingNode;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30;

    Path path = Path();
    drawingNode = currentNode;
    path.moveTo(currentNode.i * (unitSize + 1) + unitSize / 2,
        currentNode.j * (unitSize + 1) + unitSize / 2);
    while (drawingNode.parent != null) {
      drawingNode = drawingNode.parent;
      path.lineTo(drawingNode.i * (unitSize + 1) + unitSize / 2,
          drawingNode.j * (unitSize + 1) + unitSize / 2);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(PathPainter oldDelegate) {
    return oldDelegate.currentNode != currentNode ? true : false;
  }
}

class SecondPathPainter extends CustomPainter {
  SecondPathPainter(this.currentNode, this.unitSize);
  final double unitSize;
  final Node currentNode;
  Node drawingNode;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30;

    Path path = Path();
    drawingNode = currentNode;
    path.moveTo(currentNode.i * (unitSize + 1) + unitSize / 2,
        currentNode.j * (unitSize + 1) + unitSize / 2);
    while (drawingNode.parent2 != null) {
      drawingNode = drawingNode.parent2;
      path.lineTo(drawingNode.i * (unitSize + 1) + unitSize / 2,
          drawingNode.j * (unitSize + 1) + unitSize / 2);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(SecondPathPainter oldDelegate) {
    return oldDelegate.currentNode != currentNode ? true : false;
  }
}

abstract class NodePainter extends CustomPainter {
  NodePainter(this.unitSize, this.fraction, this.color);
  double fraction;
  double unitSize;
  Color color;

  @override
  bool shouldRepaint(NodePainter oldDelegate) {
    return oldDelegate.fraction != fraction ? true : false;
  }
}

class WallNodePainter extends NodePainter {
  WallNodePainter(double unitSize, double fraction, Color color)
      : super(unitSize, fraction, color);

  @override
  void paint(Canvas canvas, Size size) {
    var rectl = Rect.fromCenter(
      center: Offset(unitSize / 2, unitSize / 2),
      width: fraction * (unitSize + 2),
      height: fraction * (unitSize + 2),
    );
    Paint paint = Paint()..color = color;
    canvas.drawRect(rectl, paint);
  }
}

class VisitedNodePainter extends NodePainter {
  VisitedNodePainter(double unitSize, double fraction, Color color)
      : super(unitSize, fraction, color);

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Rect.fromCenter(
      center: Offset(unitSize / 2, unitSize / 2),
      width: fraction * (unitSize + 2),
      height: fraction * (unitSize + 2),
    );
    var rrect =
        RRect.fromRectAndRadius(rect, Radius.circular((1 - fraction) * 100));
    Paint paint = Paint()..color = color;
    canvas.drawRRect(rrect, paint);
  }
}
