import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_finder/config/size_config.dart';

import 'fab_popup2.dart';

class AnimatedButtonWithPopUp extends StatefulWidget {
  AnimatedButtonWithPopUp(
      {@required this.onPressed,
      this.items,
      @required this.child,
      this.color = Colors.white,
      this.onLongPressed,
      this.disabled = false,
      this.direction = AnimatedButtonPopUpDirection.horizontal,
      this.width = 50,
      this.height = 50,
      this.popUpOffset = const Offset(0, 0)});
  final bool disabled;
  final Function onPressed;
  final List<AnimatedButtonPopUpItem> items;
  final Widget child;
  final Color color;
  final Function onLongPressed;
  final AnimatedButtonPopUpDirection direction;
  final double width;
  final double height;
  final Offset popUpOffset;

  @override
  _AnimatedButtonWithPopUpState createState() =>
      _AnimatedButtonWithPopUpState();
}

class _AnimatedButtonWithPopUpState extends State<AnimatedButtonWithPopUp>
    with SingleTickerProviderStateMixin {
  OverlayEntry _overlayEntry;

  double fraction = 0;
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      animationBehavior: AnimationBehavior.normal,
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    animation = Tween(begin: 3.0, end: 0.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOutBack))
      ..addListener(() {
        setState(() {
          fraction = animation.value;
        });
      });
  }

  void pressAnimation() {
    controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.disabled,
      child: Padding(
        padding: EdgeInsets.only(top: fraction + 1),
        child: Opacity(
          opacity: widget.disabled ? 0.5 : 1,
          child: AnimatedContainer(
            width: widget.width,
            height: widget.height,
            // decoration: BoxDecoration(
            //   boxShadow: [
            //     BoxShadow(
            //       offset: widget.disabled
            //           ? Offset(0, 0)
            //           : Offset(0, (3 - fraction + 1) * 1.5),
            //       color: Color(0xFF2E2E2E),
            //       blurRadius: 0,
            //     )
            //   ],
            //   borderRadius: BorderRadius.circular(50),
            //   color: widget.color,
            // ),
            duration: Duration(milliseconds: 120),
            child: GestureDetector(
              onTap: () {
                pressAnimation();
                widget.onPressed();
              },
              onLongPress: () {
                if (widget.onLongPressed != null) {
                  widget.onLongPressed();
                }
                if (widget.items != null && widget.items.length != 0) {
                  pressAnimation();
                  this._overlayEntry = _createOverlayEntry();
                  Overlay.of(context).insert(this._overlayEntry);
                }
              },
              child: Container(
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    double boxHeight =
        widget.direction == AnimatedButtonPopUpDirection.horizontal
            ? widget.height
            : widget.height * widget.items.length;
    double boxWidth =
        widget.direction == AnimatedButtonPopUpDirection.horizontal
            ? widget.width * widget.items.length
            : widget.width;

    Offset boxOffset = Offset(
        offset.dx + (size.width - boxWidth) / 2 + widget.popUpOffset.dx,
        offset.dy - boxHeight - 10 + widget.popUpOffset.dy);

    return OverlayEntry(
        builder: (context) => Positioned.fill(
                child: PopUpWidget(
              offset: boxOffset,
              width: boxWidth,
              height: boxHeight,
              direction: widget.direction,
              onHitOutside: () {
                this._overlayEntry.remove();
              },
              items: widget.items,
            )));
  }
}

class PopUpWidget extends StatefulWidget {
  final Offset offset;
  final double height;
  final double width;
  final Function onHitOutside;
  final List<AnimatedButtonPopUpItem> items;
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
              // height: widget.height * fraction,
              // width: widget.width * fraction,
              left: widget.offset.dx +
                  widget.width / 2 -
                  (widget.width / 2) * fraction,
              bottom: 50 * fraction,
              child: Material(
                color: Colors.transparent,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: SizeConfig.heightMultiplier * 3,
                    ),
                    child: widget.direction ==
                            AnimatedButtonPopUpDirection.horizontal
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: widget.items.map((widget) {
                              return Flexible(
                                child: GestureDetector(
                                  onTap: () {
                                    widget.onPressed();
                                    removePopUp();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: SizeConfig.heightMultiplier / 2,
                                    ),
                                    child: widget,
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: widget.items.map((widget) {
                              return Flexible(
                                child: GestureDetector(
                                  onTap: () {
                                    widget.onPressed();
                                    removePopUp();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: SizeConfig.heightMultiplier / 2,
                                    ),
                                    child: widget,
                                  ),
                                ),
                              );
                            }).toList(),
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

class AnimatedButtonPopUpItem extends StatelessWidget {
  final Function onPressed;
  final Widget child;
  const AnimatedButtonPopUpItem({Key key, this.onPressed, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: SizeConfig.heightMultiplier * 3,
      backgroundColor: Colors.lime[400],
      child: child,
    );
  }
}
