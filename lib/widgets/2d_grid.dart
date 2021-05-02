import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_finder/logic/algorithms.dart';
import 'package:path_finder/widgets/grid.dart';
import 'package:path_finder/widgets/grid_gesture_detector.dart';
import 'package:path_finder/widgets/image_node.dart';
import 'package:path_finder/widgets/visited_node_paint.dart';
import 'package:path_finder/widgets/wall_node_paint.dart';
import 'package:provider/provider.dart';

enum GridObstacleGeneration {
  random,
  backtracker,
  recursive,
}

enum VisualizingAlgorithm {
  astar,
  dijkstra,
  bi_dir_dijkstra,
}

enum Brush {
  wall,
  start,
  finish,
  closed,
  open,
  shortestpath,
}

class Grid extends ChangeNotifier {
  Grid(
    this.rows,
    this.columns,
    this.unitSize,
    this.starti,
    this.startj,
    this.finishi,
    this.finishj,
  ) {
    nodeTypes = List.generate(rows, (_) => List.filled(columns, 0));
    nodes = List.generate(rows, (_) => List.filled(columns, null));
    staticNodes = List.generate(rows, (_) => List.filled(columns, null));
    staticShortPathNode =
        List.generate(rows, (_) => List.filled(columns, null));
    width = unitSize * rows + rows + 1;
    height = unitSize * columns + columns + 1;

    addNode(starti, startj, Brush.start);
    addNode(finishi, finishj, Brush.finish);
    currentNode = Node(finishi, finishj);
    currentSecondNode = Node(starti, startj);
  }

  int starti;
  int startj;
  int finishi;
  int finishj;

  Node currentNode;
  Node currentSecondNode;

  double width;
  double height;
  final int rows;
  final int columns;

  bool _isPanning = false;
  double scale = 1;
  final double unitSize;
  List<List<Widget>> nodes;
  List<List<int>> nodeTypes;
  List<List<Color>> staticNodes;
  List<List<Color>> staticShortPathNode;

  Widget gridWidget({
    Function(int i, int j) onTapNode,
    Function(int i, int j, int k, int l, int type) onDragNode,
    Function(double scale, double zoom) onScaleUpdate,
    Function onDragNodeEnd,
  }) {
    return ChangeNotifierProvider.value(
      value: this,
      child: GridGestureDetector(
        width: width,
        height: height,
        onDragNode: (i, j, k, l, t) => onDragNode(i, j, k, l, t),
        onTapNode: (i, j) => onTapNode(i, j),
        unitSize: unitSize,
        rows: rows,
        columns: columns,
        nodeTypes: nodeTypes,
        onScaleUpdate: (scale, zoom) => 0,
        onDragNodeEnd: () => onDragNodeEnd(),
        child: GridWidget(
          rows: rows,
          columns: columns,
          unitsize: unitSize,
          width: width,
          height: height,
        ),
      ),
    );
  }

  bool boundaryCheckFailed(int i, int j) {
    if (i > rows - 1 || i < 0 || j > columns - 1 || j < 0) return true;
    return false;
  }

  void updateStaticNode(int i, int j, Color color) {
    if (boundaryCheckFailed(i, j)) return;

    staticNodes[i][j] = color;
    notifyListeners();
  }

  void fillWithWall() {
    for (var i = 0; i < nodeTypes.length; i++) {
      for (var j = 0; j < nodeTypes[0].length; j++) {
        nodeTypes[i][j] = 1;
      }
    }
    staticNodes.forEach(
        (l) => l.fillRange(0, nodeTypes[0].length - 1, Color(0xff212121)));
    nodeTypes[starti][startj] = 2;
    nodeTypes[endi][endj] = 3;
    staticNodes[starti][startj] = null;
    staticNodes[endi][endj] = null;
    notifyListeners();
  }

  void removePath(int i, int j) {
    if (nodeTypes[i][j] == 4 || nodeTypes[i][j] == 5) {
      staticNodes[i][j] = null;
      nodeTypes[i][j] = 0;
      nodes[i][j] = null;
      notifyListeners();
    }
  }

