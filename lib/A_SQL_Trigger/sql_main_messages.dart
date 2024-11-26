import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nextapp/A_SQL_Trigger/ConstantApi.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:nextapp/Login/DownloadData.dart';

class sql_main_messages_tran {
  static UpdateDeliveryDataMain() async {
    final response =
        await http.post(Uri.parse(ConstantApi.MessageDeliveryUpdate), body: {
      "msg_to_user_mast_id": Constants_Usermast.user_id,
    });
    if (!DownloadData.Keyvalue.contains("UpdateDeliveryDataMain")) {
      DownloadData.Keyvalue.add("UpdateDeliveryDataMain");
      DownloadData.respones.add(response.statusCode);
    }
    if (response.statusCode == 200) {
    } else {
      throw Exception(
          'FAILED TO LOAD (sql_main_messages_tran,UpdateDeliveryDataMain)');
    }
  }

  static MarkAllAsRead() async {
    final response =
        await http.post(Uri.parse(ConstantApi.MessageReadDataUpdate), body: {
      "msg_to_user_mast_id": Constants_Usermast.user_id,
    });
    if (response.statusCode == 200) {
    } else {
      throw Exception(
          'FAILED TO LOAD (sql_main_messages_tran,UpdateReadMsgDataMain)');
    }
  }

  static ValueNotifier<bool> read = ValueNotifier(true);

  static ReadUserWiseMsg(String pStrToUser,String userId) async {
    if (read.value) {
      read.value = false;
      final response =
          await http.post(Uri.parse(ConstantApi.MessageReadUserWise), body: {
        "msg_from_user_mast_id": pStrToUser,
        "msg_to_user_mast_id": userId,
      });
      if (response.statusCode == 200) {
        read.value = true;
      }
    }
  }
}
