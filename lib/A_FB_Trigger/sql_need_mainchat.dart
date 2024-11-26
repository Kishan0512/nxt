import 'dart:convert';

import 'package:hive/hive.dart';

part 'sql_need_mainchat.g.dart';

@HiveType(typeId: 7)
class Need_MainChat extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  int msg_from_user_mast_id;
  @HiveField(2)
  int msg_to_user_mast_id;
  @HiveField(3)
  String msg_content;
  @HiveField(4)
  String msg_read;
  @HiveField(5)
  String msg_read_timestamp_show;
  @HiveField(6)
  bool msg_delivered;
  @HiveField(7)
  String msg_delivered_timestamp_show;
  @HiveField(8)
  int msg_type;
  @HiveField(9)
  String msg_document_url;
  @HiveField(10)
  int is_selected;
  @HiveField(11)
  String disp_name;
  @HiveField(12)
  String inserted_time_show;
  @HiveField(13)
  String user_profileimage_path;
  @HiveField(14)
  int uc_contact_id;
  @HiveField(15)
  int user_mast_id;
  @HiveField(16)
  bool user_is_favourite;
  @HiveField(17)
  bool user_is_block;
  @HiveField(18)
  String user_last_msg;
  @HiveField(19)
  String user_last_login_time;
  @HiveField(20)
  bool user_is_online;
  @HiveField(21)
  String mobile_number;
  @HiveField(22)
  String user_bio;
  @HiveField(23)
  String user_bio_last_datetime;
  @HiveField(24)
  String user_birthdate;
  @HiveField(25)
  String user_countrywithmobile;
  @HiveField(26)
  int msg_unread_count;
  @HiveField(27)
  int msg_last_id;
  @HiveField(28)
  int msg_unread_count_total;
  @HiveField(29)
  int msg_id;
  @HiveField(30)
  String server_key;
  @HiveField(31)
  var inserted_time;
  @HiveField(32)
  var msg_is_delete_by_from_user;

  Need_MainChat(
      {required this.id,
      required this.msg_from_user_mast_id,
      required this.msg_to_user_mast_id,
      required this.msg_content,
      required this.msg_read,
      required this.msg_read_timestamp_show,
      required this.msg_delivered,
      required this.msg_delivered_timestamp_show,
      required this.msg_type,
      required this.msg_document_url,
      required this.is_selected,
      required this.disp_name,
      required this.inserted_time_show,
      required this.user_profileimage_path,
      required this.uc_contact_id,
      required this.inserted_time,
      required this.user_mast_id,
      required this.user_is_favourite,
      required this.user_is_block,
      required this.user_last_msg,
      required this.user_last_login_time,
      required this.user_is_online,
      required this.mobile_number,
      required this.user_bio,
      required this.user_bio_last_datetime,
      required this.user_birthdate,
      required this.user_countrywithmobile,
      required this.msg_unread_count,
      required this.msg_last_id,
      required this.msg_unread_count_total,
      required this.msg_id,
      required this.msg_is_delete_by_from_user,
      this.server_key = ""});

  static bool parseBool(String pStr /*String key, String dis*/) {
    if (pStr == '1') {
      return true;
    } else if (pStr == '0') {
      return false;
    } else if (pStr.toString().toLowerCase() == 'true') {
      return true;
    } else if (pStr.toString().toLowerCase() == 'false') {
      return false;
    } else if (pStr.toString().toLowerCase() == '0') {
      return false;
    } else if (pStr.isEmpty) {
      return false;
    }
    return false;
  }

  factory Need_MainChat.fromJson(Map<String, dynamic> json) {
    return Need_MainChat(
        id: json['id'],
        msg_from_user_mast_id: json['msg_from_user_mast_id'] ?? 0,
        msg_to_user_mast_id: json['msg_to_user_mast_id'] ?? 0,
        msg_content: json['msg_content'] ?? "",
        msg_read: json['msg_read'].toString(),
        msg_read_timestamp_show: json['msg_read_timestamp_show'] ?? "",
        msg_delivered: parseBool(json['msg_delivered'].toString()),
        msg_delivered_timestamp_show:
            json['msg_delivered_timestamp_show'] ?? "",
        msg_type: json['msg_type'] ?? 0,
        msg_document_url: json['msg_document_url'] ?? "",
        is_selected: json['is_selected'] ?? 0,
        disp_name: json['disp_name'] ?? "",
        inserted_time_show: json['inserted_time_show'] ?? "",
        user_profileimage_path: json['user_profileimage_path'] ?? "",
        uc_contact_id: json['uc_contact_id'] ?? 0,
        user_mast_id: json['user_mast_id'] ?? 0,
        user_is_favourite: parseBool(json['user_is_favourite'].toString()),
        user_is_block: parseBool(json['user_is_block'].toString()),
        user_last_msg: json['user_last_msg'] ?? "",
        user_last_login_time: json['user_last_login_time'] ?? "",
        user_is_online: parseBool(json['user_is_online'].toString()),
        mobile_number: json['mobile_number'] ?? "",
        user_bio: json['user_bio'] ?? "",
        user_bio_last_datetime: json['user_bio_last_datetime'] ?? "",
        user_birthdate: json['user_birthdate'] ?? "",
        user_countrywithmobile: json['user_countrywithmobile'] ?? "",
        msg_unread_count: json['msg_unread_count'] ?? 0,
        msg_last_id: json['msg_last_id'] ?? false,
        msg_unread_count_total: json['msg_unread_count_total'] ?? 0,
        inserted_time: json['inserted_time'] ?? "",
        msg_id: json['msg_id'] ?? 0,
        msg_is_delete_by_from_user: json['msg_is_delete_by_from_user'] ?? false,
        server_key: json['server_key'] ?? "0");
  }

  static List<Need_MainChat> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<Need_MainChat>((item) => Need_MainChat.fromJson(item))
          .toList();

  static String encode(List<Need_MainChat> msg) => json.encode(
        msg.map<Map<String, dynamic>>((e) => toJson1(e)).toList(),
      );

  static Map<String, dynamic> toJson1(Need_MainChat m) {
    return {
      "id": m.id,
      "msg_from_user_mast_id": m.msg_from_user_mast_id,
      "msg_to_user_mast_id": m.msg_to_user_mast_id,
      "msg_content": m.msg_content,
      "msg_read": m.msg_read,
      "msg_read_timestamp_show": m.msg_read_timestamp_show,
      "msg_delivered": m.msg_delivered,
      "msg_delivered_timestamp_show": m.msg_delivered_timestamp_show,
      "msg_type": m.msg_type,
      "msg_document_url": m.msg_document_url,
      "is_selected": m.is_selected,
      "disp_name": m.disp_name,
      "inserted_time_show": m.inserted_time_show,
      "inserted_time": m.inserted_time,
      "user_profileimage_path": m.user_profileimage_path,
      "uc_contact_id": m.uc_contact_id,
      "user_mast_id": m.user_mast_id,
      "user_is_favourite": m.user_is_favourite,
      "user_is_block": m.user_is_block,
      "user_last_msg": m.user_last_msg,
      "user_last_login_time": m.user_last_login_time,
      "user_is_online": m.user_is_online,
      "mobile_number": m.mobile_number,
      "user_bio": m.user_bio,
      "user_bio_last_datetime": m.user_bio_last_datetime,
      "user_birthdate": m.user_birthdate,
      "user_countrywithmobile": m.user_countrywithmobile,
      "msg_unread_count": m.msg_unread_count,
      "msg_last_id": m.msg_last_id,
      "msg_unread_count_total": m.msg_unread_count_total,
      "msg_id": m.msg_id,
      "msg_is_delete_by_from_user": m.msg_is_delete_by_from_user,
      "server_key": m.server_key
    };
  }
}
