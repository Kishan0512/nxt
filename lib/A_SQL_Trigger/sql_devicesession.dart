import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;
import 'package:nextapp/A_Local_DB/Sync_Json.dart';
import 'package:nextapp/A_SQL_Trigger/ConstantApi.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:nextapp/Login/DownloadData.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../A_FB_Trigger/sql_user_device_session.dart';
import '../A_Local_DB/Sync_Database.dart';
import '../Constant/Constants.dart';

class sql_devicesession_tran {
  static Future<String> GetIPAddress() async {
    String pStrIpAddress = "";
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (pStrIpAddress.isEmpty) {
          pStrIpAddress = addr.address.toString();
          return pStrIpAddress;
        }
      }
    }
    return pStrIpAddress;
  }

  static setDeviceSession() async {
    try {
      var ipad = await GetIPAddress();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      if (ipad.isNotEmpty) {
        final response =
            await http.post(Uri.parse(ConstantApi.DeviceInsertData), body: {
          "user_mast_id": Constants_Usermast.user_id,
          "ipaddress": ipad,
          "nxtapp_version": packageInfo.version.toString(),
          "mobile_version": Platform.operatingSystemVersion.toString(),
          "mobile_name": androidInfo.model.toString(),
          "isAndroid": Platform.isAndroid ? 'true' : 'false',
          "isIOS": Platform.isIOS ? 'true' : 'false',
          "isMacOS": Platform.isMacOS ? 'true' : 'false',
          "isWindows": Platform.isWindows ? 'true' : 'false',
        });
        if (!DownloadData.Keyvalue.contains("setDeviceSession")) {
          DownloadData.Keyvalue.add("setDeviceSession");
          DownloadData.respones.add(response.statusCode);
        }
        if (response.statusCode == 200) {
          SyncDB.SyncTable(Constants.Table_User_Device_Session, false);
        } else {}
      }
    } catch (e) {}
  }

  static getActiveSessionDetails() async {
    List<Need_DeviceSession> needs =
        await SyncJSon.user_device_session_select();
    Constants_List.session_active =
        needs.where((element) => element.is_active == 1).toList();
    Constants_List.session_session =
        needs.where((element) => element.is_active == 0).toList();
    return needs;
  }

  static getCurrentSessionActive() async {
    Object? tableIpad;
    SyncDB.SyncTable(Constants.Table_User_Device_Session, false);
    // priyank comment , true to false
    List<Need_DeviceSession> needs =
        await SyncJSon.user_device_session_select();
    var ipad = await GetIPAddress();
    if (needs.isNotEmpty && ipad.isNotEmpty) {
      tableIpad = needs.isNotEmpty
          ? needs
              .where((element) => element.ipaddress == ipad.toString())
              .first
              .is_active
          : "";
    }
    return tableIpad == 0 ? true : false;
  }

  static setLoginSessionDetails(bool _blnlogin) async {
    var ipad = await GetIPAddress();

    if (ipad.isNotEmpty) {
      final response =
          await http.post(Uri.parse(ConstantApi.DeviceLoginLogout), body: {
        "user_mast_id": Constants_Usermast.user_id,
        "ipaddress": ipad,
        "TYPE": (_blnlogin ? "LOGIN" : "LOGOUT")
      });
      if (!DownloadData.Keyvalue.contains("setLoginSessionDetails")) {
        DownloadData.Keyvalue.add("setLoginSessionDetails");
        DownloadData.respones.add(response.statusCode);
      }
      if (response.statusCode == 200) {
      } else {
        throw Exception(
            'Failed to load (sql_devicesession_tran,setLoginSessionDetails)');
      }
    }
  }

  static setLogoutAllSession() async {
    var ipad = await GetIPAddress();
    if (ipad.isNotEmpty) {
      final response =
          await http.post(Uri.parse(ConstantApi.DeviceLoginLogout), body: {
        "user_mast_id": Constants_Usermast.user_id,
        "ipaddress": ipad,
        "TYPE": "LOGOUTALL"
      });
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }
  }

  static setLogoutIdSession(String pStrId) async {
    var ipad = await GetIPAddress();
    if (ipad.isNotEmpty) {
      final response =
          await http.post(Uri.parse(ConstantApi.DeviceLoginLogout), body: {
        "user_mast_id": Constants_Usermast.user_id,
        "ipaddress": ipad,
        "id": pStrId,
        "TYPE": "LOGOUT_ID"
      });
      if (response.statusCode == 200) {
      } else {
        throw Exception(
            'Failed to load (sql_devicesession_tran,setLogoutIdSession)');
      }
    }
  }
}
