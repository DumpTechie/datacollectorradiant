import 'dart:math';

import 'package:datacollector/common/data.dart';
import 'package:datacollector/pages/geo_tag_page1.dart';
import 'package:datacollector/pages/geo_tag_page3.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:datacollector/common/theme_helper.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import 'profile_page.dart';
import 'widgets/header_widget.dart';
import 'package:http/http.dart' as http;

class MobileVerificationPage extends StatefulWidget {
  final formData data;
  const MobileVerificationPage({Key? key, required this.data})
      : super(key: key);

  @override
  _MobileVerificationPageState createState() =>
      _MobileVerificationPageState(data);
}

class _MobileVerificationPageState extends State<MobileVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  bool _pinSuccess = false;
  String otp = '-1';
  String pinData = '';
  formData data;
  String genOtp() {
    var rng = new Random();
    var rand = rng.nextInt(900000) + 100000;
    return (rand.toString());
  }

  sendOtp() async {
    print(otp);
    var queryParameters = {
      'key': 'b39b459ec1810d98f1c388115689c000',
      'route': '2',
      'sender': 'TECHRA',
      'number': data.phoneNum,
      'sms': 'TECHNORAD : Your OTP for Veh Reg No: XX 00 X 0000 is :' + "$otp",
      'templateid': '1707161830632202624'
    };
    var uri = Uri.http('site.ping4sms.com', '/api/smsapi', queryParameters);
    var response = await http.get(uri);
    print(response);
  }

  _MobileVerificationPageState(this.data) {
    print(data);
    otp = genOtp();
    sendOtp();
  }
  @override
  Widget build(BuildContext context) {
    double _headerHeight = 200;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: _headerHeight,
                child: HeaderWidget(
                    _headerHeight, true, Icons.privacy_tip_outlined),
              ),
              SafeArea(
                child: Container(
                  margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Verification',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                              // textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Enter the verification code we just sent you on your phone number.',
                              style: TextStyle(
                                  // fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                              // textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            OTPTextField(
                              length: 6,
                              width: 300,
                              fieldWidth: 30,
                              style: TextStyle(fontSize: 30),
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldStyle: FieldStyle.underline,
                              onCompleted: (pin) {
                                setState(() {
                                  _pinSuccess = true;
                                  pinData = pin;
                                });
                              },
                            ),
                            SizedBox(height: 50.0),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "If you didn't receive a code! ",
                                    style: TextStyle(
                                      color: Colors.black38,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Resend',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        sendOtp();
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ThemeHelper().alartDialog(
                                                "Successful",
                                                "Verification code resend successful.",
                                                context);
                                          },
                                        );
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40.0),
                            Container(
                              decoration: _pinSuccess
                                  ? ThemeHelper().buttonBoxDecoration(context)
                                  : ThemeHelper().buttonBoxDecoration(
                                      context, "#AAAAAA", "#757575"),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(
                                    Theme.of(context)
                                        .secondaryHeaderColor
                                        .toString()
                                        .split('(0x')[1]
                                        .split(')')[0]),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    "Verify".toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: _pinSuccess
                                    ? () {
                                        if (pinData == otp) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      GeoTagPageThree(data)));
                                        }
                                      }
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
