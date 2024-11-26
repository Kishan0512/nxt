import 'package:flutter/material.dart';
import 'package:nextapp/Constant/Con_Clr.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';

const Own_Error = Icon(Icons.error);
const Own_Float_Addressbook =
    Icon(Icons.chat_rounded, color: AppBar_PrimaryColor);
const Own_Face = Icons.emoji_emotions_outlined;
const Own_Delete_Search = Icon(Icons.close, color: Con_white);
const Own_Remove_Media = Icon(
  Icons.close,
  color: Con_white,
  size: 20,
);
const Own_Remove_Profile = Icon(
  Icons.close,
  color: Con_black,
  size: 16,
);
const Own_Remove = Icon(Icons.close_rounded, color: AppGreyColor);
const Own_Close_doc = Icon(
  Icons.close_rounded,
  color: Con_msg_auto_6,
  size: 10,
);
const Dark_Remove = Icon(Icons.delete, color: Dark_AppGreyColor);
const Own_Delete = Icon(Icons.delete, color: AppGreyColor);
const Dark_Delete = Icon(Icons.delete, color: Dark_AppGreyColor);
const Own_Pic_SelectProfile =
    Icon(Icons.camera_alt_rounded, color: AppGreyColor);
const Dark_Pic_SelectProfile =
    Icon(Icons.camera_alt_rounded, color: Dark_AppGreyColor);
const Own_Pic_ViewProfile = Icon(Icons.visibility, color: AppGreyColor);
const Dark_Pic_ViewProfile = Icon(Icons.visibility, color: Dark_AppGreyColor);
const Own_Pic_folder = Icon(Icons.folder, color: AppGreyColor);
const Dark_Pic_folder = Icon(Icons.folder, color: Dark_AppGreyColor);

const Own_NotificationTone =
    Icon(Icons.notifications_none, size: 30, color: AppGreyColor);
const Dark_NotificationTone =
    Icon(Icons.notifications_none, size: 30, color: Dark_AppGreyColor);

const Own_Lock_Outline =
    Icon(Icons.lock_outline, size: 30, color: AppGreyColor);
const Own_ChatBubble =
    Icon(Icons.chat_bubble_outline_rounded, size: 30, color: AppGreyColor);
const Own_FolderOutlined =
    Icon(Icons.folder_outlined, size: 30, color: AppGreyColor);
const Own_DownloadOutlined =
    Icon(Icons.download_outlined, size: 30, color: AppGreyColor);
const Own_HelpOutline = Icon(Icons.help_outline, size: 30, color: AppGreyColor);
const Own_SunnyOutlined =
    Icon(Icons.wb_sunny_outlined, size: 30, color: AppGreyColor);
const Own_Logout = Icon(Icons.logout, size: 28, color: AppLogOutRed);
const Own_LogoutMain = Icon(Icons.logout, size: 28, color: AppGreyColor);

const Clear_Chat = Icon(Icons.clear_all, color: App_IconColor);
const Chat_Clear = Icon(Icons.clear_all, color: Con_white);
const Own_Delete_White = Icon(Icons.delete, color: Con_white);
const Own_Send = Icon(Icons.send, color: Con_white);
const Own_Edit = Icon(Icons.edit);
const Own_Pop = Icon(Icons.more_vert, size: 20);
const Own_Attachment = Icon(Icons.attachment, size: 23, color: Con_msg_auto_6);
const Dark_Attachment =
    Icon(Icons.attachment, size: 23, color: LightTheme_White);
const Own_Calander =
    Icon(Icons.calendar_month_rounded, size: 28, color: AppGreyColor);
const Dark_Calander =
    Icon(Icons.calendar_month_rounded, size: 28, color: LightTheme_White);
const Own_Calander1 =
    Icon(Icons.calendar_month_rounded, size: 20, color: AppGreyColor);
const Dark_Calander1 =
    Icon(Icons.calendar_month_rounded, size: 20, color: Con_msg_auto_6);
