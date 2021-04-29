import 'package:flutter/material.dart';
import 'package:path_finder/logic/algorithms.dart';
import 'package:path_finder/widgets/2d_grid.dart';
import 'package:path_finder/widgets/painters.dart';
import 'package:provider/provider.dart';

class GridWidget extends StatefulWidget {
  final int rows;
  final int columns;
  final double unitsize;
  final double height;
  final double width;

  const GridWidget(
      {Key key,
      this.rows,
      this.columns,
      this.unitsize,
      this.height,
      this.width})
      : super(key: key);
  @override
  _GridWidgetState createState() => _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FittedBox(
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: CustomPaint(
              painter: GridPainter(
                widget.rows,
                widget.columns,
                widget.unitsize,
                widget.width,
                widget.height,
                context,
              ),
            ),
          ),
        ),
        Selector<Grid, List<List<Color>>>(
          selector: (_, model) => model.staticNodes,
          builder: (_, staticNodes, __) {
            return CustomPaint(
              painter: StaticNodePainter(staticNodes, widget.unitsize),
            );
          },
        ),
        Selector<Grid, Node>(
          selector: (_, model) => model.currentNode,
          builder: (_, currentNode, __) {
            return CustomPaint(
              painter: PathPainter(currentNode, widget.unitsize),
            );
          },
        ),
        Selector<Grid, Node>(
          selector: (_, model) => model.currentSecondNode,
          builder: (_, currentNode, __) {
            return CustomPaint(
              painter: SecondPathPainter(currentNode, widget.unitsize),
            );
          },
        ),
        Selector<Grid, List<List<Widget>>>(
          selector: (_, model) => model.nodes,
          shouldRebuild: (a, b) => true,
          builder: (_, nodes, __) {
            return Stack(
              children: <Widget>[
                ...nodes.expand((row) => row).toList().where((w) => w != null)
              ],
            );
          },
        ),
      ],
    );
  }
}
