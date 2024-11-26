import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../../A_FB_Trigger/SharedPref.dart';
import '../../A_Local_DB/Sync_Database.dart';
import '../../A_Local_DB/Sync_Json.dart';
import '../../A_SQL_Trigger/ConstantApi.dart';
import '../../Constant/Con_Usermast.dart';
import '../../Constant/Constants.dart';
import '../../Login/DownloadData.dart';

part 'sql_usermast.g.dart';

@HiveType(typeId: 1)
class sql_usermast_tran extends HiveObject {
  @HiveField(0)
  final int ID;
  @HiveField(1)
  final String country_code;
  @HiveField(2)
  final String mobile_number;
  @HiveField(3)
  final String disp_mobile_number;
  @HiveField(4)
  final String user_login_name;
  @HiveField(5)
  final String user_bio;
  @HiveField(6)
  final String user_bio_last_datetime;
  @HiveField(7)
  final bool user_is_login;
  @HiveField(8)
  final bool user_is_logout;
  @HiveField(9)
  final bool user_is_online;
  @HiveField(10)
  final int user_is_otp;
  @HiveField(11)
  String user_profileimage_path;
  @HiveField(12)
  final String user_birthdate;
  @HiveField(13)
  final int user_icon_selected;
  @HiveField(14)
  final int user_show_profilepicture;
  @HiveField(15)
  final int user_show_last_seen;
  @HiveField(16)
  final int user_show_mybirthday;
  @HiveField(17)
  final String user_wallpaper;
  @HiveField(18)
  final bool user_chat_bln_quick_reply;
  @HiveField(19)
  final String user_last_login;

  sql_usermast_tran({
    required this.ID,
    required this.country_code,
    required this.mobile_number,
    required this.disp_mobile_number,
    required this.user_login_name,
    required this.user_bio,
    required this.user_bio_last_datetime,
    required this.user_is_login,
    required this.user_is_logout,
    required this.user_is_online,
    required this.user_is_otp,
    required this.user_profileimage_path,
    required this.user_birthdate,
    required this.user_icon_selected,
    required this.user_show_profilepicture,
    required this.user_show_last_seen,
    required this.user_show_mybirthday,
    required this.user_wallpaper,
    required this.user_chat_bln_quick_reply,
    required this.user_last_login,
  });

  factory sql_usermast_tran.fromJson(Map<String, dynamic> json,
      {bool fromsqlite = false}) {
    return sql_usermast_tran(
      ID: json['ID'],
      country_code: json['country_code'].toString(),
      mobile_number: json['mobile_number'].toString(),
      disp_mobile_number: json['disp_mobile_number'] ?? "",
      user_login_name: json['user_login_name'] ?? "",
      user_bio: json['user_bio'] ?? "",
      user_bio_last_datetime: json['user_bio_last_datetime'] ?? "",
      user_is_login: json['user_is_login'] ?? false,
      user_is_logout: json['user_is_logout'] ?? false,
      user_is_online: json['user_is_online'] ?? false,
      user_is_otp: json['user_is_otp'] ?? 0,
      user_profileimage_path: json['user_profileimage_path'] ??
          Constants_Usermast.user_profileimage_path_global,
      user_birthdate: json['user_is_otp'] == null ? "" : json['user_birthdate'],
      user_icon_selected: json['user_icon_selected'] ?? 0,
      user_show_profilepicture: json['user_show_profilepicture'] ?? 0,
      user_show_last_seen: json['user_show_last_seen'] ?? 0,
      user_show_mybirthday: json['user_show_mybirthday'] ?? 0,
      user_wallpaper: json['user_wallpaper'] ?? "",
      user_chat_bln_quick_reply: json['user_chat_bln_quick_reply'] ?? false,
      user_last_login: json['user_last_login'] ?? "",
    );
  }

  static String encode(List<sql_usermast_tran> msg) => json.encode(
        msg.map<Map<String, dynamic>>((e) => toJson(e)).toList(),
      );

  static List<sql_usermast_tran> decode(String musics,
          {bool fromsqlite = false}) =>
      (json.decode(musics) as List<dynamic>)
          .map<sql_usermast_tran>((item) =>
              sql_usermast_tran.fromJson(item, fromsqlite: fromsqlite))
          .toList();

  static Map<String, dynamic> toJson(sql_usermast_tran m) {
    return {
      "id": m.ID,
      "country_code": m.country_code,
      "mobile_number": m.mobile_number,
      "disp_mobile_number": m.disp_mobile_number,
      "user_bio": m.user_bio,
      "user_bio_last_datetime": m.user_bio_last_datetime,
      "user_is_login": m.user_is_login,
      "user_is_logout": m.user_is_logout,
      "user_is_otp": m.user_is_otp,
      "user_profileimage_path": m.user_profileimage_path,
      "user_birthdate": m.user_birthdate,
      "user_icon_selected": m.user_icon_selected,
      "user_show_profilepicture": m.user_show_profilepicture,
      "user_show_last_seen": m.user_show_last_seen,
      "user_show_mybirthday": m.user_show_mybirthday,
      "user_wallpaper": m.user_wallpaper,
      "user_chat_bln_quick_reply": m.user_chat_bln_quick_reply,
      "user_last_login": m.user_last_login
    };
  }

