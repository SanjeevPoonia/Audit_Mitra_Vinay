

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qaudit_tata_flutter/network/api_dialog.dart';
import 'package:qaudit_tata_flutter/network/api_helper.dart';
import 'package:qaudit_tata_flutter/network/constants.dart';
import 'package:qaudit_tata_flutter/network/loader.dart';
import 'package:qaudit_tata_flutter/utils/app_modal.dart';
import 'package:qaudit_tata_flutter/utils/app_theme.dart';
import 'package:qaudit_tata_flutter/view/image_view_screen.dart';
import 'package:qaudit_tata_flutter/view/upload_artifact_screen.dart';
import 'package:toast/toast.dart';

class ManagerScreen extends StatefulWidget
{
  List<dynamic> trendList=[];
  ManagerScreen(this.trendList);
 
  ArtifactState createState()=>ArtifactState();
}

class ArtifactState extends State<ManagerScreen>
{
  List<dynamic> trendList=[];
  bool isLoading=false;
  int selectedTabTrend=1;


  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 62,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              color: const Color(0xFF21317D),
              child: Row(
                children: [
                  GestureDetector(
                      onTap:() async {
                      
                        Navigator.pop(context);
                      },

                      child: Icon(Icons.arrow_back_ios_new,color: Colors.white)),
                  const Expanded(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text("National Collection Manager",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ),
                      )),
                  /* const Icon(Icons.filter_alt_sharp, color: Colors.white, size: 32),
                const SizedBox(width: 5),*/

                ],
              ),
            ),

            SizedBox(height: 12),
            Expanded(child:   ListView.builder(
                itemCount:widget.trendList.length,
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context,int pos)

                {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Color(0xFFFDFDFD),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, 2.0),
                              blurRadius: 4.0,
                              spreadRadius: 1.0,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.trendList[pos]["manager_name"],
                                            style: TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black)),
                                        SizedBox(height: 5),
                                        Text("Collection Manager",
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF929292))),
                                      ],
                                    ),
                                  ),


                                  SizedBox(width: 10),
                                  Column(
                                    children: [
                                      Text(widget.trendList[pos]["audit_count"].toString(),
                                          style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black)),
                                      SizedBox(height: 5),
                                      Text("Audit Count",
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF929292))),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                            const SizedBox(height: 7),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              child: Divider(
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: [

                                  SizedBox(width:5),


                                  Expanded(
                                    flex:1,
                                    child: Text("Retail",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF21317D))),
                                  ),


                                  Expanded(
                                    flex:1,
                                    child: Column(
                                      children: [
                                        Text("Pending",
                                            style: TextStyle(
                                                fontSize: 11, color: Colors.black)),
                                        SizedBox(height: 5),
                                        Text(widget.trendList[pos]["retail_pending"].toString(),
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF52CEF5))),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    width:1,
                                    height:20,
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                  Expanded(
                                    flex:1,
                                    child: Column(
                                      children: [
                                        Text("Reject",
                                            style: TextStyle(
                                                fontSize: 11, color: Colors.black)),
                                        SizedBox(height: 5),
                                        Text(widget.trendList[pos]["retail_rejected"].toString(),
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red)),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    width:1,
                                    height:20,
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                  Expanded(
                                    flex:1,
                                    child: Column(
                                      children: [
                                        Text("Approved",
                                            style: TextStyle(
                                                fontSize: 11, color: Colors.black)),
                                        SizedBox(height: 5),
                                        Text(widget.trendList[pos]["retail_approved"].toString(),
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF3ADA53))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),


                            Container(
                              margin: const EdgeInsets.only(left: 50,right:15),
                              child: Divider(
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: [

                                  SizedBox(width:5),


                                  Expanded(
                                    flex:1,
                                    child: Text("Credit Card",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF21317D))),
                                  ),


                                  Expanded(
                                    flex:1,
                                    child: Column(
                                      children: [
                                        Text("Pending",
                                            style: TextStyle(
                                                fontSize: 11, color: Colors.black)),
                                        SizedBox(height: 5),
                                        Text(widget.trendList[pos]["credit_card_pending"].toString(),
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF52CEF5))),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    width:1,
                                    height:20,
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                  Expanded(
                                    flex:1,
                                    child: Column(
                                      children: [
                                        Text("Reject",
                                            style: TextStyle(
                                                fontSize: 11, color: Colors.black)),
                                        SizedBox(height: 5),
                                        Text(widget.trendList[pos]["credit_card_rejected"].toString(),
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red)),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    width:1,
                                    height:20,
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                  Expanded(
                                    flex:1,
                                    child: Column(
                                      children: [
                                        Text("Approved",
                                            style: TextStyle(
                                                fontSize: 11, color: Colors.black)),
                                        SizedBox(height: 5),
                                        Text(widget.trendList[pos]["credit_card_approved"].toString(),
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF3ADA53))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin: const EdgeInsets.only(left: 50,right:15),
                              child: Divider(
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ),

                            const SizedBox(height: 5),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: [

                                  SizedBox(width:5),


                                  Expanded(
                                    flex:1,
                                    child: Text("Retail + Credit Card",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF21317D))),
                                  ),


                                  Expanded(
                                    flex:1,
                                    child: Column(
                                      children: [
                                        Text("Pending",
                                            style: TextStyle(
                                                fontSize: 11, color: Colors.black)),
                                        SizedBox(height: 5),
                                        Text(widget.trendList[pos]["retail_card_pending"].toString(),
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF52CEF5))),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    width:1,
                                    height:20,
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                  Expanded(
                                    flex:1,
                                    child: Column(
                                      children: [
                                        Text("Reject",
                                            style: TextStyle(
                                                fontSize: 11, color: Colors.black)),
                                        SizedBox(height: 5),
                                        Text(widget.trendList[pos]["retail_card_rejected"].toString(),
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red)),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    width:1,
                                    height:20,
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                  Expanded(
                                    flex:1,
                                    child: Column(
                                      children: [
                                        Text("Approved",
                                            style: TextStyle(
                                                fontSize: 11, color: Colors.black)),
                                        SizedBox(height: 5),
                                        Text(widget.trendList[pos]["retail_card_approved"].toString(),
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF3ADA53))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),



                            Container(
                              margin: const EdgeInsets.only(left: 50,right:15),
                              child: Divider(
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ),


                            const SizedBox(height: 5),
                          ],
                        ),
                      ),

                      SizedBox(height: 17),


                    ],
                  );
                }


            ),

                
            )

          ],
        ),
      ),
    );
  }



@override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
  
}