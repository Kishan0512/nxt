import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nextapp/A_FB_Trigger/DatabaseService.dart';
import 'package:nextapp/A_FB_Trigger/sql_need_contact.dart';
import 'package:nextapp/A_FB_Trigger/sql_user_device_session.dart';
import 'package:nextapp/A_SQL_Trigger/sql_groups.dart';
import 'package:nextapp/A_SQL_Trigger/sql_usermast.dart';

import '../A_FB_Trigger/sql_need_mainchat.dart';
import '../A_FB_Trigger/sql_need_quickreply.dart';
import '../A_FB_Trigger/sql_user_broadcast.dart';
import '../A_SQL_Trigger/Local_Contact.dart';
import '../OSFind.dart';
import 'Con_Clr.dart';

class Constants {
  static const String AppName = 'Chat App',
      Settings = 'Settings',
      AutoSender = 'Auto Sender',
      SavedMessage = 'Saved Messages',
      usermainmsg = 'USER_MSG_LAST',
      usersubmsg = 'USER_MSG',
      Contacts = 'Contacts',
      Table_UserMast = 'USER_MAST',
      Table_User_Device_Session = 'USER_DEVICE_SESSION',
      Table_Contacts_user_wise = 'USER_CONTACT',
      Table_Contacts_broadcast = 'USER_BROADCAST',
      Table_Msg_broadcast = 'USER_MSG_BROADCAST',
      Table_Msg_AutoSender = 'USER_MSG_AUTOSENDER',
      Table_Contacts_Group = 'tbl_contacts_group',
      Table_Contacts_Group_Key = '_msg',
      Table_Contacts_Group_Key_Clear = '_clear',
      Table_Contacts_Group_Msg = 'tbl_contacts_group_msg',
      Table_QuickReplies = 'USER_QUICK_REP';

  // static const String usersubmsgbroad = 'USER_MSG_BROAD';
  static const List<String> MessagePageChoices = <String>[
        AutoSender,
        SavedMessage,
        Contacts
      ],
      Light_Solid_Color = [
        'assets/solid/default.webp',
        'assets/solid/Light_Frame 138.webp',
        'assets/solid/Light_Frame 137.webp',
        'assets/solid/Light_Frame 119.webp',
        'assets/solid/Light_Frame 120.webp',
        'assets/solid/Light_Frame 121.webp',
        'assets/solid/Light_Frame 126.webp',
        'assets/solid/Light_Frame 127.webp',
        'assets/solid/Light_Frame 135.webp',
        'assets/solid/Light_Frame 136.webp',
      ],
      Dark_Solid_Color = [
        'assets/solid/Dark_Frame 142.webp',
        'assets/solid/Dark_Frame 145.webp',
        'assets/solid/Dark_Frame 148.webp',
        'assets/solid/Dark_Frame 149.webp',
        'assets/solid/Dark_Frame 152.webp',
        'assets/solid/Dark_Frame 155.webp',
        'assets/solid/Dark_Frame 160.webp',
        'assets/solid/Dark_Frame 161.webp',
        'assets/solid/Dark_Frame 163.webp',
      ];

  static List<Map> WallpaperChat = [
    {
      "is_right": "2",
      "msg_type": "1",
      "msg_content": "This is a sample message",
      "date": DateTime.now(),
      "is_read": "null",
      "center_date": "Today",
      "id": "1"
    },
    {
      "is_right": "2",
      "msg_type": "1",
      "msg_content": "This is a sample message",
      "date": DateTime.now(),
      "is_read": "null",
      "center_date": "Today",
      "id": "1"
    },
    {
      "is_right": "1",
      "msg_type": "1",
      "msg_content": "This is a sample message",
      "date": DateTime.now(),
      "is_read": "null",
      "center_date": "Today",
      "id": "1"
    }
  ];
  static List<FileSystemEntity> wallpaperFiles = [];

  static Widget mAppBar(String pStrText) {
    return Text(pStrText);
  }

  static Widget ChatBuildDivider() {
    return const Divider(
      height: 0.0,
      color: Con_black38,
      indent: 85.0,
      endIndent: 10.0,
    );
  }

  static Widget SettingBuildDivider() {
    return Os.isIOS
        ? const Divider(
            color: Con_grey,
            indent: 10.0,
            endIndent: 10.0,
          )
        : const Divider(
            color: Con_grey,
            indent: 10.0,
            endIndent: 10.0,
          );
  }

  static Widget MainSettingBuildDivider() {
    return const Divider(
      color: Con_grey,
      indent: 80.0,
      endIndent: 5.0,
    );
  }

  static Widget ActiveSessionBuildDivider() {
    return const Divider(
      color: Con_grey,
      indent: 5.0,
      endIndent: 5.0,
    );
  }

  static Widget ChatSubBuildDivider() {
    return Container(height: 3, color: Con_Main_1);
  }
}

class Constants_List {
  static List<sql_usermast_tran> need_user_mast = [];
  static List<Need_MainChat> needs_main_chat = [];
  static List<Need_QuickReply> need_quickreply = [];
  static List<Need_DeviceSession> need_DeviceSession = [],
      session_active = [],
      session_session = [];
  static List<Need_Contact> need_contact = [],
      needs_online = [],
      needs_fav = [],
      needs_block = [];
  static List<Need_Contact_Msg> needs_contact_msg = [];
  static List<Need_Group> needs_group = [];
  static List<Need_Group_Sub> needs_group_sub = [];
  static List<Need_Broadcast> need_broadcast = [];
  static List<My_Group_Contact_Sub> group_contact_sub = [];
  static List<Local_Contact> Con_Local_Contact = [];

  static Constants_List_Clear() {
    needs_main_chat.clear();
    need_user_mast.clear();
    need_DeviceSession.clear();
    need_quickreply.clear();
    session_active.clear();
    need_contact.clear();
    needs_block.clear();
    needs_online.clear();
    needs_contact_msg.clear();
    needs_fav.clear();
    need_broadcast.clear();
    needs_group.clear();
    needs_group_sub.clear();
    need_broadcast.clear();
    group_contact_sub.clear();
  }
}

class Constants_Fonts {
  static const mGblFontTitleSize = 16.00,
      mGblFontSubTitleSize = 13.00,
      mGblFontTimeShowSize = 13.00;
}
