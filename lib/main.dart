import 'package:flutter/material.dart';
import 'package:noreen/recording_history.dart';
import 'package:noreen/app_storage.dart';

import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //retrieve user preferences as app starts
  await AppStorage().init();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final controller = PageController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Speech Recognition",
      home: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              "assets/th.jpeg",
              fit: BoxFit.fill,
              repeat: ImageRepeat.noRepeat,
              alignment: Alignment(0.2, 4),
            ),
          ),
          Container(
            color: Colors.white.withOpacity(0.7),
            child: PageView(
              controller: controller,
              children: [
                Home(controller: controller,),
                RecordingHistory(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showSnack(context, message, {Duration? duration}) {
  FocusScope.of(context).requestFocus(FocusNode());
  SnackBar snackBar;
  if (duration != null) {
    snackBar = SnackBar(
      content: Text(message),
      duration: duration,
    );
  } else {
    snackBar = SnackBar(content: Text(message));
  }
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
