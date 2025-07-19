import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

class EditAuditFormScreen extends StatefulWidget {
 /* final String sheetID;
  final String sheetName;
  Map<String, dynamic> lobData;*/

  String sheetID;
  String sheetName;
  String sheetType;
  String auditID;
  String auditDate;
  String auditCycle;

  bool copy;



  EditAuditFormScreen(this.sheetID,this.sheetName,this.sheetType,this.auditID,this.auditDate,this.auditCycle,this.copy);

  AuditFormState createState() => AuditFormState();
}

class AuditFormState extends State<EditAuditFormScreen> {
  bool isLoading = false;
  String sheetID="";
  String finalGrade = '';
  bool hasInternet=true;
  String auditID="";
  List<bool> selectedManagers = [];
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
  List<dynamic> filteredCityList = [];
  List<dynamic> filterManagerList = [];
  List<dynamic> filteredAgencyList = [];

  String? selectedDate;
  var agencyNameController = TextEditingController();
  var agencyManagerNameController = TextEditingController();
  var agencyPhoneController = TextEditingController();
  var agencyAddressController = TextEditingController();
  var branchNameController = TextEditingController();
  var cityNameController = TextEditingController();
  var locationNameController = TextEditingController();
  var latLongController = TextEditingController();
  List<TextEditingController> managerEmpCodeController = [];
  List<TextEditingController> regionalManagerController = [];
  List<TextEditingController> zonalManagerController = [];
  List<TextEditingController> nationalManagerController = [];
  List<dynamic> cityList = [];

  Map<String,dynamic> auditData={};
  Map<String,dynamic> sheetData={};
  List<dynamic> questionList = [];

  List<dynamic> managerList = [];
  List<String> auditCycleListAsString = [];

  List<dynamic> auditCycleList = [];

  List<dynamic> agencyList = [];

  List<dynamic> productList = [];
  List<String> productListAsString = [];

  List<String> answerList = [
    "No",
    "Yes",
  ];

  List<String> lobListAsString = [];

  List<dynamic> lobList = [];

  String? selectedLOB;
  String? selectedAnswer;
  String? selectedProduct;
  String? selectedAuditCycle;

