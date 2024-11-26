import 'dart:convert';

import 'package:hive/hive.dart';

part 'Local_Contact.g.dart';

@HiveType(typeId: 12)
class Local_Contact extends HiveObject {
  @HiveField(0)
  String disp_name;
  @HiveField(1)
  String mobile_number;
  @HiveField(2)
  String country_code;

  Local_Contact({
    required this.disp_name,
    required this.mobile_number,
    required this.country_code,
  });

  Local_Contact.fromJson(Map<String, dynamic> json)
      : disp_name = json['disp_name'],
        mobile_number = json['mobile_number'],
        country_code = json['country_code'];

  static Map<String, dynamic> toJson(Local_Contact fav) => {
    'disp_name': fav.disp_name,
    'mobile_number': fav.mobile_number,
    'country_code': fav.country_code
  };

  static String encode(List<Local_Contact> musics) => json.encode(
    musics
        .map<Map<String, dynamic>>((music) => Local_Contact.toJson(music))
        .toList(),
  );

  static List<Local_Contact> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<Local_Contact>((item) => Local_Contact.fromJson(item))
          .toList();

  Map<String, dynamic> toJson1() {
    return {
      "disp_name": disp_name,
      "mobile_number": mobile_number,
      "country_code": country_code,
    };
  }
}