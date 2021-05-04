import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_finder/config/size_config.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:path_finder/widgets/introduction/single_page.dart';

// ignore: must_be_immutable
class IntroductionPage extends StatefulWidget {
  Function onDone;
  IntroductionPage({this.onDone});
  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  PageController _pageController;
  @override
  void initState() {
    _pageController = new PageController(
      initialPage: 0,
      keepPage: true,
    );
    super.initState();
  }

  String N = 'Skip';

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(children: [
        PageView(
          onPageChanged: (page) {
            if (page == 4)
              setState(() {
                N = 'Get In';
              });
            else
              setState(() {
                N = 'Skip';
              });
          },
          controller: _pageController,
          children: [
            SinglePage(
              title: 'Drawing tool',
              image: 'assets/paint.png',
              icon: 'assets/brush.png',
              caption:
                  'Long press drawing tool to reveal other brush types such as wall, start and finish node',
            ),
            SinglePage(
              title: 'Eraser tool',
              image: 'assets/duster.png',
              icon: 'assets/erase.png',
              caption: 'To erase walls individually, tap the erase button',
            ),
            SinglePage(
              title: 'Pan and Zoom tool',
              image: 'assets/zoooom.gif',
              icon: 'assets/pan.png',
              caption: 'To pan around and zoom, tap the pan button',
            ),
            SinglePage(
              title: 'Visualize',
              image: 'assets/dijks.gif',
              icon: 'assets/dijkstra.gif',
              caption:
                  'Tap the visualize button! Long press the visualize button to reveal other algorithms',
            ),
            SinglePage(
              title: 'Generate walls',
              image: 'assets/wallBuild.png',
              icon: 'assets/backtrack.gif',
              caption:
                  'Tap the generate button! Long press the generate button to reveal other algorithms',
            ),
          ],
        ),
        Positioned(
          bottom: 25,
          left: 0,
          child: Container(
            width: SizeConfig.widthMultiplier * 100,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController, // PageController
                count: 5,
                effect: ExpandingDotsEffect(
                  dotHeight: SizeConfig.heightMultiplier * 1.5,
                  dotWidth: SizeConfig.heightMultiplier * 1.5,
                  spacing: SizeConfig.widthMultiplier,
                ),
                onDotClicked: (index) {
                  _pageController.jumpToPage(index);
                },
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 20,
          child: GestureDetector(
            onTap: () async {
              // if (_pageController.page != 4)
              _pageController.animateToPage(4,
                  duration: Duration(milliseconds: 100),
                  curve: Curves.easeInOutBack);
              if (_pageController.page == 4) widget.onDone();
            },
            child: Container(
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.widthMultiplier * 5,
                    vertical: SizeConfig.heightMultiplier * 1.5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red[300],
                    borderRadius: BorderRadius.circular(
                      SizeConfig.widthMultiplier * 10,
                    ),
                  ),
                  child: Text(
                    N,
                    style: GoogleFonts.monoton(
                      fontSize: SizeConfig.heightMultiplier * 1.5,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
