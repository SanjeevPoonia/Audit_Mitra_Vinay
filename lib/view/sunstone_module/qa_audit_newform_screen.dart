import 'dart:convert';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qaudit_tata_flutter/view/sunstone_module/qa_upload_artifact_screen.dart';
import 'package:qaudit_tata_flutter/view/sunstone_module/qa_view_artifact_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../network/loader.dart';
import '../../utils/app_design.dart';
import '../../utils/app_modal.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../utils/app_theme.dart';
import '../../widgets/dropdown_widget.dart';
import '../../widgets/textfield_widget.dart';
import 'package:intl/intl.dart';

import '../upload_artifact_screen.dart';
import '../view_artifact_screen.dart';

class QaAuditNewFormScreen extends StatefulWidget{
  final String sheetID;
  final String sheetName;
  Map<String, dynamic> lobData;
  bool isEdit;
  String auditID;
  String auditAgencyID;

  QaAuditNewFormScreen(this.sheetID, this.lobData, this.sheetName, this.isEdit,
      this.auditID, this.auditAgencyID);

  _qaAuditForm createState()=> _qaAuditForm();

}
class _qaAuditForm extends State<QaAuditNewFormScreen>{
  bool hasInternet = true;
  List<dynamic> questionList = [];
  var dropdownSelectionList = [[]];
  var controllerList = [[]];
  String AuditIdReal = "";
  bool isLoading=false;
  bool showBasicLayout = false;
  bool showResultLayout= false;
  bool showHomePgeLayout=true;
  String current_showing="";
  var agencySearchController = TextEditingController();
  List<dynamic> locationList=[];
  var locationSearchController = TextEditingController();
  List<dynamic> filteredLocationList = [];
  String selectedLocation = "";
  List<dynamic> campusTypeList=[];
  var campusSearchController = TextEditingController();
  List<dynamic> filteredCampusList = [];
  String selectedCampus = "";
  List<dynamic> brandsList=[];
  var brandsSearchController = TextEditingController();
  List<dynamic> filteredbrandsList = [];
  String selectedBrand = "";
  List<dynamic> pillarList=[];
  var pillarSearchController = TextEditingController();
  List<dynamic> filteredPillarList = [];
  String selectedPillar = "";
  Position? _currentPosition;
  var latLongController = TextEditingController();
  List<dynamic> agencyList = [];
  List<dynamic> filteredAgencyList = [];
  List<String> auditCycleListAsString = [];
  List<dynamic> auditCycleList = [];
  String? selectedAuditCycle;
  int selectedAgencyIndex = 9999;
  var agencyNameController = TextEditingController();
  var agencyManagerNameController = TextEditingController();
  var agencyPhoneController = TextEditingController();
  var agencyAddressController = TextEditingController();
  var branchNameController = TextEditingController();
  var cityNameController = TextEditingController();
  var locationNameController = TextEditingController();
  var latLongHomeController = TextEditingController();
  var presentAuditorController = TextEditingController();
  String? selectedDate;
  String? userName;
  String selectedAgencyId = "";

  List<List<String?>> errorDropdownSelectionList = [];
  List<List<List<dynamic>>> errorScoringList = [];
  int questionCurrentPosition = 0;

  String satisTitle = "Yes";
  String unsetTitle = "No";
  String naTitle = "N/A";
  String criticalTitle = "Critical";
  String pwdTitle = "PWD";
  String percentageTitle = "Percentage";
  List<previousRemark> prevRemarkList = [];
  var weightList = [[]];
  Map<String, int> parameterIndexMap = {};

  List<dynamic> pillarWiseResultList=[];
  List<dynamic> parameterWiseResultList=[];
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
                          /*current_showing.isEmpty
                              ? "Audit In Process"
                              : "Question $current_showing",*/
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

                      !hasInternet

                          ? const SizedBox()

                          : showHomePgeLayout

                          ? _homePageWidget()

                          : showBasicLayout

                          ? _basicDetailWidget()

                          : showResultLayout

                          ? _showResultWidget()

                          : Container(

                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),

