

import 'package:flutter/cupertino.dart';
import 'package:qaudit_tata_flutter/utils/app_theme.dart';
class BackgroundWidget extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return   Container(
      height: double.infinity,
      width: double.infinity,
      color: AppTheme.themeColor,
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(
      //         'assets/bg_img.png'),
      //     fit: BoxFit.cover,
      //   ),
      // ),
    );

  }

}