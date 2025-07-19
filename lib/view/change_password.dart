
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:qaudit_tata_flutter/utils/app_modal.dart';
import 'package:qaudit_tata_flutter/utils/app_theme.dart';
import 'package:qaudit_tata_flutter/view/audit_form_screen.dart';
import 'package:qaudit_tata_flutter/view/login_screen.dart';
import 'package:qaudit_tata_flutter/view/zoom_scaffold.dart' as MEN;

import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import 'home_screen.dart';
import 'menu_screen.dart';

class ChangePasswordScreen extends StatefulWidget
{
  ChangePasswordState createState()=>ChangePasswordState();
}

class ChangePasswordState extends State<ChangePasswordScreen> with TickerProviderStateMixin
{
  int selectedIndex = 0;
  MEN.MenuController? menuController;
  final ZoomDrawerController controller = ZoomDrawerController();
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  bool isObscure1 = true;
  bool isObscure2 = true;
  bool termsChecked = false;
  bool isLoading = false;
  String emailID = '';

  var currentPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/backimage.png'),
              fit: BoxFit.cover,
            ),
          ),
          child:  Column(
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
                      Text("Change Password",
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

              Expanded(
                child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        const SizedBox(height: 25),

                        Container(
                          margin:
                          const EdgeInsets.only(top: 10, left: 40, right: 40),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(
                                10.0),
                            border: Border.all(
                              color: AppTheme.themeColor, // Set border color here
                              width: 1.0, // Set border width here
                            ),// Adjust the radius as needed
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                // Center the children horizontally
                                children: <Widget>[
                                  Text(
                                    'Change Password',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25),


                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 15),
                                child: TextFormField(
                                    validator: checkPasswordValidator,
                                    controller: currentPasswordController,
                                    obscureText: isObscure,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      suffixIcon: IconButton(
                                        icon: isObscure
                                            ? const Icon(
                                          Icons.visibility_off,
                                          size: 20,
                                          color: AppTheme.themeColor,
                                        )
                                            : const Icon(
                                          Icons.visibility,
                                          size: 20,
                                          color: AppTheme.themeColor,
                                        ),
                                        onPressed: () {
                                          Future.delayed(Duration.zero, () async {
                                            if (isObscure) {
                                              isObscure = false;
                                            } else {
                                              isObscure = true;
                                            }

                                            setState(() {});
                                          });
                                        },
                                      ),
                                      labelText: 'Current Password*',
                                      labelStyle: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                      ),
                                    )),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 15),
                                child: TextFormField(
                                    validator: checkPasswordValidator,
                                    controller: newPasswordController,
                                    obscureText: isObscure1,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      suffixIcon: IconButton(
                                        icon: isObscure1
                                            ? const Icon(
                                          Icons.visibility_off,
                                          size: 20,
                                          color: AppTheme.themeColor,
                                        )
                                            : const Icon(
                                          Icons.visibility,
                                          size: 20,
                                          color: AppTheme.themeColor,
                                        ),
                                        onPressed: () {
                                          Future.delayed(Duration.zero, () async {
                                            if (isObscure1) {
                                              isObscure1 = false;
                                            } else {
                                              isObscure1 = true;
                                            }

                                            setState(() {});
                                          });
                                        },
                                      ),
                                      labelText: 'New Password*',
                                      labelStyle: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                      ),
                                    )),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 15),
                                child: TextFormField(
                                    validator: checkPasswordValidator,
                                    controller: confirmPasswordController,
                                    obscureText: isObscure2,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      suffixIcon: IconButton(
                                        icon: isObscure2
                                            ? const Icon(
                                          Icons.visibility_off,
                                          size: 20,
                                          color: AppTheme.themeColor,
                                        )
                                            : const Icon(
                                          Icons.visibility,
                                          size: 20,
                                          color: AppTheme.themeColor,
                                        ),
                                        onPressed: () {
                                          Future.delayed(Duration.zero, () async {
                                            if (isObscure2) {
                                              isObscure2 = false;
                                            } else {
                                              isObscure2 = true;
                                            }

                                            setState(() {});
                                          });
                                        },
                                      ),
                                      labelText: 'Confirm Password*',
                                      labelStyle: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                      ),
                                    )),
                              ),

                              const SizedBox(height: 40),
                              InkWell(
                                onTap: () {
                                  _submitHandler();
                                },
                                child: Container(
                                    margin:
                                    const EdgeInsets.symmetric(horizontal: 17),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: AppTheme.themeColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    height: 50,
                                    child: const Center(
                                      child: Text('Change Password',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white)),
                                    )),
                              ),
                              SizedBox(height: 30.0),
                              Container(
                                width: 150,
                                height: 40,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/Qdegrees.png'),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0),
                      ],
                    )),
              )
            ],
          ),),
      ),
    );
  }
  String? checkPasswordValidator(String? value) {
    if (value!.length < 6) {
      return 'Password is required';
    }
    return null;
  }
  void _submitHandler() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    checkPasswords();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getValue();
    menuController = MEN.MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }
  Future<void> getValue() async {
    String? email = await MyUtils.getSharedPreferences("email");
    emailID = email ?? "NA";

  }
  void checkPasswords() {
    if (newPasswordController.text != confirmPasswordController.text) {
      setState(() {
        Toast.show('confirm password not match',
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      });
    } else {
      setState(() {
        changePassword();
      });
    }
  }
  changePassword() async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Please wait...');
    var requestModel = {
      "email": emailID,
      "password": currentPasswordController.text,
      "new_password": newPasswordController.text,
    };

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('updatePassword', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    if (responseJSON['status'] == 1) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false);
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
}



