import 'dart:convert';

import 'package:hive/hive.dart';

part 'sql_need_quickreply.g.dart';

@HiveType(typeId: 5)
class Need_QuickReply extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  int user_mast_id;
  @HiveField(2)
  String user_quick_value;
  @HiveField(3)
  int user_quick_ord;
  @HiveField(4)
  bool is_delete;

  Need_QuickReply({
    required this.id,
    required this.user_mast_id,
    required this.user_quick_value,
    required this.user_quick_ord,
    required this.is_delete,
  });

  factory Need_QuickReply.fromJson(Map<String, dynamic> json) {
    return Need_QuickReply(
      id: json['id'] ?? 0,
      user_mast_id: json['user_mast_id'] ?? 0,
      user_quick_value: json['user_quick_value'] ?? "",
      user_quick_ord: json['user_quick_ord'] ?? 0,
      is_delete: json['is_delete'] == null ? false : true,
    );
  }

  static List<Need_QuickReply> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<Need_QuickReply>((item) => Need_QuickReply.fromJson(item))
          .toList();

  static String encode(List<Need_QuickReply> msg) => json.encode(
        msg.map<Map<String, dynamic>>((e) => toJson(e)).toList(),
      );

  static Map<String, dynamic> toJson(Need_QuickReply m) {
    return {
      "id": m.id,
      "user_mast_id": m.user_mast_id,
      "user_quick_value": m.user_quick_value,
      "user_quick_ord": m.user_quick_ord,
      "is_delete": m.is_delete
    };
  }

  Map<String, dynamic> toJson1() {
    return {
      "id": id,
      "user_mast_id": user_mast_id,
      "user_quick_value": user_quick_value,
      "user_quick_ord": user_quick_ord,
      "is_delete": is_delete
    };
  }
}