  static GetUserLoginDet(List<sql_usermast_tran> needs) async {
    if (needs.isNotEmpty) {
      Constants_Usermast.country_code = needs[0].country_code;
      Constants_Usermast.mobile_number = needs[0].mobile_number;
      Constants_Usermast.disp_mobile_number = needs[0].disp_mobile_number;
      Constants_Usermast.user_login_name = needs[0].user_login_name;
      Constants_Usermast.user_bio = needs[0].user_bio;
      Constants_Usermast.user_bio_last_datetime =
          needs[0].user_bio_last_datetime;
      Constants_Usermast.user_is_login = needs[0].user_is_login;
      Constants_Usermast.user_is_logout = needs[0].user_is_logout;
      Constants_Usermast.user_is_online = needs[0].user_is_online;
      Constants_Usermast.user_is_otp = needs[0].user_is_otp;
      Constants_Usermast.use_show_profilepicture =
          needs[0].user_show_profilepicture;
      Constants_Usermast.user_birthdate = needs[0].user_birthdate;
      Constants_Usermast.user_icon_selected = needs[0].user_icon_selected;
      Constants_Usermast.user_show_last_seen = needs[0].user_show_last_seen;
      Constants_Usermast.user_show_mybirthday = needs[0].user_show_mybirthday;
      Constants_Usermast.user_wallpaper = needs[0].user_wallpaper;
      Constants_Usermast.user_last_login = needs[0].user_last_login;
      Constants_Usermast.user_profileimage_path =
          needs[0].user_profileimage_path;
      Constants_Usermast.user_id =
          await (SharedPref.read_string('user_id') ?? "");
      Constants_Usermast.user_chat_bln_quick_reply =
          await SharedPref.read_bool('Quick_Rep') ?? true;
      Constants_Usermast.user_notify_conversionTone =
          await SharedPref.read_bool('user_notify_conversionTone') ?? true;
      Constants_Usermast.user_chat_mobile_audio =
          await SharedPref.read_bool('user_chat_mobile_audio') ?? true;
      Constants_Usermast.user_chat_mobile_Document =
          await SharedPref.read_bool('user_chat_mobile_Document') ?? true;
      Constants_Usermast.user_chat_mobile_images =
          await SharedPref.read_bool('user_chat_mobile_images') ?? true;
      Constants_Usermast.user_chat_mobile_video =
          await SharedPref.read_bool('user_chat_mobile_video') ?? true;
      Constants_Usermast.user_chat_wifi_audio =
          await SharedPref.read_bool('user_chat_wifi_audio') ?? true;
      Constants_Usermast.user_chat_wifi_Document =
          await SharedPref.read_bool('user_chat_wifi_Document') ?? true;
      Constants_Usermast.user_chat_wifi_images =
          await SharedPref.read_bool('user_chat_wifi_images') ?? true;
      Constants_Usermast.user_chat_wifi_video =
          await SharedPref.read_bool('user_chat_wifi_video') ?? true;
      Constants_Usermast.user_vibrate =
          await SharedPref.read_int('user_vibrate') ?? 1;
    } else {
      Constants_Usermast.BlankCaller();
    }
  }

  static mSetUserLoginDetails(String pStrCountryCode, String pStrMobileNo,
      String pStrDispMobileNumber) async {
    try {
      final response =
          await http.post(Uri.parse(ConstantApi.LoginInsert), body: {
        "country_code": pStrCountryCode,
        "mobile_no": pStrMobileNo,
        "disp_mobile_no": (pStrDispMobileNumber),
      });
      if (response.statusCode == 200) {
        try {
          Map<String, dynamic> data = jsonDecode(response.body);
          if (data.isNotEmpty) {
            if (data["flag"].toString() != 'false') {
              Constants_Usermast.user_id = "";
              SharedPref.save_string('user_id', "");
              SharedPref.save_string('country_code', "");
              return;
            }
          }
        } catch (e) {}
        Constants_Usermast.user_id = jsonDecode(response.body).toString();
        SharedPref.save_string(
            'user_id', Constants_Usermast.user_id.toString());
        SharedPref.save_string('country_code', pStrCountryCode.toString());

        SelectUserTable();
      } else {
        throw Exception('Failed to load mSetUserLoginDetails');
      }
    } catch (e) {}
  }

  static mSetUserDirectMessageExist(String pStrCountryCode, String pStrMobileNo,
      String pStrDispMobileNumber) async {
    try {
      final response =
          await http.post(Uri.parse(ConstantApi.LoginDirectMsgExist), body: {
        "country_code": pStrCountryCode,
        "mobile_no": pStrMobileNo,
        "disp_mobile_no": (pStrDispMobileNumber),
      });
      if (response.statusCode == 200) {
        try {
          if (response.body == "0") {
            return '';
          }
          return response.body.toString();
        } catch (e) {
          return '';
        }
      } else {
        throw Exception('Failed to load mSetUserDirectMessageExist');
      }
    } catch (e) {}
  }

