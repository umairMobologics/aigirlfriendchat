import 'package:flutter/material.dart';

const Color obColor = Color.fromARGB(255, 54, 235, 174);
const Color scaffoldBackground = Color.fromARGB(255, 4, 13, 44);
const Color appBarBackground = Color.fromARGB(255, 4, 13, 44);
const Color mainClr = Color(0xff9610FF);
const Color white = Colors.white;
const Color white54 = Colors.white54;
const Color black = Colors.black;
const Color black54 = Colors.black54;
const Color heartclr = Color(0xffFF6262);
const Color red = Colors.red;
const Color pink = Colors.pink;
const Color purple = Colors.purple;
const Color deepPurple = Colors.deepPurple;
const Color indigo = Colors.indigo;
const Color blue = Color(0xff2F91EB);
const Color lightBlue = Colors.lightBlue;
const Color cyan = Colors.cyan;
const Color teal = Colors.teal;
const Color green = Colors.green;
const Color lightGreen = Colors.lightGreen;
const Color lime = Colors.lime;
const Color yellow = Colors.yellow;
const Color amber = Colors.amber;
const Color orange = Colors.orange;
const Color deepOrange = Colors.deepOrange;
const Color brown = Colors.brown;
const Color grey = Colors.grey;
const Color blueGrey = Colors.blueGrey;

Color whiteColor = Colors.white;
Color primaryColor = const Color(0xff9610FF);
// Color primaryColor = Colors.white;
Color backgroundColor = const Color(0xff181A20);
Color secondaryColor = const Color(0xff3F434E);
// Color secondaryColor = Colors.black;
const MaterialColor primaryColorTheme = MaterialColor(
  0xff9610FF, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
  <int, Color>{
    50: Color(0xff9610FF), //10%
    100: Color(0xff9610FF), //20%
    200: Color(0xff9610FF), //30%
    300: Color(0xff9610FF), //40%
    400: Color(0xff9610FF), //50%
    500: Color(0xff9610FF), //60%
    600: Color(0xff9610FF), //70%
    700: Color(0xff9610FF), //80%
    800: Color(0xff9610FF), //90%
    900: Color(0xff9610FF), //100%
  },
);

class Value {
  static bool val = false;
  static int showAdDialog = 0;
}
