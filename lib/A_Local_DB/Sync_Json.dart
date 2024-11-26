import 'package:hive/hive.dart';
import 'package:nextapp/A_SQL_Trigger/sql_contact.dart';
import 'package:nextapp/Constant/Constants.dart';

import '../A_FB_Trigger/SharedPref.dart';
import '../A_FB_Trigger/USER_MSG_AUTOSENDER.dart';
import '../A_FB_Trigger/sql_need_broadcast_sub_msg.dart';
import '../A_FB_Trigger/sql_need_contact.dart';
import '../A_FB_Trigger/sql_need_main_sub_chat.dart';
import '../A_FB_Trigger/sql_need_mainchat.dart';
import '../A_FB_Trigger/sql_need_quickreply.dart';
import '../A_FB_Trigger/sql_user_broadcast.dart';
import '../A_FB_Trigger/sql_user_device_session.dart';
import '../A_SQL_Trigger/Local_Contact.dart';
import '../A_SQL_Trigger/sql_usermast.dart';
import '../Constant/Con_Usermast.dart';

class SyncJSon {
  ///todo  user_mast
  static user_mast_table_save(List herds) async {
    if (herds.isNotEmpty && herds[0]['ID'].toString().trim() != '0') {
      var box = await Hive.openBox<sql_usermast_tran>("sql_usermast_tran");
      herds
          .map(
              (e) => box.put(e['ID'].toString(), sql_usermast_tran.fromJson(e)))
          .toList();
    }
  }

  static user_mast_table_select() async {
    var box = await Hive.openBox<sql_usermast_tran>("sql_usermast_tran");
    var values = box.values.toList();
    return values;
  }

  static user_mast_table_Clear() async {
    var box = await Hive.openBox<sql_usermast_tran>("sql_usermast_tran");
    await box.clear();
  }

  ///todo end user_mast

  ///todo  Auto Sender
  static Future<bool> user_auto_sender_save(List herds) async {
    if (herds.isNotEmpty) {
      var box = await Hive.openBox<USER_MSG_AUTOSENDER>("USER_MSG_AUTOSENDER");
      herds
          .map((e) =>
              box.put(e['id'].toString(), USER_MSG_AUTOSENDER.fromJson(e)))
          .toList();
    }
    user_auto_sender_select();
    return true;
  }

  static user_auto_sender_select() async {
    var box = await Hive.openBox<USER_MSG_AUTOSENDER>("USER_MSG_AUTOSENDER");
    var values = box.values.toList();
    return values;
  }

  static user_auto_sender_delete(String msgid) async {
    var box = await Hive.openBox<USER_MSG_AUTOSENDER>("USER_MSG_AUTOSENDER");
    await box.delete(msgid);
  }

  ///todo end Auto Sender

  ///todo  Local Contact
  static Future<bool> user_local_contact_save(List<Local_Contact> herds) async {
    if (herds.isNotEmpty) {
      var box = await Hive.openBox<Local_Contact>("Local_Contact");
      herds.map((e) => box.put(e.mobile_number.toString(), e)).toList();
    }
    return true;
  }

  static user_local_contact_select() async {
    var box = await Hive.openBox<Local_Contact>("Local_Contact");
    var values = box.values.toList();
    return values;
  }

  ///todo end Auto Sender

  ///todo user_contact
  static user_contact_save(List herds) async {
    if (herds.isNotEmpty) {
      List<Local_Contact> loc_con = await user_local_contact_select();
      if (loc_con.isNotEmpty) {
        herds = herds
            .where((e) => loc_con
                .any((u) => u.mobile_number.contains(e['mobile_number'])))
            .toList();
      var box = await Hive.openBox<Need_Contact>("Need_Contact");
      herds.map((e) => box.put(e['id'], Need_Contact.fromJson(e))).toList();
      Constants_List.need_contact = await user_contact_select_contacts(0);
      }
    }
  }

