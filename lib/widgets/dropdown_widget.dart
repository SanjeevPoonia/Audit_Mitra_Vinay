





import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../utils/app_theme.dart';

class DropDownWidget extends StatelessWidget
{
  Function onTap;
  String title;
  final String selectedValue;
  Color textColor;
  DropDownWidget(this.onTap,this.title,this.selectedValue,this.textColor);
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

        GestureDetector(
          onTap: (){
            onTap();
          },
          child: Container(
            height: 41,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black,width: 0.5)
            ),

            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 7),
                    child: Text(selectedValue,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        )),
                  ),
                ),




                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text("Select",
                      style: TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.themeColor,
                      )),
                ),


              ],
            ),

          ),
        )


      ],
    );
  }

}

class DropDownWidget2 extends StatelessWidget
{
  Function onTap;
  String title;
  final String selectedValue;
  Color textColor;
  DropDownWidget2(this.onTap,this.title,this.selectedValue,this.textColor);
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

        GestureDetector(
          onTap: (){
            onTap();
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
           // height: 41,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey.withOpacity(0.1),
                border: Border.all(color: Colors.black,width: 0.5)
            ),

            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 7),
                    child: Text(selectedValue,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        )),
                  ),
                ),




            /*    Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text("Select",
                      style: TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.themeColor,
                      )),
                ),*/


              ],
            ),

          ),
        )


      ],
    );
  }

}


class DropDownWidget3 extends StatelessWidget
{

  String title;
  String value;
  DropDownWidget3(this.title,this.value);
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
                fontWeight: FontWeight.w700,
                color: Color(0xFF3B1C32),
              )),
        ),

        SizedBox(height: 2),

        Container(
          padding: EdgeInsets.symmetric(vertical: 11),
          // height: 41,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey.withOpacity(0.1),
              border: Border.all(color: Colors.black,width: 0.5)
          ),

          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: Text(value,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      )),
                ),
              ),




              /*    Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text("Select",
                      style: TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.themeColor,
                      )),
                ),*/


            ],
          ),

        ),


      ],
    );
  }

}


class DropDownWidgetArrow extends StatelessWidget
{
  Function onTap;
  String title;
  final String selectedValue;
  Color textColor;
  DropDownWidgetArrow(this.onTap,this.title,this.selectedValue,this.textColor);
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

        GestureDetector(
          onTap: (){
            onTap();
          },
          child: Container(
           // height: 41,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 8),
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black,width: 0.5)
            ),

            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 7),
                    child: Text(selectedValue,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        )),
                  ),
                ),




                Padding(
                  padding: const EdgeInsets.only(right: 10,left: 10),
                  child: Icon(Icons.keyboard_arrow_down)
                ),


              ],
            ),

          ),
        )


      ],
    );
  }

}



class DropDownWidgetDisplay extends StatelessWidget
{
  Function onTap;
  String title;
  final String selectedValue;
  Color textColor;
  DropDownWidgetDisplay(this.onTap,this.title,this.selectedValue,this.textColor);
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

        GestureDetector(
          onTap: (){

          },
          child: Container(
            height: 41,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey.withOpacity(0.1),
                border: Border.all(color: Colors.black,width: 0.5)
            ),

            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 7),
                    child: Text(selectedValue,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        )),
                  ),
                ),




           /*     Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text("Select",
                      style: TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.themeColor,
                      )),
                ),*/


              ],
            ),

          ),
        )


      ],
    );
  }

}