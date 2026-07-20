
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:intl/intl.dart';
import 'package:qaudit_tata_flutter/utils/app_theme.dart';
import 'package:qaudit_tata_flutter/view/audit_form_screen.dart';
import 'package:qaudit_tata_flutter/view/edit_audit_form_screen.dart';
import 'package:qaudit_tata_flutter/view/sunstone_module/qa_assigned_audit_details.dart';
import 'package:qaudit_tata_flutter/view/zoom_scaffold.dart' as MEN;
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import '../../network/loader.dart';
import '../assigned_audit_details.dart';
class QaAssignedAuditsScreen extends StatefulWidget
{
  SavedAuditState createState()=>SavedAuditState();
}

class SavedAuditState extends State<QaAssignedAuditsScreen>
{
  int selectedIndex = 0;

  bool isLoading=false;
  List<dynamic> assignedAudits=[];
  @override
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(

        backgroundColor:
        const Color(0xFFF6F8FC),

        body: Column(

          children: [

            /// HEADER

            Container(

              padding: const EdgeInsets.only(
                top: 18,
                left: 18,
                right: 18,
                bottom: 24,
              ),

              decoration: const BoxDecoration(

                gradient:
                LinearGradient(

                  colors: [

                    Color(0xFF5B5FEF),
                    Color(0xFF7C3AED),
                  ],
                ),

                borderRadius:
                BorderRadius.only(

                  bottomLeft:
                  Radius.circular(30),

                  bottomRight:
                  Radius.circular(30),
                ),
              ),

              child: Row(

                children: [

                  GestureDetector(

                    onTap: (){
                      Navigator.pop(context);
                    },

                    child: Container(

                      padding:
                      const EdgeInsets.all(
                          10),

                      decoration:
                      BoxDecoration(

                        color:
                        Colors.white
                            .withOpacity(
                            .2),

                        borderRadius:
                        BorderRadius.circular(
                            14),
                      ),

                      child: const Icon(

                        Icons.arrow_back,

                        color:
                        Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(
                      width:16),

                  const Expanded(

                    child: Text(

                      "Assigned Audits",

                      style:
                      TextStyle(

                        fontSize:22,

                        fontWeight:
                        FontWeight.bold,

                        color:
                        Colors.white,
                      ),
                    ),
                  ),

                  Container(

                    padding:
                    const EdgeInsets.symmetric(

                      horizontal:12,
                      vertical:8,
                    ),

                    decoration:
                    BoxDecoration(

                      color:
                      Colors.white
                          .withOpacity(
                          .2),

                      borderRadius:
                      BorderRadius.circular(
                          20),
                    ),

                    child: Text(

                      assignedAudits
                          .length
                          .toString(),

                      style:
                      const TextStyle(

                        color:
                        Colors.white,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(
                height:12),

            Expanded(

              child:

              isLoading

                  ?

              Center(
                child: Loader(),
              )

                  :

              assignedAudits.isEmpty

                  ?

              _emptyWidget()

                  :

              ListView.builder(

                itemCount:
                assignedAudits.length,

                padding:
                const EdgeInsets.symmetric(
                  horizontal:14,
                  vertical:5,
                ),

                itemBuilder:
                    (context,pos){

                  var audit=
                  assignedAudits[pos];

                  return Container(

                    margin:
                    const EdgeInsets.only(
                        bottom:16),

                    padding:
                    const EdgeInsets.all(
                        16),

                    decoration:
                    BoxDecoration(

                      color:
                      Colors.white,

                      borderRadius:
                      BorderRadius.circular(
                          24),

                      boxShadow:[

                        BoxShadow(

                          color:
                          Colors.black
                              .withOpacity(
                              .05),

                          blurRadius:15,

                          offset:
                          const Offset(
                              0,5),
                        )
                      ],
                    ),

                    child: Column(

                      children: [

                        Row(

                          children: [

                            Container(

                              height:55,
                              width:55,

                              decoration:
                              BoxDecoration(

                                gradient:
                                const LinearGradient(

                                  colors:[

                                    Color(
                                        0xFF5B5FEF),

                                    Color(
                                        0xFF7C3AED),
                                  ],
                                ),

                                borderRadius:
                                BorderRadius.circular(
                                    16),
                              ),

                              child:
                              const Icon(

                                Icons.assignment,

                                color:
                                Colors.white,
                              ),
                            ),

                            const SizedBox(
                                width:14),

                            Expanded(

                              child: Column(

                                crossAxisAlignment:
                                CrossAxisAlignment.start,

                                children: [

                                  Text(

                                    audit["final_agency_name"]
                                        ??
                                        "NA",

                                    maxLines:1,

                                    overflow:
                                    TextOverflow
                                        .ellipsis,

                                    style:
                                    const TextStyle(

                                      fontSize:17,

                                      fontWeight:
                                      FontWeight
                                          .w700,
                                    ),
                                  ),

                                  const SizedBox(
                                      height:5),

                                  Text(

                                    audit["product"]
                                        ??
                                        "",

                                    style:
                                    TextStyle(

                                      color:
                                      Colors.grey
                                          .shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                            height:18),

                        Row(

                          children: [

                            Expanded(

                              child:
                              _infoBox(
                                Icons.location_on,
                                "Location",
                                audit[
                                "location"]
                                    ??
                                    "NA",
                              ),
                            ),

                            const SizedBox(
                                width:10),

                            Expanded(

                              child:
                              _infoBox(
                                Icons.person,
                                "Auditor",
                                audit[
                                "auditor_name"]
                                    ??
                                    "NA",
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                            height:12),

                        _infoBox(

                          Icons.email,

                          "Email",

                          audit[
                          "auditor_email"]
                              ??
                              "NA",
                        ),

                        const SizedBox(
                            height:18),

                        SizedBox(

                          width:
                          double.infinity,

                          height:50,

                          child:
                          ElevatedButton.icon(

                            style:
                            ElevatedButton
                                .styleFrom(

                              elevation:0,

                              backgroundColor:
                              const Color(
                                  0xFF5B5FEF),

                              shape:
                              RoundedRectangleBorder(

                                borderRadius:
                                BorderRadius.circular(
                                    16),
                              ),
                            ),

                            onPressed:(){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>QAAssignedAuditDetails(assignedAudits[pos]["id"].toString())));
                            },

                            icon:
                            const Icon(
                              Icons.visibility,
                              color:
                              Colors.white,
                            ),

                            label:
                            const Text(

                              "View Details",

                              style:
                              TextStyle(

                                color:
                                Colors.white,

                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _infoBox(
      IconData icon,
      String title,
      String value){

    return Container(

      padding:
      const EdgeInsets.all(12),

      decoration:
      BoxDecoration(

        color:
        const Color(
            0xFFF8FAFC),

        borderRadius:
        BorderRadius.circular(
            16),
      ),

      child: Row(

        children: [

          Icon(
            icon,
            size:18,
            color:
            const Color(
                0xFF5B5FEF),
          ),

          const SizedBox(
              width:8),

          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(

                  title,

                  style:
                  TextStyle(

                    fontSize:11,

                    color:
                    Colors.grey
                        .shade600,
                  ),
                ),

                Text(

                  value,

                  maxLines:1,

                  overflow:
                  TextOverflow
                      .ellipsis,

                  style:
                  const TextStyle(

                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _emptyWidget(){

    return Center(

      child: Column(

        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [

          Icon(
            Icons.assignment_outlined,
            size:80,
            color: Colors.grey,
          ),

          SizedBox(height:16),

          Text(

            "No Audits Found",

            style:
            TextStyle(

              fontSize:18,

              fontWeight:
              FontWeight.bold,
            ),
          ),
        ],
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
    var response = await helper.postAPIWithHeader('v2/auditor_assign_case_list', data, context);
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

