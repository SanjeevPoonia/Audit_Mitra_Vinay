import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageView extends StatelessWidget
{
  final String url;
  final String auditID;
  ImageView(this.url,this.auditID);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(padding: EdgeInsets.only(top: 35,left: 15),

              child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },

                  child: Icon(Icons.close,color: Colors.white,size: 35)),

            ),


            Expanded(
              child: auditID!=""?PhotoView(
                imageProvider:
                NetworkImage(url),
              ):PhotoView(
                imageProvider:
                FileImage(File(url)),
              ),
            ),
          ],
        )
    );
  }
}