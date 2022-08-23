// import 'dart:html';
import 'package:datacollector/common/data.dart';
import 'package:datacollector/pages/geo_tag_page1.dart';
import 'package:datacollector/pages/geo_tag_page3.dart';
import 'package:datacollector/pages/mobile_verification_page.dart';
import 'package:datacollector/pages/widgets/side_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:datacollector/common/theme_helper.dart';
import 'package:datacollector/pages/forgot_password_verification_page.dart';
import 'package:datacollector/pages/widgets/header_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

import 'profile_page.dart';

class GeoTagPageTwo extends StatefulWidget {
  formData data;
  GeoTagPageTwo(this.data) {}
  @override
  State<StatefulWidget> createState() {
    return _GeoTagPageTwoState(data);
  }
}

class _GeoTagPageTwoState extends State<GeoTagPageTwo> {
  formData data;
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;
  String valueSaluation = '';
  DateTime date = DateTime.now();
  // List of items in our dropdown menu
  var itemsSalutation = ['Mr.', 'Ms', 'Mrs'];
  final _sal = new TextEditingController();
  final _name = new TextEditingController();
  final _dobController = new TextEditingController();
  final _email = new TextEditingController();
  final _mobile = new TextEditingController();

  _GeoTagPageTwoState(this.data) {
    print(data.headName);
    _sal.value = _sal.value.copyWith(
      text: data.sal,
      selection: TextSelection.collapsed(offset: data.sal.length),
    );
    _name.value = _name.value.copyWith(
      text: data.headName,
      selection: TextSelection.collapsed(offset: data.headName.length),
    );
    _dobController.value = _dobController.value.copyWith(
      text: data.dob,
      selection: TextSelection.collapsed(offset: data.dob.length),
    );
    _email.value = _email.value.copyWith(
      text: data.email,
      selection: TextSelection.collapsed(offset: data.email.length),
    );
    _mobile.value = _mobile.value.copyWith(
      text: data.phoneNum,
      selection: TextSelection.collapsed(offset: data.phoneNum.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Generate Lead",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.black),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColorLight,
              ])),
        ),
        // actions: [
        //   Container(
        //     margin: EdgeInsets.only( top: 16, right: 16,),
        //     child: Stack(
        //       children: <Widget>[
        //         Icon(Icons.notifications),
        //         Positioned(
        //           right: 0,
        //           child: Container(
        //             padding: EdgeInsets.all(1),
        //             decoration: BoxDecoration( color: Colors.red, borderRadius: BorderRadius.circular(6),),
        //             constraints: BoxConstraints( minWidth: 12, minHeight: 12, ),
        //             child: Text( '5', style: TextStyle(color: Colors.white, fontSize: 8,), textAlign: TextAlign.center,),
        //           ),
        //         )
        //       ],
        //     ),
        //   )
        // ],
      ),
      drawer: Drawer(child: SideMenu(150)),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(75, 0, 0, 0),
                          child: Text(
                            'Geo Tagging Page2',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                            width: 150,
                            child: DropdownButtonFormField(
                              decoration: ThemeHelper().dropDownDecoration(),
                              // Initial Value

                              value: data.sal == '' ? null : data.sal,
                              hint: const Text(
                                'Salutation',
                                style: TextStyle(fontSize: 14),
                              ),

                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),

                              // Array list of items
                              items: itemsSalutation.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  data.sal = newValue!;
                                });
                              },
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: TextFormField(
                            controller: _name,
                            decoration: ThemeHelper().textInputDecoration(
                                'Family Head Name',
                                data.headName == ''
                                    ? 'Enter your Family Head Name'
                                    : data.headName),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: _email,
                            decoration: ThemeHelper().textInputDecoration(
                                "Email Id",
                                data.email == ''
                                    ? "Enter Email Address"
                                    : data.email),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        GestureDetector(
                            onTap: () async {
                              print("Container clicked");
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      lastDate: DateTime(2030))
                                  .then((pickedDate) {
                                // Check if no date is selected
                                if (pickedDate == null) {
                                  return;
                                }
                                print(
                                    '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}');
                                setState(() {
                                  // using state so that the UI will be rerendered when date is picked
                                  date = pickedDate;
                                  data.dob =
                                      '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                                });
                              });
                            },
                            child: new Container(
                              width: 180,
                              child: TextField(
                                enabled: false,
                                decoration: ThemeHelper().dateInputDecoration(
                                    data.dob == '' ? 'dob' : data.dob),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              decoration:
                                  ThemeHelper().inputBoxDecorationShaddow(),
                            )),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: _mobile,
                            decoration: ThemeHelper().textInputDecoration(
                                "Phone Number", "Enter ur number"),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 30.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration:
                                  ThemeHelper().buttonBoxDecoration(context),
                              width: 140,
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(
                                    Theme.of(context)
                                        .secondaryHeaderColor
                                        .toString()
                                        .split('(0x')[1]
                                        .split(')')[0]),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Text(
                                    "<< Prev".toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  print(date);
                                  if (_formKey.currentState!.validate()) {
                                    data.headName = _name.text;
                                    data.email = _email.text;
                                    data.phoneNum = _mobile.text;
                                    var test = data.sal != '' &&
                                        data.dob != '' &&
                                        _email.text != '' &&
                                        _mobile.text != '' &&
                                        _name.text != '';
                                    print("hello");
                                    print(_dobController.text);
                                    print(_email.text);
                                    print(_mobile.text);
                                    print(_name.text);
                                    print("hi");
                                    if (test) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GeoTagPageThree(data)));
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ThemeHelper().alartDialog(
                                              "Error",
                                              "All feilds are required",
                                              context);
                                        },
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                            Container(
                              decoration:
                                  ThemeHelper().buttonBoxDecoration(context),
                              width: 140,
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(
                                    Theme.of(context)
                                        .secondaryHeaderColor
                                        .toString()
                                        .split('(0x')[1]
                                        .split(')')[0]),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Text(
                                    "Next >>".toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  print(date);
                                  if (_formKey.currentState!.validate()) {
                                    data.headName = _name.text;
                                    data.email = _email.text;
                                    data.phoneNum = _mobile.text;
                                    var test = data.sal != '' &&
                                        data.dob != '' &&
                                        _email.text != '' &&
                                        _mobile.text != '' &&
                                        _name.text != '';
                                    if (test) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MobileVerificationPage(
                                                      data: data)));
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ThemeHelper().alartDialog(
                                              "Error",
                                              "All feilds are required",
                                              context);
                                        },
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