  // static user_contact_delete() async {
  //   var box = await Hive.openBox<Need_Contact>("Need_Contact");
  //   List<Need_Contact> Contacts = box.values.toList();
  //   List<Local_Contact> loc_con = await user_local_contact_select();
  //   if (loc_con.isNotEmpty) {
  //     Contacts = Contacts.where((e) => !(loc_con
  //         .any((u) => (u.mobile_number.contains(e.mobile_number))))).toList();
  //
  //     Contacts.forEach((e) async {
  //       await box.delete(e.id.toString());
  //     });
  //
  //     // print(box.values.length);
  //   }
  //   Constants_List.need_contact = await user_contact_select_contacts(0);
  // }

  static user_contact_select_contacts_stream() async {
    var box = Hive.openBox<Need_Contact>("Need_Contact").asStream();
    box.listen((event) {
      var fav = event.values.toList();
      Constants_List.need_contact = fav;
    });
    return Future.value(Constants_List.need_contact);
    // var box = Hive.openBox<Need_Contact>("Need_Contact").asStream();
    // box.listen((event) {
    //   var contact = event.values.toList();
    //   Constants_List.need_contact = contact;
    //   var online = event.values
    //       .where((element) =>
    //           element.user_is_online == true &&
    //           element.user_exist_in_mobile == true)
    //       .toList();
    //   Constants_List.needs_online = online;
    //
    //   var fav = event.values
    //       .where((element) =>
    //           element.user_is_favourite == true &&
    //           element.user_exist_in_mobile == true &&
    //           element.user_is_block == false)
    //       .toList();
    //   Constants_List.needs_fav = fav;
    //
    //   var block = event.values
    //       .where((element) =>
    //           element.user_is_block == true &&
    //           element.user_exist_in_mobile == true)
    //       .toList();
    //   Constants_List.needs_block = block;
    // });
  }

  static Future<Box> user_contact_select_fav_box() async {
    var box = await Hive.openBox<Need_Contact>("Need_Contact");
    return box;
  }

  static Future<List<Need_Contact>> user_contact_select_fav_stream() {
    var box = Hive.openBox<Need_Contact>("Need_Contact").asStream();
    box.listen((event) {
      var fav = event.values
          .where((element) =>
              element.user_is_favourite == true &&
              element.user_exist_in_mobile == true &&
              element.user_is_block == false)
          .toList();
      Constants_List.needs_fav = fav;
    });
    return Future.value(Constants_List.needs_fav);
  }

  static Future<List<Need_Contact>> user_contact_select_online_stream() async {
    var box = Hive.openBox<Need_Contact>("Need_Contact").asStream();
    box.listen((event) {
      var online = event.values
          .where((element) =>
              element.user_is_online == true &&
              element.user_exist_in_mobile == true)
          .toList();
      Constants_List.needs_online = online;
    });
    return Future.value(Constants_List.needs_online);
  }

  static Future<Box> user_contact_box() async {
    var _myBox = await Hive.openBox<Need_Contact>('Need_Contact');
    return _myBox;
  }

  static user_contact_select_contacts(int pInt) async {
    user_contact_select_contacts_stream();
    if (pInt == 0) {
      for (int i = 0; i < Constants_List.need_contact.length;) {
        await sql_contact_tran.GetUserWiseBlock(
                Constants_List.need_contact[i].user_mast_id.toString())
            .then((value) {
          if (value) {
            Constants_List.need_contact.removeAt(i);
          }
          i++;
        });
      }
      return (Constants_List.need_contact);
    } else if (pInt == 1) {
      return (Constants_List.needs_online);
    } else if (pInt == 2) {
      return (Constants_List.needs_fav);
    } else if (pInt == 3) {
      return (Constants_List.needs_block);
    }
  }

