class ConstantApi {
  static const String BaseURl = 'http://43.249.231.225:8080//';
  static const String LoginInsert = BaseURl + 'Login/USER_INSERT';
  static const String LoginDirectMsgExist = BaseURl + 'Login/USER_EXIST';
  static const String LoginUserGetData = BaseURl + 'Login/USER_GETDATA';
  static const String LoginUserUpdateOtpData =
      BaseURl + 'Login/USER_UPDATE_OTP';
  static const String LoginUserUpdateProfileData =
      BaseURl + 'Login/USER_UPDATE_PROFILE';
  static const String LoginUserUpdateNameData =
      BaseURl + 'Login/USER_UPDATE_NAME';
  static const String LoginUserUpdateBioData =
      BaseURl + 'Login/USER_UPDATE_BIO';
  static const String LoginUserUpdateBirthDateData =
      BaseURl + 'Login/USER_UPDATE_BIRTHDATE';
  static const String LoginUserUpdateSettingBln =
      BaseURl + 'Login/USER_UPDATE_SETTING_BLN';
  static const String LoginUserOnlineOffline =
      BaseURl + 'Login/USER_ONLINE_OFFLINE';

  //Contact Api
  static const String ContactSaveData = BaseURl + 'Contact/CONTACT_INSERT';
  static const String ContactSaveDataFavBlock =
      BaseURl + 'Contact/CONTACT_INSERT_FAV_BLOCK';
  static const String ContactGetData = BaseURl + 'Contact/CONTACT_GETDATA';
  static const String ContactUpdateFav = BaseURl + 'Contact/CONTACT_UPDATE_FAV';
  static const String ContactDirectSave =
      BaseURl + 'Contact/CONTACT_DIRECT_SAVE';
  static const String ContactWiseBlock = BaseURl + 'Contact/USER_WISE_BLOCK';

  //Main Chat Api
  static const String MainChatGetData = BaseURl + 'MessageMain/Select';

  //Group Api
  static const String GroupGetData = BaseURl + 'Group/GROUP_GETDATA';
  static const String SubGroupGetData = BaseURl + 'Group/GROUP_SUB_GETDATA';
  static const String GroupSaveData = BaseURl + 'Group/CONTACT_INSERT_GROUP';

  //Broadcast Api
  static const String BroadCastGetData =
      BaseURl + 'Broadcast/BROADCAST_GETDATA';
  static const String BroadSaveData =
      BaseURl + 'Broadcast/CONTACT_INSERT_BROADCAST';
  static const String BroadCastWiseGetData =
      BaseURl + 'Broadcast/BROADCAST_WISE_GETDATA';
  static const String BroadCastSaveName =
      BaseURl + 'Broadcast/BROADCAST_SAVENAME_UPDATE';
  static const String Broad_MainMessageUserWiseDeleteClear =
      BaseURl + 'Broadcast/UserDeleteClearAll';
  static const String Broad_SubMessageUserWiseDeleteClear =
      BaseURl + 'Broadcast/Sub_UserDeleteClearAll';

  //Group Api
  static const String DeviceSelectData = BaseURl + 'Device/Select';
  static const String DeviceLoginLogout = BaseURl + 'Device/LoginLogout';
  static const String DeviceInsertData = BaseURl + 'Device/INSERT';

  //Quick Reply Api
  static const String QuickReplyInsertData = BaseURl + 'QuickReply/INSERT';
  static const String QuickReplyDelete = BaseURl + 'QuickReply/DELETE';
  static const String QuickReplyGetData = BaseURl + 'QuickReply/SELECT';

  //Help Contact
  static const String InsertHelpContacts = BaseURl + 'HelpUser/Insert';

  //Auto Sender Api
  static const String AutoSender_Insert = BaseURl + 'MessageAutoSender/Insert';
  static const String AutoSender_Select = BaseURl + 'MessageAutoSender/Select';
  static const String AutoSender_Delete = BaseURl + 'MessageAutoSender/Delete';

  //Message Api
  static const String MessageSend = BaseURl + 'Message/Insert';
  static const String MessageGet = BaseURl + 'Message/Select';
  static const String MessageForward = BaseURl + 'Message/InsertForward';
  static const String MessageDeliveryUpdate =
      BaseURl + 'Message/UpdateMsgDelivery';
  static const String MessageReadDataUpdate = BaseURl + 'Message/UpdateMsgRead';
  static const String MessageReadUserWise =
      BaseURl + 'Message/UpdateUserWiseMsgRead';
  static const String MessageUserWiseClear = BaseURl + 'Message/UserWiseClear';
  static const String MessageUserWiseDelete = BaseURl + 'Message/UserDeleteAll';

  //TableUpdate Api
  static const String UpdateTableId = BaseURl + 'TableUpdate/Update';

  //Notification Api
  static const NotificationURL = "https://fcm.googleapis.com/fcm/send";
  static const ServerKey =
      "key=AAAANabYAOE:APA91bHDjOOkPffN5jAWGrTbMJjxM-VonpvzjQAP3omAd5AbtXlrxVHrlz-Uh7ScznDSIt1L_C5IbvUt9Aq4hXOE5mgpqtg9x4hoP1lR-8hJFzrejrRHhHSgLcaAdrYhOCtHdq5dlF3Y";
}
