import 'package:flutter/material.dart';

class SubmittedAuditViewScreen extends StatefulWidget {

  final Map<String, dynamic> auditData;

  const SubmittedAuditViewScreen({
    super.key,
    required this.auditData,
  });

  @override
  State<SubmittedAuditViewScreen> createState() =>
      _SubmittedAuditViewScreenState();
}

class _SubmittedAuditViewScreenState
    extends State<SubmittedAuditViewScreen> {

  @override
  Widget build(BuildContext context) {

    List submittedAuditData =
        widget.auditData["submitted_audit_data"] ?? [];

    Map<String, dynamic> overallResult =
        widget.auditData["overall_result"] ?? {};

    List parameterWiseResult =
        overallResult["parameter_wise_result"] ?? [];

    Map<String, dynamic> pillarWiseResult =
        overallResult["pillar_wise_result"] ?? {};

    List pillarData =
        pillarWiseResult["pillar_data"] ?? [];

    Map<String, dynamic> overallPillarResult =
        pillarWiseResult["overall_pillar_result"] ?? {};

    return Scaffold(

      backgroundColor: const Color(0xFFF6F8FC),

      appBar: AppBar(

        elevation: 0,

        backgroundColor: Colors.white,

        title: const Text(
          "Submitted Audit",
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.w700,
          ),
        ),

        iconTheme:
        const IconThemeData(
          color: Color(0xFF111827),
        ),
      ),

      body: SingleChildScrollView(

        physics:
        const BouncingScrollPhysics(),

        child: Column(
          children: [

            const SizedBox(height: 14),

            /// HEADER CARD
            _buildHeaderCard(
              overallPillarResult,
            ),

            const SizedBox(height: 18),

           /* /// BASIC INFO
            if (submittedAuditData.isNotEmpty)
              _buildAuditInfoCard(
                submittedAuditData[0],
              ),

            const SizedBox(height: 18),*/

            _buildSectionTitle(
              "Audit Parameters",
            ),

            ListView.builder(

              itemCount:
              submittedAuditData.length,

              shrinkWrap: true,

              physics:
              const NeverScrollableScrollPhysics(),

              padding:
              const EdgeInsets.symmetric(
                horizontal: 14,
              ),

              itemBuilder: (context, auditIndex) {

                var audit =
                submittedAuditData[auditIndex];

                List parameterList =
                    audit["data"] ?? [];

                return Column(

                  children: List.generate(

                    parameterList.length,

                        (paramIndex) {

                      var parameter =
                      parameterList[paramIndex];

                      /// FIND PARAMETER SCORE

                      Map<String, dynamic>?
                      parameterResult;

                      try {

                        parameterResult =
                            parameterWiseResult.firstWhere(

                                  (e) =>

                              e["parameter_id"]
                                  .toString() ==

                                  parameter["parameter_id"]
                                      .toString() &&

                                  e["parameter_index"]
                                      .toString() ==

                                      parameter[
                                      "parameter_index"]
                                          .toString(),
                            );

                      } catch (e) {
                        parameterResult = null;
                      }

                      return _buildCombinedParameterCard(
                        parameter,
                        parameterResult,
                      );
                    },
                  ),
                );
              },
            ),



            const SizedBox(height: 18),

            /// PILLAR RESULT
            _buildSectionTitle(
              "Pillar Wise Result",
            ),

            ListView.builder(

              itemCount: pillarData.length,

              shrinkWrap: true,

              physics:
              const NeverScrollableScrollPhysics(),

              padding:
              const EdgeInsets.symmetric(
                horizontal: 14,
              ),

              itemBuilder: (context, index) {

                return _buildPillarCard(
                  pillarData[index],
                );
              },
            ),

            const SizedBox(height: 18),

            /// AUDIT DETAILS
            /*_buildSectionTitle(
              "Audit Details",
            ),

            ListView.builder(

              itemCount:
              submittedAuditData.length,

              shrinkWrap: true,

              physics:
              const NeverScrollableScrollPhysics(),

              padding:
              const EdgeInsets.symmetric(
                horizontal: 14,
              ),

              itemBuilder: (context, auditIndex) {

                var audit =
                submittedAuditData[auditIndex];

                List parameterList =
                    audit["data"] ?? [];

                return Column(
                  children: [

                    ListView.builder(

                      itemCount:
                      parameterList.length,

                      shrinkWrap: true,

                      physics:
                      const NeverScrollableScrollPhysics(),

                      itemBuilder:
                          (context, paramIndex) {

                        return _buildAuditParameterCard(
                          parameterList[paramIndex],
                        );
                      },
                    ),

                    const SizedBox(height: 10),
                  ],
                );
              },
            ),*/

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
  Widget _buildCombinedParameterCard(

      Map<String, dynamic> parameter,
      Map<String, dynamic>? parameterResult,
      ) {
    List subparameter =
        parameter["subparameter"] ?? [];
    double percentage =
        double.tryParse(
          parameterResult?["percentage"]
              ?.toString() ??
              "0",
        ) ??
            0;

    return Container(

      margin: const EdgeInsets.only(
        bottom: 16,
      ),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(26),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(0.04),

            blurRadius: 18,

            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          /// HEADER
          Container(

            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(

              borderRadius:
              const BorderRadius.only(

                topLeft:
                Radius.circular(26),

                topRight:
                Radius.circular(26),
              ),

              color:
              const Color(0xFFF8FAFC),
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Row(
                  children: [

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [


                          Text(

                            "${parameter["parameter_name"]} "
                                "${parameter["parameter_tag"]??""}",

                            style:
                            const TextStyle(
                              fontSize: 18,
                              fontWeight:
                              FontWeight
                                  .w700,

                              color:
                              Color(0xFF111827),
                            ),
                          ),

                          const SizedBox(
                              height: 6),

                          Text(
                            parameter["touch_point"]
                                ?.toString() ??
                                "",

                            style: TextStyle(
                              fontSize: 13,
                              color:
                              Colors.grey
                                  .shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(

                      padding:
                      const EdgeInsets
                          .symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),

                      decoration:
                      BoxDecoration(

                        color:
                        _getScoreColor(
                          percentage,
                        ).withOpacity(0.12),

                        borderRadius:
                        BorderRadius.circular(
                            18),
                      ),

                      child: Text(
                        "${percentage.toStringAsFixed(0)}%",

                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                          FontWeight.w700,

                          color:
                          _getScoreColor(
                            percentage,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Row(
                  children: [

                    Expanded(
                      child: _scoreBox(
                        "Score",

                        parameterResult?[
                        "total_score"]
                            ?.toString() ??
                            "0",
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: _scoreBox(
                        "Scorable",

                        parameterResult?[
                        "total_scorable"]
                            ?.toString() ??
                            "0",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// SUBPARAMETER LIST
          Padding(

            padding: const EdgeInsets.all(16),

            child: Column(

              children: List.generate(

                subparameter.length,

                    (index) {

                  var sub =
                  subparameter[index];

                  return Container(

                    margin:
                    const EdgeInsets.only(
                      bottom: 14,
                    ),

                    padding:
                    const EdgeInsets.all(
                        16),

                    decoration:
                    BoxDecoration(

                      color:
                      const Color(
                          0xFFF9FAFB),

                      borderRadius:
                      BorderRadius.circular(
                          22),
                    ),

                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        Text(
                          sub["subparam_name"]
                              .toString(),

                          style:
                          const TextStyle(
                            fontSize: 15,
                            fontWeight:
                            FontWeight
                                .w700,
                          ),
                        ),

                        const SizedBox(
                            height: 14),

                        Row(
                          children: [

                            Expanded(
                              child:
                              _smallInfoChip(

                                sub["option_selected"]
                                    .toString(),

                                Colors.green,
                              ),
                            ),

                            const SizedBox(
                                width: 8),

                            Expanded(
                              child:
                              _smallInfoChip(

                                sub["compliance_experience"]
                                    .toString(),

                                Colors.orange,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                            height: 12),

                        Row(
                          children: [

                            Expanded(
                              child:
                              _scoreBox(

                                "Score",

                                sub["score"]
                                    .toString(),
                              ),
                            ),

                            const SizedBox(
                                width: 10),

                            Expanded(
                              child:
                              _scoreBox(

                                "Scorable",

                                sub["scorable"]
                                    .toString(),
                              ),
                            ),
                          ],
                        ),

                        if (sub["remark"] !=
                            null &&
                            sub["remark"]
                                .toString()
                                .isNotEmpty)

                          Padding(

                            padding:
                            const EdgeInsets
                                .only(
                                top: 14),

                            child: Container(

                              width:
                              double.infinity,

                              padding:
                              const EdgeInsets
                                  .all(14),

                              decoration:
                              BoxDecoration(

                                color:
                                Colors.white,

                                borderRadius:
                                BorderRadius.circular(
                                    16),
                              ),

                              child: Text(
                                sub["remark"]
                                    .toString(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  /// HEADER

  Widget _buildHeaderCard(
      Map<String, dynamic> overallData) {

    double finalPercentage =
        double.tryParse(
          overallData["final_percentage"]
              ?.toString() ??
              "0",
        ) ??
            0;

    return Container(

      margin:
      const EdgeInsets.symmetric(
        horizontal: 14,
      ),

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(

        borderRadius:
        BorderRadius.circular(28),

        gradient: const LinearGradient(
          colors: [
            Color(0xFF5B5FEF),
            Color(0xFF7C3AED),
          ],
        ),
      ),

      child: Column(
        children: [

          const Row(
            children: [

              Icon(
                Icons.analytics_rounded,
                color: Colors.white,
                size: 28,
              ),

              SizedBox(width: 12),

              Text(
                "Audit Summary",

                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                  FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          Text(
            "${finalPercentage.toStringAsFixed(2)}%",

            style: const TextStyle(
              fontSize: 42,
              fontWeight:
              FontWeight.w800,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Final Audit Score",

            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  /// AUDIT INFO CARD

  Widget _buildAuditInfoCard(
      Map<String, dynamic> data) {

    return Container(

      margin:
      const EdgeInsets.symmetric(
        horizontal: 14,
      ),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        children: [

          _infoRow(
            "Location",
            data["location"] ?? "-",
          ),

          _infoRow(
            "Campus Type",
            data["campus_type"] ?? "-",
          ),

          _infoRow(
            "Brand",
            data["brand"] ?? "-",
          ),

          _infoRow(
            "Pillar",
            data["pillar"] ?? "-",
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
      String title,
      String value,
      ) {

    return Padding(

      padding:
      const EdgeInsets.only(
        bottom: 14,
      ),

      child: Row(
        children: [

          Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color:
                Colors.grey.shade600,
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: Text(
              value,

              textAlign: TextAlign.right,

              style: const TextStyle(
                fontSize: 15,
                fontWeight:
                FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// SECTION TITLE

  Widget _buildSectionTitle(
      String title) {

    return Padding(

      padding:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      child: Row(
        children: [

          Text(
            title,

            style: const TextStyle(
              fontSize: 18,
              fontWeight:
              FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  /// PARAMETER RESULT CARD

  Widget _buildParameterResultCard(
      Map<String, dynamic> item) {

    double percentage =
        double.tryParse(
          item["percentage"]
              ?.toString() ??
              "0",
        ) ??
            0;

    return Container(

      margin:
      const EdgeInsets.only(
        bottom: 14,
      ),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

                  children: [

                    Text(

                      "${item["parameter_name"]} "
                          "#${item["parameter_index"]}",

                      style:
                      const TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      item["pillar"] ?? "",

                      style: TextStyle(
                        fontSize: 13,
                        color:
                        Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),

                decoration: BoxDecoration(
                  color:
                  _getScoreColor(
                    percentage,
                  ).withOpacity(0.12),

                  borderRadius:
                  BorderRadius.circular(
                      18),
                ),

                child: Text(
                  "${percentage.toStringAsFixed(0)}%",

                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w700,
                    color:
                    _getScoreColor(
                      percentage,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [

              Expanded(
                child:
                _scoreBox(
                  "Score",
                  item["total_score"]
                      .toString(),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child:
                _scoreBox(
                  "Scorable",
                  item["total_scorable"]
                      .toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// AUDIT PARAMETER CARD

  Widget _buildAuditParameterCard(
      Map<String, dynamic> item) {

    List subparameter =
        item["subparameter"] ?? [];

    return Container(

      margin:
      const EdgeInsets.only(
        bottom: 14,
      ),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: ExpansionTile(

        tilePadding:
        const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),

        childrenPadding:
        const EdgeInsets.all(16),

        title: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Text(
              "${item["parameter_name"]} "
                  "#${item["parameter_index"]}",

              style: const TextStyle(
                fontSize: 17,
                fontWeight:
                FontWeight.w700,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              item["touch_point"] ?? "",

              style: TextStyle(
                fontSize: 13,
                color:
                Colors.grey.shade600,
              ),
            ),
          ],
        ),

        children: [

          ListView.builder(

            itemCount:
            subparameter.length,

            shrinkWrap: true,

            physics:
            const NeverScrollableScrollPhysics(),

            itemBuilder:
                (context, index) {

              var sub =
              subparameter[index];

              return Container(

                margin:
                const EdgeInsets.only(
                  bottom: 14,
                ),

                padding:
                const EdgeInsets.all(16),

                decoration:
                BoxDecoration(

                  color:
                  const Color(
                      0xFFF9FAFB),

                  borderRadius:
                  BorderRadius.circular(
                      20),
                ),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

                  children: [

                    Text(
                      sub["subparam_name"]
                          .toString(),

                      style:
                      const TextStyle(
                        fontSize: 14,
                        fontWeight:
                        FontWeight
                            .w700,
                      ),
                    ),

                    const SizedBox(
                        height: 14),

                    Row(
                      children: [

                        Expanded(
                          child:
                          _smallInfoChip(
                            sub["option_selected"]
                                .toString(),

                            Colors.green,
                          ),
                        ),

                        const SizedBox(
                            width: 8),

                        Expanded(
                          child:
                          _smallInfoChip(
                            sub["compliance_experience"]
                                .toString(),

                            Colors.orange,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                        height: 12),

                    Row(
                      children: [

                        Expanded(
                          child:
                          _scoreBox(
                            "Score",
                            sub["score"]
                                .toString(),
                          ),
                        ),

                        const SizedBox(
                            width: 10),

                        Expanded(
                          child:
                          _scoreBox(
                            "Scorable",
                            sub["scorable"]
                                .toString(),
                          ),
                        ),
                      ],
                    ),

                    if (sub["remark"] !=
                        null &&
                        sub["remark"]
                            .toString()
                            .isNotEmpty)

                      Padding(
                        padding:
                        const EdgeInsets
                            .only(
                            top: 14),

                        child: Container(

                          width:
                          double.infinity,

                          padding:
                          const EdgeInsets
                              .all(14),

                          decoration:
                          BoxDecoration(

                            color:
                            Colors.white,

                            borderRadius:
                            BorderRadius.circular(
                                16),
                          ),

                          child: Text(
                            sub["remark"]
                                .toString(),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _smallInfoChip(
      String title,
      Color color,
      ) {

    return Container(

      padding:
      const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color:
        color.withOpacity(0.12),

        borderRadius:
        BorderRadius.circular(16),
      ),

      child: Center(
        child: Text(
          title,

          textAlign: TextAlign.center,

          style: TextStyle(
            fontSize: 12,
            fontWeight:
            FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _scoreBox(
      String title,
      String value,
      ) {

    return Container(

      padding:
      const EdgeInsets.symmetric(
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius:
        BorderRadius.circular(18),
      ),

      child: Column(
        children: [

          Text(
            value,

            style: const TextStyle(
              fontSize: 18,
              fontWeight:
              FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,

            style: TextStyle(
              fontSize: 12,
              color:
              Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillarCard(
      Map<String, dynamic> item) {

    return Container(

      margin:
      const EdgeInsets.only(
        bottom: 14,
      ),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(
            item["pillar"] ?? "",

            style: const TextStyle(
              fontSize: 17,
              fontWeight:
              FontWeight.w700,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [

              Expanded(
                child:
                _scoreBox(
                  "Score/Scorable", "${item["total_score"].toString()}/${item["total_scorable"]?.toString()??""}",
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child:
                _scoreBox("Weighted/Weight", "${item["weighted_score"].toString()}/${item["pillar_weight"].toString()}",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(
      double percentage) {

    if (percentage >= 85) {
      return Colors.green;
    } else if (percentage >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}