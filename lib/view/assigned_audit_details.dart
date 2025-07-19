
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qaudit_tata_flutter/network/loader.dart';

import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import '../widgets/dropdown_widget.dart';

class AssignedAuditDetails extends StatefulWidget
{
  final String id;
  AssignedAuditDetails(this.id);
  AuditState createState()=>AuditState();
}

class AuditState extends State<AssignedAuditDetails>
{
  bool isLoading=false;
  Map<String,dynamic> auditData={};
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
                    Text("Audit Details",
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
              child:
              isLoading?

                  Center(
                    child: Loader(),
                  ):


              ListView(
                padding: EdgeInsets.zero,
                children: [

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        border: Border.all(
                            color: Colors.black, width: 0.7)),

                    child: Column(
                      children: [

                        Container(
                          height: 46,
                          color: AppTheme.themeColor,
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              Text("Auditor Details",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                        ),



                        SizedBox(height: 10),



                        DropDownWidget3("Auditor Name", auditData["auditor_name"]??""),


                        SizedBox(height: 12),

                        DropDownWidget3("Auditor Email ID", auditData["auditor_email"]??""),

                        SizedBox(height: 12),

                        DropDownWidget3("Audit Date", auditData["audit_date"]??"NA"),
                        SizedBox(height: 12),
                      ],
                    ),


                  ),


                  SizedBox(height: 12),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        border: Border.all(
                            color: Colors.black, width: 0.7)),

                    child: Column(
                      children: [

                        Container(
                          height: 46,
                          color: AppTheme.themeColor,
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              Text("Collection | Agency Details",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                        ),



                        SizedBox(height: 10),



                        DropDownWidget3("Agency Name", auditData["final_agency_name"]??""),


                        SizedBox(height: 12),

                        DropDownWidget3("Type of Agency", auditData["type_of_agency"]??""),

                        SizedBox(height: 12),

                        DropDownWidget3("Sub Product", auditData["sub_product"]??"NA"),
                        SizedBox(height: 12),



                        DropDownWidget3("Product", auditData["product"]??"NA"),
                        SizedBox(height: 12),

                        DropDownWidget3("Location", auditData["location"]??"NA"),
                        SizedBox(height: 12),


                        DropDownWidget3("State", auditData["state"]??"NA"),
                        SizedBox(height: 12),





                        DropDownWidget3("Sub Product", auditData["sub_product"]??"NA"),
                        SizedBox(height: 12),



                        DropDownWidget3("Product", auditData["product"]??"NA"),
                        SizedBox(height: 12),

                        DropDownWidget3("Location", auditData["location"]??"NA"),
                        SizedBox(height: 12),


                        DropDownWidget3("State", auditData["state"]??"NA"),
                        SizedBox(height: 12),

                        DropDownWidget3("Region", auditData["region"]??"NA"),
                        SizedBox(height: 12),



                        DropDownWidget3("Process Review Agency", auditData["process_review_agency"]??"NA"),
                        SizedBox(height: 12),

                        DropDownWidget3("Process Review Agency ID", auditData["process_review_agency_id"]??"NA"),
                        SizedBox(height: 12),


                        DropDownWidget3("Process Review Period", auditData["process_review_period"]??"NA"),
                        SizedBox(height: 12),

                        DropDownWidget3("Agency Address", auditData["agency_address"]??"NA"),
                        SizedBox(height: 12),



                        DropDownWidget3("Agency Contact", auditData["contact"]??"NA"),
                        SizedBox(height: 12),

                        DropDownWidget3("Agency Email", auditData["agency_email"]??"NA"),
                        SizedBox(height: 12),

                      ],
                    ),


                  ),

                  SizedBox(height: 20),


                ],
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
    assignedAuditDetails(context);
  }

  assignedAuditDetails(BuildContext context) async {



    setState(() {
      isLoading=true;
    });
    var data = {
      "assign_id":widget.id
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('auditor_assign_case_details', data, context);
    var responseJSON = json.decode(response.body);
    auditData = responseJSON['data'];
    setState(() {
      isLoading=false;
    });
    print(responseJSON);
    setState(() {

    });

  }
}