  void removeNodeWidgetOnly(int i, int j) {
    if (boundaryCheckFailed(i, j)) {
      return;
    }
    nodes[i][j] = null;
    notifyListeners();
  }

  void removeNode(int i, int j, int t) {
    if (boundaryCheckFailed(i, j)) {
      return;
    }
    staticNodes[i][j] = null;
    if (nodeTypes[i][j] == t) {
      nodeTypes[i][j] = 0;
      nodes[i][j] = null;
      notifyListeners();
    }
  }

  void clearPaths() {
    currentNode = Node(0, 0);
    currentSecondNode = Node(0, 0);
    staticShortPathNode =
        List.generate(rows, (_) => List.filled(columns, null));
    for (var i = nodeTypes.length - 1; i > -1; i--)
      for (var j = nodeTypes[0].length - 1; j > -1; j--) removePath(i, j);
  }

  void drawPath(Node lastNode) {
    staticShortPathNode =
        List.generate(rows, (_) => List.filled(columns, null));

    Node currentNode = lastNode;
    while (currentNode.parent != null) {
      staticShortPathNode[currentNode.i][currentNode.j] = Colors.amber;
      currentNode = currentNode.parent;
    }
    staticShortPathNode[currentNode.i][currentNode.j] = Colors.amber;
    notifyListeners();
  }

  void drawPath2(Node lastNode) {
    currentNode = lastNode;
    notifyListeners();
  }

  void drawSecondPath2(Node lastNode) {
    currentSecondNode = lastNode;
    notifyListeners();
  }

  void addNodeWidgetOnly(int i, int j, Brush type) {
    switch (type) {
      case Brush.start:
        nodes[i][j] = Positioned(
          key: UniqueKey(),
          left: 0.50 + i * (unitSize.toDouble() + 1),
          top: 0.50 + j * (unitSize.toDouble() + 1),
          child: NodeImageWidget(
            unitSize,
            'assets/start.png',
          ),
        );
        break;
      case Brush.finish:
        nodes[i][j] = Positioned(
          key: UniqueKey(),
          left: 0.50 + i * (unitSize.toDouble() + 1),
          top: 0.50 + j * (unitSize.toDouble() + 1),
          child: NodeImageWidget(
            unitSize,
            'assets/finish.png',
          ),
        );
        break;
      default:
    }
    notifyListeners();
  }

  void hoverSpecialNode(int i, int j, Brush type) {
    if (nodeTypes[i][j] == 2 || nodeTypes[i][j] == 3) {
      return;
    }
    switch (type) {
      case Brush.start:
        if (starti != i || startj != j) {
          addNodeWidgetOnly(i, j, Brush.start);
          removeNodeWidgetOnly(starti, startj);
          if (nodeTypes[starti][startj] == 2) {
            removeNode(starti, startj, 2);
          }
          starti = i;
          startj = j;
        }
        break;
      case Brush.finish:
        if (finishi != i || finishj != j) {
          addNodeWidgetOnly(i, j, Brush.finish);
          removeNodeWidgetOnly(finishi, finishj);
          if (nodeTypes[finishi][finishj] == 3) {
            removeNode(finishi, finishj, 3);
          }
          finishi = i;
          finishj = j;
        }
        break;
      default:
    }
  }

  void addSpecialNode(Brush type) {
    switch (type) {
      case Brush.start:
        addNode(starti, startj, Brush.start);
        break;
      case Brush.finish:
        addNode(finishi, finishj, Brush.finish);
        break;
      default:
    }
  }

