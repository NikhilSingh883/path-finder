import 'package:flutter/material.dart';

class PopUpItem extends StatelessWidget {
  final Function onPressed;
  final Widget child;
  const PopUpItem({Key key, this.onPressed, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(width: 170, height: 50, child: Center(child: child));
  }
}
