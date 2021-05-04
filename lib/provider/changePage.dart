import 'package:flutter/cupertino.dart';

class ChangePage extends ChangeNotifier {
  bool finished = false;

  void setPage(bool s) {
    finished = s;
    notifyListeners();
  }

  bool get page => finished;
}