  // static user_contact_select_fromBox(Box<Need_Contact> box,int pInt) async {
  //   // var box = await Hive.openBox<Need_Contact>("Need_Contact");
  //   if (pInt == 0) {
  //     var values = box.values.toList();
  //     Constants_List.need_contact = values;
  //     return Constants_List.need_contact;
  //   } else if (pInt == 1) {
  //     var values = box.values
  //         .where((element) =>
  //             element.user_is_online == true &&
  //             element.user_exist_in_mobile == true)
  //         .toList();
  //     Constants_List.needs_online = values;
  //     return Constants_List.needs_online;
  //   } else if (pInt == 2) {
  //     var values = box.values
  //         .where((element) =>
  //             element.user_is_favourite == true &&
  //             element.user_exist_in_mobile == true &&
  //             element.user_is_block == false)
  //         .toList();
  //     Constants_List.needs_fav = values;
  //     return Constants_List.needs_fav;
  //   } else if (pInt == 3) {
  //     var values = box.values
  //         .where((element) =>
  //             element.user_is_block == true &&
  //             element.user_exist_in_mobile == true)
  //         .toList();
  //     Constants_List.needs_block = values;
  //     return Constants_List.needs_block;
  //   }
  // }

  ///todo end user_contact

  ///todo user_broadcast
  static user_broadcast_save(List herds) async {
    if (herds.isNotEmpty) {
      var box = await Hive.openBox<Need_Broadcast>("Need_Broadcast");
      if (herds.isNotEmpty || herds.isNotEmpty) {
        herds
            .map((e) => box.put(e['id'].toString(), Need_Broadcast.fromJson(e)))
            .toList();
      }
    }
  }

  // static user_broadcast_select() {
  //   var box = Hive.openBox<Need_Broadcast>("Need_Broadcast").asStream();
  //   box.listen((event) {
  //     Constants_List.need_broadcast = event.values.toList();
  //   });
  // }
  static Future<Box> user_broadcast_select() async {
    var _myBox = await Hive.openBox<Need_Broadcast>('Need_Broadcast');
    return _myBox;
  }

  static user_broadcast_update(String pStrFromId) async {
    var box = await Hive.openBox<Need_Broadcast_Sub_Msg>(
        "Need_Broadcast_Sub_Msg" + pStrFromId);
    await box.clear();
  }

  static user_broadcast_delete(String pStrFromId) async {
    var box = await Hive.openBox<Need_Broadcast>("Need_Broadcast");
    await box.delete(pStrFromId);
  }

  static Future<String> user_broadcast_maxId() async {
    var box = await Hive.openBox<Need_Broadcast>("Need_Broadcast");
    return box.values.isNotEmpty ? box.values.last.id.toString() : "0";
  }

  ///todo end user_broadcast

  ///todo user_msg_broadcast
  static user_msg_broadcast_save(List herds, String pStrBrId) async {
    try {
      if (herds.isNotEmpty) {
        var box = await Hive.openBox<Need_Broadcast_Sub_Msg>(
            "Need_Broadcast_Sub_Msg" + pStrBrId);
        if (herds.isNotEmpty || herds.isNotEmpty) {
          herds
              .map((e) => box.put(
                  e['id'].toString(), Need_Broadcast_Sub_Msg.fromJson(e)))
              .toList();
        }
      }
    } catch (e) {}
  }

  static user_msg_broadcast_select(String pStrBrId) async {
    var box = await Hive.openBox<Need_Broadcast_Sub_Msg>(
        "Need_Broadcast_Sub_Msg" + pStrBrId);
    return box.values.toList();
  }

  static user_msg_broadcast_update() async {
    // int count = await db.rawUpdate(
    //     'UPDATE USER_MSG_BROADCAST SET msg_is_clear_by_from_user = 1   WHERE id = ?',
    //     [pStrFromId]);
  }

  static user_msg_broadcast_delete(String pStrBrId, bool isdeleteall,
      [String? msgId]) async {
    var box = await Hive.openBox<Need_Broadcast_Sub_Msg>(
        "Need_Broadcast_Sub_Msg" + pStrBrId);

    if (isdeleteall) {
      box.clear();
    } else {
      var inputSplit = msgId?.split(",");
      inputSplit?.forEach((e) => box.delete(e.toString()));
    }
  }

  static Future<String> user_msg_broadcast_maxId() async {
    var box = await Hive.openBox<Need_Broadcast>("Need_Broadcast");
    return box.values.isNotEmpty ? box.values.last.id.toString() : "0";
  }

  ///todo end user_sub_main_chat

