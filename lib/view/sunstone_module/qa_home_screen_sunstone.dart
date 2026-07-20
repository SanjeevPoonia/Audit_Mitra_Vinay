import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:intl/intl.dart';
import 'package:qaudit_tata_flutter/network/api_helper.dart';
import 'package:qaudit_tata_flutter/network/loader.dart';
import 'package:qaudit_tata_flutter/utils/app_modal.dart';
import 'package:qaudit_tata_flutter/utils/app_theme.dart';
import 'package:qaudit_tata_flutter/view/sunstone_module/qa_main_menu.dart';
import 'package:qaudit_tata_flutter/view/zoom_scaffold.dart' as MEN;
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../network/Utils.dart';
import '../../widgets/dashboard_widget.dart';
class QAHomeScreenSunStone extends StatefulWidget
{
  LandingState createState()=>LandingState();
}
class LandingState extends State<QAHomeScreenSunStone> with TickerProviderStateMixin
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
  List<dynamic> auditCycleList=[];
  String? selectedAuditCycle;
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
          menuScreen:  QAMenuScreen(),
          showBoxes: true,
          orangeTheme: false,
          pageTitle: "Dashboard",//"My Dashboard",
          contentScreen: MEN.Layout(
              contentBuilder: (cc) => Column(
                children: [

                  Expanded(

                    child:

                    isLoading

                        ?  Center(
                      child: Loader(),
                    )

                        : RefreshIndicator(

                      onRefresh: _pullRefresh,

                      child: ListView(

                        padding: const EdgeInsets.all(16),

                        children: [

                          SizedBox(height: 10,),

                          /// USER DASHBOARD CARD

                          Container(

                            padding: const EdgeInsets.all(20),

                            decoration: BoxDecoration(

                              gradient:
                              const LinearGradient(

                                colors: [

                                  Color(0xFF4F46E5),
                                  Color(0xFF7C3AED),
                                ],
                              ),

                              borderRadius:
                              BorderRadius.circular(25),
                            ),

                            child: Column(

                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [

                                const Text(

                                  "Audit Dashboard",

                                  style: TextStyle(

                                    fontSize: 22,

                                    fontWeight:
                                    FontWeight.bold,

                                    color:
                                    Colors.white,
                                  ),
                                ),

                                const SizedBox(
                                    height: 8),

                                Text(

                                  selectedFilter,

                                  style: TextStyle(

                                    color:
                                    Colors.white
                                        .withOpacity(
                                        .85),
                                  ),
                                ),

                                const SizedBox(
                                    height: 18),

                                IntrinsicHeight(

                                  child: Row(

                                    children: [

                                      Expanded(

                                        child:
                                        _smallMetric(

                                          Icons.assignment,

                                          "Assigned",

                                          assignedAuditsCount,
                                        ),
                                      ),

                                      const SizedBox(
                                          width: 12),

                                      Expanded(

                                        child:
                                        _smallMetric(

                                          Icons.pending_actions,

                                          "Pending",

                                          pendingAuditsCount,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),

                          const SizedBox(
                              height: 20),

                          /// FILTER CARD

                          Container(

                            padding:
                            const EdgeInsets.all(
                                16),

                            decoration:
                            BoxDecoration(

                              color:
                              Colors.white,

                              borderRadius:
                              BorderRadius.circular(
                                  20),

                              boxShadow: [

                                BoxShadow(

                                  color:
                                  Colors.black
                                      .withOpacity(
                                      .04),

                                  blurRadius:
                                  15,

                                  offset:
                                  const Offset(
                                      0,
                                      5),
                                )
                              ],
                            ),

                            child: Row(

                              children: [

                                const Icon(

                                  Icons.filter_alt,

                                  color:
                                  Color(
                                      0xFF4F46E5),
                                ),

                                const SizedBox(
                                    width: 10),

                                const Text(

                                  "Filter",

                                  style:
                                  TextStyle(

                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),

                                const Spacer(),

                                /*SizedBox(

                                  width: 170,

                                  child:
                                  DropdownButtonHideUnderline(

                                    child:
                                    DropdownButton2(

                                      isExpanded:
                                      true,

                                      value:
                                      selectedFilter,

                                      items:
                                      filterList.map(

                                              (item){

                                            return DropdownMenuItem(

                                              value:
                                              item,

                                              child:
                                              Text(
                                                  item),
                                            );
                                          }

                                      ).toList(),

                                      onChanged:
                                          (value){

                                        selectedFilter =
                                            value
                                                .toString();

                                        setState(() {

                                        });

                                        if(selectedFilter==
                                            "Current Month"){

                                          fetchDashboardData(
                                              false);
                                        }
                                        else{

                                          startDateController
                                              .clear();

                                          endDateController
                                              .clear();

                                          calenderBottomSheet(
                                              context);
                                        }
                                      },
                                    ),
                                  ),
                                )*/
                                SizedBox(

                                  width: 170,

                                  child: DropdownButtonHideUnderline(

                                    child: DropdownButton2<String>(

                                      isExpanded: true,

                                      value: selectedAuditCycle,

                                      items: auditCycleList.map<DropdownMenuItem<String>>((item) {

                                        return DropdownMenuItem<String>(

                                          value: item['name']?.toString(),

                                          child: Text(
                                            item['name']?.toString() ?? '',
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );

                                      }).toList(),

                                      onChanged: (value) {
                                        if (value == null) return;
                                        setState(() {
                                          selectedAuditCycle = value;
                                        });
                                        /// Get selected cycle object
                                        final selectedCycle = auditCycleList.firstWhere(
                                              (e) => e['name'] == value,
                                          orElse: () => {},
                                        );
                                        print("Selected Cycle Id : ${selectedCycle['id']}");
                                        print("Selected Cycle Name : ${selectedCycle['name']}");
                                        /// Call dashboard API with selected cycle
                                        fetchDashboardData(true,selectedCycle['id']?.toString() ?? "",);
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                          const SizedBox(
                              height:20),

                          /// METRICS GRID

                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 1.15,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            children: [
                              _dashboardCard(
                                "Assigned",
                                assignedAuditsCount,
                                Icons.assignment,
                                const Color(
                                    0xFFE8F0FF),
                              ),

                              _dashboardCard(
                                "Pending",
                                pendingAuditsCount,
                                Icons.pending_actions,
                                const Color(
                                    0xFFFFF4E5),
                              ),

                              _dashboardCard(
                                "Submitted",
                                submittedAuditsCount,
                                Icons.task_alt,
                                const Color(
                                    0xFFE9FFF1),
                              ),

                              _dashboardCard(
                                "Saved",
                                savedAuditsCount,
                                Icons.save,
                                const Color(
                                    0xFFFFEAF0),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );

  }
  Widget _dashboardCard(
      String title,
      String count,
      IconData icon,
      Color bg){
    return Container(

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(

        color: bg,

        borderRadius:
        BorderRadius.circular(22),
      ),

      child: Column(

        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Container(

            padding:
            const EdgeInsets.all(10),

            decoration:
            BoxDecoration(

              color: Colors.white,

              borderRadius:
              BorderRadius.circular(12),
            ),

            child: Icon(
              icon,
              size: 22,
              color: const Color(0xFF4F46E5),
            ),
          ),

          Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            mainAxisSize:
            MainAxisSize.min,

            children: [

              Text(

                count,

                maxLines: 1,

                overflow:
                TextOverflow.ellipsis,

                style:
                const TextStyle(

                  fontSize: 24,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                  height:4),

              Text(

                title,

                maxLines: 1,

                overflow:
                TextOverflow.ellipsis,

                style: TextStyle(

                  fontSize: 12,

                  color:
                  Colors.grey.shade700,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
  Widget _smallMetric(
      IconData icon,
      String title,
      String count) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.15),
        borderRadius: BorderRadius.circular(15),
      ),

      child: Row(

        children: [

          Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(

              mainAxisSize: MainAxisSize.min,

              crossAxisAlignment:
              CrossAxisAlignment.start,

              mainAxisAlignment:
              MainAxisAlignment.center,

              children: [

                Text(

                  count,

                  maxLines: 1,

                  overflow:
                  TextOverflow.ellipsis,

                  style: const TextStyle(

                    fontSize: 16,

                    color: Colors.white,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                Text(

                  title,

                  maxLines: 1,

                  overflow:
                  TextOverflow.ellipsis,

                  style: TextStyle(

                    fontSize: 11,

                    color: Colors.white
                        .withOpacity(.85),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  @override
  void initState() {
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
      if(selectedAuditCycle!=null){
        final selectedCycle = auditCycleList.firstWhere(
              (e) => e['name'] == selectedAuditCycle,
          orElse: () => {},
        );
        print("Selected Cycle Id : ${selectedCycle['id']}");
        print("Selected Cycle Name : ${selectedCycle['name']}");
        /// Call dashboard API with selected cycle
        fetchDashboardData(true,selectedCycle['id']?.toString() ?? "",);
      }else{
        fetchDashboardData(false,"");
      }


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


                          fetchDashboardData(true,"");
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
    var response = await helper.postAPIWithHeader('v2/submittedAuditList', data, context);
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
    var response = await helper.postAPIWithHeader('v2/savedAuditList', data, context);
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
    var response = await helper.postAPIWithHeader('v2/auditor_assign_case_list', data, context);
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
  fetchDashboardData(bool applyFilter,String cycleId) async {
    setState(() {
      isLoading=true;
    });
    var requestModel = {};

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response;
    if (applyFilter) {
     /* response = await helper.getWithHeader('v2/auditorDashboardCount?start_date=' + startDateController.text.toString() + '&end_date=' +
              endDateController.text.toString(), {}, context);*/

      response = await helper.getWithHeader('v2/auditorDashboardCount?audit_cycle_id=$cycleId'  , {}, context);
    }
    else {
      response =
      await helper.getWithHeader('v2/auditorDashboardCount', {}, context);
    }


    var responseJSON = json.decode(response.body);

    setState(() {
      isLoading=false;
    });

    assignedAuditsCount=responseJSON["data"]["totalAssign"].toString();
    pendingAuditsCount=responseJSON["data"]["totalPending"].toString();
    submittedAuditsCount=responseJSON["data"]["totalCompletedAudits"].toString();
    savedAuditsCount=responseJSON["data"]["totalSavedAudits"].toString();

    if(!applyFilter) {
      auditCycleList =
      responseJSON['data'] != null &&
          responseJSON['data']['audit_cycle'] is List
          ? List<dynamic>.from(
        responseJSON['data']['audit_cycle'],
      )
          : [];

      if (auditCycleList.isNotEmpty) {
        final activeCycle = auditCycleList.firstWhere(
              (e) => (e['status'] ?? 0) == 1,
          orElse: () => auditCycleList.first,
        );
        selectedAuditCycle =
            activeCycle['name']?.toString() ?? "";
      }
    }
    print(responseJSON);
    setState(() {
    });
  }
  Future<void> _pullRefresh() async {

    checkInternet();

  }
}

