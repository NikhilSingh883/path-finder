import 'package:flutter/material.dart';
import 'package:path_finder/config/size_config.dart';
import 'package:path_finder/logic/algorithms.dart';
import 'package:path_finder/logic/generation_algorithm.dart';
import 'package:path_finder/provider/count_model.dart';
import 'package:path_finder/widgets/2d_grid.dart';
import 'package:path_finder/widgets/popUpButton/btn.dart';
import 'package:path_finder/widgets/popUpButton/fab_popup.dart';
import 'package:path_finder/widgets/popUpButton/fab_popup2.dart';
import 'package:path_finder/widgets/popUpButton/popUpItem.dart';
import 'package:path_finder/widgets/popUpButton/popup_model.dart';
import 'package:path_finder/widgets/popUpButton/setting_fab_popup.dart';
import 'package:provider/provider.dart';

class VisualizerPage extends StatefulWidget {
  @override
  _VisualizerPageState createState() => _VisualizerPageState();
}

class _VisualizerPageState extends State<VisualizerPage> {
  bool isRunning = false;
  int _selectedButton = 1;
  bool _generationRunning = false;

  void setActiveButton(int i, BuildContext context) {
    switch (i) {
      case 1: //brush
        grid.isPanning = false;
        drawTool = true;
        setState(() {
          _selectedButton = 1;
        });
        break;
      case 2: //eraser
        grid.isPanning = false;
        drawTool = false;
        setState(() {
          _selectedButton = 2;
        });
        break;
      case 3: // pan
        grid.isPanning = true;
        setState(() {
          _selectedButton = 3;
        });
        break;
      default:
    }
  }

  void disableBottomButtons() {
    setState(() {
      _disabled1 = true;
      _disabled2 = true;
      _disabled3 = true;
      _disabled4 = true;
      _disabled5 = true;
      _disabled6 = true;
    });
  }

  void enableBottomButtons() {
    setState(() {
      _disabled1 = false;
      _disabled2 = false;
      _disabled3 = false;
      _disabled4 = false;
      _disabled5 = false;
      _disabled6 = false;
    });
  }

  Color _color6 = Colors.lightGreen[500];

  bool _disabled1 = false;
  bool _disabled2 = false;
  bool _disabled3 = false;
  bool _disabled4 = false;
  bool _disabled5 = false;
  bool _disabled6 = false;

  bool drawTool = true;

  Grid grid = Grid(50, 90, 50, 20, 20, 25, 60);

