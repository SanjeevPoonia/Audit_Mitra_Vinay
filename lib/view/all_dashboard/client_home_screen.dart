import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:qaudit_tata_flutter/network/api_dialog.dart';
import 'package:qaudit_tata_flutter/network/api_helper.dart';
import 'package:qaudit_tata_flutter/utils/app_modal.dart';
import 'package:qaudit_tata_flutter/utils/app_theme.dart';
import 'package:qaudit_tata_flutter/view/all_dashboard/manager_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:toast/toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../network/loader.dart';
import '../../widgets/chart_repo/app_colors.dart';
import '../../widgets/dashboard_widget.dart';
import '../login_screen.dart';
import 'agency_trend_screen.dart';
import 'audit_agency_screen.dart';

class ClientHomeScreen extends StatefulWidget {
  LandingState createState() => LandingState();
}

class LandingState extends State<ClientHomeScreen> {
  int selectedIndex = 0;
  bool isLoading = false;
  bool overAllEnabled = true;
  String globalProductID = "";
  Map<String, dynamic> dashboardCountData = {};
  Map<String, dynamic> dashboardCountDataCopy = {};
  Map<String, dynamic> collectionManagerData = {};
  List<dynamic> collectionManagerList = [];
  List<dynamic> zoneWiseList = [];
  List<dynamic> parameterWiseList = [];
  List<String> filterList = [
    "Current Month",
    "Custom Date"
  ];
  String selectedFilter = "Current Month";
  List<dynamic> auditAgencyList = [];
  int selectedTabTrend = 1;
  List<dynamic> overAllDropList = [];
  List<String> overAllDropListAsString = ["Overall Data"];
  String? selectedOverAllDropValue = "Overall Data";
  List<dynamic> auditList = [];
  List<dynamic> gradesWiseDataList = [];
  List<dynamic> collectionAgencyTrendList = [];
  List<dynamic> overallAuditList = [];
  String gradeSelected = "A";
  List<dynamic> agencyWiseAuditList = [];
  List<dynamic> agencyWiseModifiedList = [];
  List<String> parameterList = [
    "AGENCY MANAGEMENT",
    "PROCESS MANAGEMENT",
    "INFOSEC MANAGEMENT",
    "TELE-CALLING MANAGEMENT",
    "CASH RISK MANAGEMENT"
  ];


  List<Color> colorList = [
    Color(0xFF4BC0C0),
    Color(0xFFFF6384),
    Color(0xFF36A2EB),
    Color(0xFF36A2EB),
    Color(0xFF9A3EEB)

  ];

