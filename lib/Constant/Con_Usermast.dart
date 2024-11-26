import 'dart:core';
import 'dart:io';

import 'Constants.dart';

class Constants_Usermast {
  static String user_id = "",
      user_mast_id = "",
      country_code = "",
      mobile_number = "",
      disp_mobile_number = "",
      user_bio = "",
      user_login_name = "",
      user_bio_last_datetime = "",
      user_profileimage_path = "",
      user_birthdate = "",
      user_wallpaper = "",
      user_last_login = "",
      user_appfirstscreen_logo = "assets/images/Nxt_Logo.webp",
      user_profileimage_path_global = "assets/images/blank_profile.webp",
      user_broadimage_path_global = "assets/images/blank_broadcast_1.webp",
      user_groupimage_path_global = "ssets/images/blank_broadcast_1.webp",
      isAndoirdPic = "assets/images/Session_Android.webp",
      isIOSPic = "assets/images/Session_IoS.webp",
      isMacOSPic = "assets/images/Session_Mac.webp",
      isWindowsPic = "assets/images/Session_Windows.webp";
  static Directory? dbpath;
  static int user_is_otp = 0,
      user_icon_selected = 0,
      user_vibrate = 1,
      use_show_profilepicture = 0,
      user_show_last_seen = 0,
      user_show_mybirthday = 0,
      user_theme_setting = 0;
  static bool user_chat_bln_favourite_contacts = true,
      mBoolPopupSelect = true,
      user_chat_bln_quick_reply = true,
      user_notify_conversionTone = true,
      tmp = false,
      user_is_login = false,
      user_is_logout = false,
      user_is_online = false,
      user_chat_mobile_audio = true,
      user_chat_mobile_Document = true,
      user_chat_mobile_images = true,
      user_chat_mobile_video = true,
      user_chat_wifi_audio = true,
      user_chat_wifi_Document = true,
      user_chat_wifi_images = true,
      user_chat_wifi_video = true;

  static BlankCaller() {
    Constants_Usermast.user_id = "";
    Constants_Usermast.country_code = "";
    Constants_Usermast.mobile_number = "";
    Constants_Usermast.disp_mobile_number = "";
    Constants_Usermast.user_login_name = "";
    Constants_Usermast.user_bio = "";
    Constants_Usermast.user_bio_last_datetime = "";
    Constants_Usermast.user_is_login = false;
    Constants_Usermast.user_is_logout = false;
    Constants_Usermast.user_is_online = false;
    Constants_Usermast.user_is_otp = 0;
    Constants_Usermast.country_code = "";
    Constants_Usermast.user_birthdate = "";
    Constants_Usermast.user_chat_mobile_audio = true;
    Constants_Usermast.user_chat_mobile_video = true;
    Constants_Usermast.user_chat_mobile_Document = true;
    Constants_Usermast.user_chat_wifi_audio = true;
    Constants_Usermast.user_chat_mobile_images = true;
    Constants_Usermast.user_chat_wifi_images = true;
    Constants_Usermast.user_chat_wifi_Document = true;
    Constants_Usermast.user_chat_wifi_video = true;
    Constants_Usermast.user_icon_selected = 0;
    Constants_Usermast.user_notify_conversionTone = true;
    Constants_Usermast.use_show_profilepicture = 0;
    Constants_Usermast.user_show_last_seen = 0;
    Constants_Usermast.user_show_mybirthday = 0;
    Constants_Usermast.user_wallpaper = "";
    Constants_Usermast.user_last_login = "";
    Constants_Usermast.user_profileimage_path = "";
    Constants_Usermast.user_vibrate = 0;

    Constants_List.need_contact.clear();
    Constants_List.needs_contact_msg.clear();
    Constants_List.need_broadcast.clear();
    Constants_List.need_quickreply.clear();
    Constants_List.needs_group.clear();
    Constants_List.needs_group_sub.clear();
    Constants_List.needs_fav.clear();
  }
}
