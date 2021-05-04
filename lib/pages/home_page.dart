import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_finder/pages/introduction_page.dart';
import 'package:path_finder/pages/visualizer_page.dart';
import 'package:path_finder/provider/count_model.dart';
import 'package:path_finder/widgets/introduction/welcome_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<bool> initialLaunch = _getLaunchState();
  Future<bool> getHome = _getHomeState();
  bool done = false;
  bool home = true;
  @override
  Widget build(BuildContext context) {
    return done
        ? ChangeNotifierProvider(
            create: (_) => OperationCountModel(),
            child: VisualizerPage(),
          )
        : FutureBuilder(
            future: initialLaunch,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data) {
                  return home
                      ? WelcomePage(
                          onDone: () {
                            setState(() {
                              home = false;
                            });
                          },
                        )
                      : IntroductionPage(
                          onDone: () {
                            setLaunchState();
                            setState(() {
                              done = true;
                            });
                          },
                        );
                } else {
                  Future.delayed(Duration.zero, () {
                    setState(() {
                      done = true;
                    });
                  });
                  return Center(child: CircularProgressIndicator());
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
  }
}

setLaunchState() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('initialLaunch', false);
}

Future<bool> _getLaunchState() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getBool('initialLaunch') ?? true);
}

setHomeState() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('initialHome', false);
}

Future<bool> _getHomeState() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getBool('initialHome') ?? true);
}
