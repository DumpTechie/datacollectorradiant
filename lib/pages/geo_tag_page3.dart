import 'dart:convert';

import 'package:datacollector/common/data.dart';
import 'package:datacollector/pages/final_page.dart';
import 'package:datacollector/pages/geo_tag_page2.dart';
import 'package:datacollector/pages/widgets/side_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:datacollector/common/theme_helper.dart';
import 'package:datacollector/pages/forgot_password_verification_page.dart';
import 'package:datacollector/pages/widgets/header_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:http/http.dart' as http;

import 'profile_page.dart';

class GeoTagPageThree extends StatefulWidget {
  formData data;
  GeoTagPageThree(this.data);
  @override
  State<StatefulWidget> createState() {
    return _GeoTagPageThreeState(data);
  }
}

class _GeoTagPageThreeState extends State<GeoTagPageThree> {
  formData data;
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;
  String valueProf = '';
  String valueSect = '';
  // List of items in our dropdown menu
  var itemsProf = ['prof1', 'Prof2', 'prof2'];
  var itemsStatus = ['rent', 'Lease', 'owned'];
  var itemsSize = ['1+1', '1+2', '1+3'];
  var itemsSect = [
    'Private',
    'Public',
    'Self',
  ];
  final _rc_no = new TextEditingController();

