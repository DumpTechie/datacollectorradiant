import 'dart:async';

import 'package:datacollector/pages/profile_page.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class FinalPage extends StatefulWidget {
  FinalPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _FinalPageState createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> {
  bool _isVisible = false;

  _FinalPageState() {
    new Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ProfilePage()),
            (route) => false);
      });
    });

    new Timer(Duration(milliseconds: 10), () {
      setState(() {
        _isVisible =
            true; // Now it is showing fade effect and navigating to Login page
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(color: Colors.amber.shade100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                child: Container(
                  child: Text('Form successfully submitted',
                      style: TextStyle(fontSize: 54)),
                ),
              )
            ],
          )),
    );
  }
}
