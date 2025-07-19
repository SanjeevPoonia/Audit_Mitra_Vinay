
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:intl/intl.dart';
import 'package:qaudit_tata_flutter/network/api_dialog.dart';
import 'package:qaudit_tata_flutter/network/api_helper.dart';
import 'package:qaudit_tata_flutter/network/loader.dart';
import 'package:qaudit_tata_flutter/utils/app_modal.dart';
import 'package:qaudit_tata_flutter/utils/app_theme.dart';
import 'package:qaudit_tata_flutter/view/all_dashboard/client_home_screen.dart';
import 'package:qaudit_tata_flutter/view/assigned_audit_details.dart';
import 'package:qaudit_tata_flutter/view/assigned_audit_list.dart';
import 'package:qaudit_tata_flutter/view/audit_form_screen.dart';
import 'package:qaudit_tata_flutter/view/home_screen.dart';
import 'package:qaudit_tata_flutter/view/menu_screen.dart';
import 'package:qaudit_tata_flutter/view/saved_audit_list.dart';
import 'package:qaudit_tata_flutter/view/submit_audit_list.dart';
import 'package:qaudit_tata_flutter/view/zoom_scaffold.dart' as MEN;

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../../network/Utils.dart';
import '../../widgets/dashboard_widget.dart';
class QAHomeScreen extends StatefulWidget
{
  LandingState createState()=>LandingState();
}

class LandingState extends State<QAHomeScreen> with TickerProviderStateMixin
{
  int selectedIndex = 0;
  MEN.MenuController? menuController;
  bool isLoading=false;
  List<dynamic> auditList=[];
  String? profileImageUrl;
  List<dynamic> questionList=[];
  final ZoomDrawerController controller = ZoomDrawerController();
  var startDateController=TextEditingController();
  var endDateController=TextEditingController();
  int pendingAudit=0;
  DateTime? startDate;
  DateTime? endDate;
  List<dynamic> assignedAudits=[];
  List<dynamic> arrSavedAuditList=[];
  List<dynamic> completedAuditList=[];
  List<String> filterList = [
    "Current Month",
    "Custom Date"
  ];
  String selectedFilter = "Current Month";

