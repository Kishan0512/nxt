import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:nextapp/A_Local_DB/Sync_Json.dart';
import 'package:nextapp/A_SQL_Trigger/ConstantApi.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:nextapp/Constant/Constants.dart';

import '../A_FB_Trigger/sql_need_contact.dart';
import '../A_Local_DB/Sync_Database.dart';

class sql_broadcast_tran {
  static SetBroadcastMain(
    String pStrid,
    String pstrbrName,
  ) async {

    final response =
        await http.post(Uri.parse(ConstantApi.BroadCastSaveName), body: {
      "id": pStrid,
      "br_name": pstrbrName,
    });
  }

  static SaveBroadCastDetail(
      String pStrGroupName,
      String pStrGroupPic,
      String pstrexecType,
      String pstrbroadId,
      List<Need_Contact> _needs) async {
    if (_needs.isNotEmpty) {
      String json =
          jsonEncode(_needs.map((i) => i.toJson1()).toList()).toString();
      if (json.isNotEmpty) {
        try {
          log({
            "contact_list": json.toString(),
            "contact_id": Constants_Usermast.user_id,
            "broad_id": pstrbroadId,
            "br_name": pStrGroupName,
            "br_profile_pic": pStrGroupPic.toString(),
            "exec_type": pstrexecType,
          }.toString());
          final response =
              await http.post(Uri.parse(ConstantApi.BroadSaveData), body: {
            "contact_list": json.toString(),
            "contact_id": Constants_Usermast.user_id,
            "broad_id": pstrbroadId,
            "br_name": pStrGroupName,
            "br_profile_pic": pStrGroupPic.toString(),
            "exec_type": pstrexecType,
          });
          print(response.statusCode);
          print(response.body);
        } catch (E) {}

        await SyncDB.SyncTable(Constants.Table_Contacts_broadcast, false);
      }
    }
  }

  static main_broadcast_delete_clear(String ids, String pStrType) async {
    final response = await http.post(
        Uri.parse(ConstantApi.Broad_MainMessageUserWiseDeleteClear),
        body: {"ids": ids, "type": pStrType});


    if (response.statusCode == 200) {

      if (pStrType == "DELETE") {
        var inputSplit = ids.split(",");
        for (var i = 0; i < inputSplit.length; i++) {
          SyncJSon.user_broadcast_delete(inputSplit[i]);
        }
      } else if (pStrType == "CLEAR") {
        var inputSplit = ids.split(",");
        for (var i = 0; i < inputSplit.length; i++) {
          SyncJSon.user_broadcast_update(inputSplit[i]);
        }
      }
    }
    SyncDB.SyncTable(Constants.Table_Contacts_broadcast, false);
    SyncDB.SyncTable(Constants.Table_Msg_broadcast, false);
    SyncDB.SyncTable(Constants.Table_Msg_broadcast, false);
  }

  static sub_broadcast_delete_clear(
      String pStrFromId, String ids, String pBlnSelectAll) async {
    final response = await http.post(
        Uri.parse(ConstantApi.Broad_SubMessageUserWiseDeleteClear),
        body: {
          "msg_from_user_mast_id": pStrFromId.toString(),
          "ids": ids.toString(),
          "SelectAll": pBlnSelectAll.toString()
        });
    if (response.statusCode == 200) {
      // var inputSplit = ids.split(",");

      // for (var i = 0; i < inputSplit.length; i++) {
      //   var value = inputSplit[i];}
      SyncJSon.user_msg_broadcast_delete(pStrFromId, false, ids);
    }
    SyncDB.SyncTable(Constants.Table_Contacts_broadcast, false);
    SyncDB.SyncTable(Constants.Table_Msg_broadcast, false);
    SyncDB.SyncTable(Constants.Table_Msg_broadcast, false);
  }
}
//
// class My_Broad_Contact {
//   int id;
//   int user_mast_id;
//   String br_name;
//   String br_created_time_show;
//   String br_modified_time_show;
//   int br_msg_type;
//   String br_profile_pic;
//   int br_last_msg_id;
//   String br_msg_content;
//   int user_unread_count;
//   int is_selected;
//   String br_exist_user;
//
//   My_Broad_Contact({
//     required this.id,
//     required this.user_mast_id,
//     required this.br_name,
//     required this.br_created_time_show,
//     required this.br_modified_time_show,
//     required this.br_msg_type,
//     required this.br_profile_pic,
//     required this.br_last_msg_id,
//     required this.br_msg_content,
//     required this.user_unread_count,
//     required this.is_selected,
//     required this.br_exist_user,
//   });
//
//   factory My_Broad_Contact.fromJson(Map<String, dynamic> json) {
//     return My_Broad_Contact(
//       id: json['id'],
//       user_mast_id: json['user_mast_id'] ?? 0,
//       br_name: json['br_name'] ?? "",
//       br_created_time_show: json['br_created_time_show'] ?? "",
//       br_modified_time_show: json['br_modified_time_show'] ?? "",
//       br_msg_type: json['br_msg_type'] ?? 0,
//       br_profile_pic: json['br_profile_pic'] ??
//           Constants_Usermast.user_broadimage_path_global,
//       br_last_msg_id: json['br_last_msg_id'] ?? 0,
//       br_msg_content: json['br_msg_content'] ?? "",
//       user_unread_count: json['user_unread_count'] ?? 0,
//       is_selected: json['is_selected'] ?? 0,
//       br_exist_user: json['br_exist_user'] ?? "",
//     );
//   }
//
//   static List<My_Broad_Contact> decode(String musics) =>
//       (json.decode(musics) as List<dynamic>)
//           .map<My_Broad_Contact>((item) => My_Broad_Contact.fromJson(item))
//           .toList();
//
//   Map<String, dynamic> toJson1() {
//     return {
//       "id": id,
//       "user_mast_id": user_mast_id,
//       "br_name": br_name,
//       "br_created_time_show": br_created_time_show,
//       "br_modified_time_show": br_modified_time_show,
//       "br_msg_type": br_msg_type,
//       "br_last_msg_id": br_last_msg_id,
//       "br_msg_content": br_msg_content,
//       "user_last_msg_delete": user_unread_count,
//       "user_last_msg": is_selected,
//       "br_exist_user": br_exist_user
//     };
//   }
// }
