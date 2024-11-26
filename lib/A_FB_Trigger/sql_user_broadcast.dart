import 'dart:convert';

import 'package:hive/hive.dart';

part 'sql_user_broadcast.g.dart';

@HiveType(typeId: 3)
class Need_Broadcast extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String image;
  @HiveField(3)
  final String count;
  @HiveField(4)
  final String date;
  @HiveField(5)
  final String last_msg;
  @HiveField(6)
  final String last_date;
  @HiveField(7)
  bool is_selected;
  @HiveField(8)
  final String br_msg_content;
  @HiveField(9)
  final String br_name;
  @HiveField(10)
  final String br_profile_pic;
  @HiveField(11)
  final String br_exist_user;
  @HiveField(12)
  final int user_mast_id;
  @HiveField(13)
  final String br_modified_time_show;
  @HiveField(14)
  var br_msg_type;
  @HiveField(15)
  var br_modified_time;

  Need_Broadcast({
    required this.id,
    required this.name,
    required this.image,
    required this.count,
    required this.date,
    required this.last_msg,
    required this.last_date,
    required this.is_selected,
    required this.br_msg_content,
    required this.br_name,
    required this.br_profile_pic,
    required this.br_exist_user,
    required this.user_mast_id,
    required this.br_modified_time_show,
    required this.br_msg_type,
    required this.br_modified_time,
  });

  Need_Broadcast.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        name = json['name'].toString(),
        image = json['image'].toString(),
        count = json['count'].toString(),
        date = json['date'].toString(),
        last_msg = json['last_msg'].toString(),
        last_date = json['last_date'].toString(),
        is_selected = json['is_selected'] ?? false,
        br_msg_content = json['br_msg_content'].toString(),
        br_name = json['br_name'].toString(),
        br_profile_pic = json['br_profile_pic'].toString(),
        br_exist_user = json['br_exist_user'].toString(),
        user_mast_id = json['user_mast_id'] ?? 0,
        br_modified_time_show = json['br_modified_time_show'] ?? "",
        br_msg_type = json['br_msg_type'] ?? 0,
        br_modified_time = json['br_modified_time'] ?? '';

  static Map<String, dynamic> toJson(Need_Broadcast fav) {
    return {
      'id': fav.id,
      'name': fav.name,
      'image': fav.image,
      'count': fav.count,
      'date': fav.date,
      'last_msg': fav.last_msg,
      'last_date': fav.last_date,
      'is_selected': fav.is_selected,
      'br_msg_content': fav.br_msg_content,
      'br_name': fav.br_name,
      'br_profile_pic': fav.br_profile_pic,
      'br_exist_user': fav.br_exist_user,
      'user_mast_id': fav.user_mast_id,
      'br_msg_type': fav.br_msg_type,
      'br_modified_time_show': fav.br_modified_time_show,
      'br_modified_time': fav.br_modified_time
    };
  }

  static String encode(List<Need_Broadcast> musics) {
    return json.encode(
      musics.map<Map<String, dynamic>>((music) {
        return Need_Broadcast.toJson(music);
      }).toList(),
    );
  }

  static List<Need_Broadcast> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<Need_Broadcast>((item) => Need_Broadcast.fromJson(item))
          .toList();

  Map<String, dynamic> toJson1() {
    return {
      "id": id,
      "name": name,
      "image": image,
      "count": count,
      "date": date,
      "last_msg": last_msg,
      "last_date": last_date,
      "is_selected": is_selected,
      "br_msg_content": br_msg_content,
      "br_name": br_name,
      "br_profile_pic": br_profile_pic,
      "br_msg_type": br_msg_type,
      "br_exist_user": br_exist_user,
      "user_mast_id": user_mast_id,
      "br_modified_time_show": br_modified_time_show,
      "br_modified_time": br_modified_time,
    };
  }
}
