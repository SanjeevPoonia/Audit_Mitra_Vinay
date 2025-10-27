
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:intl/intl.dart';
import 'package:qaudit_tata_flutter/utils/app_theme.dart';
import 'package:qaudit_tata_flutter/view/audit_form_screen.dart';
import 'package:qaudit_tata_flutter/view/edit_audit_form_screen.dart';
import 'package:qaudit_tata_flutter/view/zoom_scaffold.dart' as MEN;

import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../network/api_helper.dart';
import '../network/loader.dart';
import '../utils/app_modal.dart';
import 'audit_details_screen.dart';
import 'menu_screen.dart';

class SubmitAuditListScreen extends StatefulWidget
{
  SubmitAuditState createState()=>SubmitAuditState();
}

class SubmitAuditState extends State<SubmitAuditListScreen> with TickerProviderStateMixin
{
  int selectedIndex = 0;
  MEN.MenuController? menuController;
  final ZoomDrawerController controller = ZoomDrawerController();
  bool isLoading=false;
  List<dynamic> arrSubmitAuditList=[];
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(
        body:  Column(
          children: [

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
                    Text("Submitted Audits",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        )),
                    Container(width: 15)
                  ],
                ),
              ),
            ),


            Expanded(
                child:
                isLoading?

                Center(
                  child: Loader(),
                ):

                arrSubmitAuditList.length==0?


                Center(
                  child: Text("No Audits found!"),
                ):

                RefreshIndicator(
                  onRefresh: _pullRefresh,
                  child: ListView.builder(
                      itemCount: arrSubmitAuditList.length,
                      padding: EdgeInsets.only(top: 0),
                      itemBuilder: (BuildContext context,int pos)
                      {
                        return Column(
                          children: [

                            GestureDetector(
                              onTap:(){
                              String auditID=arrSubmitAuditList[pos]["audit_id"].toString();
                              print("Hello $auditID");
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>AuditDetailsScreen(auditID)));
                        },
                              child: Card(
                                color: Colors.white,
                                shadowColor: AppTheme.themeColor,
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                elevation: 2,
                                shape:RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7)
                                ),
                                child: Container(

                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(7)
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [


                                      arrSubmitAuditList[pos]['agency_name']==null?Container():



                                      Text(arrSubmitAuditList[pos]['agency_name']??"",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.grey,
                                          )),

                                      SizedBox(height: 10),

                                      Row(
                                        children: [

                                          Text("Audit Type:",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                              )),

                                          SizedBox(width: 10),

                                          Text(arrSubmitAuditList[pos]['audit_type'],
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

                                          Text("Product Name:",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                              )),

                                          SizedBox(width: 10),

                                          Text(arrSubmitAuditList[pos]['product'],
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

                                          Text("Auditor Name:",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                              )),

                                          SizedBox(width: 10),

                                          Text(arrSubmitAuditList[pos]['auditor_name'],
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

                                          Text("Audit ID:",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                              )),

                                          SizedBox(width: 10),

                                          Text(


                                              "00"+
                                                  arrSubmitAuditList[pos]['audit_id'].toString(),
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

                                          Text("Visited Date Time:",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                              )),

                                          SizedBox(width: 10),

                                          Text(parseServerFormatDate(arrSubmitAuditList[pos]['audit_date'].toString()),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              )),




                                        ],
                                      ),



                                      SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(child: InkWell(
                                            onTap: () {
                                              String auditID=arrSubmitAuditList[pos]["audit_id"].toString();
                                              print("Hello $auditID");
                                              Navigator.push(context,MaterialPageRoute(builder: (context)=>AuditDetailsScreen(auditID)));
                                            },
                                            child: Container(
                                                margin:
                                                const EdgeInsets.only(left: 0,right: 8,top: 8,bottom: 5),
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    color: AppTheme.themeColor,
                                                    borderRadius: BorderRadius.circular(5)),
                                                height: 45,
                                                child: Center(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Image.asset("assets/eye_icon.png",width: 25,height: 25),
                                                        SizedBox(width: 10),
                                                        Text('View',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w600,
                                                                color: Colors.white)),

                                                      ],
                                                    )
                                                )),
                                          ),),
                                          Expanded(child: Container()),
                                        ],
                                      ),



                                    ],
                                  ),




                                ),
                              ),
                            ),

                            SizedBox(height: 12)

                          ],
                        );
                      }


                  ),
                ))




          ],
        ),
      ),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    submitAuditList(context);
    menuController = MEN.MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }
  submitAuditList(BuildContext context) async {
    setState(() {
      isLoading=true;
    });
    var data = {
      "user_id":AppModel.userID
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('submittedAuditList', data, context);
    var responseJSON = json.decode(response.body);
    if(responseJSON['data']!=null){
      arrSubmitAuditList = responseJSON['data'];
    }else{
      Toast.show("Something went wrong! Please try again later",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red
      );
    }

    print(responseJSON);

    setState(() {
      isLoading=false;
    });
    setState(() {

    });

  }

  String parseServerFormatDate(String serverDate) {
    var date = DateTime.parse(serverDate);
    final dateformat = DateFormat.yMMMd();
    final timeformat = DateFormat('hh:mm a');
    final clockString = dateformat.format(date);
    final clockString2 = timeformat.format(date);
    return clockString.toString() + " "+ clockString2.toString();
  }
  Future<void> _pullRefresh() async {

   submitAuditList(context);

  }
}

