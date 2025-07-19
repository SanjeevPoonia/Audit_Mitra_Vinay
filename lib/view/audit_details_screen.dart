import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
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

import 'home_screen.dart';

class AuditDetailsScreen extends StatefulWidget {
  final String auditID;

  AuditDetailsScreen(this.auditID);

  AuditFormState createState() => AuditFormState();
}

class AuditFormState extends State<AuditDetailsScreen> {
  bool isLoading = false;
  String finalGrade = '';
  final _formKeyGuestOTP = GlobalKey<FormState>();

  Position? _currentPosition;
  bool hasInternet = true;
  String? selectedProductID;
  List<String> selectedSubProductIDsAsString = [];
  List<bool> selectedManagers = [];
  String currentAgencyID = "";
  List<int> scorableList = [];
  List<int> scoredList = [];
  String userEnteredOTP = '';
  List<dynamic> selectedLevel5Users = [];
  List<String> selectedLevel5Names=[];
  List<String> level5UserListKeys = [];
  List<dynamic> level5Users = [];
  TextEditingController textEditingController = TextEditingController();
  List<double> scoreInPercentage = [];
  List<dynamic> level4UserList=[];
  List<dynamic> selectedLevel4UserList=[];
  List<String> selectedLevel4AsString=[];
  List<String> phoneListAsString = [];
  List<String> emailListAsString = [];
  String? selectedPhone;
  String? selectedEmail;
  var agencySearchController = TextEditingController();

  List<dynamic> selectedSubProducts = [];
  List<dynamic> subProductList = [];

  List<String> levelByUserList = [];
  List<String> levelByUserListKeys = [];

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
  String? selectedAuditCycle = "Sept_2024";
  List<String> selectedSubProductAsString = [];

