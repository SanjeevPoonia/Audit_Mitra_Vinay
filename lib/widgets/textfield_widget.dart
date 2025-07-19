
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFieldWidgetNew extends StatelessWidget
{
  final String title;
  final String hintText;
  var controller;
  bool? enabled;
  TextFieldWidgetNew(this.title,this.hintText,this.controller,{this.enabled});
  @override
  Widget build(BuildContext context) {
   return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
       Padding(
         padding: const EdgeInsets.only(left: 12),
         child: Text(title,
             style: TextStyle(
               fontSize: 12,
               fontWeight: FontWeight.w500,
               color: Colors.black.withOpacity(0.7),
             )),
       ),



       SizedBox(height: 2),


       Container(
         height: 41,
         width: MediaQuery.of(context).size.width,
         color: enabled!=null?Colors.grey.withOpacity(0.1):Colors.white,
         margin: EdgeInsets.symmetric(horizontal: 10),
         child:TextFormField(
           controller: controller,
             enabled: enabled!=null?false:true,
             style: const TextStyle(
               fontSize: 13.0,
               fontWeight: FontWeight.w500,
               color: Colors.black,
             ),
             decoration: InputDecoration(
                 enabledBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(4.0),
                   borderSide:
                   BorderSide(color: Colors.black, width: 0.5),
                 ),
                 focusedBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(4.0),
                     borderSide:
                     BorderSide(color: Colors.black, width: 0.5)),
                 disabledBorder:OutlineInputBorder(
    borderRadius: BorderRadius.circular(4.0),
    borderSide:
    BorderSide(color: Colors.black, width: 0.5),
    ),
                 errorBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(4.0),
                     borderSide: BorderSide(color: Colors.red, width: 0.5)),
                 border: InputBorder.none,

                 contentPadding: EdgeInsets.fromLTRB(7.0, 7.0, 5, 8),
                 //prefixIcon: fieldIC,
                 hintText: hintText,
                 hintStyle: TextStyle(
                   fontSize: 12,
                   fontWeight: FontWeight.w500,
                   color: Colors.black.withOpacity(0.7),
                 ))),

       ),

     ],
   );
  }

}

class TextFieldWidgetMultiLine extends StatelessWidget
{
  final String title;
  final String hintText;
  var controller;
  bool? enabled;
  TextFieldWidgetMultiLine(this.title,this.hintText,this.controller,{this.enabled});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              )),
        ),



        SizedBox(height: 2),


        Container(
         // height: 41,
          width: MediaQuery.of(context).size.width,
          color: enabled!=null?Colors.grey.withOpacity(0.1):Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child:TextFormField(
              controller: controller,
              maxLines: 2,
              enabled: enabled!=null?false:true,
              style: const TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide:
                    BorderSide(color: Colors.black, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide:
                      BorderSide(color: Colors.black, width: 0.5)),
                  disabledBorder:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide:
                    BorderSide(color: Colors.black, width: 0.5),
                  ),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(color: Colors.red, width: 0.5)),
                  border: InputBorder.none,

                  contentPadding: EdgeInsets.fromLTRB(7.0, 7.0, 5, 8),
                  //prefixIcon: fieldIC,
                  hintText: hintText,
                  hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.7),
                  ))),

        ),

      ],
    );
  }

}

class TextFieldWidgetRow extends StatelessWidget
{
  final String title;
  final String hintText;
  TextFieldWidgetRow(this.title,this.hintText);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              )),
        ),



        SizedBox(height: 2),


        Container(
          height: 41,
          child:TextFormField(
              style: const TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF707070),
              ),
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide:
                    BorderSide(color: Colors.black, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide:
                      BorderSide(color: Colors.black, width: 0.5)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(color: Colors.red, width: 0.5)),
                  border: InputBorder.none,

                  contentPadding: EdgeInsets.fromLTRB(7.0, 7.0, 5, 8),
                  //prefixIcon: fieldIC,
                  hintText: hintText,
                  hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.7),
                  ))),

        ),

      ],
    );
  }

}