  List<int> scoreList = [
    3,
    1,
    2,
    3,
    1
  ];
  List<dynamic> productList = [];
  List<dynamic> questionList = [];
  final ZoomDrawerController controller = ZoomDrawerController();
  var startDateController = TextEditingController();
  var endDateController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  List<dynamic> agencyDataList = [];
  int touchedIndex = -1;
  List<String> productListAsString = [];
  String? selectedProduct;
  List<String> dataList = ["Overall Data", "Agency 1"];
  List<String> gradesList = ["Grade A", "Grade B", "Grade C", "Grade D"];
  String? selectedGrade = "Grade A";
  String? selectedDataType;
  List<String> zonesList = ["East", "North", "South", "West"];

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 25),
          Container(
            height: 62,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            color: const Color(0xFF21317D),
            child: Row(
              children: [
                GestureDetector(
                    onTap: () async {
                      _showAlertDialog();
                    },

                    child: Image.asset(
                        "assets/power_2.png", width: 29, height: 29)),
                const Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text("Client Dashboard",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                      ),
                    )),
                /* const Icon(Icons.filter_alt_sharp, color: Colors.white, size: 32),
                const SizedBox(width: 5),*/
                   GestureDetector(
                       onTap: (){
                         if(selectedFilter=="Current Month")
                           {
                             checkInternet();
                           }
                         else
                           {
                             fetchDashboardCountFilter();
                             getCollectionAgencyTrend(true);
                             fetchTotalAuditsCount(false, true);
                             fetchZoneWiseData(false, true);
                             fetchGradeWiseData("A", false, true);
                             fetchAuditAgencyData(true);
                             fetchNCMData(true);
                             fetchParameterData(true);
                           }
                       },
                       child: Icon(Icons.refresh, color: Colors.white, size: 32)),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
              child:

              isLoading ?

              Center(
                  child: Loader()
              ) :


              ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: const Color(0xFF2C68C9).withOpacity(0.10),
                    child: Row(
                      children: [
                        SizedBox(width: 7),
                        Text("Overall",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),


                        Spacer(),

                        Icon(Icons.filter_alt_sharp, color: Color(0xFF21317D)),


                        Container(
                          height: 45,
                          width: 150,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color(0xFFF5F5F5),
                              border: Border.all(color: Color(0xFFA6A6A6),
                                  width: 0.5)
                          ),
                          child:
                          DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              menuItemStyleData:
                              const MenuItemStyleData(
                                padding:
                                EdgeInsets.only(
                                    left: 12),
                              ),
                              iconStyleData:
                              IconStyleData(
                                icon: Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Icon(
                                      Icons
                                          .keyboard_arrow_down_outlined,
                                      color: Colors.black, size: 32),
                                ),
                              ),
                              isExpanded: true,
                              hint: Text(
                                  'Select Type',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight:
                                    FontWeight.w500,
                                    color: Colors.black
                                        .withOpacity(
                                        0.7),
                                  )),
                              items: filterList
                                  .map((item) =>
                                  DropdownMenuItem<
                                      String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style:
                                      const TextStyle(
                                        fontSize:
                                        14,
                                      ),
                                    ),
                                  ))
                                  .toList(),
                              value: selectedFilter,
                              onChanged: (value) {
                                selectedFilter = value.toString();
                                setState(() {});
                                if (selectedFilter == "Current Month") {
                                  fetchDashboardCount();
                                  getCollectionAgencyTrend(false);
                                  fetchTotalAuditsCount(false, false);
                                  fetchZoneWiseData(false, false);
                                  fetchGradeWiseData("A", false, false);
                                  fetchAuditAgencyData(false);
                                  fetchNCMData(false);
                                  fetchParameterData(false);
                                }
                                else {
                                  startDateController.text = "";
                                  endDateController.text = "";
                                  startDate = null;
                                  endDate = null;

                                  calenderBottomSheet(context);
                                }
                              },
                            ),
                          ),
                        ),


                        /*  Container(
                      height: 34,
                      padding: EdgeInsets.symmetric(horizontal: 9),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Color(0xFF21317D)
                      ),

                      child: Row(
                        children: [


                          Image.asset("assets/calender_ic.png",width: 18,height: 17),


                          SizedBox(width: 7),

                          Text("Download Report",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.8))),
                        ],
                      ),

                    )*/

                      ],
                    ),
                  ),
                  const SizedBox(height: 5),


                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: EdgeInsets.symmetric(horizontal: 9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: const Color(0xFfFFC8D1),
                    ),
                    height: 105,
                    child: Column(
                      children: [

                        SizedBox(height: 6),


                        Row(
                          children: [


                            const Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text("Total Allocation",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  )),
                            ),
                            const Spacer(),
                            Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Text(dashboardCountData["totalAllocation"]
                                  .toString(),
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  )),
                            ),
                          ],
                        ),

                        SizedBox(height: 17),

                        dashboardCountData.isEmpty ? Container() :


                        dashboardCountData["totalAllocationByAgency"].length !=
                            0 ?


                        Container(
                            height: 46,
                            child: Scrollbar(
                                child: ListView.builder(
                                    itemCount: dashboardCountData["totalAllocationByAgency"]
                                        .length,
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.zero,


                                    itemBuilder: (BuildContext context,
                                        int pos) {
                                      return Row(
                                        children: [
                                          Column(

                                            children: [


                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                    dashboardCountData["totalAllocationByAgency"][pos]["process_review_agency"],
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      fontWeight: FontWeight
                                                          .w400,
                                                      color: Colors.black,
                                                    )),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                    dashboardCountData["totalAllocationByAgency"][pos]["total"]
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight
                                                          .w700,
                                                      color: Colors.black,
                                                    )),
                                              ),
                                            ],

                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                          ),

                                          SizedBox(width: 10)
                                        ],
                                      );
                                    }


                                )
                            )
                        )


                            :


                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 5, top: 6),
                              child: Text("Data not available",
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      height: 2.3,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w500,
                                      decorationColor: Color(0xFF21317D),
                                      color: Color(0xFF21317D)
                                  )),
                            ),
                          ],
                        ),


                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: EdgeInsets.symmetric(horizontal: 9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: const Color(0xFFF2D6D1),
                    ),
                    height: 105,
                    child: Column(
                      children: [

                        SizedBox(height: 4),

                        Row(
                          children: [


                            const Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text("Total Submitted\nAudits",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  )),
                            ),
                            const Spacer(),
                            Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Text(
                                  dashboardCountData["totalPerfomedAudits"]
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  )),
                            ),
                          ],
                        ),

                        SizedBox(height: 5),


                        dashboardCountData.isEmpty ? Container() :


                        dashboardCountData["totalAuditCompletedByAgency"]
                            .length != 0 ?


                        Container(
                            height: 46,
                            child: Scrollbar(

                              child: ListView.builder(
                                  itemCount: dashboardCountData["totalAuditCompletedByAgency"]
                                      .length,
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.zero,


                                  itemBuilder: (BuildContext context, int pos) {
                                    return Row(
                                      children: [
                                        Column(

                                          children: [


                                            Padding(
                                              padding: EdgeInsets.only(left: 5),
                                              child: Text(
                                                  dashboardCountData["totalAuditCompletedByAgency"][pos]["agency_name"],
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  )),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 5),
                                              child: Text(
                                                  dashboardCountData["totalAuditCompletedByAgency"][pos]["completed_audits"]
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black,
                                                  )),
                                            ),
                                          ],

                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                        ),

                                        SizedBox(width: 10)
                                      ],
                                    );
                                  }


                              ),
                            )
                        )


                            :


                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 5, top: 6),
                              child: Text("Data not available",
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      height: 2.3,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w500,
                                      decorationColor: Color(0xFF21317D),
                                      color: Color(0xFF21317D)
                                  )),
                            ),
                          ],
                        ),


                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: EdgeInsets.symmetric(horizontal: 9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: const Color(0xFfAFC48B).withOpacity(0.7),
                    ),
                    child: Column(
                      children: [

                        SizedBox(height: 6),

                        Row(

                          children: [


                            const Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text("Sent For Action Planning",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  )),
                            ),
                            const Spacer(),
                            Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Text(
                                  dashboardCountData["auditsSendForActionPlan"]
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  )),
                            ),
                          ],
                        ),

                        SizedBox(height: 17),


                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [


                              Column(

                                children: [


                                  const Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text("Total\nSubmitted Audits",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                        dashboardCountData["totalPerfomedAudits"]
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        )),
                                  ),
                                ],

                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),


                              Column(

                                children: [


                                  const Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text("Pending",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                        dashboardCountData["totalPendingAuditsActionPlan"]
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        )),
                                  ),
                                ],

                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),


                              Column(

                                children: [


                                  const Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: Text("Approved/Closed",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: Text(
                                        dashboardCountData["totalApprovedAudits"]
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        )),
                                  ),
                                ],

                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),


                            ],
                          ),
                        ),

                        SizedBox(height: 5),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [


                              Column(

                                children: [


                                  const Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text("Pending (C.A.)",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                        dashboardCountData["totalPendingAuditsofCA"]
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        )),
                                  ),
                                ],

                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),


                              Column(

                                children: [


                                  const Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text("Pending (A. A.)",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                        dashboardCountData["totalPendingAuditsofAA"]
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        )),
                                  ),
                                ],

                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),


                            ],
                          ),
                        )


                      ],
                    ),
                  ),


                  const SizedBox(height: 10),


                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: InkWell(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: const Color(0xFfFFECC2),
                                  ),
                                  height: 115,
                                  child: Column(
                                    children: [

                                      SizedBox(height: 4),

                                      Row(
                                        children: [


                                          const Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Text("Closed Audits",
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                )),
                                          ),
                                          const Spacer(),
                                          Padding(
                                            padding: EdgeInsets.only(right: 5),
                                            child: Text(
                                                dashboardCountDataCopy["overallAuditcurrentMonth"] !=
                                                    null ?
                                                dashboardCountDataCopy["overallAuditcurrentMonth"]
                                                    .toString() : "",
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 10),


                                      Row(
                                        children: [


                                          Column(

                                            children: [


                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5),
                                                child: Text("Last Month",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight: FontWeight
                                                          .w400,
                                                      color: Colors.black,
                                                    )),
                                              ),

                                              SizedBox(height: 5),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5),
                                                child: Text("Audits:" +
                                                    dashboardCountDataCopy["overallAuditlastMonth"]
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      fontWeight: FontWeight
                                                          .w700,
                                                      color: Colors.black,
                                                    )),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5),
                                                child: Text("Score: " +
                                                    dashboardCountDataCopy["overallScorelastMonth"]
                                                        .toString() + "%",
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      fontWeight: FontWeight
                                                          .w700,
                                                      color: Colors.black,
                                                    )),
                                              ),
                                            ],

                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                          ),


                                          Spacer(),

                                          Column(

                                            children: [


                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    right: 5),
                                                child: Text("Current Month",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight: FontWeight
                                                          .w400,
                                                      color: Colors.black,
                                                    )),
                                              ),

                                              SizedBox(height: 5),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 5),
                                                child: Text("Audits:" +
                                                    dashboardCountDataCopy["overallAuditcurrentMonth"]
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      fontWeight: FontWeight
                                                          .w700,
                                                      color: Colors.black,
                                                    )),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 5),
                                                child: Text("Score: " +
                                                    dashboardCountDataCopy["overallScorecurrentMonth"]
                                                        .toString() + "%",
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      fontWeight: FontWeight
                                                          .w700,
                                                      color: Colors.black,
                                                    )),
                                              ),
                                            ],

                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                          ),


                                        ],
                                      )


                                    ],
                                  ),
                                ))),
                      ],
                    ),
                  ),


                  const SizedBox(height: 10),

                  /*    Container(
                margin: EdgeInsets.symmetric(horizontal: 9),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: const Color(0xFfE8D6FF),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: 3),

                    Row(
                      children: [

                         Padding(
                          padding: EdgeInsets.only(left: 7),
                          child: Text(productList.length.toString(),
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              )),
                        ),

                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("Product Count",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              )),
                        ),


                        Spacer(),


                        Image.asset("assets/count_ic.png",width: 43,height: 43),

                        SizedBox(width: 7),


                      ],
                    ),
                    SizedBox(height: 12),



                    productList.length!=0?

                    Container(
                      height:100,
                        padding: EdgeInsets.symmetric(horizontal: 2),

                    child: ListView.builder(
                        itemCount: productList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context,int pos)

                    {
                      return Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 3,horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white.withOpacity(0.56),
                            ),


                            child: Column(
                              children: [
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    SizedBox(width: 3),
                                    Image.asset("assets/count_2.png",width: 26.41,height: 26.41),
                                     Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(productList[pos]["name"],
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF21317D),
                                          )),
                                    ),






                                  ],
                                ),


                                SizedBox(height: 15),



                                Row(
                                  children: [

                                    SizedBox(width: 3),

                                    Text("Count: ",
                                        style: TextStyle(
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        )),






                                    Text(productList[pos]["total"].toString(),
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        )),



                                    SizedBox(width: 3),

                                  ],
                                ),

                                SizedBox(height: 5),

                                Row(
                                  children: [

                                    SizedBox(width: 3),

                                    Text("Score: ",
                                        style: TextStyle(
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF21317D),
                                        )),






                                    Text(productList[pos]["average_score"].toStringAsFixed(2),
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        )),



                                    SizedBox(width: 3),

                                  ],
                                ),

                                SizedBox(height: 5),
                              ],

                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),





                          ),

                          SizedBox(width: 10),

                        ],
                      );
                    }


                    )


                    ):  Container(
                        height:70,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 5,top: 6),
                            child: Text("Data not available",
                                style: TextStyle(
                                    fontSize: 12.0,
                                    height: 2.3,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w500,
                                    decorationColor: Color(0xFF21317D),
                                    color: Color(0xFF21317D)
                                )),
                          ),
                        ],
                      ),
                    ),


                    SizedBox(height: 7),

                  ],
                ),


              ),

              const SizedBox(height: 13),*/


                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: const Color(0xFF2C68C9).withOpacity(0.10),
                    child: Row(
                      children: [
                        const SizedBox(width: 7),
                        const Text("Trend Last Six Months",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                        const SizedBox(width: 7),
                      ],
                    ),
                  ),

                  SizedBox(height: 5),

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
                    child: Column(
                      children: [


                        SizedBox(height: 5),

                        Row(
                          children: [
                            Spacer(),
                            Container(
                              height: 45,
                              width: 150,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: const Color(0xFFF5F5F5),
                                  border: Border.all(
                                      color: Color(0xFFA6A6A6), width: 0.5)
                              ),
                              child:
                              DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  menuItemStyleData:
                                  const MenuItemStyleData(
                                    padding:
                                    EdgeInsets.only(
                                        left: 12),
                                  ),
                                  iconStyleData:
                                  IconStyleData(
                                    icon: Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Icon(
                                          Icons
                                              .keyboard_arrow_down_outlined,
                                          color: Colors.black, size: 32),
                                    ),
                                  ),
                                  isExpanded: true,
                                  hint: Text(
                                      'Select Type',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight:
                                        FontWeight.w500,
                                        color: Colors.black
                                            .withOpacity(
                                            0.7),
                                      )),
                                  items: overAllDropListAsString
                                      .map((item) =>
                                      DropdownMenuItem<
                                          String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style:
                                          const TextStyle(
                                            fontSize:
                                            14,
                                          ),
                                        ),
                                      ))
                                      .toList(),
                                  value: selectedOverAllDropValue,
                                  onChanged: (value) {
                                    selectedOverAllDropValue = value.toString();
                                    setState(() {});
                                    if (selectedOverAllDropValue ==
                                        "Overall Data") {
                                      if (selectedFilter == "Current Month") {
                                        fetchTotalAuditsCount(true, false);
                                      }
                                      else {
                                        fetchTotalAuditsCount(true, true);
                                      }
                                    }
                                    else {
                                      String agencyID = "";
                                      for (int i = 0; i <
                                          overAllDropList.length; i++) {
                                        if (overAllDropList[i]["process_review_agency"] ==
                                            selectedOverAllDropValue
                                                .toString()) {
                                          agencyID =
                                              overAllDropList[i]["process_review_agency_id"]
                                                  .toString();
                                          break;
                                        }
                                      }


                                      if (selectedFilter == "Current Month") {
                                        fetchAgencyWiseAudit(agencyID, false);
                                      }
                                      else {
                                        fetchAgencyWiseAudit(agencyID, true);
                                      }
                                    }
                                  },
                                ),
                              ),
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


                        SizedBox(height: 7),


                        overAllEnabled ? Container() :

                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text(selectedOverAllDropValue.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF21317D))),


                            ),
                          ],
                        ),


                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          // height: 36,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Color(0xFF21317D).withOpacity(0.58)
                          ),

                          child: Row(
                            children: [
                              Container(
                                width: 115,
                                child: Text("Month",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white)),
                              ),

                              Expanded(child: Row(
                                children: [

                                  Expanded(child: Center(
                                    child: Text("Allocation",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white)),
                                  ), flex: 1),

                                  SizedBox(width: 5),


                                  Expanded(child: Center(
                                    child: Text("Submitted",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white)),
                                  ), flex: 1),


                                  SizedBox(width: 5),
                                  Expanded(child: Center(
                                    child: Text("Pending",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white)),
                                  ), flex: 1),

                                  SizedBox(width: 5),
                                  Expanded(child: Center(
                                    child: Text("Score",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white)),
                                  ), flex: 1),

                                ],
                              ))


                            ],
                          ),

                        ),


                        overAllEnabled ?
                        ListView.builder(
                            itemCount: overallAuditList.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int pos) {
                              return Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 0),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5),
                                    height: 36,


                                    child: Row(
                                      children: [
                                        Container(
                                          width: 115,
                                          child: Text(
                                              overallAuditList[pos]["month"],
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF21317D))),
                                        ),

                                        Expanded(child: Row(
                                          children: [

                                            Expanded(child: Center(
                                              child: Text(
                                                  overallAuditList[pos]["allocation_count"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Colors.black)),
                                            ), flex: 1),

                                            Expanded(child: Center(
                                              child: Text(
                                                  overallAuditList[pos]["audit_count"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Colors.black)),
                                            ), flex: 1),

                                            Expanded(child: Center(
                                              child: Text(
                                                  overallAuditList[pos]["pending_count"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Colors.black)),
                                            ), flex: 1),


                                            Expanded(child: Center(
                                              child: Text(
                                                  overallAuditList[pos]["overall_score"]
                                                      .toString() + "%",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Colors.black)),
                                            ), flex: 1),

                                          ],
                                        ))


                                      ],
                                    ),

                                  ),

                                  pos == overallAuditList.length - 1
                                      ? Container()
                                      :

                                  Container(
                                    height: 1,
                                    color: Colors.grey.withOpacity(0.4),
                                  )
                                ],
                              );
                            }


                        ) :
                        ListView.builder(
                            itemCount: agencyWiseAuditList.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int pos) {
                              return Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 0),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5),
                                    height: 36,


                                    child: Row(
                                      children: [
                                        Container(
                                          width: 115,
                                          child: Text(
                                              agencyWiseAuditList[pos]["month"],
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF21317D))),
                                        ),


                                        agencyWiseModifiedList.length == 0
                                            ? Container()
                                            :


                                        Expanded(child: Row(
                                          children: [

                                            Expanded(child: Center(
                                              child: Text(
                                                  agencyWiseModifiedList[pos]["allocation_count"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Colors.black)),
                                            ), flex: 1),

                                            Expanded(child: Center(
                                              child: Text(
                                                  agencyWiseModifiedList[pos]["audit_count"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Colors.black)),
                                            ), flex: 1),

                                            Expanded(child: Center(
                                              child: Text(
                                                  agencyWiseModifiedList[pos]["pending_count"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Colors.black)),
                                            ), flex: 1),


                                            Expanded(child: Center(
                                              child: Text(
                                                  agencyWiseModifiedList[pos]["overall_score"]
                                                      .toString() + "%",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Colors.black)),
                                            ), flex: 1),

                                          ],
                                        ))


                                      ],
                                    ),

                                  ),


                                  pos == agencyWiseAuditList.length - 1
                                      ? Container()
                                      :

                                  Container(
                                    height: 1,
                                    color: Colors.grey.withOpacity(0.4),
                                  )
                                ],
                              );
                            }


                        )


                      ],
                    ),
                  ),
                  const SizedBox(height: 10),


                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: const Color(0xFF2C68C9).withOpacity(0.10),
                    child: Row(
                      children: [
                        const SizedBox(width: 7),
                        const Text("Zone Wise",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                        /*  const Spacer(),
                    Container(
                        height: 29,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1),
                            color: const Color(0xFF21317D)),
                        child: const Center(
                          child: Text("View All",
                              style:
                                  TextStyle(fontSize: 11, color: Colors.white)),
                        )),
                    const SizedBox(width: 7),*/
                      ],
                    ),
                  ),
                  const SizedBox(height: 13),
                  Container(
                    height: 41,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    child: ListView.builder(
                        itemCount: zonesList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int pos) {
                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = pos;
                                  });
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: selectedIndex == pos
                                            ? const Color(0xFF21317D)
                                            : const Color(0xFFDADADA)),
                                    child: Center(
                                      child: Text(zonesList[pos],
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: selectedIndex == pos
                                                  ? Colors.white
                                                  : Colors.black)),
                                    )),
                              ),
                              const SizedBox(width: 6),
                            ],
                          );
                        }),
                  ),
                  const SizedBox(height: 13),


                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: const Color(0xFFE3F7FF),
                      boxShadow: const [
                        BoxShadow(
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
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            SizedBox(width: 13),
                            Text(zonesList[selectedIndex] + " ",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C68C9))),
                            Text("Zone",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Spacer(),
                            Text("Audit Score   ",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                            Text(zoneWiseList.length == 0
                                ? "0.00%"
                                : zoneWiseList[selectedIndex]["average_score"]
                                .toStringAsFixed(2) + "%",
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF3ADA53))),
                            SizedBox(width: 10),
                          ],
                        ),

                        const SizedBox(height: 15),


                        /*   Row(
                       children: [



                         Padding(
                           padding:
                           const EdgeInsets.only(
                               left: 12),
                           child: Text("Select Product",
                               style: TextStyle(
                                 fontSize: 12,
                                 fontWeight:
                                 FontWeight.w500,
                                 color: Colors.black,
                               )),
                         ),
                         SizedBox(width: 10),
                         Expanded(
                           child: Container(
                             // width: 80,
                             height: 40,
                             margin: EdgeInsets.symmetric(
                                 horizontal: 10),
                             padding:
                             EdgeInsets.only(right: 5),
                             decoration: BoxDecoration(
                                 borderRadius:
                                 BorderRadius.circular(
                                     5),
                                 border: Border.all(
                                     color: Colors.black,
                                     width: 0.5)),
                             child:
                             DropdownButtonHideUnderline(
                               child: DropdownButton2(
                                 menuItemStyleData:
                                 const MenuItemStyleData(
                                   padding:
                                   EdgeInsets.only(
                                       left: 12),
                                 ),
                                 iconStyleData:
                                 IconStyleData(
                                   icon: Icon(
                                       Icons
                                           .keyboard_arrow_down_outlined,
                                       color:
                                       Colors.black),
                                 ),
                                 isExpanded: true,
                                 hint: Text(
                                     'Select Product',
                                     style: TextStyle(
                                       fontSize: 12,
                                       fontWeight:
                                       FontWeight.w500,
                                       color: Colors.black
                                           .withOpacity(
                                           0.7),
                                     )),
                                 items: productListAsString
                                     .map((item) =>
                                     DropdownMenuItem<
                                         String>(
                                       value: item,
                                       child: Text(
                                         item,
                                         style:
                                         const TextStyle(
                                           fontSize:
                                           14,
                                         ),
                                       ),
                                     ))
                                     .toList(),
                                 value: selectedProduct,
                                 onChanged: (value) {

                                   selectedProduct=value.toString();
                                   setState(() {

                                   });

                                   String productIDLocal="";
                                   for(int i=0;i<productList.length;i++)
                                     {
                                       if(productList[i]["name"]==selectedProduct.toString())
                                         {
                                           productIDLocal=productList[i]["product_id"].toString();
                                           break;
                                         }
                                     }
                                   globalProductID=productIDLocal;


                                   fetchZoneWiseData(productIDLocal,true);




                                 },
                               ),
                             ),
                           ),
                         ),


                       ],
                   ),*/


                        zoneWiseList.length == 0 ? Container() :

                        Container(
                          height: 250,
                          child: Stack(
                            children: [

                              zoneWiseList.length == 0 ? Container() :

                              PieChart(

                                PieChartData(

                                  pieTouchData: PieTouchData(
                                    touchCallback: (FlTouchEvent event,
                                        pieTouchResponse) {
                                      /*  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        pieTouchResponse == null ||
                                        pieTouchResponse.touchedSection == null) {
                                      touchedIndex = -1;
                                      return;
                                    }
                                    touchedIndex = pieTouchResponse
                                        .touchedSection!.touchedSectionIndex;
                                  });*/
                                    },
                                  ),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 55,
                                  sections: showingSections(),
                                ),
                              ),

                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: 105),
                                  child: Column(
                                    children: [
                                      Text(
                                          zoneWiseList[selectedIndex]["total_allocation"]
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black)),
                                      SizedBox(height: 3),
                                      Text("Allocation",
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF929292))),
                                    ],
                                  ),
                                ),
                              )


                            ],
                          ),
                        ),

                        /*    Container(
                      height: 150,
                        child:Center(
                          child: Text("No data found!"),
                        )
                    ),
*/
                        zoneWiseList.length == 0 ? Container() :
                        Padding(padding: EdgeInsets.symmetric(horizontal: 30),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Row(
                                children: [

                                  Container(
                                    width: 18,
                                    height: 7,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Color(0xFFF48FB1)
                                    ),
                                  ),

                                  SizedBox(width: 7),

                                  Text("Retail",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                ],
                              ),


                              Row(
                                children: [

                                  Container(
                                    width: 18,
                                    height: 7,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Color(0xFFFEC502)
                                    ),
                                  ),

                                  SizedBox(width: 7),

                                  Text("Credit Card",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                ],
                              ),


                              Row(
                                children: [

                                  Container(
                                    width: 18,
                                    height: 7,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Color(0xFF4D93FD)
                                    ),
                                  ),

                                  SizedBox(width: 7),

                                  Text("Retail / Credit Card",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                ],
                              )


                            ],
                          ),


                        ),


                        const SizedBox(height: 25),


                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 60),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(zoneWiseList.length == 0
                                      ? "0"
                                      : zoneWiseList[selectedIndex]["total_allocation"]
                                      .toString(),
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black)),


                                  SizedBox(height: 5),
                                  Text("Assigned Agency",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF929292))),
                                ],
                              ),
                              /* Column(
                            children: [
                              Text("50",
                                  style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black)),
                              SizedBox(height: 5),
                              Text("Scheduled",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF929292))),
                            ],
                          ),*/
                              Column(
                                children: [
                                  Text(zoneWiseList.length == 0
                                      ? "0"
                                      : zoneWiseList[selectedIndex]["audit_count"]
                                      .toString(),
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black)),
                                  SizedBox(height: 5),
                                  Text("Audit Completed",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF929292))),
                                ],
                              )
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 9),
                          child: Divider(
                            color: Color(0xFFDFD8D8),
                          ),
                        ),


                        const SizedBox(height: 10),


                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 60),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(zoneWiseList.length == 0
                                      ? "0"
                                      : zoneWiseList[selectedIndex]["sent_for_closure_count"]
                                      .toString(),
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black)),
                                  SizedBox(height: 5),
                                  Text("Sent for Closure",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF929292))),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(zoneWiseList.length == 0
                                      ? "0"
                                      : zoneWiseList[selectedIndex]["closure_completed_count"]
                                      .toString(),
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black)),
                                  SizedBox(height: 5),
                                  Text("Closure Completed",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF929292))),
                                ],
                              ),

                            ],
                          ),
                        ),
                        const SizedBox(height: 17),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: const Color(0xFFE3F7FF),
                      boxShadow: const [
                        BoxShadow(
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
                        const SizedBox(height: 15),
                        const Row(
                          children: [
                            SizedBox(width: 13),
                            Text("Parameters ",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C68C9))),
                            Text("Score",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),

                            SizedBox(width: 10),
                          ],
                        ),

                        const SizedBox(height: 15),


                        parameterWiseList.length == 0 ?


                        Container(
                          height: 50,
                          child: Center(
                            child: Text("No data found!"),
                          ),
                        ) :


                        ListView.builder(
                            itemCount: parameterWiseList.length,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int pos) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [


                                  Padding(
                                    padding: const EdgeInsets.only(left: 22),
                                    child: Text(
                                      parameterWiseList[pos]["parameter_name"],
                                      style: TextStyle(
                                        fontSize: 14.5,
                                        color: Color(0xFF272D3B),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Stack(
                                    children: [

                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 22, right: 25),
                                        child: StepProgressIndicator(
                                          totalSteps: 100,
                                          currentStep: parameterWiseList[pos]["total_parameter_percentage"]
                                              .toInt(),
                                          size: 22,
                                          padding: 0,
                                          unselectedColor: Colors.grey
                                              .withOpacity(0.5),
                                          selectedGradientColor: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              colorList[pos],
                                              colorList[pos]
                                            ],
                                          ),
                                        ),
                                      ),

                                      Container(
                                        height: 22,
                                        margin: const EdgeInsets.only(
                                            left: 22, right: 25),
                                        child: Row(
                                          children: [


                                            Spacer(),

                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Text(
                                                parameterWiseList[pos]["total_parameter_percentage"]
                                                    .toStringAsFixed(2) + '%',
                                                style: TextStyle(
                                                  fontSize: 14.5,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),

                                            SizedBox(width: 10)


                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),

                                  /*    Row(
                         children: [
                           Padding(
                             padding: const EdgeInsets.only(left: 22),
                             child: Text(
                               'Last Month Score:',
                               style: TextStyle(
                                 fontSize: 11.5,
                                 color: Color(0xFF272D3B),
                               ),
                             ),
                           ),

                           Padding(
                             padding: const EdgeInsets.only(left: 5),
                             child: Text(
                               'NA',
                               style: TextStyle(
                                 fontSize: 12,
                                 fontWeight: FontWeight.w600,
                                 color: Color(0xFF272D3B),
                               ),
                             ),
                           ),

                         ],
                       ),
                       SizedBox(height: 5),



                       Row(
                         children: [
                           Padding(
                             padding: const EdgeInsets.only(left: 22),
                             child: Text(
                               'Result:',
                               style: TextStyle(
                                 fontSize: 11.5,
                                 color: Color(0xFF272D3B),
                               ),
                             ),
                           ),

                           Padding(
                             padding: const EdgeInsets.only(left: 5),
                             child: Text(
                               'NA',
                               style: TextStyle(
                                 fontSize: 12,
                                 fontWeight: FontWeight.w600,
                                 color: Color(0xFF272D3B),
                               ),
                             ),
                           ),

                         ],
                       ),*/


                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 22),
                                    child: Divider(
                                      thickness: 1,
                                      color: Color(0xFF707070).withOpacity(
                                          0.30),
                                    ),
                                  ),
                                  SizedBox(height: 3),

                                ],
                              );
                            }


                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 22, right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '0',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF748AA1),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '20',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF748AA1),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '40',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF748AA1),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '60',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF748AA1),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '80',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF748AA1),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '100',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF748AA1),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 17),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: const Color(0xFF2C68C9).withOpacity(0.10),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        const Text("Grades",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),


                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  /*   Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 8),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                    color: const Color(0xFFF5F5F5),
                  border: Border.all(color: Color(0xFFA6A6A6),width: 0.5)
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    const Text("Grade A",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),


                    Spacer(),


                    Icon(Icons.keyboard_arrow_down,color: Color(0xFFA6A6A6),size: 32),
                    const SizedBox(width: 5),

                  ],
                ),
              ),*/

                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: const Color(0xFFF5F5F5),
                        border: Border.all(color: Color(0xFFA6A6A6), width: 0.5)
                    ),
                    child:
                    DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        menuItemStyleData:
                        const MenuItemStyleData(
                          padding:
                          EdgeInsets.only(
                              left: 12),
                        ),
                        iconStyleData:
                        IconStyleData(
                          icon: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Icon(
                                Icons
                                    .keyboard_arrow_down_outlined,
                                color: Colors.black, size: 32),
                          ),
                        ),
                        isExpanded: true,
                        hint: Text(
                            'Select Grade',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                              FontWeight.w500,
                              color: Colors.black
                                  .withOpacity(
                                  0.7),
                            )),
                        items: gradesList
                            .map((item) =>
                            DropdownMenuItem<
                                String>(
                              value: item,
                              child: Text(
                                item,
                                style:
                                const TextStyle(
                                  fontSize:
                                  14,
                                ),
                              ),
                            ))
                            .toList(),
                        value: selectedGrade,
                        onChanged: (value) {
                          selectedGrade = value.toString();
                          setState(() {

                          });


                          if (selectedGrade.toString() == "Grade A") {
                            gradeSelected = "A";
                          }

                          else if (selectedGrade.toString() == "Grade B") {
                            gradeSelected = "B";
                          }
                          else if (selectedGrade.toString() == "Grade C") {
                            gradeSelected = "C";
                          }
                          else if (selectedGrade.toString() == "Grade D") {
                            gradeSelected = "D";
                          }


                          if (selectedFilter == "Current Month") {
                            fetchGradeWiseData(gradeSelected, true, false);
                          }
                          else {
                            fetchGradeWiseData(gradeSelected, true, true);
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 13),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: const Color(0xFFFCFCFC),
                      boxShadow: const [
                        BoxShadow(
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
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            SizedBox(width: 13),
                            Text("Grade ",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C68C9))),
                            Text(gradeSelected,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),

                          ],
                        ),
                        //  const SizedBox(height: 32),


                        /*    CustomPaint(
                  painter: BoxShadowPainter()),

                    const SizedBox(height: 32),*/


                        gradesWiseDataList.length == 0 ?


                        Container(
                          height: 230,
                          child: Center(
                            child: Text("No data found!"),
                          ),
                        ) :


                        Container(
                          height: 250,
                          child: PieChart(

                            PieChartData(

                              pieTouchData: PieTouchData(
                                touchCallback: (FlTouchEvent event,
                                    pieTouchResponse) {
                                  /*  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        pieTouchResponse == null ||
                                        pieTouchResponse.touchedSection == null) {
                                      touchedIndex = -1;
                                      return;
                                    }
                                    touchedIndex = pieTouchResponse
                                        .touchedSection!.touchedSectionIndex;
                                  });*/
                                },
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              sectionsSpace: 0,
                              centerSpaceRadius: 55,
                              sections: showingSectionsGrades(),
                            ),
                          ),
                        ),


                        Padding(padding: EdgeInsets.symmetric(horizontal: 40),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Row(
                                children: [

                                  Container(
                                    width: 18,
                                    height: 7,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Color(0xFF61C667)
                                    ),
                                  ),

                                  SizedBox(width: 7),

                                  Text("East",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                ],
                              ),


                              Row(
                                children: [

                                  Container(
                                    width: 18,
                                    height: 7,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Color(0xFFFEC502)
                                    ),
                                  ),

                                  SizedBox(width: 7),

                                  Text("West",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                ],
                              ),


                              Row(
                                children: [

                                  Container(
                                    width: 18,
                                    height: 7,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Color(0xFF4D93FD)
                                    ),
                                  ),

                                  SizedBox(width: 7),

                                  Text("North",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                ],
                              ),

                              Row(
                                children: [

                                  Container(
                                    width: 18,
                                    height: 7,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Color(0xFFD81B60)
                                    ),
                                  ),

                                  SizedBox(width: 7),

                                  Text("South",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                ],
                              )

                            ],
                          ),


                        ),


                        /*     const SizedBox(height: 13),



                    Center(
                      child: Text("List Download",
                          style: TextStyle(
                              fontSize: 13,
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFF0039D6),
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0039D6))),
                    ),*/
                        const SizedBox(height: 14),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),



                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: const Color(0xFF2C68C9).withOpacity(0.10),
                    child: Row(
                      children: [
                        const SizedBox(width: 7),
                        const Text("Audit Agency",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>
                                    AuditAgencyScreen(auditAgencyList)));
                          },
                          child: Container(
                              height: 29,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1),
                                  color: const Color(0xFF21317D)),
                              child: const Center(
                                child: Text("View All",
                                    style:
                                    TextStyle(
                                        fontSize: 11, color: Colors.white)),
                              )),
                        ),
                        const SizedBox(width: 7),
                      ],
                    ),
                  ) ,

                  auditAgencyList.length != 0 ?
                  const SizedBox(height: 18) : Container(),


                  auditAgencyList.length != 0 ?

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
                    child: Column(
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
                                Text(auditAgencyList[0]["audit_agency_name"],
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
                                width: 130,
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
                                  ), flex: 1),


                                  Expanded(child: Center(
                                    child: Text("Cards",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white)),
                                  ), flex: 1),
                                  Expanded(child: Center(
                                    child: Text("R+C",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white)),
                                  ), flex: 1),

                                  Expanded(child: Center(
                                    child: Text("Total",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white)),
                                  ), flex: 1),

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
                                width: 130,
                                child: Text("Assigned Agency",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF21317D))),
                              ),

                              Expanded(child: Row(
                                children: [

                                  Expanded(child: Center(
                                    child: Text(
                                        auditAgencyList[0].toString().contains(
                                            "assign_retail_count")
                                            ? auditAgencyList[0]["assign_retail_count"]
                                            .toString()
                                            : "0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ), flex: 1),


                                  Expanded(child: Center(
                                    child: Text(
                                        auditAgencyList[0].toString().contains(
                                            "assign_card_count")
                                            ? auditAgencyList[0]["assign_card_count"]
                                            .toString()
                                            : "0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ), flex: 1),
                                  Expanded(child: Center(
                                    child: Text(
                                        auditAgencyList[0].toString().contains(
                                            "assign_retail_card_count")
                                            ? auditAgencyList[0]["assign_retail_card_count"]
                                            .toString()
                                            : "0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ), flex: 1),

                                  Expanded(child: Center(
                                    child: Text(
                                        auditAgencyList[0].toString().contains(
                                            "total_assign_count")
                                            ? auditAgencyList[0]["total_assign_count"]
                                            .toString()
                                            : "0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ), flex: 1),

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
                                width: 130,
                                child: Text("Scheduled",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF21317D))),
                              ),

                              Expanded(child: Row(
                                children: [

                                  Expanded(child: Center(
                                    child: Text(
                                        auditAgencyList[0].toString().contains(
                                            "scheduled_retail_count")
                                            ? auditAgencyList[0]["scheduled_retail_count"]
                                            .toString()
                                            : "0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ), flex: 1),


                                  Expanded(child: Center(
                                    child: Text(
                                        auditAgencyList[0].toString().contains(
                                            "scheduled_card_count")
                                            ? auditAgencyList[0]["scheduled_card_count"]
                                            .toString()
                                            : "0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ), flex: 1),
                                  Expanded(child: Center(
                                    child: Text(
                                        auditAgencyList[0].toString().contains(
                                            "scheduled_retail_card_count")
                                            ? auditAgencyList[0]["scheduled_retail_card_count"]
                                            .toString()
                                            : "0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ), flex: 1),

                                  Expanded(child: Center(
                                    child: Text(
                                        auditAgencyList[0].toString().contains(
                                            "total_scheduled_count")
                                            ? auditAgencyList[0]["total_scheduled_count"]
                                            .toString()
                                            : "0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ), flex: 1),

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
                                width: 130,
                                child: Text("Audit Completed",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF21317D))),
                              ),

                              Expanded(child: Row(
                                children: [

                                  Expanded(child: Center(
                                    child: Text(
                                        auditAgencyList[0].toString().contains(
                                            "complete_audits_retail")
                                            ? auditAgencyList[0]["complete_audits_retail"]
                                            .toString()
                                            : "0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ), flex: 1),


                                  Expanded(child: Center(
                                    child: Text(
                                        auditAgencyList[0].toString().contains(
                                            "complete_audits_card")
                                            ? auditAgencyList[0]["complete_audits_card"]
                                            .toString()
                                            : "0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ), flex: 1),
                                  Expanded(child: Center(
                                    child: Text(
                                        auditAgencyList[0].toString().contains(
                                            "complete_audits_retail_card")
                                            ? auditAgencyList[0]["complete_audits_retail_card"]
                                            .toString()
                                            : "0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ), flex: 1),

                                  Expanded(child: Center(
                                    child: Text(
                                        auditAgencyList[0].toString().contains(
                                            "complete_audit_total")
                                            ? auditAgencyList[0]["complete_audit_total"]
                                            .toString()
                                            : "0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ), flex: 1),

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
                                width: 130,
                                child: Text("Sent For Closure",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF21317D))),
                              ),

                              Expanded(child: Row(
                                children: [

                                  Expanded(child: Center(
                                    child: Text(
                                        auditAgencyList[0].toString().contains(
                                            "audits_sent_to_closer_retail")
                                            ? auditAgencyList[0]["audits_sent_to_closer_retail"]
                                            .toString()
                                            : "0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ), flex: 1),


                                  Expanded(child: Center(
                                    child: Text(
                                        auditAgencyList[0].toString().contains(
                                            "audits_sent_to_closer_card")
                                            ? auditAgencyList[0]["audits_sent_to_closer_card"]
                                            .toString()
                                            : "0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ), flex: 1),
                                  Expanded(child: Center(
                                    child: Text(
                                        auditAgencyList[0].toString().contains(
                                            "audits_sent_to_closer_retail_card")
                                            ? auditAgencyList[0]["audits_sent_to_closer_retail_card"]
                                            .toString()
                                            : "0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ), flex: 1),

                                  Expanded(child: Center(
                                    child: Text(
                                        auditAgencyList[0].toString().contains(
                                            "audits_sent_to_closer_total")
                                            ? auditAgencyList[0]["audits_sent_to_closer_total"]
                                            .toString()
                                            : "0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ), flex: 1),

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
                                width: 130,
                                child: Text("Closure Completed",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF21317D))),
                              ),

                              Expanded(child: Row(
                                children: [

                                  Expanded(child: Center(
                                    child: Text(
                                        auditAgencyList[0].toString().contains(
                                            "audits_closure_complete_retail")
                                            ? auditAgencyList[0]["audits_closure_complete_retail"]
                                            .toString()
                                            : "0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ), flex: 1),


                                  Expanded(child: Center(
                                    child: Text(
                                        auditAgencyList[0].toString().contains(
                                            "audits_closure_complete_card")
                                            ? auditAgencyList[0]["audits_closure_complete_card"]
                                            .toString()
                                            : "0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ), flex: 1),
                                  Expanded(child: Center(
                                    child: Text(
                                        auditAgencyList[0].toString().contains(
                                            "audits_closure_complete_retail_card")
                                            ? auditAgencyList[0]["audits_closure_complete_retail_card"]
                                            .toString()
                                            : "0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ), flex: 1),

                                  Expanded(child: Center(
                                    child: Text(
                                        auditAgencyList[0].toString().contains(
                                            "audits_closure_complete_total")
                                            ? auditAgencyList[0]["audits_closure_complete_total"]
                                            .toString()
                                            : "0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ), flex: 1),

                                ],
                              ))


                            ],
                          ),

                        ),
                      ],
                    ),
                  ) :      Container(
                    height: 50,
                    child: Center(
                      child: Text("No data found!"),
                    ),
                  ) ,
                  const SizedBox(height: 10),

                  /*      Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: const Color(0xFF2C68C9).withOpacity(0.10),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    const Text("Collection Agency",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),


                  ],
                ),
              ),


              const SizedBox(height: 10),

             ListView.builder(
                 itemCount:agencyDataList.length,
                 padding: EdgeInsets.zero,
                 shrinkWrap: true,
                 physics: NeverScrollableScrollPhysics(),
                 itemBuilder: (BuildContext context,int pos)
                 {
                   return Column(
                     children: [

                       Container(
                         padding: const EdgeInsets.all(7),
                         margin: const EdgeInsets.symmetric(horizontal: 8),
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(4),
                           color: Color(0xFFFCFCFC),
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
                             const SizedBox(height: 5),
                              Row(
                               children: [
                                 SizedBox(width: 8),

                                 Text(agencyDataList[pos]["agency_name"],
                                     style: TextStyle(
                                         fontSize: 15,
                                         fontWeight: FontWeight.w600,
                                         color: Colors.black)),
                                 Spacer(),
                                 Text("Overall Score   ",
                                     style: TextStyle(
                                         fontSize: 12,
                                         fontWeight: FontWeight.w500,
                                         color: Colors.black)),
                                 Text(agencyDataList[pos]["total_percentage"].toString()+"%",
                                     style: TextStyle(
                                         fontSize: 19,
                                         fontWeight: FontWeight.w600,
                                         color: Color(0xFF3ADA53))),
                                 SizedBox(width: 5),
                               ],
                             ),
                             const SizedBox(height: 15),

                              Padding(
                               padding: EdgeInsets.symmetric(horizontal: 8),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text(agencyDataList[pos]["formatted_audit_date"],
                                           style: TextStyle(
                                               fontSize: 16,
                                               fontWeight: FontWeight.w600,
                                               color: Colors.black)),
                                       SizedBox(height: 3),
                                       Text("Audit Date",
                                           style: TextStyle(
                                               fontSize: 12,
                                               fontWeight: FontWeight.w500,
                                               color: Color(0xFF929292))),
                                     ],
                                   ),
                                   Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text(agencyDataList[pos]["auditor_name"],
                                           style: TextStyle(
                                               fontSize: 16,
                                               fontWeight: FontWeight.w600,
                                               color: Colors.black)),
                                       SizedBox(height: 3),
                                       Text("Done By",
                                           style: TextStyle(
                                               fontSize: 12,
                                               fontWeight: FontWeight.w500,
                                               color: Color(0xFF929292))),
                                     ],
                                   ),

                                 ],
                               ),
                             ),
                             const SizedBox(height: 15),


                             Row(
                               children: [

                                 SizedBox(width: 8),
                                 Text("Retail",
                                     style: TextStyle(
                                         fontSize: 12,
                                         fontWeight: FontWeight.w500,
                                         color: Colors.black)),

                                 SizedBox(width: 5),

                                 Text("86.01%",
                                     style: TextStyle(
                                         fontSize: 16,
                                         fontWeight: FontWeight.w600,
                                         color: Color(0xFF21317D))),


                                 SizedBox(width: 15),
                                 Text("CC",
                                     style: TextStyle(
                                         fontSize: 12,
                                         fontWeight: FontWeight.w500,
                                         color: Colors.black)),

                                 SizedBox(width: 5),

                                 Text("72.05%",
                                     style: TextStyle(
                                         fontSize: 16,
                                         fontWeight: FontWeight.w600,
                                         color: Color(0xFF21317D))),
                                 SizedBox(width: 15),
                                 Text("R+CC",
                                     style: TextStyle(
                                         fontSize: 12,
                                         fontWeight: FontWeight.w500,
                                         color: Colors.black)),

                                 SizedBox(width: 5),

                                 Text("82.01%",
                                     style: TextStyle(
                                         fontSize: 16,
                                         fontWeight: FontWeight.w600,
                                         color: Color(0xFF21317D))),
                               ],
                             ),


                             const SizedBox(height: 5),
                             const Padding(
                               padding: EdgeInsets.only(left: 8),
                               child: Text("Product wise Score",
                                   style: TextStyle(
                                       fontSize: 12, color: Color(0xFF929292))),
                             ),
                             const SizedBox(height: 9),

                           ],
                         ),
                       ),

                       SizedBox(height: 14)

                     ],
                   );
                 }



             ),*/


                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: const Color(0xFF2C68C9).withOpacity(0.10),
                    child: Row(
                      children: [
                        const SizedBox(width: 7),
                        const Text("Collection Agency Trend",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>
                                    AgencyTrendScreen(
                                        collectionAgencyTrendList)));
                          },
                          child: Container(
                              height: 29,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1),
                                  color: const Color(0xFF21317D)),
                              child: const Center(
                                child: Text("View All",
                                    style:
                                    TextStyle(
                                        fontSize: 11, color: Colors.white)),
                              )),
                        ),
                        const SizedBox(width: 7),
                      ],
                    ),
                  ),


                  SizedBox(height: 12),


                  collectionAgencyTrendList.length == 0 ?      Container(
                    height: 50,
                    child: Center(
                      child: Text("No data found!"),
                    ),
                  )  :


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

                                  Text(
                                      collectionAgencyTrendList[0]["agency_name"],
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black)),
                                  Text(collectionAgencyTrendList[0]["location"],
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


                                Text(
                                    collectionAgencyTrendList[0]["average_score_percentage"]
                                        .toStringAsFixed(2) + "%",
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
                                    Text(
                                        collectionAgencyTrendList[0]["collection_manager_name"],
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
                                  Text(
                                      collectionAgencyTrendList[0]["audit_count"]
                                          .toString(),
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
                              itemCount: collectionAgencyTrendList[0]["six_month_data"]
                                  .length,

                              scrollDirection: Axis.horizontal,

                              itemBuilder: (BuildContext context, int pos) {
                                return Row(
                                  children: [
                                    /*  Color(0xFF3ADA53)
                               Color(0xFF52CEF5)*/
                                    Container(
                                      width: 50,
                                      height: 37,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              3),
                                          color:
                                          collectionAgencyTrendList[0]["six_month_data"][pos]["average_score"] ==
                                              0 ?

                                          Color(0xFF6C757D) :

                                          collectionAgencyTrendList[0]["six_month_data"][pos]["average_score"] <
                                              50 ?

                                          Color(0xFFF7476B) :

                                          collectionAgencyTrendList[0]["six_month_data"][pos]["average_score"] >
                                              50 &&
                                              collectionAgencyTrendList[0]["six_month_data"][pos]["average_score"] <
                                                  70 ?
                                          Color(0xFF52CEF5) :
                                          Color(0xFF3ADA53)


                                      ),
                                      child: Center(
                                        child: Text(
                                            collectionAgencyTrendList[0]["six_month_data"][pos]["average_score"]
                                                .toStringAsFixed(0) + "%",
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
                              onTap: () {
                                setState(() {
                                  selectedTabTrend = 1;
                                });
                              },
                              child: Container(
                                  height: 38,
                                  padding: EdgeInsets.symmetric(horizontal: 22),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: selectedTabTrend == 1 ? Color(
                                          0xFF21317D) : Color(0xFFE7E9F1)
                                  ),

                                  child: Center(
                                    child: Text("Retail",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: selectedTabTrend == 1
                                                ? Colors.white
                                                : Colors.black)),
                                  )

                              ),
                            ),


                            SizedBox(width: 10),

                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTabTrend = 2;
                                });
                              },
                              child: Container(
                                  height: 38,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: selectedTabTrend == 2 ? Color(
                                          0xFF21317D) : Color(0xFFE7E9F1)
                                  ),

                                  child: Center(
                                    child: Text("Credit Card",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: selectedTabTrend == 2
                                                ? Colors.white
                                                : Colors.black)),
                                  )

                              ),
                            ),


                            SizedBox(width: 10),

                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTabTrend = 3;
                                });
                              },
                              child: Container(
                                  height: 38,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: selectedTabTrend == 3 ? Color(
                                          0xFF21317D) : Color(0xFFE7E9F1)
                                  ),

                                  child: Center(
                                    child: Text("Retail + Credit Card",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: selectedTabTrend == 3
                                                ? Colors.white
                                                : Colors.black)),
                                  )

                              ),
                            ),


                          ],
                        ),

                        const SizedBox(height: 20),


                        selectedTabTrend == 1 ?

                        Container(
                          height: 40,
                          child: ListView.builder(
                              itemCount: collectionAgencyTrendList[0]["six_month_data"]
                                  .length,
                              scrollDirection: Axis.horizontal,

                              itemBuilder: (BuildContext context, int pos) {
                                return Row(
                                  children: [
                                    /*  Color(0xFF3ADA53)
                               Color(0xFF52CEF5)*/
                                    Container(
                                      width: 50,
                                      height: 37,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              3),
                                          color:
                                          collectionAgencyTrendList[0]["six_month_data"][pos]["retail_average_score_percentage"] ==
                                              0 ?

                                          Color(0xFF6C757D) :

                                          collectionAgencyTrendList[0]["six_month_data"][pos]["retail_average_score_percentage"] <
                                              50 ?

                                          Color(0xFFF7476B) :

                                          collectionAgencyTrendList[0]["six_month_data"][pos]["retail_average_score_percentage"] >
                                              50 &&
                                              collectionAgencyTrendList[0]["six_month_data"][pos]["retail_average_score_percentage"] <
                                                  70 ?
                                          Color(0xFF52CEF5) :
                                          Color(0xFF3ADA53)


                                      ),
                                      child: Center(
                                        child: Text(
                                            collectionAgencyTrendList[0]["six_month_data"][pos]["retail_average_score_percentage"]
                                                .toStringAsFixed(0) + "%",
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
                        ) :

                        selectedTabTrend == 2 ? Container(
                          height: 40,
                          child: ListView.builder(
                              itemCount: collectionAgencyTrendList[0]["six_month_data"]
                                  .length,
                              scrollDirection: Axis.horizontal,

                              itemBuilder: (BuildContext context, int pos) {
                                return Row(
                                  children: [
                                    /*  Color(0xFF3ADA53)
                               Color(0xFF52CEF5)*/
                                    Container(
                                      width: 50,
                                      height: 37,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              3),
                                          color:
                                          collectionAgencyTrendList[0]["six_month_data"][pos]["card_average_score_percentage"] ==
                                              0 ?

                                          Color(0xFF6C757D) :

                                          collectionAgencyTrendList[0]["six_month_data"][pos]["card_average_score_percentage"] <
                                              50 ?

                                          Color(0xFFF7476B) :

                                          collectionAgencyTrendList[0]["six_month_data"][pos]["card_average_score_percentage"] >=
                                              50 &&
                                              collectionAgencyTrendList[0]["six_month_data"][pos]["card_average_score_percentage"] <=
                                                  70 ?
                                          Color(0xFF52CEF5) :
                                          Color(0xFF3ADA53)


                                      ),
                                      child: Center(
                                        child: Text(
                                            collectionAgencyTrendList[0]["six_month_data"][pos]["card_average_score_percentage"]
                                                .toStringAsFixed(0) + "%",
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
                        ) :
                        Container(
                          height: 40,
                          child: ListView.builder(
                              itemCount: collectionAgencyTrendList[0]["six_month_data"]
                                  .length,
                              scrollDirection: Axis.horizontal,

                              itemBuilder: (BuildContext context, int pos) {
                                return Row(
                                  children: [
                                    /*  Color(0xFF3ADA53)
                               Color(0xFF52CEF5)*/
                                    Container(
                                      width: 50,
                                      height: 37,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              3),
                                          color:
                                          collectionAgencyTrendList[0]["six_month_data"][pos]["retails_card_average_score_percentage"] ==
                                              0 ?

                                          Color(0xFF6C757D) :

                                          collectionAgencyTrendList[0]["six_month_data"][pos]["retails_card_average_score_percentage"] <
                                              50 ?

                                          Color(0xFFF7476B) :

                                          collectionAgencyTrendList[0]["six_month_data"][pos]["retails_card_average_score_percentage"] >=
                                              50 &&
                                              collectionAgencyTrendList[0]["six_month_data"][pos]["retails_card_average_score_percentage"] <=
                                                  70 ?
                                          Color(0xFF52CEF5) :
                                          Color(0xFF3ADA53)


                                      ),
                                      child: Center(
                                        child: Text(
                                            collectionAgencyTrendList[0]["six_month_data"][pos]["retails_card_average_score_percentage"]
                                                .toStringAsFixed(0) + "%",
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
                        )

                        ,


                        const SizedBox(height: 12),
                      ],
                    ),
                  ),


                  SizedBox(height: 15),

                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: const Color(0xFF2C68C9).withOpacity(0.10),
                    child: Row(
                      children: [
                        const SizedBox(width: 7),
                        const Text("National Collection Manager",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>
                                    ManagerScreen(collectionManagerList)));
                          },
                          child: Container(
                              height: 29,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1),
                                  color: const Color(0xFF21317D)),
                              child: const Center(
                                child: Text("View All",
                                    style:
                                    TextStyle(
                                        fontSize: 11, color: Colors.white)),
                              )),
                        ),
                        const SizedBox(width: 7),
                      ],
                    ),
                  ),
                  const SizedBox(height: 13),


                  collectionManagerList.length == 0 ?


                  Container(
                    height: 50,
                    child: Center(
                      child: Text("No data found!"),
                    ),
                  ) :


                  ListView.builder(
                      itemCount: collectionManagerList.length > 2
                          ? 2
                          : collectionManagerList.length,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int pos) {
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
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                  collectionManagerList[pos]["manager_name"],
                                                  style: TextStyle(
                                                      fontSize: 19,
                                                      fontWeight: FontWeight
                                                          .w600,
                                                      color: Colors.black)),
                                              SizedBox(height: 5),
                                              Text("Collection Manager",
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Color(
                                                          0xFF929292))),
                                            ],
                                          ),
                                        ),


                                        SizedBox(width: 10),
                                        Column(
                                          children: [
                                            Text(
                                                collectionManagerList[pos]["audit_count"]
                                                    .toString(),
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
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    child: Divider(
                                      color: Colors.grey.withOpacity(0.2),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Row(
                                      children: [

                                        SizedBox(width: 5),


                                        Expanded(
                                          flex: 1,
                                          child: Text("Retail",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF21317D))),
                                        ),


                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              Text("Pending",
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black)),
                                              SizedBox(height: 5),
                                              Text(
                                                  collectionManagerList[pos]["retail_pending"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Color(
                                                          0xFF52CEF5))),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          width: 1,
                                          height: 20,
                                          color: Colors.grey.withOpacity(0.3),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              Text("Reject",
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black)),
                                              SizedBox(height: 5),
                                              Text(
                                                  collectionManagerList[pos]["retail_rejected"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Colors.red)),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          width: 1,
                                          height: 20,
                                          color: Colors.grey.withOpacity(0.3),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              Text("Approved",
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black)),
                                              SizedBox(height: 5),
                                              Text(
                                                  collectionManagerList[pos]["retail_approved"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Color(
                                                          0xFF3ADA53))),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),


                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 50, right: 15),
                                    child: Divider(
                                      color: Colors.grey.withOpacity(0.2),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Row(
                                      children: [

                                        SizedBox(width: 5),


                                        Expanded(
                                          flex: 1,
                                          child: Text("Credit Card",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF21317D))),
                                        ),


                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              Text("Pending",
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black)),
                                              SizedBox(height: 5),
                                              Text(
                                                  collectionManagerList[pos]["credit_card_pending"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Color(
                                                          0xFF52CEF5))),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          width: 1,
                                          height: 20,
                                          color: Colors.grey.withOpacity(0.3),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              Text("Reject",
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black)),
                                              SizedBox(height: 5),
                                              Text(
                                                  collectionManagerList[pos]["credit_card_rejected"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Colors.red)),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          width: 1,
                                          height: 20,
                                          color: Colors.grey.withOpacity(0.3),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              Text("Approved",
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black)),
                                              SizedBox(height: 5),
                                              Text(
                                                  collectionManagerList[pos]["credit_card_approved"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Color(
                                                          0xFF3ADA53))),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 50, right: 15),
                                    child: Divider(
                                      color: Colors.grey.withOpacity(0.2),
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Row(
                                      children: [

                                        SizedBox(width: 5),


                                        Expanded(
                                          flex: 1,
                                          child: Text("Retail + Credit Card",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF21317D))),
                                        ),


                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              Text("Pending",
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black)),
                                              SizedBox(height: 5),
                                              Text(
                                                  collectionManagerList[pos]["retail_card_pending"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Color(
                                                          0xFF52CEF5))),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          width: 1,
                                          height: 20,
                                          color: Colors.grey.withOpacity(0.3),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              Text("Reject",
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black)),
                                              SizedBox(height: 5),
                                              Text(
                                                  collectionManagerList[pos]["retail_card_rejected"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Colors.red)),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          width: 1,
                                          height: 20,
                                          color: Colors.grey.withOpacity(0.3),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              Text("Approved",
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black)),
                                              SizedBox(height: 5),
                                              Text(
                                                  collectionManagerList[pos]["retail_card_approved"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Color(
                                                          0xFF3ADA53))),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),


                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 50, right: 15),
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


                ],
              ))
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInternet();
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Color(0xFFFEC502),
            value: double.parse(
                zoneWiseList[selectedIndex]["card_count"].toString()),
            title: '',
            badgeWidget: Text(
                zoneWiseList[selectedIndex]["card_count"].toString(),
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Color(0xFF4D93FD),
            value: double.parse(
                zoneWiseList[selectedIndex]["retail_card_count"].toString()),
            title: '',
            badgeWidget: Text(
                zoneWiseList[selectedIndex]["retail_card_count"].toString(),
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Color(0xFFF48FB1),
            value: double.parse(
                zoneWiseList[selectedIndex]["retail_count"].toString()),
            title: '',
            badgeWidget: Text(
                zoneWiseList[selectedIndex]["retail_count"].toString(),
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
/*        case 3:
          return PieChartSectionData(
            color: AppColors.contentColorGreen,
            value: 15,
            title: '',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );*/
        default:
          throw Error();
      }
    });
  }


  List<PieChartSectionData> showingSectionsGrades() {
    List<String> zonesList = ["East", "West", "North", "South"];

    List<dynamic> dummyList = [];


    if (gradesWiseDataList.length != 0) {
      bool eastExits = false;
      for (int i = 0; i < gradesWiseDataList.length; i++) {
        if (gradesWiseDataList[i]["region_name"] == "East") {
          eastExits = true;
          break;
        }
      }

      if (!eastExits) {
        dummyList.add({
          "grade": gradeSelected,
          "region_name": "East",
          "grade_count": 0
        });
      }
    }

    if (gradesWiseDataList.length != 0) {
      bool eastExits = false;
      for (int i = 0; i < gradesWiseDataList.length; i++) {
        if (gradesWiseDataList[i]["region_name"] == "West") {
          eastExits = true;
          break;
        }
      }

      if (!eastExits) {
        dummyList.add({
          "grade": gradeSelected,
          "region_name": "West",
          "grade_count": 0
        });
      }
    }

    if (gradesWiseDataList.length != 0) {
      bool eastExits = false;
      for (int i = 0; i < gradesWiseDataList.length; i++) {
        if (gradesWiseDataList[i]["region_name"] == "North") {
          eastExits = true;
          break;
        }
      }

      if (!eastExits) {
        dummyList.add({
          "grade": gradeSelected,
          "region_name": "North",
          "grade_count": 0
        });
      }
    }

    if (gradesWiseDataList.length != 0) {
      bool eastExits = false;
      for (int i = 0; i < gradesWiseDataList.length; i++) {
        if (gradesWiseDataList[i]["region_name"] == "South") {
          print("Matched");
          eastExits = true;
          break;
        }
      }

      if (!eastExits) {
        dummyList.add({
          "grade": gradeSelected,
          "region_name": "South",
          "grade_count": 0
        });
      }
    }

    gradesWiseDataList.addAll(dummyList);

    print("GGGG "+gradesWiseDataList.toString());


    double eastPercentage = 0.0;
    double westPercentage = 0.0;
    double northPercentage = 0.0;
    double southPercentage = 0.0;


    for (int i = 0; i < gradesWiseDataList.length; i++) {
      if (gradesWiseDataList[i]["region_name"] == "South") {
        southPercentage =
            double.parse(gradesWiseDataList[i]["grade_count"].toString());
      }

      if (gradesWiseDataList[i]["region_name"] == "West") {

        westPercentage =
            double.parse(gradesWiseDataList[i]["grade_count"].toString());
      }

      if (gradesWiseDataList[i]["region_name"] == "North") {
        northPercentage =
            double.parse(gradesWiseDataList[i]["grade_count"].toString());
      }

      if (gradesWiseDataList[i]["region_name"] == "East") {
        eastPercentage =
            double.parse(gradesWiseDataList[i]["grade_count"].toString());
      }

      print("NOPRTH "+northPercentage.toString());
      print("EAST "+eastPercentage.toString());


      if(eastPercentage==1)
        {
          eastPercentage=25;
        }

      else if(northPercentage==1)
      {
        northPercentage=25;
      }
      else if(westPercentage==1)
      {
        westPercentage=25;
      }
      else if(southPercentage==1)
      {
        southPercentage=25;
      }

      print("NOPRTH "+northPercentage.toString());
      print("EAST "+eastPercentage.toString());
    }


    return List.generate(gradesWiseDataList.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      int totalNorthCount=0;
      int totalSouthCount=0;
      int totalEastCount=0;
      int totalWestCount=0;


      for (int i = 0; i < gradesWiseDataList.length; i++) {
        if (gradesWiseDataList[i]["region_name"] == "South") {
          totalSouthCount= gradesWiseDataList[i]["grade_count"];
        }

        if (gradesWiseDataList[i]["region_name"] == "West") {

          totalWestCount= gradesWiseDataList[i]["grade_count"];
        }

        if (gradesWiseDataList[i]["region_name"] == "North") {
          totalNorthCount= gradesWiseDataList[i]["grade_count"];
        }

        if (gradesWiseDataList[i]["region_name"] == "East") {
          totalEastCount= gradesWiseDataList[i]["grade_count"];
        }


        int totalCount=totalWestCount+totalNorthCount+totalEastCount+totalSouthCount;

        eastPercentage=(totalEastCount*100)/totalCount;
        westPercentage=(totalWestCount*100)/totalCount;
        northPercentage=(totalNorthCount*100)/totalCount;
        southPercentage=(totalSouthCount*100)/totalCount;





      }














      switch (i) {



        case 0:
          return PieChartSectionData(
            color: Color(0xFFFEC502),
            value: westPercentage,
            title: '',
            badgeWidget: Container(
              transform: Matrix4.translationValues(10.0, 20.0, 0.0),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Color of the shadow
                    spreadRadius: 0, // Spread radius of the shadow
                    blurRadius: 5, // Blur radius of the shadow
                    offset: Offset(0, 0), // Offset of the shadow
                  ),
                ],
              ),


              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  /*  Text(westPercentage.toStringAsFixed(0)+'%',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFEC502))),
*/


                  Text('West:'+totalWestCount.toString(),
                      style: TextStyle(
                          fontSize: 10,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),

                ],
              ),
            ),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Color(0xFFD81B60),
            value: southPercentage,
            title: '',
            badgeWidget: Container(
              transform: Matrix4.translationValues(-10.0, 20.0, 0.0),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Color of the shadow
                    spreadRadius: 0, // Spread radius of the shadow
                    blurRadius: 5, // Blur radius of the shadow
                    offset: Offset(0, 0), // Offset of the shadow
                  ),
                ],
              ),


              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  /*  Text(southPercentage.toStringAsFixed(0)+'%',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFD81B60))),
*/


                  Text('South:'+totalSouthCount.toString(),
                      style: TextStyle(
                          fontSize: 10,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),

                ],
              ),
            ),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Color(0xFF4D93FD),
            value: northPercentage,
            title: '',
            badgeWidget: Container(
              transform: Matrix4.translationValues(-15.0, -10.0, 0.0),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Color of the shadow
                    spreadRadius: 0, // Spread radius of the shadow
                    blurRadius: 5, // Blur radius of the shadow
                    offset: Offset(0, 0), // Offset of the shadow
                  ),
                ],
              ),


              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  /*   Text(northPercentage.toStringAsFixed(0)+'%',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4D93FD))),*/


                  Text('North:'+totalNorthCount.toString(),
                      style: TextStyle(
                          fontSize: 10,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),

                ],
              ),
            ),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Color(0xFF61C667),
            value: eastPercentage,
            title: '',
            badgeWidget: Container(
              transform: Matrix4.translationValues(20.0, -10.0, 0.0),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Color of the shadow
                    spreadRadius: 0, // Spread radius of the shadow
                    blurRadius: 5, // Blur radius of the shadow
                    offset: Offset(0, 0), // Offset of the shadow
                  ),
                ],
              ),


              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  /*   Text(eastPercentage.toStringAsFixed(0)+'%',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF61C667))),*/


                  Text('East:'+totalEastCount.toString(),
                      style: TextStyle(
                          fontSize: 10,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),

                ],
              ),
            ),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }

  checkInternet() async {
    final List<ConnectivityResult> connectivityResult =
    await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {

    } else {
      fetchDashboardCount();
      getCollectionAgencyTrend(false);
      fetchTotalAuditsCount(false, false);
      fetchZoneWiseData(false, false);
      fetchGradeWiseData("A", false, false);
      fetchAuditAgencyData(false);
      fetchNCMData(false);
      fetchParameterData(false);
    }
  }

  fetchTotalAuditsCount(bool showDialog, bool applyFilter) async {
    overAllEnabled = true;

    if (showDialog) {
      APIDialog.showAlertDialog(context, "Please wait...");
    }
    else {
      setState(() {
        isLoading = true;
      });
    }


    var requestModel = {};

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();

    var response;

    if (applyFilter) {
      response = await helper.getWithHeader('getoverallAuditScore?start_date=' +
          startDateController.text.toString() + '&end_date=' +
          endDateController.text.toString(), requestModel, context);
    }
    else {
      response =
      await helper.getWithHeader('getoverallAuditScore', requestModel, context);
    }


    if (showDialog) {
      Navigator.pop(context);
    }
    else {
      setState(() {
        isLoading = false;
      });
    }


    var responseJSON = json.decode(response.body);
    print(responseJSON);

    overallAuditList = responseJSON["data"];


    setState(() {});
  }

  fetchAgencyWiseAudit(String selectedAgencyID, bool applyFilter) async {
    if (agencyWiseModifiedList.length != 0) {
      agencyWiseModifiedList.clear();
    }
    overAllEnabled = false;

    APIDialog.showAlertDialog(context, "Please wait...");


    var requestModel = {};

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();

    var response;

    if (applyFilter) {
      response = await helper.getWithHeader(
          'getoverallAuditScoreAgencyWise?start_date=' +
              startDateController.text.toString() + '&end_date=' +
              endDateController.text.toString(), requestModel, context);
    }
    else {
      response = await helper.getWithHeader(
          'getoverallAuditScoreAgencyWise', requestModel, context);
    }


    Navigator.pop(context);


    var responseJSON = json.decode(response.body);
    print(responseJSON);

    agencyWiseAuditList = responseJSON["data"];

    for (int i = 0; i < agencyWiseAuditList.length; i++) {
      //if(agencyWiseAuditList[i][""])

      for (int j = 0; j < agencyWiseAuditList[i]["agencies"].length; j++) {
        if (selectedOverAllDropValue ==
            agencyWiseAuditList[i]["agencies"][j]["name"]) {
          agencyWiseModifiedList.add(agencyWiseAuditList[i]["agencies"][j]);
          print("MATTT");
        }
      }
    }

    print("***");
    print(agencyWiseModifiedList.toString());


    setState(() {});
  }

  //getCollectionAgencyTrend
  fetchDashboardCount() async {
    if (overAllDropListAsString.length != 0) {
      overAllDropListAsString.clear();
    }

    overAllDropListAsString.add("Overall Data");

    setState(() {
      isLoading = true;
    });
    var requestModel = {};

    print(requestModel);

    //        await helper.getWithHeader('client_dashboard_counts?start_date=2024-11-30&end_date=2023-12-12', requestModel, context);
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.getWithHeader(
        'client_dashboard_counts', requestModel, context);
    setState(() {
      isLoading = false;
    });
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    dashboardCountData = responseJSON["data"];
    dashboardCountDataCopy = responseJSON["data"];
    overAllDropList = dashboardCountData["totalAllocationByAgency"];

    for (int i = 0; i < overAllDropList.length; i++) {
      overAllDropListAsString.add(overAllDropList[i]["process_review_agency"]);
    }


    setState(() {});
  }

  fetchDashboardCountFilter() async {
    if (overAllDropListAsString.length != 0) {
      overAllDropListAsString.clear();
    }

    overAllDropListAsString.add("Overall Data");
    setState(() {
      isLoading = true;
    });
    var requestModel = {};

    print(requestModel);

    //        await helper.getWithHeader('client_dashboard_counts?start_date=2024-11-30&end_date=2023-12-12', requestModel, context);
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.getWithHeader('client_dashboard_counts?start_date=' +
        startDateController.text.toString() + '&end_date=' +
        endDateController.text.toString(), requestModel, context);

    setState(() {
      isLoading = false;
    });
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    dashboardCountData = responseJSON["data"];
    overAllDropList = dashboardCountData["totalAuditCompletedByAgency"];
    for (int i = 0; i < overAllDropList.length; i++) {
      overAllDropListAsString.add(overAllDropList[i]["process_review_agency"]);
    }
    setState(() {});
  }

  getCollectionAgencyTrend(bool applyFilter) async {
    setState(() {
      isLoading = true;
    });
    var requestModel = {};

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response;

    if (applyFilter) {
      response = await helper.getWithHeader(
          'getCollectionAgencyTrend?start_date=' +
              startDateController.text.toString() + '&end_date=' +
              endDateController.text.toString(), requestModel, context);
    }
    else {
      response = await helper.getWithHeader(
          'getCollectionAgencyTrend', requestModel, context);
    }


    setState(() {
      isLoading = false;
    });
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    collectionAgencyTrendList = responseJSON["data"]["collectionAgencyScores"];
    setState(() {});
  }

  fetchNCMData(bool applyFilter) async {
    var requestModel = {};

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response;
    if (applyFilter) {
      response = await helper.getWithHeader(
          'nationalCollectionManagerData?start_date=' +
              startDateController.text.toString() + '&end_date=' +
              endDateController.text.toString(), {}, context);
    }
    else {
      response =
      await helper.getWithHeader('nationalCollectionManagerData', {}, context);
    }


    var responseJSON = json.decode(response.body);
    print(responseJSON);

    collectionManagerList = responseJSON["data"];

    setState(() {});
  }

  //getAuditAgencyData


  fetchParameterData(bool applyFilter) async {
    var requestModel = {};

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();


    var response;
    if (applyFilter) {
      response = await helper.getWithHeader('parameterWiseScore?start_date=' +
          startDateController.text.toString() + '&end_date=' +
          endDateController.text.toString(), requestModel, context);
    }
    else {
      response = await helper.getWithHeader('parameterWiseScore', {}, context);
    }


    var responseJSON = json.decode(response.body);
    print(responseJSON);

    parameterWiseList = responseJSON["data"];

    setState(() {});
  }

  fetchAuditAgencyData(bool applyFilter) async {
    if(auditAgencyList.length!=0)
      {
        auditAgencyList.clear();
      }
    var requestModel = {};

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();

    var response;
    if (applyFilter) {
      response = await helper.getWithHeader('getAuditAgencyData?start_date=' +
          startDateController.text.toString() + '&end_date=' +
          endDateController.text.toString(), {}, context);
    }
    else {
      response = await helper.getWithHeader('getAuditAgencyData', {}, context);
    }


    var responseJSON = json.decode(response.body);
    print("AUDIT AGENCY");
    print(responseJSON);

    if(responseJSON["data"].isNotEmpty)
      {
        Map<String, dynamic> agencyData = responseJSON["data"];

        List<String> newList = agencyData.keys.toList();

        for (int i = 0; i < newList.length; i++) {
          Map<String, dynamic> data = {};
          for (int j = 0; j < agencyData[newList[i]].length; j++) {
            data.addAll(agencyData[newList[i]][j]);
          }

          print("DATA VALUE IS " + data.toString());
          auditAgencyList.add(data);
        }
      }



    log("NEW LIST IS " + auditAgencyList.toString());


    setState(() {});
  }


  fetchZoneWiseData(bool showDialog, bool applyFilter) async {
    if (showDialog) {
      APIDialog.showAlertDialog(context, "Please wait...");
    }


    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.getWithHeader('getZoneWiseData', {}, context);


    if (applyFilter) {
      response = await helper.getWithHeader(
          'getZoneWiseData?start_date=' + startDateController.text.toString() +
              '&end_date=' + endDateController.text.toString(), {}, context);
    }
    else {
      response = await helper.getWithHeader('getZoneWiseData', {}, context);
    }


    var responseJSON = json.decode(response.body);
    print(responseJSON);


    zoneWiseList = responseJSON["data"]["databyZoneRegion"];

    if (showDialog) {
      Navigator.pop(context);
    }
    setState(() {});
  }

  fetchGradeWiseData(String grade, bool showDialog, bool applyFilter) async {
    if (showDialog) {
      APIDialog.showAlertDialog(context, "Please wait...");
    }

    if (gradesWiseDataList.length != 0) {
      gradesWiseDataList.clear();
    }

    var requestModel = {

      "grade": grade
    };

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.getWithHeader(
        'gradeWiseData?grade=' + grade.toString(), requestModel, context);

    if (applyFilter) {
      response = await helper.getWithHeader(
          'gradeWiseData?start_date=' + startDateController.text.toString() +
              '&end_date=' + endDateController.text.toString() + "&grade=" +
              grade.toString(), requestModel, context);
    }
    else {
      response = await helper.getWithHeader(
          'gradeWiseData?grade=' + grade.toString(), requestModel, context);
    }


    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (showDialog) {
      Navigator.pop(context);
    }
    gradesWiseDataList = responseJSON["data"]["data"];
    setState(() {});
  }

  void calenderBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, bottomSheetState) {
          return Container(
            padding: const EdgeInsets.all(10),
            // height: 600,

            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              // Set the corner radius here
              color: Colors.white, // Example color for the container
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Center(
                  child: Container(
                    height: 6,
                    width: 62,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 5),
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text("Select Date",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),
                    ),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset("assets/cross_ic.png",
                            width: 30, height: 30)),
                    const SizedBox(width: 4),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2100));

                        if (pickedDate != null) {
                          String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                          startDate = pickedDate;
                          startDateController.text = formattedDate.toString();
                          setState(() {});
                        }
                      },
                      child: CalenderTextFieldWidget(
                        "Start Date",
                        "",
                        startDateController,
                        null,
                        enabled: false,
                        suffixIconExists: 1,
                      )),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2100));

                        if (pickedDate != null) {
                          String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);

                          endDate = pickedDate;

                          endDateController.text = formattedDate.toString();
                          setState(() {});
                        }
                      },
                      child: CalenderTextFieldWidget(
                        "End Date",
                        "",
                        endDateController,
                        null,
                        enabled: false,
                        suffixIconExists: 1,
                      )),
                ),
                const SizedBox(height: 25),
                Card(
                  elevation: 4,
                  shadowColor: Colors.grey,
                  margin: const EdgeInsets.symmetric(horizontal: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    height: 51,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white), // background
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppTheme.themeColor), // fore
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ))),
                      onPressed: () {
                        if (startDate == null) {
                          Toast.show("Please select Start Date ",
                              duration: Toast.lengthLong,
                              gravity: Toast.bottom,
                              backgroundColor: Colors.red);
                        }
                        else if (endDate == null) {
                          Toast.show("Please select End Date",
                              duration: Toast.lengthLong,
                              gravity: Toast.bottom,
                              backgroundColor: Colors.red);
                        }


                        else if (startDate!.isAfter(endDate!)) {
                          Toast.show("Start date must be less than End date ",
                              duration: Toast.lengthLong,
                              gravity: Toast.bottom,
                              backgroundColor: Colors.red);
                        } else {
                          Navigator.pop(context);

                          fetchDashboardCountFilter();
                          getCollectionAgencyTrend(true);
                          fetchTotalAuditsCount(false, true);
                          fetchZoneWiseData(false, true);
                          fetchGradeWiseData("A", false, true);
                          fetchAuditAgencyData(true);
                          fetchNCMData(true);
                          fetchParameterData(true);
                        }
                      },
                      child: const Text(
                        'Proceed',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          );
        });
      },
    );
  }

  _showAlertDialog(){
    showDialog(context: context, builder: (ctx)=> AlertDialog(
      title: const Text("Logout",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 18),),
      content: const Text("Are you sure you want to Logout ?",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16,color: Colors.black),),
      actions: <Widget>[
        TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              SharedPreferences preferences = await SharedPreferences
                  .getInstance();
              await preferences.clear();
              Toast.show('Logged out successfully!',
                  duration: Toast.lengthLong,
                  gravity: Toast.bottom,
                  backgroundColor: Colors.blue);

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.themeColor,
              ),
              height: 45,
              padding: const EdgeInsets.all(10),
              child: const Center(child: Text("Logout",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
            )
        ),
        TextButton(
            onPressed: (){
              Navigator.of(ctx).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.grayColor,
              ),
              height: 45,
              padding: const EdgeInsets.all(10),
              child: const Center(child: Text("Cancel",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
            )
        )
      ],
    ));
  }
}

class BoxShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(100, 100);

    final p1 = Offset(50, 50);
    final p2 = Offset(80, 50);
    final p3 = Offset(80, 50);
    final paint = Paint()
      ..color = Color(0xFF707070)
      ..strokeWidth = 1;
    canvas.drawLine(p1, p2, paint);
    //  canvas.drawLine(p2, p3, paint);

    // path.lineTo(0.0, 0.0);

    path.close();


    Paint paintBorder = Paint()
      ..color = Color(0xFF707070)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    // canvas.drawColor(Colors.green, BlendMode.darken);
    canvas.drawPath(path, paintBorder);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}