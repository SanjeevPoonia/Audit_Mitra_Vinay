

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:qaudit_tata_flutter/network/api_dialog.dart';
import 'package:qaudit_tata_flutter/network/constants.dart';
import 'package:qaudit_tata_flutter/utils/app_modal.dart';
import 'package:qaudit_tata_flutter/utils/app_theme.dart';
import 'package:qaudit_tata_flutter/view/upload_artifact_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:toast/toast.dart';

import 'MarkAttendanceScreen.dart';
import 'login_screen.dart';

class ImageProgressScreen extends StatefulWidget
{
  final String auditID;
  ImageProgressScreen(this.auditID);
  ArtifactState createState()=>ArtifactState();
}

class ArtifactState extends State<ImageProgressScreen>
{
  int totalFiles=0;
  int uploadedFiles=0;
  bool showAnim=false;
  double percentageUploaded=0.0;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
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
                    Text("Upload Artifact",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        )),
                    Container()
                  ],
                ),
              ),
            ),



            showAnim?Container():

            SizedBox(height: 16),
            showAnim?Container():
            Row(
              children: [
                SizedBox(width: 10),
                Text("Images are being uploaded please wait...",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black
                    )),

                SizedBox(width: 10),

                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.themeColor),
                  ),
                ),

                SizedBox(width: 5),



              ],
            ),

            SizedBox(height: 20),



            showAnim?


               SizedBox(
                   width:200,
                   height: 200,

                   child: Lottie.asset("assets/check_animation.json")):

            CircularPercentIndicator(
              radius: 90.0,
              lineWidth: 18.0,
              animation: true,
              percent: percentageUploaded,
              center:  Text(
                uploadedFiles.toString()+"/"+totalFiles.toString(),
                style:
                 TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Colors.greenAccent,
            ),


            SizedBox(height: 20),

            Text("Images uploaded successfully!",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black
                )),

            SizedBox(height: 20),

            Card(
              elevation: 3,
              margin: EdgeInsets.only(left: 10),
              shadowColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Container(
                height: 44,
                child: ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor:
                      MaterialStateProperty.all<
                          Color>(
                          Colors.white), // background
                      backgroundColor:
                      MaterialStateProperty
                          .all<Color>(AppTheme
                          .themeColor), // fore
                      shape: MaterialStateProperty.all<
                          RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(6.0),
                          ))),
                  onPressed: () {



                  },
                  child: const Text(
                    'Back to dashboard',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),



          ],
        ),
      ),
    );
  }


  uploadImage() async {

    List<dynamic> imageList = AppModel.rebuttalData;

    for (int i = 0; i < imageList.length; i++) {
      FormData formData = FormData.fromMap({
        "sheet_id": imageList[i]["sheet_id"],
        "parameter_id": imageList[i]["parameter_id"],
        "sub_parameter_id": imageList[i]["sub_parameter_id"],
        "audit_id": widget.auditID,
        "status": "1",
        "totalFile": await MultipartFile.fromFile(imageList[i]["imagePath"],
            filename: imageList[i]["imagePath"]
                .split('/')
                .last),
      });
      print(formData.fields);
      Dio dio = Dio();
      dio.options.headers['Content-Type'] = 'multipart/form-data';
      dio.options.headers['Authorizations'] = AppModel.token;
      print(AppConstant.appBaseURL + "storeArtifact");
      var response = await dio.post(AppConstant.appBaseURL + "storeArtifact",
          data: formData);
      //  log(response.data.toString());
      //var responseJSON = jsonDecode(response.data.toString());

      if (response.data['status'] == 1) {
        uploadedFiles=uploadedFiles+1;
        percentageUploaded=(uploadedFiles*totalFiles)/100;
        setState(() {

        });
        if (i == imageList.length - 1) {
          showAnim=true;
          setState(() {

          });

        }
      } else if (response.data['message'].toString() == "User not found") {
        _logOut(context);
      } else {
        /*Toast.show(response.data['message'].toString(),
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);*/
      }
    }
  }
  _logOut(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Toast.show('Your session has expired, Please login to continue!',
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.blue);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    totalFiles=AppModel.rebuttalData.length;
    uploadImage();


  }
}