  int selectedCityIndex = 9999;
  int selectedAgencyIndex = 9999;
  int selectedManagerIndex = 9999;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 25),
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
                      padding: const EdgeInsets.only(top: 8),
                      children: [
                        !hasInternet?Container():
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                              border:
                                  Border.all(color: Colors.black, width: 0.7)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 46,
                                color: AppTheme.themeColor,
                                child: Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Text(widget.sheetName,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12),




                              DropDownWidget(() {
                                selectCityBottomSheet(context);
                              },
                                  "City",
                                  selectedCityIndex == 9999
                                      ? "Select city"
                                      : filteredCityList[selectedCityIndex]["name"],Colors.black.withOpacity(0.7)),

                              SizedBox(height: 12),

                              DropDownWidget(() {
                                selectAgencyBottomSheet(context);
                              },
                                  widget.sheetType == "repo_yard"?"Yard":
                                  "Agency",
                                  selectedAgencyIndex == 9999
                                      ?widget.sheetType == "repo_yard"?"Select yard":"Select agency"
                                      : filteredAgencyList[selectedAgencyIndex]
                                          ["name"],Colors.black.withOpacity(0.7)),



                              SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text("LOB",
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
                                    border: Border.all(
                                        color: Colors.black, width: 0.5)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    menuItemStyleData: const MenuItemStyleData(
                                      padding: EdgeInsets.only(left: 12),
                                    ),
                                    iconStyleData: IconStyleData(
                                      icon: Icon(
                                          Icons.keyboard_arrow_down_outlined,
                                          color: Colors.black),
                                    ),
                                    isExpanded: true,
                                    hint: Text('Select lob',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black.withOpacity(0.7),
                                        )),
                                    items: lobListAsString
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
                                    value: selectedLOB,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedLOB = value as String;
                                      });

                                      if (selectedLOB == "Non X") {
                                        agencyNameController.text = "";
                                        agencyPhoneController.text = "";
                                        agencyAddressController.text = "";
                                        branchNameController.text = "";
                                        cityNameController.text = "";
                                        locationNameController.text = "";
                                        agencyManagerNameController.text = "";

                                        setState(() {});
                                      } else {
                                        fetchManagerDataRecovery("0");
                                      }
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text("Audit Cycle",
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
                                    border: Border.all(
                                        color: Colors.black, width: 0.5)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    menuItemStyleData: const MenuItemStyleData(
                                      padding: EdgeInsets.only(left: 12),
                                    ),
                                    iconStyleData: IconStyleData(
                                      icon: Icon(
                                          Icons.keyboard_arrow_down_outlined,
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
                                child: Text("Audit Date",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.7),
                                    )),
                              ),
                              SizedBox(height: 2),
                              GestureDetector(
                                onTap: () async {
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
                                    selectedDate = formattedDate.toString();
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  height: 41,
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Colors.black, width: 0.5)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 7),
                                          child: Text(
                                              selectedDate == null
                                                  ? "Select date"
                                                  : selectedDate.toString(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black
                                                    .withOpacity(0.7),
                                              )),
                                        ),
                                      ),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Icon(Icons.calendar_month,
                                              color: AppTheme.themeColor)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              selectedLOB == "Non X"
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Text("Product",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Colors.black.withOpacity(0.7),
                                          )),
                                    )
                                  : Container(),
                              selectedLOB == "Non X"
                                  ? SizedBox(height: 2)
                                  : Container(),
                              selectedLOB == "Non X"
                                  ? Container(
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
                                          hint: Text('Select Product',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black
                                                    .withOpacity(0.7),
                                              )),
                                          items: productListAsString
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
                                          value: selectedProduct,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedProduct = value as String;
                                            });

                                            String productID = "";

                                            for (int i = 0;
                                                i < productList.length;
                                                i++) {
                                              if (productList[i]["name"] ==
                                                  selectedProduct) {
                                                productID = productList[i]["id"]
                                                    .toString();
                                              }
                                            }

                                            fetchManagerDataRecovery(productID);
                                          },
                                        ),
                                      ),
                                    )
                                  : Container(),
                              selectedLOB == "Non X"
                                  ? SizedBox(height: 12)
                                  : Container(),
                              selectedLOB == null
                                  ? Container()
                                  : widget.sheetType == "repo_yard"
                                      ? TextFieldWidgetNew("Yard Name",
                                          "Enter yard", agencyNameController)
                                      : TextFieldWidgetNew("Agency Name",
                                          "Enter agency", agencyNameController),
                              selectedLOB == null
                                  ? Container()
                                  : SizedBox(height: 12),
                              selectedLOB == null
                                  ? Container()
                                  : Row(
                                      children: [
                                        widget.sheetType == "repo_yard"
                                            ? Expanded(
                                                child: TextFieldWidgetNew(
                                                    "Yard Manager",
                                                    "Enter yard manager",
                                                    agencyManagerNameController),
                                                flex: 1)
                                            : Expanded(
                                                child: TextFieldWidgetNew(
                                                    "Agency Manager",
                                                    "Enter Manager",
                                                    agencyManagerNameController),
                                                flex: 1),
                                        widget.sheetType == "repo_yard"
                                            ? Expanded(
                                                child: TextFieldWidgetNew(
                                                    "Yard Phone",
                                                    "Enter Number",
                                                    agencyPhoneController),
                                                flex: 1)
                                            : Expanded(
                                                child: TextFieldWidgetNew(
                                                    "Agency Phone",
                                                    "Enter Number",
                                                    agencyPhoneController),
                                                flex: 1),
                                      ],
                                    ),
                              selectedLOB == null
                                  ? Container()
                                  : SizedBox(height: 12),
                              selectedLOB == null
                                  ? Container()
                                  : widget.sheetType == "repo_yard"
                                      ? TextFieldWidgetNew(
                                          "Yard Address",
                                          "Enter Address",
                                          agencyAddressController)
                                      : TextFieldWidgetNew(
                                          "Agency Address",
                                          "Enter Address",
                                          agencyAddressController),
                              selectedLOB == null
                                  ? Container()
                                  : SizedBox(height: 12),
                              selectedLOB == null
                                  ? Container()
                                  : Row(
                                      children: [
                                        Expanded(
                                            child: TextFieldWidgetNew(
                                                "Branch Name",
                                                "Enter branch name",
                                                branchNameController),
                                            flex: 1),
                                        Expanded(
                                            child: TextFieldWidgetNew(
                                                "City",
                                                "Enter city",
                                                cityNameController),
                                            flex: 1),
                                      ],
                                    ),
                              selectedLOB == null
                                  ? Container()
                                  : SizedBox(height: 12),
                              selectedLOB == null
                                  ? Container()
                                  : TextFieldWidgetNew(
                                      "Location", "-", locationNameController),
                              selectedLOB == null
                                  ? Container()
                                  : SizedBox(height: 12),
                              selectedLOB == null
                                  ? Container()
                                  : TextFieldWidgetNew("Lattitude,Longitude",
                                      "26.7898,83.3777", latLongController,
                                      enabled: false),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                        !hasInternet?Container():
                        SizedBox(height: 18),
                        !hasInternet?Container():
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                              border:
                                  Border.all(color: Colors.black, width: 0.7)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 43,
                                color: AppTheme.themeColor,
                                child: Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Text("Collection Manager",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              DropDownWidget(() {
                                selectManagerBottomSheet(context);
                              },
                                  "Collection Manager",
                                  managerListAsString.length == 0
                                      ? "Select Collection Manager"
                                      : managerListAsString
                                          .toString()
                                          .substring(
                                              1,
                                              managerListAsString
                                                      .toString()
                                                      .length -
                                                  1),Colors.black.withOpacity(0.7)),
                              // SizedBox(height: 22),

                              selectedManagersList.length != 0
                                  ? SizedBox(height: 15)
                                  : SizedBox(height: 22),

                              ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: selectedManagersList.length,
                                  itemBuilder: (BuildContext context, int pos) {
                                    return Column(
                                      children: [
                                        Container(
                                          height: 39,
                                          color: Colors.blue.withOpacity(0.3),
                                          child: Row(
                                            children: [
                                              SizedBox(width: 10),
                                              Text(
                                                  selectedManagersList[pos]
                                                      ["name"],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        TextFieldWidgetNew("Manager Emp Code",
                                            "-", managerEmpCodeController[pos]),
                                        SizedBox(height: 12),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Row(
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
                                                          'Area Collection Manager',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.7),
                                                          )),
                                                      items:
                                                          areaManagerListAsString
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
                                                          selectedDropCollectionManager[
                                                              pos],
                                                      onChanged: (value) {
                                                        selectedDropCollectionManager[
                                                                pos] =
                                                            value as String;

                                                        setState(() {});
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        TextFieldWidgetNew(
                                            "Regional Collection Manager",
                                            "-",
                                            regionalManagerController[pos]),
                                        SizedBox(height: 12),
                                        TextFieldWidgetNew(
                                            "Zonal Collection Manager",
                                            "-",
                                            zonalManagerController[pos]),
                                        SizedBox(height: 12),
                                        TextFieldWidgetNew(
                                            "National Collection Manager",
                                            "-",
                                            nationalManagerController[pos]),
                                        SizedBox(height: 12),
                                      ],
                                    );
                                  })
                            ],
                          ),
                        ),
                        !hasInternet?Container():
                        SizedBox(height: 18),


                        !hasInternet?


                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8)),
                                border:
                                Border.all(color: Colors.black, width: 0.7)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 46,
                                  color: AppTheme.themeColor,
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Text(widget.sheetName,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12),










                                TextFieldWidgetNew("City Name",
                                    "Enter city", cityNameController),


                                SizedBox(height: 12),


                                TextFieldWidgetNew("Agency Name",
                                    "Enter agency", agencyNameController),
                                SizedBox(height: 12),

                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Text("Audit Date",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black.withOpacity(0.7),
                                      )),
                                ),
                                SizedBox(height: 2),
                                GestureDetector(
                                  onTap: () async {
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
                                      selectedDate = formattedDate.toString();
                                      setState(() {});
                                    }
                                  },
                                  child: Container(
                                    height: 41,
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: Colors.black, width: 0.5)),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(left: 7),
                                            child: Text(
                                                selectedDate == null
                                                    ? "Select date"
                                                    : selectedDate.toString(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                )),
                                          ),
                                        ),
                                        Padding(
                                            padding:
                                            const EdgeInsets.only(right: 10),
                                            child: Icon(Icons.calendar_month,
                                                color: AppTheme.themeColor)),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: 12),


                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ):Container(),







                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                              border:
                                  Border.all(color: Colors.black, width: 0.7)),
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
                                  itemBuilder: (BuildContext context, int pos) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Card(
                                            elevation: 3,
                                            color: Colors.white,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      questionList[pos]
                                                          ["parameter"],
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.blue,
                                                      )),
                                                  SizedBox(height: 5),
                                                  ListView.builder(
                                                      itemCount: questionList[
                                                                  pos][
                                                              "qm_sheet_sub_parameter"]
                                                          .length,
                                                      shrinkWrap: true,
                                                      padding: EdgeInsets.zero,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        /*  answerListFinal[pos]["subs"].add(
                                                          {

                                                            "id":questionList[pos]["qm_sheet_sub_parameter"][index]["id"].toString(),


                                                          }
                                                        );*/

                                                        return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          4),
                                                              child: Text(
                                                                  questionList[pos]
                                                                              [
                                                                              "qm_sheet_sub_parameter"]
                                                                          [
                                                                          index]
                                                                      [
                                                                      "sub_parameter"],
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                  )),
                                                            ),
                                                            SizedBox(height: 5),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    // width: 80,
                                                                    height: 40,
                                                                    margin: EdgeInsets
                                                                        .symmetric(
                                                                            horizontal:
                                                                                4),
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            right:
                                                                                5),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10),
                                                                        border: Border.all(
                                                                            color:
                                                                                Colors.black,
                                                                            width: 0.5)),
                                                                    child:
                                                                        DropdownButtonHideUnderline(
                                                                      child:
                                                                          DropdownButton2(
                                                                        menuItemStyleData:
                                                                            const MenuItemStyleData(
                                                                          padding:
                                                                              EdgeInsets.only(left: 12),
                                                                        ),
                                                                        iconStyleData:
                                                                            IconStyleData(
                                                                          icon: Icon(
                                                                              Icons.keyboard_arrow_down_outlined,
                                                                              color: Colors.black),
                                                                        ),
                                                                        isExpanded:
                                                                            true,
                                                                        hint: Text(
                                                                            'Choose Type',
                                                                            style:
                                                                                TextStyle(
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
                                                                                      fontSize: 14,
                                                                                    ),
                                                                                  ),
                                                                                ))
                                                                            .toList(),
                                                                        value: dropdownSelectionList[pos]
                                                                            [
                                                                            index],
                                                                        onChanged:
                                                                            (value) {
                                                                          dropdownSelectionList[pos][index] =
                                                                              value as String;

                                                                          if (dropdownSelectionList[pos][index] ==
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
                                                                          }

                                                                          setState(
                                                                              () {});
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                dropdownSelectionList[pos]
                                                                            [
                                                                            index] ==
                                                                        null
                                                                    ? Container()
                                                                    : Container(
                                                                        width:
                                                                            80,
                                                                        height:
                                                                            32,
                                                                        margin: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                2),
                                                                        color: Colors
                                                                            .cyan,
                                                                        child:
                                                                            Center(
                                                                          child: Text(
                                                                              double.parse(weightList[pos][index]).toStringAsFixed(2),
                                                                              style: TextStyle(
                                                                                fontSize: 12.5,
                                                                                fontWeight: FontWeight.w600,
                                                                                color: Colors.white,
                                                                              )),
                                                                        ),
                                                                      )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            Container(
                                                              // height: 41,
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          4),
                                                              child: TextFormField(
                                                                  style: const TextStyle(
                                                                    fontSize:
                                                                        13.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Color(
                                                                        0xFF707070),
                                                                  ),
                                                                  maxLines: 3,
                                                                  decoration: InputDecoration(
                                                                      enabledBorder: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                        borderSide: const BorderSide(
                                                                            color:
                                                                                Colors.black,
                                                                            width: 0.5),
                                                                      ),
                                                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0), borderSide: BorderSide(color: Colors.black, width: 0.5)),
                                                                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0), borderSide: BorderSide(color: Colors.red, width: 0.5)),
                                                                      border: InputBorder.none,
                                                                      contentPadding: EdgeInsets.fromLTRB(7.0, 7.0, 5, 8),
                                                                      //prefixIcon: fieldIC,
                                                                      hintText: "Enter Remark here",
                                                                      hintStyle: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.7),
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
                                                                  shadowColor:
                                                                      Colors
                                                                          .grey,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            6.0),
                                                                  ),
                                                                  child:
                                                                      Container(
                                                                    height: 46,
                                                                    child:
                                                                        ElevatedButton(
                                                                      style: ButtonStyle(
                                                                          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                                                          // background
                                                                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF93A6A2)),
                                                                          // fore
                                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(6.0),
                                                                          ))),
                                                                      onPressed:
                                                                          () {

                                                                          //  Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewArtifactScreen(sheetID,questionList[pos]["id"].toString(),questionList[pos]["qm_sheet_sub_parameter"][index]["id"].toString(),"1456")));


                                                                          },
                                                                      child:
                                                                          const Text(
                                                                        'Show Artifact',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              15.5,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width: 10),
                                                                Card(
                                                                  elevation: 4,
                                                                  shadowColor:
                                                                      Colors
                                                                          .grey,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            6.0),
                                                                  ),
                                                                  child:
                                                                      Container(
                                                                    height: 46,
                                                                    child:
                                                                        ElevatedButton(
                                                                      style: ButtonStyle(
                                                                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                                          // background
                                                                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF01075D)),
                                                                          // fore
                                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(6.0),
                                                                          ))),
                                                                      onPressed:
                                                                          () {

                                                                    //    Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadArtifactScreen(sheetID,questionList[pos]["id"].toString(),questionList[pos]["qm_sheet_sub_parameter"][index]["id"].toString(),"1456")));


                                                                          },
                                                                      child:
                                                                          const Text(
                                                                        'Artifact',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              15.5,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        textAlign:
                                                                            TextAlign.center,
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
                                              ),
                                            )),
                                        SizedBox(height: 17),
                                      ],
                                    );
                                  })
                            ],
                          ),
                        ),
                        SizedBox(height: 14),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                          margin: EdgeInsets.symmetric(horizontal: 17),
                          decoration: BoxDecoration(
                              color: Color(0xFFFF5100),
                              borderRadius: BorderRadius.circular(4)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Scorable:',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white.withOpacity(0.8),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    '100',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white.withOpacity(0.8),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    'Scored:',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white.withOpacity(0.8),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    double.parse(totalScore).toStringAsFixed(2),
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white.withOpacity(0.8),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    'Scored%:',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white.withOpacity(0.8),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    double.parse(totalScore)
                                            .toStringAsFixed(2) +
                                        '%',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white.withOpacity(0.8),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    'Grade:',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white.withOpacity(0.8),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    finalGrade,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white.withOpacity(0.8),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
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

                                    if(hasInternet)
                                      {
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

                            !hasInternet?Container():
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
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white), // background
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color(0xFF841921)), // fore
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ))),
                                  onPressed: () {
                                    print(selectedManagersList.toString());

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
    );
  }




  checkValidations(String methodType) {
    if (selectedCityIndex == 9999) {
      Toast.show("Please select a city name!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else if (selectedAgencyIndex == 9999) {
      Toast.show("Please select a Agency name",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else if (selectedLOB == null) {
      Toast.show("Please select a LOB",
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
    } else if (selectedManagersList.length == 0) {
      Toast.show("Please select at least one collection manager",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else {
      for (int i = 0; i < questionList.length; i++) {
        for (int j = 0;
            j < questionList[i]["qm_sheet_sub_parameter"].length;
            j++) {
          if (dropdownSelectionList[i][j] == null) {
            Toast.show(
                "Please choose option for Question " + (j + 1).toString(),
                duration: Toast.lengthLong,
                gravity: Toast.bottom,
                backgroundColor: Colors.red);
            break;
          } else if (controllerList[i][j] == "") {
            Toast.show("Please enter remark for Question " + (j + 1).toString(),
                duration: Toast.lengthLong,
                gravity: Toast.bottom,
                backgroundColor: Colors.red);
            break;
          }
        }
      }

      // All Data Passed

      prepareData(methodType);
    }
  }

  prepareData(String methodType) async {
    APIDialog.showAlertDialog(context, "Submitting details...");

    String auditCycleID = "";

    for (int i = 0; i < auditCycleList.length; i++) {
      if (selectedAuditCycle == auditCycleList[i]["name"]) {
        auditCycleID = auditCycleList[i]["id"].toString();
        break;
      }
    }

    String productID = "";

    if (selectedLOB == "Non X") {
      productID = "0";
    } else {
      for (int i = 0; i < productList.length; i++) {
        if (selectedProduct == productList[i]["name"]) {
          productID = productList[i]["id"].toString();
          break;
        }
      }
    }

    List<dynamic> managersData = [];

    for (int i = 0; i < selectedManagersList.length; i++) {
      managersData.add({
        "CM_id": selectedManagersList[i]["id"].toString(),
        "CM_Emp_Id": selectedManagersList[i]["emp_id"].toString(),
        "acm_Id": selectedManagersList[i]["acm_id"].toString(),
        "CM_name": selectedManagersList[i]["name"]
      });
    }

    List<dynamic> parameterList = [];

    for (int i = 0; i < questionList.length; i++) {
      for (int j = 0;
          j < questionList[i]["qm_sheet_sub_parameter"].length;
          j++) {
        parameterList.add({
          "id": questionList[i]["id"].toString(),
          "score": "0",
          "score_with_fatal": "0",
          "score_without_fatal": "0",
          "temp_total_weightage": "0",
          "parameter_weight": "0",
          "subs": [
            {
              "id":
                  questionList[i]["qm_sheet_sub_parameter"][j]["id"].toString(),
              "remark": controllerList[i][j].text,
              "orignal_weight": weightList[i][j],
              "is_percentage": "0",
              "selected_per": "",
              "option": dropdownSelectionList[i][j],
              "temp_weight": weightList[i][j],
              "score": weightList[i][j]
            }
          ]
        });
      }
    }

    var requestModel = {
      "submission_data": {
        "token": AppModel.token,
        "qm_sheet_id": sheetID,
        "audit_id": auditID,
        "audit_date_by_aud": selectedDate,
        "selected_city_id": cityList[selectedCityIndex]["id"].toString(),
        "audit_cycle_id": auditCycleID,
        "geotag": "26.7970494,83.3776651",
        "overall_score": "0",
        "with_fatal_score_per": "0",
        widget.sheetType + "_id":
            agencyList[selectedAgencyIndex]["id"].toString(),
        "sheet_type": widget.sheetType,
        "product_id": productID,
        "collection_manager_id": "",
        "status": "submit",
        "artifactIds": "{}",
        "agency_manager": agencyManagerNameController.text,
        "agency_phone": agencyPhoneController.text.toString(),
        "agency_address": agencyAddressController.text,
        "agency_city": cityNameController.text,
        "agency_location": locationNameController.text,
        "agency_name": agencyNameController.text,
        "branch_name": branchNameController.text,
        "lob": selectedLOB,
        "collection_manager": managersData,
      },
      "parameters": parameterList
    };

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPIWithHeader('storeAudit', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    if (responseJSON['status'] == 1) {



      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      Navigator.pop(context);
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
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

                        bottomSheetState((){
                          filteredCityList = cityList
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

                        bottomSheetState((){
                          filterManagerList = managerList
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
                                      managerListAsString
                                          .remove(filterManagerList[pos]["name"]);
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
                    Text("Select "+widget.sheetType=="repo_yard"?"Yard":"Agency",
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
                SizedBox(height: 5),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
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
                                    child: Text(filteredAgencyList[pos]["name"],
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
                        if (selectedAgencyIndex != 9999) {
                          Navigator.pop(context);
                          setState(() {});

                          fetchProducts();
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
    auditID=widget.auditID;
    sheetID=sheetID;
   checkInternet();
   print(sheetID);

  }


  saveInSharedPrefrences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String json = jsonEncode(questionList);
    await preferences.setString('question_list'+sheetID,json);
  }

  checkInternet()async{
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());

    if(connectivityResult.contains(ConnectivityResult.none))
    {
      hasInternet=false;
      setState(() {

      });
      fetchLocalData();
    }
    else
    {
      hasInternet=true;
      setState(() {

      });


    if(widget.copy)
      {
        duplicateAudit();
      }
    else
      {
        fetchAuditDetails();
      }



   //   fetchCities();
    }
  }

  fetchAuditDetails() async {
    setState(() {
      isLoading = true;
    });
    var requestModel = {"audit_id":auditID};

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPIWithHeader('audit_sheet_edit', requestModel, context);
    setState(() {
      isLoading = false;
    });
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    sheetID=responseJSON["data"]["audit_details"]["qm_sheet_id"].toString();
    auditData=responseJSON["data"]["audit_details"];
    sheetData=responseJSON["data"]["sheet_details"];

    fetchCities();


   /* cityList = responseJSON["data"]["cities"];
    questionList = responseJSON["data"]["data"]["parameter"];

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

    auditCycleList = responseJSON["data"]["cycle"];
    for (int i = 0; i < auditCycleList.length; i++) {
      auditCycleListAsString.add(auditCycleList[i]["name"]);
    }

    lobList = responseJSON["data"]["bucket"];
    for (int i = 0; i < lobList.length; i++) {
      lobListAsString.add(lobList[i]["lob"]);
    }*/


    setState(() {});
  }

  fetchLocalData() async {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    var data=prefs.getString("question_list");
    if(data!=null)
    {
      List<dynamic> list2 = jsonDecode(data);
      print("Data LENGTH"+list2.length.toString());


      for(int i=0;i<list2.length;i++)
        {
          print("Sheet IU "+list2[i]["sheet_id"].toString());
          if(sheetID==list2[i]["sheet_id"].toString())
            {
              print("Match Found");

              questionList=list2[i]["p_data"];
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











      setState(() {

      });
    }
    else
    {
      Toast.show("No Internet!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  duplicateAudit() async {

    APIDialog.showAlertDialog(context, "Please wait...");
    var requestModel = {
      "audit_id": auditID
    };

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(
        'duplicate_audit', requestModel, context);

    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if(responseJSON["status"]==1)
      {
        Toast.show(responseJSON['message'],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.green);
        auditID=responseJSON["data"]["audit_id"].toString();
        fetchAuditDetails();





      }
    else
      {
        Toast.show(responseJSON['message'],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
        Navigator.pop(context);

      }

  }

  fetchAgencies() async {
    if (agencyList.length != 0) {
      agencyList.clear();
    }
    APIDialog.showAlertDialog(context, "Please wait...");
    var requestModel = {
      "city_name": cityList[selectedCityIndex]["name"],
      "type": widget.sheetType,
      "lob": widget.sheetName,
    };

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(
        'get_agencies_from_city', requestModel, context);

    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    agencyList = responseJSON["data"];
    filteredAgencyList = responseJSON["data"];
    String agencyID="";
    if(widget.sheetType=="agency_repo"){
      agencyID=auditData["agency_repo_id"].toString();

    }else if(widget.sheetType=="repo_yard"){

      agencyID=auditData["yard_id"].toString();
    }else if(widget.sheetType=="agency"){
     agencyID=auditData["agency_id"].toString();
    }



    if(agencyID!="")
      {
        for(int i=0;i<agencyList.length;i++)
          {

            if(agencyID==agencyList[i]["id"].toString())
              {
                selectedAgencyIndex=i;
                if(selectedLOB=="Non X")
                  {
                    fetchProducts();
                  }
                else
                  {
                    fetchManagerDataRecovery("0");
                  }
                break;
              }




          }



      }









   /* lobList = responseJSON["data"]["bucket"];
    for (int i = 0; i < lobList.length; i++) {
      lobListAsString.add(lobList[i]["lob"]);
    }
*/
    setState(() {});
  }

  fetchProducts() async {
    if (productList.length != 0) {
      productList.clear();
      productListAsString.clear();
    }
    APIDialog.showAlertDialog(context, "Please wait...");
    var requestModel = {
      "type": widget.sheetType,
      "id": agencyList[selectedAgencyIndex]["id"].toString()
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




    if(auditData["product_id"].toString()=="0" || auditData["product_id"].toString()==null)
      {

        fetchManagerDataRecovery("0");
      }
    else
      {
        fetchManagerDataRecovery(auditData["product_id"].toString());
      }












    setState(() {});
  }

  fetchManagerDataRecovery(String productID) async {
   /* if (productList.length != 0) {
      productList.clear();
      productListAsString.clear();
    }*/
    if (managerList.length != 0) {
      managerList.clear();
    }

    if (managerListAsString.length != 0) {
      managerListAsString.clear();
    }

    if (areaManagerListAsString.length != 0) {
      areaManagerListAsString.clear();
    }

    if (areaManagerList.length != 0) {
      areaManagerList.clear();
    }

    if (selectedManagersList.length != 0) {
      selectedManagersList.clear();
    }

    APIDialog.showAlertDialog(context, "Please wait...");
    var requestModel = {
      "type": widget.sheetType,
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
    log(responseJSON.toString());
    managerList = responseJSON["data"]["managers_data"]["collection_manager"];
    filterManagerList = responseJSON["data"]["managers_data"]["collection_manager"];
    print("Collection Manager List");
    log(managerList.toString());
    areaManagerList =
        responseJSON["data"]["managers_data"]["area_collection_manager"];

    areaManagerListAsString.add("Please select");

    for (int i = 0; i < areaManagerList.length; i++) {
      selectedDropCollectionManager.add("Please select");
      managerEmpCodeController.add(TextEditingController());
      regionalManagerController.add(TextEditingController());
      zonalManagerController.add(TextEditingController());
      nationalManagerController.add(TextEditingController());
      areaManagerListAsString.add(areaManagerList[i]["name"]);
    }

    selectedManagers = List<bool>.filled(managerList.length, false);

    if (widget.sheetType == "repo_yard") {
      print("REPO DATA");
      print(responseJSON["data"]["yard"].toString());
      print(responseJSON["data"]["branch_detail"].toString());
      agencyNameController.text = responseJSON["data"]["yard"]["name"];
      agencyPhoneController.text =
          responseJSON["data"]["yard"]["agency_phone"] ?? "";
      agencyAddressController.text =
          responseJSON["data"]["yard"]["address"] ?? "";
      branchNameController.text =
          responseJSON["data"]["branch_detail"]["name"] ?? "";
      cityNameController.text =
          responseJSON["data"]["branch_detail"]["city"] ?? "";
      locationNameController.text = responseJSON["data"]["yard"]["city"] ?? "";
    } else if(widget.sheetType=="agency_repo"){
      agencyNameController.text = responseJSON["data"]["agencyRepo"]["name"];
      agencyPhoneController.text =
          responseJSON["data"]["agencyRepo"]["agency_phone"] ?? "";
      agencyAddressController.text =
          responseJSON["data"]["agencyRepo"]["addresss"] ?? "";
      branchNameController.text =
          responseJSON["data"]["branch_detail"]["name"] ?? "";
      cityNameController.text =
          responseJSON["data"]["branch_detail"]["name"] ?? "";
      locationNameController.text =
          responseJSON["data"]["agencyRepo"]["location"] ?? "";
    }
    else
      {
        agencyNameController.text = responseJSON["data"]["agency"]["name"];
        agencyPhoneController.text =
            responseJSON["data"]["agency"]["agency_phone"] ?? "";
        agencyAddressController.text =
            responseJSON["data"]["agency"]["addresss"] ?? "";
        branchNameController.text =
            responseJSON["data"]["branch_detail"]["name"] ?? "";
        cityNameController.text =
            responseJSON["data"]["branch_detail"]["name"] ?? "";
        locationNameController.text =
            responseJSON["data"]["agency"]["location"] ?? "";
      }

    //selectedManagersList

    List<String> managerIDs=auditData["collection_manager_id"].toString().split(",");


    print("MANAGER IDS");
    print(managerIDs.toString());



    for(int i=0;i<managerList.length;i++)
      {

        for(int j=0;j<managerIDs.length;j++)
          {

            if(managerIDs[j]==managerList[i]["id"].toString())
              {
                managerListAsString.add(managerList[i]["name"]);
                selectedManagersList.add(managerList[i]);
              }



          }



      }


    for(int i=0;i<selectedManagersList.length;i++)
      {
        managerEmpCodeController[i].text=selectedManagersList[i]["emp_id"].toString();
        regionalManagerController[i].text="-";
        zonalManagerController[i].text=selectedManagersList[i]["zcmname"].toString();
        nationalManagerController[i].text=selectedManagersList[i]["ncmname"].toString();

        for(int j=0;j<areaManagerList.length;j++)
          {

            if(selectedManagersList[i]["acm_id"].toString()==areaManagerList[j]["id"].toString())
              {
                selectedDropCollectionManager[i]=areaManagerList[j]["name"];
              }

          }


      }








    print("Manager Data");
    print(selectedManagersList.toString());

















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
      "type": widget.sheetType,
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

  fetchCities() async {
    setState(() {
      isLoading = true;
    });
    var requestModel = {"qm_sheet_id": sheetID};

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPIWithHeader('audit_sheet', requestModel, context);
    setState(() {
      isLoading = false;
    });
    var responseJSON = json.decode(response.body);
    cityList = responseJSON["data"]["cities"];
    filteredCityList = responseJSON["data"]["cities"];
    questionList = responseJSON["data"]["data"]["parameter"];
    saveInSharedPrefrences();

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

    double finalCal=0.0;
    for(int i=0;i<questionList.length;i++)
    {
      for (int j = 0;
      j < questionList[i]["qm_sheet_sub_parameter"].length;
      j++)
      {
        dropdownSelectionList[i][j]=sheetData["parameter"][i]["subparameter"][j]["option_selected"];
        weightList[i][j]=sheetData["parameter"][i]["subparameter"][j]["weight"].toStringAsFixed(2);
        finalCal=finalCal+double.parse(weightList[i][j]);
        controllerList[i][j].text=sheetData["parameter"][i]["subparameter"][j]["remark"];
      }

    }

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
    }










    auditCycleList = responseJSON["data"]["cycle"];
    for (int i = 0; i < auditCycleList.length; i++) {
      auditCycleListAsString.add(auditCycleList[i]["name"]);
    }

    lobList = responseJSON["data"]["bucket"];
    for (int i = 0; i < lobList.length; i++) {
      lobListAsString.add(lobList[i]["lob"]);
    }

    // SET DATA ON FORM


    for(int i=0;i<cityList.length;i++)
      {
        if(cityList[i]["name"]==auditData["city"])

         /* program_id
          aSSIGNM
          ACTIVITY*/
          {
            selectedCityIndex=i;
            break;
          }
      }

    if(selectedCityIndex==9999)
      {
        selectedCityIndex=0;
      }

    selectedLOB=auditData["lob"];


    for(int i=0;i<auditCycleList.length;i++)
    {
      if(auditCycleList[i]["id"].toString()==auditData["audit_cycle_id"].toString())
      {
        selectedAuditCycle=auditCycleList[i]["name"];
        break;
      }
    }


    selectedDate=auditData["audit_date_by_aud"];

    fetchAgencies();













    print(responseJSON);
    setState(() {});
  }

  fetchQuestions() async {
    setState(() {
      isLoading = true;
    });
    var requestModel = {"qm_sheet_id": sheetID};

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
}
