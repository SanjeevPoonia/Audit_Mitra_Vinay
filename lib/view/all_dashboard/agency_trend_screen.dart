

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

class AgencyTrendScreen extends StatefulWidget
{
  List<dynamic> trendList=[];
  AgencyTrendScreen(this.trendList);
 
  ArtifactState createState()=>ArtifactState();
}

class ArtifactState extends State<AgencyTrendScreen>
{
  List<dynamic> trendList=[];
  bool isLoading=false;
  List<int> selectedTabTrendList=[];


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
                          child: Text("Collection Agency Trend",
                              style: TextStyle(
                                  fontSize: 14,
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
                itemCount: trendList.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context,int pos)
            {
              return Column(
                children: [

                  Container(
                    padding: const EdgeInsets.all(7),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, 2.0),
                          blurRadius: 4.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 10),


                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(trendList[pos]["agency_name"],
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black)),
                                  Text(trendList[pos]["location"],
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF929292))),

                                ],
                              ),
                            ),


                            Column(
                              children: [
                                Text("Score:",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF929292))),


                                Text(trendList[pos]["average_score_percentage"].toStringAsFixed(2)+"%",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green)),
                              ],
                            )





                          ],
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text("Collection Manager",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF929292))),

                                    SizedBox(height: 5),
                                    Text(trendList[pos]["collection_manager_name"],
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black)),


                                  ],
                                ),
                              ),

                              SizedBox(width: 10),
                              Column(
                                children: [

                                  Text("Audit Count",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF929292))),
                                  SizedBox(height: 5),
                                  Text(trendList[pos]["audit_count"].toString(),
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black)),


                                ],
                              ),

                            ],
                          ),
                        ),



                        SizedBox(height: 15),


                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text("Overall",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF21317D))),
                        ),
                        SizedBox(height: 5),


                        Container(
                          height: 40,
                          child: ListView.builder(
                              itemCount: trendList[pos]["six_month_data"].length,
                              scrollDirection: Axis.horizontal,


                              itemBuilder: (BuildContext context,int posh)

                              {
                                return Row(
                                  children: [
                                    /*  Color(0xFF3ADA53)
                               Color(0xFF52CEF5)*/
                                    Container(
                                      width: 50,
                                      height: 37,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          color:
                                          trendList[pos]["six_month_data"][posh]["average_score"]==0?

                                          Color(0xFF6C757D):

                                          trendList[pos]["six_month_data"][posh]["average_score"]<50?

                                          Color(0xFFF7476B):

                                          trendList[pos]["six_month_data"][posh]["average_score"]>50 &&  trendList[pos]["six_month_data"][posh]["average_score"]<70?
                                          Color(0xFF52CEF5):
                                          Color(0xFF3ADA53)


                                      ),
                                      child: Center(
                                        child: Text(trendList[pos]["six_month_data"][posh]["average_score"].toStringAsFixed(0)+"%",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                      ),
                                    ),


                                    SizedBox(width: 8),


                                  ],
                                );
                              }


                          ),
                        ),

                        const SizedBox(height: 5),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          child: Divider(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        const SizedBox(height: 12),


                        Row(
                          children: [
                            GestureDetector(
                              onTap:(){

                                setState(() {
                                  selectedTabTrendList[pos]=1;
                                });
                              },
                              child: Container(
                                  height:38,
                                  padding: EdgeInsets.symmetric(horizontal: 22),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color:selectedTabTrendList[pos]==1?Color(0xFF21317D):Color(0xFFE7E9F1)
                                  ),

                                  child:Center(
                                    child:Text("Retail",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:selectedTabTrendList[pos]==1? Colors.white:Colors.black)),
                                  )

                              ),
                            ),


                            SizedBox(width: 10),

                            GestureDetector(
                              onTap:(){

                                setState(() {
                                  selectedTabTrendList[pos]=2;
                                });
                              },
                              child: Container(
                                  height:38,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color:selectedTabTrendList[pos]==2?Color(0xFF21317D):Color(0xFFE7E9F1)
                                  ),

                                  child:Center(
                                    child:Text("Credit Card",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: selectedTabTrendList[pos]==2? Colors.white:Colors.black)),
                                  )

                              ),
                            ),


                            SizedBox(width: 10),

                            GestureDetector(
                              onTap:(){

                                setState(() {
                                  selectedTabTrendList[pos]=3;
                                });
                              },
                              child: Container(
                                  height:38,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color:selectedTabTrendList[pos]==3?Color(0xFF21317D):Color(0xFFE7E9F1)
                                  ),

                                  child:Center(
                                    child:Text("Retail + Credit Card",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: selectedTabTrendList[pos]==3? Colors.white:Colors.black)),
                                  )

                              ),
                            ),




                          ],
                        ),

                        const SizedBox(height: 20),


                        selectedTabTrendList[pos]==1?

                        Container(
                          height: 40,
                          child: ListView.builder(
                              itemCount: trendList[pos]["six_month_data"].length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context,int posh)

                              {
                                return Row(
                                  children: [
                                    /*  Color(0xFF3ADA53)
                               Color(0xFF52CEF5)*/
                                    Container(
                                      width: 50,
                                      height: 37,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          color:
                                          trendList[pos]["six_month_data"][posh]["retail_average_score_percentage"]==0?

                                          Color(0xFF6C757D):

                                          trendList[pos]["six_month_data"][posh]["retail_average_score_percentage"]<50?

                                          Color(0xFFF7476B):

                                          trendList[pos]["six_month_data"][posh]["retail_average_score_percentage"]>50 &&  trendList[pos]["six_month_data"][posh]["retail_average_score_percentage"]<70?
                                          Color(0xFF52CEF5):
                                          Color(0xFF3ADA53)


                                      ),
                                      child: Center(
                                        child: Text(trendList[pos]["six_month_data"][posh]["retail_average_score_percentage"].toStringAsFixed(0)+"%",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                      ),
                                    ),


                                    SizedBox(width: 8),


                                  ],
                                );
                              }


                          ),
                        ):

                        selectedTabTrendList[pos]==2? Container(
                          height: 40,
                          child: ListView.builder(
                              itemCount: trendList[pos]["six_month_data"].length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context,int posh)

                              {
                                return Row(
                                  children: [
                                    /*  Color(0xFF3ADA53)
                               Color(0xFF52CEF5)*/
                                    Container(
                                      width: 50,
                                      height: 37,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          color:
                                          trendList[pos]["six_month_data"][posh]["card_average_score_percentage"]==0?

                                          Color(0xFF6C757D):

                                          trendList[pos]["six_month_data"][posh]["card_average_score_percentage"]<50?

                                          Color(0xFFF7476B):

                                          trendList[pos]["six_month_data"][posh]["card_average_score_percentage"]>=50 &&  trendList[pos]["six_month_data"][posh]["card_average_score_percentage"]<=70?
                                          Color(0xFF52CEF5):
                                          Color(0xFF3ADA53)


                                      ),
                                      child: Center(
                                        child: Text(trendList[pos]["six_month_data"][posh]["card_average_score_percentage"].toStringAsFixed(0)+"%",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                      ),
                                    ),


                                    SizedBox(width: 8),


                                  ],
                                );
                              }


                          ),
                        ):
                        Container(
                          height: 40,
                          child: ListView.builder(
                              itemCount: trendList[pos]["six_month_data"].length,
                              scrollDirection: Axis.horizontal,

                              itemBuilder: (BuildContext context,int posh)

                              {
                                return Row(
                                  children: [
                                    /*  Color(0xFF3ADA53)
                               Color(0xFF52CEF5)*/
                                    Container(
                                      width: 50,
                                      height: 37,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          color:
                                          trendList[pos]["six_month_data"][posh]["retails_card_average_score_percentage"]==0?

                                          Color(0xFF6C757D):

                                          trendList[pos]["six_month_data"][posh]["retails_card_average_score_percentage"]<50?

                                          Color(0xFFF7476B):

                                          trendList[pos]["six_month_data"][posh]["retails_card_average_score_percentage"]>=50 &&  trendList[pos]["six_month_data"][posh]["retails_card_average_score_percentage"]<=70?
                                          Color(0xFF52CEF5):
                                          Color(0xFF3ADA53)


                                      ),
                                      child: Center(
                                        child: Text(trendList[pos]["six_month_data"][posh]["retails_card_average_score_percentage"].toStringAsFixed(0)+"%",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                      ),
                                    ),


                                    SizedBox(width: 8),


                                  ],
                                );
                              }


                          ),
                        ),




                        const SizedBox(height: 12),
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
    trendList=widget.trendList;

    for(int i=0;i<trendList.length;i++)
      {
        selectedTabTrendList.add(1);
      }


    
  }
  
}