  ///todo user_quick_rep
  static user_quick_rep_save(List herds) async {
    if (herds.isNotEmpty) {
      var box = await Hive.openBox<Need_QuickReply>("Need_QuickReply");
      herds
          .map((e) => box.put(e['id'].toString(), Need_QuickReply.fromJson(e)))
          .toList();
    }
  }

  static user_quick_rep_select() async {
    var box = Hive.openBox<Need_QuickReply>("Need_QuickReply").asStream();
    box.listen((event) {
      Constants_List.need_quickreply = event.values.toList();
    });
    return Constants_List.need_quickreply;
  }

  static Stream<Box<Need_QuickReply>> user_quick_rep_stream() {
    var box = Hive.openBox<Need_QuickReply>("Need_QuickReply").asStream();
    return box;
  }

  static Future<Box> user_quick_rep_box() async {
    var box = await Hive.openBox<Need_QuickReply>('Need_QuickReply');
    return box;
  }

  static user_quick_rep_delete(String pStrId) async {
    var box = await Hive.openBox<Need_QuickReply>("Need_QuickReply");
    final Map<dynamic, Need_QuickReply> deliveriesMap = box.toMap();
    deliveriesMap.forEach((key, value) {
      if (value.id == int.tryParse(pStrId)) {
        box.delete(key);
      }
    });
  }

  static Future<String> user_quick_rep_maxId() async {
    var box = await Hive.openBox<Need_QuickReply>("Need_QuickReply");
    return box.values.isNotEmpty ? box.values.last.id.toString() : "0";
  }

  ///todo end user_quick_rep

  ///todo user_device_session
  static user_device_session_save(List herds) async {
    if (herds.isNotEmpty) {
      var box = await Hive.openBox<Need_DeviceSession>("Need_DeviceSession");
      herds.map((e) {
        if (Constants_Usermast.user_id.toString() ==
            e['user_mast_id'].toString()) {
          box.delete(e['id'].toString());
          box.put(e['id'].toString(), Need_DeviceSession.fromJson(e));
        }
      }).toList();
    }
  }

  static user_device_session_select() async {
    var box = Hive.openBox<Need_DeviceSession>("Need_DeviceSession").asStream();
    box.listen((event) {
      event.delete("0");
      Constants_List.need_DeviceSession = event.values.toList();
    });
    return Constants_List.need_DeviceSession;
  }

  static Future<String> user_device_session_maxId() async {
    var box = await Hive.openBox<Need_DeviceSession>("Need_DeviceSession");
    return box.values.isNotEmpty ? box.values.last.id.toString() : "0";
  }

  ///todo end user_device_session

  ///todo user_main_chat
  static Future<Box> user_main_chat_box() async {
    var _myBox = await Hive.openBox<Need_MainChat>('Need_MainChat');
    return _myBox;
  }

  static Future<Box> user_main_chat_UnreadCount() async {
    var _myBox = await Hive.openBox<Need_MainChat>('Need_MainChat');
    return _myBox;
  }

  static user_main_chat_save(List herds) async {
    var box = await Hive.openBox<Need_MainChat>("Need_MainChat");

    herds =
        herds.where((e) => e['msg_is_delete_by_from_user'] == false).toList();
    if (herds.isNotEmpty) {
      List<Local_Contact> loc_con = await user_local_contact_select();
      herds.forEach((e) {
        if (loc_con.any((u) =>
            e['user_countrywithmobile'].toString().contains(u.mobile_number))) {
          e['disp_name'] = loc_con
              .firstWhere((c) => e['user_countrywithmobile']
                  .toString()
                  .contains(c.mobile_number))
              .disp_name;
        } else {
          e['disp_name'] = e['user_countrywithmobile'];
        }
      });
      ;
      herds.map((e) {
        if (Constants_Usermast.user_id.toString() !=
            e['msg_to_user_mast_id'].toString()) {
          box.put(
              e['msg_to_user_mast_id'].toString(), Need_MainChat.fromJson(e));
        }
      }).toList();
      SharedPref.savelist(
          'Need_MainChat',
          box.values
              .toList()
              .map((e) =>
                  e.user_mast_id.toString() + '/*/' + e.disp_name.toString())
              .toList());
    }
  }

