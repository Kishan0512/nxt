import 'dart:convert';

import 'package:hive/hive.dart';

part 'sql_need_contact.g.dart';

@HiveType(typeId: 2)
class Need_Contact extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  bool is_favourite;
  @HiveField(3)
  bool is_block;
  @HiveField(4)
  bool is_broadcast;
  @HiveField(5)
  bool is_group;
  @HiveField(6)
  int user_last_is_icon_status;
  @HiveField(7)
  String user_last_msg_timestamp;
  @HiveField(8)
  bool user_last_msg_delete;
  @HiveField(9)
  String user_last_msg;
  @HiveField(10)
  String user_last_login_time;
  @HiveField(11)
  bool user_last_is_online;
  @HiveField(12)
  String user_last_mobile_country_code;
  @HiveField(13)
  String user_last_final_mobile_number;
  @HiveField(14)
  String user_last_profile;
  @HiveField(15)
  String user_last_bio;
  @HiveField(16)
  String user_last_bio_date;
  @HiveField(17)
  String user_last_birthdate;
  @HiveField(18)
  bool user_exist_in_mobile;
  @HiveField(19)
  bool user_is_online;
  @HiveField(20)
  bool user_is_favourite;
  @HiveField(21)
  bool user_is_block;
  @HiveField(22)
  int user_mast_id;
  @HiveField(23)
  String mobile_number;
  @HiveField(24)
  String user_bio;
  @HiveField(25)
  String user_profileimage_path;
  @HiveField(26)
  String user_bio_last_datetime;
  @HiveField(27)
  String user_birthdate;
  @HiveField(28)
  String user_countrywithmobile;

  Need_Contact({
    required this.id,
    required this.name,
    required this.is_favourite,
    required this.is_block,
    required this.is_broadcast,
    required this.is_group,
    required this.user_last_is_icon_status,
    required this.user_last_msg_timestamp,
    required this.user_last_msg_delete,
    required this.user_last_msg,
    required this.user_last_login_time,
    required this.user_last_is_online,
    required this.user_last_mobile_country_code,
    required this.user_last_final_mobile_number,
    required this.user_last_profile,
    required this.user_last_bio,
    required this.user_last_bio_date,
    required this.user_last_birthdate,
    required this.user_exist_in_mobile,
    required this.user_is_online,
    required this.user_is_favourite,
    required this.user_is_block,
    required this.user_mast_id,
    required this.mobile_number,
    required this.user_bio,
    required this.user_profileimage_path,
    required this.user_bio_last_datetime,
    required this.user_birthdate,
    required this.user_countrywithmobile,
  });

  Need_Contact.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        name = json['disp_name'],
        is_favourite = json['is_favourite'] ?? false,
        is_block = json['is_block'] ?? false,
        is_broadcast = json['is_broadcast'] ?? false,
        is_group = json['is_group'] ?? false,
        user_last_is_icon_status = json['user_last_is_icon_status'] ?? 0,
        user_last_msg_timestamp = json['user_last_msg_timestamp'],
        user_last_msg_delete = json['user_last_msg_delete'],
        user_last_msg = json['user_last_msg'],
        user_last_login_time = json['user_last_login_time'],
        user_last_is_online = json['user_last_is_online'] ?? false,
        user_last_mobile_country_code =
            json['user_last_mobile_country_code'] ?? "",
        user_last_final_mobile_number =
            json['user_last_final_mobile_number'] ?? "",
        user_last_profile = json['user_last_profile'] ?? "",
        user_last_bio = json['user_last_bio'] ?? "",
        user_last_bio_date = json['user_last_bio_date'] ?? "",
        user_last_birthdate = json['user_last_birthdate'] ?? "",
        user_exist_in_mobile = json['user_exist_in_mobile'] ?? false,
        user_is_online = json['user_is_online'] ?? false,
        user_is_favourite = json['user_is_favourite'] ?? false,
        user_is_block = json['user_is_block'] ?? false,
        user_mast_id = json['user_mast_id'] ?? false,
        mobile_number = json['mobile_number'] ?? "",
        user_bio = json['user_bio'] ?? "",
        user_profileimage_path = json['user_profileimage_path'] ?? "",
        user_bio_last_datetime = json['user_bio_last_datetime'] ?? "",
        user_birthdate = json['user_birthdate'] ?? "",
        user_countrywithmobile = json['user_countrywithmobile'] ?? "";

  static Map<String, dynamic> toJson(Need_Contact fav) => {
        'id': fav.id,
        'name': fav.name,
        'is_favourite': fav.is_favourite,
        'is_block': fav.is_block,
        'is_broadcast': fav.is_broadcast,
        'is_group': fav.is_group,
        'user_last_is_icon_status': fav.user_last_is_icon_status,
        'user_last_msg_timestamp': fav.user_last_msg_timestamp,
        'user_last_msg_delete': fav.user_last_msg_delete,
        'user_last_msg': fav.user_last_msg,
        'user_last_login_time': fav.user_last_login_time,
        'user_last_is_online': fav.user_last_is_online,
        'user_last_mobile_country_code': fav.user_last_mobile_country_code,
        'user_last_final_mobile_number': fav.user_last_final_mobile_number,
        'user_last_profile': fav.user_last_profile,
        'user_last_bio': fav.user_last_bio,
        'user_last_bio_date': fav.user_last_bio_date,
        'user_last_birthdate': fav.user_last_birthdate,
        'user_exist_in_mobile': fav.user_exist_in_mobile,
        'user_is_online': fav.user_is_online,
        'user_is_favourite': fav.user_is_favourite,
        'user_is_block': fav.user_is_block,
        'user_mast_id': fav.user_mast_id,
        'mobile_number': fav.mobile_number,
        'user_bio': fav.user_bio,
        'user_profileimage_path': fav.user_profileimage_path,
      };

  Map<String, dynamic> toJson2(Need_Contact fav) => {
        'id': fav.id,
        'name': fav.name,
        'is_favourite': fav.is_favourite,
        'is_block': fav.is_block,
        'is_broadcast': fav.is_broadcast,
        'is_group': fav.is_group,
        'user_last_is_icon_status': fav.user_last_is_icon_status,
        'user_last_msg_timestamp': fav.user_last_msg_timestamp,
        'user_last_msg_delete': fav.user_last_msg_delete,
        'user_last_msg': fav.user_last_msg,
        'user_last_login_time': fav.user_last_login_time,
        'user_last_is_online': fav.user_last_is_online,
        'user_last_mobile_country_code': fav.user_last_mobile_country_code,
        'user_last_final_mobile_number': fav.user_last_final_mobile_number,
        'user_last_profile': fav.user_last_profile,
        'user_last_bio': fav.user_last_bio,
        'user_last_bio_date': fav.user_last_bio_date,
        'user_last_birthdate': fav.user_last_birthdate,
        'user_exist_in_mobile': fav.user_exist_in_mobile,
        'user_is_online': fav.user_is_online,
        'user_is_favourite': fav.user_is_favourite,
        'user_is_block': fav.user_is_block,
        'user_mast_id': fav.user_mast_id,
        'mobile_number': fav.mobile_number,
        'user_bio': fav.user_bio,
        'user_profileimage_path': fav.user_profileimage_path,
      };

  static String encode(List<Need_Contact> musics) => json.encode(
        musics
            .map<Map<String, dynamic>>((music) => Need_Contact.toJson(music))
            .toList(),
      );

  static List<Need_Contact> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<Need_Contact>((item) => Need_Contact.fromJson(item))
          .toList();

  Map<String, dynamic> toJson1() {
    return {
      "id": id,
      "name": name,
      "is_favourite": is_favourite,
      "is_block": is_block,
      "is_broadcast": is_broadcast,
      "is_group": is_group,
      "user_last_is_icon_status": user_last_is_icon_status,
      "user_last_msg_timestamp": user_last_msg_timestamp,
      "user_last_msg_delete": user_last_msg_delete,
      "user_last_msg": user_last_msg,
      "user_last_login_time": user_last_login_time,
      "user_last_is_online": user_last_is_online,
      "user_last_mobile_country_code": user_last_mobile_country_code,
      "user_last_final_mobile_number": user_last_final_mobile_number,
      "user_last_profile": user_last_profile,
      "user_last_bio": user_last_bio,
      "user_last_bio_date": user_last_bio_date,
      "user_last_birthdate": user_last_birthdate,
      "user_exist_in_mobile": user_exist_in_mobile,
      "user_is_online": user_is_online,
      "user_is_favourite": user_is_favourite,
      "user_is_block": user_is_block,
      "user_mast_id": user_mast_id,
      "mobile_number": mobile_number,
      "user_bio": user_bio,
      "user_profileimage_path": user_profileimage_path,
    };
  }
}
