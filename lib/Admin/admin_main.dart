import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sai_life/Admin/AdminDashboard/admin_home.dart';
import 'package:sai_life/Admin/AdminDashboard/admin_product.dart';
import 'package:sai_life/Admin/AdminDashboard/admin_profile.dart';
import 'package:sai_life/Admin/AdminDashboard/all_orders.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    AdminHome(),
    AllOrders(),
    AdminProduct(),
    AdminProfile()
  ];
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
      systemNavigationBarColor: Colors.transparent, // navigation bar color
      statusBarIconBrightness: Brightness.dark, // status bar icons' color
      systemNavigationBarIconBrightness: Brightness.dark,
      //navigation bar icons' color
    ));
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: GestureDetector(
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
              onTap: () => exit(0)),
          title: const Text(
            'SAi LiFE CHEMiST',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.teal,
        ),
        body: Container(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Card(
          margin: const EdgeInsets.only(left: 17, right: 17, bottom: 5),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 3),
              child: GNav(
                rippleColor: Colors.transparent,
                hoverColor: Colors.transparent,
                gap: 8,
                tabBorderRadius: 10,
                activeColor: Colors.black,
                iconSize: 25,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 500),
                tabBackgroundColor: Colors.transparent,
                color: Colors.blueGrey,
                tabs: const [
                  GButton(
                    icon: Icons.home_filled,
                    text: '',
                  ),
                  GButton(
                    icon: Icons.shopping_bag,
                    text: '',
                  ),
                  GButton(
                    icon: Icons.medical_services,
                    text: '',
                  ),
                  GButton(
                    icon: Icons.person,
                    text: '',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ));
  }
}
