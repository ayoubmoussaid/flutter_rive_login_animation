import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        );
      });
}
