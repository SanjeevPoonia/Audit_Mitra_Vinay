

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qaudit_tata_flutter/network/api_dialog.dart';
import 'package:qaudit_tata_flutter/network/api_helper.dart';
import 'package:qaudit_tata_flutter/network/constants.dart';
import 'package:qaudit_tata_flutter/network/loader.dart';
import 'package:qaudit_tata_flutter/utils/app_modal.dart';
import 'package:qaudit_tata_flutter/utils/app_theme.dart';
import 'package:qaudit_tata_flutter/view/image_view_screen.dart';
import 'package:qaudit_tata_flutter/view/upload_artifact_screen.dart';
import 'package:toast/toast.dart';

class ViewArtifactScreen extends StatefulWidget
{
  final String sheetID,paramID,subParamID,tempAuditID;
  ViewArtifactScreen(this.sheetID,this.paramID,this.subParamID,this.tempAuditID);
  ArtifactState createState()=>ArtifactState();
}

class ArtifactState extends State<ViewArtifactScreen>
{
  List<dynamic> imageList=[];
  bool isLoading=false;


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
                    Text("View Artifact",
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

            SizedBox(height: 12),
            Expanded(child:

            isLoading?
            Center(
                child:Loader()
            ):

            imageList.length==0?

            Center(
              child: Text("No Artifacts found!"),
            ):

            GridView.builder(
              padding: const EdgeInsets.only(left: 12, right: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  crossAxisCount: 3,
                  childAspectRatio: (2 / 2)),
              itemCount:imageList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>ImageView(widget.tempAuditID!=""?imageList[index]["file"].toString():imageList[index]["imagePath"],widget.tempAuditID)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image:


                      widget.tempAuditID!=""?
                      DecorationImage(
                          fit: BoxFit.cover,
                          image:


                          NetworkImage(
                              imageList[index]["file"].toString()
                          )
                      ):
                      DecorationImage(
                          fit: BoxFit.cover,
                          image:FileImage(File(imageList[index]["imagePath"]))
                      ),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: Colors.black),
                    ),

                  ),
                );
                // Item rendering
              },
            ),
            )

          ],
        ),
      ),
    );
  }



@override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.tempAuditID!="")
      {
        fetchArtifacts();
      }
    else
    {
      fetchLocalData();
    }

  }




  fetchArtifacts() async {
    setState(() {
      isLoading = true;
    });
    var requestModel = {
      "sheet_id": widget.sheetID,
      "parameter_id": widget.paramID,
      "sub_parameter_id": widget.subParamID,
      "audit_id":widget.tempAuditID
    };
    print(requestModel);
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPIWithHeader('artifactsList', requestModel, context);
    setState(() {
      isLoading = false;
    });
    var responseJSON = json.decode(response.body);
    imageList = responseJSON["data"];
    print(responseJSON);
    setState(() {});
  }


  deleteArtifacts(String id,int pos) async {

    APIDialog.showAlertDialog(context, "Removing...");
    var requestModel = {
      "artifact_id": id
    };

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPIWithHeader('deleteArtifact', requestModel, context);

    Navigator.pop(context);

    var responseJSON = json.decode(response.body);
    if (responseJSON['status'] == 200) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

     imageList.removeAt(pos);
     setState(() {

     });
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    print(responseJSON);
    setState(() {});
  }


  fetchLocalData(){

    List<dynamic> imageData=AppModel.rebuttalData;

    for(int i=0;i<imageData.length;i++)
      {
        if(imageData[i]["sheet_id"]==widget.sheetID && imageData[i]["parameter_id"]==widget.paramID && imageData[i]["sub_parameter_id"]==widget.subParamID)
          {
            imageList.add(imageData[i]);
          }
      }



  }
}