const Own_User = Icon(Icons.supervised_user_circle, size: 30);
const Own_Add = Icon(Icons.add, size: 20, color: Con_white);
const Own_Account = Icon(Icons.person_outline, size: 20,color: Dark_ChatFieldIcon,);
// const Own_Phone = FaIcon(FontAwesomeIcons.phone, size: 20);
const Own_Phone = Icon(Icons.local_phone_outlined, size: 20,color: Dark_ChatFieldIcon,);
// const Own_About = FaIcon(FontAwesomeIcons.user, size: 20);
const Own_About = Icon(Icons.info_outline, size: 20,color: Dark_ChatFieldIcon,);
const Own_Save = Icon(Icons.check);
const Own_Save_white = Icon(
  Icons.check_rounded,
  color: Con_white60,
  size: 50,
);
const Own_Image = Icon(Icons.image);

const Own_Colors = Icon(Icons.color_lens_sharp);

const Own_Camera = Icon(Icons.camera);
const Own_Message = Icon(Icons.chat_rounded, color: App_IconColor);
const Own_Search = Icon(Icons.search);
const Own_audio_play =
    Icon(Icons.play_arrow_rounded, size: 15, color: Con_black54);
const Own_audio_pause = Icon(Icons.pause_rounded, size: 15, color: Con_black54);
const Dark_audio_play =
    Icon(Icons.play_arrow_rounded, size: 15, color: Dark_MediaBox_Item);
const Dark_audio_pause =
    Icon(Icons.pause_rounded, size: 15, color: Dark_MediaBox_Item);
const Dark_audio_pause2 =
    Icon(Icons.pause_rounded, size: 15, color: Dark_MediaBox);
const Own_More = Icon(Icons.more_vert);
const Own_Star_Border = Icon(Icons.star_border);
const Own_Up = Icon(Icons.arrow_drop_up, color: Con_white, size: 30);
const Own_Down = Icon(Icons.arrow_drop_down, color: Con_white, size: 30);
const Own_ArrowBack = Icon(Icons.arrow_back_ios_new);

const Own_FileDownload = Icon(Icons.image);
const Own_Picture = Icon(Icons.image);
const Own_Video = Icon(Icons.videocam);
const Own_File_Audio = Icon(Icons.audiotrack);
const Own_File_Docs = Icon(Icons.document_scanner);

ReadIcon(int Value) {
  return (ReadMet(Value, Constants_Usermast.user_icon_selected));
}

const Own_Con_camera_alt = Icon(Icons.camera_alt);

ReadMet(int Value, int IconSelect) {
  late Widget _Widget;
  switch (IconSelect) {
    case 0:
      if (Value == 0) {
        _Widget = const Icon(
          Icons.check_circle_outline_sharp,
          color: Chat_UnReadColor,
          size: 15,
        );
      } else if (Value == 1) {
        _Widget = const Icon(Icons.check_circle_outline_sharp,
            color: Chat_UnReadColor, size: 15);
      } else if (Value == 2) {
        _Widget =
            const Icon(Icons.check_circle, color: Chat_ReadColor, size: 15);
      }
      break;
    case 1:
      if (Value == 0) {
        _Widget = const Icon(Icons.update, color: Chat_UnReadColor, size: 15);
      } else if (Value == 1) {
        _Widget = const Icon(Icons.update, color: Chat_UnReadColor, size: 15);
      } else if (Value == 2) {
        _Widget = const Icon(Icons.image, color: Chat_ReadColor, size: 15);
      }
      break;
    case 2:
      if (Value == 0) {
        _Widget = const Icon(Icons.clear, color: Chat_UnReadColor, size: 15);
      } else if (Value == 1) {
        _Widget = const Icon(Icons.clear, color: Chat_UnReadColor, size: 15);
      } else if (Value == 2) {
        _Widget = const Icon(Icons.print, color: Chat_ReadColor, size: 15);
      }
      break;
    case 3:
      if (Value == 0) {
        _Widget =
            const Icon(Icons.exit_to_app, color: Chat_UnReadColor, size: 15);
      } else if (Value == 1) {
        _Widget =
            const Icon(Icons.exit_to_app, color: Chat_UnReadColor, size: 15);
      } else if (Value == 2) {
        _Widget = const Icon(Icons.chat, color: Chat_ReadColor, size: 15);
      }
      break;
  }
  return _Widget;
}
