import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_finder/provider/changePage.dart';

import 'package:path_finder/widgets/popUpButton/popup_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/size_config.dart';
import 'pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  bool launch = true;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: PopUpModel(),
      child: Selector<PopUpModel, Brightness>(
        selector: (context, model) => model.brightness,
        builder: (context, brightness, __) {
          var model = Provider.of<PopUpModel>(context, listen: false);
          _getTheme().then((bri) => model.brightness = bri);
          return LayoutBuilder(builder: (context, constraints) {
            SizeConfig().init(constraints);
            return ChangeNotifierProvider.value(
              value: ChangePage(),
              child: MaterialApp(
                theme: ThemeData(
                  primarySwatch: Colors.red,
                  brightness: brightness,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  fontFamily: 'Helvetica',
                ),
                home: Scaffold(
                  body: HomePage(),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

Future<Brightness> _getTheme() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getBool('darkMode') ?? false)
      ? Brightness.dark
      : Brightness.light;
}
