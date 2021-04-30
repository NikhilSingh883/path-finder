import 'package:flutter/material.dart';
import 'package:path_finder/widgets/popUpButton/popUpItem.dart';
import 'package:path_finder/widgets/popUpButton/popup.dart';
import 'package:path_finder/widgets/popUpButton/popup_button.dart';

class FabWithPopUp extends StatefulWidget {
  FabWithPopUp(
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
  final List<PopUpItem> items;
  final Widget child;
  final Color color;
  final Function onLongPressed;
  final AnimatedButtonPopUpDirection direction;
  final double width;
  final double height;
  final Offset popUpOffset;

  @override
  _FabWithPopUpState createState() => _FabWithPopUpState();
}

class _FabWithPopUpState extends State<FabWithPopUp>
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
              if (widget.items != null && widget.items.length != 0) {
                this._overlayEntry = _createOverlayEntry();
                Overlay.of(context).insert(this._overlayEntry);
              }
            },
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
