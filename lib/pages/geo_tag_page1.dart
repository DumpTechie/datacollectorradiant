import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:datacollector/common/data.dart';
import 'package:datacollector/pages/geo_tag_page2.dart';
import 'package:datacollector/pages/widgets/side_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:datacollector/common/theme_helper.dart';
import 'package:datacollector/pages/forgot_password_verification_page.dart';
import 'package:datacollector/pages/widgets/header_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:sql_conn/sql_conn.dart';

import 'profile_page.dart';

class GeoTagPageOne extends StatefulWidget {
  formData data;
  GeoTagPageOne(this.data) {
    print(' in const');
  }
  @override
  State<StatefulWidget> createState() {
    return _GeoTagPageOneState(data);
  }
}

class _GeoTagPageOneState extends State<GeoTagPageOne> {
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;
  String valueLocation = '';
  String valueDistrict = '';
  String valueState = '';

  String addressOne = '';
  String addressTwo = '';
  String pinCode = '';
  String Taluk = '';
  String state = '';
  String District = '';

  final _addOne = new TextEditingController();
  final _addTwo = new TextEditingController();
  final _pinCode = new TextEditingController();
  final _pinLocation = new TextEditingController();
  final _taluk = new TextEditingController();
  final _state = new TextEditingController();
  final _district = new TextEditingController();
  var locationDetails;
  var latitude;
  var longitude;
  // List of items in our dropdown menu
  var itemsDistrict = [
    '',
  ];
  List<String> itemsLocation = [];
  var itemsState = [];
  formData data;
  late StreamSubscription<Position> streamSubscription;
  refreshPinLoc() async {
    try {
      if (pinCode != '') {
        await SqlConn.connect(
            ip: '<ip-address>',
            port: "1433",
            databaseName: "NewTestDB20190906_Test_Raytech",
            username: "<usrname>",
            password: "<pass>");
        print(pinCode);
        var data = await SqlConn.readData(
            'select * from dbo.PinLocation_Details where PinCode=' + pinCode);
        print(data);
        if (data.length > 0) {
          print("hi");
          print(data.runtimeType);
          var map2 = json.decode(data);
          print(map2[0].runtimeType);
          var map3 = HashMap.from(map2[0]);
          List<String> listLocation = [];
          var Val;
          map2.forEach((item) {
            var i = HashMap.from(item);
            Val = i['LocationName'].toString();
            listLocation.add(Val);
          });
          print(map3);
          print(listLocation);
          data.pinLocation = listLocation;
          setState(() {
            itemsLocation = listLocation;
            // valueLocation = Val;
          });
        }
      }
      debugPrint("Connected!");
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      print('finally');
    }
  }

