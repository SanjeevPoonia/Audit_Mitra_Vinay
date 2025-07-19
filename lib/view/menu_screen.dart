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
import 'package:qaudit_tata_flutter/widgets/sidebar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qaudit_tata_flutter/view/zoom_scaffold.dart' as MEN;


import 'package:toast/toast.dart';
import '../network/Utils.dart';
import '../network/api_helper.dart';
import 'offline_audit_list.dart';


class MenuScreen extends StatefulWidget {

  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<MenuScreen> {
  String emailID = '';
  String userName = '';
  String? profileImageUrl;
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF9CFA5),
      body: Container(
        // color: const Color(0xFFF9CFA5),
          width: MediaQuery.of(context).size.width,
          height: double.infinity,
          child: Stack(
            children: [

              Container(
                // margin: EdgeInsets.only(left: 20,right: 20,top: 40),
                height: double.infinity,
                width: double.infinity,
                decoration:  BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/backimage.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),


              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  children: [
                    const SizedBox(height: 23),


                    Row(
                      children: [

                        Spacer(),

                        InkWell(
                          onTap: () {
                            Provider.of<MEN.MenuController>(context,
                                listen: false)
                                .toggle();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: Image.asset("assets/ham_drawer.png",width: 21.2,height: 18.42,color: AppTheme.themeColor),
                          ),
                        )

                      ],
                    ),


                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),

                           profileImageUrl==null?
                           CircleAvatar(
                            radius: 25,
                            backgroundImage:
                            AssetImage('assets/profile_d1.png'),
                          ):CircleAvatar(
                             radius: 25,
                             backgroundImage: NetworkImage(profileImageUrl!),
                           ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [



                                  Text(userName,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black)),


                                  //   const SizedBox(height: 4),

                                  Text(emailID,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black)),
                                  const SizedBox(height: 4),


                                ],
                              )
                          ),
                          const SizedBox(width: 10),
                          //  const Spacer(),

                        ],
                      ),
                    ),


                    SizedBox(height: 10),



                    Container(
                      margin: EdgeInsets.only(left: 15,right: 110),
                      child: Divider(
                        color: Colors.white.withOpacity(0.50),
                      ),
                    ),

                    //                                  Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: AssignedTab(true)));
                    Expanded(
                        child: ListView(
                            padding: EdgeInsets.symmetric(horizontal: 12),


                            children: [


                              SizedBox(height: 40),

                              InkWell(
                                onTap: (){

                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();
                                  Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: AssignedAuditsScreen()));

                                  //Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: AssignedTab(true)));

                                },
                                child: SideBarWidget(
                                    'Assigned Audits',
                                    'assets/assign_ic.png'
                                ),
                              ),





                              InkWell(
                                onTap: (){

                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();
                                  Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: HomeScreen()));

                                  //Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: AssignedTab(true)));

                                },
                                child: SideBarWidget(
                                    'Audit Sheet List',
                                    'assets/ic_audit_list.PNG'
                                ),
                              ),

                            /*  InkWell(
                                onTap: (){

                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();
                                  Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: OfflineAuditListScreen()));

                                  //Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: AssignedTab(true)));

                                },
                                child: SideBarWidget(
                                    'Offline Audit List',
                                    'assets/ic_offline_data.PNG'
                                ),
                              ),
*/

                              InkWell(
                                onTap: (){

                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();
                                  Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: SavedAuditListScreen()));
                                  //Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: AssignedTab(true)));

                                },
                                child: SideBarWidget(
                                    'Saved Audit List',
                                    'assets/ic_saved_sudit.png'
                                ),
                              ),

                              InkWell(
                                onTap: (){

                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();

                                  Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: SubmitAuditListScreen()));


                                },
                                child: SideBarWidget(
                                    'Submitted Audit List',
                                    'assets/ic_submitted_audit.PNG'
                                ),
                              ),

                              InkWell(
                                onTap: (){

                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();
                                  Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: ChangePasswordScreen()));

                                  //Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: AssignedTab(true)));

                                },
                                child: SideBarWidget(
                                    'Change Password',
                                    'assets/ic_change_password.PNG'
                                ),
                              ),

                              InkWell(
                                onTap: (){

                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();
                                  _showAlertDialog();

                                  //Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: AssignedTab(true)));

                                },
                                child: SideBarWidget(
                                    'Logout',
                                    'assets/ic_logout.PNG'
                                ),
                              ),

                            ])),

                    const SizedBox(height: 22),
                  ],
                ),
              ),
            ],
          )),
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
      profileImageUrl=responseJSON["data"]["avatar_url"].toString();
    });
  }
}