  String assignedAuditsCount="0";
  String pendingAuditsCount="0";
  String submittedAuditsCount="0";
  String savedAuditsCount="0";


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child:ChangeNotifierProvider(
        create: (context) => menuController,
        child: MEN.ZoomScaffold(
          menuScreen:  MenuScreen(),
          showBoxes: true,
          orangeTheme: false,
          pageTitle: "My Dashboard",
          contentScreen: MEN.Layout(
              contentBuilder: (cc) => Column(
                children: [

                  SizedBox(height:20),

                 Expanded(child:

                     isLoading?

                         Center(
                           child: Loader(),
                         ):



                 Container(
                   color: Colors.white,
                   child: RefreshIndicator(
                     onRefresh: _pullRefresh,
                     child: ListView(
                       children: [


                         SizedBox(height: 13),

                         Container(
                           height: 55,
                           color: const Color(0xFF2C68C9).withOpacity(0.10),
                           margin: const EdgeInsets.symmetric(horizontal: 8),
                           child: Row(
                             children: [

                               SizedBox(width: 10),

                               Text(
                                   'Filter',
                                   style: TextStyle(
                                     fontSize: 15,
                                     fontWeight:
                                     FontWeight.w600,
                                     color: Colors.black
                                         .withOpacity(
                                         0.9),
                                   )),

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

                                         fetchDashboardData(false);


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


                         SizedBox(height: 10),

                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 9),
                           child: Row(
                             children: [
                               Expanded(flex: 1, child: InkWell(

                                   onTap: (){

                                  //   Navigator.push(context, MaterialPageRoute(builder: (context)=>AssignedAuditsScreen()));

                                   },






                                   child:    Container(
                                     padding: EdgeInsets.all(5),
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(15),
                                       color: Color(0xFfe6f2ff),
                                     ),
                                     height: 110,
                                     child: Stack(
                                       children: [

                                         Row(
                                           children: [


                                             Spacer(),
                                             Container(
                                                 transform: Matrix4.translationValues(5.0, -8.0, 0.0),
                                                 child: Image.asset("assets/assigned_ic.png",width: 93,height: 111,))
                                           ],
                                         ),

                                         Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [

                                             SizedBox(height: 9),


                                             Padding(
                                               padding:  EdgeInsets.only(left: 5),
                                               child: Text("Total Assigned\nAudits",style: TextStyle(
                                                 fontSize: 15.0,
                                                 fontWeight: FontWeight.w500,
                                                 color: Colors.black,
                                               )),
                                             ),
                                             SizedBox(height: 10),
                                             Padding(
                                               padding: const EdgeInsets.only(left: 5),
                                               child: Text(assignedAuditsCount,style: TextStyle(
                                                 fontSize: 24.0,
                                                 fontWeight: FontWeight.w600,
                                                 color: AppTheme.themeColor,
                                               )),
                                             ),










                                           ],
                                         ),
                                       ],
                                     ),
                                   ))),

                               SizedBox(width: 12),
                               Expanded(flex: 1, child: InkWell(
                                   onTap: (){
                                   //  Navigator.push(context, MaterialPageRoute(builder: (context)=>SavedAuditListScreen()));

                                   },

                                   child:  Container(
                                     padding: EdgeInsets.all(5),
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(15),
                                       color: Color(0xFfe6f2ff),
                                     ),
                                     height: 110,
                                     child: Stack(
                                       children: [

                                         Row(
                                           children: [


                                             Spacer(),
                                             Container(
                                                 transform: Matrix4.translationValues(9.0, -5.0, 0.0),
                                                 child: Image.asset("assets/pen_audit_ic.png",width: 93,height: 111,))
                                           ],
                                         ),

                                         Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [

                                             SizedBox(height: 9),


                                             Padding(
                                               padding:  EdgeInsets.only(left: 5),
                                               child: Text("Total Pending\nAudits",style: TextStyle(
                                                 fontSize: 15.0,
                                                 fontWeight: FontWeight.w500,
                                                 color: Colors.black,
                                               )),
                                             ),
                                             SizedBox(height: 10),
                                             Padding(
                                               padding: const EdgeInsets.only(left: 5),
                                               child: Text(pendingAuditsCount,style: TextStyle(
                                                 fontSize: 24.0,
                                                 fontWeight: FontWeight.w600,
                                                 color: AppTheme.themeColor,
                                               )),
                                             ),










                                           ],
                                         ),
                                       ],
                                     ),
                                   ))),
                             ],
                           ),
                         ),

                         SizedBox(height: 10),

                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 9),
                           child: Row(
                             children: [
                               Expanded(flex: 1, child: InkWell(

                                   onTap: (){
                                   //  Navigator.push(context, MaterialPageRoute(builder: (context)=>SubmitAuditListScreen()));

                                   },

                                   child:  Container(
                                     padding: EdgeInsets.all(5),
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(15),
                                       color: Color(0xFfe6f2ff),
                                     ),
                                     height: 110,
                                     child: Stack(
                                       children: [

                                         Row(
                                           children: [


                                             Spacer(),
                                             Container(
                                                 transform: Matrix4.translationValues(5.0, -11.0, 0.0),
                                                 child: Image.asset("assets/tiles_5.png",width: 93,height: 111,))
                                           ],
                                         ),

                                         Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [

                                             SizedBox(height: 9),


                                             Padding(
                                               padding:  EdgeInsets.only(left: 5),
                                               child: Text("Total Submitted\nAudits",style: TextStyle(
                                                 fontSize: 15.0,
                                                 fontWeight: FontWeight.w500,
                                                 color: Colors.black,
                                               )),
                                             ),
                                             SizedBox(height: 10),
                                             Padding(
                                               padding: const EdgeInsets.only(left: 5),
                                               child: Text(submittedAuditsCount,style: TextStyle(
                                                 fontSize: 24.0,
                                                 fontWeight: FontWeight.w600,
                                                 color: AppTheme.themeColor,
                                               )),
                                             ),










                                           ],
                                         ),
                                       ],
                                     ),
                                   ))),

                               SizedBox(width: 12),
                               Expanded(flex: 1, child: InkWell(

                                   onTap: (){
                                  //   Navigator.push(context, MaterialPageRoute(builder: (context)=>SubmitAuditListScreen()));

                                   },

                                   child:  Container(
                                     padding: EdgeInsets.all(5),
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(15),
                                       color: Color(0xFfe6f2ff),
                                     ),
                                     height: 110,
                                     child: Stack(
                                       children: [

                                         Row(
                                           children: [


                                             Spacer(),
                                             Container(
                                                 transform: Matrix4.translationValues(6.0, -4.0, 0.0),
                                                 child: Image.asset("assets/card4.png",width: 93,height: 90,opacity: const AlwaysStoppedAnimation(.2)))
                                           ],
                                         ),

                                         Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [

                                             SizedBox(height: 9),


                                             Padding(
                                               padding:  EdgeInsets.only(left: 5),
                                               child: Text("Total Saved\nAudits",style: TextStyle(
                                                 fontSize: 15.0,
                                                 fontWeight: FontWeight.w500,
                                                 color: Colors.black,
                                               )),
                                             ),
                                             SizedBox(height: 10),
                                             Padding(
                                               padding: const EdgeInsets.only(left: 5),
                                               child: Text(savedAuditsCount,style: TextStyle(
                                                 fontSize: 24.0,
                                                 fontWeight: FontWeight.w600,
                                                 color: AppTheme.themeColor,
                                               )),
                                             ),










                                           ],
                                         ),
                                       ],
                                     ),
                                   ))),
                             ],
                           ),
                         ),















                       ],
                     ),
                   ),
                 ))




                ],
              )),
        ),
      ),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInternet();

    menuController = MEN.MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }


  checkInternet()async{
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());

    if(connectivityResult.contains(ConnectivityResult.none))
    {

    }
    else
      {

        fetchDashboardData(false);
      }
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


                          fetchDashboardData(true);
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
    completedAuditList = responseJSON['data'];
    pendingAudit=assignedAudits.length-completedAuditList.length;
    print(responseJSON);
    setState(() {
      isLoading=false;
    });

    // completedAuditList=responseJSON["data"];
    setState(() {

    });

  }
  savedAuditList(BuildContext context) async {
    setState(() {
      isLoading=true;
    });
    var data = {
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('savedAuditList', data, context);
    var responseJSON = json.decode(response.body);
    arrSavedAuditList = responseJSON['data'];
    setState(() {
      isLoading=false;
    });
    print(responseJSON);
    setState(() {

    });

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

    pendingAudit=assignedAudits.length-completedAuditList.length;


    setState(() {
      isLoading=false;
    });
    print(responseJSON);





    setState(() {

    });

  }
  fetchDashboardData(bool applyFilter) async {
    setState(() {
      isLoading=true;
    });
    var requestModel = {};

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response;
    if (applyFilter) {
      response = await helper.getWithHeader(
          'auditorDashboardCount?start_date=' +
              startDateController.text.toString() + '&end_date=' +
              endDateController.text.toString(), {}, context);
    }
    else {
      response =
      await helper.getWithHeader('auditorDashboardCount', {}, context);
    }


    var responseJSON = json.decode(response.body);

    setState(() {
      isLoading=false;
    });

    assignedAuditsCount=responseJSON["data"]["totalAssign"].toString();
    pendingAuditsCount=responseJSON["data"]["totalPending"].toString();
    submittedAuditsCount=responseJSON["data"]["totalCompletedAudits"].toString();
    savedAuditsCount=responseJSON["data"]["totalSavedAudits"].toString();

    print(responseJSON);


    setState(() {

    });
  }


  Future<void> _pullRefresh() async {

    checkInternet();

  }
}

