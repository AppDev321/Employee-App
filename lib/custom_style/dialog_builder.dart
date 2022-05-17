import 'package:flutter/material.dart';
import 'package:hnh_flutter/custom_style/loading_indicator.dart';
import 'package:progress_dialog/progress_dialog.dart';

class DialogBuilder {
  ProgressDialog? pr;

  DialogBuilder(this.dialogContext);

  final BuildContext dialogContext;

  void initiateLDialog(String text) {
    pr = new ProgressDialog(dialogContext,
        isDismissible: false, customBody: new LoadingIndicator(title: text));
  }


  void showLoadingDialog() {
    pr?.show();
  }

  void hideOpenDialog() {
    pr?.hide();
  }
}
