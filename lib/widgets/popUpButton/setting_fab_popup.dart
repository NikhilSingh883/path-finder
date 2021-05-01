import 'package:flutter/material.dart';
import 'package:path_finder/config/size_config.dart';
import 'package:path_finder/pages/introduction_page.dart';
import 'package:path_finder/widgets/popUpButton/fab_popup2.dart';
import 'package:path_finder/widgets/popUpButton/popup_model.dart';
import 'package:provider/provider.dart';

enum OVERLAY_POSITION { TOP, BOTTOM }

class SettingFabWithPopUp extends StatefulWidget {
  SettingFabWithPopUp({
    @required this.child,
    this.color = Colors.white,
    this.disabled = false,
    this.direction = AnimatedButtonPopUpDirection.horizontal,
    this.popUpOffset = const Offset(0, 0),
  });
  final bool disabled;
  final Widget child;
  final Color color;
  final AnimatedButtonPopUpDirection direction;

  final Offset popUpOffset;

  @override
  _SettingFabWithPopUpState createState() => _SettingFabWithPopUpState();
}

class _SettingFabWithPopUpState extends State<SettingFabWithPopUp>
    with SingleTickerProviderStateMixin {
  OverlayEntry _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      height: 50,
      minWidth: 50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      padding: EdgeInsets.all(2),
      child: widget.child, //Image.asset("assets/images/brush.png"),
      onPressed: () {
        this._overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry);
      },
    );
  }

  OVERLAY_POSITION _overlayPosition = OVERLAY_POSITION.TOP;

  OverlayEntry _createOverlayEntry() {
    var offset = Offset(100, 50);

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
              color: Colors.blueGrey.withOpacity(0.5),
            ),
          ),
          Positioned(
            left: 0,
            top: SizeConfig.heightMultiplier * 35,
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
    var model = Provider.of<PopUpModel>(context);

    const double maxSpeed = 1; // milliseconds delay
    const double minSpeed = 400; // milliseconds delay
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
          color: Colors.orange[300],
        ),
        child: Column(
          children: [
            Container(
              child: Text(
                'Settings',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.heightMultiplier * 3,
                    fontWeight: FontWeight.w800),
              ),
            ),
            ListView(
              children: <Widget>[
                ListTile(
                  title: Text('Speed of Algorithms'),
                  subtitle: Text(() {
                    switch (model.speed) {
                      case 400:
                        return "Slow";
                        break;
                      case 1:
                        return "Fast";
                        break;
                      default:
                        return "Average";
                    }
                  }()),
                  trailing: Selector<PopUpModel, int>(
                      selector: (context, model) => model.speed,
                      builder: (_, speed, __) {
                        return Container(
                          width: 200,
                          child: Slider.adaptive(
                            activeColor: Colors.lightBlue,
                            min: maxSpeed,
                            max: minSpeed,
                            divisions: 2,
                            value: speed.toDouble() * -1 + minSpeed + maxSpeed,
                            onChanged: (val) {
                              model.speed =
                                  (val * -1 + minSpeed + maxSpeed).toInt();
                            },
                          ),
                        );
                      }),
                ),
                ListTile(
                  title: Text('Dark Theme'),
                  trailing: Switch.adaptive(
                    onChanged: (state) {
                      if (state) {
                        model.brightness = Brightness.dark;
                      } else {
                        model.brightness = Brightness.light;
                      }
                    },
                    value: (() {
                      if (model.brightness == Brightness.light) {
                        return false;
                      }
                      return true;
                    }()),
                  ),
                ),
                ListTile(
                    title: Text('Forgot the tools?'),
                    trailing: FlatButton(
                      child: Text("Show Introduction"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IntroductionPage(
                              onDone: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },
                    ))
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
      ..color = Colors.orange[300]
      ..isAntiAlias = true;
    switch (overlayPosition) {
      case OVERLAY_POSITION.TOP:
        _drawThreeShape(canvas,
            first: Offset(SizeConfig.widthMultiplier * 75, 0),
            second: Offset(SizeConfig.widthMultiplier * 85, 0),
            third: Offset(SizeConfig.widthMultiplier * 80,
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
