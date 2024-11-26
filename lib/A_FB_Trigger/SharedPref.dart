import 'dart:convert';

import 'package:nextapp/A_FB_Trigger/sql_need_broadcast_sub_msg.dart';
import 'package:nextapp/A_FB_Trigger/sql_need_contact.dart';
import 'package:nextapp/A_FB_Trigger/sql_need_main_sub_chat.dart';
import 'package:nextapp/A_FB_Trigger/sql_need_mainchat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(key) == "null" ||
        prefs.getString(key) == "" ||
        prefs.getString(key) == "[]" ||
        prefs.getString(key) == null) {
      return "";
    }
    return json.decode(prefs.getString(key) ?? '');
  }

  static clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static read_string(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString(key) ?? '');
  }

  static save_main_msg(String key, List<Need_MainChat> a) async {
    final prefs = await SharedPreferences.getInstance();
    String encode = Need_MainChat.encode(a);
    prefs.setString(key, encode);
  }

  static save_sub_msg(String key, List<Need_Main_Sub_Chat> a) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String encode = Need_Main_Sub_Chat.encode(a);
      prefs.setString(key, encode);
    } catch (ex) {}
  }

  static save_broad_msg(String key, List<Need_Broadcast_Sub_Msg> a) async {
    final prefs = await SharedPreferences.getInstance();
    String encode = Need_Broadcast_Sub_Msg.encode(a);
    prefs.setString(key, encode);
  }

  static save_string(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, (value));
  }

  static save_int(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  static remove_key(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  static save_Contact(String key, List<Need_Contact> a) async {
    final prefs = await SharedPreferences.getInstance();
    String encode = Need_Contact.encode(a);
    prefs.setString(key, json.encode(encode));
  }

  static savelist(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, (value));
  }

  static read_int(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  static readlist(String key) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> Value = prefs.getStringList(key) ?? [];
    if (Value.isEmpty) {
      return Value;
    }
    return Value;
  }

  static read_bool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static save_bool(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
