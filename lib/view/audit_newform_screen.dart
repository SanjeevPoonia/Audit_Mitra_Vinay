import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qaudit_tata_flutter/view/upload_artifact_screen.dart';
import 'package:qaudit_tata_flutter/view/view_artifact_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../network/constants.dart';
import '../network/loader.dart';
import '../utils/app_modal.dart';
import '../utils/app_theme.dart';
import '../widgets/dropdown_widget.dart';
import '../widgets/textfield_widget.dart';
import 'package:dio/dio.dart';

import 'login_screen.dart';

class AuditNewFormScreen extends StatefulWidget {
  final String sheetID;
  final String sheetName;
  Map<String, dynamic> lobData;
  bool isEdit;
  String auditID;
  String auditAgencyID;

  AuditNewFormScreen(this.sheetID, this.lobData, this.sheetName, this.isEdit,
      this.auditID, this.auditAgencyID);

  _auditFormState createState() => _auditFormState();
}

class _auditFormState extends State<AuditNewFormScreen> {
  bool isLoading = false;
  String finalGrade = '';
  int totalFiles = 0;
  int uploadedFiles = 0;
  int levelWiseCount = 1;
  bool collectionManagerSelected = false;
  final _formKeyGuestOTP = GlobalKey<FormState>();
  Timer? _timer2;
  int _start = 30;
  int _start2 = 30;
  List<String> level4IDs = [];
  List<String> level5IDs = [];
  Map<String, dynamic> auditDetails = {};
  Map<String, dynamic> parameterDetails = {};
  Position? _currentPosition;
  bool hasInternet = true;
  String auditAgencyID = "";
  List<bool> selectedManagers = [];
  String currentAgencyID = "";

  List<int> scorableList = [];
  List<int> scoredList = [];

  String userEnteredOTP = '';
  String userEnteredOTP2 = '';
  List<String?> selectedLevel4Drop = [];
  List<String?> selectedLevel5Drop = [];
  var presentAuditorController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();
  List<double> scoreInPercentage = [];

  List<String> phoneListAsString = [];
  List<String> emailListAsString = [];
  String? selectedPhone;
  String? selectedEmail;
  var agencySearchController = TextEditingController();

  List<dynamic> selectedSubProducts = [];
  List<dynamic> subProductList = [];
  List<dynamic> level4UserList = [];
  List<dynamic> selectedLevel4UserList = [];
  List<String> selectedLevel4AsString = [];
  List<String> level4ListAsString = [];
  List<String> level5ListAsString = [];

  List<dynamic> selectedLevel5Users = [];
  List<dynamic> level5Users = [];

  List<String> levelByUserList = [];
  List<String> levelByUserListKeys = [];

  List<String> level5UserList = [];
  List<String> level5UserListKeys = [];

  List<String> selectedLevel5Names = [];

  String? selectedlevel1;
  String? selectedlevel2;
  String? selectedlevel3;
  List<dynamic> selectedManagersList = [];
  String totalScore = "0";
  var dropdownSelectionList = [[]];
  List<String?> selectedDropCollectionManager = [];
  var weightList = [[]];
  var controllerList = [[]];
  List<String> managerListAsString = [];
  List<dynamic> areaManagerList = [];
  List<String> areaManagerListAsString = [];
  List<dynamic> answerListFinal = [];
  String? selectedDate;
  var agencyNameController = TextEditingController();
  var agencyManagerNameController = TextEditingController();
  var agencyPhoneController = TextEditingController();
  var agencyAddressController = TextEditingController();
  var branchNameController = TextEditingController();
  var cityNameController = TextEditingController();
  var locationNameController = TextEditingController();
  var latLongController = TextEditingController();
  var managerEmpCodeController = TextEditingController();
  var regionalManagerController = TextEditingController();
  var zonalManagerController = TextEditingController();
  var nationalManagerController = TextEditingController();
  List<dynamic> cityList = [];

  List<dynamic> filteredCityList = [];
  List<dynamic> questionList = [];

  List<dynamic> managerList = [];
  List<dynamic> filterManagerList = [];
  List<String> auditCycleListAsString = [];

  List<dynamic> auditCycleList = [];

  List<dynamic> agencyList = [];
  List<dynamic> filteredAgencyList = [];

  List<dynamic> productList = [];
  List<String> productListAsString = [];

  String satisTitle = "Satisfactory";
  String unsetTitle = "Unsatisfactory";
  String naTitle = "N/A";
  String criticalTitle = "Critical";
  String pwdTitle = "PWD";
  String percentageTitle = "Percentage";

  List<String> lobListAsString = [];

  List<dynamic> lobList = [];

  String? selectedLOB;
  String? selectedAnswer;
  String? selectedProduct;
  String? selectedProductID;
  String? selectedAuditCycle;
  List<String> selectedSubProductAsString = [];
  List<String> selectedSubProductIDsAsString = [];

  int selectedCityIndex = 9999;
  int selectedAgencyIndex = 9999;
  int selectedManagerIndex = 9999;
  StateSetter? setStateGlobal;
  StateSetter? setStateGlobalManagerDialog;

  int questionCurrentPosition = 0;
  bool showBasicLayout = true;
  bool showResultLayout = false;

  bool isLevelsRequired = true;

  String AuditIdReal = "";
  String selectedAgencyId = "";

  List<previousRemark> prevRemarkList = [];

  int allocatedModuleOTP = 1;
  bool isOTPRequired = false;

  int allocatedModuleLevels = 13;
  bool isLevelShow = false;

  Timer? _timer;

  List<String> otpQuestionIds = [];

  List<selectedPreviousOptions> previousIssueSelectedList=[];

  List<resultSeries> resultList=[];
  String finalScorable="";
  String finalScore="";
  String finalPercentage="";
  String finalGradeToShow="";


