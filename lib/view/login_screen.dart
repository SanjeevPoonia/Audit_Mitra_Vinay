import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qaudit_tata_flutter/utils/app_theme.dart';
import 'package:qaudit_tata_flutter/view/all_dashboard/client_home_screen.dart';
import 'package:qaudit_tata_flutter/view/home_screen.dart';

import 'package:qaudit_tata_flutter/widgets/input_field_widget.dart';
import 'package:toast/toast.dart';
import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_modal.dart';
import '../widgets/textfield_widget.dart';
import 'all_dashboard/qa_home_screen.dart';

//import 'package:qa_views_flutter/view/home_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginScreen> {
  bool isObscure = true;
  bool termsChecked = false;
  bool isLoading = false;
  TextEditingController currentPasswordController = TextEditingController();
  final _formKeyChangePassword = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  int id = 0;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    ToastContext().init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9CFA5),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backimage.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(height: 45),
                    Center(
                      child:  Image.asset("assets/app_logo.png",height: 150),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 40, right: 40,),
                     // height: 460,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: AppTheme.themeColor, // Set border color here
                          width: 1.0, // Set border width here
                        ), // Adjust the radius as needed
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // Center the children horizontally
                            children: <Widget>[
                              Text(
                                'Hello',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // Center the children horizontally
                            children: <Widget>[
                              Text(
                                'Please login to your account.',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFieldShow(
                              validator: null,
                              controller: emailController,
                              labeltext: 'Email Address',
                              fieldIC: const Icon(Icons.mail,
                                  size: 20, color: AppTheme.themeColor),
                              suffixIc: const Icon(Icons.mail,
                                  size: 20, color: AppTheme.themeColor),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                                validator: checkPasswordValidator,
                                controller: passwordController,
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
                                  labelText: 'Password*',
                                  labelStyle: const TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                  ),
                                )),
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: GestureDetector(
                                onTap: () {
                                  forgotPasswordSheet();
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: AppTheme.blackColor,
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
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
                                  child: Text('Login',
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
                          SizedBox(height: 15.0),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  String? checkPasswordValidator(String? value) {
    if (value!.length < 6) {
      return 'Password is required';
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value!.isEmpty ||
        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
      return 'Email should be valid Email address.';
    }
    return null;
  }

  void _submitHandler() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    loginUser();
  }

  loginUser() async {
  //  FocusScope.of(context).unfocus();
    FocusScope.of(context).requestFocus(FocusNode());
    APIDialog.showAlertDialog(context, 'Please wait...');
    var requestModel = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('loginUser', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    if (responseJSON['status'] == 1) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      MyUtils.saveSharedPreferences('auth_key', responseJSON["auth_key"]);
      MyUtils.saveSharedPreferences('name', responseJSON['name']);
      MyUtils.saveSharedPreferences('email', responseJSON['email']);
      MyUtils.saveSharedPreferences('role', responseJSON['user_role']);

      MyUtils.saveSharedPreferences(
          'user_id', responseJSON["user_id"].toString());
      AppModel.setTokenValue(responseJSON["auth_key"]);
      AppModel.setUserID(responseJSON["user_id"].toString());

      if(responseJSON["user_role"]=="Client"){

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ClientHomeScreen()),
                (Route<dynamic> route) => false);

      }
      else
        {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => QAHomeScreen()),
                  (Route<dynamic> route) => false);
        }


    }

    else if(responseJSON.toString().contains("{message: Attempt to read property"))
      {
        Toast.show('Sorry this email does not exists!',
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }

    
    else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  void forgotPasswordSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                color: Colors.white,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: _formKeyChangePassword,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                          color: const Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text('Forgot Password',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                          ),
                          const Spacer(),
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Image.asset(
                                'assets/cross_ic.png',
                                width: 25,
                                height: 25,

                              )),
                          const SizedBox(width: 10)
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                          controller: currentPasswordController,
                          validator: emailValidator,
                          style: const TextStyle(
                            fontSize: 15.0,
                            height: 1.6,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            /*    contentPadding:
                                        const EdgeInsets.fromLTRB(
                                            0.0, 20.0, 0.0, 10.0),*/
                            labelText: 'Email',
                            labelStyle: const TextStyle(
                              fontSize: 13.5,
                              color: Colors.grey,
                            ),
                          )),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _submitHandler22();
                            },
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                    color: AppTheme.themeColor,
                                    borderRadius: BorderRadius.circular(5)),
                                height: 46,
                                child: const Center(
                                  child: Text('Send Reset Link',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white)),
                                )),
                          ),
                        ),
                        const SizedBox(width: 25),
                      ],
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              )),
        );
      }),
    );
  }

  void _submitHandler22() async {
    if (!_formKeyChangePassword.currentState!.validate()) {
      return;
    }
    _formKeyChangePassword.currentState!.save();
    forgotPass();
  }
  forgotPass() async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Please wait...');
    var requestModel = {
      "email": currentPasswordController.text,
    };

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('forgotPassword', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    if (responseJSON['status'] == 200) {
      Navigator.pop(context);
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }


}
