

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

class AuditAgencyScreen extends StatefulWidget
{
  List<dynamic> trendList=[];
  AuditAgencyScreen(this.trendList);
 
  ArtifactState createState()=>ArtifactState();
}

class ArtifactState extends State<AuditAgencyScreen>
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
                          child: Text("Audit Agency",
                              style: TextStyle(
                                  fontSize: 15,
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
            Expanded(child:ListView.builder(
                itemCount: widget.trendList.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context,int pos)
            {
              return Column(
                children: [

                  Container(
                    padding: const EdgeInsets.all(7),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color(0xFFFDFDFD),
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, 2.0),
                          blurRadius: 4.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child:Column(
                      children: [



                        SizedBox(height: 5),

                        Row(
                          children: [
                            SizedBox(width: 3),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Agency Name",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF868686))),
                                SizedBox(height: 2),
                                Text(widget.trendList[pos]["audit_agency_name"],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black)),



                              ],
                            ),


                            /*      Spacer(),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [




                              Text("Audit Score",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF868686))),

                              Text("86%",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF3ADA53))),

                            ],
                          ),*/
                            SizedBox(width: 3),
                          ],
                        ),


                        SizedBox(height: 15),

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          height: 36,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Color(0xFF21317D).withOpacity(0.58)
                          ),

                          child: Row(
                            children: [
                              Container(
                                width:130,
                                child: Text("Name",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white)),
                              ),

                              Expanded(child: Row(
                                children: [

                                  Expanded(child: Center(
                                    child: Text("Retail",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white)),
                                  ),flex: 1),


                                  Expanded(child: Center(
                                    child: Text("Cards",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white)),
                                  ),flex: 1),
                                  Expanded(child: Center(
                                    child: Text("R+C",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white)),
                                  ),flex: 1),

                                  Expanded(child: Center(
                                    child: Text("Total",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white)),
                                  ),flex: 1),

                                ],
                              ))




                            ],
                          ),

                        ),

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          height: 36,


                          child: Row(
                            children: [
                              Container(
                                width:130,
                                child: Text("Assigned Agency",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF21317D))),
                              ),

                              Expanded(child: Row(
                                children: [

                                  Expanded(child: Center(
                                    child: Text(widget.trendList[pos].toString().contains("assign_retail_count")?widget.trendList[pos]["assign_retail_count"].toString():"0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ),flex: 1),


                                  Expanded(child: Center(
                                    child: Text(widget.trendList[pos].toString().contains("assign_card_count")?widget.trendList[pos]["assign_card_count"].toString():"0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ),flex: 1),
                                  Expanded(child: Center(
                                    child: Text(widget.trendList[pos].toString().contains("assign_retail_card_count")?widget.trendList[pos]["assign_retail_card_count"].toString():"0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ),flex: 1),

                                  Expanded(child: Center(
                                    child: Text(widget.trendList[pos].toString().contains("total_assign_count")?widget.trendList[pos]["total_assign_count"].toString():"0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ),flex: 1),

                                ],
                              ))




                            ],
                          ),

                        ),


                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          height: 36,


                          child: Row(
                            children: [
                              Container(
                                width:130,
                                child: Text("Scheduled",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF21317D))),
                              ),

                              Expanded(child: Row(
                                children: [

                                  Expanded(child: Center(
                                    child: Text(widget.trendList[pos].toString().contains("scheduled_retail_count")?widget.trendList[pos]["scheduled_retail_count"].toString():"0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ),flex: 1),


                                  Expanded(child: Center(
                                    child: Text(widget.trendList[pos].toString().contains("scheduled_card_count")?widget.trendList[pos]["scheduled_card_count"].toString():"0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ),flex: 1),
                                  Expanded(child: Center(
                                    child: Text(widget.trendList[pos].toString().contains("scheduled_retail_card_count")?widget.trendList[pos]["scheduled_retail_card_count"].toString():"0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ),flex: 1),

                                  Expanded(child: Center(
                                    child: Text(widget.trendList[pos].toString().contains("total_scheduled_count")?widget.trendList[pos]["total_scheduled_count"].toString():"0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ),flex: 1),

                                ],
                              ))




                            ],
                          ),

                        ),

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          height: 36,


                          child: Row(
                            children: [
                              Container(
                                width:130,
                                child: Text("Audit Completed",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF21317D))),
                              ),

                              Expanded(child: Row(
                                children: [

                                  Expanded(child: Center(
                                    child: Text(widget.trendList[pos].toString().contains("complete_audits_retail")?widget.trendList[pos]["complete_audits_retail"].toString():"0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ),flex: 1),


                                  Expanded(child: Center(
                                    child: Text(widget.trendList[pos].toString().contains("complete_audits_card")?widget.trendList[pos]["complete_audits_card"].toString():"0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ),flex: 1),
                                  Expanded(child: Center(
                                    child: Text(widget.trendList[pos].toString().contains("complete_audits_retail_card")?widget.trendList[pos]["complete_audits_retail_card"].toString():"0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ),flex: 1),

                                  Expanded(child: Center(
                                    child: Text(widget.trendList[pos].toString().contains("complete_audit_total")?widget.trendList[pos]["complete_audit_total"].toString():"0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ),flex: 1),

                                ],
                              ))




                            ],
                          ),

                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          height: 36,


                          child: Row(
                            children: [
                              Container(
                                width:130,
                                child: Text("Sent For Closure",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF21317D))),
                              ),

                              Expanded(child: Row(
                                children: [

                                  Expanded(child: Center(
                                    child: Text(widget.trendList[pos].toString().contains("audits_sent_to_closer_retail")?widget.trendList[pos]["audits_sent_to_closer_retail"].toString():"0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ),flex: 1),


                                  Expanded(child: Center(
                                    child: Text(widget.trendList[pos].toString().contains("audits_sent_to_closer_card")?widget.trendList[pos]["audits_sent_to_closer_card"].toString():"0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ),flex: 1),
                                  Expanded(child: Center(
                                    child: Text(widget.trendList[pos].toString().contains("audits_sent_to_closer_retail_card")?widget.trendList[pos]["audits_sent_to_closer_retail_card"].toString():"0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ),flex: 1),

                                  Expanded(child: Center(
                                    child: Text(widget.trendList[pos].toString().contains("audits_sent_to_closer_total")?widget.trendList[pos]["audits_sent_to_closer_total"].toString():"0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ),flex: 1),

                                ],
                              ))




                            ],
                          ),

                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          height: 36,


                          child: Row(
                            children: [
                              Container(
                                width:130,
                                child: Text("Closure Completed",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF21317D))),
                              ),

                              Expanded(child: Row(
                                children: [

                                  Expanded(child: Center(
                                    child: Text(widget.trendList[pos].toString().contains("audits_closure_complete_retail")?widget.trendList[pos]["audits_closure_complete_retail"].toString():"0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ),flex: 1),


                                  Expanded(child: Center(
                                    child: Text(widget.trendList[pos].toString().contains("audits_closure_complete_card")?widget.trendList[pos]["audits_closure_complete_card"].toString():"0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ),flex: 1),
                                  Expanded(child: Center(
                                    child: Text(widget.trendList[pos].toString().contains("audits_closure_complete_retail_card")?widget.trendList[pos]["audits_closure_complete_retail_card"].toString():"0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ),flex: 1),

                                  Expanded(child: Center(
                                    child: Text(widget.trendList[pos].toString().contains("audits_closure_complete_total")?widget.trendList[pos]["audits_closure_complete_total"].toString():"0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ),flex: 1),

                                ],
                              ))




                            ],
                          ),

                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 13)
                  
                ],
              );
            }
            
            
            )

                
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