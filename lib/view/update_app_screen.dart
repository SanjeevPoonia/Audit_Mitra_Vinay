
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/app_theme.dart';
class UpdateAppScreen extends StatefulWidget
{
  UpdateAppState createState()=>UpdateAppState();
}
class UpdateAppState extends State<UpdateAppScreen>
{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
               // BackgroundWidget(),
                Column(
                  children: [
                    const SizedBox(height: 100),
                    Image.asset("assets/app_logo.png",width: 150,height: 150),
                    const SizedBox(height: 30),
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12))),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Update',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16.5,color: AppTheme.themeColor),
                            ),
                            const SizedBox(height: 15),

                            const Text(
                              'A new version of Audit Mitra is available on store, please update your app ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15),
                            ),

                            const SizedBox(height: 25),

                            Container(
                              margin:
                              const EdgeInsets.symmetric(horizontal: 6),
                              height: 48,
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      foregroundColor: MaterialStateProperty.all<Color>(
                                          Colors.white),
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          AppTheme.themeColor),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                              side: BorderSide(
                                                  color: AppTheme.themeColor)))),
                                  onPressed: () {
                                    if(Platform.isAndroid)
                                      {
                                        launchUrl(
                                          Uri.parse('https://play.google.com/store/apps/details?id=com.qaudit.rbl'),
                                          mode: LaunchMode.externalApplication,
                                        );
                                      }
                                    else
                                      {
                                        launchUrl(
                                          Uri.parse('https://apps.apple.com/in/app/audit-wave/id6737145036'),
                                          //mode: LaunchMode.externalApplication,
                                        );
                                      }
                                  },
                                  child: const Text("UPDATE", style: TextStyle(fontSize: 14))),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
              ],
            ),
          ),
        ));
  }

}