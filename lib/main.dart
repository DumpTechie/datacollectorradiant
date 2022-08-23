import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'pages/splash_screen.dart';

void main() {
  runApp(LoginUiApp());
}

class LoginUiApp extends StatelessWidget {
  Color _primaryColor = HexColor('#ffecd1');
  Color _secondColor = HexColor('#ffe1b5');
  Color _accentColor = HexColor('#fba52a');
  Color _color = HexColor('#036a75');

  // Design color
  // Color _primaryColor= HexColor('#FFC867');
  // Color _accentColor= HexColor('#FF3CBD');

  // Our Logo Color
  // Color _primaryColor= HexColor('#D44CF6');
  // Color _accentColor= HexColor('#5E18C8');

  // Our Logo Blue Color
  //Color _primaryColor= HexColor('#651BD2');
  //Color _accentColor= HexColor('#320181');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Collector',
      theme: ThemeData(
        primaryColor: _primaryColor,
        secondaryHeaderColor: _accentColor,
        primaryColorLight: _secondColor,
        hintColor: _color,
        scaffoldBackgroundColor: HexColor('#ffe1b5'),
        primarySwatch: Colors.grey,
      ),
      home: SplashScreen(title: 'Flutter Login UI'),
    );
  }
}