  String current_showing="";



  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
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
                    Text("Audit Form",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        )),
                   /* Text(current_showing,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.newThemeColor,
                        )),*/
                    Container()
                  ],
                ),
              ),
            ),
            Expanded(
                child: isLoading
                    ? Center(
                        child: Loader(),
                      )
                    : ListView(
                        physics: BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(top: 8),
                        children: [
                          !hasInternet
                              ? Container()
                              : showBasicLayout
                                  ? _basicDetailWidget()
                                  : showResultLayout
                                      ? _showResultWidget()
                                      : Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(8),
                                                  bottomRight:
                                                      Radius.circular(8)),
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 0.7)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 43,
                                                color: AppTheme.themeColor,
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 10),
                                                    Text("Audit",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 15),
                                              _questionWiseWidget()
                                            ],
                                          ),
                                        ),
                        ],
                      ))
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
        viewAuditData(context);
        fetchAllocatedModule();
      } else {
        AuditIdReal = "";
        fetchCities();
        fetchAgencies();
        fetchAuditCycleList();
        fetchUserList();
        fetchAllocatedModule();
      }
    }
  }

  viewAuditData(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    var data = {"audit_id": widget.auditID};
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPIWithHeader('audit_sheet_edit', data, context);
    var responseJSON = json.decode(response.body);

    print(responseJSON.toString());

    auditDetails = responseJSON["data"]["audit_details"];
    parameterDetails = responseJSON["data"]["sheet_details"];
    questionList = responseJSON["data"]["sheet_details"]["parameter"];
    if (auditDetails.toString().contains("present_auditor") &&
        auditDetails["present_auditor"] != null) {
      presentAuditorController.text = auditDetails["present_auditor"];
    }
    if (auditDetails["audit_agency_id"] != null) {
      auditAgencyID = auditDetails["audit_agency_id"].toString();
    } else {
      auditAgencyID = "";
    }

    int totalScorer = 0;
    int totalScored = 0;
    int row = questionList.length;
    int col = 20;
    dropdownSelectionList = List<List>.generate(
        row, (i) => List<dynamic>.generate(col, (index) => null));
    weightList = List<List>.generate(
        row, (i) => List<String>.generate(col, (index) => ""));
    controllerList = List<List>.generate(
        row,
        (i) => List<TextEditingController>.generate(
            col, (index) => TextEditingController()));

    for (int i = 0; i < questionList.length; i++) {
      print("LOOP COUNT" + i.toString());

      for (int j = 0; j < questionList[i]["subparameter"].length; j++) {

        if(questionList[i]["subparameter"][j]["weight"]!=null && questionList[i]["subparameter"][j]["weight"].toString().isNotEmpty){
          totalScorer = totalScorer + int.parse(questionList[i]["subparameter"][j]["weight"].toString());
        }
        print("Total Scoredd " + totalScored.toString());
        if(questionList[i]["subparameter"][j]["score"]!=null && questionList[i]["subparameter"][j]["score"].toString().isNotEmpty){
          totalScored = totalScored + int.parse(questionList[i]["subparameter"][j]["score"].toString());
        }




        if (questionList[i]["subparameter"][j]["remark"] != null) {
          controllerList[i][j].text = questionList[i]["subparameter"][j]["remark"].toString();
        } else {
          controllerList[i][j].text = "NA";
        }

        print("selected Drop Down Value : ${questionList[i]["subparameter"][j]["option_selected"]}");
        if(questionList[i]["subparameter"][j]["option_selected"].toString().isNotEmpty){
          dropdownSelectionList[i][j] = questionList[i]["subparameter"][j]["option_selected"];
        }
        print("selected Drop Down Weigth : ${questionList[i]["subparameter"][j]["score"]}");
        if(questionList[i]["subparameter"][j]["score"].toString().isNotEmpty){
          weightList[i][j] = questionList[i]["subparameter"][j]["score"].toString();
        }


      }

      scorableList.add(totalScorer);
      scoredList.add(totalScored);
      scoreInPercentage.add((totalScored * 100) / totalScorer);
      totalScorer = 0;
      totalScored = 0;
      if (scorableList.length == 0) {
        finalGrade = "";
      } else if (scorableList.reduce((a, b) => a + b) == 0) {
        finalGrade = "";
      } else {
        double finalCal = scoredList.reduce((a, b) => a + b) *
            100 /
            scorableList.reduce((a, b) => a + b);
        if (finalCal >= 90) {
          finalGrade = "A";
        } else if (finalCal >= 75) {
          finalGrade = "B";
        } else if (finalCal >= 61) {
          finalGrade = "C";
        } else {
          finalGrade = "D";
        }
      }

      setState(() {
        isLoading = false;
      });
    }

    fetchAgenciesEdit(auditDetails["agency_id"].toString());
    // fetchProductsEdit(auditDetails["agency_id"].toString(),auditDetails["product_id"].toString());
    fetchAuditCycleListEdit(auditDetails["audit_cycle_id"].toString());

    selectedDate = auditDetails["audit_date_by_aud"].toString();
    latLongController.text = auditDetails["latitude"].toString() +
        " , " +
        auditDetails["longitude"].toString();

    String? level3ID = auditDetails["lavel_3"].toString();
    String? level4ID = auditDetails["lavel_4"].toString();
    String? level5ID = auditDetails["lavel_5"].toString();

    fetchUserListEdit(level3ID, level4ID, level5ID);

    setState(() {});
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
      weightList = List<List>.generate(
          row, (i) => List<String>.generate(col, (index) => ""));
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

  Widget _basicDetailWidget() {
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
          widget.isEdit
              ? TextFieldWidgetNew(
                  "Present Auditor*",
                  enabled: false,
                  "-",
                  presentAuditorController)
              : TextFieldWidgetNew(
                  "Present Auditor*", "Enter here", presentAuditorController),
          selectedProduct == null /*&& !widget.isEdit*/
              ? Container()
              : Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text("Product*",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.7),
                            )),
                      ),
                      SizedBox(height: 2),
                      Container(
                        // width: 80,
                        height: 40,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(color: Colors.black, width: 0.5)),
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
                            hint: Text('Select Product',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black.withOpacity(0.7),
                                )),
                            items: productListAsString
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ))
                                .toList(),
                            value: selectedProduct,
                            onChanged: null,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      selectedSubProductAsString.length == 0
                          ? Container()
                          : DropDownWidget2(
                              () {},
                              "Sub Products",
                              selectedSubProductAsString.length == 0
                                  ? "Select Sub Products"
                                  : selectedSubProductAsString
                                      .toString()
                                      .substring(
                                          1,
                                          selectedSubProductAsString
                                                  .toString()
                                                  .length -
                                              1),
                              selectedSubProductAsString.length == 0
                                  ? Colors.black.withOpacity(0.7)
                                  : Colors.black),
                      selectedSubProductAsString.length == 0
                          ? Container()
                          : SizedBox(height: 12),
                      TextFieldWidgetNew(
                          "Agency Name", "", agencyNameController,
                          enabled: false),
                      SizedBox(height: 12),
                      widget.isEdit
                          ? TextFieldWidgetNew(
                              "Agency Manager",
                              enabled: false,
                              "-",
                              agencyManagerNameController)
                          : TextFieldWidgetNew("Agency Manager",
                              "Enter Manager", agencyManagerNameController),
                      SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text("Agency Mobile Number",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.7),
                            )),
                      ),
                      SizedBox(height: 2),
                      Container(
                        // width: 80,
                        height: 40,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(color: Colors.black, width: 0.5)),
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
                            hint: Text('Select Agency Mobile No.',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black.withOpacity(0.7),
                                )),
                            items: phoneListAsString
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
                            value: selectedPhone,
                            onChanged: (value) {
                              setState(() {
                                selectedPhone = value as String;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text("Agency Email",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.7),
                            )),
                      ),
                      SizedBox(height: 2),
                      Container(
                        // width: 80,
                        height: 40,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(color: Colors.black, width: 0.5)),
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
                            hint: Text('Select Agency Email',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black.withOpacity(0.7),
                                )),
                            items: emailListAsString
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
                            value: selectedEmail,
                            onChanged: (value) {
                              setState(() {
                                selectedEmail = value as String;
                              });
                            },
                          ),
                        ),
                      ),
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
                      isLevelShow
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Text("Level 3*",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black.withOpacity(0.7),
                                      )),
                                ),
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: CustomDropdown<String>.search(
                                        hintText: 'Select Level 3',
                                        items: levelByUserList,
                                        decoration: CustomDropdownDecoration(
                                          closedBorder: Border.all(
                                              color: Colors.black, width: 0.7),
                                          closedBorderRadius:
                                              BorderRadius.circular(5),
                                          closedSuffixIcon: Icon(
                                              Icons
                                                  .keyboard_arrow_down_outlined,
                                              color: Colors.black),
                                          expandedSuffixIcon: Icon(
                                              Icons.keyboard_arrow_up_outlined,
                                              color: Colors.black),
                                        ),
                                        initialItem: selectedlevel1,
                                        overlayHeight: 342,
                                        onChanged: (value) {
                                          log('SearchDropdown onChanged value: $value');
                                          setState(() {
                                            selectedlevel1 = value;
                                          });
                                        },
                                      ),
                                    ))
                                  ],
                                ),
                                SizedBox(height: 16),
                                selectedLevel4Drop.length == 0
                                    ? Container()
                                    : widget.isEdit
                                        ? Container()
                                        : Row(
                                            children: [
                                              Spacer(),
                                              GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedLevel4Drop
                                                          .add(null);
                                                      selectedLevel5Drop
                                                          .add(null);
                                                      /*selectedLevel4Drop.add(
                                                level4ListAsString[
                                                0]);
                                            selectedLevel5Drop.add(
                                                level5ListAsString[
                                                0]);*/
                                                      levelWiseCount =
                                                          levelWiseCount + 1;
                                                    });
                                                  },
                                                  child: Image.asset(
                                                    "assets/plus.png",
                                                    width: 25,
                                                    height: 25,
                                                  )),
                                              SizedBox(width: 10)
                                            ],
                                          ),
                                selectedLevel4Drop.length == 0
                                    ? Container()
                                    : ListView.builder(
                                        itemCount: levelWiseCount,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int pos) {
                                          int level4Count = 4 + pos * 2;
                                          int level5Count = 5 + pos * 2;

                                          String level4Title =
                                              "Level $level4Count *";
                                          String level5Title =
                                              "Level $level5Count *";

                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              pos == 0
                                                  ? Container()
                                                  : widget.isEdit
                                                      ? Container()
                                                      : const SizedBox(
                                                          height: 10),
                                              pos == 0
                                                  ? Container()
                                                  : widget.isEdit
                                                      ? Container()
                                                      : Row(
                                                          children: [
                                                            Spacer(),
                                                            GestureDetector(
                                                                onTap: () {
                                                                  levelWiseCount =
                                                                      levelWiseCount -
                                                                          1;
                                                                  selectedLevel4Drop
                                                                      .removeAt(
                                                                          pos);
                                                                  selectedLevel5Drop
                                                                      .removeAt(
                                                                          pos);
                                                                  setState(
                                                                      () {});
                                                                },
                                                                child: Image.asset(
                                                                    "assets/delete.png",
                                                                    width: 25,
                                                                    height:
                                                                        25)),
                                                            SizedBox(width: 10)
                                                          ],
                                                        ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12),
                                                child: Text(level4Title,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black
                                                          .withOpacity(0.7),
                                                    )),
                                              ),
                                              SizedBox(height: 2),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: CustomDropdown<
                                                        String>.search(
                                                      hintText:
                                                          'Select $level4Title',
                                                      items: level4ListAsString,
                                                      decoration:
                                                          CustomDropdownDecoration(
                                                        closedBorder:
                                                            Border.all(
                                                                color: Colors
                                                                    .black,
                                                                width: 0.7),
                                                        closedBorderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        closedSuffixIcon: Icon(
                                                            Icons
                                                                .keyboard_arrow_down_outlined,
                                                            color:
                                                                Colors.black),
                                                        expandedSuffixIcon: Icon(
                                                            Icons
                                                                .keyboard_arrow_up_outlined,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      overlayHeight: 342,
                                                      initialItem:
                                                          selectedLevel4Drop[
                                                              pos],
                                                      onChanged: (value) {
                                                        log('SearchDropdown onChanged value4: $value');
                                                        setState(() {
                                                          selectedLevel4Drop[
                                                                  pos] =
                                                              value.toString();
                                                        });
                                                      },
                                                    ),
                                                  ))
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12),
                                                child: Text(level5Title,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black
                                                          .withOpacity(0.7),
                                                    )),
                                              ),
                                              SizedBox(height: 2),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: CustomDropdown<
                                                        String>.search(
                                                      hintText:
                                                          'Select $level5Title',
                                                      items: level5ListAsString,
                                                      decoration:
                                                          CustomDropdownDecoration(
                                                        closedBorder:
                                                            Border.all(
                                                                color: Colors
                                                                    .black,
                                                                width: 0.7),
                                                        closedBorderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        closedSuffixIcon: Icon(
                                                            Icons
                                                                .keyboard_arrow_down_outlined,
                                                            color:
                                                                Colors.black),
                                                        expandedSuffixIcon: Icon(
                                                            Icons
                                                                .keyboard_arrow_up_outlined,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      overlayHeight: 342,
                                                      initialItem:
                                                          selectedLevel5Drop[
                                                              pos],
                                                      onChanged: (value) {
                                                        log('SearchDropdown onChanged value: $value');
                                                        setState(() {
                                                          selectedLevel5Drop[
                                                                  pos] =
                                                              value.toString();
                                                        });
                                                      },
                                                    ),
                                                  ))
                                                ],
                                              ),
                                              SizedBox(height: 12),
                                            ],
                                          );
                                        }),
                              ],
                            )
                          : Container(),
                      SizedBox(height: 5),
                    ],
                  ),
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
                      // checkValidations("save");
                      //saveBasicDetails();
                      checkValidationForBasic();
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
  }

  Widget _questionWiseWidget() {

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
                                  "$currentQuNo/$totalQuestion ${questionList[pos]["parameter"]}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF21317D).withOpacity(0.7),
                                  )),
                            ),
                          ),
                          children: [
                            SizedBox(height: 5),
                            widget.isEdit
                                ? ListView.builder(
                                itemCount: questionList[pos]["subparameter"].length,
                                shrinkWrap: true,
                                padding:
                                EdgeInsets.symmetric(horizontal: 5),
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  String subParamId = questionList[pos]["subparameter"][index]["id"].toString();
                                  int unsetRemarkPosition = findUnsatDependancies(paramId, subParamId);
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
                                  int isNA = questionList[pos]["subparameter"][index]["na"] ?? 0;
                                  int ispwd = questionList[pos]["subparameter"][index]["pwd"] ?? 0;
                                  int isper = questionList[pos]["subparameter"][index]["per"] ?? 0;
                                  int isCritical = questionList[pos]["subparameter"][index]["critical"] ?? 0;
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

                                  int isCollectionManager = questionList[pos]["subparameter"][index]["collection_manager"] ?? 0;

                                  if (isCollectionManager == 1) {
                                    otpQuestionIds.add(subParamId);
                                  }
                                  if(dropdownSelectionList[pos][index]!=null&&dropdownSelectionList[pos][index] == naTitle){
                                    if (weightList[pos][index] == "") {
                                      scorableList[pos] = scorableList[pos] + 0;
                                      weightList[pos][index] = "0";
                                      scoredList[pos] = scoredList[pos] + 0;
                                      if (scorableList[pos] == 0) {
                                        scoreInPercentage[pos] = 0.0;
                                      } else {
                                        scoreInPercentage[pos] = (scoredList[pos] * 100) / scorableList[pos];
                                      }
                                    } else {
                                      if (weightList[pos][index] != "0") {
                                        scorableList[pos] = scorableList[pos] - int.parse(questionList[pos]["subparameter"][index]["weight"].toString());
                                        scoredList[pos] = scoredList[pos] - int.parse(questionList[pos]["subparameter"][index]["weight"].toString());
                                      }

                                      weightList[pos][index] = "0";
                                      if (scorableList[pos] == 0) {
                                        scoreInPercentage[pos] = 0.0;
                                      } else {
                                        scoreInPercentage[pos] = (scoredList[pos] * 100) / scorableList[pos];
                                      }
                                    }
                                  }

                                  return Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Text(
                                            questionList[pos]["subparameter"][index]["sub_parameter"],
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                      ),
                                      const SizedBox(height: 5),
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
                                                  menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.only(left: 12),),
                                                  iconStyleData: IconStyleData(icon: Icon(Icons.keyboard_arrow_down_outlined, color: Colors.black),),
                                                  isExpanded: true,
                                                  hint: Text('Choose Type', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black.withOpacity(0.7),)),
                                                  items: answerList.map((item) => DropdownMenuItem<String>(value: item, child: Text(item, style: const TextStyle(fontSize: 14,),),)).toList(),
                                                  value: dropdownSelectionList[pos][index],
                                                  onChanged: (value) {dropdownSelectionList[pos][index] = value as String;
                                                    if (dropdownSelectionList[pos][index] == satisTitle) {
                                                      print("DDDD");
                                                      print(pos.toString());
                                                      print(weightList[pos][index]);
                                                      print(scoredList[pos].toString());

                                                      if (weightList[pos][index] == "") {
                                                        scorableList[pos] = scorableList[pos] + int.parse(questionList[pos]["subparameter"][index]["weight"].toString());
                                                      }

                                                      if (weightList[pos][index] == "" || weightList[pos][index] == "0") {
                                                        scoredList[pos] = scoredList[pos] + int.parse(questionList[pos]["subparameter"][index]["weight"].toString());
                                                      }

                                                      weightList[pos][index] = questionList[pos]["subparameter"][index]["weight"].toString();

                                                      if (scorableList[pos] == 0) {
                                                        scoreInPercentage[pos] = 0.0;
                                                      } else {
                                                        scoreInPercentage[pos] = (scoredList[pos] * 100) / scorableList[pos];
                                                      }
                                                      removeTheItemWhenSatisSelected(paramId, subParamId);
                                                    }
                                                    else if (dropdownSelectionList[pos][index] == unsetTitle) {
                                                      print("NO ANSWER SELEC");
                                                      print(weightList[pos][index].toString());
                                                      if (weightList[pos][index] == "") {
                                                        print("Item not exists");
                                                        scorableList[pos] = scorableList[pos] + int.parse(questionList[pos]["subparameter"][index]["weight"].toString());
                                                        weightList[pos][index] = "0";
                                                        scoredList[pos] = scoredList[pos] + 0;
                                                        if (scorableList[pos] == 0) {
                                                          scoreInPercentage[
                                                          pos] = 0.0;
                                                        } else {
                                                          scoreInPercentage[pos] = (scoredList[pos] * 100) / scorableList[pos];
                                                        }

                                                      } else {
                                                        print("Item exists");

                                                        weightList[pos][index] = "0";

                                                        print("Scored List " + scoredList[pos].toString());
                                                        print("Scored List22 " + questionList[pos]["subparameter"][index]["weight"].toString());

                                                        if (scoredList[pos] != 0) {
                                                          scoredList[pos] = scoredList[pos] - int.parse(questionList[pos]["subparameter"][index]["weight"].toString());
                                                        }

                                                        if (scorableList[pos] == 0) {
                                                          scoreInPercentage[pos] = 0.0;
                                                        } else {
                                                          scoreInPercentage[pos] = (scoredList[pos] * 100) / scorableList[pos];
                                                        }
                                                      }

                                                      checkForUnSatSelection(paramId, questionList[pos]["subparameter"][index]["id"].toString(), dropdownSelectionList[pos][index].toString());
                                                    }
                                                    else if (dropdownSelectionList[pos][index] == criticalTitle) {
                                                      if (weightList[pos][index] == "") {
                                                        scorableList[pos] = scorableList[pos] +
                                                            int.parse(questionList[pos]["qm_sheet_sub_parameter"][index]["weight"].toString());
                                                        weightList[pos][index] = "0";
                                                        scoredList[pos] = scoredList[pos] + 0;
                                                        if (scorableList[pos] == 0) {
                                                          scoreInPercentage[pos] = 0.0;
                                                        } else {
                                                          scoreInPercentage[pos] = (scoredList[pos] * 100) / scorableList[pos];
                                                        }
                                                      } else {
                                                        if (weightList[pos][index] != "0") {
                                                          scoredList[pos] = scoredList[pos] - int.parse(questionList[pos]["qm_sheet_sub_parameter"][index]["weight"].toString());
                                                        }

                                                        weightList[pos][index] = "0";
                                                        if (scorableList[pos] == 0) {
                                                          scoreInPercentage[pos] = 0.0;
                                                        } else {
                                                          scoreInPercentage[pos] = (scoredList[pos] * 100) / scorableList[pos];
                                                        }
                                                      }
                                                      removeTheItemWhenSatisSelected(paramId, subParamId);
                                                    }
                                                    /*else if (dropdownSelectionList[pos][index] == naTitle) {
                                                      scorableList[pos] = scorableList[pos] + 0;
                                                      weightList[pos][index] = "0";
                                                      scoredList[pos] = 0;
                                                      scoreInPercentage[pos] = 0.0;

                                                      removeTheItemWhenSatisSelected(paramId, subParamId);
                                                    }*/else if (dropdownSelectionList[pos][index] == naTitle) {
                                                      if (weightList[pos][index] == "") {
                                                        scorableList[pos] = scorableList[pos] + 0;
                                                        weightList[pos][index] = "0";
                                                        scoredList[pos] = scoredList[pos] + 0;
                                                        if (scorableList[pos] == 0) {
                                                          scoreInPercentage[pos] = 0.0;
                                                        } else {
                                                          scoreInPercentage[pos] = (scoredList[pos] * 100) / scorableList[pos];
                                                        }
                                                      } else {
                                                        if (weightList[pos][index] != "0") {
                                                          scorableList[pos] = scorableList[pos] - int.parse(questionList[pos]["subparameter"][index]["weight"].toString());
                                                          scoredList[pos] = scoredList[pos] - int.parse(questionList[pos]["subparameter"][index]["weight"].toString());
                                                        }

                                                        weightList[pos][index] = "0";
                                                        if (scorableList[pos] == 0) {
                                                          scoreInPercentage[pos] = 0.0;
                                                        } else {
                                                          scoreInPercentage[pos] = (scoredList[pos] * 100) / scorableList[pos];
                                                        }
                                                      }






                                                      /* scorableList[pos] = scorableList[pos] + 0;
                                                      weightList[pos][index] = "0";
                                                      scoredList[pos] =scoredList[pos]+0;
                                                      scoreInPercentage[pos] = 0.0;*/
                                                      removeTheItemWhenSatisSelected(paramId, subParamId);
                                                    }

                                                    if (scorableList.length == 0) {
                                                      finalGrade = "";
                                                    } else if (scorableList.reduce((a, b) => a + b) == 0) {
                                                      finalGrade = "";
                                                    } else {
                                                      double finalCal = scoredList.reduce((a, b) => a + b) * 100 / scorableList.reduce((a, b) => a + b);
                                                      if (finalCal >= 90) {
                                                        finalGrade = "A";
                                                      } else if (finalCal >= 75) {
                                                        finalGrade = "B";
                                                      } else if (finalCal >= 61) {
                                                        finalGrade = "C";
                                                      } else {
                                                        finalGrade = "D";
                                                      }
                                                    }

                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      previousRemark.isNotEmpty
                                          ? Padding(
                                          padding: const EdgeInsets
                                              .symmetric(horizontal: 4),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                  "Repeat Issue, Check Previous Remark below",
                                                  style:
                                                  const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    color: Colors.red,
                                                  )),
                                              const SizedBox(
                                                  height: 10),
                                              Text(previousRemark,
                                                  style:
                                                  const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    color: AppTheme
                                                        .themeColor,
                                                  )),
                                              const SizedBox(
                                                  height: 10),
                                            ],
                                          ))
                                          : Container(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Row(
                                          children: [
                                            previousArtifact.isNotEmpty
                                                ? Expanded(
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text(
                                                        "Previous Uploaded Artifact",
                                                        style:
                                                        const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500,
                                                          color: Colors
                                                              .red,
                                                        )),
                                                    const SizedBox(
                                                        height: 10),
                                                    ClipRRect(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          16),
                                                      // rounded corners
                                                      child:
                                                      CachedNetworkImage(
                                                        height: 150,
                                                        imageUrl:
                                                        previousArtifact,
                                                        fit: BoxFit
                                                            .cover,
                                                        placeholder:
                                                            (context,
                                                            url) =>
                                                            Container(
                                                              color: Colors
                                                                  .grey[
                                                              200],
                                                              child:
                                                              const Center(
                                                                child: CircularProgressIndicator(
                                                                    strokeWidth:
                                                                    2),
                                                              ),
                                                            ),
                                                        errorWidget: (context,
                                                            url,
                                                            error) =>
                                                        const Icon(
                                                            Icons
                                                                .error,
                                                            color: Colors
                                                                .red),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        height: 10),
                                                  ],
                                                ))
                                                : Container(),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            applicableIssueList.isNotEmpty
                                                ? Padding(padding: EdgeInsets.only(bottom: 10), child: Card(
                                              elevation: 4,
                                              shadowColor:
                                              Colors.grey,
                                              shape:
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    6.0),
                                              ),
                                              child: Container(
                                                height: 46,
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                          Colors
                                                              .white),
                                                      // background
                                                      backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                          Color(
                                                              0xFFEA735B)),
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
                                                    selectIssueBottomSheem(context, applicableIssueList,paramId,subParamId);
                                                  },
                                                  child: const Text(
                                                    'Select Issues',
                                                    style: TextStyle(
                                                      fontSize: 15.5,
                                                      fontWeight:
                                                      FontWeight
                                                          .w500,
                                                      color: Colors
                                                          .white,
                                                    ),
                                                    textAlign:
                                                    TextAlign
                                                        .center,
                                                  ),
                                                ),
                                              ),
                                            ),)
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        // height: 41,
                                        margin: const EdgeInsets.symmetric(
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
                                                          builder: (context) => ViewArtifactScreen(
                                                              widget
                                                                  .sheetID,
                                                              questionList[pos]
                                                              ["id"]
                                                                  .toString(),
                                                              questionList[pos]
                                                              [
                                                              "subparameter"]
                                                              [
                                                              index]["id"]
                                                                  .toString(),
                                                              AuditIdReal)));
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
                                                          builder: (context) => UploadArtifactScreen(
                                                              widget
                                                                  .sheetID,
                                                              questionList[pos]
                                                              ["id"]
                                                                  .toString(),
                                                              questionList[pos]
                                                              [
                                                              "subparameter"]
                                                              [
                                                              index]["id"]
                                                                  .toString(),
                                                              "1456",
                                                              AuditIdReal)));
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
                                : ListView.builder(
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

                                  int isCollectionManager = questionList[pos]["qm_sheet_sub_parameter"][index]["collection_manager"] ?? 0;

                                  if (isCollectionManager == 1) {
                                    otpQuestionIds.add(subParamId);
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

                                                    if (dropdownSelectionList[pos][index] == satisTitle) {
                                                      if (weightList[pos][index] == "") {
                                                        scorableList[pos] = scorableList[pos] + int.parse(questionList[pos]["qm_sheet_sub_parameter"][index]["weight"].toString());
                                                      }
                                                      if (weightList[pos][index] == "" || weightList[pos][index] == "0") {
                                                        scoredList[pos] = scoredList[pos] + int.parse(questionList[pos]["qm_sheet_sub_parameter"][index]["weight"].toString());
                                                      }
                                                      weightList[pos][index] = questionList[pos]["qm_sheet_sub_parameter"][index]["weight"].toString();

                                                      if (scorableList[pos] == 0) {scoreInPercentage[pos] = 0.0;
                                                      } else {scoreInPercentage[pos] = (scoredList[pos] * 100) / scorableList[pos];}
                                                      removeTheItemWhenSatisSelected(paramId, subParamId);
                                                    } else if (dropdownSelectionList[pos][index] == unsetTitle) {
                                                      if (weightList[pos][index] == "") {
                                                        scorableList[pos] = scorableList[pos] + int.parse(questionList[pos]["qm_sheet_sub_parameter"][index]["weight"].toString());
                                                        weightList[pos][index] = "0";
                                                        scoredList[pos] = scoredList[pos] + 0;
                                                        if (scorableList[pos] == 0) {
                                                          scoreInPercentage[pos] = 0.0;
                                                        } else {
                                                          scoreInPercentage[pos] = (scoredList[pos] * 100) / scorableList[pos];
                                                        }
                                                      } else {
                                                        if (weightList[pos][index] != "0") {
                                                          scoredList[pos] = scoredList[pos] - int.parse(questionList[pos]["qm_sheet_sub_parameter"][index]["weight"].toString());
                                                        }

                                                        weightList[pos][index] = "0";
                                                        if (scorableList[pos] == 0) {
                                                          scoreInPercentage[pos] = 0.0;
                                                        } else {
                                                          scoreInPercentage[pos] = (scoredList[pos] * 100) / scorableList[pos];
                                                        }
                                                      }
                                                      checkForUnSatSelection(
                                                          paramId, questionList[pos]["qm_sheet_sub_parameter"][index]["id"].toString(),
                                                          dropdownSelectionList[pos][index].toString());
                                                    } else if (dropdownSelectionList[pos][index] == criticalTitle) {
                                                      if (weightList[pos][index] == "") {
                                                        scorableList[pos] = scorableList[pos] +
                                                            int.parse(questionList[pos]["qm_sheet_sub_parameter"][index]["weight"].toString());
                                                        weightList[pos][index] = "0";
                                                        scoredList[pos] = scoredList[pos] + 0;
                                                        if (scorableList[pos] == 0) {
                                                          scoreInPercentage[pos] = 0.0;
                                                        } else {
                                                          scoreInPercentage[pos] = (scoredList[pos] * 100) / scorableList[pos];
                                                        }
                                                      } else {
                                                        if (weightList[pos][index] != "0") {
                                                          scoredList[pos] = scoredList[pos] - int.parse(questionList[pos]["qm_sheet_sub_parameter"][index]["weight"].toString());
                                                        }

                                                        weightList[pos][index] = "0";
                                                        if (scorableList[pos] == 0) {
                                                          scoreInPercentage[pos] = 0.0;
                                                        } else {
                                                          scoreInPercentage[pos] = (scoredList[pos] * 100) / scorableList[pos];
                                                        }
                                                      }
                                                      removeTheItemWhenSatisSelected(paramId, subParamId);
                                                    } else if (dropdownSelectionList[pos][index] == naTitle) {
                                                      if (weightList[pos][index] == "") {
                                                        scorableList[pos] = scorableList[pos] + 0;
                                                        weightList[pos][index] = "0";
                                                        scoredList[pos] = scoredList[pos] + 0;
                                                        if (scorableList[pos] == 0) {
                                                          scoreInPercentage[pos] = 0.0;
                                                        } else {
                                                          scoreInPercentage[pos] = (scoredList[pos] * 100) / scorableList[pos];
                                                        }
                                                      } else {



                                                        if (weightList[pos][index] != "0") {
                                                          scorableList[pos] = scorableList[pos] - int.parse(questionList[pos]["qm_sheet_sub_parameter"][index]["weight"].toString());
                                                          scoredList[pos] = scoredList[pos] - int.parse(questionList[pos]["qm_sheet_sub_parameter"][index]["weight"].toString());
                                                        }

                                                        weightList[pos][index] = "0";
                                                        if (scorableList[pos] == 0) {
                                                          scoreInPercentage[pos] = 0.0;
                                                        } else {
                                                          scoreInPercentage[pos] = (scoredList[pos] * 100) / scorableList[pos];
                                                        }
                                                      }






                                                     /* scorableList[pos] = scorableList[pos] + 0;
                                                      weightList[pos][index] = "0";
                                                      scoredList[pos] =scoredList[pos]+0;
                                                      scoreInPercentage[pos] = 0.0;*/
                                                      removeTheItemWhenSatisSelected(paramId, subParamId);
                                                    }

                                                    if (scorableList.length == 0) {
                                                      finalGrade = "";
                                                    } else if (scorableList.reduce((a, b) => a + b) == 0) {
                                                      finalGrade = "";
                                                    } else {
                                                      double finalCal = scoredList.reduce((a, b) => a + b) * 100 / scorableList.reduce((a, b) => a + b);

                                                      if (finalCal >= 90) {
                                                        finalGrade = "A";
                                                      } else if (finalCal >= 75) {
                                                        finalGrade = "B";
                                                      } else if (finalCal >= 61) {
                                                        finalGrade = "C";
                                                      } else {
                                                        finalGrade = "D";
                                                      }
                                                    }
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      previousRemark.isNotEmpty
                                          ? Padding(
                                          padding: const EdgeInsets
                                              .symmetric(horizontal: 4),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                  "Repeat Issue, Check Previous Remark below",
                                                  style:
                                                  const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    color: Colors.red,
                                                  )),
                                              const SizedBox(
                                                  height: 10),
                                              Text(previousRemark,
                                                  style:
                                                  const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    color: AppTheme
                                                        .themeColor,
                                                  )),
                                              const SizedBox(
                                                  height: 10),
                                            ],
                                          ))
                                          : Container(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Row(
                                          children: [
                                            previousArtifact.isNotEmpty
                                                ? Expanded(
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text(
                                                        "Previous Uploaded Artifact",
                                                        style:
                                                        const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500,
                                                          color: Colors
                                                              .red,
                                                        )),
                                                    const SizedBox(
                                                        height: 10),
                                                    ClipRRect(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          16),
                                                      // rounded corners
                                                      child:
                                                      CachedNetworkImage(
                                                        height: 150,
                                                        imageUrl:
                                                        previousArtifact,
                                                        fit: BoxFit
                                                            .cover,
                                                        placeholder:
                                                            (context,
                                                            url) =>
                                                            Container(
                                                              color: Colors
                                                                  .grey[
                                                              200],
                                                              child:
                                                              const Center(
                                                                child: CircularProgressIndicator(
                                                                    strokeWidth:
                                                                    2),
                                                              ),
                                                            ),
                                                        errorWidget: (context,
                                                            url,
                                                            error) =>
                                                        const Icon(
                                                            Icons
                                                                .error,
                                                            color: Colors
                                                                .red),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        height: 10),
                                                  ],
                                                ))
                                                : Container(),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            applicableIssueList.isNotEmpty
                                                ? Padding(padding: EdgeInsets.only(bottom: 10), child:Card(
                                              elevation: 4,
                                              shadowColor:
                                              Colors.grey,
                                              shape:
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    6.0),
                                              ),
                                              child: Container(

                                                height: 46,
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                          Colors
                                                              .white),
                                                      // background
                                                      backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                          Color(
                                                              0xFFEA735B)),
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
                                                    selectIssueBottomSheem(
                                                        context,
                                                        applicableIssueList,paramId,subParamId);
                                                  },
                                                  child: const Text(
                                                    'Select Issues',
                                                    style: TextStyle(
                                                      fontSize: 15.5,
                                                      fontWeight:
                                                      FontWeight
                                                          .w500,
                                                      color: Colors
                                                          .white,
                                                    ),
                                                    textAlign:
                                                    TextAlign
                                                        .center,
                                                  ),
                                                ),
                                              ),
                                            ) ,)
                                                : Container(),
                                          ],
                                        ),
                                      ),
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
                                                          builder: (context) => ViewArtifactScreen(
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
                                                              AuditIdReal)));
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
                                                          builder: (context) => UploadArtifactScreen(
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
                                                              AuditIdReal)));
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
  }

  Widget _showResultWidget() {
    setState(() {
      current_showing="";
    });
    return Column(
      children: [
        SizedBox(height: 14),
        Container(
          height: 43,
          margin: EdgeInsets.symmetric(horizontal: 10),
          color: AppTheme.themeColor,
          child: Row(
            children: [
              SizedBox(width: 10),
              Text("Result",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  )),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 5),
          height: 36,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Color(0xFF21317D).withOpacity(0.58)),
          child: Row(
            children: [
              Container(
                width: 130,
                child: Text("Parameter",
                    style: TextStyle(fontSize: 12, color: Colors.white)),
              ),
              Expanded(
                  child: Row(
                children: [
                  Expanded(
                      child: Center(
                        child: Text("Scorable",
                            style:
                                TextStyle(fontSize: 12, color: Colors.white)),
                      ),
                      flex: 1),
                  Expanded(
                      child: Center(
                        child: Text("Scored",
                            style:
                                TextStyle(fontSize: 12, color: Colors.white)),
                      ),
                      flex: 1),
                  Expanded(
                      child: Center(
                        child: Text("Scores%",
                            style:
                                TextStyle(fontSize: 12, color: Colors.white)),
                      ),
                      flex: 1),
                ],
              ))
            ],
          ),
        ),
        SizedBox(height: 5),
        ListView.builder(
            itemCount: resultList.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context, int pos) {

              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    height: 36,
                    child: Row(
                      children: [
                        Container(
                          width: 130,
                          child: Text(resultList[pos].paramName,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF21317D))),
                        ),
                        Expanded(
                            child: Row(
                          children: [
                            Expanded(
                                child: Center(
                                  child: Text(resultList[pos].scorable,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                ),
                                flex: 1),
                            Expanded(
                                child: Center(
                                  child: Text(resultList[pos].score,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                ),
                                flex: 1),
                            Expanded(
                                child: Center(
                                  child: Text(
                                      "${resultList[pos].percentage}%",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                ),
                                flex: 1),
                          ],
                        ))
                      ],
                    ),
                  ),
                  pos == resultList.length - 1
                      ? Container()
                      : Container(
                          child: Divider(),
                          margin: EdgeInsets.symmetric(horizontal: 14))
                ],
              );
            }),
        SizedBox(height: 7),
        Container(
          color: Color(0xFF21317D).withOpacity(0.58),
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 5),
          height: 36,
          child: Row(
            children: [
              Container(
                width: 130,
                child: Text("Over All",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ),
              Expanded(
                  child: Row(
                children: [
                  Expanded(
                      child: Center(
                        child: Text(
                            finalScorable,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),
                      flex: 1),
                  Expanded(
                      child: Center(
                        child: Text(
                            finalScore,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),
                      flex: 1),
                  Expanded(
                      child: Center(
                        child: Text(
                            "$finalPercentage%",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),
                      flex: 1),
                ],
              ))
            ],
          ),
        ),
        Container(
          height: 43,
          margin: EdgeInsets.symmetric(horizontal: 10),
          color: AppTheme.themeColor,
          child: Row(
            children: [
              SizedBox(width: 10),
              Text("Final Grade",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  )),
              Spacer(),
              Text(finalGradeToShow,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
              SizedBox(width: 10)
            ],
          ),
        ),
        SizedBox(height: 26),
        Card(
          elevation: 3,
          margin: EdgeInsets.only(left: 10),
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
                      AppTheme.themeColor), // fore
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ))),
              onPressed: () {
                checkValidations();
              },
              child: const Text(
                'SUBMIT',
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
      ],
    );
  }

  void questionSaveNext() {
    questionCurrentPosition = questionCurrentPosition + 1;
    setState(() {});
  }

  void saveBasicDetails() {
    showBasicLayout = false;
    setState(() {});
  }

  void showResultLayoutFunction() {
    showResultLayout = true;
    setState(() {});
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
        await helper.postAPIWithHeader('agency-details', requestModel, context);

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

    if (responseJSON["product"] != null) {
      if (productListAsString.length != 0) {
        productListAsString.clear();
      }
      productListAsString.add(responseJSON["product"]["name"]);
      selectedProduct = responseJSON["product"]["name"];
      selectedProductID = responseJSON["product"]["id"].toString();
    }
    subProductList = responseJSON["sub_products"];

    for (int i = 0; i < subProductList.length; i++) {
      selectedSubProductAsString
          .add(subProductList[i]["product_attribute_name"]);
      selectedSubProductIDsAsString.add(subProductList[i]["id"].toString());
    }

    if (responseJSON["agency_mobile_number"].length != 0) {
      if (phoneListAsString.length != 0) {
        phoneListAsString.clear();
      }
      Map<String, dynamic> data = responseJSON["agency_mobile_number"];
      List<String> keysList = [];
      keysList = data.keys.toList();
      print(responseJSON);
      print(data.keys.toList().toString());
      for (int i = 0; i < keysList.length; i++) {
        phoneListAsString.add(data[keysList[i]].toString());
      }

      selectedPhone = phoneListAsString[0].toString();
    }

    if (responseJSON["agency_email"].length != 0) {
      if (emailListAsString.length != 0) {
        emailListAsString.clear();
      }
      Map<String, dynamic> data = responseJSON["agency_email"];
      List<String> keysList = [];
      keysList = data.keys.toList();
      print(responseJSON);
      print(data.keys.toList().toString());
      for (int i = 0; i < keysList.length; i++) {
        emailListAsString.add(data[keysList[i]].toString());
      }
      selectedEmail = emailListAsString[0].toString();
    }

    if (widget.isEdit) {
      if (responseJSON["agency_mobile_number"].length != 0 &&
          auditDetails["agency_mobile"] != null) {
        selectedPhone = auditDetails["agency_mobile"].toString();
      }

      if (responseJSON["agency_email"].length != 0 &&
          auditDetails["agency_email"] != null) {
        selectedEmail = auditDetails["agency_email"];
      }
    }

    setState(() {});
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

  fetchAgenciesEdit(String agencyID) async {
    print("Agency Id : $agencyID");
    if (agencyList.length != 0) {
      agencyList.clear();
    }

    var requestModel = {"location": "kolkata"};

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(
        'get_agencies_from_city', requestModel, context);

    var responseJSON = json.decode(response.body);


    agencyList = responseJSON["details"];
    for (int i = 0; i < agencyList.length; i++) {
      if (agencyList[i]["id"].toString() == agencyID) {
        selectedAgencyIndex = i;
        break;
      }
    }
    setState(() {});
    fetchAgencyDetails();
  }

  fetchProductsEdit(String agencyID, String productID) async {
    if (productList.length != 0) {
      productList.clear();
      productListAsString.clear();
    }

    var requestModel = {
      "type": "agency",
      "id": agencyID,
    };

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPIWithHeader('getProduct', requestModel, context);

    var responseJSON = json.decode(response.body);
    print(responseJSON);

    productList = responseJSON["data"];
    for (int i = 0; i < productList.length; i++) {
      productListAsString.add(productList[i]["name"]);
    }

    for (int i = 0; i < productList.length; i++) {
      if (productList[i]["id"].toString() == productID) {
        selectedProduct = productList[i]["name"];
        break;
      }
    }

    fetchSubProductsEdit(productID);

    setState(() {});
  }

  fetchSubProductsEdit(String productID) async {
    if (subProductList.length != 0) {
      subProductList.clear();
    }
    subProductList.clear();

    var requestModel = {"product_id": productID};

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPIWithHeader('getSubProduct', requestModel, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    // agencyList=responseJSON["data"];
    subProductList = responseJSON["data"];

    setState(() {});
  }

  fetchUserListEdit(String? level3ID, String? level4ID, String? level5ID) async {
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.get('formet_user_list', context);
    var responseJSON = json.decode(response.body);
    Map<String, dynamic> data = responseJSON["details"];
    Map<String, dynamic> dataLevel5 = {};
    if (responseJSON["Level_5"].isNotEmpty) {
      dataLevel5 = responseJSON["Level_5"];
    }

    List<String> keysList = [];
    List<String> keysListLevel5 = [];
    keysList = data.keys.toList();
    keysListLevel5 = dataLevel5.keys.toList();
    levelByUserListKeys = keysList;
    level5UserListKeys = keysListLevel5;

    List<String> level5Data = [];

    for (int i = 0; i < keysListLevel5.length; i++) {
      level5Data.add(dataLevel5[keysListLevel5[i]]);
    }
    print(responseJSON);
    print(data.keys.toList().toString());

    for (int i = 0; i < keysListLevel5.length; i++) {
      level5Users.add({"id": keysListLevel5[i], "name": level5Data[i]});
    }
    for (int i = 0; i < level5Users.length; i++) {
      level5ListAsString.add(level5Users[i]["name"]);
    }

    print("LITTT");
    print(level5Users.toString());

    for (int i = 0; i < keysList.length; i++) {
      levelByUserList.add(data[keysList[i]]);
    }

    for (int i = 0; i < keysList.length; i++) {
      level4UserList.add({"id": keysList[i], "name": levelByUserList[i]});
    }

    for (int i = 0; i < level4UserList.length; i++) {
      level4ListAsString.add(level4UserList[i]["name"]);
    }

    print("LITTT22");
    print(level4UserList.toString());
    for (int i = 0; i < level4UserList.length; i++) {
      if (level3ID == level4UserList[i]["id"].toString()) {
        selectedlevel1 = level4UserList[i]["name"];
      }
    }
    List<String> level4IDList = level4ID.toString().split(",");
    print("Level 4 ID" + level4IDList.toString());

    for (int i = 0; i < level4UserList.length; i++) {
      for (int j = 0; j < level4IDList.length; j++) {
        if (level4IDList[j] == level4UserList[i]["id"].toString()) {
          print("Match F9ound");

          selectedLevel4Drop.add(level4UserList[i]["name"]);

          /*  selectedLevel4UserList.add(level4UserList[i].toString());
            selectedLevel4AsString.add(level4UserList[i]["name"]);*/
        }
      }
    }

    print("Selected Managers " + selectedLevel4UserList.toString());

    List<String> level5IDList = level5ID.toString().split(",");
    levelWiseCount = level4IDList.length;

    for (int i = 0; i < level5Users.length; i++) {
      for (int j = 0; j < level5IDList.length; j++) {
        if (level5IDList[j] == level5Users[i]["id"].toString()) {
          selectedLevel5Drop.add(level5Users[i]["name"]);
          /*  selectedLevel5Users.add(level5Users[i].toString());
          selectedLevel5Names.add(level5Users[i]["name"]);*/
        }
      }
    }

    setState(() {});
  }

  fetchAuditCycleListEdit(String selectedAuditID) async {
    var requestModel = {};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.getWithHeader('get_audit_cycle', requestModel, context);

    var responseJSON = json.decode(response.body);

    auditCycleList = responseJSON["details"];
    for (int i = 0; i < auditCycleList.length; i++) {
      auditCycleListAsString.add(auditCycleList[i]["name"]);
      if (auditCycleList[i]["id"].toString() == selectedAuditID) {
        selectedAuditCycle = auditCycleList[i]["name"];
      }
    }

    print("Cycle Data");
    print(responseJSON);
    setState(() {});
  }

  fetchCities() async {
    setState(() {
      isLoading = true;
    });
    var requestModel = {"qm_sheet_id": widget.sheetID};

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPIWithHeader('audit_sheet', requestModel, context);

    var responseJSON = json.decode(response.body);
    /* cityList = responseJSON["data"]["cities"];
    filteredCityList = responseJSON["data"]["cities"];*/
    questionList = responseJSON["data"]["data"]["parameter"];

    for (int i = 0; i < questionList.length; i++) {
      print("LOOP COUNT" + i.toString());
      scorableList.add(0);
      scoredList.add(0);
      scoreInPercentage.add(0);
    }

    setState(() {
      isLoading = false;
    });

    int row = questionList.length;
    int col = 20;
    dropdownSelectionList = List<List>.generate(
        row, (i) => List<dynamic>.generate(col, (index) => null));
    weightList = List<List>.generate(
        row, (i) => List<String>.generate(col, (index) => ""));
    controllerList = List<List>.generate(
        row,
        (i) => List<TextEditingController>.generate(
            col, (index) => TextEditingController()));
    //var twoDList = List<List>.generate(row, (i) => List<dynamic>.generate(col, (index) => null));

    print("Hello 2D");

    /*  auditCycleList = responseJSON["data"]["cycle"];
    for (int i = 0; i < auditCycleList.length; i++) {
      auditCycleListAsString.add(auditCycleList[i]["name"]);
    }*/

    /*  lobList = responseJSON["data"]["bucket"];
    for (int i = 0; i < lobList.length; i++) {
      lobListAsString.add(lobList[i]["lob"]);
    }*/

    print(responseJSON);
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
        'get_agencies_from_city', requestModel, context);

    var responseJSON = json.decode(response.body);
    print(responseJSON);
    agencyList = responseJSON["details"];
    setState(() {});
  }

  fetchAuditCycleList() async {
    var requestModel = {};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.getWithHeader('get_audit_cycle', requestModel, context);

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

  fetchUserList() async {
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.get('formet_user_list', context);
    var responseJSON = json.decode(response.body);
    Map<String, dynamic> data = responseJSON["details"];
    Map<String, dynamic> dataLevel5 = responseJSON["Level_5"];
    List<String> keysList = [];
    List<String> keysListLevel5 = [];
    keysList = data.keys.toList();
    keysListLevel5 = dataLevel5.keys.toList();
    levelByUserListKeys = keysList;
    level5UserListKeys = keysListLevel5;

    List<String> level5Data = [];

    for (int i = 0; i < keysListLevel5.length; i++) {
      level5Data.add(dataLevel5[keysListLevel5[i]]);
    }
    print(responseJSON);
    print(data.keys.toList().toString());

    for (int i = 0; i < keysListLevel5.length; i++) {
      level5Users.add({"id": keysListLevel5[i], "name": level5Data[i]});
    }

    for (int i = 0; i < level5Users.length; i++) {
      level5ListAsString.add(level5Users[i]["name"]);
      if (i == 0) {
        selectedLevel5Drop.add(null);
        //selectedLevel5Drop.add(level5Users[0]["name"]);
      }
    }

    print("LITTT");
    print(level5Users.toString());

    for (int i = 0; i < keysList.length; i++) {
      levelByUserList.add(data[keysList[i]]);
    }

    for (int i = 0; i < keysList.length; i++) {
      level4UserList.add({"id": keysList[i], "name": levelByUserList[i]});
    }
    for (int i = 0; i < level4UserList.length; i++) {
      level4ListAsString.add(level4UserList[i]["name"]);
      if (i == 0) {
        selectedLevel4Drop.add(null);
        // selectedLevel4Drop.add(level4UserList[0]["name"]);
      }
    }

    /* selectedlevel1 = levelByUserList[0].toString();
    selectedlevel2 = levelByUserList[0].toString();
    selectedlevel3 = levelByUserList[0].toString();*/

    setState(() {});
  }

  fetchAllocatedModule() async {
    APIDialog.showAlertDialog(context, "Please wait.Checking ...");
    var requestModel = {
      "user_id": AppModel.userID,
    };
    print("Request Model $requestModel");
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(
        'allocated-modules', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print("Allocated Module:-$responseJSON");
    if (responseJSON['status'].toString() == "1") {
      final allModules = responseJSON['allocated_module'] as List<dynamic>;
      for (int i = 0; i < allModules.length; i++) {
        int key = allModules[i]['key'] ?? 0;
        String mo = allModules[i]['key']?.toString() ?? "";
        if (key == allocatedModuleOTP) {
          isOTPRequired = true;
        } else if (key == allocatedModuleLevels) {
          isLevelShow = true;
        }
      }

      setState(() {});
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  checkValidationForBasic() {
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
    } else if (!checkLevelsValidation()) {
      print("There is a validation error with Level");
    } else {
      _saveBasicDetailsForm();
    }
  }

  bool checkLevelsValidation() {
    ToastContext().init(context);
    bool validation = true;
    if (!isLevelShow) {
      return validation;
    }
    if (selectedlevel1 != null) {
      bool allSelected = !selectedLevel4Drop.contains(null) &&
          !selectedLevel5Drop.contains(null);
      if (!allSelected) {
        Toast.show("Please select all levels before continuing",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
        validation = false;
      } else {
        validation = true;
      }
    } else {
      Toast.show("Please select Level 3",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      validation = false;
    }

    return validation;
  }

  _saveBasicDetailsForm() async {
    APIDialog.showAlertDialog(context, "Saving Basic Details...");
    String auditCycleID = "";
    for (int i = 0; i < auditCycleList.length; i++) {
      if (selectedAuditCycle == auditCycleList[i]["name"]) {
        auditCycleID = auditCycleList[i]["id"].toString();
        break;
      }
    }
    if (level4IDs.isNotEmpty) {
      level4IDs.clear();
    }
    if (level5IDs.isNotEmpty) {
      level5IDs.clear();
    }
    for (int i = 0; i < selectedLevel4Drop.length; i++) {
      bool flag = false;
      print("LOOP DATA44");

      for (int j = 0; j < level4UserList.length; j++) {
        print("LOOP DATA " + j.toString());

        print(selectedLevel4Drop[i]);
        print(level4UserList[j]["name"]);

        if (selectedLevel4Drop[i] != null) {
          if (selectedLevel4Drop[i] == level4UserList[j]["name"]) {
            flag = true;
            print("LOOP DATA 22");
            level4IDs.add(level4UserList[j]["id"].toString());
            break;
          }
        }
      }
    }
    for (int i = 0; i < selectedLevel5Drop.length; i++) {
      for (int j = 0; j < level5Users.length; j++) {
        if (selectedLevel5Drop[i] != null) {
          if (selectedLevel5Drop[i] == level5Users[j]["name"]) {
            level5IDs.add(level5Users[j]["id"].toString());
            break;
          }
        }
      }
    }

    String level1ID = "";
    for (int i = 0; i < level4UserList.length; i++) {
      if (level4UserList[i]["name"] == selectedlevel1.toString()) {
        level1ID = level4UserList[i]["id"].toString();
        break;
      }
    }
    selectedAgencyId = agencySearchController.text.toString().length == 0
        ? agencyList[selectedAgencyIndex]["id"].toString()
        : filteredAgencyList[selectedAgencyIndex]["id"].toString();

    String selectedSubproductId = selectedSubProductIDsAsString.join(",");

    var requestModels = {
      "lat_long": latLongController.text.toString(),
      "qm_sheet_id": widget.sheetID,
      "audit_cycle_id": auditCycleID,
      "agency_phone": selectedPhone.toString(),
      "agency_manager_name":agencyManagerNameController.text.toString(),
      "agency_email": selectedEmail.toString(),
      "present_auditor": presentAuditorController.text.toString(),
      "branch_id": "",
      "agency_id": agencySearchController.text.toString().length == 0
          ? agencyList[selectedAgencyIndex]["id"].toString()
          : filteredAgencyList[selectedAgencyIndex]["id"].toString(),
      "yard_id": "",
      "branch_repo_id": "",
      "agency_repo_id": "",
      "product_id": selectedProductID,
      "sub_product_id": selectedSubproductId,
      "collection_manager_id": level1ID,
      "lavel_4": level4IDs,
      "lavel_5": level5IDs,
    };
    var requestModelEdit = {
      "audit_id": AuditIdReal,
      "lat_long": latLongController.text.toString(),
      "qm_sheet_id": widget.sheetID,
      "audit_cycle_id": auditCycleID,
      "agency_phone": selectedPhone.toString(),
      "agency_email": selectedEmail.toString(),
      "agency_manager_name":agencyManagerNameController.text.toString(),
      "present_auditor": presentAuditorController.text.toString(),
      "branch_id": "",
      "agency_id": agencySearchController.text.toString().length == 0
          ? agencyList[selectedAgencyIndex]["id"].toString()
          : filteredAgencyList[selectedAgencyIndex]["id"].toString(),
      "yard_id": "",
      "branch_repo_id": "",
      "agency_repo_id": "",
      "product_id": selectedProductID,
      "sub_product_id": selectedSubproductId,
      "collection_manager_id": level1ID,
      "lavel_4": level4IDs,
      "lavel_5": level5IDs,
    };

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('saveBasicInfoaudit',
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

  checkValidations() {
    ToastContext().init(context);
    /*String idDummy = "133";
    String idDummyStaging = "131";
    String id = "184";
    String id1 = "151";
    String id2 = "218";
    String idStaging = "42";*/

    String question = "Check collection manager";
    String question2 =
        "Presence Of Banker During Process Review (Mention the reason with product name (Cards/Retail/MSME) in remarks if UNSATISFACTORY)";
    collectionManagerSelected = false;

    if (widget.isEdit) {
      outerLoop:
      for (int i = 0; i < questionList.length; i++) {
        for (int j = 0;
        j < questionList[i]["subparameter"].length;
        j++) {
          String subParamId =
          questionList[i]["subparameter"][j]["id"].toString();
          print(subParamId);
          if (otpQuestionIds.contains(subParamId)) {
            if (dropdownSelectionList[i][j] == "Satisfactory") {
              collectionManagerSelected = true;
              break outerLoop;
            }
          }
        }
      }

      /*outerLoop:
      for (int i = 0; i < questionList.length; i++) {
        for (int j = 0; j < questionList[i]["subparameter"].length; j++) {
          String subParamId = questionList[i]["subparameter"][j]["id"].toString();
          if (otpQuestionIds.contains(subParamId)) {
            if (dropdownSelectionList[i][j] == "Satisfactory") {
              collectionManagerSelected = true;
              break outerLoop;
            }
          }
        }
      }*/
    } else {
      outerLoop:
      for (int i = 0; i < questionList.length; i++) {
        for (int j = 0;
            j < questionList[i]["qm_sheet_sub_parameter"].length;
            j++) {
          String subParamId =
              questionList[i]["qm_sheet_sub_parameter"][j]["id"].toString();
          print(subParamId);
          if (otpQuestionIds.contains(subParamId)) {
            if (dropdownSelectionList[i][j] == "Satisfactory") {
              collectionManagerSelected = true;
              break outerLoop;
            }
          }
        }
      }
    }

    print("COLLL");
    print("OTP Required ids $otpQuestionIds");
    print(collectionManagerSelected.toString());

    if (isOTPRequired) {
      print("is OTP Required $isOTPRequired");
      sendOTP("");
    } else {
      print("is OTP Not Required $isOTPRequired");
      //prepareData("submit");
      submitAudit();
    }
  }

  sendOTP(String productID) async {
    APIDialog.showAlertDialog(context, "Sending OTP...");
    List<Map<String, dynamic>> parameterList = [];
    if (widget.isEdit) {
      for (int i = 0; i < questionList.length; i++) {
        print("LOOP COUNT");
        Map<String, dynamic> parameterListChild = Map();
        parameterListChild.addAll({
          (questionList[i]["id"]).toString(): {
            "subs": {
              for (int r = 0; r < questionList[i]["subparameter"].length; r++)

                (questionList[i]["subparameter"][r]["id"]).toString(): {
                  "score":dropdownSelectionList[i][r] == naTitle
                      ? naTitle
                      : dropdownSelectionList[i][r] == unsetTitle
                      ? "0"
                      : weightList[i][r],
                  "option": dropdownSelectionList[i][r],
                  "remark": controllerList[i][r].text
                }
            }
          },
        });
        parameterList.add(parameterListChild);
      }
    } else {
      for (int i = 0; i < questionList.length; i++) {
        print("LOOP COUNT");

        Map<String, dynamic> parameterListChild = Map();

        parameterListChild.addAll({
          (questionList[i]["id"]).toString(): {
            "subs": {
              for (int r = 0; r < questionList[i]["qm_sheet_sub_parameter"].length; r++)
                (questionList[i]["qm_sheet_sub_parameter"][r]["id"]).toString():
                    {
                      "score":dropdownSelectionList[i][r] == naTitle
                          ? naTitle
                          : dropdownSelectionList[i][r] == unsetTitle
                          ? "0"
                          : weightList[i][r],
                      "option": dropdownSelectionList[i][r],
                      "remark": controllerList[i][r].text
                }
            }
          },
        });

        parameterList.add(parameterListChild);
      }
    }

    String auditCycleID = "";

    for (int i = 0; i < auditCycleList.length; i++) {
      if (selectedAuditCycle == auditCycleList[i]["name"]) {
        auditCycleID = auditCycleList[i]["id"].toString();
        break;
      }
    }
    var requestModel = {
      "agency_email": selectedEmail,
      "user_id": AppModel.userID,
      "agency_id": agencySearchController.text.toString().length == 0
          ? agencyList[selectedAgencyIndex]["id"].toString()
          : filteredAgencyList[selectedAgencyIndex]["id"].toString(),
      "parameters": parameterList,
      "product_id": selectedProductID,
      "audit_id":AuditIdReal,
      "audit_cycle": auditCycleID,
      "overall_score": scoredList.reduce((a, b) => a + b).toString(),
    };

    log(json.encode(requestModel));

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(
        'agency/send-otp', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    print(responseJSON);

    if (responseJSON['message'].toString() == "OTP and PDF sent successfully") {
      Toast.show(responseJSON['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      startTimer();

      if (productID != "resend") {
        textEditingController.text = "";
        otpVerifyDialog(context);
      }
    }

    setState(() {});
  }

  void otpVerifyDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStateDialog) {
            setStateGlobal = setStateDialog;
            return AlertDialog(
                insetPadding: const EdgeInsets.all(10),
                scrollable: true,
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                //this right here
                content: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        key: _formKeyGuestOTP,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFF3F3F3),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text('Please Enter Agency OTP',
                                        style: TextStyle(
                                            fontSize: 15.5,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black)),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(Icons.close_rounded,
                                          color: Colors.black)),
                                  const SizedBox(width: 10)
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            const SizedBox(height: 20),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              height: 45,
                              child: Center(
                                  child: PinCodeTextField(
                                length: 6,
                                autoDisposeControllers: false,
                                keyboardType: TextInputType.number,
                                obscureText: false,
                                animationType: AnimationType.fade,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderWidth: 1,
                                  borderRadius: BorderRadius.circular(5),
                                  fieldHeight: 45,
                                  selectedColor: AppTheme.themeColor,
                                  selectedFillColor: Colors.white,
                                  fieldWidth: 40,
                                  activeFillColor: Colors.white,
                                  activeColor: Colors.green,
                                  inactiveFillColor: AppTheme.otpColor,
                                  inactiveColor: AppTheme.otpColor,
                                  disabledColor: AppTheme.otpColor,
                                  errorBorderColor: Colors.red,
                                ),
                                animationDuration: Duration(milliseconds: 300),
                                backgroundColor: Colors.white,
                                enableActiveFill: true,
                                controller: textEditingController,
                                enablePinAutofill: false,
                                onCompleted: (v) {
                                  print("Completed");
                                  print(v);
                                  userEnteredOTP = v;
                                },
                                onChanged: (value) {
                                  print(value);
                                  setState(() {
                                    userEnteredOTP = value;
                                  });
                                },
                                appContext: context,
                              )),
                            ),
                            const SizedBox(height: 25),
                            InkWell(
                              onTap: () {
                                if (userEnteredOTP.length != 6) {
                                  Toast.show("Please enter a Valid OTP",
                                      duration: Toast.lengthLong,
                                      gravity: Toast.bottom,
                                      backgroundColor: Colors.blue);
                                } else {
                                  verifyOTP();
                                }
                              },
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: AppTheme.themeColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  height: 50,
                                  child: const Center(
                                    child: Text('Submit',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                  )),
                            ),
                            SizedBox(height: 12),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                    children: <TextSpan>[
                                      const TextSpan(text: 'Resend OTP in '),
                                      TextSpan(
                                        text: _start < 10
                                            ? '00:0' + _start.toString()
                                            : '00:' + _start.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                      const TextSpan(text: ' seconds '),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Didn\'t receive the OTP ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A1A1A),
                                    )),
                                _start == 0
                                    ? GestureDetector(
                                        onTap: () {
                                          sendOTP("resend");
                                        },
                                        child: Text('Resend',
                                            style: TextStyle(
                                              fontSize: 15,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  AppTheme.themeColor,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.themeColor,
                                            )),
                                      )
                                    : Text('Resend',
                                        style: TextStyle(
                                          fontSize: 15,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        )),
                              ],
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ));
          });
        });
  }

  void startTimer() {
    _start = 30;
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setStateGlobal!(() {
            timer.cancel();
          });
        } else {
          setStateGlobal!(() {
            _start--;
          });
        }
      },
    );
  }

  verifyOTP() async {
    APIDialog.showAlertDialog(context, "Verifying OTP...");

    var requestModel = {
      "otp": userEnteredOTP,
      "agency_email": selectedEmail,
      "agency_id": agencySearchController.text.toString().length == 0
          ? agencyList[selectedAgencyIndex]["id"].toString()
          : filteredAgencyList[selectedAgencyIndex]["id"].toString()
    };

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(
        'agency/verify-otp', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    print(responseJSON);

    if (responseJSON['status'].toString() == "valid") {
      Navigator.pop(context);
      Toast.show("OTP Verified successfully!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      if (collectionManagerSelected) {
        sendOTPToCollectionManager(false);
      } else {
        //prepareData("submit");
        submitAudit();
      }

      // AuditSubmit API
    } else if (responseJSON["status"] == "invalid") {
      Toast.show("Invalid OTP!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    setState(() {});
  }

  sendOTPToCollectionManager(bool resendOTP) async {
    APIDialog.showAlertDialog(context, "Sending OTP...");
    List<Map<String, dynamic>> parameterList = [];
    String level1ID = "";
    for (int i = 0; i < level4UserList.length; i++) {
      if (level4UserList[i]["name"] == selectedlevel1.toString()) {
        level1ID = level4UserList[i]["id"].toString();
        break;
      }
    }
    if (widget.isEdit) {
      for (int i = 0; i < questionList.length; i++) {
        print("LOOP COUNT");
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
        parameterList.add(parameterListChild);
      }
    } else {
      for (int i = 0; i < questionList.length; i++) {
        print("LOOP COUNT");

        Map<String, dynamic> parameterListChild = Map();

        parameterListChild.addAll({
          (questionList[i]["id"]).toString(): {
            "subs": {
              for (int r = 0;
                  r < questionList[i]["qm_sheet_sub_parameter"].length;
                  r++)
                (questionList[i]["qm_sheet_sub_parameter"][r]["id"]).toString():
                    {
                  "option": dropdownSelectionList[i][r],
                  "remark": controllerList[i][r].text
                }
            }
          },
        });

        parameterList.add(parameterListChild);
      }
    }

    String auditCycleID = "";

    for (int i = 0; i < auditCycleList.length; i++) {
      if (selectedAuditCycle == auditCycleList[i]["name"]) {
        auditCycleID = auditCycleList[i]["id"].toString();
        break;
      }
    }

    var requestModel = {
      "agency_email": selectedEmail,
      "user_id": AppModel.userID,
      "agency_id": agencySearchController.text.toString().length == 0
          ? agencyList[selectedAgencyIndex]["id"].toString()
          : filteredAgencyList[selectedAgencyIndex]["id"].toString(),
      "parameters": parameterList,
      "product_id": selectedProductID,
      "audit_cycle": auditCycleID,
      "collection_manager_id": level1ID,
      "overall_score": scoredList.reduce((a, b) => a + b).toString(),
    };

    log(json.encode(requestModel));

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(
        'collection_manager/send-otp', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    print(responseJSON);

    if (responseJSON['message'].toString() == "OTP and PDF sent successfully") {
      Toast.show(responseJSON['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      startTimer2();

      if (!resendOTP) {
        textEditingController2.text = "";
        otpVerifyDialogManager(context);
      }
    }

    setState(() {});
  }

  void otpVerifyDialogManager(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStateDialog) {
            setStateGlobalManagerDialog = setStateDialog;
            return AlertDialog(
                insetPadding: const EdgeInsets.all(10),
                scrollable: true,
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                //this right here
                content: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        key: _formKeyGuestOTP,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFF3F3F3),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text('Collection Manager OTP',
                                        style: TextStyle(
                                            fontSize: 15.5,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black)),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(Icons.close_rounded,
                                          color: Colors.black)),
                                  const SizedBox(width: 10)
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            const SizedBox(height: 20),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              height: 45,
                              child: Center(
                                  child: PinCodeTextField(
                                length: 6,
                                autoDisposeControllers: false,
                                keyboardType: TextInputType.number,
                                obscureText: false,
                                animationType: AnimationType.fade,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderWidth: 1,
                                  borderRadius: BorderRadius.circular(5),
                                  fieldHeight: 45,
                                  selectedColor: AppTheme.themeColor,
                                  selectedFillColor: Colors.white,
                                  fieldWidth: 40,
                                  activeFillColor: Colors.white,
                                  activeColor: Colors.green,
                                  inactiveFillColor: AppTheme.otpColor,
                                  inactiveColor: AppTheme.otpColor,
                                  disabledColor: AppTheme.otpColor,
                                  errorBorderColor: Colors.red,
                                ),
                                animationDuration: Duration(milliseconds: 300),
                                backgroundColor: Colors.white,
                                enableActiveFill: true,
                                controller: textEditingController2,
                                enablePinAutofill: false,
                                onCompleted: (v) {
                                  print("Completed");
                                  print(v);
                                  userEnteredOTP2 = v;
                                },
                                onChanged: (value) {
                                  print(value);
                                  setState(() {
                                    userEnteredOTP2 = value;
                                  });
                                },
                                appContext: context,
                              )),
                            ),
                            const SizedBox(height: 25),
                            InkWell(
                              onTap: () {
                                if (userEnteredOTP2.length != 6) {
                                  Toast.show("Please enter a Valid OTP",
                                      duration: Toast.lengthLong,
                                      gravity: Toast.bottom,
                                      backgroundColor: Colors.blue);
                                } else {
                                  verifyOTPManager();
                                }
                              },
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: AppTheme.themeColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  height: 50,
                                  child: const Center(
                                    child: Text('Submit',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                  )),
                            ),
                            SizedBox(height: 12),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                    children: <TextSpan>[
                                      const TextSpan(text: 'Resend OTP in '),
                                      TextSpan(
                                        text: _start2 < 10
                                            ? '00:0' + _start2.toString()
                                            : '00:' + _start2.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                      const TextSpan(text: ' seconds '),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Didn\'t receive the OTP ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A1A1A),
                                    )),
                                _start2 == 0
                                    ? GestureDetector(
                                        onTap: () {
                                          sendOTPToCollectionManager(true);
                                        },
                                        child: Text('Resend',
                                            style: TextStyle(
                                              fontSize: 15,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  AppTheme.themeColor,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.themeColor,
                                            )),
                                      )
                                    : Text('Resend',
                                        style: TextStyle(
                                          fontSize: 15,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        )),
                              ],
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ));
          });
        });
  }

  void startTimer2() {
    _start2 = 30;
    const oneSec = const Duration(seconds: 1);
    _timer2 = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start2 == 0) {
          setStateGlobalManagerDialog!(() {
            _timer2!.cancel();
          });
        } else {
          setStateGlobalManagerDialog!(() {
            _start2--;
          });
        }
      },
    );
  }

  verifyOTPManager() async {
    APIDialog.showAlertDialog(context, "Verifying OTP...");
    String level1ID = "";

    for (int i = 0; i < level4UserList.length; i++) {
      if (level4UserList[i]["name"] == selectedlevel1.toString()) {
        level1ID = level4UserList[i]["id"].toString();
        break;
      }
    }

    var requestModel = {
      "otp": userEnteredOTP2,
      "collection_manager_id": level1ID
    };

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(
        'collection_manager/verify-otp', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    print(responseJSON);

    if (responseJSON['status'].toString() == "valid") {
      Navigator.pop(context);
      Toast.show("OTP Verified successfully!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      submitAudit();
      //prepareData("submit");
      // AuditSubmit API
    } else if (responseJSON["status"] == "invalid") {
      Toast.show("Invalid OTP!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    setState(() {});
  }
  submitAudit() async {

    APIDialog.showAlertDialog(context, "Submitting Audit...");
    //subparameter
    var requestModel = {
      "audit_id":AuditIdReal,
    };
    log(json.encode(requestModel));
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('submitAudit', requestModel, context);
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
        uploadImage("submit", responseJSON["audit_id"].toString());
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

  prepareData(String methodType) async {
    if (level4IDs.isNotEmpty) {
      level4IDs.clear();
    }
    if (level5IDs.isNotEmpty) {
      level5IDs.clear();
    }
    APIDialog.showAlertDialog(context,
        methodType == "save" ? "Saving Audit..." : "Submitting Audit...");

    print(selectedLevel4Drop.toString());
    print(selectedLevel5Drop.toString());
    print(level4IDs.toString());
    print(level5IDs.toString());
    log(level4UserList.toString());

    print(selectedLevel4Drop.length.toString() + "COUNNNN");
    // print(selectedLevel.toString());
    for (int i = 0; i < selectedLevel4Drop.length; i++) {
      bool flag = false;
      print("LOOP DATA44");
      if (selectedLevel4Drop[i] != null && selectedLevel4Drop[i] != "null") {
        for (int j = 0; j < level4UserList.length; j++) {
          print("LOOP DATA " + j.toString());

          print(selectedLevel4Drop[i]);
          print(level4UserList[j]["name"]);

          if (selectedLevel4Drop[i] != null) {
            if (selectedLevel4Drop[i] == level4UserList[j]["name"]) {
              flag = true;
              print("LOOP DATA 22");
              level4IDs.add(level4UserList[j]["id"].toString());
              break;
            }
          }
        }
      }
    }
    for (int i = 0; i < selectedLevel5Drop.length; i++) {
      if (selectedLevel5Drop[i] != null) {
        for (int j = 0; j < level5Users.length; j++) {
          if (selectedLevel5Drop[i] != null) {
            if (selectedLevel5Drop[i] == level5Users[j]["name"]) {
              level5IDs.add(level5Users[j]["id"].toString());
              break;
            }
          }
        }
      }
    }

    String auditCycleID = "";

    for (int i = 0; i < auditCycleList.length; i++) {
      if (selectedAuditCycle == auditCycleList[i]["name"]) {
        auditCycleID = auditCycleList[i]["id"].toString();
        break;
      }
    }

    String level1ID = "";
    int level1Index = 0;
    int level2Index = 0;
    int level3Index = 0;
    for (int i = 0; i < levelByUserList.length; i++) {
      if (selectedlevel1 == levelByUserList[i]) {
        level1Index = i;
      }

      if (selectedlevel2 == levelByUserList[i]) {
        level2Index = i;
      }

      if (selectedlevel3 == levelByUserList[i]) {
        level3Index = i;
      }
    }
    for (int i = 0; i < level4UserList.length; i++) {
      if (level4UserList[i]["name"] == selectedlevel1.toString()) {
        level1ID = level4UserList[i]["id"].toString();
        break;
      }
    }

    String productID = "";

    for (int i = 0; i < productList.length; i++) {
      if (selectedProduct == productList[i]["name"]) {
        productID = productList[i]["id"].toString();
        break;
      }
    }

    List<dynamic> parameterList = [];

    //subparameter

    if (widget.isEdit) {
      for (int i = 0; i < questionList.length; i++) {
        List<dynamic> subParams = [];
        parameterList.add({
          "id": questionList[i]["id"].toString(),
          "score": "0",
          "score_with_fatal": "0",
          "score_without_fatal": "0",
          "temp_total_weightage": "0",
          "parameter_weight": "0",
          "subs": subParams
        });

        for (int j = 0; j < questionList[i]["subparameter"].length; j++) {
          subParams.add({
            "id": questionList[i]["subparameter"][j]["id"].toString(),
            "remark": controllerList[i][j].text,
            "orignal_weight": weightList[i][j],
            "is_percentage": "0",
            "selected_per": "",
            "option": dropdownSelectionList[i][j],
            "temp_weight": weightList[i][j],
            "score": weightList[i][j]
          });
        }
      }
    } else {
      for (int i = 0; i < questionList.length; i++) {
        List<dynamic> subParams = [];
        parameterList.add({
          "id": questionList[i]["id"].toString(),
          "score": "0",
          "score_with_fatal": "0",
          "score_without_fatal": "0",
          "temp_total_weightage": "0",
          "parameter_weight": "0",
          "subs": subParams
        });
        for (int j = 0;
            j < questionList[i]["qm_sheet_sub_parameter"].length;
            j++) {
          subParams.add({
            "id": questionList[i]["qm_sheet_sub_parameter"][j]["id"].toString(),
            "remark": controllerList[i][j].text,
            "orignal_weight": weightList[i][j],
            "is_percentage": "0",
            "selected_per": "",
            "option": dropdownSelectionList[i][j],
            "temp_weight": weightList[i][j],
            "score": weightList[i][j]
          });
        }
      }
    }

    List<Map<String, dynamic>> checkListData = [];

    if (widget.isEdit) {
      for (int i = 0; i < questionList.length; i++) {
        print("LOOP COUNT");

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
      }
    } else {
      for (int i = 0; i < questionList.length; i++) {
        print("LOOP COUNT");

        Map<String, dynamic> parameterListChild = Map();

        parameterListChild.addAll({
          (questionList[i]["id"]).toString(): {
            "subs": {
              for (int r = 0;
                  r < questionList[i]["qm_sheet_sub_parameter"].length;
                  r++)
                (questionList[i]["qm_sheet_sub_parameter"][r]["id"]).toString():
                    {
                  "option": dropdownSelectionList[i][r],
                  "remark": controllerList[i][r].text
                }
            }
          },
        });

        checkListData.add(parameterListChild);
      }
    }

    var requestModel = {
      "submission_data": {
        "token": AppModel.token,
        "user_id": AppModel.userID,
        "audit_id": AuditIdReal,
        "present_auditor": presentAuditorController.text,
        "qm_sheet_id": widget.sheetID,
        "audit_date_by_aud": selectedDate,
        "agency_phone": selectedPhone.toString(),
        "agency_email": selectedEmail.toString(),
        "audit_agency_id": auditAgencyID,
        "audit_cycle_id": auditCycleID,
        "geotag": latLongController.text.toString(),
        "overall_score": scoredList.reduce((a, b) => a + b).toString(),
        "agency_id": agencySearchController.text.toString().length == 0
            ? agencyList[selectedAgencyIndex]["id"].toString()
            : filteredAgencyList[selectedAgencyIndex]["id"].toString(),
        "sheet_type": "agency",
        "product_id": selectedProductID,
        "status": methodType,
        "artifactIds": "{}",
        "temp_audit_id": 1456,
        "agency_manager": agencyManagerNameController.text,
        "agency_address": agencyAddressController.text,
        "agency_city": cityNameController.text,
        "agency_location": locationNameController.text,
        "agency_name": agencyNameController.text,
        "branch_name": branchNameController.text,
        "audit_cycle_name": selectedAuditCycle.toString(),
        "collection_manager_id": level1ID,
        "lavel_4": level4IDs,
        "lavel_5": level5IDs,
        "grade": finalGrade,
        "with_fatal_score_per":
            "${scoreInPercentage.reduce((a, b) => a + b).toStringAsFixed(2)}%",
        "sub_product_ids": selectedSubProductIDsAsString
            .toString()
            .substring(1, selectedSubProductIDsAsString.toString().length - 1)
      },
      "parameters": parameterList,
      "checksheet_data": checkListData,
    };
    var requestModelEdit = {
      "submission_data": {
        "token": AppModel.token,
        "user_id": AppModel.userID,
        "present_auditor": presentAuditorController.text,
        "collection_manager": selectedlevel1.toString(),
        "audit_id": AuditIdReal.isNotEmpty ? AuditIdReal : widget.auditID,
        "agency_phone": selectedPhone.toString(),
        "agency_email": selectedEmail.toString(),
        "qm_sheet_id": widget.sheetID,
        "audit_date_by_aud": selectedDate,
        "audit_cycle_id": auditCycleID,
        "geotag": latLongController.text.toString(),
        "overall_score": scoredList.reduce((a, b) => a + b).toString(),
        "agency_id": agencySearchController.text.toString().length == 0
            ? agencyList[selectedAgencyIndex]["id"].toString()
            : filteredAgencyList[selectedAgencyIndex]["id"].toString(),
        "sheet_type": "agency",
        "product_id": selectedProductID,
        "status": methodType,
        "artifactIds": "{}",
        "temp_audit_id": 1456,
        "agency_manager": agencyManagerNameController.text,
        "agency_address": agencyAddressController.text,
        "agency_city": cityNameController.text,
        "agency_location": locationNameController.text,
        "agency_name": agencyNameController.text,
        "branch_name": branchNameController.text,
        "audit_cycle_name": selectedAuditCycle.toString(),
        "collection_manager_id": level1ID,
        "audit_agency_id": widget.auditAgencyID,
        "lavel_4": level4IDs,
        "lavel_5": level5IDs,
        "grade": finalGrade, // grade need to store
        "with_fatal_score_per":
            "${scoreInPercentage.reduce((a, b) => a + b).toStringAsFixed(2)}%",
        "sub_product_ids": selectedSubProductIDsAsString
            .toString()
            .substring(1, selectedSubProductIDsAsString.toString().length - 1)
      },
      "parameters": parameterList,
      "checksheet_data": checkListData,
    };

    log(json.encode(requestModel));
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(
        'storeAudit', widget.isEdit ? requestModelEdit : requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    if (responseJSON['status'].toString() == "1") {
      if (AppModel.rebuttalData.length != 0 && !widget.isEdit) {
        Toast.show(
            methodType == "save"
                ? "Audit Saved successfully!"
                : "Audit Submitted successfully!",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.green);

        uploadImage(methodType, responseJSON["audit_id"].toString());
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

  uploadImage(String methodType, String auditID) async {
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
      print(AppConstant.appBaseURL + "storeArtifact");
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
        /*Toast.show(response.data['message'].toString(),
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);*/
      }
    }
  }

  _logOut(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Toast.show('Your session has expired, Please login to continue!',
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.blue);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false);
  }

  checkValidationsForQuestionWise(bool isLast) {
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
      for (int j = 0;
          j < questionList[i]["qm_sheet_sub_parameter"].length;
          j++) {
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
    }

    if (flag) {
      /*if(isLast){
        showResultLayoutFunction();
      }else{
        questionSaveNext();
      }*/
      prepareDataForSave(isLast);
    }
  }

  prepareDataForSave(bool isLast) async {
    APIDialog.showAlertDialog(context, "Please wait.Saving ...");
    List<dynamic> parameterList = [];
    if (widget.isEdit) {
      int i = questionCurrentPosition;
      for (int j = 0; j < questionList[i]["subparameter"].length; j++) {
          String score="";
          String slectOption="";
          if(dropdownSelectionList[i][j]==naTitle){
              score= naTitle;
              slectOption= naTitle;
          }else{
            score= weightList[i][j];
            slectOption=weightList[i][j];
          }

        parameterList.add({
          "parameter_id": questionList[i]["id"].toString(),
          "sub_parameter_id":
              questionList[i]["subparameter"][j]["id"].toString(),

          "option_selected": dropdownSelectionList[i][j],
          "selected_option": score,
          "score": slectOption,
          "remark": controllerList[i][j].text,
          "is_critical": "0",
          "is_percentage": "0",
          "selected_per": "",
          "is_alert": ""
        });
      }
    } else {
      int i = questionCurrentPosition;
      List<dynamic> subParams = [];
      for (int j = 0;
          j < questionList[i]["qm_sheet_sub_parameter"].length;
          j++) {

        String score="";
        String slectOption="";
        if(dropdownSelectionList[i][j]==naTitle){
          score= naTitle;
          slectOption= naTitle;
        }else{
          score= weightList[i][j];
          slectOption=weightList[i][j];
        }
        parameterList.add({
          "parameter_id": questionList[i]["id"].toString(),
          "sub_parameter_id": questionList[i]["qm_sheet_sub_parameter"][j]["id"].toString(),
          "option_selected": dropdownSelectionList[i][j],
         /* "selected_option": weightList[i][j],
          "score": weightList[i][j],*/
          "selected_option": score,
          "score": slectOption,
          "remark": controllerList[i][j].text,
          "is_critical": "0",
          "is_percentage": "0",
          "selected_per": "",
          "is_alert": ""
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

    print("Request Model $requestModel");
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(
        'saveQuestionWiseData', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['status'].toString() == "1") {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      if(previousIssueSelectedList.isNotEmpty){
        savePreviousSelectedIssues(isLast);
      }else{
        if (isLast) {
         // showResultLayoutFunction();
          getResultFromServer();
        } else {
          questionSaveNext();
        }
      }

    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  savePreviousSelectedIssues(bool isLast) async {
    APIDialog.showAlertDialog(context, "Please wait.Saving ...");
    List<dynamic> issues = [];
    for(int i=0;i<previousIssueSelectedList.length;i++){
      issues.add({
        "parameter_id":previousIssueSelectedList[i].paramId,
        "sub_parameter_id":previousIssueSelectedList[i].subParamId,
        "question_id":previousIssueSelectedList[i].selectedIssuesId,
        "remark":previousIssueSelectedList[i].selectedAdditionalRemark,
      });

    }
    var requestModel = {
      "audit_id": AuditIdReal,
      "qm_sheet_id": widget.sheetID,
      "issues": issues,
    };

    print("Request Model $requestModel");
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(
        'saveUnsatIssueResponse', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['status'].toString() == "1") {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      previousIssueSelectedList.clear();
      if (isLast) {
        getResultFromServer();
        //showResultLayoutFunction();
      } else {
        questionSaveNext();
      }
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
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
        'get_audit_parameter_result', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['status'].toString() == "1") {

      List<dynamic> data=responseJSON['data'];
      finalScorable=responseJSON['final_score']['final_scorable']?.toString()??"0";
      finalScore=responseJSON['final_score']['final_scored']?.toString()??"0";
      finalPercentage=responseJSON['final_score']['final_score_per']?.toString()??"0";
      finalGradeToShow=responseJSON['final_score']['grade']?.toString()??"N/A";
      resultList.clear();
      for(int i=0;i<data.length;i++){
        String paramName=data[i]['parameter_name']?.toString()??"N/A";
        String scorable=data[i]['scorable']?.toString()??"0";
        String score=data[i]['score']?.toString()??"0";
        String percentage=data[i]['score_per']?.toString()??"0";
        resultList.add(resultSeries(paramName, scorable, score, percentage ));
      }


      showResultLayoutFunction();

    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  checkForUnSatSelection(String paramId, String subParamid, String observation) async {
    APIDialog.showAlertDialog(context, "Please wait.Checking ...");
    var requestModel = {
      "agency_id": selectedAgencyId,
      "parameter_id": paramId,
      "sub_parameter_id": subParamid,
      "observation": observation,
    };
    print("Request Model $requestModel");
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(
        'check-unsat-observation', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['status'].toString() == "1") {
      final unSatQuestions = responseJSON['questions'] as List<dynamic>;
      final artifact =
          responseJSON['repeat_issue']?['artifact']?.toString() ?? "";
      final remark = responseJSON['repeat_issue']?['remark']?.toString() ?? "";
      final position = prevRemarkList.indexWhere(
        (item) => item.paramId == paramId && item.subParamId == subParamid,
      );
      final remarkQuestList = unSatQuestions.map((q) {
        return previousRemarkQuestions(
          q['id']?.toString() ?? "",
          q['question_text']?.toString() ?? "",
          false,
        );
      }).toList();

      if (position != -1) {
        prevRemarkList[position]
          ..artifact = artifact
          ..remark = remark
          ..observation = observation
          ..prevRemarkQuestList = remarkQuestList;
      } else {
        prevRemarkList.add(
          previousRemark(paramId, subParamid, observation, remark, artifact,
              remarkQuestList),
        );
      }

      setState(() {});
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  int findAlreadySelectedIssuePosition(String paramId, String subParamId) {
    final position = previousIssueSelectedList.indexWhere(
          (item) => item.paramId == paramId && item.subParamId == subParamId,
    );
    return position;
  }
  int findUnsatDependancies(String paramId, String subParamId) {
    final position = prevRemarkList.indexWhere(
      (item) => item.paramId == paramId && item.subParamId == subParamId,
    );
    return position;
  }
  void removeTheItemWhenSatisSelected(String paramId, String subParamId) {
    final position = prevRemarkList.indexWhere(
      (item) => item.paramId == paramId && item.subParamId == subParamId,
    );
    if (position != -1) {
      prevRemarkList.removeAt(position);
      setState(() {});
    }

    final positionPrevious=previousIssueSelectedList.indexWhere((item)=>item.paramId == paramId && item.subParamId ==subParamId,);
    if(positionPrevious!=-1){
      previousIssueSelectedList.removeAt(positionPrevious);
      setState(() {

      });
    }

  }
  void setSelectedPreviousIssue(String paramId,String subParamId,int previousPosition,String selectedId,String addRemark){
    if(previousPosition!=-1){
      previousIssueSelectedList[previousPosition].selectedIssuesId=selectedId;
      previousIssueSelectedList[previousPosition].selectedAdditionalRemark=addRemark;
    }else{
      previousIssueSelectedList.add(selectedPreviousOptions(paramId, subParamId, selectedId, addRemark));
    }
    /*for(int i=0;i<previousIssueSelectedList.length;i++){
      print("Param Id ${previousIssueSelectedList[i].paramId}");
      print("SubParam Id ${previousIssueSelectedList[i].paramId}");
      print("Selected Id ${previousIssueSelectedList[i].selectedIssuesId}");
      print("Selected Remark ${previousIssueSelectedList[i].selectedAdditionalRemark}");
    }*/

    setState(() {

    });
  }
  void selectIssueBottomSheem(BuildContext context, List<previousRemarkQuestions> opt,String paramId,String subParamId) {
    final List<previousRemarkQuestions> options = opt;
    final Set<String> selectedIds = {};
    final TextEditingController remarkController = TextEditingController();
    final int previousSelectedIssuePosition=findAlreadySelectedIssuePosition(paramId, subParamId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, bottomSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Text("Please select applicable issues",
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

                      const SizedBox(height: 10),

                      // Handle bar
                      Center(
                        child: Container(
                          height: 6,
                          width: 62,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Dynamic Checkbox List from model
                      ...options.map((option) {
                        return CheckboxListTile(
                          title: Text(option.remarkQuestText ?? ""),
                          value: selectedIds.contains(option.remarkQuestId),
                          onChanged: (checked) {
                            bottomSheetState(() {
                              if (checked == true) {
                                selectedIds.add(option.remarkQuestId);
                              } else {
                                selectedIds.remove(option.remarkQuestId);
                              }
                            });
                          },
                        );
                      }).toList(),

                      const SizedBox(height: 10),

                      // Remark Field
                      TextField(
                        controller: remarkController,
                        decoration: const InputDecoration(
                          labelText: "Enter additional remark",
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 20),
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.themeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            String selIssueId=selectedIds.join(",");
                            String addRemark=remarkController.text.toString();
                            Navigator.pop(context);
                            setSelectedPreviousIssue(paramId, subParamId, previousSelectedIssuePosition, selIssueId, addRemark);
                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
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
