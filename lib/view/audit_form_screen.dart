import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:qaudit_tata_flutter/network/api_dialog.dart';
import 'package:qaudit_tata_flutter/network/api_helper.dart';
import 'package:qaudit_tata_flutter/network/loader.dart';
import 'package:qaudit_tata_flutter/utils/app_modal.dart';
import 'package:qaudit_tata_flutter/utils/app_theme.dart';
import 'package:qaudit_tata_flutter/view/audit_form_screen.dart';
import 'package:qaudit_tata_flutter/view/upload_artifact_screen.dart';
import 'package:qaudit_tata_flutter/view/view_artifact_screen.dart';
import 'package:qaudit_tata_flutter/widgets/dropdown_widget.dart';
import 'package:qaudit_tata_flutter/widgets/textfield_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../network/constants.dart';
import 'home_screen.dart';
import 'login_screen.dart';
const _list = [
  'Pakistani',
  'Indian',
  'Middle Eastern',
  'Western',
  'Chinese',
  'Italian',
];
class AuditFormScreen extends StatefulWidget {
  final String sheetID;
  final String sheetName;
  Map<String, dynamic> lobData;
  bool isEdit;
  String auditID;
  String auditAgencyID;

  AuditFormScreen(this.sheetID, this.lobData, this.sheetName, this.isEdit,
      this.auditID, this.auditAgencyID);

  AuditFormState createState() => AuditFormState();
}

class AuditFormState extends State<AuditFormScreen> {
  bool isLoading = false;
  String finalGrade = '';

  int totalFiles=0;
  int uploadedFiles=0;
  String? selectedItem = _list[2];
  int levelWiseCount = 1;
  bool collectionManagerSelected = false;
  final _formKeyGuestOTP = GlobalKey<FormState>();
  Timer? _timer;
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
  List<String> selectedLevel4Drop = [];
  List<String> selectedLevel5Drop = [];
  var presentAuditorController=TextEditingController();
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

