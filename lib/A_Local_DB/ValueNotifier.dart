import 'package:flutter/foundation.dart';

class MyNotifierClass extends ValueNotifier<bool> {
  MyNotifierClass(bool value) : super(value);
  static ValueNotifier<bool> User_broad_Sync = ValueNotifier(true),
      User_broad_msg_Sync = ValueNotifier(true),
      User_contact_Sync = ValueNotifier(true),
      User_device_session_Sync = ValueNotifier(true),
      User_Mast_Sync = ValueNotifier(true),
      User_MSG_Sync = ValueNotifier(true),
      User_MSG_Last_Sync = ValueNotifier(true),
      User_Quick_Rep_Sync = ValueNotifier(true),
      User_Auto_Sender_Sync = ValueNotifier(true);

  static ValueNotifier<List> Searchfoundid = ValueNotifier([]);

  static bool get is_User_broad => User_broad_Sync.value;

  static bool get is_User_broad_msg => User_broad_msg_Sync.value;

  static bool get is_User_contact => User_contact_Sync.value;

  static bool get is_User_device_session => User_device_session_Sync.value;

  static bool get is_User_Mast => User_Mast_Sync.value;

  static bool get is_User_MSG => User_MSG_Sync.value;

  static bool get is_User_MSG_Last => User_MSG_Last_Sync.value;

  static bool get is_User_Quick_Rep => User_Quick_Rep_Sync.value;

  static bool get is_User_Auto_Sender => User_Auto_Sender_Sync.value;

  static List get is_Searchfoundid => Searchfoundid.value;

  void updateBool({required bool value, required String Key}) {
    switch (Key) {
      case 'USER_BROADCAST':
        User_broad_Sync.value = value;
        break;
      case 'USER_MSG_BROADCAST':
        User_broad_msg_Sync.value = value;
        break;
      case 'USER_CONTACT':
        User_contact_Sync.value = value;
        break;
      case 'USER_DEVICE_SESSION':
        User_device_session_Sync.value = value;
        break;
      case 'USER_MAST':
        User_Mast_Sync.value = value;
        break;
      case 'USER_MSG':
        User_MSG_Sync.value = value;
        break;
      case 'USER_MSG_LAST':
        User_MSG_Last_Sync.value = value;
        break;
      case 'USER_QUICK_REP':
        User_Quick_Rep_Sync.value = value;
        break;
      case 'USER_MSG_AUTOSENDER':
        User_Auto_Sender_Sync.value = value;
        break;
      case 'Searchfoundid':
        User_Auto_Sender_Sync.value = value;
        break;
    }
  }

  void updateList({required List value, required String Key}) {
    switch (Key) {
      case 'Searchfoundid':
        Searchfoundid.value = value;
        break;
    }
  }

  bool getbool({required String Key}) {
    switch (Key) {
      case 'USER_BROADCAST':
        return is_User_broad;
      case 'USER_MSG_BROADCAST':
        return is_User_broad_msg;
      case 'USER_CONTACT':
        return is_User_contact;
      case 'USER_DEVICE_SESSION':
        return is_User_device_session;
      case 'USER_MAST':
        return is_User_Mast;
      case 'USER_MSG':
        return is_User_MSG;
      case 'USER_MSG_LAST':
        return is_User_MSG_Last;
      case 'USER_QUICK_REP':
        return is_User_Quick_Rep;
      case 'USER_MSG_AUTOSENDER':
        return is_User_Auto_Sender;
      default:
        return true;
    }
  }

  List getList({required String Key}) {
    switch (Key) {
      case 'Searchfoundid':
        return is_Searchfoundid;
      default:
        return [];
    }
  }
}
