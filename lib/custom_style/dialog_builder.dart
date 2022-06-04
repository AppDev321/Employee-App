import 'package:flutter/material.dart';
import 'package:hnh_flutter/custom_style/loading_indicator.dart';
import 'package:progress_dialog/progress_dialog.dart';

class DialogBuilder {
  ProgressDialog? _progressDialog;

  DialogBuilder(this._dialogContext);

  final BuildContext _dialogContext;

  void initiateLDialog(String text) {
    _progressDialog = new ProgressDialog(_dialogContext,
        isDismissible: false, customBody: new LoadingIndicator(title: text));

  }
  ProgressDialog? getDiaog()
  {
    return _progressDialog;
  }

  void showLoadingDialog() {
    if(_progressDialog?.isShowing()==false)
    _progressDialog?.show();
  }

  void hideOpenDialog() {
    if(_progressDialog?.isShowing()==true)
    _progressDialog?.hide();
  }
}
