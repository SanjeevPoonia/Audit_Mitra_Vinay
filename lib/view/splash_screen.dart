

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qaudit_tata_flutter/network/Utils.dart';
import 'package:qaudit_tata_flutter/view/home_screen.dart';


import 'all_dashboard/client_home_screen.dart';
import 'all_dashboard/qa_home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget
{
  final String token;
  SplashScreen(this.token);
  SplashState createState()=>SplashState();
}
class SplashState extends State<SplashScreen>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(30),

          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/splash_logo.png'),
              fit: BoxFit.contain,
            ),
          ),
        )
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    _navigateUser();

  }

  _navigateUser() async { 
    if(widget.token!='')
      {

        String? userRole=await MyUtils.getSharedPreferences("role");

        if(userRole=="Client")
          {
            Timer(
                Duration(seconds: 2),
                    () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => ClientHomeScreen())));
          }
        else
          {
            Timer(
                Duration(seconds: 2),
                    () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => QAHomeScreen())));
          }






      }
    else
      {
        Timer(
            Duration(seconds: 2),
                () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen())));
      }
}}
