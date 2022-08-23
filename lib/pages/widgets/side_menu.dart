// This widget will draw header section of all page. Wich you will get with the project source code.

import 'package:datacollector/common/data.dart';
import 'package:datacollector/pages/geo_tag_page1.dart';
import 'package:datacollector/pages/profile_page.dart';
import 'package:datacollector/pages/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SideMenu extends StatefulWidget {
  final double _height;

  const SideMenu(this._height, {Key? key}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState(_height);
}

class _SideMenuState extends State<SideMenu> {
  double _headerHeight = 250;
  double _height;
  double _drawerIconSize = 24;
  double _drawerFontSize = 17;

  _SideMenuState(this._height);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
            0.0,
            1.0
          ],
              colors: [
            Theme.of(context).primaryColor.withOpacity(0.1),
            Theme.of(context).primaryColorLight.withOpacity(0.2),
          ])),
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 1.0],
                colors: [
                  Theme.of(context).primaryColorLight,
                  Theme.of(context).primaryColor,
                ],
              ),
            ),
            child: Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true,
                  Icons.login_rounded), //let's create a common header widget
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.format_align_center,
              size: _drawerIconSize,
              color: Theme.of(context).secondaryHeaderColor,
            ),
            title: Text(
              'GeoTaging',
              style: TextStyle(
                  fontSize: _drawerFontSize,
                  color: Theme.of(context).secondaryHeaderColor),
            ),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GeoTagPageOne(new formData())));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              size: _drawerIconSize,
              color: Theme.of(context).secondaryHeaderColor,
            ),
            title: Text(
              'Profile',
              style: TextStyle(
                  fontSize: _drawerFontSize,
                  color: Theme.of(context).secondaryHeaderColor),
            ),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout_rounded,
              size: _drawerIconSize,
              color: Theme.of(context).secondaryHeaderColor,
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                  fontSize: _drawerFontSize,
                  color: Theme.of(context).secondaryHeaderColor),
            ),
            onTap: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
    );
  }
}

class ShapeClipper extends CustomClipper<Path> {
  List<Offset> _offsets = [];
  ShapeClipper(this._offsets);
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height - 20);

    // path.quadraticBezierTo(size.width/5, size.height, size.width/2, size.height-40);
    // path.quadraticBezierTo(size.width/5*4, size.height-80, size.width, size.height-20);

    path.quadraticBezierTo(
        _offsets[0].dx, _offsets[0].dy, _offsets[1].dx, _offsets[1].dy);
    path.quadraticBezierTo(
        _offsets[2].dx, _offsets[2].dy, _offsets[3].dx, _offsets[3].dy);

    // path.lineTo(size.width, size.height-20);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
