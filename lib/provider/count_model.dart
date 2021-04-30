import 'package:flutter/material.dart';
import 'package:path_finder/pages/introduction_page.dart';
import 'package:path_finder/widgets/popUpButton/popup_model.dart';
import 'package:provider/provider.dart';

class OperationCountModel extends ChangeNotifier {
  int _operations = 0;

  int get operations => _operations;

  set operations(int value) {
    _operations = value;
    notifyListeners();
  }
}

class SettingsPage extends StatelessWidget {
  static const double maxSpeed = 1; // milliseconds delay
  static const double minSpeed = 400; // milliseconds delay
  @override
  Widget build(BuildContext context) {
    var model = Provider.of<PopUpModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Speed of Algorithms'),
            subtitle: Text(() {
              switch (model.speed) {
                case 400:
                  return "Slow";
                  break;
                case 1:
                  return "Fast";
                  break;
                default:
                  return "Average";
              }
            }()),
            trailing: Selector<PopUpModel, int>(
                selector: (context, model) => model.speed,
                builder: (_, speed, __) {
                  return Container(
                    width: 200,
                    child: Slider.adaptive(
                      activeColor: Colors.lightBlue,
                      min: maxSpeed,
                      max: minSpeed,
                      divisions: 2,
                      value: speed.toDouble() * -1 + minSpeed + maxSpeed,
                      onChanged: (val) {
                        model.speed = (val * -1 + minSpeed + maxSpeed).toInt();
                      },
                    ),
                  );
                }),
          ),
          ListTile(
            title: Text('Dark Theme'),
            trailing: Switch.adaptive(
              onChanged: (state) {
                if (state) {
                  model.brightness = Brightness.dark;
                } else {
                  model.brightness = Brightness.light;
                }
              },
              value: (() {
                if (model.brightness == Brightness.light) {
                  return false;
                }
                return true;
              }()),
            ),
          ),
          ListTile(
              title: Text('Forgot the tools?'),
              trailing: FlatButton(
                child: Text("Show Introduction"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IntroductionPage(
                        onDone: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
              ))
        ],
      ),
    );
  }
}