  int selectedCityIndex = 9999;
  int selectedAgencyIndex = 9999;
  int selectedManagerIndex = 9999;
  StateSetter? setStateGlobal;
  Map<String,dynamic> auditDetails={};
  Map<String,dynamic> parameterDetails={};
  int levelWiseCount=1;
  List<String> selectedLevel4Drop=[];
  List<String> selectedLevel5Drop=[];
  List<String> level4ListAsString=[];
  List<String> level5ListAsString=[];
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
                    Text("Audit Details",
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
                                            Text("Test Sheet",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                )),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      DropDownWidgetDisplay(
                                        () {

                                        },
                                        "Agency*",
                                        selectedAgencyIndex == 9999
                                            ? ""
                                            : agencyList[selectedAgencyIndex]["agency_id"].toString()+" "+agencyList[
                                                selectedAgencyIndex]["name"],
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
                                   /*       DateTime? pickedDate = await showDatePicker(
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
                                          }*/
                                        },
                                        child: Container(
                                          height: 41,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
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

                                           Container(
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
                                                        color: Colors.grey.withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                5),
                                                        border: Border.all(
                                                            color: Colors.black,
                                                            width: 0.5)),
                                                    child:
                                                        DropdownButtonHideUnderline(
                                                      child: DropdownButton2(
                                                        enableFeedback: false,
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
                                                                          14, color: Colors.black
                                                                    ),
                                                                  ),
                                                                ))
                                                            .toList(),
                                                        value: selectedProduct,
                                                        onChanged: null,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 12),
                                                  DropDownWidget2(() {

                                                  },
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
                                                              .withOpacity(0.7)
                                                          : Colors.black),
                                                  SizedBox(height: 12),
                                                  TextFieldWidgetNew(
                                                      "Agency Name",
                                                      "",
                                                      agencyNameController,
                                                      enabled: false),
                                                  SizedBox(height: 12),
                                                  TextFieldWidgetNew(
                                                      "Agency Manager",
                                                      "Enter Manager",
                                                      enabled: false,
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
                                                                          14, color: Colors.black
                                                                    ),
                                                                  ),
                                                                ))
                                                            .toList(),
                                                        value: selectedPhone,
                                                        onChanged:null,
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
                                                                          14, color: Colors.black
                                                                    ),
                                                                  ),
                                                                ))
                                                            .toList(),
                                                        value: selectedEmail,
                                                        onChanged: null,
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
                                                  Container(
                                                    // width: 80,
                                                    height: 45,
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
                                                                          14, color: Colors.black
                                                                    ),
                                                                  ),
                                                                ))
                                                            .toList(),
                                                        value: selectedlevel1,
                                                        onChanged: null
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 12),

                                                /*  DropDownWidgetArrow(() {

                                                  },
                                                      "Level 4",
                                                      selectedLevel4UserList
                                                          .length ==
                                                          0
                                                          ? "Select Level 4"
                                                          : selectedLevel4AsString
                                                          .toString()
                                                          .substring(
                                                          1,
                                                          selectedLevel4AsString
                                                              .toString()
                                                              .length -
                                                              1),
                                                      selectedLevel4AsString
                                                          .length ==
                                                          0
                                                          ? Colors.black
                                                          .withOpacity(0.7)
                                                          : Colors.black),


                                                  SizedBox(height: 12),



                                                  DropDownWidgetArrow(() {
                                                  //  selectLevel5BottomSheet(context);
                                                  },
                                                      "Level 5",
                                                      selectedLevel5Names
                                                          .length ==
                                                          0
                                                          ? "Select Level 5"
                                                          : selectedLevel5Names
                                                          .toString()
                                                          .substring(
                                                          1,
                                                          selectedLevel5Names
                                                              .toString()
                                                              .length -
                                                              1),
                                                      selectedLevel5Names
                                                          .length ==
                                                          0
                                                          ? Colors.black
                                                          .withOpacity(0.7)
                                                          : Colors.black),*/
                                                  SizedBox(height: 12),
                                                  GestureDetector(
                                                    onTap: () {

                                                    },
                                                    child: TextFieldWidgetNew(
                                                        "Geo tag",
                                                        "Tap here",
                                                        latLongController,
                                                        enabled: false),
                                                  ),


                                                  SizedBox(height: 5),


                                                  selectedLevel4Drop.length==0?Container():
                                                  ListView.builder(
                                                      itemCount: levelWiseCount,
                                                      shrinkWrap: true,
                                                      padding: EdgeInsets.zero,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      itemBuilder: (BuildContext context,int pos)

                                                      {
                                                        return Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                          //  SizedBox(height: 10),
                                                            pos==0?
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Row(
                                                                children: [



                                                                  Padding(padding: EdgeInsets.only(left: 5),

                                                                    child: Text("Level wise data",
                                                                        style: TextStyle(
                                                                          fontSize: 15,
                                                                          fontWeight: FontWeight.w500,
                                                                          color: Colors.blue,
                                                                        )),


                                                                  ),


                                                                  SizedBox(width: 10)
                                                                ],
                                                              ),
                                                            ):Container(),



                                                            Padding(
                                                              padding:
                                                              const EdgeInsets.only(
                                                                  left: 12),
                                                              child: Text("Level 4",
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
                                                              // height: 40,
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
                                                                      'Select Level 4',
                                                                      style: TextStyle(
                                                                        fontSize: 12,
                                                                        fontWeight:
                                                                        FontWeight.w500,
                                                                        color: Colors.black
                                                                            .withOpacity(
                                                                            0.7),
                                                                      )),
                                                                  items: level4ListAsString
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
                                                                  value: selectedLevel4Drop[pos],
                                                                  onChanged: null
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(height: 5),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets.only(
                                                                  left: 12),
                                                              child: Text("Level 5",
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
                                                              // height: 40,
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
                                                                      'Select Level 5',
                                                                      style: TextStyle(
                                                                        fontSize: 12,
                                                                        fontWeight:
                                                                        FontWeight.w500,
                                                                        color: Colors.black
                                                                            .withOpacity(
                                                                            0.7),
                                                                      )),
                                                                  items: level5ListAsString
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
                                                                  value: selectedLevel5Drop[pos],
                                                                  onChanged: null
                                                                ),
                                                              ),
                                                            ),

                                                            SizedBox(height: 12),

                                                          ],
                                                        );


                                                      }


                                                  )




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
                                                          MediaQuery.of(context)
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
                                                            data: Theme.of(context).copyWith(
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
                                                                    width: MediaQuery.of(
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
                                                                                Color(0xFF21317D).withOpacity(0.7),
                                                                          )),
                                                                    ),
                                                                  ),
                                                                  children: [
                                                                    SizedBox(
                                                                        height:
                                                                            5),
                                                                    ListView.builder(
                                                                        itemCount: questionList[pos]["subparameter"].length,
                                                                        shrinkWrap: true,
                                                                        padding: EdgeInsets.symmetric(horizontal: 5),
                                                                        physics: NeverScrollableScrollPhysics(),
                                                                        scrollDirection: Axis.vertical,
                                                                        itemBuilder: (BuildContext context, int index) {
                                                                          /*  answerListFinal[pos]["subs"].add(
                                                              {

                                                                "id":questionList[pos]["subparameter"][index]["id"].toString(),


                                                              }
                                                            );*/

                                                                          return Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                                                                child: Text(questionList[pos]["subparameter"][index]["sub_parameter"],
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
                                                                                      margin: EdgeInsets.symmetric(horizontal: 4),
                                                                                      padding: EdgeInsets.only(right: 5),
                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black, width: 0.5)),
                                                                                      child: DropdownButtonHideUnderline(
                                                                                        child: DropdownButton2(
                                                                                          menuItemStyleData: const MenuItemStyleData(
                                                                                            padding: EdgeInsets.only(left: 12),
                                                                                          ),
                                                                                          iconStyleData: IconStyleData(
                                                                                            icon: Icon(Icons.keyboard_arrow_down_outlined, color: Colors.black),
                                                                                          ),
                                                                                          isExpanded: true,
                                                                                          hint: Text('Choose Type',
                                                                                              style: TextStyle(
                                                                                                fontSize: 12,
                                                                                                fontWeight: FontWeight.w500,
                                                                                                color: Colors.black.withOpacity(0.7),
                                                                                              )),
                                                                                          items: answerList
                                                                                              .map((item) => DropdownMenuItem<String>(
                                                                                                    value: item,
                                                                                                    child: Text(
                                                                                                      item,
                                                                                                      style: const TextStyle(
                                                                                                        fontSize: 14, color: Colors.black
                                                                                                      ),
                                                                                                    ),
                                                                                                  ))
                                                                                              .toList(),
                                                                                          value: dropdownSelectionList[pos][index],
                                                                                          onChanged: null,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                        dropdownSelectionList[pos][index] == null
                                                                                      ? Container()
                                                                                      : Container(
                                                                                          width: 80,
                                                                                          height: 32,
                                                                                          margin: EdgeInsets.symmetric(horizontal: 2),
                                                                                          color: Colors.cyan,
                                                                                          child: Center(
                                                                                            child: Text(dropdownSelectionList[pos][index] == "Satisfactory" ? questionList[pos]["subparameter"][index]["weight"].toString() : "0",
                                                                                                style: TextStyle(
                                                                                                  fontSize: 12.5,
                                                                                                  fontWeight: FontWeight.w600,
                                                                                                  color: Colors.white,
                                                                                                )),
                                                                                          ),
                                                                                        )
                                                                                ],
                                                                              ),
                                                                              SizedBox(height: 10),
                                                                              Container(
                                                                                color:Colors.grey.withOpacity(0.1),
                                                                                // height: 41,
                                                                                margin: EdgeInsets.symmetric(horizontal: 4),
                                                                                child: TextFormField(
                                                                                  enabled:false,
                                                                                    style: const TextStyle(
                                                                                      fontSize: 13.0,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      color: Color(0xFF707070),
                                                                                    ),
                                                                                    maxLines: 3,
                                                                                    decoration: InputDecoration(
                                                                                        enabledBorder: OutlineInputBorder(
                                                                                          borderRadius: BorderRadius.circular(10.0),
                                                                                          borderSide: const BorderSide(color: Colors.black, width: 0.5),
                                                                                        ),


                                                                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0), borderSide: BorderSide(color: Colors.black, width: 0.5)),
                                                                                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0), borderSide: BorderSide(color: Colors.red, width: 0.5)),
                                                                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0), borderSide: BorderSide(color: Colors.black, width: 0.8)),
                                                                                        contentPadding: EdgeInsets.fromLTRB(7.0, 7.0, 5, 8),
                                                                                        //prefixIcon: fieldIC,
                                                                                        hintText: "Enter Remark here",
                                                                                        hintStyle: TextStyle(
                                                                                          fontSize: 12,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: Colors.black.withOpacity(0.7),
                                                                                        )),
                                                                                    controller: controllerList[pos][index]),
                                                                              ),
                                                                              SizedBox(height: 15),
                                                                              Row(
                                                                                children: [
                                                                                  Spacer(),
                                                                                  Card(
                                                                                    elevation: 4,
                                                                                    shadowColor: Colors.grey,
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(6.0),
                                                                                    ),
                                                                                    child: Container(
                                                                                      height: 46,
                                                                                      child: ElevatedButton(
                                                                                        style: ButtonStyle(
                                                                                            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                                                                            // background
                                                                                            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF93A6A2)),
                                                                                            // fore
                                                                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(6.0),
                                                                                            ))),
                                                                                        onPressed: () {
                                                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => ViewArtifactScreen(auditDetails["qm_sheet_id"].toString(), questionList[pos]["id"].toString(), questionList[pos]["subparameter"][index]["id"].toString(),  widget.auditID)));
                                                                                        },
                                                                                        child: const Text(
                                                                                          'Show Artifact',
                                                                                          style: TextStyle(
                                                                                            fontSize: 15.5,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            color: Colors.black,
                                                                                          ),
                                                                                          textAlign: TextAlign.center,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                               /*   SizedBox(width: 10),
                                                                                  Card(
                                                                                    elevation: 4,
                                                                                    shadowColor: Colors.grey,
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(6.0),
                                                                                    ),
                                                                                    child: Container(
                                                                                      height: 46,
                                                                                      child: ElevatedButton(
                                                                                        style: ButtonStyle(
                                                                                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                                                            // background
                                                                                            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF01075D)),
                                                                                            // fore
                                                                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(6.0),
                                                                                            ))),
                                                                                        onPressed: () {
                                                                                       //   Navigator.push(context, MaterialPageRoute(builder: (context) => UploadArtifactScreen(widget.sheetID, questionList[pos]["id"].toString(), questionList[pos]["subparameter"][index]["id"].toString(), "1456")));
                                                                                        },
                                                                                        child: const Text(
                                                                                          'Artifact',
                                                                                          style: TextStyle(
                                                                                            fontSize: 15.5,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                          textAlign: TextAlign.center,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),*/
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

                                              scorableList[pos]==0 && scoredList[pos]==0?

                                                  "0%":





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
                      /*    Row(
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
                          SizedBox(height: 10),*/
                        ],
                      ))
          ],
        ),
      ),
    );
  }

  checkValidations(String methodType) {
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
    } else if (selectedProduct == null) {
      Toast.show("Please select a Product",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else if (latLongController.text == "") {
      Toast.show("Location not found!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else if (agencyNameController.text == "") {
      Toast.show("Please select a Collection Manager",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else {
      bool flag = true;
      outerLoop:
      for (int i = 0; i < questionList.length; i++) {
        for (int j = 0;
            j < questionList[i]["subparameter"].length;
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
          } else if (controllerList[i][j].text == "") {
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

      // All Data Passed


    }
  }






  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInternet();

  }


  checkInternet() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      hasInternet = false;
      setState(() {});

    } else {
      hasInternet = true;
      setState(() {});


      viewAuditData(context);



   /*   fetchAgencies();
      fetchAuditCycleList();
      fetchUserList();*/
    }
  }



  fetchAgencies(String agencyID) async {
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

    for(int i=0;i<agencyList.length;i++)
      {
        if(agencyList[i]["id"].toString()==agencyID)
          {
            selectedAgencyIndex=i;
            break;
          }
      }


    fetchAgencyDetails();





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
        await helper.postAPIWithHeader('agency-details', requestModel, context);

    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    log(responseJSON.toString());

    agencyNameController.text = responseJSON["details"]["name"];
    agencyManagerNameController.text =
        responseJSON["details"]["agency_manager"]??"";
    agencyAddressController.text = responseJSON["details"]["address"];
    cityNameController.text = responseJSON["details"]["location"];
    locationNameController.text = responseJSON["details"]["location"];


    if(responseJSON["product"]!=null)
    {
      if(productListAsString.length!=0)
      {
        productListAsString.clear();
      }
      productListAsString.add(responseJSON["product"]["name"]);
      selectedProduct=responseJSON["product"]["name"];
      selectedProductID=responseJSON["product"]["id"].toString();
    }
    subProductList = responseJSON["sub_products"];

    for(int i=0;i<subProductList.length;i++)
    {
      selectedSubProductAsString.add(subProductList[i]["product_attribute_name"]);
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
    if (responseJSON["agency_mobile_number"].length != 0 && auditDetails["agency_mobile"]!=null) {
      selectedPhone=auditDetails["agency_mobile"].toString();
    }

    if (responseJSON["agency_email"].length != 0 && auditDetails["agency_email"]!=null) {
      selectedEmail=auditDetails["agency_email"];
    }



    setState(() {});
  }

  /*fetchManagerData(String productID) async {
    if (managerList.length != 0) {
      managerList.clear();
    }

    if (managerListAsString.length != 0) {
      managerListAsString.clear();
    }
    APIDialog.showAlertDialog(context, "Please wait...");
    var requestModel = {
      "type": widget.lobData["type"],
      "id": agencyList[selectedAgencyIndex]["id"].toString(),
      "product_id": productID
    };

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPIWithHeader('renderBranch', requestModel, context);

    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    managerList = responseJSON["data"]["managers_data"]["collection_manager"];
    selectedManagers = List<bool>.filled(managerList.length, false);
    setState(() {});
  }*/




  fetchQuestions() async {
    setState(() {
      isLoading = true;
    });
    var requestModel = {"qm_sheet_id": ""};

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



  fetchAuditCycleList(String selectedAuditID) async {
    var requestModel = {};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.getWithHeader('get_audit_cycle', requestModel, context);

    var responseJSON = json.decode(response.body);

    auditCycleList = responseJSON["details"];
    for (int i = 0; i < auditCycleList.length; i++) {
      auditCycleListAsString.add(auditCycleList[i]["name"]);
      if(auditCycleList[i]["id"].toString()==selectedAuditID)
        {
          selectedAuditCycle=auditCycleList[i]["name"];
        }
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
    List<String> keysList = [];
    keysList = data.keys.toList();
    levelByUserListKeys = keysList;
    print(responseJSON);
    print(data.keys.toList().toString());
    for (int i = 0; i < keysList.length; i++) {
      levelByUserList.add(data[keysList[i]]);
    }
    selectedlevel1 = levelByUserList[0].toString();
    selectedlevel2 = levelByUserList[0].toString();
    selectedlevel3 = levelByUserList[0].toString();
    setState(() {});
  }


  viewAuditData(BuildContext context) async {
    setState(() {
      isLoading=true;
    });
    var data = {
      "audit_id":widget.auditID
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('audit_sheet_edit', data, context);
    var responseJSON = json.decode(response.body);


    print(responseJSON.toString());


    auditDetails=responseJSON["data"]["audit_details"];
    parameterDetails=responseJSON["data"]["sheet_details"];
    questionList=responseJSON["data"]["sheet_details"]["parameter"];


    int totalScorer=0;
    int totalScored=0;
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

      for(int j=0;j<questionList[i]["subparameter"].length;j++)
        {
           totalScorer=totalScorer+int.parse(questionList[i]["subparameter"][j]["weight"].toString());
           print("Total Scoredd "+totalScored.toString());
           totalScored=totalScored+int.parse(questionList[i]["subparameter"][j]["score"].toString());
           controllerList[i][j].text=questionList[i]["subparameter"][j]["remark"].toString();

           dropdownSelectionList[i][j]=questionList[i]["subparameter"][j]["option_selected"];

           weightList[i][j]=questionList[i]["subparameter"][j]["score"].toString();
        }

      scorableList.add(totalScorer);
      scoredList.add(totalScored);
      scoreInPercentage.add((totalScored * 100) / totalScorer);
       totalScorer=0;
       totalScored=0;
      if (scorableList.length == 0) {
        finalGrade = "";
      } else if (scorableList.reduce((a, b) => a + b) == 0) {
        finalGrade = "";
      } else {
        double finalCal=scoredList.reduce(
                (a, b) =>
            a + b) *
            100 /
            scorableList
                .reduce((a,
                b) =>
            a + b);
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
        isLoading=false;
      });
    }

    fetchAgencies(auditDetails["agency_id"].toString());
    fetchAuditCycleList(auditDetails["audit_cycle_id"].toString());

    selectedDate=auditDetails["audit_date_by_aud"].toString();
    latLongController.text=auditDetails["latitude"].toString()+" , "+auditDetails["longitude"].toString();

    String? level3ID=auditDetails["lavel_3"].toString();
    String? level4ID=auditDetails["lavel_4"].toString();
    String? level5ID=auditDetails["lavel_5"].toString();


    fetchUserListEdit(level3ID,level4ID,level5ID);



    setState(() {

    });

  }


  fetchUserListEdit(String? level3ID,String? level4ID,String? level5ID) async {
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.get('formet_user_list', context);
    var responseJSON = json.decode(response.body);
    Map<String, dynamic> data = responseJSON["details"];
    Map<String, dynamic> dataLevel5={};
    if(responseJSON["Level_5"].isNotEmpty)
    {
      dataLevel5 = responseJSON["Level_5"];
    }

    List<String> keysList = [];
    List<String> keysListLevel5 = [];
    keysList = data.keys.toList();
    keysListLevel5 = dataLevel5.keys.toList();
    levelByUserListKeys = keysList;
    level5UserListKeys = keysListLevel5;

    List<String> level5Data=[];


    for (int i = 0; i < keysListLevel5.length; i++) {
      level5Data.add(dataLevel5[keysListLevel5[i]]);
    }
    print(responseJSON);
    print(data.keys.toList().toString());

    for (int i = 0; i < keysListLevel5.length; i++) {

      level5Users.add({
        "id":keysListLevel5[i],
        "name":level5Data[i]
      });
    }
    for(int i=0;i<level5Users.length;i++)
    {
      level5ListAsString.add(level5Users[i]["name"]);

    }

    print("LITTT");
    print(level5Users.toString());

    for (int i = 0; i < keysList.length; i++) {
      levelByUserList.add(data[keysList[i]]);
    }

    for (int i = 0; i < keysList.length; i++) {
      level4UserList.add({
        "id":keysList[i],
        "name":levelByUserList[i]
      });
    }

    for(int i=0;i<level4UserList.length;i++)
    {
      level4ListAsString.add(level4UserList[i]["name"]);

    }

    print("LITTT22");
    print(level4UserList.toString());
    for(int i=0;i<level4UserList.length;i++)
    {
      if(level3ID==level4UserList[i]["id"].toString())
      {
        selectedlevel1=level4UserList[i]["name"];
      }
    }
    List<String> level4IDList = level4ID.toString().split(",");
    print("Level 4 ID"+level4IDList.toString());

    for(int i=0;i<level4UserList.length;i++)
    {
      for(int j=0;j<level4IDList.length;j++)
      {
        if(level4IDList[j]==level4UserList[i]["id"].toString())
        {
          print("Match F9ound");


          selectedLevel4Drop.add(level4UserList[i]["name"]);


          /*  selectedLevel4UserList.add(level4UserList[i].toString());
            selectedLevel4AsString.add(level4UserList[i]["name"]);*/
        }
      }
    }

    print("Selected Managers "+selectedLevel4UserList.toString());


    List<String> level5IDList = level5ID.toString().split(",");
    levelWiseCount=level5IDList.length;

    for(int i=0;i<level5Users.length;i++)
    {

      for(int j=0;j<level5IDList.length;j++)
      {
        if(level5IDList[j]==level5Users[i]["id"].toString())
        {
          selectedLevel5Drop.add(level5Users[i]["name"]);
          /*  selectedLevel5Users.add(level5Users[i].toString());
          selectedLevel5Names.add(level5Users[i]["name"]);*/
        }
      }
    }





    setState(() {});
  }

}
