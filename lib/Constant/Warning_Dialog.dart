import 'package:flutter/material.dart';
import 'package:nextapp/Constant/Con_Wid.dart';

import 'Con_Clr.dart';

void showWarningDialog(
    {required BuildContext context,
    required String title,
    required String message,
    required Function onYesPressed}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomWarningDialog(
        title: title,
        message: message,
        onYesPressed: onYesPressed,
      );
    },
  );
}

class CustomWarningDialog extends StatelessWidget {
  final String title;
  final String message;
  final Function onYesPressed;

  const CustomWarningDialog(
      {super.key,
      required this.title,
      required this.message,
      required this.onYesPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0,
      backgroundColor: Con_transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: getPlatformBrightness() ? Con_msg_auto_4 : Con_white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Con_black26,
            offset: Offset(0, 5),
            blurRadius: 10.0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
                color: getPlatformBrightness() ? AppBar_PrimaryColor1 : Con_Main_1,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: getPlatformBrightness() ? AppBar_PrimaryColor1 :Con_Main_1,
                  backgroundColor: Con_white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onYesPressed();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: getPlatformBrightness() ? AppBar_PrimaryColor1 : Con_Main_1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Yes'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
