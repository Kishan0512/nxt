import 'dart:convert';

// class Need_Fav {
//   String id;
//   String name;
//   String user_profile;
//   bool is_favourite;
//
//   Need_Fav(
//       {required this.id,
//       required this.name,
//       required this.user_profile,
//       required this.is_favourite});
//
//   Need_Fav.fromJson(Map<String, dynamic> json)
//       : id = json['id'],
//         name = json['name'],
//         user_profile = json['user_profile'] ??
//             Constants_Usermast.user_profileimage_path_global,
//         is_favourite = json['is_favourite'];
//
//   static Map<String, dynamic> toJson(Need_Fav fav) => {
//         'id': fav.id,
//         'name': fav.name,
//         'user_profile': fav.user_profile,
//         'is_favourite': fav.is_favourite,
//       };
//
//   static String encode(List<Need_Fav> musics) => json.encode(
//         musics
//             .map<Map<String, dynamic>>((music) => Need_Fav.toJson(music))
//             .toList(),
//       );
//
//   static List<Need_Fav> decode(String musics) =>
//       (json.decode(musics) as List<dynamic>)
//           .map<Need_Fav>((item) => Need_Fav.fromJson(item))
//           .toList();
//
//   Map<String, dynamic> toJson1() {
//     return {
//       "id": id,
//       "name": name,
//       "user_profile": user_profile,
//       "is_favourite": is_favourite,
//     };
//   }
// }

class Need_Group {
  String id;
  String name;
  String image;
  String count;
  String date;
  bool is_selected;
  bool is_first;
  String user_last_user;
  String user_last_msg;

  Need_Group(
      {required this.id,
      required this.name,
      required this.image,
      required this.count,
      required this.date,
      required this.is_selected,
      required this.is_first,
      required this.user_last_user,
      required this.user_last_msg});

  Need_Group.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        image = json['image'],
        count = json['count'],
        date = json['date'],
        is_selected = false,
        is_first = json['is_first'] ?? false,
        user_last_user = json['user_last_user'],
        user_last_msg = json['user_last_msg'];

  static Map<String, dynamic> toJson(Need_Group fav) {
    return {
      'id': fav.id,
      'name': fav.name,
      'image': fav.image,
      'count': fav.count,
      'date': fav.date,
      'is_selected': fav.is_selected,
      'is_first': fav.is_first,
      'user_last_user': fav.user_last_user,
      'user_last_msg': fav.user_last_msg
    };
  }

  static String encode(List<Need_Group> musics) {
    return json.encode(
      musics.map<Map<String, dynamic>>((music) {
        return Need_Group.toJson(music);
      }).toList(),
    );
  }

  static List<Need_Group> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<Need_Group>((item) => Need_Group.fromJson(item))
          .toList();

  Map<String, dynamic> toJson1() {
    return {
      "id": id,
      "name": name,
      "image": image,
      "count": count,
      "date": date,
      "is_selected": is_selected,
      "is_first": is_first,
      "user_last_user": user_last_user,
      "user_last_msg": user_last_msg
    };
  }
}

class Need_Group_Sub {
  final String id;
  final String name;
  final String image;
  final String count;
  final String date;
  bool is_selected;
  bool is_admin;

  Need_Group_Sub(
      {required this.id,
      required this.name,
      required this.image,
      required this.count,
      required this.date,
      required this.is_selected,
      required this.is_admin});

  Need_Group_Sub.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        image = json['image'],
        count = json['count'],
        date = json['date'],
        is_selected = json['is_selected']?.isNotEmpty == true,
        is_admin = json['is_admin']?.isNotEmpty == true;

  static Map<String, dynamic> toJson(Need_Group_Sub fav) {
    return {
      'id': fav.id,
      'name': fav.name,
      'image': fav.image,
      'count': fav.count,
      'date': fav.date,
      'is_selected': fav.is_selected,
      'is_admin': fav.is_admin,
    };
  }

  static String encode(List<Need_Group_Sub> musics) {
    return json.encode(
      musics.map<Map<String, dynamic>>((music) {
        return Need_Group_Sub.toJson(music);
      }).toList(),
    );
  }

  static List<Need_Group_Sub> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<Need_Group_Sub>((item) => Need_Group_Sub.fromJson(item))
          .toList();

  Map<String, dynamic> toJson1() {
    return {
      "id": id,
      "name": name,
      "image": image,
      "count": count,
      "date": date,
      "is_selected": is_selected,
      "is_admin": is_admin
    };
  }
}

class Need_Group_Sub_Msg {
  final String user_last_user;
  final String user_last_msg;
  final bool user_delivered_is_msg;
  final String user_delivered_msg_timestamp;
  final bool user_read_is_msg;
  final String user_read_msg_timestamp;
  final bool is_delete_msg;
  final String user_last_timestamp;
  final String type;

  Need_Group_Sub_Msg(
      {required this.user_last_user,
      required this.user_last_msg,
      required this.user_delivered_is_msg,
      required this.user_delivered_msg_timestamp,
      required this.user_read_is_msg,
      required this.user_read_msg_timestamp,
      required this.is_delete_msg,
      required this.user_last_timestamp,
      required this.type});

  Need_Group_Sub_Msg.fromJson(Map<String, dynamic> json)
      : user_last_user = json['user_last_user'],
        user_last_msg = json['user_last_msg'],
        user_delivered_is_msg = json['user_delivered_is_msg'],
        user_delivered_msg_timestamp = json['user_delivered_msg_timestamp'],
        user_read_is_msg = json['user_read_is_msg'],
        user_read_msg_timestamp = json['user_read_msg_timestamp'],
        is_delete_msg = json['is_delete_msg']?.isNotEmpty == true,
        user_last_timestamp = json['user_last_timestamp'],
        type = json['type'];

