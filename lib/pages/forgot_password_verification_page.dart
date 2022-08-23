import 'dart:ffi';

import 'package:datacollector/common/data.dart';
import 'package:datacollector/pages/geo_tag_page1.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:datacollector/common/theme_helper.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'profile_page.dart';
import 'widgets/header_widget.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

class ForgotPasswordVerificationPage extends StatefulWidget {
  final phNum;
  const ForgotPasswordVerificationPage({Key? key, required this.phNum})
      : super(key: key);

  @override
  _ForgotPasswordVerificationPageState createState() =>
      _ForgotPasswordVerificationPageState(phNum);
}

class _ForgotPasswordVerificationPageState
    extends State<ForgotPasswordVerificationPage> {
  final otpController = new OtpFieldController();
  var phNumber;
  var otp = 0;
  var pinNum = '';
  _ForgotPasswordVerificationPageState(phnum) {
    this.phNumber = phnum;
    this.otp = Generate6Otp();
    print(otp);
    sendotp(otp);
  }
  sendotp(otpNum) async {
    print('otp');
    var queryParameters = {
      'key': 'b39b459ec1810d98f1c388115689c000',
      'route': '2',
      'sender': 'TECHRA',
      'number': phNumber,
      'sms':
          'TECHNORAD : Your OTP for Veh Reg No: XX 00 X 0000 is :' + "$otpNum",
      'templateid': '1707161830632202624'
    };
    var uri = Uri.http('site.ping4sms.com', '/api/smsapi', queryParameters);
    var response = await http.get(uri);
    print(response);
  }

  final _formKey = GlobalKey<FormState>();
  bool _pinSuccess = false;
  Generate6Otp() {
    var rng = new Random();
    var rand = rng.nextInt(900000) + 100000;
    return (rand.toInt());
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
                              controller: otpController,
                              length: 6,
                              width: 300,
                              fieldWidth: 30,
                              style: TextStyle(fontSize: 30),
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldStyle: FieldStyle.underline,
                              onCompleted: (pin) {
                                setState(() {
                                  pinNum = pin;
                                  _pinSuccess = true;
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
                                        sendotp(otp);
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
                                style: ThemeHelper().buttonStyle(),
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
                                        print(otp);

                                        if ('$otp' == pinNum) {
                                          formData data = new formData();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      GeoTagPageOne(data)));
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ThemeHelper().alartDialog(
                                                  "Invalid Pin",
                                                  "Enter the correct OTP",
                                                  context);
                                            },
                                          );
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
