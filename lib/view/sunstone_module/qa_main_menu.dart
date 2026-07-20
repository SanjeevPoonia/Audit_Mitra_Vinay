import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qaudit_tata_flutter/utils/app_theme.dart';
import 'package:qaudit_tata_flutter/view/assigned_audit_list.dart';
import 'package:qaudit_tata_flutter/view/change_password.dart';
import 'package:qaudit_tata_flutter/view/home_screen.dart';
import 'package:qaudit_tata_flutter/view/login_screen.dart';
import 'package:qaudit_tata_flutter/view/saved_audit_list.dart';
import 'package:qaudit_tata_flutter/view/submit_audit_list.dart';
import 'package:qaudit_tata_flutter/view/sunstone_module/qa_assigned_audit_list.dart';
import 'package:qaudit_tata_flutter/view/sunstone_module/qa_home_screen.dart';
import 'package:qaudit_tata_flutter/view/sunstone_module/qa_saved_audit_list.dart';
import 'package:qaudit_tata_flutter/view/sunstone_module/qa_submitted_audit_list.dart';
import 'package:qaudit_tata_flutter/widgets/sidebar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qaudit_tata_flutter/view/zoom_scaffold.dart' as MEN;
import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_helper.dart';



class QAMenuScreen extends StatefulWidget {

  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<QAMenuScreen> {
  String emailID = '';
  String userName = '';
  String? profileImageUrl;
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF9CFA5),
        body: SafeArea(

          child: Container(

            width: double.infinity,
            height: double.infinity,

            decoration: const BoxDecoration(

              gradient: LinearGradient(

                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,

                colors: [
                  Color(0xFFF5F7FB),
                  Colors.white,
                ],
              ),
            ),

            child: Column(

              children: [

                /// FIXED PROFILE HEADER

                SizedBox(

                  height: 270,

                  child: Container(

                    width: double.infinity,

                    padding: const EdgeInsets.only(
                      top: 15,
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),

                    decoration: const BoxDecoration(

                      gradient: LinearGradient(

                        colors: [

                          Color(0xFF4F46E5),
                          Color(0xFF7C3AED),
                        ],
                      ),

                      borderRadius: BorderRadius.only(

                        bottomLeft:
                        Radius.circular(35),

                        bottomRight:
                        Radius.circular(35),
                      ),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Align(

                          alignment:
                          Alignment.topRight,

                          child: InkWell(

                            onTap: () {

                              Provider.of<
                                  MEN.MenuController>(
                                  context,
                                  listen:false)
                                  .toggle();
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

                                Icons.close,

                                color:
                                Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        Container(

                          decoration:
                          BoxDecoration(

                            shape:
                            BoxShape.circle,

                            border: Border.all(

                              color:
                              Colors.white,

                              width:3,
                            ),

                            boxShadow:[

                              BoxShadow(

                                color:
                                Colors.black
                                    .withOpacity(
                                    .15),

                                blurRadius:15,
                              )
                            ],
                          ),

                          child: CircleAvatar(

                            radius:42,

                            backgroundColor:
                            Colors.white,

                            backgroundImage:

                            profileImageUrl == null

                                ?

                            const AssetImage(
                                "assets/profile_d1.png")

                            as ImageProvider

                                :

                            NetworkImage(
                                profileImageUrl!),
                          ),
                        ),

                        const SizedBox(
                            height:12),

                        Text(

                          userName,

                          maxLines:1,

                          overflow:
                          TextOverflow.ellipsis,

                          style:
                          const TextStyle(

                            fontSize:16,

                            fontWeight:
                            FontWeight.bold,

                            color:
                            Colors.white,
                          ),
                        ),

                        const SizedBox(
                            height:5),

                        Text(

                          emailID,

                          maxLines:1,

                          overflow:
                          TextOverflow.ellipsis,

                          style:
                          TextStyle(

                            fontSize:12,

                            color:
                            Colors.white
                                .withOpacity(.9),
                          ),
                        ),

                        const Spacer(),
                      ],
                    ),
                  ),
                ),

                /// MENU SECTION

                Expanded(

                  child: SingleChildScrollView(

                    padding:
                    const EdgeInsets.symmetric(
                      horizontal:16,
                      vertical:16,
                    ),

                    child: Column(

                      children: [

                        _menuTile(
                          "Assigned Audits",
                          Icons.assignment,
                              (){
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.leftToRight,
                                child: QaAssignedAuditsScreen(),
                              ),
                            );
                          },
                        ),

                        _menuTile(
                          "Audit Sheet List",
                          Icons.fact_check,
                              (){
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.leftToRight,
                                child: QaHomeScreen(),
                              ),
                            );
                          },
                        ),

                        _menuTile(
                          "Saved Audits",
                          Icons.save,
                              (){
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.leftToRight,
                                child: QaSavedAuditListScreen(),
                              ),
                            );
                          },
                        ),

                        _menuTile(
                          "Submitted Audits",
                          Icons.task_alt,
                              (){
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.leftToRight,
                                child: QaSubmitAuditListScreen(),
                              ),
                            );
                          },
                        ),

                        _menuTile(
                          "Change Password",
                          Icons.lock_reset,
                              (){
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.leftToRight,
                                child: ChangePasswordScreen(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height:25),

                        InkWell(

                          onTap: (){
                            _showAlertDialog();
                          },

                          child: Container(

                            padding:
                            const EdgeInsets.all(15),

                            decoration:
                            BoxDecoration(

                              color:
                              Colors.red
                                  .withOpacity(.08),

                              borderRadius:
                              BorderRadius.circular(
                                  20),
                            ),

                            child: Row(

                              children: [

                                const Icon(
                                  Icons.logout,
                                  color: Colors.red,
                                ),

                                const SizedBox(
                                    width:10),

                                const Expanded(

                                  child: Text(

                                    "Logout",

                                    style: TextStyle(

                                      fontWeight:
                                      FontWeight.bold,

                                      color:
                                      Colors.red,
                                    ),
                                  ),
                                ),

                                Icon(

                                  Icons.arrow_forward_ios,

                                  size:15,

                                  color:
                                  Colors.grey.shade600,
                                )
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(
                            height:25),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
  Widget _menuTile(
      String title,
      IconData icon,
      VoidCallback onTap){

    return InkWell(

      onTap: (){

        Provider.of<
            MEN.MenuController>(
            context,
            listen:false)
            .toggle();

        onTap();
      },

      child: Container(

        margin:
        const EdgeInsets.only(
            bottom:14),

        padding:
        const EdgeInsets.all(
            15),

        decoration:
        BoxDecoration(

          color:
          Colors.white,

          borderRadius:
          BorderRadius.circular(
              18),

          boxShadow:[

            BoxShadow(

              color:
              Colors.black
                  .withOpacity(
                  .04),

              blurRadius:12,

              offset:
              const Offset(
                  0,4),
            )
          ],
        ),

        child: Row(

          children: [

            Container(

              padding:
              const EdgeInsets.all(
                  5),

              decoration:
              BoxDecoration(

                color:
                const Color(
                    0xFFEEF2FF),

                borderRadius:
                BorderRadius.circular(
                    12),
              ),

              child: Icon(

                icon,

                color:
                const Color(
                    0xFF4F46E5),
              ),
            ),

            const SizedBox(
                width:14),

            Expanded(

              child: Text(

                title,

                style:
                const TextStyle(

                  fontSize:13,

                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),

            Icon(

              Icons.arrow_forward_ios,

              size:15,

              color:
              Colors.grey.shade600,
            )
          ],
        ),
      ),
    );
  }
  void termAndConditionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context,bottomSheetState)
        {
          return Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 50),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40)), // Set the corner radius here
              color: Colors.white, // Example color for the container
            ),
            child:Column(
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
                    SizedBox(width: 14),

                    Text("Terms and Conditions",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        )),

                    Spacer(),

                    GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Image.asset("assets/cross_ic.png",width: 38,height: 38)),
                    SizedBox(width: 4),
                  ],
                ),
                SizedBox(height: 8),
                Expanded(child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 16,right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Lorem Ipsum is simply dummy text ?',
                            style: TextStyle(
                                color: Color(0xFF00407E),
                                fontSize: 14,
                                fontWeight: FontWeight.w600

                            ),
                          ),
                          SizedBox(height: 10),
                          Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting\n\n'
                              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting',
                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 14,
                                fontWeight: FontWeight.normal

                            ),
                          ),
                          SizedBox(height: 20),
                          Text('Lorem Ipsum is simply text ?',
                            style: TextStyle(
                                color: Color(0xFF00407E),
                                fontSize: 14,
                                fontWeight: FontWeight.w600

                            ),
                          ),
                          SizedBox(height: 10),
                          Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting',

                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 14,
                                fontWeight: FontWeight.normal

                            ),
                          ),
                          SizedBox(height: 20),
                          Text('Lorem Ipsum is simply dummy text ?',
                            style: TextStyle(
                                color: Color(0xFF00407E),
                                fontSize: 14,
                                fontWeight: FontWeight.w600

                            ),
                          ),
                          SizedBox(height: 10),
                          Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting\n\n'
                              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting',
                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 14,
                                fontWeight: FontWeight.normal

                            ),
                          ),

                        ],
                      ),
                    ),


                  ],
                )),
                SizedBox(height: 25),


                Card(
                  elevation: 4,
                  shadowColor:Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor:
                          MaterialStateProperty.all<Color>(
                              Colors.white), // background
                          backgroundColor:
                          MaterialStateProperty.all<Color>(
                              AppTheme.themeColor), // fore
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'I Accept',
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
        }

        );

      },
    );
  }

  void initState() {
    super.initState();
    getValue();
    fetchProfileImage();
  }
  Future<void> getValue() async {
    String? email = await MyUtils.getSharedPreferences("email");
    String? name = await MyUtils.getSharedPreferences("name");
    emailID = email ?? "NA";
    userName = name ?? "NA";
    print(email);
    print(name);
  }
  _showAlertDialog(){
    showDialog(context: context, builder: (ctx)=> AlertDialog(
      title: const Text("Logout",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 18),),
      content: const Text("Are you sure you want to Logout ?",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16,color: Colors.black),),
      actions: <Widget>[
        TextButton(
            onPressed: (){
              Navigator.of(ctx).pop();
              _logOut(context);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.themeColor,
              ),
              height: 45,
              padding: const EdgeInsets.all(10),
              child: const Center(child: Text("Logout",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
            )
        ),
        TextButton(
            onPressed: (){
              Navigator.of(ctx).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.grayColor,
              ),
              height: 45,
              padding: const EdgeInsets.all(10),
              child: const Center(child: Text("Cancel",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
            )
        )
      ],
    ));
  }
  _logOut(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("user_id");
    await preferences.remove("email");
    await preferences.remove("auth_key");
    await preferences.remove("token");
    await preferences.remove("client_id");
    await preferences.remove("role");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false);
  }
  fetchProfileImage() async {

    var requestModel = {};
    ApiBaseHelper helper = ApiBaseHelper();
    var  response =
    await helper.getWithHeader('getProfileImage', {}, context);

    var responseJSON = json.decode(response.body);


    print(responseJSON);


    setState(() {
      if(responseJSON["data"]["avatar_url"]!=null) {
        profileImageUrl = responseJSON["data"]["avatar_url"].toString();
      }
    });
  }
}
