import 'dart:convert';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl_phone_field/helpers.dart';
import 'package:qaudit_tata_flutter/view/sunstone_module/qa_upload_artifact_screen.dart';
import 'package:qaudit_tata_flutter/view/sunstone_module/qa_view_artifact_screen.dart';
import 'package:toast/toast.dart';
import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../network/loader.dart';
import '../../utils/app_design.dart';
import '../../utils/app_modal.dart';
import '../../utils/app_theme.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';

class QaMainAuditFormScreen extends StatefulWidget{
  final String sheetID;
  final String sheetName;
  Map<String, dynamic> lobData;
  bool isEdit;
  String auditID;
  String auditAgencyID;
  QaMainAuditFormScreen(this.sheetID, this.lobData, this.sheetName, this.isEdit,
      this.auditID, this.auditAgencyID);
  _qaMainAuditForm createState()=>_qaMainAuditForm();

}
class _qaMainAuditForm extends State<QaMainAuditFormScreen>{
  var presentAuditorController = TextEditingController();
  String? selectedDate;
  String? userName;
  String AuditIdReal = "";
  bool isLoading=false;
  List locationFileterList=[];
  var agencySearchController = TextEditingController();
  List<dynamic> agencyList = [];
  List<dynamic> filteredAgencyList = [];
  int selectedAgencyIndex = 9999;
  var agencyNameController = TextEditingController();
  var agencyManagerNameController = TextEditingController();
  var agencyPhoneController = TextEditingController();
  var agencyAddressController = TextEditingController();
  var branchNameController = TextEditingController();
  var cityNameController = TextEditingController();
  var locationNameController = TextEditingController();
  var latLongHomeController = TextEditingController();
  List<String> auditCycleListAsString = [];
  List<dynamic> auditCycleList = [];
  String? selectedAuditCycle;
  Position? _currentPosition;
  var latLongController = TextEditingController();
  String selectedAgencyId = "";


  bool showResultLayout= false;
  bool showHomePgeLayout=true;
  bool showFilterPageLayout=false;
  bool showParameterPageLayout=false;
  bool showSubParameterPageLayout=false;


  int selectedFilterIndex=0;
  List parameterList=[];
  int selectedParameterIndex=0;
  List subParameterList=[];

  List<dynamic> questionList = [];
  var dropdownSelectionList = [[]];
  var controllerList = [[]];

  String satisTitle = "Yes";
  String unsetTitle = "No";
  String naTitle = "N/A";
  String criticalTitle = "Critical";
  String pwdTitle = "PWD";
  String percentageTitle = "Percentage";
  List<List<String?>> errorDropdownSelectionList = [];
  List<List<List<dynamic>>> errorScoringList = [];


  List<TextEditingController>parameterRemarkControllerList=[];


