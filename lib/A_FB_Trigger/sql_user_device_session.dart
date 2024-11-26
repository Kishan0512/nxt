import 'dart:convert';

import 'package:hive/hive.dart';

part 'sql_user_device_session.g.dart';

@HiveType(typeId: 6)
class Need_DeviceSession extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  int user_mast_id;
  @HiveField(2)
  String nxtapp_version;
  @HiveField(3)
  String mobile_version;
  @HiveField(4)
  String ipaddress;
  @HiveField(5)
  int is_active;
  @HiveField(6)
  String device_location;
  @HiveField(7)
  String mobile_name;
  @HiveField(8)
  String login_date_time;
  @HiveField(9)
  String login_date_time_show;
  @HiveField(10)
  String mac_address;
  @HiveField(11)
  bool isAndroid;
  @HiveField(12)
  bool isIOS;
  @HiveField(13)
  bool isMacOS;
  @HiveField(14)
  bool isWindows;

  Need_DeviceSession({
    required this.id,
    required this.user_mast_id,
    required this.nxtapp_version,
    required this.mobile_version,
    required this.ipaddress,
    required this.is_active,
    required this.device_location,
    required this.mobile_name,
    required this.login_date_time,
    required this.login_date_time_show,
    required this.mac_address,
    required this.isAndroid,
    required this.isIOS,
    required this.isMacOS,
    required this.isWindows,
  });

  factory Need_DeviceSession.fromJson(Map<String, dynamic> json) {
    return Need_DeviceSession(
      id: json['id'],
      user_mast_id: json['user_mast_id'] ?? 0,
      nxtapp_version: json['nxtapp_version'] ?? "",
      mobile_version: json['mobile_version'] ?? "",
      ipaddress: json['ipaddress'] ?? "",
      is_active: json['is_active'] == false ? 0 : 1,
      device_location: json['device_location'] ?? "",
      mobile_name: json['mobile_name'] ?? "",
      login_date_time: json['login_date_time'] ?? "",
      mac_address: json['mac_address'] ?? "",
      login_date_time_show: json['login_date_time_show'] ?? "",
      isAndroid: json['isAndroid'] == null ? false : true,
      isIOS: json['isIOS'] == null ? false : true,
      isMacOS: json['isMacOS'] == null ? false : true,
      isWindows: json['isWindows'] == null ? false : true,
    );
  }

  static List<Need_DeviceSession> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<Need_DeviceSession>((item) => Need_DeviceSession.fromJson(item))
          .toList();

  Map<String, dynamic> toJson1() {
    return {
      "id": id,
      "user_mast_id": user_mast_id,
      "nxtapp_version": nxtapp_version,
      "mobile_version": mobile_version,
      "ipaddress": ipaddress,
      "is_active": is_active,
      "device_location": device_location,
      "mobile_name": mobile_name,
      "login_date_time": login_date_time,
      "mac_address": mac_address,
      "login_date_time_show": login_date_time_show,
      "isAndroid": isAndroid,
      "isIOS": isIOS,
      "isMacOS": isMacOS,
      "isWindows": isWindows,
    };
  }
}
