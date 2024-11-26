import 'dart:convert';

import 'package:hive/hive.dart';

part 'sql_need_broadcast_sub_msg.g.dart';

@HiveType(typeId: 4)
class Need_Broadcast_Sub_Msg {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String document_url;
  @HiveField(2)
  final String msg_type;
  @HiveField(3)
  final String msg_content;
  @HiveField(4)
  final String msg_audio_name;
  @HiveField(5)
  final String msg_media_size;
  @HiveField(6)
  final String is_right;
  @HiveField(7)
  final String is_read;
  @HiveField(8)
  final String read_time;
  @HiveField(9)
  final String delivered_time;
  @HiveField(10)
  final String date;
  @HiveField(11)
  final String center_date;
  @HiveField(12)
  final String broadcast_bulk_id;
  @HiveField(13)
  var msg_timestamp;
  @HiveField(14)
  final String is_delivered;

  Need_Broadcast_Sub_Msg(
      {required this.id,
      required this.document_url,
      required this.msg_type,
      required this.msg_content,
      required this.msg_audio_name,
      required this.msg_media_size,
      required this.is_right,
      required this.is_read,
      required this.read_time,
      required this.delivered_time,
      required this.is_delivered,
      required this.msg_timestamp,
      required this.date,
      required this.center_date,
      required this.broadcast_bulk_id});

  factory Need_Broadcast_Sub_Msg.fromJson(Map<String, dynamic> json) {
    return Need_Broadcast_Sub_Msg(
        id: json['id'].toString(),
        document_url: json['msg_document_url'].toString(),
        msg_type: json['msg_type'].toString(),
        msg_content: json['msg_content'].toString(),
        msg_audio_name: json['msg_audio_name'].toString(),
        msg_media_size: json['msg_media_size'].toString(),
        is_right: json['is_right'].toString(),
        is_read: json['msg_read'].toString(),
        read_time: json['msg_read_timestamp_show'].toString(),
        delivered_time: json['msg_delivered_timestamp_show'].toString(),
        date: json['msg_timestamp_show'].toString(),
        msg_timestamp: json['msg_timestamp'].toString(),
        center_date: json['center_date'].toString(),
        is_delivered: json['msg_delivered'].toString(),
        broadcast_bulk_id: json['broadcast_bulk_id'].toString());
  }

  static List<Need_Broadcast_Sub_Msg> decode(String musics) {
    return (json.decode(musics) as List<dynamic>)
        .map<Need_Broadcast_Sub_Msg>(
            (item) => Need_Broadcast_Sub_Msg.fromJson(item))
        .toList();
  }

  static String encode(List<Need_Broadcast_Sub_Msg> msg) => json.encode(
        msg.map<Map<String, dynamic>>((e) => tojson(e)).toList(),
      );

  static Map<String, dynamic> tojson(Need_Broadcast_Sub_Msg m) {
    return {
      "id": m.id.toString(),
      "msg_document_url": m.document_url.toString(),
      "msg_type": m.msg_type.toString(),
      "msg_content": m.msg_content,
      "msg_audio_name": m.msg_audio_name.toString(),
      "msg_media_size": m.msg_media_size.toString(),
      "is_right": m.is_right,
      "msg_read": m.is_read,
      "msg_delivered": m.is_delivered,
      "msg_read_timestamp_show": m.read_time,
      "msg_timestamp": m.msg_timestamp,
      "msg_delivered_timestamp_show": m.delivered_time,
      "msg_timestamp_show": m.date,
      "center_date": m.center_date,
      "broadcast_bulk_id": m.broadcast_bulk_id
    };
  }
}
