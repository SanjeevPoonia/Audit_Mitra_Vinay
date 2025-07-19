import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qaudit_tata_flutter/utils/app_theme.dart';
import 'package:qaudit_tata_flutter/view/audit_form_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'menu_screen.dart';

class OfflineAuditListScreen extends StatefulWidget {
  OfflineAuditState createState() => OfflineAuditState();
}

class OfflineAuditState extends State<OfflineAuditListScreen>
    with TickerProviderStateMixin {
  List<dynamic> offlineAudits = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      SizedBox(height: 25),
      Card(
        elevation: 4,
        margin: EdgeInsets.only(bottom: 10),
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        child: Container(
          height: 69,
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.keyboard_backspace_rounded,
                      color: Colors.black)),
              Text("Offline Audits",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  )),
              Container()
            ],
          ),
        ),
      ),
      Expanded(
        child: offlineAudits.length == 0
            ? Center(
                child: Text("No offline audits found!"),
              )
            : ListView.builder(
                itemCount: offlineAudits.length,
                padding: EdgeInsets.only(top: 18),
                itemBuilder: (BuildContext context, int pos) {
                  return Column(
                    children: [
                      Card(
                        color: Colors.white,
                        shadowColor: AppTheme.themeColor,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7)),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(offlineAudits[pos]["agency_name"],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey,
                                  )),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text("Audit Type",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      )),
                                  SizedBox(width: 10),
                                  Text(offlineAudits[pos]["audit_type"],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      )),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text("City Name",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      )),
                                  SizedBox(width: 10),
                                  Text(offlineAudits[pos]["city_name"],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      )),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text("Audit Date",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      )),
                                  SizedBox(width: 10),
                                  Text(offlineAudits[pos]["audit_date"],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      )),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Spacer(),
                          InkWell(
                            onTap: () async {
                              final List<ConnectivityResult>
                                  connectivityResult =
                                  await (Connectivity().checkConnectivity());

                              if (connectivityResult
                                  .contains(ConnectivityResult.none)) {
                                Toast.show(
                                    "Internet required to proceed further!",
                                    duration: Toast.lengthLong,
                                    gravity: Toast.bottom,
                                    backgroundColor: Colors.red);
                              } else {
                             /*   Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AuditFormScreen(
                                            offlineAudits[pos]["sheet_id"]
                                                .toString(),
                                            offlineAudits[pos]["sheet"],
                                            offlineAudits[pos]["sheet_name"],
                                            true,"")));*/
                              }

                              // Navigator.push(context,MaterialPageRoute(builder: (context)=>AuditFormScreen()));
                            },
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: 0, right: 8, top: 8, bottom: 5),
                                decoration: BoxDecoration(
                                    color: AppTheme.themeColor,
                                    borderRadius: BorderRadius.circular(5)),
                                height: 45,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text('UPDATE & SUBMIT',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
      ),
    ]));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchLocalData();
  }

  fetchLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("answer_list");
    if (data != null) {
      List<dynamic> list2 = jsonDecode(data);
      print("The LENGTH of ");
      print(list2.length);
      offlineAudits = list2;

      log(offlineAudits.toString());

      setState(() {});
    }
  }
}
