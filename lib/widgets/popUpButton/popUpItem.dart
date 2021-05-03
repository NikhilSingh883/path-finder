import 'package:flutter/material.dart';
import 'package:path_finder/config/size_config.dart';

class PopUpItem extends StatelessWidget {
  final Function onPressed;
  final String text;
  final String image;
  PopUpItem({Key key, this.onPressed, this.text, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.widthMultiplier * 2,
        ),
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
            CircleAvatar(
              radius: SizeConfig.heightMultiplier * 8,
              backgroundImage: AssetImage(
                image,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
