
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qaudit_tata_flutter/network/loader.dart';
import '../../network/api_helper.dart';
import '../../utils/app_theme.dart';
import '../../widgets/dropdown_widget.dart';


class QAAssignedAuditDetails extends StatefulWidget
{
  final String id;
  QAAssignedAuditDetails(this.id);
  AuditState createState()=>AuditState();
}

class AuditState extends State<QAAssignedAuditDetails>
{
  bool isLoading=false;
  Map<String,dynamic> auditData={};
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FB),

        body: isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : CustomScrollView(
          slivers: [

            /// Header
            SliverAppBar(
              expandedHeight: 100,
              pinned: true,
              elevation: 0,
              backgroundColor: AppTheme.themeColor,

              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),

              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  "Audit Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.themeColor,
                        AppTheme.themeColor.withOpacity(.8),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    _sectionCard(
                      title: "Auditor Details",
                      icon: Icons.person_outline,
                      children: [

                        _infoTile(
                          "Auditor Name",
                          auditData["auditor_name"],
                          Icons.person,
                        ),

                        _infoTile(
                          "Email",
                          auditData["auditor_email"],
                          Icons.email_outlined,
                        ),

                        _infoTile(
                          "Audit Date",
                          auditData["audit_date"],
                          Icons.calendar_today,
                        ),
                      ],
                    ),

                    const SizedBox(height:20),

                    _sectionCard(
                      title:
                      "Collection / Agency Details",

                      icon:
                      Icons.business,

                      children: [

                        _infoTile(
                          "Agency Name",
                          auditData["final_agency_name"],
                          Icons.apartment,
                        ),

                        _infoTile(
                          "Agency Type",
                          auditData["type_of_agency"],
                          Icons.category,
                        ),

                        _infoTile(
                          "Product",
                          auditData["product"],
                          Icons.shopping_bag,
                        ),

                        _infoTile(
                          "Location",
                          auditData["location"],
                          Icons.location_on,
                        ),

                        _infoTile(
                          "State",
                          auditData["state"],
                          Icons.map,
                        ),

                        _infoTile(
                          "Region",
                          auditData["region"],
                          Icons.public,
                        ),

                        _infoTile(
                          "Agency Contact",
                          auditData["contact"],
                          Icons.phone,
                        ),

                        _infoTile(
                          "Agency Email",
                          auditData["agency_email"],
                          Icons.mail,
                        ),

                        _infoTile(
                          "Agency Address",
                          auditData["agency_address"],
                          Icons.home,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }){

    return Container(
      margin: const EdgeInsets.only(bottom:20),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(24),

        boxShadow: [

          BoxShadow(
            blurRadius: 15,
            offset: const Offset(0,5),
            color: Colors.black.withOpacity(.05),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Icon(
                icon,
                color: AppTheme.themeColor,
              ),

              const SizedBox(width:10),

              Text(
                title,
                style: const TextStyle(
                  fontSize:18,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),

          const SizedBox(height:18),

          ...children
        ],
      ),
    );
  }

  Widget _infoTile(
      String title,
      dynamic value,
      IconData icon,
      ){

    return Padding(
      padding: const EdgeInsets.only(bottom:14),

      child: Container(
        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(

          color: Colors.grey.shade50,

          borderRadius:
          BorderRadius.circular(18),
        ),

        child: Row(

          children: [

            Icon(
              icon,
              size:20,
              color: AppTheme.themeColor,
            ),

            const SizedBox(width:14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(
                    title,
                    style: TextStyle(
                      fontSize:12,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height:4),

                  Text(
                    (value ?? "NA")
                        .toString(),

                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize:15,
                    ),
                  ),
                ],
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
    assignedAuditDetails(context);
  }

  assignedAuditDetails(BuildContext context) async {



    setState(() {
      isLoading=true;
    });
    var data = {
      "assign_id":widget.id
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('v2/auditor_assign_case_details', data, context);
    var responseJSON = json.decode(response.body);
    log(responseJSON.toString());
    auditData = responseJSON['data'];
    setState(() {
      isLoading=false;
    });
    print(responseJSON);
    setState(() {

    });

  }
}