  static user_main_chat_select() async {
    var box = await Hive.openBox<Need_MainChat>("Need_MainChat");

    return box.values.toList();
  }

  // static Stream<List<Need_MainChat>> user_main_chat_stream() {
  //   var box = Hive.openBox<Need_MainChat>("Need_MainChat").asStream();
  //   box.listen((event) {
  //     Constants_List.needs_main_chat = event.values.toList();
  //     Constants_List.needs_main_chat.sort(
  //       (a, b) => b.inserted_time_show.compareTo(a.inserted_time_show),
  //     );
  //   });
  //   return Stream.value(Constants_List.needs_main_chat);
  // }

  static user_main_chat_delete(String ToId) async {
    var box1 = await Hive.openBox<Need_MainChat>("Need_MainChat");
    await box1.delete(ToId);
  }

  ///todo end user_main_chat

  ///todo user_sub_main_chat
  static user_sub_main_chat_save(List herds) async {
    if (herds.isNotEmpty) {
      var box = await Hive.openBox<Need_Main_Sub_Chat>(
          "Need_Main_Sub_Chat");
      herds.map((e) async {
        if (e['msg_from_user_mast_id'].toString() ==
                Constants_Usermast.user_id.toString() ||
            e['msg_to_user_mast_id'].toString() == Constants_Usermast.user_id.toString()) {
          // box.delete(e['id'].toString());
          box.put(e['id'].toString(), Need_Main_Sub_Chat.fromJson(e));
        }
      }).toList();
    }
  }

  static user_sub_main_chat_select() async {
    var box =
        await Hive.openBox<Need_Main_Sub_Chat>("Need_Main_Sub_Chat");
    return box.values.toList();
  }

  static Future<Box> user_sub_chat_Box() async {
    var box =
        await Hive.openBox<Need_Main_Sub_Chat>("Need_Main_Sub_Chat");
    return box;
  }

  static user_sub_main_chat_update(String pStrFromId) async {
    // int count = await db.rawUpdate(  'UPDATE USER_MSG SET msg_delivered = 1   WHERE msg_delivered=0 and msg_from_user_mast_id = ? and  msg_to_user_mast_id = ?  ' ,[pStrFromId,pStrToId]);
    // int count1 = await db.rawUpdate(  'UPDATE USER_MSG_LAST SET msg_delivered = 1   WHERE msg_delivered=0 and msg_from_user_mast_id = ? and  msg_to_user_mast_id = ?  ' ,[pStrFromId,pStrToId]);
  }

  static user_sub_main_chat_delete(String UserToId, bool isdeleteall,
      [String? msgId]) async {
    var box =
        await Hive.openBox<Need_Main_Sub_Chat>("Need_Main_Sub_Chat");
    if (isdeleteall) {
      box.clear();
    } else {
      var inputSplit = msgId?.split(",");
      inputSplit?.forEach((e) => box.delete(e.toString()));
    }
  }

  ///todo end user_sub_main_chat

// static Future<List<Need_Main_Sub_Chat>> sub_contact_read_msg(
//     bool _bln, String pStrRedirectUserid) async {
//   List<Need_Main_Sub_Chat> _needs_sub_msg = [];
//   String decode = await SharedPref.read_string(pStrRedirectUserid);
//   if (decode.isNotEmpty) {
//     try {
//       if (decode != null) {
//         _needs_sub_msg = Need_Main_Sub_Chat.decode(decode);
//         return _needs_sub_msg;
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
//   return _needs_sub_msg;
// }

// static Future<List<Need_Broadcast_Sub_Msg>> sub_contact_broad_read_msg(
//     String pStrBroadId) async {
//   List<Need_Broadcast_Sub_Msg> _needs_broad_sub_msg = [];
//   String decode = await SharedPref.read_string("BROAD_ID" + pStrBroadId);
//   if (decode.isNotEmpty) {
//     try {
//       if (decode != null) {
//         _needs_broad_sub_msg = Need_Broadcast_Sub_Msg.decode(decode);
//         return _needs_broad_sub_msg;
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
//   return _needs_broad_sub_msg;
// }
}
