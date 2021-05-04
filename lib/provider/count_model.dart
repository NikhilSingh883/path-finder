import 'package:flutter/material.dart';

class OperationCountModel extends ChangeNotifier {
  int _operations = 0;

  int get operations => _operations;

  set operations(int value) {
    _operations = value;
    notifyListeners();
  }
}
