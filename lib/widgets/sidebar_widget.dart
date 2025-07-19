

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qaudit_tata_flutter/utils/app_theme.dart';

class SideBarWidget extends StatelessWidget
{
  final String title;
  final String imagePath;
  SideBarWidget(this.title,this.imagePath);
  @override
  Widget build(BuildContext context) {

    return   Padding(padding: EdgeInsets.symmetric(vertical: 14),

      child: Row(


        children: [

          SizedBox(width: 7),

          Image.asset(imagePath,width:23,height: 23,color: AppTheme.themeColor,),


          SizedBox(width: 15),


          Text(title,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black.withOpacity(0.84))),

        ],
      ),


    );
  }

}