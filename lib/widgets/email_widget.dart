


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:surveycxm/view/otp_verify_screen.dart';
import 'package:qaudit_tata_flutter/widgets/textfield_widget.dart';

import '../utils/app_theme.dart';
import 'input_field_widget.dart';
//import '../view/login_screen.dart';

class EmailWidget extends StatefulWidget
{
  EmailWidgetState createState()=>EmailWidgetState();
}
class EmailWidgetState extends State<EmailWidget>
{
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 80),
              Container(
                margin:
                const EdgeInsets.symmetric(
                    horizontal: 10),
                child: TextFieldShow(
                  controller: emailController,
                  labeltext: 'Email or Mobile Number',
                  fieldIC: const Icon(
                      Icons.mail,
                      size: 20,
                      color:
                      AppTheme.themeColor),
                  suffixIc: const Icon(
                    Icons.abc,
                    size: 0,
                  ),
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {

               //   Navigator.push(context, MaterialPageRoute(builder: (context)=>OTPVerifyScreen()));

                  // Navigator.of(context).push(PageRouteBuilder(
                  //     opaque: false,
                  //     pageBuilder: (BuildContext context, _, __) =>
                  //         OTPVerifyScreen()));
                /*  _submitHandlerTab1Screen1(
                      context);
*/

                },
                child: Container(
                    margin: const EdgeInsets
                        .symmetric(
                        horizontal: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color:
                        AppTheme.themeColor,
                        borderRadius:
                        BorderRadius
                            .circular(5)),
                    height: 50,
                    child: const Center(
                      child: Text('Send OTP',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                              FontWeight
                                  .w600,
                              color: Colors
                                  .white)),
                    )),
              ),
              const SizedBox(height: 45),
              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Text(
                      'Already have an account? ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                        FontWeight.bold,
                        color:
                        Color(0xFF1A1A1A),
                      )),
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             LoginScreen()));
                    },
                    child: const Text('Login',
                        style: TextStyle(
                          fontSize: 15,
                          decoration:
                          TextDecoration
                              .underline,
                          fontWeight:
                          FontWeight.bold,
                          color: AppTheme
                              .themeColor,
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          )),
    );
  }

}