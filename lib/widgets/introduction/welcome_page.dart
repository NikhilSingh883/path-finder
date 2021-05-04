import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_finder/config/size_config.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class WelcomePage extends StatefulWidget {
  Function onDone;
  WelcomePage({Key key, this.onDone}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          bottom: SizeConfig.heightMultiplier * 5,
        ),
        child: Column(
          children: [
            SizedBox(
              height: SizeConfig.heightMultiplier * 8,
            ),
            Container(
              child: Text(
                'Welcome',
                style: GoogleFonts.luckiestGuy(
                  fontSize: SizeConfig.heightMultiplier * 4,
                  // fontWeight: FontWeight.w700,
                  color: Colors.brown[300],
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 5,
            ),
            Container(
              width: SizeConfig.widthMultiplier * 90,
              child: Text(
                "This app let's you visualize different path finding algorithm using Graph theory with custmizations like start node,end node,wall generation using different methods",
                textAlign: TextAlign.center,
                style: GoogleFonts.rockSalt(
                  color: Colors.red[700],
                  fontSize: SizeConfig.heightMultiplier * 2,
                  // fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                // vertical: SizeConfig.heightMultiplier * 10,
                horizontal: SizeConfig.widthMultiplier * 5,
              ),
              child: Image.asset(
                'assets/vis.png',
                height: SizeConfig.heightMultiplier * 30,
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                widget.onDone();
                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (context) {
                //   return IntroductionPage();
                // }));
              },
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.widthMultiplier * 5,
                    vertical: SizeConfig.heightMultiplier * 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple[300],
                    borderRadius: BorderRadius.circular(
                      SizeConfig.widthMultiplier * 10,
                    ),
                  ),
                  child: Text(
                    "Let's  get  started",
                    style: GoogleFonts.monoton(
                      color: Colors.white,
                      fontSize: SizeConfig.heightMultiplier * 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