  static mSetUserOtpDetail(String pStrOtp, {required String deviceKey}) async {
    try {
      final response =
          await http.post(Uri.parse(ConstantApi.LoginUserUpdateOtpData), body: {
        "user_id": Constants_Usermast.user_id,
        "user_is_otp": pStrOtp,
        "device_key": deviceKey
      });

      if (response.statusCode == 200) {
        SelectUserTable();
      } else {
        throw Exception('Failed to load mSetUserOtpDetail');
      }
    } on PlatformException catch (e) {
      print("Failed to usermast mSetUserOtpDetail: ${e.message}");
    }
  }

  static mSetUserProfileDetail(String userProfileimagePath) async {
    try {
      final response = await http
          .post(Uri.parse(ConstantApi.LoginUserUpdateProfileData), body: {
        "user_id": Constants_Usermast.user_id,
        "user_profileimage_path": userProfileimagePath,
      });
      SharedPref.save_string('profile_pic', userProfileimagePath);
      var box = await Hive.openBox<sql_usermast_tran>("sql_usermast_tran");
      Constants_Usermast.user_profileimage_path = userProfileimagePath;
      final boxdata = box.get(Constants_Usermast.user_id.toString());
      boxdata!.user_profileimage_path = userProfileimagePath;
      await box.put(Constants_Usermast.user_id.toString(), boxdata);
      if (response.statusCode == 200) {
        SelectUserTable();
      } else {
        throw Exception('Failed to load mSetUserProfileDetail');
      }
    } on PlatformException catch (e) {
      print("Failed to usermast mSetUserProfileDetail: ${e.message}");
    }
  }

  static mSetUserNameDetail(String userLoginName) async {
    try {
      final response = await http
          .post(Uri.parse(ConstantApi.LoginUserUpdateNameData), body: {
        "user_id": Constants_Usermast.user_id,
        "user_login_name": userLoginName,
      });
      if (response.statusCode == 200) {
        SelectUserTable();
      } else {
        throw Exception('Failed to load mSetUserNameDetail');
      }
    } on PlatformException catch (e) {
      print("Failed to usermast mSetUserNameDetail: ${e.message}");
    }
  }

  static mSetUserBioDetail(String userBio) async {
    try {
      final response =
          await http.post(Uri.parse(ConstantApi.LoginUserUpdateBioData), body: {
        "user_id": Constants_Usermast.user_id.toString(),
        "user_bio": userBio,
      });
      if (response.statusCode == 200) {
        SelectUserTable();
      } else {
        throw Exception('Failed to load mSetUserBioDetail');
      }
    } on PlatformException {}
  }

  static mSetUserBirthDateDetail(String userBirthdate) async {
    try {
      final response = await http
          .post(Uri.parse(ConstantApi.LoginUserUpdateBirthDateData), body: {
        "user_id": Constants_Usermast.user_id,
        "user_birthdate": userBirthdate,
      });
      if (response.statusCode == 200) {
        SelectUserTable();
      } else {
        throw Exception('Failed to load mSetUserBirthDateDetail');
      }
    } on PlatformException catch (e) {
      print("Failed to usermast mSetUserBirthDateDetail: ${e.message}");
    }
  }

  static mSetUserUpdateBln(String columnKey, String Value) async {
    try {
      final response = await http
          .post(Uri.parse(ConstantApi.LoginUserUpdateSettingBln), body: {
        "user_id": Constants_Usermast.user_id.toString(),
        "column_key": columnKey,
        "blnValue": Value,
      });
      if (response.statusCode == 200) {
        SelectUserTable();
      } else {
        throw Exception('Failed to load mSetUserUpdateBln');
      }
    } on PlatformException catch (e) {
      print("Failed to usermast mSetUserUpdateBln: ${e.message}");
    }
  }

  static mSetUserOnlineOffline(bool _bln) async {
    try {
      var val = _bln ? "1" : "0";

      final response =
          await http.post(Uri.parse(ConstantApi.LoginUserOnlineOffline), body: {
        "id": Constants_Usermast.user_id.toString(),
        "user_is_online": val.toString(),
      });
      if (!DownloadData.Keyvalue.contains("mSetUserOnlineOffline")) {
        DownloadData.Keyvalue.add("mSetUserOnlineOffline");
        DownloadData.respones.add(response.statusCode);
      }
      if (response.statusCode == 200) {}
    } on PlatformException catch (e) {
      print("Failed to usermast mSetUserOnlineOffline: ${e.message}");
    }
  }

  static SelectUserTable() async {
    await SyncDB.SyncTable(Constants.Table_UserMast, false);
    List<sql_usermast_tran> needs = await SyncJSon.user_mast_table_select();
    await sql_usermast_tran.GetUserLoginDet(needs);
  }
}