  void addNode(int i, int j, Brush type) {
    if (boundaryCheckFailed(i, j)) return;

    if (nodeTypes[i][j] == 0 || nodeTypes[i][j] == 4 || nodeTypes[i][j] == 5) {
      switch (type) {
        case Brush.wall:
          nodeTypes[i][j] = 1;
          nodes[i][j] = Positioned(
            key: UniqueKey(),
            left: 0.50 + i * (unitSize.toDouble() + 1),
            top: 0.50 + j * (unitSize.toDouble() + 1),
            child: WallNodePaintWidget(
              color: Colors.black,
              unitSize: unitSize,
              i: i,
              j: j,
              callback: (i, j, color) {
                updateStaticNode(i, j, color);
                removeNodeWidgetOnly(i, j);
              },
            ),
          );
          break;
        case Brush.start:
          nodeTypes[i][j] = 2;
          nodes[i][j] = Positioned(
            key: UniqueKey(),
            left: 0.50 + i * (unitSize.toDouble() + 1),
            top: 0.50 + j * (unitSize.toDouble() + 1),
            child: NodeImageWidget(
              unitSize,
              'assets/start.png',
            ),
          );
          break;
        case Brush.finish:
          nodeTypes[i][j] = 3;
          nodes[i][j] = Positioned(
            key: UniqueKey(),
            left: 0.50 + i * (unitSize.toDouble() + 1),
            top: 0.50 + j * (unitSize.toDouble() + 1),
            child: NodeImageWidget(
              unitSize,
              'assets/finish.png',
            ),
          );
          break;
        case Brush.open:
          nodeTypes[i][j] = 4;
          updateStaticNode(i, j, Colors.cyan);
          break;
        case Brush.closed:
          nodeTypes[i][j] = 5;
          nodes[i][j] = Positioned(
              key: UniqueKey(),
              left: 0.50 + i * (unitSize.toDouble() + 1),
              top: 0.50 + j * (unitSize.toDouble() + 1),
              child: VisitedNodePaintWidget(
                color: Colors.red.withOpacity(0.8),
                unitSize: unitSize,
                i: i,
                j: j,
                callback: (i, j, color) {
                  if (nodeTypes[i][j] == 5) {
                    updateStaticNode(i, j, color);
                    removeNodeWidgetOnly(i, j);
                  }
                },
              ));
          break;
        default:
      }
      notifyListeners();
    } else if (nodeTypes[i][j] == 1 &&
        (type == Brush.start || type == Brush.finish)) {
      switch (type) {
        case Brush.start:
          nodeTypes[i][j] = 2;
          nodes[i][j] = Positioned(
            key: UniqueKey(),
            left: 0.50 + i * (unitSize.toDouble() + 1),
            top: 0.50 + j * (unitSize.toDouble() + 1),
            child: NodeImageWidget(
              unitSize,
              'assets/start.png',
            ),
          );
          break;
        case Brush.finish:
          nodeTypes[i][j] = 3;
          nodes[i][j] = Positioned(
            key: UniqueKey(),
            left: 0.50 + i * (unitSize.toDouble() + 1),
            top: 0.50 + j * (unitSize.toDouble() + 1),
            child: NodeImageWidget(
              unitSize,
              'assets/finish.png',
            ),
          );
          break;
        default:
      }
      notifyListeners();
    }
  }

  void generateBoard(
      {@required GridObstacleGeneration function,
      @required Function onFinished,
      @required Function callback}) {
    int i = 0;
    int j = 0;
    clearPaths();
    switch (function) {
      case GridObstacleGeneration.random:
        Timer.periodic(Duration(microseconds: 10), (timer) {
          if (callback()) {
            timer.cancel();
          }
          removeNode(i, j, 1);
          if (Random().nextDouble() < 0.3) {
            addNode(i, j, Brush.wall);
          }
          i++;
          if (i == nodeTypes.length) {
            i = 0;
            j++;
          }
          if (j == nodeTypes[0].length) {
            onFinished();
            timer.cancel();
            return;
          }
        });
        break;
      default:
    }
  }

  double currentPosX;
  double currentPosY;

  void putCurrentNode(int i, int j) {
    currentPosX = 0.50 + i * (unitSize.toDouble() + 1);
    currentPosY = 0.50 + j * (unitSize.toDouble() + 1);
  }

  void clearBoard({Function onFinished}) {
    int i = 0;
    int j = 0;
    clearPaths();
    for (var i = 0; i < nodeTypes.length; i++) {
      for (var j = 0; j < nodeTypes[0].length; j++) {
        removeNode(i, j, 1);
      }
    }
  }

  bool get isPanning => _isPanning;

  set isPanning(bool value) {
    _isPanning = value;
    notifyListeners();
  }

  void updateDecorationScale(double value) {
    scale = value;
    notifyListeners();
  }
}
