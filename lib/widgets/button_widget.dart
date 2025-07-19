import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class ButtonWidget extends StatelessWidget {
  Function onTap;
  String btnText;

  ButtonWidget(this.btnText, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          width: double.infinity,
          decoration: BoxDecoration(
              color: AppTheme.themeColor,
              borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: Text(btnText,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ),
          height: 53),
    );
  }
}
