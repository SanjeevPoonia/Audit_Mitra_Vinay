



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qaudit_tata_flutter/widgets/textfield_widget.dart';

import '../../utils/app_theme.dart';
import '../input_field_widget.dart';

class SignUpStep1 extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return  ListView(
      children: [



        SizedBox(height: 30),


        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: TextFieldShow(
            labeltext: 'Email or Mobile Number',
            fieldIC: const Icon(Icons.mail,
                size: 20,
                color: AppTheme.themeColor),
            suffixIc: const Icon(
              Icons.abc,
              size: 0,
            ),
          ),
        ),
        SizedBox(height: 40),

        InkWell(
          onTap: (){


          },
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppTheme.themeColor,
                  borderRadius: BorderRadius.circular(5)
              ),

              child: Center(
                child: Text('Send OTP',style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                )),
              ),
              height: 50),
        ),

        SizedBox(height: 25),




        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Already have an account? ',style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),

            )),

            Text('Login',style: TextStyle(
              fontSize: 15,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
              color: AppTheme.themeColor,

            )),



          ],
        ),

      ],
    );
  }

}