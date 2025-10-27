
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:qaudit_tata_flutter/network/api_dialog.dart';
import 'package:qaudit_tata_flutter/network/api_helper.dart';
import 'package:qaudit_tata_flutter/network/loader.dart';
import 'package:qaudit_tata_flutter/utils/app_modal.dart';
import 'package:qaudit_tata_flutter/utils/app_theme.dart';
import 'package:qaudit_tata_flutter/view/audit_form_screen.dart';
import 'package:qaudit_tata_flutter/view/audit_newform_screen.dart';
import 'package:qaudit_tata_flutter/view/zoom_scaffold.dart' as MEN;

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'menu_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
class HomeScreen extends StatefulWidget
{
  LandingState createState()=>LandingState();
}

class LandingState extends State<HomeScreen> with TickerProviderStateMixin
{
  int selectedIndex = 0;
  MEN.MenuController? menuController;
  bool isLoading=false;
  List<dynamic> auditList=[];
  List<dynamic> questionList=[];
  final ZoomDrawerController controller = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {

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
                    Text("Audit Sheet List",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        )),
                    Container(width: 15)
                  ],
                ),
              ),
            ),

            Expanded(child:

            isLoading?

            Center(
              child: Loader(),
            ):


            auditList.length==0?

            Center(
              child: Text("No data found!"),
            ):



            ListView.builder(
                itemCount: auditList.length,
                padding: EdgeInsets.only(top: 5),
                itemBuilder: (BuildContext context,int pos)
                {
                  return Column(
                    children: [

                      Card(
                        color: Colors.white,
                        shadowColor: AppTheme.themeColor,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        elevation: 2,
                        shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)
                        ),
                        child: Container(

                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7)
                          ),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(auditList[pos]["name"],
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  )),

                              SizedBox(height: 5),

                              Row(
                                children: [

                                  Text("Sheet Type",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      )),

                                  SizedBox(width: 10),

                                  Text(auditList[pos]["type"],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      )),




                                ],
                              ),

                              SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text("Lob",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      )),

                                  SizedBox(width: 10),

                                  Text(auditList[pos]["lob"],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      )),
                                  Spacer(),
                                  Container(
                                    height: 42,
                                    child: ElevatedButton(
                                        child: Text('Start Audit',
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 13.5)),
                                        style: ButtonStyle(
                                            foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                            backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                AppTheme.themeColor),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                ))),
                                        onPressed: () async{

                                          Navigator.push(context,MaterialPageRoute(builder: (context)=>AuditNewFormScreen(auditList[pos]["id"].toString(),{},auditList[pos]["name"],false,"","")));
                                          //Navigator.push(context,MaterialPageRoute(builder: (context)=>AuditFormScreen(auditList[pos]["id"].toString(),{},auditList[pos]["name"],false,"","")));









                                        }),
                                  ),

                                  SizedBox(width: 5)
                                ],
                              ),

                              SizedBox(height: 7),
                            ],
                          ),




                        ),
                      ),

                      SizedBox(height: 12)

                    ],
                  );
                }


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

    checkInternet();

    menuController = MEN.MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }




  checkInternet()async{
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult.contains(ConnectivityResult.none))
    {
      fetchLocalData();
    }
    else
      {
        fetchAuditSheets();
       // fetchQuestionList();
      }
  }



  fetchQuestionList() async {


    var requestModel = {
      "user_id": AppModel.userID
    };

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('qm-sheet-list1', requestModel, context);
    var responseJSON = json.decode(response.body);
     questionList=responseJSON["data"];
    saveQuestionsSharedPrefrences();

    print(responseJSON);
    setState(() {

    });

  }

  fetchAuditSheets() async {

    setState(() {
      isLoading=true;
    });
    var requestModel = {
     /* "user_id": AppModel.userID*/
    };

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('getSheets', requestModel, context);
    setState(() {
      isLoading=false;
    });
    var responseJSON = json.decode(response.body);
    auditList=responseJSON["data"];
   // saveInSharedPrefrences();

    print(responseJSON);
    setState(() {

    });

  }


  saveInSharedPrefrences() async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String json = jsonEncode(auditList);
    await preferences.setString('audit_list',json);
  }

  saveQuestionsSharedPrefrences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String json = jsonEncode(questionList);
    await preferences.setString('question_list',json);
  }



  fetchLocalData() async {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    var data=prefs.getString("audit_list");
     if(data!=null)
       {
         List<dynamic> list2 = jsonDecode(data);
         auditList=list2;
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






}

