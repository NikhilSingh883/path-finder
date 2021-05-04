import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_finder/config/size_config.dart';

class SinglePage extends StatelessWidget {
  final String title;
  final String caption;
  final String image;
  final String icon;
  const SinglePage({Key key, this.title, this.caption, this.image, this.icon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: SizeConfig.heightMultiplier * 10,
        left: SizeConfig.widthMultiplier * 2,
        right: SizeConfig.widthMultiplier * 2,
      ),
      child: Column(
        children: [
          FittedBox(
            child: Text(
              title,
              style: GoogleFonts.codystar(
                fontSize: SizeConfig.heightMultiplier * 5,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: SizeConfig.heightMultiplier * 5,
              horizontal: SizeConfig.widthMultiplier * 5,
            ),
            child: Image.asset(
              image,
              height: SizeConfig.heightMultiplier * 30,
              // color: Colors.white,
            ),
          ),
          Container(
            width: SizeConfig.widthMultiplier * 75,
            child: Text(
              caption,
              textAlign: TextAlign.center,
              style: GoogleFonts.turretRoad(
                color: Colors.black,
                fontSize: SizeConfig.heightMultiplier * 2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 7,
          ),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: SizeConfig.heightMultiplier * 5,
            ),
            color: Colors.transparent,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: SizeConfig.heightMultiplier * 6,
              backgroundImage: AssetImage(
                icon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