  _GeoTagPageOneState(this.data) {
    print('in state const');
    if (data.address['houseNumber'] != '' ||
        data.address['houseName'] != '' ||
        data.address['street'] != '') {
      addressOne =
          '${data.address['houseNumber']}, ${data.address['houseName']},  ${data.address['street']}';
    }
    if (data.address['locality'] != '' || data.address['locality'] != '') {
      addressTwo = '${data.address['locality']} , ${data.address['locality']}';
    }
    pinCode = '${data.address['locality']}';
    District = '${data.address['district']}';
    state = '${data.address['state']}';
    _addOne.value = _addOne.value.copyWith(
      text: addressOne,
      selection: TextSelection.collapsed(offset: addressOne.length),
    );
    _addTwo.value = _addTwo.value.copyWith(
      text: addressTwo,
      selection: TextSelection.collapsed(offset: addressOne.length),
    );
    _pinCode.value = _pinCode.value.copyWith(
      text: pinCode,
      selection: TextSelection.collapsed(offset: addressOne.length),
    );
    _taluk.value = _taluk.value.copyWith(
      text: Taluk,
      selection: TextSelection.collapsed(offset: addressOne.length),
    );
    _state.value = _taluk.value.copyWith(
      text: state,
      selection: TextSelection.collapsed(offset: addressOne.length),
    );
    _district.value = _taluk.value.copyWith(
      text: District,
      selection: TextSelection.collapsed(offset: addressOne.length),
    );
    print('constuctor end');
    print(addressOne);
    refreshPinLoc();
    if (addressOne == ',,') {
      _determinePosition();
    }
  }
  decodeCall(uri) async {
    print(data);
    data.phoneNum;
    var res = await http.get(uri);
    print(res);
    print(res.statusCode);

    if (res.statusCode == 200) {
      print(res.body);
      Map<String, dynamic> responseJson = json.decode(res.body);
      // print(responseJson.runtimeType);
      List<Map<String, dynamic>> list = [];
      var cd = responseJson.forEach((key, value) {
        Map<String, dynamic> value2 = Map.of({key: value});
        list.add(value2);
      });
      print(list[2].runtimeType);
      var map = HashMap.from(list[2]);
      print(map['results'][0].runtimeType);
      print(map['results'][0]['houseNumber']);
      var resultMap = map['results'][0];
      // var ld = {
      //   "houseNumber": resultMap["houseNumber"],
      //   "houseName": resultMap["houseName"],
      //   "poi": resultMap["poi"],
      //   "poi_dist": resultMap["poi_dist"],
      //   "street": resultMap["street"],
      //   "street_dist": resultMap["street_dist"],
      //   "subSubLocality": resultMap["subSubLocality"],
      //   "subLocality": resultMap["subLocality"],
      //   "locality": resultMap["locality"],
      //   "village": resultMap["village"],
      //   "district": resultMap["district"],
      //   "subDistrict": resultMap["subDistrict"],
      //   "city": resultMap["city"],
      //   "state": resultMap["state"],
      //   "pincode": resultMap["pincode"],
      //   "lat": resultMap["lat"],
      //   "lng": resultMap["lng"],
      //   "area": resultMap["area"],
      //   "formatted_address": resultMap["formatted_address"]
      // };
      locationDetails = resultMap;
      if (resultMap['houseNumber'] != '' ||
          resultMap['houseName'] != '' ||
          resultMap['street'] != '') {
        addressOne =
            '${resultMap['houseNumber']}, ${resultMap['houseName']},  ${resultMap['street']}';
      }
      print(addressOne);
      addressTwo = '${resultMap['subLocality']}, ${resultMap['locality']}';
      pinCode = '${resultMap['pincode']}';
      District = '${resultMap['district']}';
      state = '${resultMap['state']}';
      Taluk = '${resultMap['subDistrict']}';
      _addOne.value = _addOne.value.copyWith(
        text: addressOne,
        selection: TextSelection.collapsed(offset: addressOne.length),
      );
      _addTwo.value = _addTwo.value.copyWith(
        text: addressTwo,
        selection: TextSelection.collapsed(offset: addressOne.length),
      );
      _pinCode.value = _pinCode.value.copyWith(
        text: pinCode,
        selection: TextSelection.collapsed(offset: addressOne.length),
      );
      _taluk.value = _taluk.value.copyWith(
        text: Taluk,
        selection: TextSelection.collapsed(offset: addressOne.length),
      );
      _state.value = _taluk.value.copyWith(
        text: state,
        selection: TextSelection.collapsed(offset: addressOne.length),
      );
      _district.value = _taluk.value.copyWith(
        text: District,
        selection: TextSelection.collapsed(offset: addressOne.length),
      );

      refreshPinLoc();
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request u
      //sers of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var poss = Geolocator.getCurrentPosition();
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((position) {
      print(position.latitude);
      print(position.longitude);
      latitude = position.latitude;
      longitude = position.longitude;
      String url = 'apis.mapmyindia.com';
      var params = {
        'lat': position.latitude.toString(),
        'lng': position.longitude.toString(),
        'region': 'IND',
        'lang': 'hello'
      };
      final uri = Uri.https(
          url,
          '/advancedmaps/v1/7529c725a48e6a978f76fc957e6bb366/rev_geocode',
          params);
      decodeCall(uri);
      // Geocoder.local
      //     .findAddressesFromCoordinates(coordinates)
      //     .then((placemarks) {
      //   setState(() {
      //     print(placemarks.first.addressLine);
      //     print(placemarks.first.adminArea);
      //     print(placemarks.first.countryName);
      //     print(placemarks.first.featureName);
      //     print(placemarks.first.locality);
      //     print(placemarks.first.subAdminArea);
      //     print(placemarks.first.subLocality);
      //     print(placemarks.first.subThoroughfare);
      //     print(placemarks.first.thoroughfare);
      //     print(placemarks.first.toMap());
      //     print(placemarks.first.subAdminArea);
      //     addressOne =
      //         'No:${placemarks.first.subThoroughfare},${placemarks.first.subThoroughfare}';
      //     addressTwo =
      //         '${placemarks.first.subLocality}, ${placemarks.first.locality}, ${placemarks.first.countryName}';
      //     pinCode = '${placemarks.first.postalCode}';
      //     Taluk = '${placemarks.first.adminArea}';

      //     _addOne.value = _addOne.value.copyWith(
      //       text: addressOne,
      //       selection: TextSelection.collapsed(offset: addressOne.length),
      //     );
      //     _addTwo.value = _addTwo.value.copyWith(
      //       text: addressTwo,
      //       selection: TextSelection.collapsed(offset: addressOne.length),
      //     );
      //     _pinCode.value = _pinCode.value.copyWith(
      //       text: pinCode,
      //       selection: TextSelection.collapsed(offset: addressOne.length),
      //     );
      //     _taluk.value = _taluk.value.copyWith(
      //       text: Taluk,
      //       selection: TextSelection.collapsed(offset: addressOne.length),
      //     );
      //   });
      // });
    });

    return await poss;
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
                Theme.of(context).primaryColorLight,
                Theme.of(context).primaryColor,
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
                          margin: EdgeInsets.fromLTRB(100, 0, 0, 0),
                          child: Text(
                            'Geo Tagging',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            print('hi');
                            _determinePosition();
                          },
                          icon: Icon(Icons.location_on),
                          label: Text("Pin location"),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: TextFormField(
                            decoration: ThemeHelper().textInputDecoration(
                                'Address Line 1',
                                'Enter your First line of Address'),
                            controller: _addOne,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            decoration: ThemeHelper().textInputDecoration(
                                'Address Line 2',
                                "Enter your Second line of Address"),
                            controller: _addTwo,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                            child: DropdownButtonFormField(
                          decoration: ThemeHelper().dropDownDecoration(),
                          hint: const Text(
                            'Pin location',
                            style: TextStyle(fontSize: 14),
                          ),
                          // Initial Value
                          // value: valueLocation,
                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),

                          // Array list of items
                          items: itemsLocation.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              valueLocation = newValue!;
                            });
                          },
                        )),
                        SizedBox(height: 20.0),
                        Row(
                          textDirection: TextDirection.ltr,
                          children: [
                            Expanded(
                              child: Container(
                                child: TextFormField(
                                  decoration: ThemeHelper().textInputDecoration(
                                      'Pincode', "Enter your Pincode"),
                                  controller: _pinCode,
                                ),
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                            ),
                            SizedBox(width: 50),
                            Expanded(
                              child: Container(
                                child: TextFormField(
                                  decoration: ThemeHelper().textInputDecoration(
                                      'Taluk/City', "Enter your Taluk/Cityr"),
                                  controller: _taluk,
                                ),
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            decoration: ThemeHelper().textInputDecoration(
                                'District', "Enter your District"),
                            controller: _district,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            decoration: ThemeHelper().textInputDecoration(
                                'State', "Enter your State"),
                            controller: _state,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          decoration:
                              ThemeHelper().buttonBoxDecoration(context),
                          margin: EdgeInsets.fromLTRB(50, 0, 0, 0),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(Theme.of(context)
                                .secondaryHeaderColor
                                .toString()
                                .split('(0x')[1]
                                .split(')')[0]),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "Next >>".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  await SqlConn.connect(
                                      ip: '<ip-address>',
                                      port: "1433",
                                      databaseName:
                                          "NewTestDB20190906_Test_Raytech",
                                      username: "<usrname>",
                                      password: "<pass>");
                                  print(pinCode);
                                  var query =
                                      "insert into dbo.Location_Detail (houseNumber, houseName, poi,poi_dist,street,street_dist,subSubLocality,subLocality,locality,village,district,subDistrict,city,state,pincode,lat,lng,area,formatted_address)VALUES ('${locationDetails['houseNumber']}','${locationDetails['houseName']}' ,'${locationDetails['poi']}', ${locationDetails['poi_dist']},'${locationDetails['street']}',${locationDetails['street_dist']},'${locationDetails['subSubLocality']}','${locationDetails['subLocality']}','${locationDetails['locality']}','${locationDetails['village']}','${locationDetails['district']}','${locationDetails['subDistrict']}','${locationDetails['city']}','${locationDetails['state']}',${locationDetails['pincode']},${latitude},${longitude},'${locationDetails['area']}','${locationDetails['formatted_address']}')";
                                  var datasucc = await SqlConn.writeData(query);
                                  print(datasucc);
                                  debugPrint("Connected!");
                                  data.address = locationDetails;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              GeoTagPageTwo(data)));
                                } catch (e) {
                                  debugPrint(e.toString());
                                } finally {
                                  print('finally');
                                }
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 30.0),
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
