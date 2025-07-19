



import 'package:flutter/material.dart';
import 'package:qaudit_tata_flutter/utils/app_theme.dart';

class DashboardWidget2 extends StatelessWidget
{
  final String title;
  final String imagePath;
  final String count;
  DashboardWidget2(this.title,this.imagePath,this.count);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFfe6f2ff),
      ),
      height: 110,
      child: Stack(
        children: [

          Row(
            children: [


              Spacer(),
              Container(
                  transform: Matrix4.translationValues(5.0, -8.0, 0.0),
                  child: Image.asset(imagePath,width: 93,height: 111,))
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 9),


              Padding(
                padding:  EdgeInsets.only(left: 5),
                child: Text(title,style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                )),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(count,style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.themeColor,
                )),
              ),










            ],
          ),
        ],
      ),
    );
  }

}


class CalenderTextFieldWidget extends StatelessWidget
{
  final String title,initialValue;
  bool? enabled;
  bool? numberPad;
  int? suffixIconExists;
  var controller;
  final String? Function(String?)? validator;
  CalenderTextFieldWidget(this.title,this.initialValue,this.controller,this.validator,{this.enabled,this.numberPad,this.suffixIconExists});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.only(left: 10,right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),

          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  color: Color(0xFF707070))),
          SizedBox(height: 4),
          SizedBox(

            child: TextFormField(
              controller: controller,
              validator: validator,
              keyboardType: numberPad!=null?TextInputType.number:TextInputType.text,
              enabled: enabled!=null?enabled:true,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.black
              ),
              decoration: InputDecoration(
                hintText:"Please select date",
                filled: true,
                border: InputBorder.none,
                /* border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3.0),
                  borderSide: BorderSide.none
                ),*/
                fillColor: Color(0xFFEEEDF9),
                suffixIcon: suffixIconExists!=null?Icon(Icons.calendar_month,color: AppTheme.themeColor):null,
                hintStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 13,
                    color: AppTheme.blackColor
                ),

                //   floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
            ),
          ),


        ],
      ),
    );
  }

}
