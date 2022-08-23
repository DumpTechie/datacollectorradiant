import 'package:datacollector/pages/forgot_password_verification_page.dart';
import 'package:datacollector/pages/geo_tag_page1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:datacollector/common/theme_helper.dart';

import 'forgot_password_page.dart';
import 'profile_page.dart';
import 'registration_page.dart';
import 'widgets/header_widget.dart';
import 'package:sql_conn/sql_conn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneNum = new TextEditingController();
  double _headerHeight = 250;
  Key _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true,
                  Icons.login_rounded), //let's create a common header widget
            ),
            Text(
              'Welcome Back',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Text(
              'Signin into your account',
              style: TextStyle(color: Colors.grey),
            ),
            SafeArea(
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
                  height: 550,
                  margin: EdgeInsets.fromLTRB(
                      0, 10, 0, 10), // This will be the login form
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).primaryColorLight,
                    boxShadow: [
                      BoxShadow(color: Colors.white, spreadRadius: 3),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 60.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                child: TextField(
                                  controller: phoneNum,
                                  decoration: ThemeHelper().textInputDecoration(
                                      'Phone Number',
                                      'Enter your Phone Number'),
                                  keyboardType: TextInputType.number,
                                ),
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 30.0),
                              // Container(
                              //   child: TextField(
                              //     obscureText: true,
                              //     decoration: ThemeHelper().textInputDecoration(
                              //         'Password', 'Enter your password'),
                              //   ),
                              //   decoration:
                              //       ThemeHelper().inputBoxDecorationShaddow(),
                              // ),
                              // SizedBox(height: 15.0),
                              // Container(
                              //   margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                              //   alignment: Alignment.topRight,
                              //   child: GestureDetector(
                              //     onTap: () {
                              //       Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) =>
                              //                 ForgotPasswordPage()),
                              //       );
                              //     },
                              //     child: Text(
                              //       "Forgot your password?",
                              //       style: TextStyle(
                              //         color: Colors.grey,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Container(
                                decoration:
                                    ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(
                                      Theme.of(context)
                                          .secondaryHeaderColor
                                          .toString()
                                          .split('(0x')[1]
                                          .split(')')[0]),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text(
                                      'Sign In'.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  onPressed: () async {
                                    //After successful login we will redirect to profile page. Let's create profile page now
                                    try {
                                      if (phoneNum.text.length == 10) {
                                        print(phoneNum.text);
                                        String num = phoneNum.text;
                                        await SqlConn.connect(
                                            ip: '<ip-address>',
                                            port: "1433",
                                            databaseName:
                                                "Android_AlternateLive_Test_Raytech",
                                            username: "<usrname>",
                                            password: "<pass>");
                                        var data = await SqlConn.readData(
                                            'SELECT * FROM dbo.FOS_MASTER where MobileNo =' +
                                                num);
                                        // print(data);
                                        // print(data.length);
                                        if (data.length > 2) {
                                          print("hi");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ForgotPasswordVerificationPage(
                                                          phNum:
                                                              phoneNum.text)));
                                        }
                                        debugPrint("Connected!");
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ThemeHelper().alartDialog(
                                                "Incorrect Mobile Number",
                                                "Please enter  a valid phone num.",
                                                context);
                                          },
                                        );
                                      }
                                    } catch (e) {
                                      debugPrint(e.toString());
                                    } finally {
                                      print('finally');
                                    }
                                  },
                                ),
                              ),
                              // Container(
                              //   margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                              //   //child: Text('Don\'t have an account? Create'),
                              //   child: Text.rich(TextSpan(children: [
                              //     TextSpan(text: "Don\'t have an account? "),
                              //     TextSpan(
                              //       text: 'Create',
                              //       recognizer: TapGestureRecognizer()
                              //         ..onTap = () {
                              //           Navigator.push(
                              //               context,
                              //               MaterialPageRoute(
                              //                   builder: (context) =>
                              //                       RegistrationPage()));
                              //         },
                              //       style: TextStyle(
                              //           fontWeight: FontWeight.bold,
                              //           color: Theme.of(context)
                              //               .secondaryHeaderColor),
                              //     ),
                              //   ])),
                              // ),
                            ],
                          )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
