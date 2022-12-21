import 'package:flutter/cupertino.dart';

import 'BottomCustomAlterWidget.dart';

class AppTool {
  /// 底部弹出2个选项框
  showBottomAlert(BuildContext context, confirmCallback, String title,
      String option1, String option2,String option3,String option4,String option5) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return BottomCustomAlterWidget(
              confirmCallback, title, option1, option2,option3,option4,option5);
        });
  }
}