  _GeoTagPageThreeState(this.data) {
    print(data.headName);
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                'Geo Tagging Page3',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                            width: 150,
                            child: DropdownButtonFormField(
                              decoration: ThemeHelper().dropDownDecoration(),
                              hint: const Text(
                                'Profession',
                                style: TextStyle(fontSize: 14),
                              ),
                              // Initial Value
                              value: data.prof == '' ? null : data.prof,

                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),

                              // Array list of items
                              items: itemsProf.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  data.prof = newValue!;
                                });
                              },
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                            child: DropdownButtonFormField(
                          decoration: ThemeHelper().dropDownDecoration(),
                          hint: const Text(
                            'Sector(Only for  employees)',
                            style: TextStyle(fontSize: 14),
                          ),
                          // Initial Value
                          value: data.sect == '' ? null : data.sect,

                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),

                          // Array list of items
                          items: itemsSect.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              data.sect = newValue!;
                            });
                          },
                        )),
                        SizedBox(height: 20.0),
                        Container(
                            child: DropdownButtonFormField(
                          decoration: ThemeHelper().dropDownDecoration(),
                          hint: const Text(
                            'Residence status',
                            style: TextStyle(fontSize: 14),
                          ),
                          // Initial Value
                          value: data.status == '' ? null : data.status,

                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),

                          // Array list of items
                          items: itemsStatus.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              data.status = newValue!;
                            });
                          },
                        )),
                        SizedBox(height: 20.0),
                        Container(
                            child: DropdownButtonFormField(
                          decoration: ThemeHelper().dropDownDecoration(),
                          hint: const Text(
                            'Family Size',
                            style: TextStyle(fontSize: 14),
                          ),
                          // Initial Value
                          // if(data.size!='')
                          value: data.Size == '' ? null : data.Size,

                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),

                          // Array list of items
                          items: itemsSize.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              data.Size = newValue!;
                            });
                          },
                        )),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                'Vehicle Details',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 250,
                          child: TextFormField(
                            controller: _rc_no,
                            decoration: ThemeHelper().textInputDecoration(
                                'Vehicle Registration No',
                                'Enter your Registration number'),
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
                                  if (_formKey.currentState!.validate()) {
                                    print(data.prof);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GeoTagPageTwo(data)));
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
                                    "Submit".toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  print(data.prof);
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      print(_rc_no.text);
                                      String num = '7845812198';
                                      await SqlConn.connect(
                                          ip: '<ip-address>',
                                          port: "1433",
                                          databaseName:
                                              "NewTestDB20190906_Test_Raytech",
                                          username: "<usrname>",
                                          password: "<pass>");
                                      var dataQuery = await SqlConn.readData(
                                          "select * from dbo.Vahan_Details_Pro where rc_regn_no='${_rc_no.text}'");
                                      print(dataQuery);
                                      print(dataQuery.length);
                                      if (dataQuery.length > 2) {
                                        print('already exixts');
                                      } else {
                                        print('doesnt exists');
                                        Map<String, String> body = {
                                          'consent': 'Y',
                                          'rc_no': '${_rc_no.text}',
                                        };
                                        String url = 'production.aadrila.com';
                                        var parms = {
                                          'consent': 'Y',
                                          'rc_no': '${_rc_no.text}'
                                        };
                                        final uri = Uri.https(url,
                                            '/api/v1/variant-id-lite', parms);
                                        print(uri);
                                        var res =
                                            await http.post(uri, headers: {
                                          'Content-Type': 'application/json',
                                          'Accept': 'application/json',
                                          'Authorization':
                                              'Bearer 0a7c6d2e49ca45ffa17391ef9bfff8b7',
                                        });
                                        print(res.body);
                                        var fRes = '';
                                        if (res.statusCode == 200) {
                                          Map<String, dynamic> responseJson =
                                              json.decode(res.body);
                                          // print(responseJson.runtimeType);
                                          List<Map<String, dynamic>> list = [];
                                          var cd = responseJson
                                              .forEach((key, value) {
                                            Map<String, dynamic> value2 =
                                                Map.of({key: value});
                                            list.add(value2);
                                          });
                                          print(list);
                                          for (var item in list) {
                                            print(
                                                item['data']['rc_owner_name']);
                                            var response = item['data'];

                                            var qur =
                                                'INSERT INTO dbo.Vahan_Details_Pro(rc_regn_no ,rc_rto_code,rc_regn_dt,rc_owner_sr,rc_registered_at,rc_fit_upto,rc_tax_upto,rc_status_as_on,rc_financer,rc_insurance_comp,rc_insurance_policy_no,rc_insurance_upto,rc_vch_catg,rc_vh_class_desc,rc_manu_month_yr,rc_chasi_no,rc_eng_no],rc_cubic_cap,rc_maker_desc,rc_maker_model,rc_color,rc_body_type_desc,rc_fuel_desc,rc_wheelbase,rc_unld_wt,rc_gvw,rc_no_cyl,rc_seat_cap,rc_sleeper_cap,rc_stand_cap,rc_norms_desc,rc_status,rc_ncrb_status,rc_blacklist_status,rc_noc_details,rc_pucc_no,rc_owner_name,rc_f_name,rc_mobile_no,rc_present_address,rc_permanent_address,rc_permit_no,rc_permit_issue_dt,rc_permit_valid_from,rc_permit_valid_upto ,rc_permit_type,insurance_comp_id ,insurance_comp_name,Insurance_Company_ID_PK ,financier_name_master ,financier_code_master,vehicle_rto,pin_code,rc_owner_first_name ,rc_owner_last_name,id,Created_User_Id,vehicle_No)VALUES("${response['rc_regn_no']}","${response['rc_rto_code']}","date(${response['rc_regn_dt']})","${response['rc_owner_sr']}","${response['rc_registered_at']}","date(${response['rc_fit_upto']})","${response['rc_tax_upto']}","date(${response['rc_status_as_on']})","${response['rc_financer']}","${response['rc_insurance_comp']}","${response['rc_insurance_policy_no']}","date(${response['rc_insurance_upto']})","${response['rc_vch_catg']}","${response['rc_vh_class_desc']}","${response['rc_manu_month_yr']}","${response['rc_chasi_no']}" ,"${response['rc_eng_no']}","${response['rc_cubic_cap']}","${response['rc_maker_desc']}","${response['rc_maker_model']}","${response['rc_color']}" ,"${response['rc_body_type_desc']}","${response['rc_fuel_desc']}","${response['rc_wheelbase']}" ,"${response['rc_unld_wt']}","${response['rc_gvw']}","${response['rc_no_cyl']}","${response['rc_seat_cap']}","${response['rc_sleeper_cap']}","${response['rc_stand_cap']}","${response['rc_norms_desc']}","${response['rc_status']}","${response['rc_ncrb_status']}","${response['rc_blacklist_status']}","${response['rc_noc_details']}","${response['rc_pucc_no']}","${response['rc_pucc_upto']}" ,"${response['rc_owner_name']}","${response['rc_f_name']}" ,"${response['rc_mobile_no']}","${response['rc_present_address']}","${response['rc_permanent_address']}","${response['rc_permit_no']}","${response['rc_permit_issue_dt']}","${response['rc_permit_valid_from']}","${response['rc_permit_valid_upto']}","${response['rc_permit_type']}","${response['crn']}","${response['insurance_comp_id']}","${response['insurance_comp_name']}","${response['financier_name_master']}","${response['financier_code_master']}","${response['state_code']}","${response['rto_code']}","${response['vehicle_rto']}","${response['pin_code']}","${response['rc_owner_first_name']}" ," ","${_rc_no.text}")';
                                            print(qur);
                                            var temp =
                                                'VALUES("${response['rc_regn_no']}","${response['rc_rto_code']}","${response['rc_regn_dt']}","${response['rc_owner_sr']}","${response['rc_registered_at']}","${response['rc_fit_upto']}","${response['rc_tax_upto']}","${response['rc_status_as_on']}","${response['rc_financer']}","${response['rc_insurance_comp']}","${response['rc_insurance_policy_no']}","${response['rc_insurance_upto']}","${response['rc_vch_catg']}","${response['rc_vh_class_desc']}","${response['rc_manu_month_yr']}","${response['rc_chasi_no']}" ,"${response['rc_eng_no']}","${response['rc_cubic_cap']}","${response['rc_maker_desc']}","${response['rc_maker_model']}","${response['rc_color']}" ,"${response['rc_body_type_desc']}","${response['rc_fuel_desc']}","${response['rc_wheelbase']}" ,"${response['rc_unld_wt']}","${response['rc_gvw']}","${response['rc_no_cyl']}","${response['rc_seat_cap']}","${response['rc_sleeper_cap']}","${response['rc_stand_cap']}","${response['rc_norms_desc']}","${response['rc_status']}","${response['rc_ncrb_status']}","${response['rc_blacklist_status']}","${response['rc_noc_details']}","${response['rc_pucc_no']}","${response['rc_pucc_upto']}" ,"${response['rc_owner_name']}","${response['rc_f_name']}" ,"${response['rc_mobile_no']}","${response['rc_present_address']}","${response['rc_permanent_address']}","${response['rc_permit_no']}","${response['rc_permit_issue_dt']}","${response['rc_permit_valid_from']}","${response['rc_permit_valid_upto']}","${response['rc_permit_type']}","${response['crn']}","${response['insurance_comp_id']}","${response['insurance_comp_name']}","${response['financier_name_master']}","${response['financier_code_master']}","${response['state_code']}","${response['rto_code']}","${response['vehicle_rto']}","${response['pin_code']}","${response['rc_owner_first_name']}" ,"${response['rc_owner_last_name']}"," " ," "," "," ","${_rc_no.text}")';
                                            print(temp);
                                            var dataWriteQuery =
                                                await SqlConn.writeData(qur);
                                            print(dataWriteQuery);
                                          }
                                        }
                                      }
                                    } catch (e) {
                                      debugPrint(e.toString());
                                    } finally {
                                      print('finally');
                                    }
                                    //     .shAndRemoveUntil(
                                    //         MaterialPageRoute(
                                    //             builder: (context) => FinalPage(
                                    //                 title: 'Success page')),
                                    //         (Route<dynamic> route) => false);
                                  }
                                },
                              ),
                            ),
                          ],
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
