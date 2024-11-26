import 'package:hive/hive.dart';

part 'USER_MSG_AUTOSENDER.g.dart';

@HiveType(typeId: 10)
class USER_MSG_AUTOSENDER extends HiveObject {
  @HiveField(0)
  final String msgContent;
  @HiveField(1)
  final int? id;
  @HiveField(2)
  final int msgFromUserMastId;
  @HiveField(3)
  final String msgToUserMastIds;
  @HiveField(4)
  final String? msgTimestamp;
  @HiveField(5)
  final String msgTypeDateUtc;
  @HiveField(6)
  final String msgTypeDateTimeUtc;
  @HiveField(7)
  final String msgTypeBtn;
  @HiveField(8)
  final String msgTypeDateTime;
  @HiveField(9)
  final List<MediaListClass> mediaList;

  USER_MSG_AUTOSENDER({
    required this.msgContent,
    this.id,
    required this.msgFromUserMastId,
    required this.msgToUserMastIds,
    this.msgTimestamp,
    required this.msgTypeDateUtc,
    required this.msgTypeDateTimeUtc,
    required this.msgTypeBtn,
    required this.msgTypeDateTime,
    required this.mediaList,
  });

  factory USER_MSG_AUTOSENDER.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> mediaListJson =
        List<Map<String, dynamic>>.from(json['mediaList']);
    List<MediaListClass> mediaList =
        mediaListJson.map((v) => MediaListClass.fromJson(v)).toList();

    return USER_MSG_AUTOSENDER(
      msgContent: json['msg_content'] ?? '',
      id: json['id'] ?? 0,
      msgFromUserMastId: json['msg_from_user_mast_id'] ?? 0,
      msgToUserMastIds: json['msg_to_user_mast_ids'] ?? '',
      msgTimestamp: json['msg_timestamp'] ?? '',
      msgTypeDateUtc: json['msg_type_date_utc'] ?? '',
      msgTypeDateTimeUtc: json['msg_type_date_time_utc'] ?? '',
      msgTypeBtn: json['msg_type_btn'] ?? '',
      msgTypeDateTime: json['msg_type_date_time'] ?? '',
      mediaList: mediaList,
    );
  }

  static Map<String, dynamic> toJson(USER_MSG_AUTOSENDER h, String tranType) {
    return {
      'msg_content': h.msgContent,
      'msg_from_user_mast_id': h.msgFromUserMastId,
      'msg_to_user_mast_ids': h.msgToUserMastIds,
      'msg_type_date_utc': h.msgTypeDateUtc,
      'msg_type_date_time_utc': h.msgTypeDateTimeUtc,
      'msg_type_btn': h.msgTypeBtn,
      'msg_type_date_time': h.msgTypeDateTime,
      'mediaList': h.mediaList.map((e) => MediaListClass.toJson(e)).toList(),
      'tran_type': tranType
    };
  }
}

@HiveType(typeId: 11)
class MediaListClass extends HiveObject {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final int? refId;
  @HiveField(2)
  final String msgDocumentUrl;
  @HiveField(3)
  final String msgAudioName;
  @HiveField(4)
  final String msgMediaSize;
  @HiveField(5)
  final String msgType;
  @HiveField(6)
  final String? msgTimeStamp;

  MediaListClass({
    this.id,
    this.refId,
    required this.msgDocumentUrl,
    required this.msgAudioName,
    required this.msgMediaSize,
    required this.msgType,
    this.msgTimeStamp,
  });

  MediaListClass.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        refId = json['ref_id'] ?? 0,
        msgDocumentUrl = json['msg_document_url'] ?? '',
        msgAudioName = json['msg_audio_name'] ?? '',
        msgMediaSize = json['msg_media_size'] ?? '',
        msgType = json['msg_type'] ?? '',
        msgTimeStamp = json['msg_time_stamp'] ?? '';

  static Map<String, String> toJson(MediaListClass h) {
    return {
      'id': h.id.toString(),
      'ref_id': h.refId.toString(),
      'msg_document_url': h.msgDocumentUrl.toString(),
      'msg_audio_name': h.msgAudioName.toString(),
      'msg_media_size': h.msgMediaSize.toString(),
      'msg_type': h.msgType.toString(),
      'msg_time_stamp': h.msgTimeStamp.toString()
    };
  }
}