  static Map<String, dynamic> toJson(Need_Group_Sub_Msg fav) {
    return {
      'user_last_user': fav.user_last_user,
      'user_last_msg': fav.user_last_msg,
      'user_delivered_is_msg': fav.user_delivered_is_msg,
      'user_delivered_msg_timestamp': fav.user_delivered_msg_timestamp,
      'user_read_is_msg': fav.user_read_is_msg,
      'user_read_msg_timestamp': fav.user_read_msg_timestamp,
      'is_delete_msg': fav.is_delete_msg,
      'user_last_timestamp': fav.user_last_timestamp,
      'type': fav.type,
    };
  }

  static String encode(List<Need_Group_Sub_Msg> musics) {
    return json.encode(
      musics.map<Map<String, dynamic>>((music) {
        return Need_Group_Sub_Msg.toJson(music);
      }).toList(),
    );
  }

  static List<Need_Group_Sub_Msg> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<Need_Group_Sub_Msg>((item) => Need_Group_Sub_Msg.fromJson(item))
          .toList();

  Map<String, dynamic> toJson1() {
    return {
      'user_last_user': user_last_user,
      'user_last_msg': user_last_msg,
      'user_delivered_is_msg': user_delivered_is_msg,
      'user_delivered_msg_timestamp': user_delivered_msg_timestamp,
      'user_read_is_msg': user_read_is_msg,
      'user_read_msg_timestamp': user_read_msg_timestamp,
      'is_delete_msg': is_delete_msg,
      'user_last_timestamp': user_last_timestamp,
      'type': type,
    };
  }
}

class Need_Contact_Msg {
  String id;
  String user_mast_id;
  String name;
  String user_profile;
  String user_bio;
  String user_last_msg;
  int user_last_is_icon_status;
  String user_last_msg_timestamp;
  bool user_last_msg_delete;
  bool is_favourite;
  bool is_block;
  bool is_broadcast;
  bool is_selected;
  bool is_online;
  String user_last_bio_date;
  String user_last_login_time;
  String user_last_birthdate;
  String user_last_final_mobile_number;

  Need_Contact_Msg({
    required this.id,
    required this.name,
    required this.user_mast_id,
    required this.user_profile,
    required this.user_bio,
    required this.user_last_msg,
    required this.user_last_is_icon_status,
    required this.user_last_msg_timestamp,
    required this.user_last_msg_delete,
    required this.is_favourite,
    required this.is_block,
    required this.is_broadcast,
    required this.is_selected,
    required this.is_online,
    required this.user_last_bio_date,
    required this.user_last_login_time,
    required this.user_last_birthdate,
    required this.user_last_final_mobile_number,
  });

  Need_Contact_Msg.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        user_mast_id = json['user_mast_id'],
        user_profile = json['user_profile'],
        user_bio = json['user_bio'],
        user_last_msg = json['user_last_msg'],
        user_last_is_icon_status = json['user_last_is_icon_status'],
        user_last_msg_timestamp = json['user_last_msg_timestamp'],
        user_last_msg_delete = json['user_last_msg_delete'],
        is_favourite = json['is_favourite'],
        is_block = json['is_block'] ?? false,
        is_broadcast = json['is_broadcast'],
        is_selected = json['is_selected'],
        is_online = json['is_online'],
        user_last_bio_date = json['user_last_bio_date'],
        user_last_login_time = json['user_last_login_time'],
        user_last_birthdate = json['user_last_birthdate'],
        user_last_final_mobile_number =
            json['user_last_final_mobile_number'] ?? "";

  static Map<String, dynamic> toJson(Need_Contact_Msg fav) => {
        'id': fav.id,
        'user_mast_id': fav.user_mast_id,
        'name': fav.name,
        'user_profile': fav.user_profile,
        'user_bio': fav.user_bio,
        'user_last_msg': fav.user_last_msg,
        'user_last_is_icon_status': fav.user_last_is_icon_status,
        'user_last_msg_timestamp': fav.user_last_msg_timestamp,
        'user_last_msg_delete': fav.user_last_msg_delete,
        'is_favourite': fav.is_favourite,
        'is_block': fav.is_block,
        'is_broadcast': fav.is_broadcast,
        'is_selected': fav.is_selected,
        'is_online': fav.is_online,
        'user_last_bio_date': fav.user_last_bio_date,
        'user_last_login_time': fav.user_last_login_time,
        'user_last_birthdate': fav.user_last_birthdate,
      };

  static String encode(List<Need_Contact_Msg> musics) => json.encode(
        musics
            .map<Map<String, dynamic>>(
                (music) => Need_Contact_Msg.toJson(music))
            .toList(),
      );

  static List<Need_Contact_Msg> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<Need_Contact_Msg>((item) => Need_Contact_Msg.fromJson(item))
          .toList();

  Map<String, dynamic> toJson1() {
    return {
      "id": id,
      "name": name,
      "user_profile": user_profile,
      "user_bio": user_bio,
      "user_last_msg": user_last_msg,
      "user_last_is_icon_status": user_last_is_icon_status,
      "user_last_msg_timestamp": user_last_msg_timestamp,
      "user_last_msg_delete": user_last_msg_delete,
      "is_favourite": is_favourite,
      "is_block": is_block,
      "is_broadcast": is_broadcast,
      "is_selected": is_selected,
      "is_online": is_online,
      "user_last_bio_date": user_last_bio_date,
      "user_last_login_time": user_last_login_time,
      "user_last_birthdate": user_last_birthdate,
    };
  }
}
