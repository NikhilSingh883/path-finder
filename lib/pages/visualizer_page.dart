import 'package:flutter/material.dart';
import 'package:path_finder/config/size_config.dart';
import 'package:path_finder/logic/algorithms.dart';
import 'package:path_finder/logic/generation_algorithm.dart';
import 'package:path_finder/provider/count_model.dart';
import 'package:path_finder/widgets/2d_grid.dart';
import 'package:path_finder/widgets/popUpButton/fab_popup.dart';
import 'package:path_finder/widgets/popUpButton/fab_popup2.dart';
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

  Grid grid = Grid(51, 100, 50, 10, 10, 30, 80);

  double brushSize = 0.1;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var popupmodel = Provider.of<PopUpModel>(context, listen: false);
    var operationModel =
        Provider.of<OperationCountModel>(context, listen: false);
    final snackBar = SnackBar(
      content: Text("Path Doesn't exist"),
      duration: Duration(milliseconds: 1400),
    );
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
              margin: EdgeInsets.symmetric(
                vertical: SizeConfig.heightMultiplier * 2,
              ),
              child: SettingFabWithPopUp(
                child: Container(
                  child: Icon(Icons.settings, color: Colors.white),
                  color: Colors.purple[300],
                ),
                disabled: false,
              )),
          Consumer<PopUpModel>(
            builder: (_, model, __) {
              return FabWithPopUp(
                disabled: _disabled6,
                color: _color6,
                width: 150,
                popUpOffset: Offset(100, 50),
                direction: AnimatedButtonPopUpDirection.vertical,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "Visualize\n",
                      style: TextStyle(
                          color: Color(0xFF2E2E2E), fontSize: 22, height: 1.0),
                      children: [
                        TextSpan(
                            style: TextStyle(
                                color: Color(0xFF2E2E2E), fontSize: 16),
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
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).bottomAppBarColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Consumer<PopUpModel>(
                builder: (_, model, __) {
                  return FabWithPopUp2(
                    width: 130,
                    popUpOffset: Offset(0, 100),
                    direction: AnimatedButtonPopUpDirection.vertical,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "Generate\n",
                          style: TextStyle(
                              color: Colors.black, fontSize: 22, height: 1.0),
                          children: [
                            TextSpan(
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
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
              Container(
                width: 0,
                height: 60,
              ),
              // Consumer<PopUpModel>(
              //   builder: (_, model, __) {
              //     return PopUpButton(
              //         direction: AnimatedButtonPopUpDirection.horizontal,
              //         child: Image.asset("assets/images/brush.png"),
              //         onPressed: () {
              //           setActiveButton(1, context);
              //         },
              //         onLongPressed: () {
              //           setActiveButton(1, context);
              //         },
              //         disabled: _disabled1,
              //         color: _selectedButton == 1
              //             ? Colors.orangeAccent
              //             : Theme.of(context).buttonColor,
              //         items: <PopUpItem>[
              //           PopUpItem(
              //             child: Image.asset(
              //               "assets/images/wall_node.png",
              //               color: model.brushColor1,
              //               scale: 1.5,
              //             ),
              //             onPressed: () {
              //               model.setActiveBrush(1);
              //             },
              //           ),
              //           PopUpItem(
              //             child: Image.asset(
              //               "assets/images/start_node.png",
              //               color: model.brushColor2,
              //               scale: 1.9,
              //             ),
              //             onPressed: () {
              //               model.setActiveBrush(2);
              //             },
              //           ),
              //           PopUpItem(
              //             child: Image.asset(
              //               "assets/images/end_node.png",
              //               color: model.brushColor3,
              //               scale: 1.9,
              //             ),
              //             onPressed: () {
              //               model.setActiveBrush(3);
              //             },
              //           )
              //         ]);
              //   },
              // ),
              Container(
                width: 0,
                height: 60,
              ),
              // PopUpButton(
              //   child: Image.asset("assets/images/erase.png"),
              //   onPressed: () {
              //     setActiveButton(2, context);
              //   },
              //   disabled: _disabled2,
              //   color: _selectedButton == 2
              //       ? Colors.orangeAccent
              //       : Theme.of(context).buttonColor,
              // ),
              Container(
                width: 0,
                height: 60,
              ),
              // PopUpButton(
              //   child: Image.asset("assets/images/pan.png"),
              //   onPressed: () {
              //     setActiveButton(3, context);
              //   },
              //   disabled: _disabled3,
              //   color: _selectedButton == 3
              //       ? Colors.orangeAccent
              //       : Theme.of(context).buttonColor,
              // ),
              Container(
                width: 0,
                height: 60,
              ),
              // PopUpButton(
              //   child: Icon(
              //     Icons.delete,
              //     size: 35,
              //     color: Color(0xFF212121),
              //   ),
              //   color: Theme.of(context).buttonColor,
              //   disabled: _disabled4,
              //   onPressed: () {
              //     grid.clearBoard(onFinished: () {});
              //   },
              // ),
            ],
          ),
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
            bottom: 5,
            left: 5,
            child: Selector<OperationCountModel, int>(
                selector: (context, model) => model.operations,
                shouldRebuild: (a, b) => true,
                builder: (_, operations, __) {
                  return popupmodel.brightness == Brightness.light
                      ? Text(
                          'Operations: ${operations.toString()}',
                          style: TextStyle(
                              backgroundColor: Colors.white.withOpacity(0.6)),
                        )
                      : Text('Operations: ${operations.toString()}');
                }),
          ),
          AnimatedPositioned(
            left: MediaQuery.of(context).size.width / 2 - 23,
            bottom: isRunning ? 15 : -50,
            duration: Duration(milliseconds: 500),
            curve: Curves.elasticOut,
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              child: Icon(Icons.pause, color: Colors.black),
              mini: true,
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
    );
  }
}
