import 'package:flutter/material.dart';
import 'package:path_finder/widgets/popUpButton/popUpItem.dart';

import 'fab_popup2.dart';

class PopUpWidget extends StatefulWidget {
  final Offset offset;
  final double height;
  final double width;
  final Function onHitOutside;
  final List<PopUpItem> items;
  final AnimatedButtonPopUpDirection direction;
  PopUpWidget(
      {this.offset,
      this.height,
      this.width,
      this.onHitOutside,
      this.items,
      this.direction});
  @override
  _PopUpWidgetState createState() => _PopUpWidgetState();
}

class _PopUpWidgetState extends State<PopUpWidget>
    with TickerProviderStateMixin {
  double fraction = 0;
  double opacity = 1.0;
  Animation<double> animation;
  Animation<double> animationFadeOut;
  AnimationController controller;
  bool ignore = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      animationBehavior: AnimationBehavior.preserve,
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOutBack))
      ..addListener(() {
        setState(() {
          fraction = animation.value;
        });
      });

    controller.forward();
  }

  void removePopUp() {
    setState(() {
      ignore = true;
    });
    controller = AnimationController(
      animationBehavior: AnimationBehavior.preserve,
      duration: const Duration(milliseconds: 100),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onHitOutside();
        }
      });

    animationFadeOut = Tween(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.linear))
          ..addListener(() {
            setState(() {
              opacity = animationFadeOut.value;
            });
          });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: ignore,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (details) {
          if (details.localPosition.dx < widget.offset.dx ||
              details.localPosition.dx > widget.offset.dx + widget.width ||
              details.localPosition.dy < widget.offset.dy ||
              details.localPosition.dy > widget.offset.dy + widget.height) {
            // this._overlayEntry.remove();
            removePopUp();
            //widget.onHitOutside();
          } else {
            // print("pog");
          }
        },
        child: Stack(
          children: <Widget>[
            Positioned(
              height: widget.height * fraction,
              width: widget.width * fraction,
              left: widget.offset.dx +
                  widget.width / 2 -
                  (widget.width / 2) * fraction,
              top: widget.offset.dy + 50 - 50 * fraction,
              child: Material(
                color: Colors.transparent,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).dialogBackgroundColor,
                      boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: -5)],
                      borderRadius: BorderRadius.circular(4),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.white,
                      //     offset: Offset(0, 0),
                      //     spreadRadius: 2,
                      //     blurRadius: 10
                      //   )
                      // ]
                    ),
                    // width: widget.width,
                    //height: widget.height,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 11.0, vertical: 8),
                      child: widget.direction ==
                              AnimatedButtonPopUpDirection.horizontal
                          ? Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: widget.items.map((widget) {
                                return Flexible(
                                  // ignore: deprecated_member_use
                                  child: FlatButton(
                                      key: UniqueKey(),
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        removePopUp();
                                        widget.onPressed();
                                      },
                                      child: widget),
                                );
                              }).toList(),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: widget.items.map((widget) {
                                return Flexible(
                                  // ignore: deprecated_member_use
                                  child: FlatButton(
                                      key: UniqueKey(),
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        widget.onPressed();
                                        removePopUp();
                                      },
                                      child: widget),
                                );
                              }).toList(),
                            ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