  double brushSize = 0.1;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    var popupmodel = Provider.of<PopUpModel>(context, listen: false);
    var operationModel =
        Provider.of<OperationCountModel>(context, listen: false);
    final snackBar = SnackBar(
      content: Text("Path Doesn't exist"),
      duration: Duration(milliseconds: 1400),
    );
    return Scaffold(
        floatingActionButton: Container(
          margin:
              EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier * 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                child: SettingFabWithPopUp(
                  child: Icon(Icons.settings, color: Colors.white),
                  disabled: false,
                ),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 2,
              ),
              Consumer<PopUpModel>(
                builder: (_, model, __) {
                  return FabWithPopUp(
                    disabled: _disabled6,
                    color: _color6,
                    width: SizeConfig.widthMultiplier * 25,
                    popUpOffset: Offset(0, 50),
                    direction: AnimatedButtonPopUpDirection.vertical,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "Visualize\n",
                          style: TextStyle(
                            color: Color(0xFF2E2E2E),
                            fontSize: SizeConfig.heightMultiplier * 2,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                          children: [
                            TextSpan(
                                style: TextStyle(
                                  color: Color(0xFF2E2E2E),
                                  fontSize: SizeConfig.heightMultiplier * 1.5,
                                ),
                                text: (() {
                                  switch (model.selectedPathAlg) {
                                    case VisualizingAlgorithm.astar:
                                      return "A*";
                                      break;
                                    case VisualizingAlgorithm.dijkstra:
                                      return "Dijkstra";
                                      break;
                                    case VisualizingAlgorithm.bi_dir_dijkstra:
                                      return "Bidir.  Dijkstra";
                                      break;
                                    default:
                                      return "Maze";
                                  }
                                }()))
                          ]),
                    ),
                    onPressed: () {
                      model.stop = false;
                      setActiveButton(3, context);
                      setState(() {
                        isRunning = true;
                        _color6 = Colors.redAccent;
                      });
                      disableBottomButtons();
                      grid.clearPaths();
                      PathfindAlgorithms.visualize(
                          algorithm: model.selectedPathAlg,
                          gridd: grid.nodeTypes,
                          startti: grid.starti,
                          starttj: grid.startj,
                          finishi: grid.finishi,
                          finishj: grid.finishj,
                          onShowClosedNode: (int i, int j) {
                            grid.addNode(i, j, Brush.closed);
                          },
                          onShowOpenNode: (int i, int j) {
                            grid.addNode(i, j, Brush.open);
                          },
                          speed: () {
                            return model.speed;
                          },
                          onDrawPath: (Node lastNode, int c) {
                            operationModel.operations = c;
                            if (model.stop) {
                              setState(() {
                                _color6 = Colors.lightGreen[500];
                              });
                              enableBottomButtons();
                              return true;
                            }
                            grid.drawPath2(lastNode);
                            return false;
                          },
                          onDrawSecondPath: (Node lastNode, int c) {
                            operationModel.operations = c;
                            if (model.stop) {
                              setState(() {
                                _color6 = Colors.lightGreen[500];
                              });
                              enableBottomButtons();
                              return true;
                            }
                            grid.drawSecondPath2(lastNode);
                            return false;
                          },
                          onFinished: (pathFound) {
                            setState(() {
                              isRunning = false;
                              _color6 = Colors.lightGreen[500];
                            });
                            enableBottomButtons();
                            if (!pathFound) {
                              Scaffold.of(context).showSnackBar(snackBar);
                            }
                          });
                    },
                    model: model,
                  );
                },
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 2,
              ),
              Consumer<PopUpModel>(
                builder: (_, model, __) {
                  return FabWithPopUp2(
                    width: SizeConfig.widthMultiplier * 25,
                    popUpOffset: Offset(0, 100),
                    direction: AnimatedButtonPopUpDirection.vertical,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "Generate\n",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontSize: SizeConfig.heightMultiplier * 2,
                              height: 1.0),
                          children: [
                            TextSpan(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        SizeConfig.heightMultiplier * 1.5),
                                text: (() {
                                  switch (model.selectedAlg) {
                                    case GridObstacleGeneration.backtracker:
                                      return "Backtracker Maze";
                                      break;
                                    case GridObstacleGeneration.random:
                                      return "Random";
                                      break;
                                    case GridObstacleGeneration.recursive:
                                      return "Recursive Maze";
                                      break;
                                    default:
                                      return "Maze";
                                  }
                                }()))
                          ]),
                    ),
                    onPressed: () {
                      model.stop = false;
                      setActiveButton(3, context);
                      setState(() {
                        isRunning = true;
                        _generationRunning = true;
                      });
                      disableBottomButtons();
                      grid.clearPaths();
                      //grid.fillWithWall();
                      GenerateAlgorithms.visualize(
                          algorithm: model.selectedAlg,
                          gridd: grid.nodeTypes,
                          stopCallback: () {
                            return model.stop;
                          },
                          onShowCurrentNode: (i, j) {
                            //grid.addNode(i, j, Brush.open);
                            grid.putCurrentNode(i, j);
                          },
                          onRemoveWall: (i, j) {
                            grid.removeNode(i, j, 1);
                          },
                          onShowWall: (i, j) {
                            grid.addNode(i, j, Brush.wall);
                          },
                          speed: () {
                            return model.speed;
                          },
                          onFinished: () {
                            setState(() {
                              isRunning = false;
                              _generationRunning = false;
                            });
                            enableBottomButtons();
                          });
                    },
                    onLongPressed: () {},
                    disabled: _disabled5,
                    color: _generationRunning
                        ? Colors.redAccent
                        : Theme.of(context).buttonColor,
                    model: model,
                  );
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            Selector<PopUpModel, Brush>(
              selector: (context, model) => model.selectedBrush,
              builder: (_, brush, __) {
                return grid.gridWidget(
                  onTapNode: (i, j) {
                    grid.clearPaths();
                    if (drawTool) {
                      if (brush == Brush.wall) {
                        grid.addNode(i, j, Brush.wall);
                      } else {
                        grid.hoverSpecialNode(i, j, brush);
                      }
                    } else {
                      grid.removeNode(i, j, 1);
                    }
                  },
                  onDragNode: (i, j, k, l, t) {
                    if (drawTool) {
                      if (brush != Brush.wall) {
                        grid.hoverSpecialNode(k, l, brush);
                      } else {
                        grid.addNode(k, l, brush);
                      }
                    } else {
                      grid.removeNode(k, l, 1);
                    }
                  },
                  onDragNodeEnd: () {
                    if (brush != Brush.wall && drawTool) {
                      grid.addSpecialNode(brush);
                    }
                  },
                );
              },
            ),
            Positioned(
              top: 50,
              left: 0,
              child: Selector<OperationCountModel, int>(
                  selector: (context, model) => model.operations,
                  shouldRebuild: (a, b) => true,
                  builder: (_, operations, __) {
                    return popupmodel.brightness == Brightness.light
                        ? Text(
                            'Operations: ${operations.toString()}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Operations: ${operations.toString()}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          );
                  }),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: size.width,
                // height: 80,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(size.width, 80),
                      painter: BNBCustomPainter(popupmodel),
                    ),
                    Center(
                      heightFactor: 0.6,
                      child: FloatingActionButton(
                        backgroundColor:
                            !isRunning ? Colors.orange : Colors.orange[100],
                        child: Icon(
                          !isRunning ? Icons.play_arrow : Icons.pause,
                          color: Colors.white,
                        ),

                        // mini: true,
                        onPressed: () {
                          setState(() {
                            isRunning = false;
                          });
                          popupmodel.stop = true;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                child: Center(
                  heightFactor: 2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: SizeConfig.widthMultiplier * 3,
                      ),
                      Consumer<PopUpModel>(
                        builder: (_, model, __) {
                          return AnimatedButtonWithPopUp(
                              height: SizeConfig.heightMultiplier * 5,
                              direction: AnimatedButtonPopUpDirection.vertical,
                              child: Image.asset(
                                "assets/brush.png",
                                color: model.brightness == Brightness.light
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setActiveButton(1, context);
                              },
                              onLongPressed: () {
                                setActiveButton(1, context);
                              },
                              disabled: _disabled1,
                              color: _selectedButton == 1
                                  ? Colors.orangeAccent
                                  : Theme.of(context).buttonColor,
                              items: <AnimatedButtonPopUpItem>[
                                AnimatedButtonPopUpItem(
                                  child: Image.asset(
                                    "assets/wall.png",
                                    height: SizeConfig.heightMultiplier * 3,
                                  ),
                                  onPressed: () {
                                    model.setActiveBrush(1);
                                  },
                                ),
                                AnimatedButtonPopUpItem(
                                  child: Image.asset(
                                    "assets/start.png",
                                    height: SizeConfig.heightMultiplier * 3,
                                  ),
                                  onPressed: () {
                                    model.setActiveBrush(2);
                                  },
                                ),
                                AnimatedButtonPopUpItem(
                                  child: Image.asset(
                                    "assets/finish.png",
                                    height: SizeConfig.heightMultiplier * 3,
                                  ),
                                  onPressed: () {
                                    model.setActiveBrush(3);
                                  },
                                )
                              ]);
                        },
                      ),
                      SizedBox(
                        width: SizeConfig.widthMultiplier * 6,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            bottom: SizeConfig.heightMultiplier * 2),
                        child: AnimatedButtonWithPopUp(
                          height: SizeConfig.heightMultiplier * 5,
                          child: Image.asset(
                            "assets/erase.png",
                            color: popupmodel.brightness == Brightness.light
                                ? Colors.white
                                : Colors.black,
                          ),
                          onPressed: () {
                            setActiveButton(2, context);
                          },
                          disabled: _disabled2,
                          color: _selectedButton == 2
                              ? Colors.orangeAccent
                              : Theme.of(context).buttonColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                child: Center(
                  heightFactor: 2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            bottom: SizeConfig.heightMultiplier * 2),
                        child: AnimatedButtonWithPopUp(
                          height: SizeConfig.heightMultiplier * 5,
                          child: Image.asset(
                            "assets/pan.png",
                            color: popupmodel.brightness == Brightness.light
                                ? Colors.white
                                : Colors.black,
                          ),
                          onPressed: () {
                            setActiveButton(3, context);
                          },
                          disabled: _disabled3,
                          color: _selectedButton == 3
                              ? Colors.orangeAccent
                              : Theme.of(context).buttonColor,
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.widthMultiplier * 6,
                      ),
                      AnimatedButtonWithPopUp(
                        height: SizeConfig.heightMultiplier * 5,
                        child: Image.asset(
                          "assets/delete.png",
                          color: popupmodel.brightness == Brightness.light
                              ? Colors.white
                              : Colors.black,
                        ),
                        color: Theme.of(context).buttonColor,
                        disabled: _disabled4,
                        onPressed: () {
                          grid.clearBoard(onFinished: () {});
                        },
                      ),
                      SizedBox(
                        width: SizeConfig.widthMultiplier * 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class BNBCustomPainter extends CustomPainter {
  final PopUpModel popUpModel;

  BNBCustomPainter(this.popUpModel);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = popUpModel.brightness == Brightness.light
          ? Colors.deepOrange[500]
          : Colors.yellow[200]
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
