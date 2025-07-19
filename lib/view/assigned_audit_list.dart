
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

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../network/loader.dart';
import '../utils/app_modal.dart';
import 'assigned_audit_details.dart';
import 'menu_screen.dart';

class AssignedAuditsScreen extends StatefulWidget
{
  SavedAuditState createState()=>SavedAuditState();
}

class SavedAuditState extends State<AssignedAuditsScreen>
{
  int selectedIndex = 0;

  bool isLoading=false;
  List<dynamic> assignedAudits=[];
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Column(
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
                    Text("Assigned Audits",
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

                assignedAudits.length==0?


                Center(
                  child: Text("No Audits found!"),
                ):

                ListView.builder(
                    itemCount: assignedAudits.length,
                    padding: EdgeInsets.only(top: 0),
                    itemBuilder: (BuildContext context,int pos)
                    {
                      return Column(
                        children: [

                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Card(
                              color: Colors.white,
                              shadowColor: AppTheme.themeColor,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              elevation: 3,
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

                                    assignedAudits[pos]['final_agency_name']==null?Container():

                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(assignedAudits[pos]['final_agency_name']??"",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF2A3663),
                                              )),
                                        ),


                                        // Icon(Icons.edit,color: AppTheme.themeColor)
                                      ],
                                    ),

                                    SizedBox(height: 10),

                                    Row(
                                      children: [

                                        Text("Product:",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                            )),

                                        SizedBox(width: 10),

                                        Text(assignedAudits[pos]['product'],
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

                                        Text("Location:",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                            )),

                                        SizedBox(width: 10),

                                        Text(assignedAudits[pos]['location'],
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

                                        Text(
                                            assignedAudits[pos]['auditor_name']==""?"NA":

                                            assignedAudits[pos]['auditor_name'],
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

                                        Text("Auditor Email:",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                            )),

                                        SizedBox(width: 10),

                                        Text(assignedAudits[pos]['auditor_email'].toString(),
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
                                            Navigator.push(context,MaterialPageRoute(builder: (context)=>AssignedAuditDetails(assignedAudits[pos]["id"].toString())));

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
                                                      Image.asset("assets/eye_icon.png",width: 20,height: 20),
                                                      SizedBox(width: 10),
                                                      Text('View Details',
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


                ))

          ],
        ),


      ),
    );
  }

  String parseServerFormatDate(String serverDate) {
    var date = DateTime.parse(serverDate);
    final dateformat = DateFormat.yMMMd();
    final timeformat = DateFormat('hh:mm a');
    final clockString = dateformat.format(date);
    final clockString2 = timeformat.format(date);
    return clockString.toString() + " "+ clockString2.toString();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    assignedAuditList(context);
  }

  assignedAuditList(BuildContext context) async {

    String? email= await MyUtils.getSharedPreferences("email");


    setState(() {
      isLoading=true;
    });
    var data = {
      "email":email==null?"":email.toString()
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('auditor_assign_case_list', data, context);
    var responseJSON = json.decode(response.body);
    assignedAudits = responseJSON['data'];
    setState(() {
      isLoading=false;
    });
    print(responseJSON);
/*    if (responseJSON['status'] == 1) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }*/


   // completedAuditList=responseJSON["data"];
    setState(() {

    });

  }
}

