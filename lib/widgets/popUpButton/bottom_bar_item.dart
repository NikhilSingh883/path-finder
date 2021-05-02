import 'package:flutter/material.dart';
import 'package:path_finder/config/size_config.dart';

class BottomBarItem extends StatelessWidget {
  final Function onPressed;
  final String text;
  final String image;
  BottomBarItem({Key key, this.onPressed, this.text, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: SizeConfig.heightMultiplier * 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier,
          ),
          Container(
            height: SizeConfig.heightMultiplier * 13,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image(
              image: AssetImage(image),
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