  List<String> answerList = ["Satisfactory", "Unsatisfactory"];

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
                        : Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8)),
                          border: Border.all(
                              color: Colors.black, width: 0.7)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 46,
                            color: AppTheme.themeColor,
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
                                : agencySearchController.text
                                .toString()
                                .length ==
                                0
                                ? agencyList[selectedAgencyIndex]["agency_id"]
                                .toString() + " " +
                                agencyList[selectedAgencyIndex]
                                ["name"]
                                : filteredAgencyList[selectedAgencyIndex]["agency_id"]
                                .toString() + " " + filteredAgencyList[
                            selectedAgencyIndex]
                            ["name"]
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
                                  color:
                                  Colors.black.withOpacity(0.7),
                                )),
                          ),
                          SizedBox(height: 2),

                          widget.isEdit ?

                          Container(
                            // width: 80,
                            height: 40,
                            margin:
                            EdgeInsets.symmetric(horizontal: 10),
                            padding: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                                color: Colors.grey
                                    .withOpacity(0.1),
                                borderRadius:
                                BorderRadius.circular(5),
                                border: Border.all(
                                    color: Colors.black, width: 0.5)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                enableFeedback: false,
                                menuItemStyleData:
                                const MenuItemStyleData(
                                  padding: EdgeInsets.only(left: 12),
                                ),
                                iconStyleData: IconStyleData(
                                  icon: Icon(
                                      Icons
                                          .keyboard_arrow_down_outlined,
                                      color: Colors.black),
                                ),
                                isExpanded: true,
                                hint: Text('Select audit cycle',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black
                                          .withOpacity(0.7),
                                    )),
                                items: auditCycleListAsString
                                    .map((item) =>
                                    DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black
                                        ),
                                      ),
                                    ))
                                    .toList(),
                                value: selectedAuditCycle,
                                onChanged: null,
                              ),
                            ),
                          ) :


                          Container(
                            // width: 80,
                            height: 40,
                            margin:
                            EdgeInsets.symmetric(horizontal: 10),
                            padding: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(5),
                                border: Border.all(
                                    color: Colors.black, width: 0.5)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                menuItemStyleData:
                                const MenuItemStyleData(
                                  padding: EdgeInsets.only(left: 12),
                                ),
                                iconStyleData: IconStyleData(
                                  icon: Icon(
                                      Icons
                                          .keyboard_arrow_down_outlined,
                                      color: Colors.black),
                                ),
                                isExpanded: true,
                                hint: Text('Select audit cycle',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black
                                          .withOpacity(0.7),
                                    )),
                                items: auditCycleListAsString
                                    .map((item) =>
                                    DropdownMenuItem<String>(
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
                                    selectedAuditCycle =
                                    value as String;
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
                                  color:
                                  Colors.black.withOpacity(0.7),
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
                                  DateFormat('yyyy-MM-dd')
                                      .format(pickedDate);
                                  selectedDate =
                                      formattedDate.toString();
                                  setState(() {});
                                }
                              }
                            },
                            child: Container(
                              height: 41,
                              width:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10),
                              decoration: BoxDecoration(
                                  color: widget.isEdit ? Colors.grey
                                      .withOpacity(0.1) : Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(5),
                                  border: Border.all(
                                      color: Colors.black,
                                      width: 0.5)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 7),
                                      child: Text(
                                          selectedDate == null
                                              ? "Select date"
                                              : selectedDate
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight:
                                            FontWeight.w500,
                                            color: selectedDate ==
                                                null
                                                ? Colors.black
                                                .withOpacity(0.7)
                                                : Colors.black,
                                          )),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10),
                                      child: Icon(
                                          Icons.calendar_month,
                                          color:
                                          AppTheme.themeColor)),
                                ],
                              ),
                            ),
                          ),


                          SizedBox(height: 12),
                          widget.isEdit ?


                          TextFieldWidgetNew(
                              "Present Auditor*",
                              enabled: false,
                              "-",
                              presentAuditorController) :
                          TextFieldWidgetNew(
                              "Present Auditor*",
                              "Enter here",
                              presentAuditorController),


                          selectedProduct ==
                              null /*&& !widget.isEdit*/
                              ? Container()
                              : Container(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 12),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(
                                      left: 12),
                                  child: Text("Product*",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight:
                                        FontWeight.w500,
                                        color: Colors.black
                                            .withOpacity(0.7),
                                      )),
                                ),
                                SizedBox(height: 2),
                                Container(
                                  // width: 80,
                                  height: 40,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10),
                                  padding:
                                  EdgeInsets.only(right: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.grey
                                          .withOpacity(0.1),
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
                                              style: const TextStyle(
                                                  fontSize:
                                                  14,
                                                  color: Colors
                                                      .black),
                                            ),
                                          ))
                                          .toList(),
                                      value: selectedProduct,
                                      onChanged: null,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),

                                selectedSubProductAsString
                                    .length ==
                                    0
                                    ? Container()
                                    : DropDownWidget2(
                                        () {},
                                    "Sub Products",
                                    selectedSubProductAsString
                                        .length ==
                                        0
                                        ? "Select Sub Products"
                                        : selectedSubProductAsString
                                        .toString()
                                        .substring(
                                        1,
                                        selectedSubProductAsString
                                            .toString()
                                            .length -
                                            1),
                                    selectedSubProductAsString
                                        .length ==
                                        0
                                        ? Colors.black
                                        .withOpacity(
                                        0.7)
                                        : Colors.black),
                                selectedSubProductAsString
                                    .length ==
                                    0
                                    ? Container()
                                    : SizedBox(height: 12),
                                TextFieldWidgetNew(
                                    "Agency Name",
                                    "",
                                    agencyNameController,
                                    enabled: false),
                                SizedBox(height: 12),

                                widget.isEdit ?


                                TextFieldWidgetNew(
                                    "Agency Manager",
                                    enabled: false,
                                    "-",
                                    agencyManagerNameController) :
                                TextFieldWidgetNew(
                                    "Agency Manager",
                                    "Enter Manager",
                                    agencyManagerNameController),
                                SizedBox(height: 12),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(
                                      left: 12),
                                  child: Text(
                                      "Agency Mobile Number",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight:
                                        FontWeight.w500,
                                        color: Colors.black
                                            .withOpacity(0.7),
                                      )),
                                ),
                                SizedBox(height: 2),
                                Container(
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
                                          'Select Agency Mobile No.',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight:
                                            FontWeight.w500,
                                            color: Colors.black
                                                .withOpacity(
                                                0.7),
                                          )),
                                      items: phoneListAsString
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
                                      value: selectedPhone,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedPhone =
                                          value as String;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(
                                      left: 12),
                                  child: Text("Agency Email",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight:
                                        FontWeight.w500,
                                        color: Colors.black
                                            .withOpacity(0.7),
                                      )),
                                ),
                                SizedBox(height: 2),
                                Container(
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
                                          'Select Agency Email',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight:
                                            FontWeight.w500,
                                            color: Colors.black
                                                .withOpacity(
                                                0.7),
                                          )),
                                      items: emailListAsString
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
                                      value: selectedEmail,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedEmail =
                                          value as String;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                                TextFieldWidgetMultiLine(
                                    "Agency Address",
                                    "-",
                                    agencyAddressController,
                                    enabled: false),
                                SizedBox(height: 12),
                                TextFieldWidgetNew("City", "-",
                                    cityNameController,
                                    enabled: false),
                                SizedBox(height: 12),
                                TextFieldWidgetNew("Location",
                                    "-", locationNameController,
                                    enabled: false),
                                SizedBox(height: 12),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(
                                      left: 12),
                                  child: Text("Level 3",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight:
                                        FontWeight.w500,
                                        color: Colors.black
                                            .withOpacity(0.7),
                                      )),
                                ),
                                SizedBox(height: 2),
                            /*    Container(
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
                                          'Select Level 3',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight:
                                            FontWeight.w500,
                                            color: Colors.black
                                                .withOpacity(
                                                0.7),
                                          )),
                                      items: levelByUserList
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
                                      value: selectedlevel1,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedlevel1 =
                                          value as String;
                                        });
                                      },
                                    ),
                                  ),
                                ),*/

                                Row(
                                  children: [


                                    Expanded(child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: CustomDropdown<String>.search(
                                        hintText: 'Select Level 3',
                                        items: levelByUserList,

                                        decoration: CustomDropdownDecoration(
                                            closedBorder:  Border.all(
                                                color: Colors.black, width: 0.7),
                                            closedBorderRadius: BorderRadius.circular(5),

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



                                SizedBox(height: 12),

                                GestureDetector(
                                  onTap: () {
                                    if (!widget.isEdit) {
                                      print("Click Triggered");
                                      _getCurrentPosition();
                                    }


                                  },
                                  child: TextFieldWidgetNew(
                                      "Geo tag",
                                      "Tap here",
                                      latLongController,
                                      enabled: false),
                                ),







                                SizedBox(height: 16),
                                selectedLevel4Drop.length == 0
                                    ? Container()
                                    :

                                widget.isEdit ? Container() :
                                Row(
                                  children: [
                                    Spacer(),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedLevel4Drop.add(
                                                level4ListAsString[
                                                0]);
                                            selectedLevel5Drop.add(
                                                level5ListAsString[
                                                0]);
                                            levelWiseCount =
                                                levelWiseCount +
                                                    1;
                                          });
                                        },
                                        child:
                                        Image.asset(
                                          "assets/plus.png",
                                          width: 25,
                                          height: 25,
                                        )


                                    ),
                                    SizedBox(width: 10)
                                  ],
                                ),

                                selectedLevel4Drop.length == 0
                                    ? Container()
                                    : ListView.builder(
                                    itemCount:
                                    levelWiseCount,
                                    shrinkWrap: true,
                                    padding:
                                    EdgeInsets.zero,
                                    physics:
                                    const NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext
                                    context,
                                        int pos) {
                                      return Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          pos == 0
                                              ? Container()
                                              :
                                          widget.isEdit ? Container() :
                                          SizedBox(
                                              height:
                                              10),
                                          pos == 0
                                              ? Container()
                                              :
                                          widget.isEdit ? Container() :

                                          Row(
                                            children: [
                                              Spacer(),
                                              GestureDetector(
                                                  onTap:
                                                      () {
                                                    levelWiseCount =
                                                        levelWiseCount - 1;
                                                    selectedLevel4Drop.removeAt(
                                                        pos);
                                                    selectedLevel5Drop.removeAt(
                                                        pos);
                                                    setState(() {});
                                                  },
                                                  child: Image.asset(
                                                      "assets/delete.png",
                                                      width: 25,
                                                      height: 25)),
                                              SizedBox(
                                                  width:
                                                  10)
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets
                                                .only(
                                                left:
                                                12),
                                            child: Text(
                                                "Level 4",
                                                style:
                                                TextStyle(
                                                  fontSize:
                                                  12,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500,
                                                  color: Colors
                                                      .black
                                                      .withOpacity(
                                                      0.7),
                                                )),
                                          ),
                                          SizedBox(
                                              height: 2),
                                      /*    Container(
                                            // width: 80,
                                            // height: 40,
                                            margin: EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                10),
                                            padding: EdgeInsets
                                                .only(
                                                right:
                                                5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    5),
                                                border: Border.all(
                                                    color: Colors
                                                        .black,
                                                    width:
                                                    0.5)),
                                            child:
                                            DropdownButtonHideUnderline(
                                              child:
                                              DropdownButton2(
                                                menuItemStyleData:
                                                const MenuItemStyleData(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                      12),
                                                ),
                                                iconStyleData:
                                                IconStyleData(
                                                  icon: Icon(
                                                      Icons
                                                          .keyboard_arrow_down_outlined,
                                                      color:
                                                      Colors.black),
                                                ),
                                                isExpanded:
                                                true,
                                                hint: Text(
                                                    'Select Level 4',
                                                    style:
                                                    TextStyle(
                                                      fontSize:
                                                      12,
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      color: Colors
                                                          .black
                                                          .withOpacity(0.7),
                                                    )),
                                                items: level4ListAsString
                                                    .map((item) =>
                                                    DropdownMenuItem<String>(
                                                      value: item,
                                                      child: Text(
                                                        item,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ))
                                                    .toList(),
                                                value:
                                                selectedLevel4Drop[
                                                pos],
                                                onChanged:
                                                    (value) {
                                                  setState(
                                                          () {
                                                        selectedLevel4Drop[pos] =
                                                        value
                                                        as String;
                                                      });
                                                },
                                              ),
                                            ),
                                          ),*/


                                          Row(
                                            children: [


                                              Expanded(child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: CustomDropdown<String>.search(
                                                  hintText: 'Select Level 4',
                                                  items: level4ListAsString,

                                                  decoration: CustomDropdownDecoration(
                                                    closedBorder:  Border.all(
                                                        color: Colors.black, width: 0.7),
                                                    closedBorderRadius: BorderRadius.circular(5),

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
                                                  initialItem:selectedLevel4Drop[pos],
                                                  onChanged: (value) {
                                                    log('SearchDropdown onChanged value: $value');
                                                    setState(() {
                                                      selectedLevel4Drop[pos] = value.toString();
                                                    });
                                                  },
                                                ),
                                              ))



                                            ],
                                          ),



                                          SizedBox(
                                              height: 5),
                                          Padding(
                                            padding:
                                            const EdgeInsets
                                                .only(
                                                left:
                                                12),
                                            child: Text(
                                                "Level 5",
                                                style:
                                                TextStyle(
                                                  fontSize:
                                                  12,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500,
                                                  color: Colors
                                                      .black
                                                      .withOpacity(
                                                      0.7),
                                                )),
                                          ),
                                          SizedBox(
                                              height: 2),
                                      /*    Container(
                                            // width: 80,
                                            // height: 40,
                                            margin: EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                10),
                                            padding: EdgeInsets
                                                .only(
                                                right:
                                                5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    5),
                                                border: Border.all(
                                                    color: Colors
                                                        .black,
                                                    width:
                                                    0.5)),
                                            child:
                                            DropdownButtonHideUnderline(
                                              child:
                                              DropdownButton2(
                                                menuItemStyleData:
                                                const MenuItemStyleData(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                      12),
                                                ),
                                                iconStyleData:
                                                IconStyleData(
                                                  icon: Icon(
                                                      Icons
                                                          .keyboard_arrow_down_outlined,
                                                      color:
                                                      Colors.black),
                                                ),
                                                isExpanded:
                                                true,
                                                hint: Text(
                                                    'Select Level 5',
                                                    style:
                                                    TextStyle(
                                                      fontSize:
                                                      12,
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      color: Colors
                                                          .black
                                                          .withOpacity(0.7),
                                                    )),
                                                items: level5ListAsString
                                                    .map((item) =>
                                                    DropdownMenuItem<String>(
                                                      value: item,
                                                      child: Text(
                                                        item,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ))
                                                    .toList(),
                                                value:
                                                selectedLevel5Drop[
                                                pos],
                                                onChanged:
                                                    (value) {
                                                  setState(
                                                          () {
                                                        selectedLevel5Drop[pos] =
                                                        value
                                                        as String;
                                                      });
                                                },
                                              ),
                                            ),
                                          ),*/



                                          Row(
                                            children: [


                                              Expanded(child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: CustomDropdown<String>.search(
                                                  hintText: 'Select Level 5',
                                                  items: level5ListAsString,
                                                  decoration: CustomDropdownDecoration(
                                                    closedBorder:  Border.all(
                                                        color: Colors.black, width: 0.7),
                                                    closedBorderRadius: BorderRadius.circular(5),

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
                                                  initialItem:selectedLevel5Drop[pos],
                                                  onChanged: (value) {
                                                    log('SearchDropdown onChanged value: $value');
                                                    setState(() {
                                                      selectedLevel5Drop[pos] = value.toString();
                                                    });
                                                  },
                                                ),
                                              ))



                                            ],
                                          ),
                                          SizedBox(
                                              height: 12),
                                        ],
                                      );
                                    }),

                                 SizedBox(height: 5),








                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    !hasInternet ? Container() : SizedBox(height: 18),
                    !hasInternet
                        ? Container()
                        : Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8)),
                          border: Border.all(
                              color: Colors.black, width: 0.7)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          ListView.builder(
                              itemCount: questionList.length,
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder:
                                  (BuildContext context, int pos) {
                                return Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Card(
                                        elevation: 3,
                                        //  color: Colors.white,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              5),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            // color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(
                                                5),
                                          ),
                                          width:
                                          MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          padding:
                                          EdgeInsets.symmetric(
                                              vertical: 0,
                                              horizontal: 0),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Theme(
                                                data: Theme.of(context)
                                                    .copyWith(
                                                    listTileTheme: ListTileTheme
                                                        .of(
                                                        context)
                                                        .copyWith(
                                                        dense:
                                                        true,
                                                        minVerticalPadding:
                                                        10),
                                                    dividerColor: Colors
                                                        .transparent),
                                                child: ListTileTheme(
                                                    contentPadding:
                                                    EdgeInsets
                                                        .only(
                                                        right:
                                                        5),
                                                    child:
                                                    ExpansionTile(
                                                      initiallyExpanded:
                                                      false,
                                                      collapsedBackgroundColor:
                                                      Colors
                                                          .white,
                                                      backgroundColor:
                                                      Color(
                                                          0xFFF6F6F6),
                                                      title:
                                                      Container(
                                                        width: MediaQuery
                                                            .of(
                                                            context)
                                                            .size
                                                            .width,
                                                        //height: 43,
                                                        alignment:
                                                        Alignment
                                                            .centerLeft,
                                                        //color: Colors.white,

                                                        child:
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .only(
                                                              left:
                                                              5),
                                                          child: Text(
                                                              questionList[pos]
                                                              [
                                                              "parameter"],
                                                              style:
                                                              TextStyle(
                                                                fontSize:
                                                                15,
                                                                fontWeight:
                                                                FontWeight.w500,
                                                                color:
                                                                Color(
                                                                    0xFF21317D)
                                                                    .withOpacity(
                                                                    0.7),
                                                              )),
                                                        ),
                                                      ),
                                                      children: [
                                                        SizedBox(
                                                            height:
                                                            5),
                                                        widget.isEdit
                                                            ? ListView.builder(
                                                            itemCount: questionList[pos]["subparameter"]
                                                                .length,
                                                            shrinkWrap: true,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                horizontal: 5),
                                                            physics: NeverScrollableScrollPhysics(),
                                                            scrollDirection: Axis
                                                                .vertical,
                                                            itemBuilder: (
                                                                BuildContext context,
                                                                int index) {
                                                              /*  answerListFinal[pos]["subs"].add(
                                                              {

                                                                "id":questionList[pos]["qm_sheet_sub_parameter"][index]["id"].toString(),


                                                              }
                                                            );*/

                                                              return Column(
                                                                crossAxisAlignment: CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal: 4),
                                                                    child: Text(
                                                                        questionList[pos]["subparameter"][index]["sub_parameter"],
                                                                        style: TextStyle(
                                                                          fontSize: 12,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color: Colors
                                                                              .black,
                                                                        )),
                                                                  ),
                                                                  SizedBox(
                                                                      height: 5),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: Container(
                                                                          // width: 80,
                                                                          height: 40,
                                                                          margin: EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 4),
                                                                          padding: EdgeInsets
                                                                              .only(
                                                                              right: 5),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius
                                                                                  .circular(
                                                                                  10),
                                                                              border: Border
                                                                                  .all(
                                                                                  color: Colors
                                                                                      .black,
                                                                                  width: 0.5)),
                                                                          child: DropdownButtonHideUnderline(
                                                                            child: DropdownButton2(
                                                                              menuItemStyleData: const MenuItemStyleData(
                                                                                padding: EdgeInsets
                                                                                    .only(
                                                                                    left: 12),
                                                                              ),
                                                                              iconStyleData: IconStyleData(
                                                                                icon: Icon(
                                                                                    Icons
                                                                                        .keyboard_arrow_down_outlined,
                                                                                    color: Colors
                                                                                        .black),
                                                                              ),
                                                                              isExpanded: true,
                                                                              hint: Text(
                                                                                  'Choose Type',
                                                                                  style: TextStyle(
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight
                                                                                        .w500,
                                                                                    color: Colors
                                                                                        .black
                                                                                        .withOpacity(
                                                                                        0.7),
                                                                                  )),
                                                                              items: answerList
                                                                                  .map((
                                                                                  item) =>
                                                                                  DropdownMenuItem<
                                                                                      String>(
                                                                                    value: item,
                                                                                    child: Text(
                                                                                      item,
                                                                                      style: const TextStyle(
                                                                                        fontSize: 14,
                                                                                      ),
                                                                                    ),
                                                                                  ))
                                                                                  .toList(),
                                                                              value: dropdownSelectionList[pos][index],
                                                                              onChanged: (
                                                                                  value) {
                                                                                dropdownSelectionList[pos][index] =
                                                                                value as String;

                                                                                if (dropdownSelectionList[pos][index] ==
                                                                                    "Satisfactory") {
                                                                                  print(
                                                                                      "DDDD");
                                                                                  print(
                                                                                      pos
                                                                                          .toString());
                                                                                  print(
                                                                                      weightList[pos][index]);
                                                                                  print(
                                                                                      scoredList[pos]
                                                                                          .toString());

                                                                                  if (weightList[pos][index] ==
                                                                                      "") {
                                                                                    scorableList[pos] =
                                                                                        scorableList[pos] +
                                                                                            int
                                                                                                .parse(
                                                                                                questionList[pos]["subparameter"][index]["weight"]
                                                                                                    .toString());
                                                                                  }

                                                                                  if (weightList[pos][index] ==
                                                                                      "" ||
                                                                                      weightList[pos][index] ==
                                                                                          "0") {
                                                                                    scoredList[pos] =
                                                                                        scoredList[pos] +
                                                                                            int
                                                                                                .parse(
                                                                                                questionList[pos]["subparameter"][index]["weight"]
                                                                                                    .toString());
                                                                                  }

                                                                                  weightList[pos][index] =
                                                                                      questionList[pos]["subparameter"][index]["weight"]
                                                                                          .toString();

                                                                                  scoreInPercentage[pos] =
                                                                                      (scoredList[pos] *
                                                                                          100) /
                                                                                          scorableList[pos];
                                                                                } else {
                                                                                  print(
                                                                                      "NO ANSWER SELEC");

                                                                                  print(
                                                                                      weightList[pos][index]
                                                                                          .toString());

                                                                                  if (weightList[pos][index] ==
                                                                                      "") {
                                                                                    print(
                                                                                        "Item not exists");
                                                                                    scorableList[pos] =
                                                                                        scorableList[pos] +
                                                                                            int
                                                                                                .parse(
                                                                                                questionList[pos]["subparameter"][index]["weight"]
                                                                                                    .toString());

                                                                                    weightList[pos][index] =
                                                                                    "0";
                                                                                    scoredList[pos] =
                                                                                        scoredList[pos] +
                                                                                            0;
                                                                                    scoreInPercentage[pos] =
                                                                                        (scoredList[pos] *
                                                                                            100) /
                                                                                            scorableList[pos];
                                                                                  } else {
                                                                                    print(
                                                                                        "Item exists");

                                                                                    // scorableList[pos] = scorableList[pos] - int.parse(questionList[pos]["qm_sheet_sub_parameter"][index]["weight"].toString());

                                                                                    weightList[pos][index] =
                                                                                    "0";


                                                                                    print("Scored List "+scoredList[pos].toString());
                                                                                    print("Scored List22 "+questionList[pos]["subparameter"][index]["weight"]
                                                                                        .toString());


                                                                                    if(scoredList[pos]!=0)
                                                                                      {
                                                                                        scoredList[pos] =
                                                                                            scoredList[pos] -
                                                                                                int
                                                                                                    .parse(
                                                                                                    questionList[pos]["subparameter"][index]["weight"]
                                                                                                        .toString());
                                                                                      }

                                                                                    scoreInPercentage[pos] =
                                                                                        (scoredList[pos] *
                                                                                            100) /
                                                                                            scorableList[pos];
                                                                                  }
                                                                                }

                                                                                if (scorableList
                                                                                    .length ==
                                                                                    0) {
                                                                                  finalGrade =
                                                                                  "";
                                                                                } else
                                                                                if (scorableList
                                                                                    .reduce((
                                                                                    a,
                                                                                    b) =>
                                                                                a +
                                                                                    b) ==
                                                                                    0) {
                                                                                  finalGrade =
                                                                                  "";
                                                                                } else {
                                                                                  double finalCal = scoredList
                                                                                      .reduce((
                                                                                      a,
                                                                                      b) =>
                                                                                  a +
                                                                                      b) *
                                                                                      100 /
                                                                                      scorableList
                                                                                          .reduce((
                                                                                          a,
                                                                                          b) =>
                                                                                      a +
                                                                                          b);

                                                                                  if (finalCal >=
                                                                                      90) {
                                                                                    finalGrade =
                                                                                    "A";
                                                                                  } else
                                                                                  if (finalCal >=
                                                                                      75) {
                                                                                    finalGrade =
                                                                                    "B";
                                                                                  } else
                                                                                  if (finalCal >=
                                                                                      61) {
                                                                                    finalGrade =
                                                                                    "C";
                                                                                  } else {
                                                                                    finalGrade =
                                                                                    "D";
                                                                                  }
                                                                                }

                                                                                setState(() {});

                                                                                /*                                   if (dropdownSelectionList[pos][index] ==
                                                                                  "Yes") {
                                                                                weightList[pos][index] =
                                                                                    questionList[pos]["qm_sheet_sub_parameter"][index]["weight"].toString();
                                                                              } else if (dropdownSelectionList[pos][index] ==
                                                                                  "No") {
                                                                                weightList[pos][index] =
                                                                                    "0";
                                                                              }

                                                                              double
                                                                                  finalCal =
                                                                                  double.parse(totalScore) + double.parse(weightList[pos][index]);

                                                                              print("Final Cal " +
                                                                                  finalCal.toString());
                                                                              totalScore =
                                                                                  finalCal.toString();

                                                                              if (finalCal >=
                                                                                  80) {
                                                                                finalGrade =
                                                                                    "A";
                                                                              } else if (finalCal >= 70 &&
                                                                                  finalCal <=
                                                                                      79) {
                                                                                finalGrade =
                                                                                    "B";
                                                                              } else if (finalCal >= 60 &&
                                                                                  finalCal <=
                                                                                      69) {
                                                                                finalGrade =
                                                                                    "C";
                                                                              } else if (finalCal >= 50 &&
                                                                                  finalCal <=
                                                                                      59) {
                                                                                finalGrade =
                                                                                    "D";
                                                                              } else if (finalCal <=
                                                                                  49) {
                                                                                finalGrade =
                                                                                    "E";
                                                                              }*/
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      /*      dropdownSelectionList[pos][index] == null
                                                                                      ? Container()
                                                                                      : Container(
                                                                                          width: 80,
                                                                                          height: 32,
                                                                                          margin: EdgeInsets.symmetric(horizontal: 2),
                                                                                          color: Colors.cyan,
                                                                                          child: Center(
                                                                                            child: Text(dropdownSelectionList[pos][index] == "Satisfactory" ? questionList[pos]["qm_sheet_sub_parameter"][index]["weight"].toString() : "0",
                                                                                                style: TextStyle(
                                                                                                  fontSize: 12.5,
                                                                                                  fontWeight: FontWeight.w600,
                                                                                                  color: Colors.white,
                                                                                                )),
                                                                                          ),
                                                                                        )*/
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height: 10),
                                                                  Container(
                                                                    // height: 41,
                                                                    margin: EdgeInsets
                                                                        .symmetric(
                                                                        horizontal: 4),
                                                                    child: TextFormField(
                                                                        style: const TextStyle(
                                                                          fontSize: 13.0,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color: Color(
                                                                              0xFF707070),
                                                                        ),
                                                                        maxLines: 3,
                                                                        decoration: InputDecoration(
                                                                            enabledBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius
                                                                                  .circular(
                                                                                  10.0),
                                                                              borderSide: const BorderSide(
                                                                                  color: Colors
                                                                                      .black,
                                                                                  width: 0.5),
                                                                            ),
                                                                            focusedBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius
                                                                                    .circular(
                                                                                    4.0),
                                                                                borderSide: BorderSide(
                                                                                    color: Colors
                                                                                        .black,
                                                                                    width: 0.5)),
                                                                            errorBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius
                                                                                    .circular(
                                                                                    4.0),
                                                                                borderSide: BorderSide(
                                                                                    color: Colors
                                                                                        .red,
                                                                                    width: 0.5)),
                                                                            border: InputBorder
                                                                                .none,
                                                                            contentPadding: EdgeInsets
                                                                                .fromLTRB(
                                                                                7.0,
                                                                                7.0,
                                                                                5,
                                                                                8),
                                                                            //prefixIcon: fieldIC,
                                                                            hintText: "Enter Remark here",
                                                                            hintStyle: TextStyle(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight
                                                                                  .w500,
                                                                              color: Colors
                                                                                  .black
                                                                                  .withOpacity(
                                                                                  0.7),
                                                                            )),
                                                                        controller: controllerList[pos][index]),
                                                                  ),
                                                                  SizedBox(
                                                                      height: 15),
                                                                  Row(
                                                                    children: [
                                                                      Spacer(),
                                                                      Card(
                                                                        elevation: 4,
                                                                        shadowColor: Colors
                                                                            .grey,
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius
                                                                              .circular(
                                                                              6.0),
                                                                        ),
                                                                        child: Container(
                                                                          height: 46,
                                                                          child: ElevatedButton(
                                                                            style: ButtonStyle(
                                                                                foregroundColor: MaterialStateProperty
                                                                                    .all<
                                                                                    Color>(
                                                                                    Colors
                                                                                        .black),
                                                                                // background
                                                                                backgroundColor: MaterialStateProperty
                                                                                    .all<
                                                                                    Color>(
                                                                                    Color(
                                                                                        0xFF93A6A2)),
                                                                                // fore
                                                                                shape: MaterialStateProperty
                                                                                    .all<
                                                                                    RoundedRectangleBorder>(
                                                                                    RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius
                                                                                          .circular(
                                                                                          6.0),
                                                                                    ))),
                                                                            onPressed: () {
                                                                              Navigator
                                                                                  .push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (
                                                                                          context) =>
                                                                                          ViewArtifactScreen(
                                                                                              widget
                                                                                                  .sheetID,
                                                                                              questionList[pos]["id"]
                                                                                                  .toString(),
                                                                                              questionList[pos]["subparameter"][index]["id"]
                                                                                                  .toString(),
                                                                                              widget
                                                                                                  .auditID)));
                                                                            },
                                                                            child: const Text(
                                                                              'Show Artifact',
                                                                              style: TextStyle(
                                                                                fontSize: 15.5,
                                                                                fontWeight: FontWeight
                                                                                    .w500,
                                                                                color: Colors
                                                                                    .black,
                                                                              ),
                                                                              textAlign: TextAlign
                                                                                  .center,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          width: 10),
                                                                      Card(
                                                                        elevation: 4,
                                                                        shadowColor: Colors
                                                                            .grey,
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius
                                                                              .circular(
                                                                              6.0),
                                                                        ),
                                                                        child: Container(
                                                                          height: 46,
                                                                          child: ElevatedButton(
                                                                            style: ButtonStyle(
                                                                                foregroundColor: MaterialStateProperty
                                                                                    .all<
                                                                                    Color>(
                                                                                    Colors
                                                                                        .white),
                                                                                // background
                                                                                backgroundColor: MaterialStateProperty
                                                                                    .all<
                                                                                    Color>(
                                                                                    Color(
                                                                                        0xFF01075D)),
                                                                                // fore
                                                                                shape: MaterialStateProperty
                                                                                    .all<
                                                                                    RoundedRectangleBorder>(
                                                                                    RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius
                                                                                          .circular(
                                                                                          6.0),
                                                                                    ))),
                                                                            onPressed: () {
                                                                              Navigator
                                                                                  .push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (
                                                                                          context) =>
                                                                                          UploadArtifactScreen(
                                                                                              widget
                                                                                                  .sheetID,
                                                                                              questionList[pos]["id"]
                                                                                                  .toString(),
                                                                                              questionList[pos]["subparameter"][index]["id"]
                                                                                                  .toString(),
                                                                                              "1456",
                                                                                              widget
                                                                                                  .auditID)));
                                                                            },
                                                                            child: const Text(
                                                                              'Artifact',
                                                                              style: TextStyle(
                                                                                fontSize: 15.5,
                                                                                fontWeight: FontWeight
                                                                                    .w500,
                                                                                color: Colors
                                                                                    .white,
                                                                              ),
                                                                              textAlign: TextAlign
                                                                                  .center,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          width: 8),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height: 22),
                                                                ],
                                                              );
                                                            })
                                                            : ListView.builder(
                                                            itemCount: questionList[pos]["qm_sheet_sub_parameter"]
                                                                .length,
                                                            shrinkWrap: true,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                horizontal: 5),
                                                            physics: NeverScrollableScrollPhysics(),
                                                            scrollDirection: Axis
                                                                .vertical,
                                                            itemBuilder: (
                                                                BuildContext context,
                                                                int index) {
                                                              /*  answerListFinal[pos]["subs"].add(
                                                              {

                                                                "id":questionList[pos]["qm_sheet_sub_parameter"][index]["id"].toString(),


                                                              }
                                                            );*/

                                                              return Column(
                                                                crossAxisAlignment: CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal: 4),
                                                                    child: Text(
                                                                        questionList[pos]["qm_sheet_sub_parameter"][index]["sub_parameter"],
                                                                        style: TextStyle(
                                                                          fontSize: 12,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color: Colors
                                                                              .black,
                                                                        )),
                                                                  ),
                                                                  SizedBox(
                                                                      height: 5),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: Container(
                                                                          // width: 80,
                                                                          height: 40,
                                                                          margin: EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 4),
                                                                          padding: EdgeInsets
                                                                              .only(
                                                                              right: 5),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius
                                                                                  .circular(
                                                                                  10),
                                                                              border: Border
                                                                                  .all(
                                                                                  color: Colors
                                                                                      .black,
                                                                                  width: 0.5)),
                                                                          child: DropdownButtonHideUnderline(
                                                                            child: DropdownButton2(
                                                                              menuItemStyleData: const MenuItemStyleData(
                                                                                padding: EdgeInsets
                                                                                    .only(
                                                                                    left: 12),
                                                                              ),
                                                                              iconStyleData: IconStyleData(
                                                                                icon: Icon(
                                                                                    Icons
                                                                                        .keyboard_arrow_down_outlined,
                                                                                    color: Colors
                                                                                        .black),
                                                                              ),
                                                                              isExpanded: true,
                                                                              hint: Text(
                                                                                  'Choose Type',
                                                                                  style: TextStyle(
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight
                                                                                        .w500,
                                                                                    color: Colors
                                                                                        .black
                                                                                        .withOpacity(
                                                                                        0.7),
                                                                                  )),
                                                                              items: answerList
                                                                                  .map((
                                                                                  item) =>
                                                                                  DropdownMenuItem<
                                                                                      String>(
                                                                                    value: item,
                                                                                    child: Text(
                                                                                      item,
                                                                                      style: const TextStyle(
                                                                                        fontSize: 14,
                                                                                      ),
                                                                                    ),
                                                                                  ))
                                                                                  .toList(),
                                                                              value: dropdownSelectionList[pos][index],
                                                                              onChanged: (
                                                                                  value) {
                                                                                dropdownSelectionList[pos][index] =
                                                                                value as String;

                                                                                if (dropdownSelectionList[pos][index] ==
                                                                                    "Satisfactory") {
                                                                                  print(
                                                                                      "DDDD");
                                                                                  print(
                                                                                      pos
                                                                                          .toString());
                                                                                  print(
                                                                                      weightList[pos][index]);
                                                                                  print(
                                                                                      scoredList[pos]
                                                                                          .toString());

                                                                                  if (weightList[pos][index] ==
                                                                                      "") {
                                                                                    scorableList[pos] =
                                                                                        scorableList[pos] +
                                                                                            int
                                                                                                .parse(
                                                                                                questionList[pos]["qm_sheet_sub_parameter"][index]["weight"]
                                                                                                    .toString());
                                                                                  }

                                                                                  if (weightList[pos][index] ==
                                                                                      "" ||
                                                                                      weightList[pos][index] ==
                                                                                          "0") {
                                                                                    scoredList[pos] =
                                                                                        scoredList[pos] +
                                                                                            int
                                                                                                .parse(
                                                                                                questionList[pos]["qm_sheet_sub_parameter"][index]["weight"]
                                                                                                    .toString());
                                                                                  }

                                                                                  weightList[pos][index] =
                                                                                      questionList[pos]["qm_sheet_sub_parameter"][index]["weight"]
                                                                                          .toString();

                                                                                  scoreInPercentage[pos] =
                                                                                      (scoredList[pos] *
                                                                                          100) /
                                                                                          scorableList[pos];
                                                                                } else {
                                                                                  print(
                                                                                      "NO ANSWER SELEC");

                                                                                  print(
                                                                                      weightList[pos][index]
                                                                                          .toString());

                                                                                  if (weightList[pos][index] ==
                                                                                      "") {
                                                                                    print(
                                                                                        "Item not exists");
                                                                                    scorableList[pos] =
                                                                                        scorableList[pos] +
                                                                                            int
                                                                                                .parse(
                                                                                                questionList[pos]["qm_sheet_sub_parameter"][index]["weight"]
                                                                                                    .toString());

                                                                                    weightList[pos][index] =
                                                                                    "0";
                                                                                    scoredList[pos] =
                                                                                        scoredList[pos] +
                                                                                            0;
                                                                                    scoreInPercentage[pos] =
                                                                                        (scoredList[pos] *
                                                                                            100) /
                                                                                            scorableList[pos];
                                                                                  } else {
                                                                                    print(
                                                                                        "Item exists");
                                                                                    print("Scored List "+scoredList[pos].toString());
                                                                                    print("Scored List22 "+questionList[pos]["qm_sheet_sub_parameter"][index]["weight"]
                                                                                        .toString());


                                                                                    // scorableList[pos] = scorableList[pos] - int.parse(questionList[pos]["qm_sheet_sub_parameter"][index]["weight"].toString());


                                                                                    if(weightList[pos][index] !=
                                                                                    "0")
                                                                                      {
                                                                                        scoredList[pos] =
                                                                                            scoredList[pos] -
                                                                                                int
                                                                                                    .parse(
                                                                                                    questionList[pos]["qm_sheet_sub_parameter"][index]["weight"]
                                                                                                        .toString());
                                                                                      }

                                                                                    weightList[pos][index] =
                                                                                    "0";

                                                                                    scoreInPercentage[pos] =
                                                                                        (scoredList[pos] *
                                                                                            100) /
                                                                                            scorableList[pos];
                                                                                  }
                                                                                }

                                                                                if (scorableList
                                                                                    .length ==
                                                                                    0) {
                                                                                  finalGrade =
                                                                                  "";
                                                                                } else
                                                                                if (scorableList
                                                                                    .reduce((
                                                                                    a,
                                                                                    b) =>
                                                                                a +
                                                                                    b) ==
                                                                                    0) {
                                                                                  finalGrade =
                                                                                  "";
                                                                                } else {
                                                                                  double finalCal = scoredList
                                                                                      .reduce((
                                                                                      a,
                                                                                      b) =>
                                                                                  a +
                                                                                      b) *
                                                                                      100 /
                                                                                      scorableList
                                                                                          .reduce((
                                                                                          a,
                                                                                          b) =>
                                                                                      a +
                                                                                          b);

                                                                                  if (finalCal >=
                                                                                      90) {
                                                                                    finalGrade =
                                                                                    "A";
                                                                                  } else
                                                                                  if (finalCal >=
                                                                                      75) {
                                                                                    finalGrade =
                                                                                    "B";
                                                                                  } else
                                                                                  if (finalCal >=
                                                                                      61) {
                                                                                    finalGrade =
                                                                                    "C";
                                                                                  } else {
                                                                                    finalGrade =
                                                                                    "D";
                                                                                  }
                                                                                }

                                                                                setState(() {});

                                                                                /*                                   if (dropdownSelectionList[pos][index] ==
                                                                                  "Yes") {
                                                                                weightList[pos][index] =
                                                                                    questionList[pos]["qm_sheet_sub_parameter"][index]["weight"].toString();
                                                                              } else if (dropdownSelectionList[pos][index] ==
                                                                                  "No") {
                                                                                weightList[pos][index] =
                                                                                    "0";
                                                                              }

                                                                              double
                                                                                  finalCal =
                                                                                  double.parse(totalScore) + double.parse(weightList[pos][index]);

                                                                              print("Final Cal " +
                                                                                  finalCal.toString());
                                                                              totalScore =
                                                                                  finalCal.toString();

                                                                              if (finalCal >=
                                                                                  80) {
                                                                                finalGrade =
                                                                                    "A";
                                                                              } else if (finalCal >= 70 &&
                                                                                  finalCal <=
                                                                                      79) {
                                                                                finalGrade =
                                                                                    "B";
                                                                              } else if (finalCal >= 60 &&
                                                                                  finalCal <=
                                                                                      69) {
                                                                                finalGrade =
                                                                                    "C";
                                                                              } else if (finalCal >= 50 &&
                                                                                  finalCal <=
                                                                                      59) {
                                                                                finalGrade =
                                                                                    "D";
                                                                              } else if (finalCal <=
                                                                                  49) {
                                                                                finalGrade =
                                                                                    "E";
                                                                              }*/
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      /*      dropdownSelectionList[pos][index] == null
                                                                                      ? Container()
                                                                                      : Container(
                                                                                          width: 80,
                                                                                          height: 32,
                                                                                          margin: EdgeInsets.symmetric(horizontal: 2),
                                                                                          color: Colors.cyan,
                                                                                          child: Center(
                                                                                            child: Text(dropdownSelectionList[pos][index] == "Satisfactory" ? questionList[pos]["qm_sheet_sub_parameter"][index]["weight"].toString() : "0",
                                                                                                style: TextStyle(
                                                                                                  fontSize: 12.5,
                                                                                                  fontWeight: FontWeight.w600,
                                                                                                  color: Colors.white,
                                                                                                )),
                                                                                          ),
                                                                                        )*/
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height: 10),
                                                                  Container(
                                                                    // height: 41,
                                                                    margin: EdgeInsets
                                                                        .symmetric(
                                                                        horizontal: 4),
                                                                    child: TextFormField(
                                                                        style: const TextStyle(
                                                                          fontSize: 13.0,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color: Color(
                                                                              0xFF707070),
                                                                        ),
                                                                        maxLines: 3,
                                                                        decoration: InputDecoration(
                                                                            enabledBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius
                                                                                  .circular(
                                                                                  10.0),
                                                                              borderSide: const BorderSide(
                                                                                  color: Colors
                                                                                      .black,
                                                                                  width: 0.5),
                                                                            ),
                                                                            focusedBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius
                                                                                    .circular(
                                                                                    4.0),
                                                                                borderSide: BorderSide(
                                                                                    color: Colors
                                                                                        .black,
                                                                                    width: 0.5)),
                                                                            errorBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius
                                                                                    .circular(
                                                                                    4.0),
                                                                                borderSide: BorderSide(
                                                                                    color: Colors
                                                                                        .red,
                                                                                    width: 0.5)),
                                                                            border: InputBorder
                                                                                .none,
                                                                            contentPadding: EdgeInsets
                                                                                .fromLTRB(
                                                                                7.0,
                                                                                7.0,
                                                                                5,
                                                                                8),
                                                                            //prefixIcon: fieldIC,
                                                                            hintText: "Enter Remark here",
                                                                            hintStyle: TextStyle(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight
                                                                                  .w500,
                                                                              color: Colors
                                                                                  .black
                                                                                  .withOpacity(
                                                                                  0.7),
                                                                            )),
                                                                        controller: controllerList[pos][index]),
                                                                  ),
                                                                  SizedBox(
                                                                      height: 15),
                                                                  Row(
                                                                    children: [
                                                                      Spacer(),
                                                                      Card(
                                                                        elevation: 4,
                                                                        shadowColor: Colors
                                                                            .grey,
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius
                                                                              .circular(
                                                                              6.0),
                                                                        ),
                                                                        child: Container(
                                                                          height: 46,
                                                                          child: ElevatedButton(
                                                                            style: ButtonStyle(
                                                                                foregroundColor: MaterialStateProperty
                                                                                    .all<
                                                                                    Color>(
                                                                                    Colors
                                                                                        .black),
                                                                                // background
                                                                                backgroundColor: MaterialStateProperty
                                                                                    .all<
                                                                                    Color>(
                                                                                    Color(
                                                                                        0xFF93A6A2)),
                                                                                // fore
                                                                                shape: MaterialStateProperty
                                                                                    .all<
                                                                                    RoundedRectangleBorder>(
                                                                                    RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius
                                                                                          .circular(
                                                                                          6.0),
                                                                                    ))),
                                                                            onPressed: () {
                                                                              Navigator
                                                                                  .push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (
                                                                                          context) =>
                                                                                          ViewArtifactScreen(
                                                                                              widget
                                                                                                  .sheetID,
                                                                                              questionList[pos]["id"]
                                                                                                  .toString(),
                                                                                              questionList[pos]["qm_sheet_sub_parameter"][index]["id"]
                                                                                                  .toString(),
                                                                                              widget
                                                                                                  .auditID)));
                                                                            },
                                                                            child: const Text(
                                                                              'Show Artifact',
                                                                              style: TextStyle(
                                                                                fontSize: 15.5,
                                                                                fontWeight: FontWeight
                                                                                    .w500,
                                                                                color: Colors
                                                                                    .black,
                                                                              ),
                                                                              textAlign: TextAlign
                                                                                  .center,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          width: 10),
                                                                      Card(
                                                                        elevation: 4,
                                                                        shadowColor: Colors
                                                                            .grey,
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius
                                                                              .circular(
                                                                              6.0),
                                                                        ),
                                                                        child: Container(
                                                                          height: 46,
                                                                          child: ElevatedButton(
                                                                            style: ButtonStyle(
                                                                                foregroundColor: MaterialStateProperty
                                                                                    .all<
                                                                                    Color>(
                                                                                    Colors
                                                                                        .white),
                                                                                // background
                                                                                backgroundColor: MaterialStateProperty
                                                                                    .all<
                                                                                    Color>(
                                                                                    Color(
                                                                                        0xFF01075D)),
                                                                                // fore
                                                                                shape: MaterialStateProperty
                                                                                    .all<
                                                                                    RoundedRectangleBorder>(
                                                                                    RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius
                                                                                          .circular(
                                                                                          6.0),
                                                                                    ))),
                                                                            onPressed: () {
                                                                              Navigator
                                                                                  .push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (
                                                                                          context) =>
                                                                                          UploadArtifactScreen(
                                                                                              widget
                                                                                                  .sheetID,
                                                                                              questionList[pos]["id"]
                                                                                                  .toString(),
                                                                                              questionList[pos]["qm_sheet_sub_parameter"][index]["id"]
                                                                                                  .toString(),
                                                                                              "1456",
                                                                                              widget
                                                                                                  .auditID)));
                                                                            },
                                                                            child: const Text(
                                                                              'Artifact',
                                                                              style: TextStyle(
                                                                                fontSize: 15.5,
                                                                                fontWeight: FontWeight
                                                                                    .w500,
                                                                                color: Colors
                                                                                    .white,
                                                                              ),
                                                                              textAlign: TextAlign
                                                                                  .center,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          width: 8),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height: 22),
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
                                  ],
                                );
                              })
                        ],
                      ),
                    ),
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
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                          ),
                          Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Center(
                                        child: Text("Scorable",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white)),
                                      ),
                                      flex: 1),
                                  Expanded(
                                      child: Center(
                                        child: Text("Scored",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white)),
                                      ),
                                      flex: 1),
                                  Expanded(
                                      child: Center(
                                        child: Text("Scores%",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white)),
                                      ),
                                      flex: 1),
                                ],
                              ))
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    ListView.builder(
                        itemCount: questionList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context, int pos) {
                          return Column(
                            children: [
                              Container(
                                margin:
                                EdgeInsets.symmetric(horizontal: 10),
                                padding:
                                EdgeInsets.symmetric(horizontal: 5),
                                height: 36,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 130,
                                      child: Text(
                                          questionList[pos]["parameter"],
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
                                                  child: Text(
                                                      scorableList[pos]
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          color: Colors.black)),
                                                ),
                                                flex: 1),
                                            Expanded(
                                                child: Center(
                                                  child: Text(
                                                      scoredList[pos]
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          color: Colors.black)),
                                                ),
                                                flex: 1),
                                            Expanded(
                                                child: Center(
                                                  child: Text(
                                                      scorableList[pos] == 0
                                                          ? "0.00%"
                                                          :
                                                      scoreInPercentage[pos]
                                                          .toStringAsFixed(
                                                          2) +
                                                          "%",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          color: Colors.black)),
                                                ),
                                                flex: 1),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                              pos == questionList.length - 1
                                  ? Container()
                                  : Container(
                                  child: Divider(),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 14))
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
                                            scorableList.length == 0
                                                ? ""
                                                : scorableList
                                                .reduce((a, b) => a + b)
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                      ),
                                      flex: 1),
                                  Expanded(
                                      child: Center(
                                        child: Text(
                                            scoredList.length == 0
                                                ? ""
                                                : scoredList
                                                .reduce((a, b) => a + b)
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                      ),
                                      flex: 1),
                                  Expanded(
                                      child: Center(
                                        child: Text(
                                            scorableList.length == 0
                                                ? ""
                                                : scorableList.reduce(
                                                    (a, b) => a + b) ==
                                                0
                                                ? "0.00%"
                                                : (scoredList.reduce(
                                                    (a, b) =>
                                                a + b) *
                                                100 /
                                                scorableList
                                                    .reduce((a,
                                                    b) =>
                                                a + b))
                                                .toStringAsFixed(
                                                2) +
                                                "%",
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
                          Text(finalGrade,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          elevation: 3,
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Container(
                            height: 44,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.white), // background
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Color(0xFFFF5100)), // fore
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(6.0),
                                      ))),
                              onPressed: () {
                                if (hasInternet) {
                                  checkValidations("save");
                                }
                              },
                              child: const Text(
                                'SAVE',
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

                        //   SizedBox(width: 10),

                        !hasInternet
                            ? Container()
                            : Card(
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
                                  foregroundColor:
                                  MaterialStateProperty.all<
                                      Color>(
                                      Colors.white), // background
                                  backgroundColor:
                                  MaterialStateProperty
                                      .all<Color>(AppTheme
                                      .themeColor), // fore
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(6.0),
                                      ))),
                              onPressed: () {
                                checkValidations("submit");
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
                        ),

                        SizedBox(width: 8),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  checkValidations(String methodType) {
    ToastContext().init(context);
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
    }

    else if(presentAuditorController.text=="" && !widget.isEdit)
    {
      Toast.show("Please enter Present Auditor name!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }


    else if (latLongController.text == "") {
      Toast.show("Geo tag not found",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }



    else {
      bool flag = true;
      if (widget.isEdit) {
        //subparameter

        outerLoop:
        for (int i = 0; i < questionList.length; i++) {
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
                dropdownSelectionList[i][j] != "Satisfactory") {
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
      } else {
        outerLoop:
        for (int i = 0; i < questionList.length; i++) {
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
                dropdownSelectionList[i][j] != "Satisfactory") {
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
      }

      // All Data Passed

      if (flag) {
        if (methodType == "save") {
          prepareData(methodType);
        } else {
          String idDummy = "133";
          String idDummyStaging = "131";
          String id = "82";
          String id1 = "62";
          String id2 = "42";
          String idStaging = "42";
          String question = "Check collection manager";
          String question2 = "Presence Of Banker During Process Review (Mention the reason with product name (Cards/Retail/MSME) in remarks if UNSATISFACTORY)";
          collectionManagerSelected = false;


          if (widget.isEdit) {
            outerLoop:
            for (int i = 0; i < questionList.length; i++) {
              for (int j = 0;
              j < questionList[i]["subparameter"].length;
              j++) {
                if (questionList[i]["subparameter"][j]["id"].toString() ==
                    idDummy ||
                    questionList[i]["subparameter"][j]["id"].toString() ==
                        id ||
                    questionList[i]["subparameter"][j]["id"].toString() ==
                        idDummyStaging ||
                    questionList[i]["subparameter"][j]["id"].toString() ==
                        idStaging ||
                    questionList[i]["subparameter"][j]["id"].toString() ==
                        id1 ||
                    questionList[i]["subparameter"][j]["id"].toString() ==
                        id2) {
                  if (dropdownSelectionList[i][j] == "Satisfactory") {
                    collectionManagerSelected = true;
                    break outerLoop;
                  }
                }
              }
            }
          }
          else {
            outerLoop:
            for (int i = 0; i < questionList.length; i++) {
              for (int j = 0;
              j < questionList[i]["qm_sheet_sub_parameter"].length;
              j++) {
                if (questionList[i]["qm_sheet_sub_parameter"][j]["id"]
                    .toString() ==
                    idDummy ||
                    questionList[i]["qm_sheet_sub_parameter"][j]["id"]
                        .toString() ==
                        id ||
                    questionList[i]["qm_sheet_sub_parameter"][j]["id"]
                        .toString() ==
                        idDummyStaging ||
                    questionList[i]["qm_sheet_sub_parameter"][j]["id"]
                        .toString() ==
                        idStaging ||
                    questionList[i]["qm_sheet_sub_parameter"][j]["id"]
                        .toString() ==
                        id1 ||
                    questionList[i]["qm_sheet_sub_parameter"][j]["id"]
                        .toString() ==
                        id2) {
                  if (dropdownSelectionList[i][j] == "Satisfactory") {
                    collectionManagerSelected = true;
                    break outerLoop;
                  }
                }
              }
            }
          }

          print("COLLL");
          print(collectionManagerSelected.toString());

          // prepareData("submit");
          sendOTP("");
        }

        // prepareData(methodType);
      }
    }
  }

  prepareData(String methodType) async {
    if (level4IDs.length != 0) {
      level4IDs.clear();
    }
    if (level5IDs.length != 0) {
      level5IDs.clear();
    }
    APIDialog.showAlertDialog(context, "Submitting Audit...");

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

      for (int j = 0; j < level4UserList.length; j++) {
        print("LOOP DATA " + j.toString());


        print(selectedLevel4Drop[i]);
        print(level4UserList[j]["name"]);

        if (selectedLevel4Drop[i] == level4UserList[j]["name"]) {
          flag = true;
          print("LOOP DATA 22");
          level4IDs.add(level4UserList[j]["id"].toString());
          break;
        }
      }
    }

    for (int i = 0; i < selectedLevel5Drop.length; i++) {
      for (int j = 0; j < level5Users.length; j++) {
        if (selectedLevel5Drop[i] == level5Users[j]["name"]) {
          level5IDs.add(level5Users[j]["id"].toString());
          break;
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
        for (int j = 0; j <
            questionList[i]["qm_sheet_sub_parameter"].length; j++) {
          subParams.add({
            "id": questionList[i]["qm_sheet_sub_parameter"][j]["id"]
                .toString(),
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

        /*   parameterList[(questionList[i]["id"]).toString()]={
    "subs":{
    (questionList[i]["qm_sheet_sub_parameter"][j]["id"]).toString():
    {
    "option": dropdownSelectionList[i][j],
    "remark": controllerList[i][j].text
    }
    }
    };
*/
      }
    }




    var requestModel = {
      "submission_data": {
        "token": AppModel.token,
        "user_id": AppModel.userID,
        "present_auditor":presentAuditorController.text,
        "qm_sheet_id": widget.sheetID,
        "audit_date_by_aud": selectedDate,
        "agency_phone": selectedPhone.toString(),
        "agency_email": selectedEmail.toString(),
        "audit_agency_id": auditAgencyID,
        "audit_cycle_id": auditCycleID,
        "geotag": latLongController.text.toString(),
        "overall_score": scoredList.reduce((a, b) => a + b).toString(),
        "agency_id": agencySearchController.text
            .toString()
            .length == 0
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
        scoreInPercentage.reduce((a, b) => a + b).toStringAsFixed(2) + "%",
        "sub_product_ids": selectedSubProductIDsAsString
            .toString()
            .substring(1, selectedSubProductIDsAsString
            .toString()
            .length - 1)
      },
      "parameters": parameterList,
      "checksheet_data": checkListData,
    };
    var requestModelEdit = {
      "submission_data": {
        "token": AppModel.token,
        "user_id": AppModel.userID,
        "present_auditor":presentAuditorController.text,
        "collection_manager": selectedlevel1.toString(),
        "audit_id": widget.auditID,
        "agency_phone": selectedPhone.toString(),
        "agency_email": selectedEmail.toString(),
        "qm_sheet_id": widget.sheetID,
        "audit_date_by_aud": selectedDate,
        "audit_cycle_id": auditCycleID,
        "geotag": latLongController.text.toString(),
        "overall_score": scoredList.reduce((a, b) => a + b).toString(),
        "agency_id": agencySearchController.text
            .toString()
            .length == 0
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
        "grade": finalGrade,
        "with_fatal_score_per":
        scoreInPercentage.reduce((a, b) => a + b).toStringAsFixed(2) + "%",
        "sub_product_ids": selectedSubProductIDsAsString
            .toString()
            .substring(1, selectedSubProductIDsAsString
            .toString()
            .length - 1)
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
    totalFiles=imageList.length;
    APIDialog.showAlertDialog(context, 'Uploading images...');
    for (int i = 0; i < imageList.length; i++) {
      FormData formData = FormData.fromMap({
        "sheet_id": widget.sheetID,
        "parameter_id": imageList[i]["parameter_id"],
        "sub_parameter_id": imageList[i]["sub_parameter_id"],
        "audit_id": auditID,
        "status": "1",
        "totalFile": await MultipartFile.fromFile(imageList[i]["imagePath"],
            filename: imageList[i]["imagePath"]
                .split('/')
                .last),
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
        uploadedFiles=uploadedFiles+1;
        if (i == imageList.length - 1) {
          Navigator.pop(context);
          Toast.show(
              "Images Uploaded successfully!",
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
                                    animationDuration: Duration(
                                        milliseconds: 300),
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

                                  /*   Future.delayed(const Duration(seconds: 2), () {

                                    Navigator.pop(context);



                                    Toast.show("OTP Verified successfully!",
                                        duration: Toast.lengthLong,
                                        gravity: Toast.bottom,
                                        backgroundColor: Colors.green);



                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) => HomeScreen()),
                                            (Route<dynamic> route) => false);



                                  });*/

                                  //  verifyOTP();
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

                            /*   Row(
                              children: [

                                Spacer(),

                                GestureDetector(
                                  onTap: () {
                                    sendOTP("resend");
                                  },
                                  child: Text("Resend OTP",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.blue,
                                      )),
                                ),
                                SizedBox(width: 12),


                              ],
                            ),
*/


                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10),
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
                                        decorationColor: AppTheme.themeColor,
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
                                    animationDuration: Duration(
                                        milliseconds: 300),
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

                                  /*   Future.delayed(const Duration(seconds: 2), () {

                                    Navigator.pop(context);



                                    Toast.show("OTP Verified successfully!",
                                        duration: Toast.lengthLong,
                                        gravity: Toast.bottom,
                                        backgroundColor: Colors.green);



                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) => HomeScreen()),
                                            (Route<dynamic> route) => false);



                                  });*/

                                  //  verifyOTP();
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

                            /*  Row(
                              children: [

                                Spacer(),

                                GestureDetector(
                                  onTap: () {
                                    sendOTPToCollectionManager(true);
                                  },
                                  child: Text("Resend OTP",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.blue,
                                      )),
                                ),
                                SizedBox(width: 12),


                              ],
                            ),*/


                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10),
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
                                        decorationColor: AppTheme.themeColor,
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


  void selectCityBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, bottomSheetState) {
          return Container(
            padding: EdgeInsets.all(10),
            // height: 600,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
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
                    Text("Select City",
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
                      style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF707070),
                      ),
                      onChanged: (value) {
                        // Filter the city list based on the search query
                        // setState(() {
                        //
                        // });
                        bottomSheetState(() {
                          filteredCityList = cityList
                              .where((city) =>
                              city["name"]
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
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
                          labelText: "Search city",
                          labelStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF707070).withOpacity(0.4),
                          ))),
                ),
                SizedBox(height: 5),
                Container(
                  height: 300,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredCityList.length,
                      itemBuilder: (BuildContext context, int pos) {
                        return InkWell(
                          onTap: () {
                            bottomSheetState(() {
                              selectedCityIndex = pos;
                            });
                          },
                          child: Container(
                            height: 57,
                            color: selectedCityIndex == pos
                                ? Color(0xFFFF7C00).withOpacity(0.10)
                                : Colors.white,
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24),
                                  child: Text(filteredCityList[pos]["name"],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      )),
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
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ))),
                      onPressed: () {
                        if (selectedCityIndex != 9999) {
                          Navigator.pop(context);
                          setState(() {});

                          fetchAgencies();
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
          );
        });
      },
    );
  }

  void selectManagerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, bottomSheetState) {
          return Container(
            padding: EdgeInsets.all(10),
            // height: 600,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
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
                    Text("Collection Manager",
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
                      style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF707070),
                      ),
                      onChanged: (value) {
                        bottomSheetState(() {
                          filterManagerList = managerList
                              .where((city) =>
                              city["name"]
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
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
                  height: 300,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filterManagerList.length,
                      itemBuilder: (BuildContext context, int pos) {
                        return Container(
                          height: 57,
                          color: selectedManagerIndex == pos
                              ? Color(0xFFFF7C00).withOpacity(0.10)
                              : Colors.white,
                          child: Row(
                            children: [
                              GestureDetector(
                                child: Container(
                                  child: selectedManagers[pos]
                                      ? Icon(Icons.check_box,
                                      color: AppTheme.themeColor)
                                      : Icon(Icons.check_box_outline_blank),
                                ),
                                onTap: () {
                                  bottomSheetState(() {
                                    if (selectedManagers[pos]) {
                                      selectedManagersList
                                          .remove(filterManagerList[pos]);

                                      selectedManagers[pos] = false;
                                      managerListAsString.remove(
                                          filterManagerList[pos]["name"]);
                                    } else {
                                      selectedManagers[pos] = true;
                                      managerListAsString
                                          .add(filterManagerList[pos]["name"]);
                                      selectedManagersList
                                          .add(filterManagerList[pos]);
                                    }
                                    print("Selected Managers ");
                                    print(selectedManagersList.toString());
                                  });

                                  setState(() {});
                                },
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24),
                                  child: Text(filterManagerList[pos]["name"],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      )),
                                ),
                              ),
                            ],
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
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ))),
                      onPressed: () {
                        if (managerListAsString.length != 0) {
                          Navigator.pop(context);
                          setState(() {});
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
          );
        });
      },
    );
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
                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom),
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
                                .where((hobbie) =>
                                hobbie['agency_id']
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();


                            List<dynamic> results2 = agencyList
                                .where((hobbie) =>
                                hobbie['name']
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();


                            results.addAll(results1);
                            results.addAll(results2);
                          }

                          filteredAgencyList = results;


                          bottomSheetState(() {

                          });
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
                    child:
                    filteredAgencyList.length != 0 ||
                        agencySearchController.text.isNotEmpty ?


                    ListView.builder(
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
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 24),
                                      child: Text(
                                          filteredAgencyList[pos]["agency_id"]
                                              .toString() + " " +
                                              filteredAgencyList[pos]["name"],
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
                        }) :
                    ListView.builder(
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
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 24),
                                      child: Text(agencyList[pos]["agency_id"]
                                          .toString() + " " +
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
                        })

                    ,
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
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
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

  void selectSubProductsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, bottomSheetState) {
          return Container(
            padding: EdgeInsets.all(10),
            // height: 600,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
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
                    Text("Sub Products",
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
                /*   Container(
                  width: double.infinity,
                  height: 53,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color(0xFFEEEDF9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                      style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF707070),
                      ),
                      onChanged: (value) {

                        bottomSheetState((){
                          filteredAgencyList = agencyList
                              .where((city) => city["name"].toLowerCase().contains(value.toLowerCase()))
                              .toList();
                        });
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
                SizedBox(height: 5),*/
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                      itemCount: subProductList.length,
                      itemBuilder: (BuildContext context, int pos) {
                        return InkWell(
                          onTap: () {
                            if (selectedSubProducts
                                .contains(subProductList[pos].toString())) {
                              selectedSubProductAsString.remove(
                                  subProductList[pos]
                                  ["product_attribute_name"]);

                              selectedSubProducts
                                  .remove(subProductList[pos].toString());

                              print(selectedSubProductAsString.toString());
                            } else {
                              selectedSubProductAsString.add(subProductList[pos]
                              ["product_attribute_name"]);
                              selectedSubProducts
                                  .add(subProductList[pos].toString());

                              print(selectedSubProductAsString.toString());
                            }

                            bottomSheetState(() {});
                          },
                          child: Container(
                            height: 57,
                            color: selectedSubProducts
                                .contains(subProductList[pos].toString())
                                ? Color(0xFFFF7C00).withOpacity(0.10)
                                : Colors.white,
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                selectedSubProducts.contains(
                                    subProductList[pos].toString())
                                    ? Icon(Icons.check_box,
                                    color: AppTheme.themeColor)
                                    : Icon(Icons.check_box_outline_blank),
                                Expanded(
                                  child: Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                        subProductList[pos]
                                        ["product_attribute_name"],
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
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ))),
                      onPressed: () {
                        if (selectedSubProducts.length != 0) {
                          Navigator.pop(context);
                          setState(() {});
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
          );
        });
      },
    );
  }

  void selectLevel5BottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, bottomSheetState) {
          return Container(
            padding: EdgeInsets.all(10),
            // height: 600,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
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
                    Text("Level 5",
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
                /*   Container(
                  width: double.infinity,
                  height: 53,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color(0xFFEEEDF9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                      style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF707070),
                      ),
                      onChanged: (value) {

                        bottomSheetState((){
                          filteredAgencyList = agencyList
                              .where((city) => city["name"].toLowerCase().contains(value.toLowerCase()))
                              .toList();
                        });
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
                SizedBox(height: 5),*/
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                      itemCount: level5Users.length,
                      itemBuilder: (BuildContext context, int pos) {
                        print("DATATAT");

                        print(level5Users[pos].toString());
                        print(selectedLevel5Users.toString());

                        if (selectedLevel5Users
                            .contains(level5Users[pos].toString())) {
                          print("Match FFF");
                        }

                        return InkWell(
                          onTap: () {
                            if (selectedLevel5Users
                                .contains(level5Users[pos].toString())) {
                              selectedLevel5Users
                                  .remove(level5Users[pos].toString());

                              selectedLevel5Names
                                  .remove(level5Users[pos]["name"].toString());

                              level5IDs
                                  .remove(level5Users[pos]["id"].toString());

                              print(selectedLevel5Names.toString());
                              print(selectedLevel5Users.toString());
                            } else {
                              selectedLevel5Names.add(level5Users[pos]["name"]);
                              selectedLevel5Users
                                  .add(level5Users[pos].toString());

                              level5IDs.add(level5Users[pos]["id"].toString());

                              print(selectedLevel5Names.toString());
                            }

                            bottomSheetState(() {});
                          },
                          child: Container(
                            height: 57,
                            color: selectedLevel5Users
                                .contains(level5Users[pos].toString())
                                ? Color(0xFFFF7C00).withOpacity(0.10)
                                : Colors.white,
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                selectedLevel5Users
                                    .contains(level5Users[pos].toString())
                                    ? Icon(Icons.check_box,
                                    color: AppTheme.themeColor)
                                    : Icon(Icons.check_box_outline_blank),
                                Expanded(
                                  child: Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(level5Users[pos]["name"] ?? "",
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
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ))),
                      onPressed: () {
                        if (selectedLevel5Users.length != 0) {
                          Navigator.pop(context);
                          setState(() {});
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
          );
        });
      },
    );
  }

  void selectLevel4BottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, bottomSheetState) {
          return Container(
            padding: EdgeInsets.all(10),
            // height: 600,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
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
                    Text("Level 4",
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
                /*   Container(
                  width: double.infinity,
                  height: 53,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color(0xFFEEEDF9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                      style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF707070),
                      ),
                      onChanged: (value) {

                        bottomSheetState((){
                          filteredAgencyList = agencyList
                              .where((city) => city["name"].toLowerCase().contains(value.toLowerCase()))
                              .toList();
                        });
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
                SizedBox(height: 5),*/
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                      itemCount: level4UserList.length,
                      itemBuilder: (BuildContext context, int pos) {
                        return InkWell(
                          onTap: () {
                            if (selectedLevel4UserList
                                .contains(level4UserList[pos].toString())) {
                              selectedLevel4UserList
                                  .remove(level4UserList[pos].toString());
                              level4IDs
                                  .remove(level4UserList[pos]["id"].toString());

                              selectedLevel4AsString.remove(
                                  level4UserList[pos]["name"].toString());

                              print(selectedLevel4AsString.toString());
                              print(selectedLevel4UserList.toString());
                            } else {
                              selectedLevel4AsString
                                  .add(level4UserList[pos]["name"]);
                              selectedLevel4UserList
                                  .add(level4UserList[pos].toString());
                              level4IDs
                                  .add(level4UserList[pos]["id"].toString());
                              print(selectedLevel4AsString.toString());
                            }

                            bottomSheetState(() {});
                          },
                          child: Container(
                            height: 57,
                            color: selectedLevel4UserList
                                .contains(level4UserList[pos].toString())
                                ? Color(0xFFFF7C00).withOpacity(0.10)
                                : Colors.white,
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                selectedLevel4UserList.contains(
                                    level4UserList[pos].toString())
                                    ? Icon(Icons.check_box,
                                    color: AppTheme.themeColor)
                                    : Icon(Icons.check_box_outline_blank),
                                Expanded(
                                  child: Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                    child:
                                    Text(level4UserList[pos]["name"] ?? "",
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
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ))),
                      onPressed: () {
                        if (selectedLevel4UserList.length != 0) {
                          Navigator.pop(context);
                          setState(() {});
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
          );
        });
      },
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

  saveInSharedPrefrences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String json = jsonEncode(questionList);
    await preferences.setString('question_list' + widget.sheetID, json);
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
        viewAuditData(context);
      } else {
        fetchCities();
        fetchAgencies();
        fetchAuditCycleList();
        fetchUserList();
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
    if(auditDetails.toString().contains("present_auditor"))
      {
        presentAuditorController.text=auditDetails["present_auditor"];
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
            (i) =>
        List<TextEditingController>.generate(
            col, (index) => TextEditingController()));

    for (int i = 0; i < questionList.length; i++) {
      print("LOOP COUNT" + i.toString());

      for (int j = 0; j < questionList[i]["subparameter"].length; j++) {
        totalScorer = totalScorer +
            int.parse(questionList[i]["subparameter"][j]["weight"].toString());
        print("Total Scoredd " + totalScored.toString());
        totalScored = totalScored +
            int.parse(questionList[i]["subparameter"][j]["score"].toString());

        if(questionList[i]["subparameter"][j]["remark"]!=null)
          {
            controllerList[i][j].text =
                questionList[i]["subparameter"][j]["remark"].toString();
          }
        else
          {
            controllerList[i][j].text = "NA";
          }



        dropdownSelectionList[i][j] =
        questionList[i]["subparameter"][j]["option_selected"];

        weightList[i][j] =
            questionList[i]["subparameter"][j]["score"].toString();
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

  fetchAgenciesEdit(String agencyID) async {
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
              (i) =>
          List<TextEditingController>.generate(
              col, (index) => TextEditingController()));

      setState(() {});
    } else {
      Toast.show("No Internet!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
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

  fetchProducts() async {
    if (productList.length != 0) {
      productList.clear();
      productListAsString.clear();
    }
    APIDialog.showAlertDialog(context, "Please wait...");
    var requestModel = {
      "type": "agency",
      "id": agencySearchController.text
          .toString()
          .length == 0
          ? agencyList[selectedAgencyIndex]["id"].toString()
          : filteredAgencyList[selectedAgencyIndex]["id"].toString(),
    };

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPIWithHeader('getProduct', requestModel, context);

    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    // agencyList=responseJSON["data"];

    productList = responseJSON["data"];
    for (int i = 0; i < productList.length; i++) {
      productListAsString.add(productList[i]["name"]);
    }

    setState(() {});
  }

  fetchSubProducts(String productID) async {
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

  verifyOTP() async {
    APIDialog.showAlertDialog(context, "Verifying OTP...");

    var requestModel = {
      "otp": userEnteredOTP,
      "agency_email": selectedEmail,
      "agency_id": agencySearchController.text
          .toString()
          .length == 0
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


        // Call send OTP API For collection Manager
      }
      else {
        prepareData("submit");
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


      prepareData("submit");


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
    //subparameter

    // List<dynamic> parameterList=[];
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

        /*   parameterList[(questionList[i]["id"]).toString()]={
    "subs":{
    (questionList[i]["qm_sheet_sub_parameter"][j]["id"]).toString():
    {
    "option": dropdownSelectionList[i][j],
    "remark": controllerList[i][j].text
    }
    }
    };
*/
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
      "agency_id": agencySearchController.text
          .toString()
          .length == 0
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

  sendOTP(String productID) async {
    APIDialog.showAlertDialog(context, "Sending OTP...");
    //subparameter

    // List<dynamic> parameterList=[];
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

        /*   parameterList[(questionList[i]["id"]).toString()]={
    "subs":{
    (questionList[i]["qm_sheet_sub_parameter"][j]["id"]).toString():
    {
    "option": dropdownSelectionList[i][j],
    "remark": controllerList[i][j].text
    }
    }
    };
*/
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
      "agency_id": agencySearchController.text
          .toString()
          .length == 0
          ? agencyList[selectedAgencyIndex]["id"].toString()
          : filteredAgencyList[selectedAgencyIndex]["id"].toString(),
      "parameters": parameterList,
      "product_id": selectedProductID,
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

  fetchAgencyDetails() async {
    APIDialog.showAlertDialog(context, "Please wait...");
    var requestModel = {
      "agency_id": agencySearchController.text
          .toString()
          .length == 0
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
            (i) =>
        List<TextEditingController>.generate(
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
          "Location  latitude : ${_currentPosition!
              .latitude} Longitude : ${_currentPosition!.longitude}");

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

  fetchQuestions() async {
    setState(() {
      isLoading = true;
    });
    var requestModel = {"qm_sheet_id": widget.sheetID};

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPIWithHeader('audit_sheet', requestModel, context);
    setState(() {
      isLoading = false;
    });
    var responseJSON = json.decode(response.body);
    cityList = responseJSON["data"]["cities"];
    auditCycleList = responseJSON["data"]["cycle"];
    for (int i = 0; i < auditCycleList.length; i++) {
      auditCycleListAsString.add(auditCycleList[i]["name"]);
    }

    lobList = responseJSON["data"]["bucket"];
    for (int i = 0; i < lobList.length; i++) {
      lobListAsString.add(lobList[i]["lob"]);
    }

    print(responseJSON);
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
        selectedLevel5Drop.add(level5Users[0]["name"]);
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
        selectedLevel4Drop.add(level4UserList[0]["name"]);
      }
    }

    selectedlevel1 = levelByUserList[0].toString();
    selectedlevel2 = levelByUserList[0].toString();
    selectedlevel3 = levelByUserList[0].toString();

    setState(() {});
  }

  fetchUserListEdit(String? level3ID, String? level4ID,
      String? level5ID) async {
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

  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      results = agencyList;
    } else {
      results = agencyList
          .where((hobbie) =>
          hobbie['name']
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      filteredAgencyList = results;
    });
  }

}
