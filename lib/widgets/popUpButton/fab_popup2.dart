import 'package:flutter/material.dart';
import 'package:path_finder/config/size_config.dart';
import 'package:path_finder/widgets/popUpButton/popUpItem.dart';
import 'package:path_finder/widgets/popUpButton/popup_model.dart';

import 'popup.dart';

enum AnimatedButtonPopUpDirection {
  horizontal,
  vertical,
}

enum OVERLAY_POSITION { TOP, BOTTOM }

class FabWithPopUp2 extends StatefulWidget {
  FabWithPopUp2({
    @required this.onPressed,
    @required this.child,
    this.color = Colors.white,
    this.onLongPressed,
    this.disabled = false,
    this.direction = AnimatedButtonPopUpDirection.horizontal,
    this.width = 50,
    this.height = 50,
    this.popUpOffset = const Offset(0, 0),
    this.model,
  });
  final bool disabled;
  final Function onPressed;
  final Widget child;
  final Color color;
  final Function onLongPressed;
  final AnimatedButtonPopUpDirection direction;
  final double width;
  final double height;
  final Offset popUpOffset;
  final PopUpModel model;

  @override
  _FabWithPopUp2State createState() => _FabWithPopUp2State();
}

class _FabWithPopUp2State extends State<FabWithPopUp2>
    with SingleTickerProviderStateMixin {
  OverlayEntry _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.disabled,
      child: Opacity(
        opacity: widget.disabled ? 0.5 : 1,
        child: AnimatedContainer(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: widget.disabled ? 0 : 10,
                spreadRadius: 0,
              )
            ],
            borderRadius: BorderRadius.circular(50),
            color: widget.color,
          ),
          duration: Duration(milliseconds: 120),
          child: FlatButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            padding: EdgeInsets.all(2),
            child: widget.child, //Image.asset("assets/images/brush.png"),
            onPressed: () {
              widget.onPressed();
            },
            onLongPress: () {
              if (widget.onLongPressed != null) {
                widget.onLongPressed();
              }
              this._overlayEntry = _createOverlayEntry();
              Overlay.of(context).insert(this._overlayEntry);
            },
          ),
        ),
      ),
    );
  }

  TapDownDetails _tapDownDetails;
  OVERLAY_POSITION _overlayPosition = OVERLAY_POSITION.TOP;

  double _statusBarHeight;
  double _toolBarHeight;

  OverlayEntry _createOverlayEntry() {
    var offset = Offset(100, 50);
    _statusBarHeight = MediaQuery.of(context).padding.top;
    _toolBarHeight = 50;

    return OverlayEntry(builder: (context) {
      return Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _overlayEntry.remove();
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.blueGrey.withOpacity(0.4),
            ),
          ),
          Positioned(
            left: 0,
            top: SizeConfig.heightMultiplier * 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                body(context, offset.dy),
                if (_overlayPosition == OVERLAY_POSITION.TOP) nip(),
              ],
            ),
          )
        ],
      );
    });
  }

  Widget body(BuildContext context, double offset) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.all(
        Radius.circular(SizeConfig.widthMultiplier * 10),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.heightMultiplier * 5,
          horizontal: SizeConfig.widthMultiplier * 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(SizeConfig.widthMultiplier * 10),
          ),
          color: Colors.teal[100],
        ),
        child: Column(
          children: [
            Container(
              child: Text(
                'Choose Wall Generation Algorithm',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.heightMultiplier * 3,
                    fontWeight: FontWeight.w800),
              ),
            ),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: SizeConfig.heightMultiplier * 3,
              childAspectRatio: 16 / 16,
              shrinkWrap: true,
              children: <PopUpItem>[
                PopUpItem(
                  text: "Backtracker Maze",
                  onPressed: () {
                    widget.model.setActiveAlgorithm(1, context);
                    _overlayEntry.remove();
                  },
                  image: 'assets/backtrack.gif',
                ),
                PopUpItem(
                  text: "Random",
                  onPressed: () {
                    widget.model.setActiveAlgorithm(2, context);
                    _overlayEntry.remove();
                  },
                  image: 'assets/ramdom.gif',
                ),
                PopUpItem(
                  text: "Recursive Maze",
                  onPressed: () {
                    widget.model.setActiveAlgorithm(3, context);
                    _overlayEntry.remove();
                  },
                  image: 'assets/division.gif',
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget nip() {
    return Container(
      height: 10.0,
      width: 10.0,
      child: CustomPaint(
        painter: OpenPainter(_overlayPosition),
      ),
    );
  }
}

class OpenPainter extends CustomPainter {
  final OVERLAY_POSITION overlayPosition;

  OpenPainter(this.overlayPosition);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.teal[100]
      ..isAntiAlias = true;
    switch (overlayPosition) {
      case OVERLAY_POSITION.TOP:
        _drawThreeShape(canvas,
            first: Offset(SizeConfig.widthMultiplier * 85, 0),
            second: Offset(
              SizeConfig.widthMultiplier * 102,
              -SizeConfig.heightMultiplier * 7,
            ),
            third: Offset(SizeConfig.widthMultiplier * 90,
                SizeConfig.widthMultiplier * 5),
            size: size,
            paint: paint);

        break;
      case OVERLAY_POSITION.BOTTOM:
        _drawThreeShape(canvas,
            first: Offset(15, 0),
            second: Offset(0, 20),
            third: Offset(30, 20),
            size: size,
            paint: paint);

        break;
    }

    canvas.save();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  void _drawThreeShape(Canvas canvas,
      {Offset first, Offset second, Offset third, Size size, paint}) {
    var path1 = Path()
      ..moveTo(first.dx, first.dy)
      ..lineTo(second.dx, second.dy)
      ..lineTo(third.dx, third.dy);
    canvas.drawPath(path1, paint);
  }

  void _drawTwoShape(Canvas canvas,
      {Offset first, Offset second, Size size, paint}) {
    var path1 = Path()
      ..moveTo(first.dx, first.dy)
      ..lineTo(second.dx, second.dy);
    canvas.drawPath(path1, paint);
  }
}