                        decoration: BoxDecoration(

                          color: Colors.white,

                          borderRadius:
                          BorderRadius.circular(20),

                          boxShadow: [
                            BoxShadow(
                              color:
                              Colors.black.withOpacity(0.04),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            Container(

                              height: 52,

                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 18,
                              ),

                              decoration:
                              const BoxDecoration(

                                borderRadius:
                                BorderRadius.only(
                                  topLeft:
                                  Radius.circular(20),
                                  topRight:
                                  Radius.circular(20),
                                ),

                                gradient:
                                LinearGradient(
                                  colors: [
                                    Color(0xFF5B5FEF),
                                    Color(0xFF7C3AED),
                                  ],
                                ),
                              ),

                              child: const Row(
                                children: [

                                  Icon(
                                    Icons.assignment_rounded,
                                    color: Colors.white,
                                  ),

                                  SizedBox(width: 10),

                                  Text(
                                    "Audit Questions",

                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                      FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            _questionWiseWidget(),
                          ],
                        ),
                      ),

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
      hasInternet = false;
      setState(() {});
      fetchLocalData();
    } else {
      hasInternet = true;
      setState(() {});
      if (widget.isEdit) {
        AuditIdReal = widget.auditID;
        /*  viewAuditData(context);
        fetchAllocatedModule();*/
      } else {
        AuditIdReal = "";
        fetchDropdownData();
        //fetchCities();
        fetchAgencies();
        fetchAuditCycleList();
        //fetchUserList();
        //fetchAllocatedModule();
      }
    }
  }
  fetchLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("question_list");
    if (data != null) {
      List<dynamic> list2 = jsonDecode(data);
      print("Data LENGTH" + list2.length.toString());
      for (int i = 0; i < list2.length; i++) {
        print("Sheet IU " + list2[i]["sheet_id"].toString());
        if (widget.sheetID == list2[i]["sheet_id"].toString()) {
          print("Match Found");
          questionList = list2[i]["p_data"];
          print(questionList.toString());
          break;
        }
      }

      int row = questionList.length;
      int col = 20;
      dropdownSelectionList = List<List>.generate(
          row, (i) => List<dynamic>.generate(col, (index) => null));
      controllerList = List<List>.generate(
          row,
              (i) => List<TextEditingController>.generate(
              col, (index) => TextEditingController()));

      setState(() {});
    } else {
      Toast.show("No Internet!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  fetchDropdownData() async {
    setState(() {
      isLoading = true;
    });
    var requestModel = {"qm_sheet_id": widget.sheetID};
    print(requestModel);
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.getWithHeader('v2/get-mapping-dropdown-data', requestModel, context);
    var responseJSON = json.decode(response.body);

    print(responseJSON);

    locationList = List.from(responseJSON['data']['locations'] ?? []);
    campusTypeList = List.from(responseJSON['data']['campus_types'] ?? []);
    brandsList = List.from(responseJSON['data']['brands'] ?? []);
    pillarList = List.from(responseJSON['data']['pillar'] ?? []);

    setState(() {
      isLoading = false;
    });

    int row = questionList.length;
    int col = 20;
    dropdownSelectionList = List<List>.generate(
        row, (i) => List<dynamic>.generate(col, (index) => null));
    /*weightList = List<List>.generate(
        row, (i) => List<String>.generate(col, (index) => ""));*/
    controllerList = List<List>.generate(
        row,
            (i) => List<TextEditingController>.generate(
            col, (index) => TextEditingController()));
    print("Hello 2D");
    print(responseJSON);
    setState(() {});
  }
  void selectLocationBottomSheet(BuildContext context) {
    filteredLocationList = List.from(locationList);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, bottomSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// Top Drag Line
                    SizedBox(height: 5),
                    Center(
                      child: Container(
                        height: 6,
                        width: 62,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    /// Header
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Text(
                          "Select Location",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        )
                      ],
                    ),

                    SizedBox(height: 15),

                    /// Search Field
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
                        controller: locationSearchController,
                        onChanged: (value) {

                          if (value.isEmpty) {
                            filteredLocationList =
                                List.from(locationList);
                          } else {
                            filteredLocationList = locationList
                                .where((location) => location
                                .toString()
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                                .toList();
                          }

                          bottomSheetState(() {});
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search Location",
                          suffixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    /// Location List
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        itemCount: filteredLocationList.length,
                        itemBuilder: (context, index) {

                          String location =
                          filteredLocationList[index].toString();

                          return InkWell(
                            onTap: () {

                              bottomSheetState(() {
                                selectedLocation = location;
                              });
                            },
                            child: Container(
                              height: 55,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.centerLeft,
                              color: selectedLocation == location
                                  ? Color(0xFFFF7C00).withOpacity(0.10)
                                  : Colors.white,
                              child: Text(
                                location,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 15),

                    /// Select Button
                    SizedBox(
                      height: 53,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {

                          if (selectedLocation.isNotEmpty) {

                            Navigator.pop(context);
                            print(selectedLocation);
                            setState(() {});
                            // checkValidationForBasic();
                          }
                        },
                        child: Text("Select"),
                      ),
                    ),

                    SizedBox(height: 15),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
      /*ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));*/
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
        /*ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));*/
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Toast.show(
          "Location permissions are permanently denied, we cannot request permissions.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      /*ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));*/
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

      // _getAddressFromLatLng(position);
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
  Widget _basicDetailWidget() {



    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),

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
                  Color(0xFF5B5FEF),
                  Color(0xFF7C3AED),
                ],
              ),
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Row(
                  children: [

                    Container(
                      padding: const EdgeInsets.all(10),

                      decoration: BoxDecoration(
                        color:
                        Colors.white.withOpacity(0.15),

                        borderRadius:
                        BorderRadius.circular(14),
                      ),

                      child: const Icon(
                        Icons.apartment_rounded,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Expanded(
                      child: Text(
                        "Audit Parameters",
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
                  "Select all required details",
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

                /// LOCATION
                _modernSelectionTile(
                  title: "Location*",

                  value: selectedLocation.isEmpty
                      ? "Select Location"
                      : selectedLocation,

                  icon: Icons.location_on_rounded,

                  onTap: () {
                    selectLocationBottomSheet(
                      context,
                    );
                  },
                ),

                const SizedBox(height: 18),

                /// CAMPUS TYPE
                _modernSelectionTile(
                  title: "Campus Type*",

                  value: selectedCampus.isEmpty
                      ? "Select Campus Type"
                      : selectedCampus,

                  icon: Icons.school_rounded,

                  onTap: () {
                    selectCampusTypeBottomSheet(
                      context,
                    );
                  },
                ),

                const SizedBox(height: 18),

                /// BRAND
                AnimatedSwitcher(
                  duration:
                  const Duration(
                    milliseconds: 300,
                  ),

                  child:
                  selectedCampus.isNotEmpty &&
                      selectedCampus ==
                          "Brand"

                      ? Column(
                    children: [

                      _modernSelectionTile(

                        title: "Brand*",

                        value:
                        selectedBrand
                            .isEmpty
                            ? "Select Brand"
                            : selectedBrand,

                        icon:
                        Icons
                            .storefront_rounded,

                        onTap: () {

                          selectBrandsBottomSheet(
                            context,
                          );
                        },
                      ),

                      const SizedBox(
                          height: 18),
                    ],
                  )

                      : const SizedBox(),
                ),

                /// PILLAR
                _modernSelectionTile(
                  title: "Pillar*",

                  value: selectedPillar.isEmpty
                      ? "Select Pillar"
                      : selectedPillar,

                  icon:
                  Icons.dashboard_customize,

                  onTap: () {
                    selectPillarBottomSheet(
                      context,
                    );
                  },
                ),

                const SizedBox(height: 30),

                /// NEXT BUTTON
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

                      if (hasInternet) {
                        checkValidationForBasic();
                      }
                    },

                    child: const Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,

                      children: [

                        Text(
                          "Next",
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
  /*Widget _basicDetailWidget() {
    setState(() {
      current_showing="";
    });

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
          border: Border.all(color: Colors.black, width: 0.7)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 46,
            color: AppTheme.newThemeColor,
            child: Row(
              children: [
                SizedBox(width: 10),
                Text("Agency",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    )),
              ],
            ),
          ),
          SizedBox(height: 12),
          DropDownWidget2(
                () {
              selectLocationBottomSheet(context);
            },
            "Location*",
            selectedLocation .isEmpty
                ? "Select Location"
                : selectedLocation,
            selectedLocation .isEmpty
                ? Colors.black.withOpacity(0.7)
                : Colors.black,
          ),
          SizedBox(height: 12),
          DropDownWidget2(
                () {
                  selectCampusTypeBottomSheet(context);
            },
            "Campus Type*",
            selectedCampus .isEmpty
                ? "Select Campus Type"
                : selectedCampus,
            selectedCampus .isEmpty
                ? Colors.black.withOpacity(0.7)
                : Colors.black,
          ),
          SizedBox(height: 12),
          selectedCampus.isNotEmpty && selectedCampus=="Brand"?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropDownWidget2(
                        () {
                      selectBrandsBottomSheet(context);
                    },
                    "Brand*",
                    selectedBrand .isEmpty
                        ? "Select Brand"
                        : selectedBrand,
                    selectedBrand .isEmpty
                        ? Colors.black.withOpacity(0.7)
                        : Colors.black,
                  ),
                  SizedBox(height: 12),
                ],
              ):Container(),
          DropDownWidget2(
                () {
              selectPillarBottomSheet(context);
            },
            "Pillar*",
            selectedPillar .isEmpty
                ? "Select Pillar"
                : selectedPillar,
            selectedPillar .isEmpty
                ? Colors.black.withOpacity(0.7)
                : Colors.black,
          ),
          SizedBox(height: 20),
          Center(
            child: Card(
              elevation: 3,
              shadowColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Container(
                height: 44,
                child: ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white), // background
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xFFFF5100)), // fore
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ))),
                  onPressed: () {
                    if (hasInternet) {
                      checkValidationForBasic();
                    }
                  },
                  child: const Text(
                    'NEXT',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),

        ],
      ),
    );
  }*/
  void selectCampusTypeBottomSheet(BuildContext context) {
    filteredCampusList = List.from(campusTypeList);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, bottomSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// Top Drag Line
                    SizedBox(height: 5),
                    Center(
                      child: Container(
                        height: 6,
                        width: 62,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    /// Header
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Text(
                          "Select Campus Type",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        )
                      ],
                    ),

                    SizedBox(height: 15),

                    /// Search Field
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
                        controller: campusSearchController,
                        onChanged: (value) {

                          if (value.isEmpty) {
                            filteredCampusList =
                                List.from(campusTypeList);
                          } else {
                            filteredCampusList = campusTypeList
                                .where((location) => location
                                .toString()
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                                .toList();
                          }

                          bottomSheetState(() {});
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search Campus Type",
                          suffixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    /// Location List
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        itemCount: filteredCampusList.length,
                        itemBuilder: (context, index) {

                          String location =
                          filteredCampusList[index].toString();

                          return InkWell(
                            onTap: () {

                              bottomSheetState(() {
                                selectedCampus = location;
                              });
                            },
                            child: Container(
                              height: 55,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.centerLeft,
                              color: selectedCampus == location
                                  ? Color(0xFFFF7C00).withOpacity(0.10)
                                  : Colors.white,
                              child: Text(
                                location,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 15),

                    /// Select Button
                    SizedBox(
                      height: 53,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {

                          if (selectedCampus.isNotEmpty) {

                            Navigator.pop(context);
                            print(selectedCampus);
                            setState(() {});
                            //checkValidationForBasic();
                          }
                        },
                        child: Text("Select"),
                      ),
                    ),

                    SizedBox(height: 15),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  void selectBrandsBottomSheet(BuildContext context) {
    filteredbrandsList = List.from(brandsList);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, bottomSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// Top Drag Line
                    SizedBox(height: 5),
                    Center(
                      child: Container(
                        height: 6,
                        width: 62,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    /// Header
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Text(
                          "Select Brand",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        )
                      ],
                    ),

                    SizedBox(height: 15),

                    /// Search Field
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
                        controller: brandsSearchController,
                        onChanged: (value) {

                          if (value.isEmpty) {
                            filteredbrandsList =
                                List.from(brandsList);
                          } else {
                            filteredbrandsList = brandsList
                                .where((location) => location
                                .toString()
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                                .toList();
                          }

                          bottomSheetState(() {});
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search Brand",
                          suffixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    /// Location List
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        itemCount: filteredbrandsList.length,
                        itemBuilder: (context, index) {

                          String location =
                          filteredbrandsList[index].toString();

                          return InkWell(
                            onTap: () {

                              bottomSheetState(() {
                                selectedBrand = location;
                              });
                            },
                            child: Container(
                              height: 55,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.centerLeft,
                              color: selectedBrand == location
                                  ? Color(0xFFFF7C00).withOpacity(0.10)
                                  : Colors.white,
                              child: Text(
                                location,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 15),

                    /// Select Button
                    SizedBox(
                      height: 53,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {

                          if (selectedBrand.isNotEmpty) {
                            Navigator.pop(context);
                            print(selectedBrand);
                            setState(() {});
                            // checkValidationForBasic();
                          }
                        },
                        child: Text("Select"),
                      ),
                    ),

                    SizedBox(height: 15),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  void selectPillarBottomSheet(BuildContext context) {
    filteredPillarList = List.from(pillarList);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, bottomSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// Top Drag Line
                    SizedBox(height: 5),
                    Center(
                      child: Container(
                        height: 6,
                        width: 62,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    /// Header
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Text(
                          "Select Pillar",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        )
                      ],
                    ),

                    SizedBox(height: 15),

                    /// Search Field
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
                        controller: pillarSearchController,
                        onChanged: (value) {

                          if (value.isEmpty) {
                            filteredPillarList =
                                List.from(pillarList);
                          } else {
                            filteredPillarList = pillarList
                                .where((location) => location
                                .toString()
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                                .toList();
                          }

                          bottomSheetState(() {});
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search Pillar",
                          suffixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    /// Location List
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        itemCount: filteredPillarList.length,
                        itemBuilder: (context, index) {

                          String location =
                          filteredPillarList[index].toString();

                          return InkWell(
                            onTap: () {

                              bottomSheetState(() {
                                selectedPillar = location;
                              });
                            },
                            child: Container(
                              height: 55,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.centerLeft,
                              color: selectedPillar == location
                                  ? Color(0xFFFF7C00).withOpacity(0.10)
                                  : Colors.white,
                              child: Text(
                                location,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 15),

                    /// Select Button
                    SizedBox(
                      height: 53,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {

                          if (selectedPillar.isNotEmpty) {

                            Navigator.pop(context);
                            print(selectedPillar);
                            setState(() {});
                            //checkValidationForBasic();
                          }
                        },
                        child: Text("Select"),
                      ),
                    ),

                    SizedBox(height: 15),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  checkValidationForBasic() {
    if (selectedLocation.isEmpty) {
      Toast.show("Please select Location",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    else if (selectedCampus.isEmpty) {
      Toast.show("Please select Campus Type",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else if (selectedCampus.isNotEmpty && selectedCampus == "Brand" && selectedBrand.isEmpty) {
      Toast.show("Please select Brand",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else if (selectedPillar.isEmpty) {
      Toast.show("Please Select Pillar",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }  else {
      fetchMainParams();
    }
  }
  /*****************Home First Page Layout *********************************/
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
    setState(() {});
  }
  fetchAuditCycleList() async {
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
    setState(() {});
  }
  /*Widget _homePageWidget() {
    setState(() {
      current_showing="";
    });

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
          border: Border.all(color: Colors.black, width: 0.7)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 46,
            color: AppTheme.newThemeColor,
            child: Row(
              children: [
                SizedBox(width: 10),
                Text("Collection | Agency",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    )),
              ],
            ),
          ),
          SizedBox(height: 12),
          DropDownWidget2(
                () {
              selectAgencyBottomSheet(context);
            },
            "Agency*",
            selectedAgencyIndex == 9999
                ? "Select agency"
                : agencySearchController.text.toString().length == 0
                ? agencyList[selectedAgencyIndex]["agency_id"].toString() +
                " " +
                agencyList[selectedAgencyIndex]["name"]
                : filteredAgencyList[selectedAgencyIndex]["agency_id"]
                .toString() +
                " " +
                filteredAgencyList[selectedAgencyIndex]["name"]
                    .toString(),
            selectedAgencyIndex == 9999
                ? Colors.black.withOpacity(0.7)
                : Colors.black,
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text("Audit Cycle*",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.7),
                )),
          ),
          SizedBox(height: 2),
          widget.isEdit
              ? Container(
            // width: 80,
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black, width: 0.5)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                enableFeedback: false,
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.only(left: 12),
                ),
                iconStyleData: IconStyleData(
                  icon: Icon(Icons.keyboard_arrow_down_outlined,
                      color: Colors.black),
                ),
                isExpanded: true,
                hint: Text('Select audit cycle',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.7),
                    )),
                items: auditCycleListAsString
                    .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                        fontSize: 14, color: Colors.black),
                  ),
                ))
                    .toList(),
                value: selectedAuditCycle,
                onChanged: null,
              ),
            ),
          )
              : Container(
            // width: 80,
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black, width: 0.5)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.only(left: 12),
                ),
                iconStyleData: IconStyleData(
                  icon: Icon(Icons.keyboard_arrow_down_outlined,
                      color: Colors.black),
                ),
                isExpanded: true,
                hint: Text('Select audit cycle',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.7),
                    )),
                items: auditCycleListAsString
                    .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ))
                    .toList(),
                value: selectedAuditCycle,
                onChanged: (value) {
                  setState(() {
                    selectedAuditCycle = value as String;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text("Audit Date*",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.7),
                )),
          ),
          SizedBox(height: 2),
          GestureDetector(
            onTap: () async {
              if (!widget.isEdit) {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2100));

                if (pickedDate != null) {
                  String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
                  selectedDate = formattedDate.toString();
                  setState(() {});
                }
              }
            },
            child: Container(
              height: 41,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: widget.isEdit
                      ? Colors.grey.withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black, width: 0.5)),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: Text(
                          selectedDate == null
                              ? "Select date"
                              : selectedDate.toString(),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: selectedDate == null
                                ? Colors.black.withOpacity(0.7)
                                : Colors.black,
                          )),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(Icons.calendar_month,
                          color: AppTheme.newThemeColor)),
                ],
              ),
            ),
          ),
          SizedBox(height: 12),
          TextFieldWidgetNew(
              "Present Auditor*",
              enabled: false,
              "Enter here", presentAuditorController),
          SizedBox(height: 12),
          TextFieldWidgetMultiLine(
              "Agency Address", "-", agencyAddressController,
              enabled: false),
          SizedBox(height: 12),
          TextFieldWidgetNew("City", "-", cityNameController,
              enabled: false),
          SizedBox(height: 12),
          TextFieldWidgetNew(
              "Location", "-", locationNameController,
              enabled: false),
          SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              if (!widget.isEdit) {
                print("Click Triggered");
                _getCurrentPosition();
              }
            },
            child: TextFieldWidgetNew(
                "Geo tag", "Tap here", latLongController,
                enabled: false),
          ),
          SizedBox(height: 12),


          SizedBox(height: 20),
          Center(
            child: Card(
              elevation: 3,
              shadowColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Container(
                height: 44,
                child: ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white), // background
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xFFFF5100)), // fore
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ))),
                  onPressed: () {
                    if (hasInternet) {
                      checkValidationForHomePage();
                    }
                  },
                  child: const Text(
                    'SAVE & NEXT',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }*/
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

                      if (hasInternet) {
                        checkValidationForHomePage();
                      }
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
    showBasicLayout = true;
    setState(() {});
  }
  /**************************Question List *******************/
  fetchMainParams() async {
    APIDialog.showAlertDialog(context, "Please wait...");
    var requestModels = {
      "location": selectedLocation,
      "campus_type": selectedCampus,
      "brand": selectedBrand,
      "pillar": selectedPillar,
    };
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('v2/get-final-parameters', requestModels, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    questionList.clear();
    questionList=List.from(responseJSON['parameters'] ?? []);
    parameterIndexMap.clear();
    for (int i = 0; i < questionList.length; i++) {
      String paramId =
      questionList[i]["id"].toString();
      parameterIndexMap[paramId] = 1;
      questionList[i]["duplicate_index"] = 1;
    }
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
    dropdownSelectionList.clear();
    controllerList.clear();
    weightList.clear();

    for (int i = 0; i < questionList.length; i++) {

      List subParams =
          questionList[i]["qm_sheet_sub_parameter"] ?? [];

      dropdownSelectionList.add(
        List<dynamic>.generate(
          subParams.length,
              (index) => null,
        ),
      );

      controllerList.add(
        List<TextEditingController>.generate(
          subParams.length,
              (index) => TextEditingController(),
        ),
      );

      weightList.add(
        List<String>.generate(
          subParams.length,
              (index) => "",
        ),
      );
    }

    setState(() {});
    if(questionList.isNotEmpty){
      saveHomeDetails();
      questionCurrentPosition = 0;
      WidgetsBinding.instance
          .addPostFrameCallback((_) {
        _selectParameterAt(0);
      });
    }else{
      Toast.show("Parameters and Sub parameters not found for selected Fields",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }

  }
  void saveHomeDetails() {
    showHomePgeLayout = false;
    showBasicLayout = false;
    setState(() {});
  }
  int findUnsatDependancies(String paramId, String subParamId) {
    final position = prevRemarkList.indexWhere(
          (item) => item.paramId == paramId && item.subParamId == subParamId,
    );
    return position;
  }

  List<dynamic> _subParametersForIndex(int index) {
    if (index < 0 || index >= questionList.length) {
      return [];
    }
    final item = questionList[index];
    if (widget.isEdit && item["subparameter"] != null) {
      return List<dynamic>.from(item["subparameter"] ?? []);
    }
    return List<dynamic>.from(item["qm_sheet_sub_parameter"] ?? []);
  }

  String _parameterIndexFor(int index) {
    if (index < 0 || index >= questionList.length) {
      return "1";
    }
    return (questionList[index]["duplicate_index"] ?? 1).toString();
  }

  String _parameterTitleFor(int index) {
    if (index < 0 || index >= questionList.length) {
      return "";
    }
    final name = questionList[index]["parameter"]?.toString() ?? "";
    final duplicateIndex = int.tryParse(_parameterIndexFor(index)) ?? 1;
    return duplicateIndex > 1 ? "$name #$duplicateIndex" : name;
  }

  Map<String, dynamic> _parameterDetailsRequest(int index) {
    return {
      "audit_id": AuditIdReal,
      "parameter_id": questionList[index]["id"].toString(),
      "parameter_index": _parameterIndexFor(index),
      "location": selectedLocation,
      "campus_type": selectedCampus,
      "brand": selectedBrand,
      "pillar": selectedPillar,
    };
  }

  Future<Map<String, dynamic>?> _fetchSavedParameterDetails(
      int index, {
        bool showLoader = false,
      }) async {
    if (!hasInternet || index < 0 || index >= questionList.length) {
      return null;
    }
    if (showLoader) {
      APIDialog.showAlertDialog(context, "Loading parameter details...");
    }
    try {
      ApiBaseHelper helper = ApiBaseHelper();
      var response = await helper.postAPIWithHeader(
        'v2/get_saved_parameter_details',
        _parameterDetailsRequest(index),
        context,
      );
      var responseJSON = json.decode(response.body);
      return Map<String, dynamic>.from(responseJSON);
    } catch (e) {
      debugPrint("Saved parameter fetch failed: $e");
      return null;
    } finally {
      if (showLoader && mounted) {
        Navigator.pop(context);
      }
    }
  }

  List<dynamic> _savedSubParametersFromResponse(Map<String, dynamic>? response) {
    if (response == null || response["status"] != true) {
      return [];
    }
    final data = response["data"];
    if (data is! Map) {
      return [];
    }
    final parameters = data["parameters"];
    if (parameters is! List || parameters.isEmpty) {
      return [];
    }
    final firstParameter = parameters.first;
    if (firstParameter is! Map) {
      return [];
    }
    final subParameters = firstParameter["sub_parameters"] ??
        firstParameter["subparameter"] ??
        firstParameter["qm_sheet_sub_parameter"];
    if (subParameters is List) {
      return subParameters;
    }
    return [];
  }

  String _readSavedString(Map item, List<String> keys) {
    for (final key in keys) {
      final value = item[key];
      if (value != null && value.toString().isNotEmpty) {
        return value.toString();
      }
    }
    return "";
  }

  void _populateSavedParameterValues(
      int index,
      Map<String, dynamic>? response,
      ) {
    final savedSubParameters = _savedSubParametersFromResponse(response);
    if (savedSubParameters.isEmpty || index < 0 || index >= questionList.length) {
      return;
    }

    final currentSubParameters = _subParametersForIndex(index);
    for (int j = 0; j < currentSubParameters.length; j++) {
      final subParameterId = currentSubParameters[j]["id"].toString();
      final savedIndex = savedSubParameters.indexWhere((item) {
        if (item is! Map) {
          return false;
        }
        final savedId = item["sub_parameter_id"] ??
            item["subparameter_id"] ??
            item["qm_sheet_sub_parameter_id"] ??
            item["id"];
        return savedId.toString() == subParameterId;
      });

      if (savedIndex == -1 || savedSubParameters[savedIndex] is! Map) {
        continue;
      }

      final savedItem = savedSubParameters[savedIndex] as Map;
      final selectedOption = _readSavedString(
        savedItem,
        ["option_selected", "option", "selected_text"],
      );
      final remark = _readSavedString(savedItem, ["remark", "remarks"]);
      final score = _readSavedString(
        savedItem,
        ["score", "selected_option", "selected_score"],
      );
      final errorCount = _readSavedString(savedItem, ["error_count"]);

      if (selectedOption.isNotEmpty) {
        dropdownSelectionList[index][j] = selectedOption;
      }
      controllerList[index][j].text = remark;
      if (score.isNotEmpty && index < weightList.length && j < weightList[index].length) {
        weightList[index][j] = score;
      }
      if (errorCount.isNotEmpty &&
          index < errorDropdownSelectionList.length &&
          j < errorDropdownSelectionList[index].length) {
        errorDropdownSelectionList[index][j] = errorCount;
      }
    }
  }

  Future<void> _selectParameterAt(int index) async {
    if (index < 0 || index >= questionList.length) {
      return;
    }
    setState(() {
      questionCurrentPosition = index;
    });
    final response = await _fetchSavedParameterDetails(index, showLoader: true);
    if (!mounted) {
      return;
    }
    _populateSavedParameterValues(index, response);
    setState(() {});
  }

  bool _savedItemHasArtifact(Map item) {
    final artifacts = item["artifacts"] ?? item["artifact"] ?? item["files"];
    if (artifacts is List) {
      return artifacts.isNotEmpty;
    }
    if (artifacts is String) {
      return artifacts.trim().isNotEmpty;
    }
    return false;
  }

  Future<bool> _validateUnsetArtifacts(
      int index) async {

    final subParameters =
    _subParametersForIndex(index);

    for (int j = 0;
    j < subParameters.length;
    j++) {

      if (dropdownSelectionList[index][j]
          ==
          unsetTitle) {

        final artifacts =
            subParameters[j]
            ["artifacts"] ??
                [];

        if (artifacts.isEmpty) {

          await _showArtifactRequiredDialog();

          return false;
        }
      }
    }

    return true;
  }
  /*Future<bool> _validateUnsetArtifacts(int index) async {
    final subParameters = _subParametersForIndex(index);
    final unsetSubParameterIds = <String>[];
    for (int j = 0; j < subParameters.length; j++) {
      if (dropdownSelectionList[index][j] == unsetTitle) {
        unsetSubParameterIds.add(subParameters[j]["id"].toString());
      }
    }
    if (unsetSubParameterIds.isEmpty) {
      return true;
    }

    final response = await _fetchSavedParameterDetails(index, showLoader: true);
    if (!mounted) {
      return false;
    }
    final savedSubParameters = _savedSubParametersFromResponse(response);

    for (final subParameterId in unsetSubParameterIds) {
      final savedIndex = savedSubParameters.indexWhere((item) {
        if (item is! Map) {
          return false;
        }
        final savedId = item["sub_parameter_id"] ??
            item["subparameter_id"] ??
            item["qm_sheet_sub_parameter_id"] ??
            item["id"];
        return savedId.toString() == subParameterId;
      });
      if (savedIndex == -1 ||
          savedSubParameters[savedIndex] is! Map ||
          !_savedItemHasArtifact(savedSubParameters[savedIndex] as Map)) {
        await _showArtifactRequiredDialog();
        return false;
      }
    }
    return true;
  }*/

  Future<void> _showArtifactRequiredDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFFF8A00)),
              SizedBox(width: 10),
              Expanded(child: Text("Artifact Required")),
            ],
          ),
          content: const Text(
            "Please upload an artifact for every No response before saving this parameter.",
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B5FEF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _addDuplicateParameter(int pos) {
    Map<String, dynamic> duplicateParam = jsonDecode(jsonEncode(questionList[pos]));
    String parameterId = duplicateParam["id"].toString();
    int currentIndex = parameterIndexMap[parameterId] ?? 1;
    currentIndex++;
    parameterIndexMap[parameterId] = currentIndex;
    duplicateParam["duplicate_index"] = currentIndex;
    questionList.insert(pos + 1, duplicateParam);

    final subParams = List<dynamic>.from(duplicateParam["qm_sheet_sub_parameter"] ?? []);
    final subParamLength = subParams.length;

    dropdownSelectionList.insert(
      pos + 1,
      List<dynamic>.generate(subParamLength, (index) => null),
    );
    controllerList.insert(
      pos + 1,
      List<TextEditingController>.generate(
        subParamLength,
            (index) => TextEditingController(),
      ),
    );
    weightList.insert(
      pos + 1,
      List<String>.generate(subParamLength, (index) => ""),
    );

    List<String?> innerSelection = [];
    List<List<dynamic>> innerErrorList = [];
    for (int j = 0; j < subParams.length; j++) {
      innerSelection.add(null);
      if (subParams[j]["error_scoring"] != null) {
        innerErrorList.add(jsonDecode(subParams[j]["error_scoring"]));
      } else {
        innerErrorList.add([]);
      }
    }
    errorDropdownSelectionList.insert(pos + 1, innerSelection);
    errorScoringList.insert(pos + 1, innerErrorList);

    setState(() {
      questionCurrentPosition = pos + 1;
    });

    Toast.show(
      "${questionList[pos]["parameter"]} added successfully. Please continue to proceed with the new entry.",
      duration: Toast.lengthLong,
      backgroundColor: Colors.green,
    );
  }

  Future<void> _confirmRemoveParameter(int index) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text("Remove Parameter"),
          content: const Text("Are you sure you want to remove this parameter?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                _deleteDuplicateParameter(index);
              },
              child: const Text(
                "Remove",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDuplicateParameter(int index) async {
    if (index < 0 || index >= questionList.length) {
      return;
    }
    APIDialog.showAlertDialog(context, "Removing parameter...");
    try {
      ApiBaseHelper helper = ApiBaseHelper();
      var response = await helper.postAPIWithHeader(
        'v2/delete_saved_parameter_details',
        _parameterDetailsRequest(index),
        context,
      );
      if (mounted) {
        Navigator.pop(context);
      }
      var responseJSON = json.decode(response.body);
      if (responseJSON["status"] == true) {
        dropdownSelectionList.removeAt(index);
        controllerList.removeAt(index);
        weightList.removeAt(index);
        errorDropdownSelectionList.removeAt(index);
        errorScoringList.removeAt(index);
        questionList.removeAt(index);
        if (questionCurrentPosition >= questionList.length) {
          questionCurrentPosition = questionList.length - 1;
        }
        if (questionCurrentPosition < 0) {
          questionCurrentPosition = 0;
        }
        setState(() {});
        Toast.show(responseJSON["message"]?.toString() ??
            "Saved parameter details deleted successfully",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.green);
      } else {
        dropdownSelectionList.removeAt(index);
        controllerList.removeAt(index);
        weightList.removeAt(index);
        errorDropdownSelectionList.removeAt(index);
        errorScoringList.removeAt(index);
        questionList.removeAt(index);
        if (questionCurrentPosition >= questionList.length) {
          questionCurrentPosition = questionList.length - 1;
        }
        if (questionCurrentPosition < 0) {
          questionCurrentPosition = 0;
        }
        setState(() {});
        Toast.show(responseJSON["message"]?.toString() ?? "Saved data not found on server",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
      }
      Toast.show("Unable to remove parameter",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  Widget _parameterTabs() {
    return Container(
      height: 58,
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: questionList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = index == questionCurrentPosition;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF5B5FEF) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF5B5FEF)
                    : const Color(0xFFE5E7EB),
              ),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: const Color(0xFF5B5FEF).withOpacity(0.22),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
                  : [],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => _selectParameterAt(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Center(
                  child: Text(
                    _parameterTitleFor(index),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : const Color(0xFF111827),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  /*Widget _questionWiseWidget() {

    int pos = questionCurrentPosition;
    String currentQuNo = "${pos + 1}";
    String totalQuestion = "${questionList.length}";
    String paramId = questionList[pos]["id"].toString();
    setState(() {
      current_showing="$currentQuNo/$totalQuestion";
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
            elevation: 3,
            //  color: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                        listTileTheme: ListTileTheme.of(context)
                            .copyWith(dense: true, minVerticalPadding: 10),
                        dividerColor: Colors.transparent),
                    child: ListTileTheme(
                        contentPadding: EdgeInsets.only(right: 5),
                        child: ExpansionTile(

                          initiallyExpanded: true,
                          collapsedBackgroundColor: Colors.white,
                          backgroundColor: Color(0xFFF6F6F6),
                          title: Container(
                            width: MediaQuery.of(context).size.width,
                            //height: 43,
                            alignment: Alignment.centerLeft,
                            //color: Colors.white,

                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                  "$currentQuNo/$totalQuestion "
                                      "${questionList[pos]["parameter"]} "
                                      "(${questionList[pos]["touch_point"] ?? ""})",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF21317D).withOpacity(0.7),
                                  )),
                            ),
                          ),
                          children: [
                            questionList[pos]["add_more"] == 1
                                ? Padding(
                              padding: const EdgeInsets.only(
                                right: 10,
                                top: 5,
                              ),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
                                    onPressed: () {

                                      /// DUPLICATE PARAM

                                      Map<String, dynamic> duplicateParam =
                                      jsonDecode(jsonEncode(questionList[pos]));
                                      String parameterId =
                                      duplicateParam["id"].toString();

                                      int currentIndex =
                                          parameterIndexMap[parameterId] ?? 1;

                                      currentIndex++;

                                      parameterIndexMap[parameterId] =
                                          currentIndex;

                                      /// SAVE DUPLICATE INDEX

                                      duplicateParam["duplicate_index"] =
                                          currentIndex;

                                      questionList.insert(pos + 1, duplicateParam);

                                      /// SUB PARAM COUNT

                                      int subParamLength =
                                          duplicateParam["qm_sheet_sub_parameter"].length;

                                      /// DROPDOWN LIST

                                      dropdownSelectionList.insert(
                                        pos + 1,
                                        List<dynamic>.generate(
                                          subParamLength,
                                              (index) => null,
                                        ),
                                      );

                                      /// CONTROLLER LIST

                                      controllerList.insert(
                                        pos + 1,
                                        List<TextEditingController>.generate(
                                          subParamLength,
                                              (index) => TextEditingController(),
                                        ),
                                      );

                                      /// WEIGHT LIST

                                      weightList.insert(
                                        pos + 1,
                                        List<String>.generate(
                                          subParamLength,
                                              (index) => "",
                                        ),
                                      );

                                      /// ERROR DROPDOWN SELECTION

                                      List<String?> innerSelection = [];

                                      /// ERROR SCORING LIST

                                      List<List<dynamic>> innerErrorList = [];

                                      List subParams =
                                      duplicateParam["qm_sheet_sub_parameter"];

                                      for (int j = 0; j < subParams.length; j++) {

                                        innerSelection.add(null);

                                        if (subParams[j]["error_scoring"] != null) {

                                          innerErrorList.add(
                                            jsonDecode(
                                              subParams[j]["error_scoring"],
                                            ),
                                          );

                                        } else {

                                          innerErrorList.add([]);
                                        }
                                      }

                                      errorDropdownSelectionList.insert(
                                        pos + 1,
                                        innerSelection,
                                      );

                                      errorScoringList.insert(
                                        pos + 1,
                                        innerErrorList,
                                      );

                                      setState(() {});
                                    },
                                  icon: Icon(Icons.add, size: 18),
                                  label: Text("Add"),
                                ),
                              ),
                            )
                                : SizedBox(),
                            SizedBox(height: 5),
                            ListView.builder(
                                itemCount: questionList[pos]["qm_sheet_sub_parameter"].length,
                                shrinkWrap: true,
                                padding:
                                EdgeInsets.symmetric(horizontal: 5),
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  String subParamId = questionList[pos]["qm_sheet_sub_parameter"][index]["id"].toString();
                                  int unsetRemarkPosition =
                                  findUnsatDependancies(paramId, subParamId);
                                  String previousRemark = "";
                                  String previousArtifact = "";
                                  List<previousRemarkQuestions>
                                  applicableIssueList = [];
                                  if (unsetRemarkPosition != -1) {
                                    previousRemark = prevRemarkList[unsetRemarkPosition].remark;
                                    previousArtifact = prevRemarkList[unsetRemarkPosition].artifact;
                                    applicableIssueList = prevRemarkList[unsetRemarkPosition].prevRemarkQuestList;
                                  }

                                  List<String> answerList = [];
                                  answerList.add(satisTitle);
                                  answerList.add(unsetTitle);
                                  int isNA = questionList[pos]["qm_sheet_sub_parameter"][index]["na"] ?? 0;
                                  int ispwd = questionList[pos]["qm_sheet_sub_parameter"][index]["pwd"] ?? 0;
                                  int isper = questionList[pos]["qm_sheet_sub_parameter"][index]["per"] ?? 0;
                                  int isCritical = questionList[pos]["qm_sheet_sub_parameter"][index]["critical"] ?? 0;
                                  if (isNA == 1) {
                                    answerList.add(naTitle);
                                  }
                                  if (ispwd == 1) {
                                    answerList.add(pwdTitle);
                                  }
                                  if (isper == 1) {
                                    answerList.add(percentageTitle);
                                  }
                                  if (isCritical == 1) {
                                    answerList.add(criticalTitle);
                                  }
                                  return Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Text(
                                            questionList[pos][
                                            "qm_sheet_sub_parameter"]
                                            [index]["sub_parameter"],
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              // width: 80,
                                              height: 40,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 4),
                                              padding:
                                              EdgeInsets.only(right: 5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      10),
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
                                                  hint: Text('Choose Type',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        color: Colors.black
                                                            .withOpacity(
                                                            0.7),
                                                      )),
                                                  items: answerList
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
                                                  value:
                                                  dropdownSelectionList[
                                                  pos][index],
                                                  onChanged: (value) {
                                                    dropdownSelectionList[
                                                    pos][index] =
                                                    value as String;
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      questionList[pos]["qm_sheet_sub_parameter"][index]
                                      ["use_error_count"] ==
                                          1 &&
                                          dropdownSelectionList[pos][index] == unsetTitle

                                          ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        child: Container(
                                          height: 45,
                                          margin: EdgeInsets.only(bottom: 10),
                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 0.5,
                                            ),
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              isExpanded: true,

                                              hint: Text(
                                                "Select Error Count",
                                              ),

                                              value:
                                              errorDropdownSelectionList[pos][index],
                                              items: errorScoringList[pos][index]
                                                  .map<DropdownMenuItem<String>>((e) {

                                                return DropdownMenuItem<String>(

                                                  value: e["error_count"].toString(),

                                                  child: Text(
                                                    "Error Count : ${e["error_count"]}"
                                                        " | Score : ${e["score"]}",
                                                  ),
                                                );
                                              }).toList(),

                                              onChanged: (value) {

                                                errorDropdownSelectionList[pos][index] =
                                                    value;

                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                      )
                                          : SizedBox(),
                                      Container(
                                        // height: 41,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: TextFormField(
                                            style: const TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF707070),
                                            ),
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      10.0),
                                                  borderSide:
                                                  const BorderSide(
                                                      color:
                                                      Colors.black,
                                                      width: 0.5),
                                                ),
                                                focusedBorder:
                                                OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        4.0),
                                                    borderSide:
                                                    BorderSide(
                                                        color:
                                                        Colors
                                                            .black,
                                                        width:
                                                        0.5)),
                                                errorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(4.0),
                                                    borderSide: BorderSide(
                                                        color: Colors.red,
                                                        width: 0.5)),
                                                border: InputBorder.none,
                                                contentPadding:
                                                EdgeInsets.fromLTRB(
                                                    7.0, 7.0, 5, 8),
                                                //prefixIcon: fieldIC,
                                                hintText:
                                                "Enter Remark here",
                                                hintStyle: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight:
                                                  FontWeight.w500,
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                )),
                                            controller: controllerList[pos]
                                            [index]),
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Spacer(),
                                          Card(
                                            elevation: 4,
                                            shadowColor: Colors.grey,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  6.0),
                                            ),
                                            child: Container(
                                              height: 46,
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                    foregroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(
                                                        Colors
                                                            .black),
                                                    // background
                                                    backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(Color(
                                                        0xFF93A6A2)),
                                                    // fore
                                                    shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              6.0),
                                                        ))),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => QaViewArtifactScreen(
                                                              widget
                                                                  .sheetID,
                                                              questionList[pos]
                                                              ["id"]
                                                                  .toString(),
                                                              questionList[pos]
                                                              [
                                                              "qm_sheet_sub_parameter"]
                                                              [
                                                              index]["id"]
                                                                  .toString(),
                                                              AuditIdReal,questionList[pos]["duplicate_index"].toString())));
                                                },
                                                child: const Text(
                                                  'Show Artifact',
                                                  style: TextStyle(
                                                    fontSize: 15.5,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                  textAlign:
                                                  TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Card(
                                            elevation: 4,
                                            shadowColor: Colors.grey,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  6.0),
                                            ),
                                            child: Container(
                                              height: 46,
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                    foregroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(
                                                        Colors
                                                            .white),
                                                    // background
                                                    backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(Color(
                                                        0xFF01075D)),
                                                    // fore
                                                    shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              6.0),
                                                        ))),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => QaUploadArtifactScreen(
                                                              widget
                                                                  .sheetID,
                                                              questionList[pos]
                                                              ["id"]
                                                                  .toString(),
                                                              questionList[pos]
                                                              [
                                                              "qm_sheet_sub_parameter"]
                                                              [
                                                              index]["id"]
                                                                  .toString(),
                                                              "1456",
                                                              AuditIdReal,questionList[pos]["duplicate_index"].toString())));
                                                },
                                                child: const Text(
                                                  'Artifact',
                                                  style: TextStyle(
                                                    fontSize: 15.5,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                  textAlign:
                                                  TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                        ],
                                      ),
                                      SizedBox(height: 22),
                                    ],
                                  );
                                })
                          ],
                        )),
                  ),
                ],
              ),
            )),
        SizedBox(height: 13),
        Center(
          child: questionCurrentPosition == questionList.length - 1
              ? Card(
            elevation: 3,
            shadowColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Container(
              height: 44,
              child: ElevatedButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white), // background
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color(0xFFFF5100)), // fore
                    shape:
                    MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ))),
                onPressed: () {
                  if (hasInternet) {
                    checkValidationsForQuestionWise(true);
                  }
                },
                child: const Text(
                  'SAVE & NEXT',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
              : Card(
            elevation: 3,
            shadowColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Container(
              height: 44,
              child: ElevatedButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white), // background
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color(0xFFFF5100)), // fore
                    shape:
                    MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ))),
                onPressed: () {
                  if (hasInternet) {
                    checkValidationsForQuestionWise(false);
                  }
                },
                child: const Text(
                  'SAVE & NEXT',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 13),
      ],
    );
  }*/

  Widget _questionWiseWidget() {

    int pos = questionCurrentPosition;

    String currentQuNo = "${pos + 1}";
    String paramId = questionList[pos]["id"].toString();

    current_showing = currentQuNo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        _parameterTabs(),

        /// PROGRESS CARD
        /*Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 6,
          ),

          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: Column(
            children: [

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    "Audit Progress",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const Icon(
                    Icons.trending_up_rounded,
                    color: Color(0xFF5B5FEF),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              ClipRRect(
                borderRadius:
                BorderRadius.circular(20),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: 0,
                    end: (pos + 1) / questionList.length,
                  ),
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value,
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF5B5FEF),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),*/

        /// QUESTION CARD
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
            BorderRadius.circular(26),

            boxShadow: [
              BoxShadow(
                color:
                Colors.black.withOpacity(0.04),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),

            child: ExpansionTile(

              initiallyExpanded: true,

              tilePadding:
              const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),

              childrenPadding:
              const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 16,
              ),

              collapsedShape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(26),
              ),

              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(26),
              ),

              title: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

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
                      BorderRadius.circular(
                          30),
                    ),

                    child: Text(
                      "Parameter",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight:
                        FontWeight.w700,
                        color:
                        Color(0xFF5B5FEF),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    _parameterTitleFor(pos),

                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.w700,
                      color: Color(0xFF1B1D28),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "${questionList[pos]["touch_point"] ?? ""}",

                    style: TextStyle(
                      fontSize: 13,
                      color:
                      Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),

              children: [

                /// ADD MORE BUTTON
                questionList[pos]["add_more"] == 1

                    ? Align(
                  alignment:
                  Alignment.centerRight,

                  child: Container(
                    margin:
                    const EdgeInsets.only(
                      bottom: 18,
                    ),

                    decoration:
                    BoxDecoration(

                      gradient:
                      const LinearGradient(
                        colors: [
                          Color(0xFFFF8A00),
                          Color(0xFFFF5E00),
                        ],
                      ),

                      borderRadius:
                      BorderRadius.circular(
                          30),
                    ),

                    child:
                    ElevatedButton.icon(

                      style:
                      ElevatedButton
                          .styleFrom(
                        backgroundColor:
                        Colors
                            .transparent,

                        shadowColor:
                        Colors
                            .transparent,

                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                              30),
                        ),
                      ),

                      onPressed: () {
                        _addDuplicateParameter(pos);
                      },

                      icon: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                      ),

                      label: const Text(
                        "Add More",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                )

                    : const SizedBox(),

                (int.tryParse(_parameterIndexFor(pos)) ?? 1) > 1
                    ? Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () => _confirmRemoveParameter(pos),
                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                      label: const Text(
                        "Remove",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                )
                    : const SizedBox(),

                /// SUB PARAM LIST

                ListView.builder(

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
                                                selectedBrand
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

                                                "1456",

                                                AuditIdReal,

                                                questionList[
                                                pos]
                                                ["duplicate_index"]
                                                    .toString(),
                                                selectedBrand
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
                ),
              ],
            ),
          ),
        ),

        /// NAVIGATION BUTTONS
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),

          child: Row(
            children: [
              if (questionCurrentPosition > 0) ...[
                Expanded(
                  child: SizedBox(
                    height: 58,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF111827),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => _selectParameterAt(questionCurrentPosition - 1),
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text(
                        "Previous",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                flex: questionCurrentPosition > 0 ? 1 : 2,
                child: SizedBox(
                  height: 58,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B5FEF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      if (hasInternet) {
                        checkValidationsForQuestionWise(
                          questionCurrentPosition == questionList.length - 1,
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          questionCurrentPosition == questionList.length - 1
                              ? "Submit"
                              : "Save & Next",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
      ],
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
  checkValidationsForQuestionWise(bool isLast) async {
    bool flag = true;
    if (widget.isEdit) {
      int i = questionCurrentPosition;
      //subparameter
      outerLoop:
      for (int j = 0; j < questionList[i]["subparameter"].length; j++) {
        if (dropdownSelectionList[i][j] == null) {
          Toast.show(
              "Please choose option for Question " +
                  (j + 1).toString() +
                  " in " +
                  questionList[i]["parameter"],
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.red);
          flag = false;
          break outerLoop;
        } else if (controllerList[i][j].text == "" &&
            (dropdownSelectionList[i][j] == unsetTitle ||
                dropdownSelectionList[i][j] == criticalTitle)) {
          Toast.show(
              "Please enter remark for Question " +
                  (j + 1).toString() +
                  " in " +
                  questionList[i]["parameter"],
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.red);
          flag = false;
          break outerLoop;
        }
      }
    } else {
      int i = questionCurrentPosition;
      outerLoop:
      for (int j = 0; j < questionList[i]["qm_sheet_sub_parameter"].length; j++) {
        if (dropdownSelectionList[i][j] == null) {
          Toast.show(
              "Please choose option for Question " +
                  (j + 1).toString() +
                  " in " +
                  questionList[i]["parameter"],
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.red);
          flag = false;
          break outerLoop;
        } else if (controllerList[i][j].text == "" &&
            (dropdownSelectionList[i][j] == unsetTitle ||
                dropdownSelectionList[i][j] == criticalTitle)) {
          Toast.show(
              "Please enter remark for Question " +
                  (j + 1).toString() +
                  " in " +
                  questionList[i]["parameter"],
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.red);
          flag = false;
          break outerLoop;
        }else if (dropdownSelectionList[i][j]==unsetTitle  && questionList[i]["qm_sheet_sub_parameter"][j]["use_error_count"] == 1 && errorDropdownSelectionList[i][j] == null){
          Toast.show(
              "Please Select Error Count for Question " +
                  (j + 1).toString() +
                  " in " +
                  questionList[i]["parameter"],
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.red);
          flag = false;
          break outerLoop;
        }
      }
    }

    if (flag) {
      final artifactValid = await _validateUnsetArtifacts(questionCurrentPosition);
      if (!artifactValid) {
        return;
      }
      prepareDataForSave(isLast);
    }
  }
  prepareDataForSave(bool isLast) async {
    APIDialog.showAlertDialog(context, "Please wait.Saving ...");
    List<dynamic> parameterList = [];
    if (widget.isEdit) {
      int i = questionCurrentPosition;
      for (int j = 0; j < questionList[i]["subparameter"].length; j++) {

        String weight=questionList[i]["subparameter"][j]['weight']?.toString()??"";
        String scoreMain="";
        String scorableMain="";




        if(dropdownSelectionList[i][j]==naTitle){
          scoreMain="0";
          scorableMain="0";
        }else if(dropdownSelectionList[i][j]==satisTitle){
          scoreMain=weight;
          scorableMain=weight;
        }else if(dropdownSelectionList[i][j]==unsetTitle && questionList[i]["subparameter"][j]["use_error_count"] == 0){
          scoreMain="0";
          scorableMain=weight;
        }else if(dropdownSelectionList[i][j]==unsetTitle && questionList[i]["subparameter"][j]["use_error_count"] == 1){
          if(errorDropdownSelectionList[i][j] != null){
            String erCount = errorDropdownSelectionList[i][j].toString();
            String slErScore="";
            List<dynamic> errorList = errorScoringList[i][j];
            int selectedIndex = errorList.indexWhere((e) => e["error_count"].toString() == erCount,);
            if (selectedIndex != -1) {
              slErScore = errorList[selectedIndex]["score"].toString();
              /// OVERRIDE SCORE
              /* score = selectedErrorScore;
              selectOption = selectedErrorScore;*/
            }
            scoreMain=slErScore;
            scorableMain=weight;
          }else{
            scoreMain="0";
            scorableMain=weight;
          }

        }else{
          scoreMain=weight;
          scorableMain=weight;
        }


        String score="";
        String slectOption="";
        if(dropdownSelectionList[i][j]==naTitle){
          score= naTitle;
          slectOption= naTitle;
        }else{
          score= weightList[i][j];
          slectOption=weightList[i][j];
        }
        String selectedErrorCount = "";
        String selectedErrorScore = "";

        if (questionList[i]["qm_sheet_sub_parameter"][j]
        ["use_error_count"] ==
            1 &&
            errorDropdownSelectionList[i][j] != null) {

          selectedErrorCount =
              errorDropdownSelectionList[i][j].toString();

          List<dynamic> errorList =
          errorScoringList[i][j];

          int selectedIndex = errorList.indexWhere(
                (e) =>
            e["error_count"].toString() ==
                selectedErrorCount,
          );

          if (selectedIndex != -1) {

            selectedErrorScore =
                errorList[selectedIndex]["score"]
                    .toString();

            /// OVERRIDE SCORE

            /* score = selectedErrorScore;
            selectOption = selectedErrorScore;*/
          }
        }

        parameterList.add({
          "parameter_id": questionList[i]["id"].toString(),
          "parameter_index":
          questionList[i]["duplicate_index"].toString(),
          "sub_parameter_id":
          questionList[i]["subparameter"][j]["id"].toString(),
          "option_selected": dropdownSelectionList[i][j],
          "selected_option": scoreMain,
          "score": scoreMain,
          "scorable":scorableMain,
          "remark": controllerList[i][j].text,
          "is_critical": "0",
          "is_percentage": "0",
          "selected_per": "",
          "is_alert": "",
          "error_count":
          selectedErrorCount,
          "error_score":
          selectedErrorScore,
          "location":selectedLocation,
          "campus_type":selectedCampus,
          "brand":selectedBrand,
          "pillar":selectedPillar,
          "touch_point":questionList[i]['touch_point'],
          "compliance_experience":questionList[i]["subparameter"][j]['compliance_experience'],
        });
      }
    } else {
      int i = questionCurrentPosition;
      List<dynamic> subParams = [];
      for (int j = 0;
      j < questionList[i]["qm_sheet_sub_parameter"].length;
      j++) {

        String weight=questionList[i]["qm_sheet_sub_parameter"][j]['weight']?.toString()??"";
        String scoreMain="";
        String scorableMain="";




        String score="";
        String slectOption="";
        if(dropdownSelectionList[i][j]==naTitle){
          scoreMain="0";
          scorableMain="0";
        }else if(dropdownSelectionList[i][j]==satisTitle){
          scoreMain=weight;
          scorableMain=weight;
        }else if(dropdownSelectionList[i][j]==unsetTitle && questionList[i]["qm_sheet_sub_parameter"][j]["use_error_count"] == 0){
          scoreMain="0";
          scorableMain=weight;
        }else if(dropdownSelectionList[i][j]==unsetTitle && questionList[i]["qm_sheet_sub_parameter"][j]["use_error_count"] == 1){
          if(errorDropdownSelectionList[i][j] != null){
            String erCount = errorDropdownSelectionList[i][j].toString();
            String slErScore="";
            List<dynamic> errorList = errorScoringList[i][j];
            int selectedIndex = errorList.indexWhere((e) => e["error_count"].toString() == erCount,);
            if (selectedIndex != -1) {
              slErScore = errorList[selectedIndex]["score"].toString();
              /// OVERRIDE SCORE
              /* score = selectedErrorScore;
              selectOption = selectedErrorScore;*/
            }
            scoreMain=slErScore;
            scorableMain=weight;
          }else{
            scoreMain="0";
            scorableMain=weight;
          }

        }else{
          scoreMain="0";
          scorableMain=weight;
        }
        String selectedErrorCount = "";
        String selectedErrorScore = "";
        if (questionList[i]["qm_sheet_sub_parameter"][j]["use_error_count"] == 1 &&
            errorDropdownSelectionList[i][j] != null) {
          selectedErrorCount = errorDropdownSelectionList[i][j].toString();
          List<dynamic> errorList = errorScoringList[i][j];
          int selectedIndex = errorList.indexWhere((e) => e["error_count"].toString() == selectedErrorCount,);
          if (selectedIndex != -1) {
            selectedErrorScore = errorList[selectedIndex]["score"].toString();
            /// OVERRIDE SCORE
            /* score = selectedErrorScore;
              selectOption = selectedErrorScore;*/
          }
        }

        parameterList.add({
          "parameter_id": questionList[i]["id"].toString(),
          "parameter_index": questionList[i]["duplicate_index"].toString(),
          "sub_parameter_id": questionList[i]["qm_sheet_sub_parameter"][j]["id"].toString(),
          "option_selected": dropdownSelectionList[i][j],
          /* "selected_option": weightList[i][j],
          "score": weightList[i][j],*/
          "selected_option": scoreMain,
          "score": scoreMain,
          "scorable":scorableMain,
          "remark": controllerList[i][j].text,
          "is_critical": "0",
          "is_percentage": "0",
          "selected_per": "",
          "is_alert": "",
          "error_count": selectedErrorCount,
          "error_score": selectedErrorScore,
          "location":selectedLocation,
          "campus_type":selectedCampus,
          "brand":selectedBrand,
          "pillar":selectedPillar,
          "touch_point":questionList[i]['touch_point'],
          "compliance_experience":questionList[i]["qm_sheet_sub_parameter"][j]['compliance_experience'],
        });
      }
    }
    List<Map<String, dynamic>> checkListData = [];
    if (widget.isEdit) {
      int i = questionCurrentPosition;
      Map<String, dynamic> parameterListChild = Map();
      parameterListChild.addAll({
        (questionList[i]["id"]).toString(): {
          "subs": {
            for (int r = 0; r < questionList[i]["subparameter"].length; r++)
              (questionList[i]["subparameter"][r]["id"]).toString(): {
                "option": dropdownSelectionList[i][r],
                "remark": controllerList[i][r].text
              }
          }
        },
      });
      checkListData.add(parameterListChild);
    } else {
      int i = questionCurrentPosition;
      Map<String, dynamic> parameterListChild = Map();
      parameterListChild.addAll({
        (questionList[i]["id"]).toString(): {
          "subs": {
            for (int r = 0;
            r < questionList[i]["qm_sheet_sub_parameter"].length;
            r++)
              (questionList[i]["qm_sheet_sub_parameter"][r]["id"]).toString(): {
                "option": dropdownSelectionList[i][r],
                "remark": controllerList[i][r].text
              }
          }
        },
      });

      checkListData.add(parameterListChild);
    }

    var requestModel = {
      "audit_id": AuditIdReal,
      'qm_sheet_id':widget.sheetID,
      "parameters": parameterList,
      /* "parameters": parameterList,
      "checksheet_data": checkListData,*/
    };
    log(requestModel.toString());




    print("Request Model $requestModel");
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(
        'v2/save-audit-result-v2', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['status']) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      if (isLast) {
        showSubmitConfirmationDialog();
      } else {
        questionSaveNext();
      }
    }
    else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  void questionSaveNext() {
    _selectParameterAt(questionCurrentPosition + 1);
  }
  void showSubmitConfirmationDialog() {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {

        return AlertDialog(

          title: Text("Submit Audit"),

          content: Text(
            "Do you want to add more data "
                "or submit audit?",
          ),

          actions: [

            TextButton(

              onPressed: () {
                Navigator.pop(context);
                resetBasicLayoutForAddMore();
              },

              child: Text("Add More"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                getResultFromServer();

              },

              child: Text("Submit Audit"),
            ),
          ],
        );
      },
    );
  }
  void resetBasicLayoutForAddMore() {

    /// RESET BASIC FILTERS

    selectedLocation = "";

    selectedCampus = "";

    selectedBrand = "";

    selectedPillar = "";

    /// SHOW BASIC SCREEN AGAIN

    showHomePgeLayout = false;

    showBasicLayout = true;

    showResultLayout = false;

    /// RESET QUESTION POSITION

    questionCurrentPosition = 0;

    setState(() {});
  }
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
    print(responseJSON);
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
    showBasicLayout=false;
    showHomePgeLayout=false;
    showResultLayout = true;
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

            var item =
            parameterWiseResultList[index];

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
                                  "#${item["parameter_index"]}",

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
                              item["pillar"],

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

                          item["pillar"],

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
                          "Score",

                          value:
                          item["total_score"]
                              .toString(),
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
                      ),

                      Expanded(
                        child:
                        _pillarInfoItem(
                          title:
                          "Weight",

                          value:
                          "${item["pillar_weight"]}%",
                        ),
                      ),
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
                showResultLayout = false;
                showHomePgeLayout = false;
                showBasicLayout = false;
                setState(() {});
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
/*uploadImage(String methodType, String auditID) async {
    List<dynamic> imageList = AppModel.rebuttalData;
    totalFiles = imageList.length;
    APIDialog.showAlertDialog(context, 'Uploading images...');
    for (int i = 0; i < imageList.length; i++) {
      FormData formData = FormData.fromMap({
        "sheet_id": widget.sheetID,
        "parameter_id": imageList[i]["parameter_id"],
        "sub_parameter_id": imageList[i]["sub_parameter_id"],
        "audit_id": auditID,
        "status": "1",
        "totalFile": await MultipartFile.fromFile(imageList[i]["imagePath"],
            filename: imageList[i]["imagePath"].split('/').last),
      });
      print(formData.fields);
      Dio dio = Dio();
      dio.options.headers['Content-Type'] = 'multipart/form-data';
      dio.options.headers['Authorizations'] = AppModel.token;
      print(AppConstant.appBaseURL + "v2/storeArtifact");
      var response = await dio.post(AppConstant.appBaseURL + "storeArtifact",
          data: formData);
      //  log(response.data.toString());
      //var responseJSON = jsonDecode(response.data.toString());

      if (response.data['status'] == 1) {
        uploadedFiles = uploadedFiles + 1;
        if (i == imageList.length - 1) {
          Navigator.pop(context);
          Toast.show("Images Uploaded successfully!",
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.green);
          Navigator.pop(context);
        }
      } else if (response.data['message'].toString() == "User not found") {
        _logOut(context);
      } else {
        *//*Toast.show(response.data['message'].toString(),
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);*//*
      }
    }
  }*/



}
class previousRemark {
  String paramId;
  String subParamId;
  String observation;
  String remark;
  String artifact;
  List<previousRemarkQuestions> prevRemarkQuestList;

  previousRemark(this.paramId, this.subParamId, this.observation, this.remark,
      this.artifact, this.prevRemarkQuestList);
}
class previousRemarkQuestions {
  String remarkQuestId;
  String remarkQuestText;
  bool isSelected;

  previousRemarkQuestions(
      this.remarkQuestId, this.remarkQuestText, this.isSelected);
}
class selectedPreviousOptions{
  String paramId;
  String subParamId;
  String selectedIssuesId;
  String selectedAdditionalRemark;
  selectedPreviousOptions(this.paramId, this.subParamId, this.selectedIssuesId,
      this.selectedAdditionalRemark);
}
class resultSeries{
  String paramName;
  String scorable;
  String score;
  String percentage;

  resultSeries(this.paramName, this.scorable, this.score, this.percentage);
}
