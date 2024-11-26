import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nextapp/A_SQL_Trigger/ConstantApi.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:nextapp/Constant/Constants.dart';

class sql_groups_tran {
  static Future<List<My_Group_Contact>> GetGroupDetail() async {
    List<My_Group_Contact> needs = [];
    final response =
        await http.post(Uri.parse(ConstantApi.GroupGetData), body: {
      "contact_id": Constants_Usermast.user_id,
    });
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        needs = My_Group_Contact.decode(response.body);
      }
    } else {}
    return needs;
  }

  static GetGroupDetail_Sub(String id) async {
    List<My_Group_Contact_Sub> needs = [];
    final response =
        await http.post(Uri.parse(ConstantApi.SubGroupGetData), body: {
      "contact_id": Constants_Usermast.user_id,
      "user_grp_id": id.toString(),
    });
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        if (response.body != "") {
          needs = My_Group_Contact_Sub.decode(response.body);
        }
      }
    } else {
      throw Exception('Failed to load GetGroupDetail_Sub');
    }
    return needs;
  }

  static SaveGroupDetail(String pStrGroupId, String pStrGroupName,
      String pStrGroupPic, String pStrExecType) async {
    if (Constants_List.need_contact.isNotEmpty) {
      String json = jsonEncode(
              Constants_List.need_contact.map((i) => i.toJson1()).toList())
          .toString();
      if (json.isNotEmpty) {
        final response =
            await http.post(Uri.parse(ConstantApi.GroupSaveData), body: {
          "contact_list": json.toString(),
          "contact_id": Constants_Usermast.user_id,
          "grp_name": pStrGroupName,
          "grp_id": pStrGroupId,
          "grp_profile_pic": pStrGroupPic,
          "exec_type": pStrExecType,
        });
      }
    }
  }
}

class My_Group_Contact {
  int id;
  int user_mast_id;
  String grp_name;
  String grp_created_time_show;
  String grp_modified_time_show;
  int grp_msg_type;
  String grp_profile_pic;
  int grp_last_msg_id;
  String grp_user_last_msg;
  int user_unread_count;
  bool is_selected;
  String grp_exist_user;

  My_Group_Contact({
    required this.id,
    required this.user_mast_id,
    required this.grp_name,
    required this.grp_created_time_show,
    required this.grp_modified_time_show,
    required this.grp_msg_type,
    required this.grp_profile_pic,
    required this.grp_last_msg_id,
    required this.grp_user_last_msg,
    required this.user_unread_count,
    required this.is_selected,
    required this.grp_exist_user,
  });

  factory My_Group_Contact.fromJson(Map<String, dynamic> json) {
    return My_Group_Contact(
      id: json['id'],
      user_mast_id: json['user_mast_id'],
      grp_name: json['grp_name'] ?? "",
      grp_created_time_show: json['grp_created_time_show'] ?? "",
      grp_modified_time_show: json['grp_modified_time_show'] ?? "",
      grp_msg_type: json['grp_msg_type'],
      grp_profile_pic: json['grp_profile_pic'] ??
          Constants_Usermast.user_groupimage_path_global,
      grp_last_msg_id: json['grp_last_msg_id'],
      grp_user_last_msg: json['grp_user_last_msg'],
      user_unread_count: json['user_unread_count'] ?? 0,
      is_selected: json['is_selected'] ?? false,
      grp_exist_user: json['grp_exist_user'] ?? "",
    );
  }

  static List<My_Group_Contact> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<My_Group_Contact>((item) => My_Group_Contact.fromJson(item))
          .toList();

  Map<String, dynamic> toJson1() {
    return {
      "id": id,
      "user_mast_id": user_mast_id,
      "grp_name": grp_name,
      "grp_created_time_show": grp_created_time_show,
      "grp_modified_time_show": grp_modified_time_show,
      "grp_msg_type": grp_msg_type,
      "grp_last_msg_id": grp_last_msg_id,
      "grp_user_last_msg": grp_user_last_msg,
      "user_last_msg_delete": user_unread_count,
      "user_last_msg": is_selected,
      "grp_exist_user": grp_exist_user
    };
  }
}

class My_Group_Contact_Sub {
  int id;
  int user_grp_id;
  int user_mast_id;
  bool is_admin;
  String disp_mobile_number;
  String disp_name;
  String user_bio;
  String is_admin_datetime;
  bool is_selected;
  String grp_exist_user;

  My_Group_Contact_Sub({
    required this.id,
    required this.user_grp_id,
    required this.user_mast_id,
    required this.is_admin,
    required this.disp_mobile_number,
    required this.disp_name,
    required this.user_bio,
    required this.is_admin_datetime,
    required this.is_selected,
    required this.grp_exist_user,
  });

  factory My_Group_Contact_Sub.fromJson(Map<String, dynamic> json) {
    return My_Group_Contact_Sub(
      id: json['id'],
      user_grp_id: json['user_grp_id'],
      user_mast_id: json['user_mast_id'],
      is_admin: json['is_admin'],
      disp_mobile_number: json['disp_mobile_number'] ?? "",
      disp_name: json['disp_name'],
      user_bio: json['user_bio'] ?? "",
      is_admin_datetime: json['is_admin_datetime'].toString() != "null"
          ? json['is_admin_datetime'].toString()
          : "",
      is_selected: json['is_selected'],
      grp_exist_user: json['grp_exist_user'] ?? "",
    );
  }

  static List<My_Group_Contact_Sub> decode(String musics) => (json
          .decode(musics) as List<dynamic>)
      .map<My_Group_Contact_Sub>((item) => My_Group_Contact_Sub.fromJson(item))
      .toList();

  Map<String, dynamic> toJson1() {
    return {
      "id": id,
      "user_grp_id": user_grp_id,
      "user_mast_id": user_mast_id,
      "is_admin": is_admin,
      "disp_mobile_number": disp_mobile_number,
      "disp_name": disp_name,
      "user_bio": user_bio,
      "is_admin_datetime": is_admin_datetime,
      "is_selected": is_selected,
      "grp_exist_user": grp_exist_user
    };
  }
}
