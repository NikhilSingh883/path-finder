import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../2d_grid.dart';

class PopUpModel extends ChangeNotifier {
  Brightness _brightness = Brightness.light;
  Brightness get brightness => _brightness;

  set brightness(value) {
    _brightness = value;
    if (value == Brightness.dark) {
      _setTheme(true);
    } else {
      _setTheme(false);
    }
    notifyListeners();
  }

  int _speed = 1;
  double _unitSize = 25;
  int get speed => _speed;
  double get unitSize => _unitSize;

  set unitS(value) {
    _unitSize = value;
    notifyListeners();
  }

  set speed(value) {
    _speed = value;
    notifyListeners();
  }

  bool _stop = false;

  bool get stop => _stop;

  set stop(value) {
    _stop = value;
    notifyListeners();
  }

  Color brushColor1 = Colors.orangeAccent;
  Color brushColor2 = Color(0xFF2E2E2E);
  Color brushColor3 = Color(0xFF2E2E2E);
  Brush selectedBrush = Brush.wall;

  GridObstacleGeneration selectedAlg = GridObstacleGeneration.recursive;

  VisualizingAlgorithm selectedPathAlg = VisualizingAlgorithm.astar;

  void setActiveBrush(int i) {
    switch (i) {
      case 1: //wall

        selectedBrush = Brush.wall;
        notifyListeners();
        break;
      case 2: //start
        selectedBrush = Brush.start;
        notifyListeners();
        break;
      case 3: //finish
        selectedBrush = Brush.finish;
        notifyListeners();
        break;
      default:
    }
  }

  void setActiveAlgorithm(int i, BuildContext context) {
    switch (i) {
      case 1: //maze
        selectedAlg = GridObstacleGeneration.backtracker;
        notifyListeners();
        break;
      case 2: //random
        selectedAlg = GridObstacleGeneration.random;
        notifyListeners();
        break;
      case 3: //recursive
        selectedAlg = GridObstacleGeneration.recursive;
        notifyListeners();
        break;
      default:
    }
  }

  void setActivePAlgorithm(int i) {
    switch (i) {
      case 1: //astar
        selectedPathAlg = VisualizingAlgorithm.astar;
        notifyListeners();
        break;
      case 2: //dijkstra
        selectedPathAlg = VisualizingAlgorithm.dijkstra;
        notifyListeners();
        break;
      case 3: //dfs
        selectedPathAlg = VisualizingAlgorithm.bi_dir_dijkstra;
        notifyListeners();
        break;
      default:
    }
  }
}

_setTheme(bool theme) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('darkMode', theme);
}
