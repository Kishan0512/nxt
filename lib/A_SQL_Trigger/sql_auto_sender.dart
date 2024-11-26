import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nextapp/A_Local_DB/Sync_Json.dart';
import 'package:nextapp/A_SQL_Trigger/ConstantApi.dart';

import '../A_Local_DB/Sync_Database.dart';
import '../Constant/Constants.dart';

class sql_auto_sender_tran {
  static Future<bool> Send_Msg({
    String? id,
    required String msgContent,
    required String msgFromUserMastId,
    required String msgToUserMastIds,
    required String msgTypeDateUtc,
    required String msgTypeDateTimeUtc,
    required String msgTypeBtn,
    required String msgTypeDateTime,
    required String tran_type,
    required List<Map<String, String>> mediaList,
  }) async {
    Map<String, dynamic> requestBody = {
      if (tran_type == 'UPDATE') "id": id.toString().trim(),
      "msg_content": msgContent.trim(),
      "msg_from_user_mast_id": msgFromUserMastId.trim(),
      "msg_to_user_mast_ids": msgToUserMastIds.trim(),
      "msg_type_date_utc": msgTypeDateUtc.trim(),
      "msg_type_date_time_utc": msgTypeDateTimeUtc.trim(),
      "msg_type_btn": msgTypeBtn.trim(),
      "msg_type_date_time": msgTypeDateTime.trim(),
      "mediaList": mediaList,
      "tran_type": tran_type.trim()
    };
    String requestBodyJson = jsonEncode(requestBody);
    final response = await http.post(
      Uri.parse(ConstantApi.AutoSender_Insert),
      headers: {"Content-Type": "application/json"},
      body: requestBodyJson,
    );
    if (response.statusCode == 200) {
      return await SyncDB.SyncTable(Constants.Table_Msg_AutoSender, false);
    } else {
      Fluttertoast.showToast(msg: "can't send message");
      return false;
    }
  }

  static Future<bool> Delete_Msg({required String id}) async {
    final response = await http.post(
      Uri.parse(ConstantApi.AutoSender_Delete),
      body: {"id": id.toString().trim(), "tran_type": "Delete"},
    );
    if (response.statusCode == 200) {
      await SyncJSon.user_auto_sender_delete(id);
      return await SyncDB.SyncTable(Constants.Table_Msg_AutoSender, false);
    } else {
      Fluttertoast.showToast(msg: "can't delete  message");
      return false;
    }
  }
}