  List parameterWiseResultList=[];
  List pillarWiseResultList=[];
  List pillarDataList=[];
  Map<String, dynamic> overallResult={};
  double overallWeightedScore=0.0;
  double totalPillarWeight=0.0;


  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: 10,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Row(
                children: [

                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppDesign.bg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                  ),

                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "Audit Form",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        Text(
                          "Audit In Process",
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppDesign.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(

                width: double.infinity,
                color: const Color(0xFFF8FAFC),

                child: isLoading

                    ? Center(
                  child: Loader(),
                )

                    : SingleChildScrollView(

                  physics: const BouncingScrollPhysics(),

                  child: Column(
                    children: [

                      const SizedBox(height: 8),
                      showHomePgeLayout
                          ? _homePageWidget()
                      : showFilterPageLayout
                      ? _locationFilterWidget()
                      : showParameterPageLayout
                          ? _parameterWidget()
                      : showSubParameterPageLayout
                          ? _questionListWidget()
                      : showResultLayout
                      ?_showResultWidget()
                      :Container(child: Center(child: Text("Some Condition Mismatch Blank Layout"),),),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppModel.rebuttalData.clear();
    checkInternet();
    print(widget.sheetID);
  }
  checkInternet() async {
    String? name = await MyUtils.getSharedPreferences("name");
    setState(() {
      userName = name ?? "NA";
      presentAuditorController.text=userName!;
    });


    final List<ConnectivityResult> connectivityResult =
    await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      Toast.show("Please check your internet connection.",backgroundColor: Colors.red,duration: Toast.lengthLong);
      if(Navigator.canPop(context)){
        Navigator.of(context).pop();
      }
    } else {
      setState(() {});
      AuditIdReal = widget.isEdit
          ? widget.auditID
          : "";

      if(!widget.isEdit){
        String formattedDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
        selectedDate = formattedDate;
        setState(() {

        });
      }

      //await fetchDropdownData();
      await fetchAgencies();
      await fetchAuditCycleList();

      if(widget.isEdit){
        fetchEditAgencyDetails();
      }

    }
  }
  // Base Dropdown Data
  fetchDropdownData() async {
    setState(() {
      isLoading = true;
    });
    var requestModel = {
      "qm_sheet_id": widget.sheetID,
      "audit_id":AuditIdReal,
    };
    print(requestModel);
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPIWithHeader('v2/get-mapping-dropdown-data', requestModel, context);
    var responseJSON = json.decode(response.body);

    print(responseJSON);
    locationFileterList =
    responseJSON['data'] is List
        ? List<dynamic>.from(
      responseJSON['data'],
    )
        : [];
    setState(() {
      isLoading = false;
    });

    /*int row = questionList.length;
    int col = 20;
    dropdownSelectionList = List<List>.generate(
        row, (i) => List<dynamic>.generate(col, (index) => null));
    controllerList = List<List>.generate(
        row,
            (i) => List<TextEditingController>.generate(
            col, (index) => TextEditingController()));*/
    print("Hello 2D");
    print(responseJSON);
    setState(() {});
  }
  fetchAgencyDetails() async {
    APIDialog.showAlertDialog(context, "Please wait...");
    var requestModel = {
      "agency_id": agencySearchController.text.toString().length == 0
          ? agencyList[selectedAgencyIndex]["id"].toString()
          : filteredAgencyList[selectedAgencyIndex]["id"].toString(),
    };

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPIWithHeader('v2/agency-details', requestModel, context);

    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    log(responseJSON.toString());
    agencyNameController.text = responseJSON["details"]["name"];
    agencyManagerNameController.text =
    responseJSON["details"]["agency_manager"] != null
        ? responseJSON["details"]["agency_manager"].toString()
        : "";
    agencyAddressController.text = responseJSON["details"]["address"];
    cityNameController.text = responseJSON["details"]["location"];
    locationNameController.text = responseJSON["details"]["location"];
    setState(() {});
  }
  fetchAgencies() async {
    setState(() {
      isLoading=true;
    });
    if (agencyList.length != 0) {
      agencyList.clear();
    }
    var requestModel = {"location": "kolkata"};
    print(requestModel);
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(
        'v2/get_agencies_from_city', requestModel, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    agencyList = responseJSON["details"];
    setState(() {
      isLoading=false;
    });
  }
  fetchAuditCycleList() async {
    setState(() {
      isLoading=true;
    });
    var requestModel = {};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.getWithHeader('v2/get_audit_cycle', requestModel, context);

    var responseJSON = json.decode(response.body);

    auditCycleList = responseJSON["details"];
    for (int i = 0; i < auditCycleList.length; i++) {
      auditCycleListAsString.add(auditCycleList[i]["name"]);
    }

    if (auditCycleList.length != 0) {
      selectedAuditCycle = auditCycleList[0]["name"];
    }

    print("Cycle Data");
    print(responseJSON);
    setState(() {
      isLoading=false;
    });
  }
  fetchEditAgencyDetails() async {
    APIDialog.showAlertDialog(context, "Please wait...");
    var requestModel = {
      "audit_id":AuditIdReal,
    };
    print(requestModel);
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPIWithHeader('v2/saved_audit_details', requestModel, context);
    if(Navigator.canPop(context)){Navigator.pop(context);}
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    log(responseJSON.toString());

    bool status=responseJSON['status']??false;
    if(status){
      var auditDetails= responseJSON['audit_details']??{};
      String agid=auditDetails['agency_id']?.toString()??"";
      String agName=auditDetails['agency_name']?.toString()??"";
      String adDate=auditDetails['audit_date_by_aud']?.toString()??"";
      String agAddress=auditDetails['address']?.toString()??"";
      String agCity=auditDetails['agency_city']?.toString()??"";
      String agLocation=auditDetails['agency_location']?.toString()??"";
      String agAuName=auditDetails['auditor_name']?.toString()??"";
      String agLatLong=auditDetails['lat_long']?.toString()??"";

      if(adDate.isNotEmpty){
        selectedDate=adDate;
      }
      if(agLatLong.isNotEmpty){
        latLongController.text=agLatLong;
      }
      if(agAuName.isNotEmpty){
        presentAuditorController.text=agAuName;
      }
      if(agid.isNotEmpty){
        for (int i = 0; i < agencyList.length; i++) {
          if (agencyList[i]["id"].toString() == agid) {
            selectedAgencyIndex = i;
            break;
          }
        }
      }
      if(agName.isNotEmpty){
        agencyNameController.text=agName;
      }
      if(agAddress.isNotEmpty){
        agencyAddressController.text=agAddress;
      }
      if(agCity.isNotEmpty){
        cityNameController.text=agCity;
      }
      if(agLocation.isNotEmpty){
        locationNameController.text=agLocation;
      }

    }
    setState(() {});
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Toast.show("Location services are disabled. Please enable the services.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Toast.show("Location permissions are denied.",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Toast.show(
          "Location permissions are permanently denied, we cannot request permissions.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      return false;
    }

    return true;
  }
  _showPermissionCustomDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Please allow below permissions for access the Attendance Functionality.",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "1.) Location Permission",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "2.) Enable GPS Services",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          //call attendance punch in or out
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.themeColor,
                          ),
                          height: 45,
                          padding: const EdgeInsets.all(10),
                          child: const Center(
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }
  Future<void> _getCurrentPosition() async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, "Fetching Location..");
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      Navigator.of(context).pop();
      _showPermissionCustomDialog();
      return;
    }
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      print(
          "Location  latitude : ${_currentPosition!.latitude} Longitude : ${_currentPosition!.longitude}");
      latLongController.text =
          position.latitude.toString() + " , " + position.longitude.toString();
      setState(() {});
      Navigator.pop(context);
    }).catchError((e) {
      debugPrint(e);
      Toast.show(
          "Error!!! Can't get Location. Please Ensure your location services are enabled",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      Navigator.pop(context);
    });
  }
  void selectAgencyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, bottomSheetState) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: EdgeInsets.all(10),
              // height: 600,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                // Set the corner radius here
                color: Colors.white, // Example color for the container
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Center(
                    child: Container(
                      height: 6,
                      width: 62,
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Text("Select Agency",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),
                      Spacer(),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset("assets/cross_ic.png",
                              width: 30, height: 30)),
                      SizedBox(width: 4),
                    ],
                  ),
                  SizedBox(height: 22),
                  Container(
                    width: double.infinity,
                    height: 53,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color(0xFFEEEDF9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                        controller: agencySearchController,
                        style: const TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF707070),
                        ),
                        onChanged: (value) {
                          List<dynamic> results = [];
                          if (value.isEmpty) {
                            results = agencyList;
                          } else {
                            List<dynamic> results1 = agencyList
                                .where((hobbie) => hobbie['agency_id']
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                                .toList();

                            List<dynamic> results2 = agencyList
                                .where((hobbie) => hobbie['name']
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                                .toList();

                            results.addAll(results1);
                            results.addAll(results2);
                          }

                          filteredAgencyList = results;

                          bottomSheetState(() {});
                        },
                        decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.search,
                              color: Color(0xFFB5B5B5),
                            ),
                            border: InputBorder.none,
                            fillColor: Color(0xFFEEEDF9),
                            filled: true,
                            contentPadding: EdgeInsets.fromLTRB(2.0, 7.0, 5, 5),
                            //prefixIcon: fieldIC,
                            labelText: "Search By Name",
                            labelStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF707070).withOpacity(0.4),
                            ))),
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    height: 180,
                    child: filteredAgencyList.length != 0 ||
                        agencySearchController.text.isNotEmpty
                        ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredAgencyList.length,
                        itemBuilder: (BuildContext context, int pos) {
                          return InkWell(
                            onTap: () {
                              bottomSheetState(() {
                                selectedAgencyIndex = pos;
                              });
                            },
                            child: Container(
                              height: 57,
                              color: selectedAgencyIndex == pos
                                  ? Color(0xFFFF7C00).withOpacity(0.10)
                                  : Colors.white,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24),
                                      child: Text(
                                          filteredAgencyList[pos]
                                          ["agency_id"]
                                              .toString() +
                                              " " +
                                              filteredAgencyList[pos]
                                              ["name"],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                        : ListView.builder(
                        shrinkWrap: true,
                        itemCount: agencyList.length,
                        itemBuilder: (BuildContext context, int pos) {
                          return InkWell(
                            onTap: () {
                              bottomSheetState(() {
                                selectedAgencyIndex = pos;
                              });
                            },
                            child: Container(
                              height: 57,
                              color: selectedAgencyIndex == pos
                                  ? Color(0xFFFF7C00).withOpacity(0.10)
                                  : Colors.white,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24),
                                      child: Text(
                                          agencyList[pos]["agency_id"]
                                              .toString() +
                                              " " +
                                              agencyList[pos]["name"],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(height: 15),
                  Card(
                    elevation: 4,
                    shadowColor: Colors.grey,
                    margin: EdgeInsets.symmetric(horizontal: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      height: 53,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white), // background
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppTheme.themeColor), // fore
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ))),
                        onPressed: () {
                          if (selectedAgencyIndex != 9999) {
                            Navigator.pop(context);
                            setState(() {});

                            fetchAgencyDetails();

                            //fetchProducts();
                          }
                        },
                        child: const Text(
                          'Select',
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
                  SizedBox(height: 15),
                ],
              ),
            ),
          );
        });
      },
    );
  }
  Widget _homePageWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4F46E5),
                  Color(0xFF7C3AED),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [

                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.assignment_rounded,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Expanded(
                      child: Text(
                        "Audit Information",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  "Fill all required details to continue",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.90),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [

                /// AGENCY
                _modernSelectionTile(
                  title: "Agency*",
                  value: selectedAgencyIndex == 9999
                      ? "Select Agency"
                      : agencySearchController.text.toString().isEmpty
                      ? agencyList[selectedAgencyIndex]["agency_id"]
                      .toString() +
                      " " +
                      agencyList[selectedAgencyIndex]["name"]
                      : filteredAgencyList[selectedAgencyIndex]
                  ["agency_id"]
                      .toString() +
                      " " +
                      filteredAgencyList[selectedAgencyIndex]
                      ["name"]
                          .toString(),
                  icon: Icons.business_rounded,
                  onTap: () {
                    selectAgencyBottomSheet(context);
                  },
                ),

                const SizedBox(height: 18),

                /// AUDIT CYCLE
                _modernDropdownContainer(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,

                      value: selectedAuditCycle,

                      hint: const Text(
                        "Select Audit Cycle",
                      ),

                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                        ),
                      ),

                      menuItemStyleData:
                      const MenuItemStyleData(
                        padding:
                        EdgeInsets.symmetric(
                          horizontal: 14,
                        ),
                      ),

                      items: auditCycleListAsString
                          .map(
                            (item) =>
                            DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                      )
                          .toList(),

                      onChanged: widget.isEdit
                          ? null
                          : (value) {

                        setState(() {
                          selectedAuditCycle =
                          value as String;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                /// AUDIT DATE
                _modernSelectionTile(

                  title: "Audit Date*",

                  value: selectedDate ??
                      "Select Date",

                  icon: Icons.calendar_month,

                  onTap: () async {

                    if (!widget.isEdit) {

                      DateTime? pickedDate =
                      await showDatePicker(

                        context: context,

                        initialDate: DateTime.now(),

                        firstDate: DateTime(1950),

                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {

                        String formattedDate =
                        DateFormat('yyyy-MM-dd')
                            .format(pickedDate);

                        selectedDate =
                            formattedDate;

                        setState(() {});
                      }
                    }
                  },
                ),

                const SizedBox(height: 18),

                /// PRESENT AUDITOR
                _modernTextField(
                  title: "Present Auditor*",
                  controller:
                  presentAuditorController,
                  enabled: false,
                  icon: Icons.person_rounded,
                ),

                const SizedBox(height: 18),

                /// ADDRESS
                _modernTextField(
                  title: "Agency Address",
                  controller:
                  agencyAddressController,
                  enabled: false,
                  icon: Icons.location_on,
                  maxLines: 3,
                ),

                const SizedBox(height: 18),

                /// CITY
                _modernTextField(
                  title: "City",
                  controller: cityNameController,
                  enabled: false,
                  icon: Icons.location_city,
                ),

                const SizedBox(height: 18),

                /* /// LOCATION
                _modernTextField(
                  title: "Location",
                  controller:
                  locationNameController,
                  enabled: false,
                  icon: Icons.pin_drop_rounded,
                ),*/

                const SizedBox(height: 18),

                /// GEO TAG
                GestureDetector(
                  onTap: () {

                    if (!widget.isEdit) {
                      _getCurrentPosition();
                    }
                  },

                  child: _modernTextField(
                    title: "Geo Tag",
                    controller:
                    latLongController,
                    enabled: false,
                    icon: Icons.my_location,
                    hint: "Tap to fetch location",
                  ),
                ),

                const SizedBox(height: 28),

                /// BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 56,

                  child: ElevatedButton(

                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(
                          0xFF5B5FEF),

                      elevation: 0,

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius
                            .circular(18),
                      ),
                    ),

                    onPressed: () {
                        checkValidationForHomePage();
                    },

                    child: const Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [

                        Text(
                          "Save & Next",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(width: 8),

                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
  /// MODERN TILE
  Widget _modernSelectionTile({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
          ),
        ),

        child: Row(
          children: [

            Container(
              padding: const EdgeInsets.all(10),

              decoration: BoxDecoration(
                color:
                const Color(0xFFF4F6FF),
                borderRadius:
                BorderRadius.circular(14),
              ),

              child: Icon(
                icon,
                size: 20,
                color:
                const Color(0xFF5B5FEF),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight:
                      FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                      FontWeight.w600,
                      color:
                      value.contains("Select")
                          ? Colors.grey
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.keyboard_arrow_down_rounded,
            ),
          ],
        ),
      ),
    );
  }
  /// MODERN TEXTFIELD
  Widget _modernTextField({
    required String title,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
    int maxLines = 1,
    String hint = "",
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: const Color(0xFFF4F6FF),
              borderRadius:
              BorderRadius.circular(14),
            ),

            child: Icon(
              icon,
              size: 20,
              color: const Color(0xFF5B5FEF),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 4),

                TextField(
                  controller: controller,
                  enabled: enabled,
                  maxLines: maxLines,

                  decoration: InputDecoration(
                    isDense: true,
                    hintText: hint,
                    border: InputBorder.none,
                  ),

                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  /// DROPDOWN CONTAINER
  Widget _modernDropdownContainer({
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),

      child: child,
    );
  }
  checkValidationForHomePage() {
    if (selectedAgencyIndex == 9999) {
      Toast.show("Please select a Agency",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else if (selectedAuditCycle == null) {
      Toast.show("Please select a Audit cycle",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else if (selectedDate == null) {
      Toast.show("Please select a Audit Date",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else if (presentAuditorController.text == "") {
      Toast.show("Please enter Present Auditor name!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else if (latLongController.text == "") {
      Toast.show("Geo tag not found",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }  else {
      _saveHomeDetailsForm();
    }
  }
  _saveHomeDetailsForm() async {
    APIDialog.showAlertDialog(context, "Saving Basic Details...");
    String auditCycleID = "";
    for (int i = 0; i < auditCycleList.length; i++) {
      if (selectedAuditCycle == auditCycleList[i]["name"]) {
        auditCycleID = auditCycleList[i]["id"].toString();
        break;
      }
    }
    selectedAgencyId = agencySearchController.text.toString().length == 0
        ? agencyList[selectedAgencyIndex]["id"].toString()
        : filteredAgencyList[selectedAgencyIndex]["id"].toString();
    var requestModels = {
      "lat_long": latLongController.text.toString(),
      "qm_sheet_id": widget.sheetID,
      "audit_cycle_id": auditCycleID,
      "present_auditor": presentAuditorController.text.toString(),
      "agency_id": selectedAgencyId,
    };
    var requestModelEdit = {
      "audit_id": AuditIdReal,
      "lat_long": latLongController.text.toString(),
      "qm_sheet_id": widget.sheetID,
      "audit_cycle_id": auditCycleID,
      "present_auditor": presentAuditorController.text.toString(),
      "agency_id": selectedAgencyId,
    };

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('v2/saveBasicInfoaudit',
        widget.isEdit ? requestModelEdit : requestModels, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['status'].toString() == "1") {
      AuditIdReal = responseJSON['audit_id'].toString();
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      saveBasicDetails();
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  void saveBasicDetails() {
    showHomePgeLayout = false;
    showResultLayout= false;
    showFilterPageLayout=true;
    showParameterPageLayout=false;
    showSubParameterPageLayout=false;
    setState(() {});

    fetchDropdownData();
  }

  Widget _locationFilterWidget() {

    bool hasPending = locationFileterList.any(
          (item) =>
      (item["filled_count"] ?? 0) > 0 &&
          !(item["is_completed"] ?? false),
    );

    bool hasCompleted = locationFileterList.any(
          (item) =>
      (item["filled_count"] ?? 0) > 0 &&
          (item["is_completed"] ?? false),
    );

    bool showReviewButton =
        hasCompleted && !hasPending;

    return Container(

      margin: const EdgeInsets.symmetric(
        horizontal: 14,
      ),

      child: Column(

        children: [

          const SizedBox(height: 8),

          /// HEADER

          Container(

            padding:
            const EdgeInsets.all(18),

            decoration: BoxDecoration(

              gradient:
              const LinearGradient(

                colors: [

                  Color(0xFF4F46E5),
                  Color(0xFF7C3AED),
                ],
              ),

              borderRadius:
              BorderRadius.circular(24),
            ),

            child: const Row(

              children: [

                Icon(
                  Icons.filter_alt_rounded,
                  color: Colors.white,
                ),

                SizedBox(width: 12),

                Text(

                  "Audit Mapping",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          ListView.builder(

            itemCount:
            locationFileterList.length,

            shrinkWrap: true,

            physics:
            const NeverScrollableScrollPhysics(),

            itemBuilder:
                (context,index){

              var item=
              locationFileterList[index];

              int filledCount=
                  int.tryParse(
                      item["filled_count"]
                          .toString()) ??
                      0;

              bool completed=
                  item["is_completed"] ??
                      false;

              bool pending=
                  filledCount>0 &&
                      !completed;

               return Container(
                margin: const EdgeInsets.only(bottom: 12),

                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                  BorderRadius.circular(22),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: Row(
                  children: [

                    /// LEFT CONTENT

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          /// TAGS

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,

                            children: [
                              if(item["location"]!=null)
                              _modernChip(
                                Icons.location_on_outlined,
                                item["location"],
                              ),
                              if(item["campus_type"]!=null)
                              _modernChip(
                                Icons.school_outlined,
                                item["campus_type"],
                              ),

                              if(item["brand"]!=null)
                                _modernChip(
                                  Icons.storefront_outlined,
                                  item["brand"],
                                ),

                              if(item["pillar"]!=null)
                                _modernChip(
                                  Icons.account_tree_outlined,
                                  item["pillar"],
                                ),

                              if(item["touch_point"]!=null)
                                _modernChip(
                                  Icons.touch_app_outlined,
                                  item["touch_point"],
                                ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Row(

                            children: [

                              /// PROGRESS SMALL

                              Container(

                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 7,
                                ),

                                decoration:
                                BoxDecoration(

                                  color:
                                  const Color(
                                      0xFFF4F6FF),

                                  borderRadius:
                                  BorderRadius.circular(
                                      30),
                                ),

                                child: Row(

                                  children: [

                                    const Icon(
                                      Icons.bar_chart,
                                      size: 16,
                                      color: Color(
                                          0xFF5B5FEF),
                                    ),

                                    const SizedBox(
                                        width: 6),

                                    Text(

                                      item["progress"]
                                          .toString(),

                                      style:
                                      const TextStyle(
                                        fontWeight:
                                        FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width:10),

                              /// STATUS

                              Container(

                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 7,
                                ),

                                decoration:
                                BoxDecoration(

                                  color:

                                  completed
                                      ? Colors.green
                                      .withOpacity(
                                      0.12)

                                      : pending

                                      ? Colors.orange
                                      .withOpacity(
                                      0.12)

                                      : Colors.grey
                                      .withOpacity(
                                      0.12),

                                  borderRadius:
                                  BorderRadius.circular(
                                      30),
                                ),

                                child: Row(

                                  children: [

                                    Icon(

                                      completed

                                          ? Icons.check_circle

                                          : pending

                                          ? Icons.pending

                                          : Icons.schedule,

                                      size: 15,

                                      color:

                                      completed
                                          ? Colors.green

                                          : pending
                                          ? Colors.orange
                                          : Colors.grey,
                                    ),

                                    const SizedBox(
                                        width: 5),

                                    Text(

                                      completed

                                          ? "Completed"

                                          : pending
                                          ? "Pending"
                                          : "Not Started",

                                      style:
                                      TextStyle(
                                        fontWeight:
                                        FontWeight.w600,

                                        fontSize: 12,

                                        color:

                                        completed
                                            ? Colors.green

                                            : pending
                                            ? Colors.orange
                                            : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width:12),

                    /// BIG EYE BUTTON

                    GestureDetector(

                      onTap: () {

                        setState(() {
                          selectedFilterIndex=index;
                        });
                        fetchParameters();
                      },

                      child: Container(

                        height: 65,
                        width: 65,

                        decoration:
                        BoxDecoration(

                          gradient:
                          const LinearGradient(
                            colors: [

                              Color(0xFF5B5FEF),
                              Color(0xFF7C3AED),
                            ],
                          ),

                          borderRadius:
                          BorderRadius.circular(
                              18),
                        ),

                        child: const Icon(

                          Icons.visibility_rounded,

                          size: 30,

                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );;
            },
          ),

          if(showReviewButton)

            Padding(

              padding:
              const EdgeInsets.only(
                  top:15),

              child: SizedBox(

                width:
                double.infinity,

                height:56,

                child:
                ElevatedButton(

                  style:
                  ElevatedButton
                      .styleFrom(

                    backgroundColor:
                    const Color(
                        0xFF5B5FEF),

                    shape:
                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(
                          18),
                    ),
                  ),

                  onPressed:(){
                    getResultFromServer();
                  },

                  child:
                  const Row(

                    mainAxisAlignment:
                    MainAxisAlignment
                        .center,

                    children:[

                      Text(

                        "Review Audit",

                        style:
                        TextStyle(

                          fontSize:16,
                          fontWeight:
                          FontWeight
                              .w700,

                          color:
                          Colors.white,
                        ),
                      ),

                      SizedBox(
                          width:8),

                      Icon(
                        Icons
                            .arrow_forward,
                        color:
                        Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          const SizedBox(
              height:20),
        ],
      ),
    );
  }
  Widget _modernChip(
      IconData icon,
      dynamic value,
      ){

    if(value==null ||
        value.toString()
            .trim()
            .isEmpty){
      return const SizedBox();
    }

    return Container(

      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),

      decoration:
      BoxDecoration(

        color:
        const Color(0xFFF8FAFC),

        borderRadius:
        BorderRadius.circular(
            30),
      ),

      child: Row(

        mainAxisSize:
        MainAxisSize.min,

        children: [

          Icon(
            icon,
            size: 16,
            color: const Color(
                0xFF5B5FEF),
          ),

          const SizedBox(width:6),

          Text(

            value.toString(),

            style:
            const TextStyle(

              fontSize: 14,

              fontWeight:
              FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }


  // Parameter wise widget
  fetchParameters() async {
    setState(() {
      isLoading = true;
    });

    var item=locationFileterList[selectedFilterIndex];
    var requestModel = {
      "qm_sheet_id": widget.sheetID,
      "audit_id": AuditIdReal,
    };

    [
      "location",
      "campus_type",
      "brand",
      "pillar",
      "touch_point",
    ].forEach((key) {

      final value = item[key];

      if ((value ?? "").toString().isNotEmpty) {
        requestModel[key] = value;
      }

    });


    print(requestModel);
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPIWithHeader('v2/view-mapping', requestModel, context);
    var responseJSON = json.decode(response.body);
    log(jsonEncode(responseJSON));
    parameterList =
    responseJSON['data'] is List
        ? List<dynamic>.from(
      responseJSON['data'],
    )
        : [];
    setState(() {
      isLoading = false;
    });
    saveFilterData();
  }
  void saveFilterData() {
    showHomePgeLayout = false;
    showResultLayout= false;
    showFilterPageLayout=false;
    showParameterPageLayout=true;
    showSubParameterPageLayout=false;
    setState(() {});
  }
  Widget _parameterWidget() {
    return Column(
      children: [

        const SizedBox(height: 10),

        /// BACK BUTTON
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(

              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF5B5FEF),

                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(18),

                  side: const BorderSide(
                    color: Color(0xFFE8ECF4),
                  ),
                ),
              ),

              onPressed: () {
                saveBasicDetails();
              },

              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
              ),

              label: const Text(
                "Back To Mapping",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        /// PARAMETER LIST

        ListView.builder(

          itemCount:
          parameterList.length,

          shrinkWrap: true,

          physics:
          const NeverScrollableScrollPhysics(),

          itemBuilder:
              (context,index){

            var item=
            parameterList[index];

            bool isFilled=
                item["is_filled"] ??
                    false;

            String status=
                item["status"]
                    ?.toString() ??
                    "Pending";

            bool isPending=
                status.toLowerCase()
                    ==
                    "pending";

            String buttonText=

            !isFilled

                ? "Start"

                : status
                .toLowerCase()
                ==
                "completed"

                ? "View"

                : "Edit";

            Color statusColor=

            isPending

                ? Colors.orange

                : Colors.green;

            return Container(

              margin:
              const EdgeInsets.only(
                  left:14,
                  right:14,
                  bottom:14),

              padding:
              const EdgeInsets.all(15),

              decoration:
              BoxDecoration(

                color:
                Colors.white,

                borderRadius:
                BorderRadius.circular(
                    22),

                boxShadow:[

                  BoxShadow(

                    color:
                    Colors.black
                        .withOpacity(
                        0.04),

                    blurRadius:12,

                    offset:
                    const Offset(
                        0,5),
                  ),
                ],
              ),

              child: Row(

                children: [

                  Container(

                    height:60,
                    width:60,

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
                          18),
                    ),

                    child:
                    const Icon(
                      Icons.assignment,
                      color:
                      Colors.white,
                      size:30,
                    ),
                  ),

                  const SizedBox(
                      width:14),

                  Expanded(

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        Text(

                          item["parameter"]
                              ?.toString()
                              ??
                              "",

                          style:
                          const TextStyle(

                            fontSize:
                            16,

                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),

                        const SizedBox(
                            height:8),

                        Container(

                          padding:
                          const EdgeInsets
                              .symmetric(

                              horizontal:
                              10,

                              vertical:
                              6),

                          decoration:
                          BoxDecoration(

                            color:
                            statusColor
                                .withOpacity(
                                0.12),

                            borderRadius:
                            BorderRadius
                                .circular(
                                30),
                          ),

                          child: Text(

                            status,

                            style:
                            TextStyle(

                              color:
                              statusColor,

                              fontWeight:
                              FontWeight
                                  .w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                      width:12),

                  ElevatedButton(

                    style:
                    ElevatedButton
                        .styleFrom(

                      backgroundColor:
                      const Color(
                          0xFF5B5FEF),
                      foregroundColor: Colors.white,

                      shape:
                      RoundedRectangleBorder(

                        borderRadius:
                        BorderRadius.circular(
                            14),
                      ),
                    ),

                    onPressed:(){
                      print(
                          item["action"]
                          ["url"]);
                      setState(() {
                        selectedParameterIndex=index;
                      });

                      fetchSubParameters();

                    },

                    child:
                    Text(
                        buttonText),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }


  // Subparameter wise widget
  fetchSubParameters() async {
    setState(() {
      isLoading = true;
    });

    var item=locationFileterList[selectedFilterIndex];
    var requestModel = {
      "qm_sheet_id": widget.sheetID,
      "audit_id": AuditIdReal,
    };

    [
      "location",
      "campus_type",
      "brand",
      "pillar",
      "touch_point",
    ].forEach((key) {

      final value = item[key];

      if ((value ?? "").toString().isNotEmpty) {
        requestModel[key] = value;
      }

    });

    requestModel['parameter_id']=parameterList[selectedParameterIndex]['id']?.toString()??"";


    print(requestModel);
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPIWithHeader('v2/view-parameter-details', requestModel, context);
    var responseJSON = json.decode(response.body);
    log(jsonEncode(responseJSON));
    subParameterList.clear();
    List apiData = responseJSON["data"] ?? [];
    for (var item in apiData) {
      int parameterIndex =
          item["parameter_index"] ?? 1;
      subParameterList.add({

        "id": item["id"]?.toString() ?? "",
        "parameter": item["parameter"]?.toString() ?? "",
        "parameter_tag": item["parameter_tag"]?.toString() ?? "",
        "touch_point":
        (
            (item["sub_parameters"] as List?)?.isNotEmpty ?? false
        )
            ? (
            item["sub_parameters"][0]
            ["sub_parameter_details"]?["touch_point"]
                ?.toString() ??
                ""
        )
            : "",

        "duplicate_index": parameterIndex,

        "add_more":
        item["add_more"] ?? 0,

        "add_more_limit":
        item["add_more_limit"] ?? 0,

        "qm_sheet_sub_parameter":

        List<dynamic>.from(
          item["sub_parameters"] ?? [],
        ).map((sub){

          final details =
              sub["sub_parameter_details"] ?? {};

          final filledData =
          List<dynamic>.from(
            sub["filled_data"] ?? [],
          );

          final savedData =
          filledData.isNotEmpty
              ? filledData.first
              : {};

          return {

            "id":
            details["id"]
                ?.toString() ??
                "",

            "sub_parameter":
            details["sub_parameter"]
                ?.toString() ??
                "",
            "details":details["details"]
                ?.toString() ??
                "",

            "compliance_experience":
            details["compliance_experience"]
                ?.toString() ??
                "",
            "weight":
            details["weight"]
                ?.toString() ??
                "0",

            "na":
            details["na"] ?? 0,

            "pwd":
            details["pwd"] ?? 0,

            "per":
            details["per"] ?? 0,

            "critical":
            details["critical"] ?? 0,

            "use_error_count":
            details["use_error_count"] ?? 0,

            "error_scoring":
            details["error_scoring"],

            /// restored values

            "selected_option":
            savedData["option_selected"],

            "remark":
            savedData["remark"]
                ?.toString() ??
                "",

            "artifacts":
            List<dynamic>.from(
              savedData["artifacts"] ?? [],
            ),

            "error_count":
            savedData["error_count"]
                ?.toString(),

            "error_score":
            savedData["error_score"]
                ?.toString(),
          };

        }).toList(),
      });
    }

    questionList = subParameterList;
    errorDropdownSelectionList.clear();
    errorScoringList.clear();
    for (int i = 0; i < questionList.length; i++) {
      List<String?> innerSelection = [];
      List<List<dynamic>> innerErrorList = [];
      List subParams =
          questionList[i]["qm_sheet_sub_parameter"] ?? [];
      for (int j = 0; j < subParams.length; j++) {
        innerSelection.add(null);
        if (subParams[j]["error_scoring"] != null) {
          innerErrorList.add(
            jsonDecode(subParams[j]["error_scoring"]),
          );
        } else {
          innerErrorList.add([]);
        }
      }
      errorDropdownSelectionList.add(innerSelection);
      errorScoringList.add(innerErrorList);
    }
    initializeLists();
    setState(() {
      isLoading = false;
    });
    saveParameterData();
  }
  void saveParameterData() {
    showHomePgeLayout = false;
    showResultLayout= false;
    showFilterPageLayout=false;
    showParameterPageLayout=false;
    showSubParameterPageLayout=true;
    setState(() {});
  }
  Widget _questionListWidget() {

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(

              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF5B5FEF),

                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(18),

                  side: const BorderSide(
                    color: Color(0xFFE8ECF4),
                  ),
                ),
              ),

              onPressed: () {
                fetchParameters();
              },

              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
              ),

              label: const Text(
                "Back To Parameters",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        ListView.builder(

          shrinkWrap: true,
          physics:
          NeverScrollableScrollPhysics(),

          itemCount:
          questionList.length,

          itemBuilder:
              (context,pos){

            var parameter =
            questionList[pos];

            int duplicateIndex=

                parameter[
                "duplicate_index"] ?? 1;
            int isAddMore=questionList[pos]["add_more"]??0;

            return Container(

              margin:
              EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),

              padding:
              EdgeInsets.all(16),

              decoration:
              BoxDecoration(

                color: Colors.white,

                borderRadius:
                BorderRadius.circular(
                    24),

                boxShadow:[

                  BoxShadow(
                    blurRadius:12,
                    color: Colors.black12,
                  )
                ],
              ),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  /// HEADER

                  Row(

                    children: [

                      Expanded(

                        child: Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            Text(

                              duplicateIndex>1

                                  ?

                              "${parameter["parameter"]} ($duplicateIndex)"

                                  :

                              parameter["parameter"],

                              style:
                              TextStyle(

                                fontSize:18,

                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            SizedBox(
                                height:5),

                            Text(

                              parameter[
                              "touch_point"]
                                  ?? "",

                              style:
                              TextStyle(
                                color:
                                Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// ADD BUTTON

                      if(
                      showAddButton(pos)
                      )

                        IconButton(

                          onPressed:(){

                            addDuplicateParameter(
                                pos);
                          },

                          icon: Icon(
                            Icons.add_circle,
                            color:
                            Colors.green,
                            size:32,
                          ),
                        ),

                      /// DELETE

                      if(
                      duplicateIndex>1
                      )

                        IconButton(

                          onPressed:(){

                           deleteParameter(
                               pos);
                          },

                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height:16),

                  if (isAddMore==1) ...[
                    TextField(
                      controller: parameterRemarkControllerList[pos],
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: "Enter Parameter Tag",
                        prefixIcon: const Icon(Icons.edit_note),

                        filled: true,
                        fillColor: Colors.grey.shade50,

                        contentPadding: const EdgeInsets.all(14),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height:20),
                  ],



                  _subParameterWidget(
                      pos),
                ],
              ),
            );
          },
        ),
        SizedBox(height:20),
        Padding(

          padding:
          EdgeInsets.symmetric(
              horizontal:14),

          child: SizedBox(

            width:
            double.infinity,

            height:55,

            child:
            ElevatedButton(

              style:
              ElevatedButton.styleFrom(

                backgroundColor:
                Color(
                    0xFF5B5FEF),

                shape:
                RoundedRectangleBorder(

                  borderRadius:
                  BorderRadius.circular(
                      18),
                ),
              ),

              onPressed:(){

                validateAllParameter();

              },

              child:
              Text(

                "Save",

                style:
                TextStyle(
                  fontSize:16,
                  color:
                  Colors.white,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
            height:30),
      ],
    );
  }
  Widget _subParameterWidget(
      int pos){
    return ListView.builder(

      itemCount:
      questionList[pos]
      ["qm_sheet_sub_parameter"]
          .length,

      shrinkWrap: true,

      physics:
      const NeverScrollableScrollPhysics(),

      itemBuilder:
          (context, index) {

        List<String> answerList =
        [];

        answerList
            .add(satisTitle);

        answerList
            .add(unsetTitle);

        int isNA = questionList[
        pos]
        ["qm_sheet_sub_parameter"]
        [index]["na"] ??
            0;

        int ispwd = questionList[
        pos]
        ["qm_sheet_sub_parameter"]
        [index]["pwd"] ??
            0;

        int isper = questionList[
        pos]
        ["qm_sheet_sub_parameter"]
        [index]["per"] ??
            0;

        int isCritical =
            questionList[pos][
            "qm_sheet_sub_parameter"]
            [index]["critical"] ??
                0;
        String details=questionList[pos]["qm_sheet_sub_parameter"][index]["details"] ?? "";
        print("*************Details**************$details");

        if (isNA == 1) {
          answerList.add(
              naTitle);
        }

        if (ispwd == 1) {
          answerList.add(
              pwdTitle);
        }

        if (isper == 1) {
          answerList.add(
              percentageTitle);
        }

        if (isCritical == 1) {
          answerList.add(
              criticalTitle);
        }

        return Container(

          margin:
          const EdgeInsets.only(
            bottom: 18,
          ),

          padding:
          const EdgeInsets.all(
              16),

          decoration:
          BoxDecoration(

            color:
            const Color(
                0xFFF9FAFB),

            borderRadius:
            BorderRadius
                .circular(
                22),

            border: Border.all(
              color: const Color(
                  0xFFE5E7EB),
            ),
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,

            children: [

              /// SUB PARAM TITLE
              Row(
                children: [
                  Expanded(child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                    children: [
                      Text(
                        questionList[pos][
                        "qm_sheet_sub_parameter"]
                        [index]
                        ["sub_parameter"],

                        style:
                        const TextStyle(
                          fontSize: 15,
                          fontWeight:
                          FontWeight
                              .w700,
                          color: Color(
                              0xFF1B1D28),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        questionList[pos][
                        "qm_sheet_sub_parameter"]
                        [index]
                        ["compliance_experience"],


                        style:
                        const TextStyle(
                          fontSize: 13,
                          fontWeight:
                          FontWeight
                              .w700,
                          color: Color(
                              0xFF56568F),
                        ),
                      ),
                    ],
                  )),
            details.isNotEmpty
            ? IconButton(
            onPressed: () {
            showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
            ),
            ),
            builder: (context) {
            return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

            Row(
            children: const [
            Icon(
            Icons.info_outline,
            color: Colors.blue,
            ),
            SizedBox(width: 8),
            Text(
            "Details",
            style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            ),
            ),
            ],
            ),

            const SizedBox(height: 16),

            Text(
            details,
            style: const TextStyle(
            fontSize: 15,
            height: 1.5,
            ),
            ),

            const SizedBox(height: 20),
            ],
            ),
            );
            },
            );
            },
            icon: const Icon(
            Icons.info_outline,
            color: Colors.blue,
            ),
            )
                : const SizedBox()
                ],
              ),



              const SizedBox(
                  height: 14),

              /// DROPDOWN
              Container(

                padding:
                const EdgeInsets
                    .symmetric(
                  horizontal:
                  14,
                ),

                decoration:
                BoxDecoration(

                  color:
                  Colors.white,

                  borderRadius:
                  BorderRadius
                      .circular(
                      16),

                  border:
                  Border.all(
                    color: const Color(
                        0xFFE5E7EB),
                  ),
                ),

                child:
                DropdownButtonHideUnderline(

                  child:
                  DropdownButton2(

                    isExpanded:
                    true,

                    hint:
                    const Text(
                      "Choose Type",
                    ),

                    value:
                    dropdownSelectionList[
                    pos]
                    [index],

                    menuItemStyleData:
                    const MenuItemStyleData(
                      padding:
                      EdgeInsets.symmetric(
                        horizontal:
                        14,
                      ),
                    ),

                    iconStyleData:
                    const IconStyleData(
                      icon:
                      Icon(Icons.keyboard_arrow_down_rounded),
                    ),

                    items: answerList
                        .map(
                          (item) =>
                          DropdownMenuItem<String>(
                            value:
                            item,
                            child:
                            Text(item),
                          ),
                    )
                        .toList(),

                    onChanged:
                        (value) {

                      dropdownSelectionList[
                      pos]
                      [index] =
                      value
                      as String;

                      setState(
                              () {});
                    },
                  ),
                ),
              ),

              /// ERROR DROPDOWN
              questionList[pos][
              "qm_sheet_sub_parameter"]
              [index][
              "use_error_count"] ==
                  1 &&
                  dropdownSelectionList[
                  pos]
                  [index] ==
                      unsetTitle

                  ? Padding(

                padding:
                const EdgeInsets
                    .only(
                    top: 14),

                child:
                Container(

                  padding:
                  const EdgeInsets
                      .symmetric(
                    horizontal:
                    14,
                  ),

                  decoration:
                  BoxDecoration(

                    color:
                    Colors
                        .white,

                    borderRadius:
                    BorderRadius
                        .circular(
                        16),

                    border:
                    Border.all(
                      color: const Color(
                          0xFFE5E7EB),
                    ),
                  ),

                  child:
                  DropdownButtonHideUnderline(

                    child:
                    DropdownButton<String>(

                      isExpanded:
                      true,

                      hint:
                      const Text(
                        "Select Error Count",
                      ),

                      value:
                      errorDropdownSelectionList[
                      pos]
                      [index],

                      items:
                      errorScoringList[pos]
                      [index]
                          .map<
                          DropdownMenuItem<
                              String>>(
                            (
                            e) {

                          return DropdownMenuItem<
                              String>(

                            value:
                            e["error_count"]
                                .toString(),

                            child:
                            Text(
                              "Error Count : ${e["error_count"]} | Score : ${e["score"]}",
                            ),
                          );
                        },
                      ).toList(),

                      onChanged:
                          (value) {

                        errorDropdownSelectionList[
                        pos]
                        [index] =
                            value;

                        setState(
                                () {});
                      },
                    ),
                  ),
                ),
              )

                  : const SizedBox(),

              const SizedBox(
                  height: 14),

              /// REMARK FIELD
              TextFormField(

                controller:
                controllerList[
                pos][index],

                maxLines: 4,

                style:
                const TextStyle(
                  fontSize: 14,
                  fontWeight:
                  FontWeight
                      .w500,
                ),

                decoration:
                InputDecoration(

                  hintText:
                  "Enter remark here",

                  filled: true,

                  fillColor:
                  Colors.white,

                  contentPadding:
                  const EdgeInsets
                      .all(16),

                  border:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius
                        .circular(
                        18),

                    borderSide:
                    const BorderSide(
                      color: Color(
                          0xFFE5E7EB),
                    ),
                  ),

                  enabledBorder:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius
                        .circular(
                        18),

                    borderSide:
                    const BorderSide(
                      color: Color(
                          0xFFE5E7EB),
                    ),
                  ),

                  focusedBorder:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius
                        .circular(
                        18),

                    borderSide:
                    const BorderSide(
                      color: Color(
                          0xFF5B5FEF),
                      width: 1.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                  height: 18),

              /// BUTTONS
              Row(
                children: [

                  Expanded(
                    child:
                    ElevatedButton(

                      style:
                      ElevatedButton
                          .styleFrom(

                        elevation:
                        0,

                        backgroundColor:
                        const Color(
                            0xFFF1F5F9),

                        foregroundColor:
                        Colors.black,

                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                              16),
                        ),
                      ),

                      onPressed:
                          () {

                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder:
                                (
                                context) =>
                                QaViewArtifactScreen(

                                    widget
                                        .sheetID,

                                    questionList[
                                    pos]
                                    ["id"]
                                        .toString(),

                                    questionList[pos]
                                    [
                                    "qm_sheet_sub_parameter"]
                                    [index]
                                    ["id"]
                                        .toString(),

                                    AuditIdReal,

                                    questionList[
                                    pos]
                                    ["duplicate_index"]
                                        .toString(),
                                    locationFileterList[selectedFilterIndex]
                                ),
                          ),
                        );
                      },

                      child:
                      const Text(
                        "Show Artifact",
                        style:
                        TextStyle(
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                      width: 12),

                  Expanded(
                    child:
                    ElevatedButton(

                      style:
                      ElevatedButton
                          .styleFrom(

                        elevation:
                        0,

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

                      onPressed:
                          () async{

                        final artifactData = await Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder:
                                (
                                context) =>
                                QaUploadArtifactScreen(

                                    widget
                                        .sheetID,

                                    questionList[
                                    pos]
                                    ["id"]
                                        .toString(),

                                    questionList[pos]
                                    [
                                    "qm_sheet_sub_parameter"]
                                    [index]
                                    ["id"]
                                        .toString(),

                                    AuditIdReal,

                                    AuditIdReal,

                                    questionList[
                                    pos]
                                    ["duplicate_index"]
                                        .toString(),
                                    locationFileterList[selectedFilterIndex]
                                ),
                          ),
                        );
                        if (artifactData != null) {

                          updateQuestionArtifact(
                            pos,
                            artifactData,
                          );
                        }

                      },

                      child:
                      const Text(
                        "Artifact",
                        style:
                        TextStyle(
                          fontWeight:
                          FontWeight.w700,
                          color:
                          Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  void updateQuestionArtifact(
      int questionIndex,
      Map<String,dynamic> artifactData,
      ) {

    String subParamId =
    artifactData["sub_parameter_id"]
        .toString();

    List artifacts =
        artifactData["artifacts"] ?? [];

    List subParams =
    questionList[questionIndex]
    ["qm_sheet_sub_parameter"];

    int subIndex =
    subParams.indexWhere(
          (e) =>
      e["id"].toString()
          ==
          subParamId,
    );

    if (subIndex != -1) {

      /// create key if not exists
      subParams[subIndex]
      ["artifacts"] ??= [];

      subParams[subIndex]
      ["artifacts"]
          .addAll(
        artifacts,
      );

      setState(() {});
    }
  }

  bool showAddButton(
      int pos){

    int currentIndex=

        questionList[pos]
        ["duplicate_index"]
            ??1;

    int limit=

        questionList[pos]
        ["add_more_limit"]
            ??0;

    int total=

        questionList.where((e)=>

        e["id"].toString()==

            questionList[pos]
            ["id"]
                .toString()

        ).length;

    return

      questionList[pos]
      ["add_more"]==1

          &&

          currentIndex==1

          &&

          total<limit;
  }
  void addDuplicateParameter(
      int pos){

    var original=

    jsonDecode(
        jsonEncode(
            questionList[pos]
        ));

    int maxIndex=1;

    for(
    var item
    in questionList
    ){

      if(

      item["id"]
          .toString()

          ==

          original["id"]
              .toString()

      ){

        int index=

            item[
            "duplicate_index"]

                ??1;

        if(
        index>maxIndex
        ){
          maxIndex=index;
        }
      }
    }

    original[
    "duplicate_index"
    ]=maxIndex+1;

    for(
    var sub
    in original[
    "qm_sheet_sub_parameter"
    ]){

      sub[
      "selected_option"
      ]=null;

      sub[
      "remark"
      ]="";

      sub[
      "artifacts"
      ]=[];

      sub[
      "error_count"
      ]=null;
    }

    questionList.insert(
      pos+1,
      original,
    );

    List subParams=
    original[
    "qm_sheet_sub_parameter"
    ];

    dropdownSelectionList.insert(

        pos+1,

        List.generate(
            subParams.length,
                (_)=>null
        )
    );

    controllerList.insert(

        pos+1,

        List.generate(

            subParams.length,

                (_)=>TextEditingController()
        )
    );
    parameterRemarkControllerList.insert(

      pos+1,

      TextEditingController(),
    );
    errorDropdownSelectionList
        .insert(

        pos+1,

        List.generate(
            subParams.length,
                (_)=>null
        )
    );

    errorScoringList.insert(

        pos+1,

        List.generate(

            subParams.length,

                (index){

              return
                subParams[index]
                ["error_scoring"]!=null

                    ?

                jsonDecode(
                    subParams[index]
                    ["error_scoring"]
                )

                    :

                [];
            })
    );

    Toast.show("Parameter Added Successfully",duration: Toast.lengthLong,backgroundColor: Colors.green);

    setState(() {});
  }
  Future<void> removeParameter(
      int pos
      ) async {

    questionList.removeAt(pos);

    dropdownSelectionList
        .removeAt(pos);

    controllerList
        .removeAt(pos);

    errorDropdownSelectionList
        .removeAt(pos);

    errorScoringList
        .removeAt(pos);

    setState(() {});
  }
  void initializeLists() {

    dropdownSelectionList.clear();
    parameterRemarkControllerList.clear();

    for(var row in controllerList){
      for(var controller in row){
        controller.dispose();
      }
    }
    controllerList.clear();


    errorDropdownSelectionList.clear();
    errorScoringList.clear();

    for (int i = 0; i < questionList.length; i++) {

      List subParams =
          questionList[i]["qm_sheet_sub_parameter"] ?? [];

      /// Dropdown restore
      dropdownSelectionList.add(

        List.generate(

          subParams.length,

              (index){

            return subParams[index]
            ["selected_option"];
          },
        ),
      );

      /// Remarks restore
      controllerList.add(

        List.generate(

          subParams.length,

              (index){

            return TextEditingController(

              text:

              subParams[index]
              ["remark"]
                  ?.toString()
                  ??"",
            );
          },
        ),
      );

      parameterRemarkControllerList.add(
        TextEditingController(
          text:
          questionList[i]
          ["parameter_tag"]
              ?.toString()

              ?? "",
        ),
      );

      /// Error dropdown restore

      List<String?> errorSelection=[];

      List<List<dynamic>>
      errorScore=[];

      for(
      int j=0;
      j<subParams.length;
      j++
      ){

        errorSelection.add(
          subParams[j]
          ["error_count"]
              ?.toString(),
        );

        if(
        subParams[j]
        ["error_scoring"]
            !=null
        ){

          errorScore.add(

            jsonDecode(
              subParams[j]
              ["error_scoring"],
            ),
          );

        }else{

          errorScore.add([]);
        }
      }

      errorDropdownSelectionList
          .add(errorSelection);

      errorScoringList
          .add(errorScore);
    }

    setState(() {});
  }
  void validateAllParameter(){

    for(
    int i=0;
    i<questionList.length;
    i++
    ){
      int duplicateIndex= questionList[i]["duplicate_index"] ?? 1;
      String dupIndex=duplicateIndex>1?" ($duplicateIndex) ":"";


      if ( questionList[i]["add_more"]==1&&

      parameterRemarkControllerList[i]
          .text
          .trim()
          .isEmpty

      ) {

        Toast.show(
          "${questionList[i]["parameter"]} $dupIndex Parameter TAG is required",
          backgroundColor:
          Colors.red,
        );

        return;
      }

      List sub=
      questionList[i]
      ["qm_sheet_sub_parameter"];

      for(
      int j=0;
      j<sub.length;
      j++
      ){

        if(

        dropdownSelectionList
        [i][j]
            ==null
        ){

          Toast.show(

            "${sub[j]["sub_parameter"]} required",

            backgroundColor:
            Colors.red,
          );

          return;
        }

        /// error validation

        if(

        dropdownSelectionList
        [i][j]

            ==unsetTitle

            &&

            sub[j]
            ["use_error_count"]

                ==1

            &&

            errorDropdownSelectionList
            [i][j]

                ==null
        ){

          Toast.show(

            "Select error count",

            backgroundColor:
            Colors.red,
          );

          return;
        }

        /// artifact validation

        if(

        dropdownSelectionList
        [i][j]

            ==unsetTitle

        ){

          List artifacts=

              sub[j]
              ["artifacts"]
                  ??[];

          if(
          artifacts.isEmpty
          ){

            Toast.show(

              " ${sub[j]["sub_parameter"]} Artifact required",

              backgroundColor:
              Colors.red,
            );

            return;
          }
        }
        if(

        controllerList[i][j]
            .text
            .trim()
            .isEmpty

            &&

            (
                dropdownSelectionList[i][j]
                    ==unsetTitle

                    ||

                    dropdownSelectionList[i][j]
                        ==criticalTitle
                    ||

                    dropdownSelectionList[i][j]
                        ==naTitle
            )

        ){

          Toast.show(
            "Remark required",
            backgroundColor:
            Colors.red,
          );

          return;
        }
      }
    }

    prepareDataForSave();
  }
  Future<void> prepareDataForSave() async {

    APIDialog.showAlertDialog(
      context,
      "Please wait. Saving...",
    );

    var item = locationFileterList[selectedFilterIndex];
    List<dynamic> parameterList = [];
    List<Map<String, dynamic>>
    checkListData = [];
    /// LOOP ALL PARAMETERS

    for (int i = 0;
    i < questionList.length;
    i++) {

      List subParams = questionList[i]["qm_sheet_sub_parameter"];

      /// CHECKLIST

      Map<String,dynamic>parameterListChild = {questionList[i]["id"].toString():
      {

          "subs":{

            for(
            int r=0;
            r<subParams.length;
            r++
            )

              subParams[r]["id"]
                  .toString():

              {

                "option":

                dropdownSelectionList
                [i][r],

                "remark":

                controllerList
                [i][r]
                    .text,
              }
          }
        }
      };

      checkListData.add(
          parameterListChild);

      /// PARAMETER DATA
      print("***************Sub param list******************");
      log(subParams.toString());
      print("*********************************");

      for (
      int j = 0;
      j < subParams.length;
      j++
      ) {

        String weight = subParams[j]["weight"]
                ?.toString() ??
                "0";

        String scoreMain = "0";

        String scorableMain = weight;

        String selectedErrorCount =
            "";

        String selectedErrorScore =
            "";

        String selectedOption =

            dropdownSelectionList
            [i][j]
                ?.toString() ??
                "";

        /// SCORE CALCULATION

        if (selectedOption ==
            naTitle) {

          scoreMain = "0";

          scorableMain = "0";

        }

        else if (selectedOption ==
            satisTitle) {

          scoreMain = weight;

        }

        else if (selectedOption == unsetTitle && subParams[j]["use_error_count"] == 1
        ) {

          selectedErrorCount = errorDropdownSelectionList[i][j]?.toString() ?? "";

          if(selectedErrorCount.isNotEmpty){

            List errorList = errorScoringList[i][j];
            int selectedIndex =
            errorList.indexWhere((e)=> e["error_count"].toString() == selectedErrorCount);

            if(selectedIndex!=-1){

              selectedErrorScore= errorList[selectedIndex]["score"].toString();
              scoreMain= selectedErrorScore;
            }
          }
        }

        int isAddMore=questionList[i]["add_more"]??0;
        Map<String, dynamic> parameterData = {

          "parameter_id":
          questionList[i]["id"].toString(),

          "parameter_index":
          questionList[i]["duplicate_index"]
              .toString(),

          "parameter_tag": isAddMore==1  ? parameterRemarkControllerList[i].text.trim() : "",

          "sub_parameter_id":
          subParams[j]["id"]
              .toString(),

          "option_selected":
          selectedOption,

          "selected_option":
          scoreMain,

          "score":
          scoreMain,

          "scorable":
          scorableMain,

          "remark":
          controllerList[i][j].text,

          "is_critical":"0",

          "is_percentage":"0",

          "selected_per":"",

          "is_alert":"",

          "error_count":
          selectedErrorCount,

          "error_score":
          selectedErrorScore,

          "touch_point":
          questionList[i]["touch_point"],

          "compliance_experience":
          subParams[j]
          ["compliance_experience"],
        };

        /// ADD DYNAMIC FILTER VALUES

        [
          "location",
          "campus_type",
          "brand",
          "pillar",
        ].forEach((key) {

          final value = item[key];

          if ((value ?? "")
              .toString()
              .trim()
              .isNotEmpty) {

            parameterData[key] = value;
          }
        });

        parameterList.add(parameterData);
      }
    }

    var requestModel = {

      "audit_id":
      AuditIdReal,

      "qm_sheet_id":
      widget.sheetID,

      "parameters":
      parameterList,

      //"checksheet_data":
      //checkListData
    };

    log(
        jsonEncode(
            requestModel
        ));

    ApiBaseHelper helper =
    ApiBaseHelper();

    var response = await helper.postAPIWithHeader('v2/save-audit-result-v2', requestModel, context,);

    Navigator.pop(
        context);

    var responseJSON =
    jsonDecode(
        response.body);

    if (
    responseJSON[
    'status']
    ) {

      Toast.show(

        responseJSON[
        'message'],

        duration:
        Toast.lengthLong,

        gravity:
        Toast.bottom,

        backgroundColor:
        Colors.green,
      );
        fetchParameters();
    }

    else {

      Toast.show(

        responseJSON[
        'message'],

        duration:
        Toast.lengthLong,

        gravity:
        Toast.bottom,

        backgroundColor:
        Colors.red,
      );
    }
  }
  Future<void> deleteParameter(
      int pos,
      ) async {

    bool? shouldDelete =
    await showDialog<bool>(

      context: context,

      builder: (context){

        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20),
          ),

          title: const Text(
            "Delete Parameter",
          ),

          content: Text(

            "Are you sure you want to delete "
                "${questionList[pos]["parameter"]
                ??
                questionList[pos]["parameter_name"]
                ??
                "NA"}"
                " ?",
          ),

          actions: [

            TextButton(

              onPressed:(){

                Navigator.pop(
                    context,
                    false);
              },

              child:
              const Text(
                  "Cancel"
              ),
            ),

            ElevatedButton(

              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                Colors.red,
              ),

              onPressed:(){

                Navigator.pop(
                    context,
                    true);
              },

              child:
              const Text(
                "Delete",
                style:
                TextStyle(
                    color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if(
    shouldDelete!=true
    ){
      return;
    }

    try{

      APIDialog.showAlertDialog(
        context,
        "Deleting...",
      );

      var item=locationFileterList[selectedFilterIndex];
      var requestModel={

        "audit_id":
        AuditIdReal,

        "parameter_id":

        questionList[pos]
        ["id"]
            .toString(),

        "duplicate_index":

        questionList[pos]
        ["duplicate_index"]
            .toString(),
        "parameter_index":

        questionList[pos]
        ["duplicate_index"]
            .toString(),
      };

      [
        "location",
        "campus_type",
        "brand",
        "pillar",
        "touch_point",
      ].forEach((key) {

        final value = item[key];

        if ((value ?? "").toString().isNotEmpty) {
          requestModel[key] = value;
        }

      });

      ApiBaseHelper helper=
      ApiBaseHelper();

      var response=

      await helper.postAPIWithHeader(

        "v2/delete_saved_parameter_details",

        requestModel,

        context,
      );

      Navigator.pop(context);

      var responseJson=
      jsonDecode(
          response.body);

      questionList.removeAt(
          pos);

      dropdownSelectionList
          .removeAt(
          pos);

      controllerList
          .removeAt(
          pos);
      parameterRemarkControllerList
          .removeAt(pos);

      errorDropdownSelectionList
          .removeAt(
          pos);

      errorScoringList
          .removeAt(
          pos);

      setState(() {});

      Toast.show(

        "Parameter Deleted Successfully",

        backgroundColor:
        Colors.green,
      );

    }catch(e){

      Navigator.pop(context);

      Toast.show(

        "Something went wrong",

        backgroundColor:
        Colors.red,
      );

      print(
          "Delete Error $e");
    }
  }


  //*************************Result

  getResultFromServer() async {
    APIDialog.showAlertDialog(context, "Please wait.Calculating Score ...");
    var requestModel = {
      "audit_id": AuditIdReal,
      "qm_sheet_id": widget.sheetID,
    };
    print("Request Model $requestModel");
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(
        'v2/get_audit_complete_result', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    log(responseJSON.toString());
    if (responseJSON['status']) {

      parameterWiseResultList.clear();
      parameterWiseResultList=responseJSON['parameter_wise_result']??[];
      pillarWiseResultList= responseJSON['pillar_wise_result']['pillar_data']??[];
      var pillarWiseResult=responseJSON['pillar_wise_result'];
      pillarDataList =pillarWiseResult?["pillar_data"] ?? [];
      overallResult = pillarWiseResult?["overall_pillar_result"] ?? {};
      overallWeightedScore = double.tryParse(
        overallResult["final_percentage"]
            ?.toString() ??
            "0",
      ) ??
          0.0;
      totalPillarWeight = double.tryParse(
        overallResult["total_pillar_weight"]
            ?.toString() ??
            "0",
      ) ??
          0.0;

      setState(() {

      });


      showResultLayoutFunction();

    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  void showResultLayoutFunction() {
    showHomePgeLayout = false;
    showResultLayout= true;
    showFilterPageLayout=false;
    showParameterPageLayout=false;
    showSubParameterPageLayout=false;
    setState(() {});
  }
  Widget _showResultWidget() {




    return Column(
      children: [

        const SizedBox(height: 14),

        /// HEADER CARD
        Container(

          margin: const EdgeInsets.symmetric(
            horizontal: 14,
          ),

          padding: const EdgeInsets.all(22),

          decoration: BoxDecoration(

            borderRadius:
            BorderRadius.circular(28),

            gradient: const LinearGradient(
              colors: [
                Color(0xFF5B5FEF),
                Color(0xFF7C3AED),
              ],
            ),

            boxShadow: [
              BoxShadow(
                color:
                Colors.black.withOpacity(0.08),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Row(
                children: [

                  Container(
                    padding:
                    const EdgeInsets.all(12),

                    decoration: BoxDecoration(
                      color:
                      Colors.white.withOpacity(
                          0.15),

                      borderRadius:
                      BorderRadius.circular(
                          18),
                    ),

                    child: const Icon(
                      Icons.analytics_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: Text(
                      "Audit Summary",

                      style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                        FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              Row(
                children: [

                  Expanded(
                    child:
                    _summaryTopCard(
                      title:
                      "Weighted Score",

                      value:
                      "${overallWeightedScore.toStringAsFixed(2)}%",

                      icon:
                      Icons.speed_rounded,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child:
                    _summaryTopCard(
                      title:
                      "Parameters",

                      value:
                      "${parameterWiseResultList.length}",

                      icon:
                      Icons.list_alt_rounded,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        /// PARAMETER WISE HEADER
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),

          child: Row(
            children: [

              const Text(
                "Parameter Wise Result",

                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),

              const Spacer(),

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color:
                  const Color(0xFFF4F6FF),

                  borderRadius:
                  BorderRadius.circular(30),
                ),

                child: Text(
                  "${parameterWiseResultList.length} Items",

                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w700,
                    color: Color(0xFF5B5FEF),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        /// PARAMETER LIST
        ListView.builder(

          itemCount:
          parameterWiseResultList.length,

          shrinkWrap: true,

          physics:
          const NeverScrollableScrollPhysics(),

          padding:
          const EdgeInsets.symmetric(
            horizontal: 14,
          ),

          itemBuilder:
              (context, index) {

            var item = parameterWiseResultList[index];
            int duplicateIndex=item['parameter_index']??1;
            String dIndex=duplicateIndex>1?"($duplicateIndex)":"";

            return Container(

              margin:
              const EdgeInsets.only(
                bottom: 14,
              ),

              padding:
              const EdgeInsets.all(18),

              decoration:
              BoxDecoration(

                color: Colors.white,

                borderRadius:
                BorderRadius.circular(
                    24),

                boxShadow: [

                  BoxShadow(
                    color:
                    Colors.black.withOpacity(
                        0.04),

                    blurRadius: 18,

                    offset:
                    const Offset(
                        0, 6),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  /// TITLE ROW
                  Row(
                    children: [

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                          children: [

                            Text(

                              "${item["parameter_name"]} "
                                  "$dIndex",

                              style:
                              const TextStyle(
                                fontSize: 17,
                                fontWeight:
                                FontWeight
                                    .w700,

                                color: Color(
                                    0xFF111827),
                              ),
                            ),

                            const SizedBox(
                                height: 6),

                            Text(
                              item["pillar"]??"",

                              style:
                              TextStyle(
                                fontSize:
                                13,

                                color: Colors
                                    .grey
                                    .shade600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal:
                          12,
                          vertical: 8,
                        ),

                        decoration:
                        BoxDecoration(

                          color:
                          _getScoreColor(
                            double.parse(
                              item["percentage"]
                                  .toString(),
                            ),
                          ).withOpacity(
                              0.12),

                          borderRadius:
                          BorderRadius
                              .circular(
                              16),
                        ),

                        child: Text(
                          "${item["percentage"]}%",

                          style: TextStyle(
                            fontSize: 15,
                            fontWeight:
                            FontWeight
                                .w700,

                            color:
                            _getScoreColor(
                              double.parse(
                                item["percentage"]
                                    .toString(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [

                      Expanded(
                        child:
                        _scoreInfoCard(
                          title:
                          "Scored",

                          value:
                          item["total_score"]
                              .toString(),

                          icon:
                          Icons.star_rounded,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child:
                        _scoreInfoCard(
                          title:
                          "Scorable",

                          value:
                          item["total_scorable"]
                              .toString(),

                          icon:
                          Icons.analytics_outlined,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 10),

        /// PILLAR HEADER
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),

          child: Row(
            children: [

              const Text(
                "Pillar Wise Result",

                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),

              const Spacer(),

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color:
                  const Color(0xFFF4F6FF),

                  borderRadius:
                  BorderRadius.circular(30),
                ),

                child: Text(
                  "${pillarDataList.length} Pillars",

                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w700,
                    color: Color(0xFF5B5FEF),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        /// PILLAR LIST
        ListView.builder(

          itemCount:
          pillarDataList.length,

          shrinkWrap: true,

          physics:
          const NeverScrollableScrollPhysics(),

          padding:
          const EdgeInsets.symmetric(
            horizontal: 14,
          ),

          itemBuilder:
              (context, index) {

            var item =
            pillarDataList[index];

            return Container(

              margin:
              const EdgeInsets.only(
                bottom: 14,
              ),

              padding:
              const EdgeInsets.all(20),

              decoration:
              BoxDecoration(

                color: Colors.white,

                borderRadius:
                BorderRadius.circular(
                    24),

                boxShadow: [

                  BoxShadow(
                    color:
                    Colors.black.withOpacity(
                        0.04),

                    blurRadius: 18,

                    offset:
                    const Offset(
                        0, 6),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Row(
                    children: [

                      Expanded(
                        child: Text(

                          item["pillar"]??"",

                          style:
                          const TextStyle(
                            fontSize: 17,
                            fontWeight:
                            FontWeight
                                .w700,

                            color: Color(
                                0xFF111827),
                          ),
                        ),
                      ),

                      Container(
                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal:
                          12,
                          vertical: 8,
                        ),

                        decoration:
                        BoxDecoration(

                          color:
                          const Color(
                              0xFF5B5FEF)
                              .withOpacity(
                              0.10),

                          borderRadius:
                          BorderRadius
                              .circular(
                              16),
                        ),

                        child: Text(
                          "${item["weighted_score"]}%",

                          style:
                          const TextStyle(
                            fontSize: 15,
                            fontWeight:
                            FontWeight
                                .w700,

                            color: Color(
                                0xFF5B5FEF),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Expanded(
                        child:
                        _pillarInfoItem(
                          title:
                          "Score/Scorable",
                          value: "${item["total_score"].toString()}/${item["total_scorable"].toString()}", //item["total_score"].toString(),
                        ),
                      ),
                      Expanded(
                        child:
                        _pillarInfoItem(
                          title:
                          "Weighted/weight",
                          value: "${item["weighted_score"].toString()}/${item["pillar_weight"].toString()}", //item["total_score"].toString(),
                        ),
                      ),

                    /*  Expanded(
                        child:
                        _pillarInfoItem(
                          title:
                          "Piller Weight",
                          value: item["pillar_weight"].toString(), //item["total_score"].toString(),
                        ),
                      ),

                      Expanded(
                        child:
                        _pillarInfoItem(
                          title:
                          "Scorable",

                          value:
                          item["total_scorable"]
                              .toString(),
                        ),
                      ),*/

                      /*Expanded(
                        child:
                        _pillarInfoItem(
                          title:
                          "Weight",

                          value:
                          "${item["pillar_weight"]}%",
                        ),
                      ),*/
                    ],
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 18),

        /// FINAL SUMMARY CARD
        Container(

          margin: const EdgeInsets.symmetric(
            horizontal: 14,
          ),

          padding: const EdgeInsets.all(22),

          decoration: BoxDecoration(

            borderRadius:
            BorderRadius.circular(28),

            color: const Color(0xFF111827),

            boxShadow: [
              BoxShadow(
                color:
                Colors.black.withOpacity(0.08),

                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: Column(
            children: [

              const Text(
                "Final Audit Score",

                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "${overallWeightedScore.toStringAsFixed(2)}%",

                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [

                  Expanded(
                    child: _overallScoreItem(
                      title: "Weighted Score",
                      value:
                      overallResult[
                      "total_weighted_score"]
                          .toString(),
                    ),
                  ),

                  Expanded(
                    child: _overallScoreItem(
                      title: "Pillar Weight",
                      value:
                      "${totalPillarWeight.toStringAsFixed(0)}%",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        /// BACK BUTTON
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF111827),
                side: const BorderSide(color: Color(0xFFE5E7EB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                saveBasicDetails();
              },
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text(
                "Back",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        /// SUBMIT BUTTON
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
          ),

          child: SizedBox(

            width: double.infinity,
            height: 58,

            child: ElevatedButton(

              style:
              ElevatedButton.styleFrom(

                backgroundColor:
                const Color(0xFF5B5FEF),

                elevation: 0,

                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                      20),
                ),
              ),

              onPressed: () {
                submitAudit();
              },

              child: const Row(
                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  Text(
                    "Submit Audit",

                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(width: 8),

                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 30),
      ],
    );
  }
  /// TOP SUMMARY CARD
  Widget _summaryTopCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: Colors.white.withOpacity(0.12),

        borderRadius:
        BorderRadius.circular(18),
      ),

      child: Column(
        children: [

          Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),

          const SizedBox(height: 10),

          Text(
            value,

            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,

            style: TextStyle(
              fontSize: 13,
              color:
              Colors.white.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
  Widget _overallScoreItem({
    required String title,
    required String value,
  }) {
    return Column(
      children: [

        Text(
          value,

          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          title,

          textAlign: TextAlign.center,

          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
  /// SCORE INFO CARD

  Widget _scoreInfoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: const Color(0xFFF8FAFC),

        borderRadius:
        BorderRadius.circular(18),
      ),

      child: Column(
        children: [

          Icon(
            icon,
            color: const Color(0xFF5B5FEF),
          ),

          const SizedBox(height: 8),

          Text(
            value,

            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,

            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
  /// PILLAR ITEM
  Widget _pillarInfoItem({
    required String title,
    required String value,
  }) {
    return Column(
      children: [

        Text(
          value,

          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),

        const SizedBox(height: 4),

        Text(
          title,

          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  /// SCORE COLOR

  Color _getScoreColor(double percentage) {

    if (percentage >= 85) {
      return Colors.green;
    } else if (percentage >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
  submitAudit() async {

    APIDialog.showAlertDialog(context, "Submitting Audit...");
    //subparameter
    var requestModel = {
      "audit_id":AuditIdReal,
    };
    log(json.encode(requestModel));
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('v2/submitAudit', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    if (responseJSON['status'].toString() == "1") {
      if (AppModel.rebuttalData.length != 0 && !widget.isEdit) {
        Toast.show(
            "Audit Submitted successfully!",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.green);
        Navigator.pop(context);
        //uploadImage("submit", responseJSON["audit_id"].toString());
      } else {
        Toast.show(responseJSON['message'],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.green);
        Navigator.pop(context);
      }
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }






}