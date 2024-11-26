import 'dart:convert';
import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:nextapp/A_FB_Trigger/sql_need_contact.dart';
import 'package:nextapp/A_Local_DB/Sync_Database.dart';
import 'package:nextapp/A_Local_DB/Sync_Json.dart';
import 'package:nextapp/A_SQL_Trigger/ConstantApi.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:nextapp/Constant/Constants.dart';
import 'package:nextapp/Login/DownloadData.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_number/phone_number.dart';

import 'Local_Contact.dart';

part 'sql_contact.g.dart';

@HiveType(typeId: 9)
class sql_contact_tran extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int contact_id;
  @HiveField(2)
  final int user_mast_id;
  @HiveField(3)
  final String mobile_number;
  @HiveField(4)
  final String disp_mobile_number;
  @HiveField(5)
  final String disp_name;
  @HiveField(6)
  final bool user_exist_in_mobile;
  @HiveField(7)
  final bool user_is_block;
  @HiveField(8)
  final bool user_is_favourite;
  @HiveField(9)
  final int user_last_msg_id;

  sql_contact_tran({
    required this.id,
    required this.contact_id,
    required this.user_mast_id,
    required this.mobile_number,
    required this.disp_mobile_number,
    required this.disp_name,
    required this.user_exist_in_mobile,
    required this.user_is_block,
    required this.user_is_favourite,
    required this.user_last_msg_id,
  });

  factory sql_contact_tran.fromJson(Map<String, dynamic> json) {
    return sql_contact_tran(
      id: json['id'],
      contact_id: json['contact_id'],
      user_mast_id: json['user_mast_id'],
      mobile_number: json['mobile_number'],
      disp_mobile_number: json['disp_mobile_number'],
      disp_name: json['disp_name'],
      user_exist_in_mobile: json['user_exist_in_mobile'],
      user_is_block: json['user_is_block'],
      user_is_favourite: (json['user_is_favourite']),
      user_last_msg_id: json['user_last_msg_id'],
    );
  }

  static int parseBool(bool pStr) {
    if (pStr == true) {
      return 1;
    } else if (pStr == false) {
      return 0;
    }
    return 0;
  }

  static List<sql_contact_tran> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<sql_contact_tran>((item) => sql_contact_tran.fromJson(item))
          .toList();

  static Future<bool> _reqpermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  static Future<Map<String, String>> convertToCountryCodeAndNumber(
      String phoneNumber) async {
    try {
      final trimmedNumber = phoneNumber.replaceAll(RegExp(r'\s+'), '');
      final hasLeadingPlus = trimmedNumber.startsWith('+');
      String countryCode;
      String mobileNumber = trimmedNumber;
      if (trimmedNumber.startsWith('0')) {
        countryCode = '+91';
        mobileNumber = countryCode + trimmedNumber.substring(1);
      } else if (trimmedNumber.startsWith('91') && trimmedNumber.length == 12) {
        countryCode = '+91';
        mobileNumber =
            countryCode + trimmedNumber.substring(hasLeadingPlus ? 1 : 2);
      } else if (trimmedNumber.startsWith('+') && trimmedNumber.length == 13) {
        mobileNumber = trimmedNumber;
      } else  {
        countryCode = Constants_Usermast.country_code.trim();
        mobileNumber = countryCode + trimmedNumber;
      }
      final parsedNumber = await PhoneNumberUtil().parse(mobileNumber);
      countryCode = parsedNumber.countryCode.toString();
      mobileNumber = parsedNumber.nationalNumber.toString();
      return {
        'countryCode': '+$countryCode',
        'mobileNumber': mobileNumber,
      };
    } catch (e) {
      return {};
    }
  }

  static SaveContactDetail() async {
    try {
      if (await _reqpermission(Permission.contacts)) {
        List<Local_Contact> needs = await GetContact();
        await SyncJSon.user_local_contact_save(needs)
            .then((value) => SyncJSon.user_local_contact_select());
        await ContactApi(needs);
      }
    } catch (e) {}
  }

  static Future<List<Local_Contact>> GetContact() async {
    List<Local_Contact> needs = [];
    try {
      Iterable<Contact> _contacts =
      await ContactsService.getContacts(withThumbnails: false);
      List<Future> futures = [];
      for (var contact in _contacts) {
        for (var phone in contact.phones!) {
          futures.add(convertToCountryCodeAndNumber(phone.value.toString())
              .then((Contact) {
            if (Contact.isNotEmpty) {
              needs.add(Local_Contact(
                disp_name: (contact.displayName.toString() != ""
                    ? contact.displayName
                    .toString()
                    .trim()
                    .trimLeft()
                    .trimRight()
                    : contact.givenName.toString())
                    .trim()
                    .trimLeft()
                    .trimRight(),
                mobile_number: Contact['mobileNumber']
                    .toString()
                    .trim()
                    .trimLeft()
                    .trimRight(),
                country_code: Contact['countryCode']
                    .toString()
                    .trim()
                    .trimLeft()
                    .trimRight(),
              ));
            }
          }));
        }
      }

      await Future.wait(futures);
    } catch (e) {}
    return needs;
  }

  static ContactApi(List<Local_Contact> needs) async {
    String json = jsonEncode(needs.map((i) => i.toJson1()).toList()).toString();
    if (json.isNotEmpty) {
      final response =
      await http.post(Uri.parse(ConstantApi.ContactSaveData), body: {
        "contact_list": json.toString(),
        "contact_id": Constants_Usermast.user_id,
      });
      if (!DownloadData.Keyvalue.contains("SaveContactDetail")) {
        DownloadData.Keyvalue.add("SaveContactDetail");
        DownloadData.respones.add(response.statusCode);
      }
      if (response.statusCode == 200) {
        SyncDB.SyncTable(Constants.Table_Contacts_user_wise, false);
      } else {
        throw Exception(
            'FAILED TO LOAD (sql_main_messages_tran,UpdateDeliveryDataMain)');
      }
    }
  }

  static mContactDirectSaveUser(String pStrUserMastId) async {
    try {
      final response =
      await http.post(Uri.parse(ConstantApi.ContactDirectSave), body: {
        "contact_id": Constants_Usermast.user_id.toString(),
        "user_mast_id": pStrUserMastId,
      });
      if (response.statusCode == 200) {} else {
        throw Exception('Failed to load mContactDirectSaveUser');
      }
    } on PlatformException catch (e) {
      print("Failed to usermast mContactDirectSaveUser: ${e.message}");
    }
  }

  static mSetUserWiseUpdateFav(String id, String columnKey,
      String Value) async {

    try {
      final response = await http.post(Uri.parse(ConstantApi.ContactUpdateFav),
          body: {
            "user_id": id.toString(),
            "column_key": columnKey,
            "blnValue": Value
          });
      SyncDB.SyncTable(Constants.Table_Contacts_user_wise, true);
      SyncDB.SyncTable(Constants.usermainmsg, true);
    } on PlatformException catch (e) {
      print("Failed to usermast mSetUserWiseUpdateFav: ${e.message}");
    }
  }

  static SaveContactDetFavBlock(List<Need_Contact> _needs) async {
    if (_needs.isNotEmpty) {


      String json =
      jsonEncode(_needs.map((i) => i.toJson1()).toList()).toString();

      if (json.isNotEmpty) {
        final response = await http
            .post(Uri.parse(ConstantApi.ContactSaveDataFavBlock), body: {
          "contact_list": json.toString(),
          "contact_id": Constants_Usermast.user_id,
        });
      }
    }
  }

  static Future<bool> GetUserWiseBlock(String contactId) async {
    bool _BlnValue = false;
    try {

      final response =
      await http.post(Uri.parse(ConstantApi.ContactWiseBlock), body: {
        "contact_id": contactId,
        "user_mast_id": Constants_Usermast.user_id.toString(),
      });

      if (response.statusCode == 200) {
        _BlnValue = jsonDecode(response.body);
      } else {
        throw Exception('Failed to load mSetUserUpdateBln');
      }
      return _BlnValue;
    } on PlatformException catch (e) {
      print("Failed to usermast mSetUserUpdateBln: ${e.message}");
    }
    return _BlnValue;
  }
}
