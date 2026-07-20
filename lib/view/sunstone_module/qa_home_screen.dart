
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
import 'package:qaudit_tata_flutter/view/sunstone_module/qa_audit_form_screen.dart';
import 'package:qaudit_tata_flutter/view/sunstone_module/qa_audit_newform_screen.dart';
import 'package:qaudit_tata_flutter/view/sunstone_module/qa_main_auditform_screen.dart';
import 'package:qaudit_tata_flutter/view/zoom_scaffold.dart' as MEN;

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
class QaHomeScreen extends StatefulWidget
{
  LandingState createState()=>LandingState();
}

class LandingState extends State<QaHomeScreen> with TickerProviderStateMixin
{
  int selectedIndex = 0;
  MEN.MenuController? menuController;
  bool isLoading=false;
  List<dynamic> auditList=[];
  List<dynamic> questionList=[];
  final ZoomDrawerController controller = ZoomDrawerController();

  @override
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(

        backgroundColor:
        const Color(0xFFF5F7FB),

        body: Column(

          children: [

            /// HEADER

            Container(

              padding: const EdgeInsets.only(
                top: 18,
                left: 18,
                right: 18,
                bottom: 24,
              ),

              decoration: const BoxDecoration(

                gradient:
                LinearGradient(

                  colors: [

                    Color(0xFF4F46E5),
                    Color(0xFF7C3AED),
                  ],
                ),

                borderRadius:
                BorderRadius.only(

                  bottomLeft:
                  Radius.circular(30),

                  bottomRight:
                  Radius.circular(30),
                ),
              ),

              child: Row(

                children: [

                  InkWell(

                    onTap: (){
                      Navigator.pop(context);
                    },

                    child: Container(

                      padding:
                      const EdgeInsets.all(10),

                      decoration:
                      BoxDecoration(

                        color:
                        Colors.white
                            .withOpacity(.15),

                        borderRadius:
                        BorderRadius.circular(
                            14),
                      ),

                      child: const Icon(

                        Icons.arrow_back,

                        color:
                        Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  const Expanded(

                    child: Text(

                      "Audit Sheet List",

                      style: TextStyle(

                        fontSize: 22,

                        fontWeight:
                        FontWeight.bold,

                        color:
                        Colors.white,
                      ),
                    ),
                  ),

                  Container(

                    padding:
                    const EdgeInsets.symmetric(

                      horizontal:12,
                      vertical:8,
                    ),

                    decoration:
                    BoxDecoration(

                      color:
                      Colors.white
                          .withOpacity(.15),

                      borderRadius:
                      BorderRadius.circular(
                          18),
                    ),

                    child: Text(

                      auditList.length
                          .toString(),

                      style:
                      const TextStyle(

                        color:
                        Colors.white,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height:10),

            Expanded(

              child:

              isLoading

                  ?

               Center(
                child: Loader(),
              )

                  :

              auditList.isEmpty

                  ?

              _emptyWidget()

                  :

              ListView.builder(

                padding:
                const EdgeInsets.symmetric(
                  horizontal:16,
                  vertical:6,
                ),

                itemCount:
                auditList.length,

                itemBuilder:
                    (context,pos){

                  var item=
                  auditList[pos];

                  return Container(

                    margin:
                    const EdgeInsets.only(
                        bottom:16),

                    padding:
                    const EdgeInsets.all(
                        16),

                    decoration:
                    BoxDecoration(

                      color:
                      Colors.white,

                      borderRadius:
                      BorderRadius.circular(
                          24),

                      boxShadow:[

                        BoxShadow(

                          color:
                          Colors.black
                              .withOpacity(
                              .04),

                          blurRadius:18,

                          offset:
                          const Offset(
                              0,6),
                        )
                      ],
                    ),

                    child: Column(

                      children: [

                        Row(

                          children: [

                            Container(

                              width:58,
                              height:58,

                              decoration:
                              BoxDecoration(

                                gradient:
                                const LinearGradient(

                                  colors:[

                                    Color(
                                        0xFF4F46E5),

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

                                size:28,
                              ),
                            ),

                            const SizedBox(
                                width:14),

                            Expanded(

                              child: Column(

                                crossAxisAlignment:
                                CrossAxisAlignment.start,

                                children: [

                                  Text(

                                    item["name"]
                                        ?? "",

                                    style:
                                    const TextStyle(

                                      fontSize:17,

                                      fontWeight:
                                      FontWeight.w700,
                                    ),
                                  ),

                                  const SizedBox(
                                      height:6),

                                  Container(

                                    padding:
                                    const EdgeInsets.symmetric(

                                      horizontal:10,
                                      vertical:6,
                                    ),

                                    decoration:
                                    BoxDecoration(

                                      color:
                                      Colors.blue
                                          .withOpacity(
                                          .08),

                                      borderRadius:
                                      BorderRadius.circular(
                                          20),
                                    ),

                                    child: Text(

                                      item["type"]
                                          ?? "",

                                      style:
                                      const TextStyle(

                                        fontSize:12,

                                        fontWeight:
                                        FontWeight.w600,

                                        color:
                                        Color(
                                            0xFF4F46E5),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),

                        const SizedBox(
                            height:18),

                        _infoTile(

                          Icons.business,

                          "LOB",

                          item["lob"]
                              ?? "NA",
                        ),

                        const SizedBox(
                            height:18),

                        SizedBox(

                          width:
                          double.infinity,

                          height:50,

                          child:
                          ElevatedButton.icon(

                            icon:
                            const Icon(
                              Icons.play_arrow,
                              color:
                              Colors.white,
                            ),

                            label:
                            const Text(

                              "Start Audit",

                              style:
                              TextStyle(

                                fontWeight:
                                FontWeight.bold,

                                color:
                                Colors.white,
                              ),
                            ),

                            style:
                            ElevatedButton
                                .styleFrom(

                              elevation:0,

                              backgroundColor:
                              const Color(
                                  0xFF4F46E5),

                              shape:
                              RoundedRectangleBorder(

                                borderRadius:
                                BorderRadius.circular(
                                    16),
                              ),
                            ),

                            onPressed:(){

                              Navigator.push(

                                context,

                                MaterialPageRoute(

                                  builder:(context)=>

                                      QaMainAuditFormScreen(

                                        item["id"]
                                            .toString(),

                                        {},

                                        item["name"],

                                        false,

                                        "",

                                        "",
                                      ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _infoTile(
      IconData icon,
      String title,
      String value){

    return Container(

      padding:
      const EdgeInsets.all(
          12),

      decoration:
      BoxDecoration(

        color:
        const Color(
            0xFFF8FAFC),

        borderRadius:
        BorderRadius.circular(
            16),
      ),

      child: Row(

        children: [

          Icon(

            icon,

            color:
            const Color(
                0xFF4F46E5),

            size:20,
          ),

          const SizedBox(
              width:10),

          Text(

            "$title : ",

            style:
            TextStyle(

              color:
              Colors.grey
                  .shade600,

              fontWeight:
              FontWeight.w500,
            ),
          ),

          Expanded(

            child: Text(

              value,

              style:
              const TextStyle(

                fontWeight:
                FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _emptyWidget(){

    return Center(

      child: Column(

        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [

          Icon(

            Icons.assignment_outlined,

            size:90,

            color:
            Colors.grey.shade400,
          ),

          const SizedBox(
              height:14),

          const Text(

            "No Audit Sheets Available",

            style: TextStyle(

              fontSize:18,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(
              height:6),

          Text(

            "Audit sheets will appear here",

            style: TextStyle(

              color:
              Colors.grey.shade600,
            ),
          )
        ],
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
    var response = await helper.postAPIWithHeader('v2/getSheets', requestModel, context);
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

