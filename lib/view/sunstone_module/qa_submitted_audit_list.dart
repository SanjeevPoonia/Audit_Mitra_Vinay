import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:intl/intl.dart';
import 'package:qaudit_tata_flutter/network/api_dialog.dart';
import 'package:qaudit_tata_flutter/utils/app_theme.dart';
import 'package:qaudit_tata_flutter/view/audit_form_screen.dart';
import 'package:qaudit_tata_flutter/view/edit_audit_form_screen.dart';
import 'package:qaudit_tata_flutter/view/sunstone_module/qa_submitted_audit_details.dart';
import 'package:qaudit_tata_flutter/view/zoom_scaffold.dart' as MEN;
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../../network/api_helper.dart';
import '../../network/loader.dart';
import '../../utils/app_modal.dart';

class QaSubmitAuditListScreen extends StatefulWidget
{
  SubmitAuditState createState()=>SubmitAuditState();
}

class SubmitAuditState extends State<QaSubmitAuditListScreen> with TickerProviderStateMixin
{
  int selectedIndex = 0;
  MEN.MenuController? menuController;
  final ZoomDrawerController controller = ZoomDrawerController();
  bool isLoading=false;
  List<dynamic> arrSubmitAuditList=[];
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
                        Colors.white.withOpacity(.15),

                        borderRadius:
                        BorderRadius.circular(14),
                      ),

                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(width:15),

                  const Expanded(

                    child: Text(

                      "Submitted Audits",

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
                      Colors.white.withOpacity(.15),

                      borderRadius:
                      BorderRadius.circular(18),
                    ),

                    child: Text(

                      arrSubmitAuditList
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

              arrSubmitAuditList.isEmpty

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
                    vertical:6,
                  ),

                  itemCount:
                  arrSubmitAuditList.length,

                  itemBuilder:
                      (context,pos){

                    var item=
                    arrSubmitAuditList[pos];

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
                                .withOpacity(.04),

                            blurRadius:18,

                            offset:
                            const Offset(0,6),
                          )
                        ],
                      ),

                      child: Column(

                        children: [

                          Row(

                            children: [

                              Container(

                                width:58,
                                height:58,

                                decoration:
                                BoxDecoration(

                                  gradient:
                                  const LinearGradient(

                                    colors:[

                                      Color(
                                          0xFF10B981),

                                      Color(
                                          0xFF059669),
                                    ],
                                  ),

                                  borderRadius:
                                  BorderRadius.circular(
                                      18),
                                ),

                                child:
                                const Icon(

                                  Icons.task_alt,

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
                                        Colors.green
                                            .withOpacity(
                                            .1),

                                        borderRadius:
                                        BorderRadius.circular(
                                            20),
                                      ),

                                      child: const Text(

                                        "Submitted",

                                        style:
                                        TextStyle(

                                          color:
                                          Colors.green,

                                          fontWeight:
                                          FontWeight.w600,

                                          fontSize:12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),

                          const SizedBox(
                              height:18),

                          _infoTile(
                            Icons.category,
                            "Audit Type",
                            item["audit_type"] ?? "NA",
                          ),

                          const SizedBox(
                              height:10),

                          _infoTile(
                            Icons.inventory,
                            "Product",
                            item["product"] ?? "NA",
                          ),

                          const SizedBox(
                              height:10),

                          _infoTile(
                            Icons.person,
                            "Auditor",
                            item["auditor_name"] ?? "NA",
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
                                Icons.visibility,
                                color:
                                Colors.white,
                              ),

                              label:
                              const Text(

                                "View Details",

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
                                    0xFF10B981),

                                shape:
                                RoundedRectangleBorder(

                                  borderRadius:
                                  BorderRadius.circular(
                                      16),
                                ),
                              ),

                              onPressed:(){

                                String auditID =
                                item["audit_id"]
                                    .toString();

                                SubmittedAuditDetails(
                                    context,
                                    auditID
                                );
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
            size:20,
            color:
            const Color(
                0xFF10B981),
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
            Icons.assignment_turned_in_outlined,
            size:90,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height:16),

          const Text(

            "No Submitted Audits",

            style: TextStyle(

              fontSize:18,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height:6),

          Text(

            "Submitted audits will appear here",

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
    var response = await helper.postAPIWithHeader('v2/submittedAuditList', data, context);
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

  SubmittedAuditDetails(
      BuildContext context,
      String auditId,
      ) async {

    APIDialog.showAlertDialog(
      context,
      "Please Wait...",
    );

    var data = {
      "audit_id": auditId,
    };

    print(data);

    ApiBaseHelper helper =
    ApiBaseHelper();

    var response =
    await helper.postAPIWithHeader(
      'v2/submitted_audit_data',
      data,
      context,
    );

    var responseJSON =
    json.decode(response.body);

    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }

    print(responseJSON);

    if (responseJSON['status'] != null &&
        responseJSON['status']) {

      /// NAVIGATE TO DETAILS SCREEN

      Navigator.push(

        context,

        MaterialPageRoute(

          builder: (context) =>
              SubmittedAuditViewScreen(

                auditData:
                Map<String, dynamic>.from(
                  responseJSON,
                ),
              ),
        ),
      );

    } else {

      Toast.show(
        responseJSON['message']
            ?.toString() ??
            "Something went wrong! Please try again later",

        duration: Toast.lengthLong,

        gravity: Toast.bottom,

        backgroundColor: Colors.red,
      );
    }
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

