
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:intl/intl.dart';
import 'package:qaudit_tata_flutter/utils/app_theme.dart';
import 'package:qaudit_tata_flutter/view/audit_form_screen.dart';
import 'package:qaudit_tata_flutter/view/audit_newform_screen.dart';
import 'package:qaudit_tata_flutter/view/edit_audit_form_screen.dart';
import 'package:qaudit_tata_flutter/view/sunstone_module/qa_main_auditform_screen.dart';
import 'package:qaudit_tata_flutter/view/zoom_scaffold.dart' as MEN;
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../../network/api_helper.dart';
import '../../network/loader.dart';
class QaSavedAuditListScreen extends StatefulWidget
{
  SavedAuditState createState()=>SavedAuditState();
}

class SavedAuditState extends State<QaSavedAuditListScreen> with TickerProviderStateMixin
{
  int selectedIndex = 0;

  bool isLoading=false;
  List<dynamic> arrSavedAuditList=[];
  @override
  @override
  Widget build(BuildContext context) {

    ToastContext().init(context);

    return SafeArea(
      child: Scaffold(

        backgroundColor:
        const Color(0xFFF5F7FB),

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

                    Color(0xFF4F46E5),
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

                  InkWell(

                    onTap: (){
                      Navigator.pop(context);
                    },

                    child: Container(

                      padding:
                      const EdgeInsets.all(10),

                      decoration:
                      BoxDecoration(

                        color:
                        Colors.white.withOpacity(
                            .15),

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

                  const SizedBox(width:15),

                  const Expanded(

                    child: Text(

                      "Saved Audits",

                      style: TextStyle(

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
                      Colors.white.withOpacity(
                          .15),

                      borderRadius:
                      BorderRadius.circular(
                          18),
                    ),

                    child: Text(

                      arrSavedAuditList
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

            const SizedBox(height:10),

            Expanded(

              child:

              isLoading

                  ?

               Center(
                child: Loader(),
              )

                  :

              arrSavedAuditList.isEmpty

                  ?

              _emptyWidget()

                  :

              RefreshIndicator(

                onRefresh:
                _pullRefresh,

                child:
                ListView.builder(

                  padding:
                  const EdgeInsets.symmetric(

                    horizontal:16,
                    vertical:5,
                  ),

                  itemCount:
                  arrSavedAuditList.length,

                  itemBuilder:
                      (context,pos){

                    var item=
                    arrSavedAuditList[pos];

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
                                .04),

                            blurRadius:18,

                            offset:
                            const Offset(
                                0,6),
                          )
                        ],
                      ),

                      child: Column(

                        children: [

                          Row(

                            children: [

                              Container(

                                height:58,
                                width:58,

                                decoration:
                                BoxDecoration(

                                  gradient:
                                  const LinearGradient(

                                    colors:[

                                      Color(
                                          0xFF4F46E5),

                                      Color(
                                          0xFF7C3AED),
                                    ],
                                  ),

                                  borderRadius:
                                  BorderRadius.circular(
                                      18),
                                ),

                                child:
                                const Icon(

                                  Icons.assignment,

                                  color:
                                  Colors.white,

                                  size:28,
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

                                      item[
                                      "agency_name"]
                                          ??
                                          "NA",

                                      style:
                                      const TextStyle(

                                        fontSize:17,

                                        fontWeight:
                                        FontWeight.w700,
                                      ),
                                    ),

                                    const SizedBox(
                                        height:6),

                                    Container(

                                      padding:
                                      const EdgeInsets.symmetric(

                                        horizontal:10,
                                        vertical:6,
                                      ),

                                      decoration:
                                      BoxDecoration(

                                        color:
                                        Colors.orange
                                            .withOpacity(
                                            .1),

                                        borderRadius:
                                        BorderRadius.circular(
                                            20),
                                      ),

                                      child: Text(

                                        item[
                                        "audit_type"]
                                            ??
                                            "",

                                        style:
                                        const TextStyle(

                                          color:
                                          Colors.orange,

                                          fontWeight:
                                          FontWeight.w600,

                                          fontSize:12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                              height:18),

                          _infoTile(
                            Icons.inventory,
                            "Product",
                            item["product"]
                                ?? "NA",
                          ),

                          const SizedBox(
                              height:10),

                          _infoTile(
                            Icons.person,
                            "Auditor",
                            item["auditor_name"]
                                ?? "NA",
                          ),

                          const SizedBox(
                              height:10),

                          _infoTile(
                            Icons.numbers,
                            "Audit ID",
                            "00${item["audit_id"]}",
                          ),

                          const SizedBox(
                              height:10),

                          _infoTile(
                            Icons.calendar_month,
                            "Visited",
                            parseServerFormatDate(
                                item["audit_date"]
                                    .toString()),
                          ),

                          const SizedBox(
                              height:18),

                          SizedBox(

                            width:
                            double.infinity,

                            height:50,

                            child:
                            ElevatedButton.icon(

                              icon:
                              const Icon(
                                Icons.edit,
                                color:
                                Colors.white,
                              ),

                              label:
                              const Text(

                                "Edit Audit",

                                style:
                                TextStyle(

                                  fontWeight:
                                  FontWeight.bold,

                                  color:
                                  Colors.white,
                                ),
                              ),

                              style:
                              ElevatedButton
                                  .styleFrom(

                                elevation:0,

                                backgroundColor:
                                const Color(
                                    0xFF4F46E5),

                                shape:
                                RoundedRectangleBorder(

                                  borderRadius:
                                  BorderRadius.circular(
                                      16),
                                ),
                              ),

                              onPressed:(){

                                Navigator.push(

                                  context,

                                  MaterialPageRoute(

                                    builder:
                                        (context)=>

                                        QaMainAuditFormScreen(

                                          item[
                                          "qm_sheet_id"]
                                              .toString(),

                                          {},

                                          "Collection | Agency",

                                          true,

                                          item[
                                          "audit_id"]
                                              .toString(),

                                          "",
                                        ),
                                  ),

                                ).then((_){

                                  getDataFromServer();

                                });
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _infoTile(
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

            color:
            const Color(
                0xFF4F46E5),

            size:20,
          ),

          const SizedBox(
              width:10),

          Text(

            "$title : ",

            style:
            TextStyle(

              color:
              Colors.grey.shade600,

              fontWeight:
              FontWeight.w500,
            ),
          ),

          Expanded(

            child: Text(

              value,

              style:
              const TextStyle(

                fontWeight:
                FontWeight.w600,
              ),
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

            size:90,

            color:
            Colors.grey.shade400,
          ),

          const SizedBox(
              height:16),

          const Text(

            "No Saved Audits",

            style:
            TextStyle(

              fontSize:18,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(
              height:6),

          Text(

            "Your saved audits will appear here",

            style:
            TextStyle(

              color:
              Colors.grey.shade600,
            ),
          )
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
    getDataFromServer();
  }

  getDataFromServer(){
    savedAuditList(context);
  }

  savedAuditList(BuildContext context) async {
    setState(() {
      isLoading=true;
    });
    var data = {
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('v2/savedAuditList', data, context);
    var responseJSON = json.decode(response.body);
    if(responseJSON['data']!=null){
      arrSavedAuditList = responseJSON['data'];
    }else{
      Toast.show("Something went wrong! Please try again later",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red
      );
    }

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


  Future<void> _pullRefresh() async {

    savedAuditList(context);

  }
}

