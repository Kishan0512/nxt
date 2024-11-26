import 'dart:convert';

import 'package:hive/hive.dart';

part 'sql_need_main_sub_chat.g.dart';

@HiveType(typeId: 8)
class Need_Main_Sub_Chat extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String msg_timestamp;
  @HiveField(2)
  final String msg_audio_name;
  @HiveField(3)
  final String msg_media_size;
  @HiveField(4)
  final String msg_content;
  @HiveField(5)
  final String is_right;
  @HiveField(6)
  final String is_read;
  @HiveField(7)
  final String read_time;
  @HiveField(8)
  final String delivered_time;
  @HiveField(9)
  final String date;
  @HiveField(10)
  final String center_date;
  @HiveField(11)
  final String msg_type;
  @HiveField(12)
  final String msg_to_user_mast_id;
  @HiveField(13)
  final String msg_from_user_mast_id;
  @HiveField(14)
  final String document_url;
  @HiveField(15)
  final String is_delivered;
  @HiveField(16)
  final String msg_blurhash;
  @HiveField(17)
  final String broadcast_id;
  @HiveField(18)
  final String broadcast_bulk_id;

  Need_Main_Sub_Chat(
      {required this.id,
      required this.document_url,
      required this.msg_audio_name,
      required this.msg_media_size,
      required this.msg_content,
      required this.is_right,
      required this.is_read,
      required this.read_time,
      required this.delivered_time,
      required this.msg_timestamp,
      required this.date,
      required this.is_delivered,
      required this.broadcast_bulk_id,
      required this.broadcast_id,
      required this.center_date,
      required this.msg_type,
      required this.msg_blurhash,
      required this.msg_from_user_mast_id,
      required this.msg_to_user_mast_id});

  factory Need_Main_Sub_Chat.fromJson(Map<String, dynamic> json) {
    return Need_Main_Sub_Chat(
      id: json['id'].toString(),
      document_url: json['msg_document_url'].toString(),
      msg_audio_name: json['msg_audio_name'].toString(),
      msg_media_size: json['msg_media_size'].toString(),
      msg_content: json['msg_content'].toString(),
      is_right: json['is_right'].toString(),
      is_read: json['msg_read'].toString(),
      read_time: json['msg_read_timestamp_show'].toString(),
      delivered_time: json['msg_delivered_timestamp_show'].toString(),
      date: json['msg_timestamp_show'].toString(),
      msg_timestamp: json['msg_timestamp'].toString(),
      center_date: json['center_date'].toString(),
      msg_type: json['msg_type'].toString(),
      msg_to_user_mast_id: json['msg_to_user_mast_id'].toString(),
      msg_from_user_mast_id: json['msg_from_user_mast_id'].toString(),
      is_delivered: json['msg_delivered'].toString(),
      msg_blurhash: json['msg_blurhash'].toString(),
      broadcast_id: json['broadcast_id'].toString(),
      broadcast_bulk_id: json['broadcast_bulk_id'].toString(),
    );
  }

  static List<Need_Main_Sub_Chat> decode(String musics) {
    return (json.decode(musics) as List<dynamic>)
        .map<Need_Main_Sub_Chat>((item) => Need_Main_Sub_Chat.fromJson(item))
        .toList();
  }

  static String encode(List<Need_Main_Sub_Chat> msg) => json.encode(
        msg.map<Map<String, dynamic>>((e) => tojson(e)).toList(),
      );

  static Map<String, dynamic> tojson(Need_Main_Sub_Chat m) {
    return {
      "id": m.id.toString(),
      "msg_document_url": m.document_url.toString(),
      "msg_audio_name": m.msg_audio_name.toString(),
      "msg_media_size": m.msg_media_size.toString(),
      "msg_content": m.msg_content,
      "is_right": m.is_right,
      "msg_read": m.is_read,
      "msg_read_timestamp_show": m.read_time,
      "msg_delivered_timestamp_show": m.delivered_time,
      "msg_delivered": m.is_delivered,
      "msg_timestamp_show": m.date,
      "msg_timestamp": m.msg_timestamp,
      "center_date": m.center_date,
      "msg_type": m.msg_type,
      "msg_to_user_mast_id": m.msg_to_user_mast_id,
      "msg_from_user_mast_id": m.msg_from_user_mast_id,
      "msg_blurhash": m.msg_blurhash,
      "broadcast_bulk_id": m.broadcast_bulk_id,
      "broadcast_id": m.broadcast_id
    };
  }
}
