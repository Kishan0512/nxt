//todo                                                  卐   ॐ નમઃ શિવાય   卐

import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:nextapp/A_Local_DB/Sync_Database.dart';
import 'package:nextapp/A_Local_DB/Sync_Json.dart';
import 'package:nextapp/A_SQL_Trigger/sql_contact.dart';
import 'package:nextapp/A_SQL_Trigger/sql_main_messages.dart';
import 'package:nextapp/A_SQL_Trigger/sql_sub_messages.dart';
import 'package:nextapp/Con_Contacts/contacts.dart';
import 'package:nextapp/Constant/Con_AppBar_ChatProfile.dart';
import 'package:nextapp/Constant/Con_Clr.dart';
import 'package:nextapp/Constant/Con_Icons.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:nextapp/ExtraDarts/widget/auto_scroll.dart';
import 'package:nextapp/main.dart';
import 'package:nextapp/mdi_page/A_ChatBubble/ChatBubble.dart';
import 'package:nextapp/mdi_page/Message/msg_sub_quickreplies.dart';
import 'package:nextapp/mdi_page/Wallpaper/chat_wallpaper.dart';
import 'package:nextapp/mdi_page/chat_mdi_page.dart';
import 'package:nextapp/tem.dart';

import '../../A_FB_Trigger/sql_need_main_sub_chat.dart';
import '../../Constant/Center_widget/grouped_list.dart';
import '../../Constant/Con_Wid.dart';
import '../../Constant/Image_picker/drishya_picker.dart';
import '../../OSFind.dart';
import 'Message_info/msg_info.dart';
import 'msg_sub_show_media_list.dart';

class sub_contactsdetails extends StatefulWidget {
  late String mStrMobile;
  late String usermastid;
  late String mStrName;
  late String mStrProfile;
  late bool mBlnFav;
  late String mStrLastBio;
  late String mStrLastBioDate;
  late bool mBlnLastOnline;
  late String mStrLastLoginTime;
  late String mStrLastBirthdate;
  late String mStrLastfinalmobilenumber;
  late bool mBlnBlock;
  String? serverKey;
  bool? isContact;

  sub_contactsdetails(
      this.mStrMobile,
      this.usermastid,
      this.mStrName,
      this.mStrProfile,
      this.mBlnFav,
      this.mStrLastBio,
      this.mStrLastBioDate,
      this.mBlnLastOnline,
      this.mStrLastLoginTime,
      this.mStrLastBirthdate,
      this.mStrLastfinalmobilenumber,
      this.mBlnBlock,
      {this.serverKey,
      this.isContact,
      Key? key})
      : super(key: key);

  @override
  sub_contactsdetailsPageState createState() => sub_contactsdetailsPageState();
}

enum PopUpData {
  MediaLinksdocs,
  Search,
  Wallpaper,
  QuickReplies,
  Block,
  ClearChat
}

class sub_contactsdetailsPageState extends State<sub_contactsdetails>
    with SingleTickerProviderStateMixin {
  sub_contactsdetailsPageState();

  //todo Scroll to last massage
  bool isnotinbottom = false;
  ValueNotifier<int> lastindex = ValueNotifier(0);
  ValueNotifier<int> latestindex = ValueNotifier(0);
  ValueNotifier<int> Count = ValueNotifier(0);
  bool values = false;

  //todo complete
  final TextEditingController _searchQuery = TextEditingController();
  final TextEditingController _txtcont = TextEditingController();
  late ScrollController _controller;
  late final GalleryController controllerimage;
  String selectpStrmess = "",
      selectedmesstipe = "",
      selectedmediasize = "",
      selectedimagename = "",
      selectedurl = "",
      wallpaper = "";
  List<Need_Main_Sub_Chat> _needs_sub_msg = [],
      _selected_needs_sub_msg = [],
      _needs_mess_imfo = [],
      mListResults = [];
  late int mIntCurrentIndex = 0, mIntBroadCount = 0;
  late final AnimationController animationController;
  bool isShowSticker = false,
      mBoolAppBarNew = false,
      mBlnIsBlockUserMe = false,
      mBoolMediaShare = false,
      Emojishow = false,
      iscenterdatehide = true,
      isSearching = false,
      mBoolPopupSelect = true,
      isLocal = false;


  int SearchIndex = 0;
  Timer? timer;
  StreamController<BoxEvent> _quick_rep_strm_con = StreamController<BoxEvent>();
  StreamController<BoxEvent> _Sub_chat_strm_con = StreamController<BoxEvent>();
  var _quick_rep_box;
  var _Sub_chat_box;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()
      ..addListener(() {
        setState(() {
          if (_controller.position.pixels > 10.0) {
            isnotinbottom = true;
            Count.value = lastindex.value - latestindex.value;
            values = true;
          } else {
            isnotinbottom = false;
            latestindex.value = lastindex.value;
            values = true;
          }
        });
      })
      ..addListener(_scrollListener);
    UserWiseBlock();
    controllerimage = GalleryController();
    _openBox();
    setupNeeds_Msg(widget.usermastid);
    _selected_needs_sub_msg = [];
    sql_main_messages_tran.ReadUserWiseMsg(
        widget.usermastid, Constants_Usermast.user_id);
    isShowSticker = false;
    users = false;
  }

  @override
  Widget build(BuildContext context) {
    SyncJSon.user_sub_main_chat_select();
    sql_main_messages_tran.ReadUserWiseMsg(
        widget.usermastid, Constants_Usermast.user_id);
    getWallpaper();
    final List<Need_Main_Sub_Chat> imageList = _needs_sub_msg
        .where((element) =>
            element.document_url != "null" && element.msg_type == "2")
        .toList();
    final List<Need_Main_Sub_Chat> videolist = _needs_sub_msg
        .where((element) =>
            element.document_url != "null" && element.msg_type == "5")
        .toList();
    final List<Need_Main_Sub_Chat> audiolist = _needs_sub_msg
        .where((element) =>
            element.document_url != "null" && element.msg_type == "3")
        .toList();
    final List<Need_Main_Sub_Chat> doculist = _needs_sub_msg
        .where((element) =>
            element.document_url != "null" && element.msg_type == "4")
        .toList();
    _openBox();
    return WillPopScope(
      child: Os.isIOS
          ? SlidableGallery(
              controller: controllerimage,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                extendBody: false,
                extendBodyBehindAppBar: false,
                appBar: mBoolAppBarNew == true
                    ? EnableAppBar(context)
                    : (
                        AppBar(
                        titleSpacing: -8,
                        leadingWidth: 40,
                        leading: Container(
                          margin: const EdgeInsets.only(left: 3),
                          child: Con_Wid.mIconButton(
                            icon: _selected_needs_sub_msg.isEmpty
                                ? Own_ArrowBack
                                : Own_Delete_Search,
                            onPressed: () {
                              _selected_needs_sub_msg.isEmpty
                                  ? navigate == true
                                      ? Navigator.pushReplacement(
                                          context,
                                          RouteTransitions.slideTransition(
                                              widget.isContact ?? false
                                                  ? const Contacts()
                                                  : MdiMainPage()))
                                      : Navigator.pushReplacement(
                                          context,
                                          RouteTransitions.slideTransition(
                                              widget.isContact ?? false
                                                  ? const Contacts()
                                                  : MdiMainPage()))
                                  : {
                                      setState(() {
                                        _selected_needs_sub_msg.clear();
                                        selected_needs_sub_msg.clear();
                                        mBoolMsgSelectMode = false;
                                      })
                                    };
                            },
                          ),
                        ),
                        title: _selected_needs_sub_msg.isEmpty
                            ? AppBarChatProfile(
                                mobilenumber: widget.mStrMobile,
                                name: widget.mStrName,
                                usermastid: widget.usermastid,
                                user_profile: widget.mStrProfile,
                                user_bio: widget.mStrLastBio,
                                user_last_is_online: widget.mBlnLastOnline,
                                user_last_login_time: widget.mStrLastLoginTime,
                                user_last_biodate: widget.mStrLastBioDate,
                                user_last_birthdate: widget.mStrLastBirthdate,
                                user_last_final_mobile_number:
                                    widget.mStrLastfinalmobilenumber,
                                user_block: widget.mBlnBlock,
                                imageList: imageList,
                                videolist: videolist,
                                audiolist: audiolist,
                                doculist: doculist,
                                mBlnIsBlockUserMe: mBlnIsBlockUserMe,
                              )
                            : Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                    "${_selected_needs_sub_msg.length} Selected"),
                              ),
                        actions: <Widget>[
                          if (_selected_needs_sub_msg.isNotEmpty)
                            Con_Wid.mIconButton(
                                onPressed: () {
                                  var fromIds = _selected_needs_sub_msg
                                      .where((e) =>
                                          e.msg_from_user_mast_id ==
                                          Constants_Usermast.user_mast_id)
                                      .map((e) => e.id.trim())
                                      .join(",");
                                  var toIds = _selected_needs_sub_msg
                                      .where((e) =>
                                          e.msg_from_user_mast_id !=
                                          Constants_Usermast.user_mast_id)
                                      .map((e) => e.id.trim())
                                      .join(",");
                                  sql_sub_messages_tran.Sub_ChatUserWiseDelete(
                                      Constants_Usermast.user_id,
                                      int.parse(widget.usermastid),
                                      toIds,
                                      fromIds,
                                      false);
                                  setState(() {
                                    setupNeeds_Msg(widget.usermastid);
                                    _selected_needs_sub_msg.clear();
                                    selected_needs_sub_msg.clear();
                                    mBoolMsgSelectMode = false;
                                  });
                                },
                                icon: Own_Delete_White),
                          if (_selected_needs_sub_msg.isNotEmpty &&
                              _selected_needs_sub_msg.length == 1 &&
                              selectpStrmess == "1")
                            Con_Wid.mIconButton(
                                onPressed: () {
                                  _needs_mess_imfo.clear();
                                  _needs_mess_imfo = _needs_sub_msg
                                      .where((e) =>
                                          e.id.toString() ==
                                          _selected_needs_sub_msg[0]
                                              .id
                                              .toString())
                                      .toList();
                                  if (selectpStrmess == "1") {
                                    List<msginfo> info = [];
                                    info.add(msginfo(
                                        mStrName: widget.mStrName,
                                        mStrProfile: widget.mStrProfile,
                                        Userid: widget.usermastid,
                                        ReadTime: _needs_mess_imfo[0].read_time,
                                        DeliverdTime: _needs_mess_imfo[0]
                                            .delivered_time));
                                    Navigator.push(
                                        context,
                                        RouteTransitions.slideTransition(
                                            msg_info(
                                          Userlist: info,

                                          msg_content:
                                              _needs_mess_imfo[0].msg_content,
                                          pStrBlurhash:
                                              _needs_mess_imfo[0].msg_blurhash,
                                          msg_type: selectedmesstipe,
                                          is_alert: true,
                                          send_time: _needs_mess_imfo[0]
                                              .date
                                              .substring(_needs_mess_imfo[0]
                                                      .date
                                                      .length -
                                                  8),
                                          Audioname: selectedimagename,
                                          imagename: selectedurl,
                                          mediasize: selectedmediasize,
                                        )));
                                  }
                                },
                                icon: const Icon(Icons.info_outline)),
                          if (_selected_needs_sub_msg.isEmpty)
                            widget.mBlnFav
                                ? Con_Wid.mIconButton(
                                    icon: const Icon(Icons.star),
                                    onPressed: () async {
                                      setState(() {
                                        widget.mBlnFav =
                                            widget.mBlnFav ? false : true;
                                        sql_contact_tran.mSetUserWiseUpdateFav(
                                            widget.mStrMobile.toString(),
                                            'user_is_favourite',
                                            widget.mBlnFav == true ? "1" : "0");
                                        SyncJSon.user_contact_select_contacts(
                                            2);
                                      });
                                    })
                                : Con_Wid.mIconButton(
                                    icon: Own_Star_Border,
                                    onPressed: () async {
                                      setState(() {
                                        widget.mBlnFav =
                                            widget.mBlnFav ? false : true;
                                        sql_contact_tran.mSetUserWiseUpdateFav(
                                            widget.mStrMobile.toString(),
                                            'user_is_favourite',
                                            widget.mBlnFav == true ? "1" : "0");
                                      });
                                    }),
                          if (_selected_needs_sub_msg.isNotEmpty)
                            Con_Wid.mIconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      RouteTransitions.slideTransition(
                                          MdiMainPage(
                                              selected_needs_sub_msg:
                                                  _selected_needs_sub_msg
                                                      .map((e) => e.id)
                                                      .toList())));
                                  setState(() {
                                    _selected_needs_sub_msg.clear();
                                    selected_needs_sub_msg.clear();
                                    mBoolMsgSelectMode = false;
                                  });
                                },
                                icon: Image.asset(
                                  'assets/images/forward.webp',
                                )),
                          _selected_needs_sub_msg.isEmpty
                              ? PopupMenuButton<PopUpData>(
                                  splashRadius: 20,
                                  icon: Own_More,
                                  onSelected: (PopUpData result) {
                                    {
                                      switch (result) {
                                        case PopUpData.MediaLinksdocs:
                                          final List<Need_Main_Sub_Chat>
                                              imageList = _needs_sub_msg
                                                  .where((element) =>
                                                      element.document_url !=
                                                          "null" &&
                                                      element.msg_type == "2")
                                                  .toList();
                                          final List<Need_Main_Sub_Chat>
                                              videolist = _needs_sub_msg
                                                  .where((element) =>
                                                      element.msg_type == "5")
                                                  .toList();
                                          final List<Need_Main_Sub_Chat>
                                              audiolist = _needs_sub_msg
                                                  .where((element) =>
                                                      element.document_url !=
                                                          "null" &&
                                                      element.msg_type == "3")
                                                  .toList();
                                          final List<Need_Main_Sub_Chat>
                                              doculist = _needs_sub_msg
                                                  .where((element) =>
                                                      element.document_url !=
                                                          "null" &&
                                                      element.msg_type == "4")
                                                  .toList();
                                          Navigator.push(
                                              context,
                                              RouteTransitions.slideTransition(
                                                  MsgMediaList(
                                                      widget.usermastid,
                                                      widget.mStrName,
                                                      widget.usermastid,
                                                      imageList,
                                                      videolist,
                                                      audiolist,
                                                      doculist)));
                                          break;
                                        case PopUpData.Search:
                                          setState(() {
                                            mBoolAppBarNew = true;
                                          });
                                          break;
                                        case PopUpData.Wallpaper:
                                          Navigator.push(
                                              context,
                                              RouteTransitions.slideTransition(
                                                  chat_wallpaper(
                                                      widget.usermastid,
                                                      widget.mStrName)));
                                          break;
                                        case PopUpData.QuickReplies:
                                          Navigator.push(
                                              context,
                                              RouteTransitions.slideTransition(
                                                  const QuickReplies()));
                                          break;
                                        case PopUpData.Block:
                                          Os.isIOS
                                              ? ConfirmBlock(true)
                                              : Cupertino_ConfirmBlock(true);
                                          break;
                                        case PopUpData.ClearChat:
                                          Os.isIOS
                                              ? ConfirmClear()
                                              : Cupertino_ConfirmClear();
                                          break;
                                      }
                                    }
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<PopUpData>>[
                                    const PopupMenuItem<PopUpData>(
                                      height: 30,
                                      value: PopUpData.MediaLinksdocs,
                                      child: Text('Media, links,and docs'),
                                    ),
                                    const PopupMenuItem(
                                      height: 0,
                                      enabled: false,
                                      child: Divider(
                                        color: Con_Main_1,
                                      ),
                                    ),
                                    const PopupMenuItem<PopUpData>(
                                      height: 30,
                                      value: PopUpData.Search,
                                      child: Text('Search'),
                                    ),
                                    const PopupMenuItem(
                                      height: 0,
                                      enabled: false,
                                      child: Divider(
                                        color: Con_Main_1,
                                      ),
                                    ),
                                    const PopupMenuItem<PopUpData>(
                                      height: 30,
                                      value: PopUpData.Wallpaper,
                                      child: Text('Wallpaper'),
                                    ),
                                    const PopupMenuItem(
                                      height: 0,
                                      enabled: false,
                                      child: Divider(
                                        color: Con_Main_1,
                                      ),
                                    ),
                                    const PopupMenuItem<PopUpData>(
                                      height: 30,
                                      value: PopUpData.QuickReplies,
                                      child: Text('Quick replies'),
                                    ),
                                    const PopupMenuItem(
                                      height: 0,
                                      enabled: false,
                                      child: Divider(
                                        color: Con_Main_1,
                                      ),
                                    ),
                                    PopupMenuItem<PopUpData>(
                                      height: 30,
                                      value: PopUpData.Block,
                                      child: Text(widget.mBlnBlock == false
                                          ? 'Block'
                                          : 'Unblock'),
                                    ),
                                    const PopupMenuItem(
                                      height: 0,
                                      enabled: false,
                                      child: Divider(
                                        color: Con_Main_1,
                                      ),
                                    ),
                                    const PopupMenuItem<PopUpData>(
                                      height: 30,
                                      value: PopUpData.ClearChat,
                                      child: Text('Clear chat'),
                                    ),
                                  ],
                                )
                              : PopupMenuButton<PopUpData_Broad>(
                                  splashRadius: 20,
                                  onSelected: (PopUpData_Broad result) {
                                    {
                                      setState(() {
                                        if (Constants_Usermast
                                                .mBoolPopupSelect ==
                                            false) {
                                          Constants_Usermast.mBoolPopupSelect =
                                              true;
                                        } else if (Constants_Usermast
                                                .mBoolPopupSelect ==
                                            true) {
                                          Constants_Usermast.mBoolPopupSelect =
                                              false;
                                        }
                                      });
                                    }
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<PopUpData_Broad>>[
                                    Constants_Usermast.mBoolPopupSelect == true
                                        ? const PopupMenuItem<PopUpData_Broad>(
                                            value: PopUpData_Broad.SelectAll,
                                            child: Text('Select All     '),
                                          )
                                        : const PopupMenuItem<PopUpData_Broad>(
                                            value: PopUpData_Broad.UnselectAll,
                                            child: Text('UnSelect All     '),
                                          ),
                                  ],
                                ),
                        ],
                      )),
                body: Stack(
                  children: [
                    Container(
                      decoration: Con_Wid.mGlbWallpaper(
                          wallpaper, widget.usermastid, isLocal),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(color: getPlatformBrightness()
                              ? Dark_Bio_Scroll
                              : topColor,boxShadow: [BoxShadow(color: Colors.grey.shade300,offset: Offset(2, 2),blurRadius: 8)]),
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            height: 20,
                            width: double.infinity,
                            child: widget.mStrLastBio.length < 60
                                ? Center(
                                    child: Text(
                                    widget.mStrLastBio.replaceAll("\n", ''),
                                    style: const TextStyle(fontSize: 12),
                                  ))
                                : TextScroll(
                                    widget.mStrLastBio.replaceAll("\n", ''),
                                    mode: TextScrollMode.endless,
                                    intervalSpaces: 10,
                                  )),
                        Expanded(child: ChatData()),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: widget.mBlnBlock == false &&
                                      mBlnIsBlockUserMe == false
                                  ? 0.0
                                  : 10.0),
                          child: BlockWidget(),
                        ),
                        widget.mBlnBlock == false &&
                                mBlnIsBlockUserMe == false &&
                                Constants_Usermast.user_chat_bln_quick_reply
                            ? Con_Wid.buildInput_Suggestion(
                                _quick_rep_strm_con,
                                _quick_rep_box,
                                SendMessage: (String Value) {
                                  SendMessage(Value);
                                  _txtcont.clear();
                                  _controller.animateTo(
                                    0.0,
                                    curve: Curves.easeOut,
                                    duration: const Duration(milliseconds: 300),
                                  );
                                  setState(() {
                                    _selected_needs_sub_msg.clear();
                                    selected_needs_sub_msg.clear();
                                    mBoolMsgSelectMode = false;
                                  });
                                },
                              )
                            : Container(),
                        widget.mBlnBlock == false && mBlnIsBlockUserMe == false
                            ? Con_Wid_Box(
                                controller: controllerimage,
                                messageType: MessageType.chat,
                                usermastid: widget.usermastid,
                                serverKey: widget.serverKey.toString(),
                                sender_name: widget.mStrName,
                                onTap: () {
                                  setState(() {
                                    _selected_needs_sub_msg.clear();
                                    selected_needs_sub_msg.clear();
                                    mBoolMsgSelectMode = false;
                                  });
                                },
                                onSendMessage: (String value) {
                                  SendMessage(value);
                                },
                              )
                            : Container(),
                        Container(
                            height: MediaQuery.of(context).viewInsets.bottom),
                      ],
                    ),
                    Positioned(
                      left: MediaQuery.of(context).size.width / 1.12,
                      bottom: (MediaQuery.of(context).size.height / 13) +
                          MediaQuery.of(context).viewInsets.bottom,
                      child: InkWell(
                        onTap: () {
                          _controller.animateTo(
                              _controller.position.minScrollExtent,
                              duration: const Duration(seconds: 1),
                              curve: Curves.linear);
                          setState(() {});
                        },
                        child: AnimatedContainer(
                          height: isnotinbottom ? 30 : 0,
                          width: isnotinbottom ? 30 : 0,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/down.png"),
                              ),
                              color: Con_Main_1,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 3,
                                  offset: Offset(3, 5),
                                ),
                              ]),
                          duration: Duration(milliseconds: 500),
                          child: Count.value == 0
                              ? Container()
                              : Baseline(
                                  baseline: 5,
                                  baselineType: TextBaseline.alphabetic,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                          width: 18,
                                          height: 18,
                                          decoration: const BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle),
                                          child: Center(
                                              child: Text(
                                            Count.value.toString(),
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ))),
                                    ],
                                  )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          : CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                  backgroundColor: App_IconColor,
                  padding: EdgeInsetsDirectional.zero,
                  leading: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.left_chevron,
                        color: Con_white),
                    onPressed: () {
                      Navigator.push(context,
                          RouteTransitions.slideTransition(MdiMainPage()));
                    },
                  ),
                  middle: AppBarChatProfile(
                      mobilenumber: widget.mStrMobile,
                      name: widget.mStrName,
                      usermastid: widget.usermastid,
                      user_profile: widget.mStrProfile,
                      user_bio: widget.mStrLastBio,
                      user_last_is_online: widget.mBlnLastOnline,
                      user_last_login_time: widget.mStrLastLoginTime,
                      user_last_biodate: widget.mStrLastBioDate,
                      user_last_birthdate: widget.mStrLastBirthdate,
                      user_last_final_mobile_number:
                          widget.mStrLastfinalmobilenumber,
                      user_block: widget.mBlnBlock,
                      mBlnIsBlockUserMe: mBlnIsBlockUserMe,
                      imageList: imageList,
                      videolist: videolist,
                      audiolist: audiolist,
                      doculist: doculist)),
              child: Container(
                decoration: Con_Wid.mGlbWallpaper(
                    wallpaper, widget.usermastid, isLocal),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        color: Con_white60,
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        height: 20,
                        width: double.infinity,
                        child: widget.mStrLastBio.length < 60
                            ? Center(
                                child: Material(
                                color: Con_transparent,
                                child: Text(
                                  widget.mStrLastBio.replaceAll("\n", ''),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ))
                            : Material(
                                color: Con_transparent,
                                child: TextScroll(
                                  widget.mStrLastBio.replaceAll("\n", ''),
                                  mode: TextScrollMode.endless,
                                  intervalSpaces: 10,
                                ),
                              )),
                    Expanded(child: ChatData()),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: BlockWidget(),
                    ),
                    widget.mBlnBlock == false && mBlnIsBlockUserMe == false
                        ? Con_Wid.buildInput_Suggestion(
                            _quick_rep_strm_con,
                            _quick_rep_box,
                            SendMessage: (String Value) {
                              SendMessage(Value);
                              _txtcont.clear();
                              _controller.animateTo(
                                0.0,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 300),
                              );
                              setState(() {
                                _selected_needs_sub_msg.clear();
                                selected_needs_sub_msg.clear();
                                mBoolMsgSelectMode = false;
                              });
                            },
                          )
                        : Container(),
                    widget.mBlnBlock == false && mBlnIsBlockUserMe == false
                        ? Con_Wid_Box(
                            controller: controllerimage,
                            messageType: MessageType.chat,
                            usermastid: widget.usermastid,
                            sender_name: widget.mStrName,
                            serverKey: widget.serverKey.toString(),
                            onTap: () {
                              setState(() {
                                _selected_needs_sub_msg.clear();
                                selected_needs_sub_msg.clear();
                                mBoolMsgSelectMode = false;
                              });
                            },
                            onSendMessage: (String value) {
                              SendMessage(value);
                            },
                          )
                        : Container()
                  ],
                ),
              )),
      onWillPop: onwillpop,
    );
  }

  ChatData() {
    final box = Hive.box<Need_Main_Sub_Chat>('Need_Main_Sub_Chat');
    final data = ValueNotifier<List<Need_Main_Sub_Chat>>(box.values.toList());

    return ValueListenableBuilder<List<Need_Main_Sub_Chat>>(
        valueListenable: data,
        builder: (context, box, _) {
          _needs_sub_msg = box;
          _needs_sub_msg = _needs_sub_msg.where((e) =>
                  e.msg_to_user_mast_id.toString() ==
                      widget.usermastid.toString() ||
                  e.msg_from_user_mast_id.toString() ==
                      widget.usermastid.toString())
              .toList();

          if (_needs_sub_msg.isNotEmpty) {
            _needs_sub_msg.sort(
              (b, a) => a.msg_timestamp
                  .replaceAll(')/', '')
                  .replaceAll('/Date(', '')
                  .compareTo(b.msg_timestamp
                      .replaceAll(')/', '')
                      .replaceAll('/Date(', '')),
            );
            lastindex.value = _needs_sub_msg.length;
            if (values) {
              if (_controller.position.pixels > 10.0) {
                isnotinbottom = true;
                Count.value = lastindex.value - latestindex.value;
              } else {
                isnotinbottom = false;
                latestindex.value = lastindex.value;
              }
            }
            return GroupedListView<Need_Main_Sub_Chat, DateTime>(
              physics: const BouncingScrollPhysics(),
              elements: _needs_sub_msg,
              order: GroupedListOrder.DESC,
              controller: _controller,
              reverse: true,
              shrinkWrap: true,
              floatingHeader: true,
              IsDatehide: iscenterdatehide,
              useStickyGroupSeparators: true,
              groupBy: (Need_Main_Sub_Chat e) => DateTime(
                DateFormat("MMM dd yyyy hh:mm a").parse(e.date).year,
                DateFormat("MMM dd yyyy hh:mm a").parse(e.date).month,
                DateFormat("MMM dd yyyy hh:mm a").parse(e.date).day,
              ),
              groupHeaderBuilder: _getGroupSeparator,
              itemBuilder: (context, chat) {
                return ChatBubble().ShowChatBubble(
                  context,
                  chat.is_right,
                  chat.msg_type,
                  chat.msg_content,
                  chat.document_url,
                  chat.msg_audio_name,
                  chat.msg_media_size,
                  chat.date,
                  chat.is_read,
                  chat.is_delivered,
                  chat.center_date,
                  chat.id,
                  chat.msg_to_user_mast_id,
                  "",
                  _searchQuery.text.toString().toLowerCase(),
                  widget.mStrName,
                  chat.msg_blurhash,
                  onSelected: (List<String> value) {
                    setState(() {
                      _selected_needs_sub_msg = _needs_sub_msg
                          .where((e) => value.contains(e.id))
                          .toList();
                      selectpStrmess = chat.is_right;
                      selectedmesstipe = chat.msg_type;
                      selectedimagename = chat.msg_audio_name;
                      selectedurl = chat.document_url;
                      selectedmediasize = chat.msg_media_size;
                    });
                  },
                  SearchSelected:
                      SyncDB.myNotifier.getList(Key: 'Searchfoundid').isNotEmpty
                          ? SyncDB.myNotifier
                              .getList(Key: 'Searchfoundid')[SearchIndex]
                          : '',
                  SearchChange: (value) {

                    List Searchfoundid =
                        SyncDB.myNotifier.getList(Key: 'Searchfoundid');
                    if (_searchQuery.text.toString().isNotEmpty) {
                      if (!Searchfoundid.contains(value)) {
                        Searchfoundid.add(value);
                        SyncDB.myNotifier.updateList(
                            value: Searchfoundid, Key: 'Searchfoundid');
                      }
                    }
                  },
                );
              },
            );
          } else {
            return Container();
          }
        });

  }

  getWallpaper() async {
    var data = await Con_Wid.mReadGlbWallpaper(widget.usermastid);
    wallpaper = data['wallpaper'];
    isLocal = data['isLocal'];
    setState(() {});
  }

  Future<void> _openBox() async {

    _quick_rep_box = await SyncJSon.user_quick_rep_box();
    _quick_rep_strm_con = StreamController<BoxEvent>.broadcast();
    _quick_rep_box.watch().listen((event) => _quick_rep_strm_con.add(event));
    if (!_Sub_chat_strm_con.isClosed) {
      _Sub_chat_box = await SyncJSon.user_sub_chat_Box();
      _needs_sub_msg = _Sub_chat_box.values.toList();
      _Sub_chat_strm_con = StreamController<BoxEvent>.broadcast();
      _Sub_chat_box.watch().listen((event) => _Sub_chat_strm_con.add(event));
    }
  }

  void _scrollListener() {
    setState(() {
      iscenterdatehide = true;
    });
    Future.delayed(const Duration(seconds: 2)).then((value) {
      setState(() {
        iscenterdatehide = false;
      });
    });
  }

  @override
  dispose() {
    super.dispose();
    _controller.dispose();
    timer?.cancel();
    controllerimage.dispose();
    _selected_needs_sub_msg.clear();
    selected_needs_sub_msg.clear();
    mBoolMsgSelectMode = false;

    _Sub_chat_box.close();
    _Sub_chat_strm_con.close();
    _quick_rep_strm_con.close();

  }



  AppBar EnableAppBar(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double yourWidth = width / 6;
    return AppBar(
      titleSpacing: 0,
      leading:
          Con_Wid.mIconButton(
        icon: Own_ArrowBack,
        onPressed: () {
          setState(() {
            isSearching = false;
            _searchQuery.clear();
            mBoolAppBarNew = false;
            SyncDB.myNotifier.updateList(value: [], Key: 'Searchfoundid');
            SearchIndex = 0;
          });
        },
      ),

      title: TextField(
        autofocus: true,
        style: const TextStyle(color: Con_white),
        keyboardType: TextInputType.text,
        controller: _searchQuery,
        onChanged: (value) {
          setState(() {
            _SearchListState();
            isSearching = true;
          });
        },
        decoration: const InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: "Search.."),
      ),
      actions: <Widget>[
        Con_Wid.mIconButton(
            icon: Own_Up,
            onPressed: () {
              setState(() {
                if (SearchIndex <
                    SyncDB.myNotifier.getList(Key: 'Searchfoundid').length -
                        1) {
                  SearchIndex++;
                }
              });
              ScrollQuery();
            }),
        Con_Wid.mIconButton(
            icon: Own_Down,
            onPressed: () {
              setState(() {
                if (SearchIndex > 0) {
                  SearchIndex--;
                }
              });
              ScrollQuery();
            }),
      ],
    );
  }

  ScrollQuery() {
    if (SyncDB.myNotifier.getList(Key: 'Searchfoundid').isNotEmpty) {
      List<Need_Main_Sub_Chat> Filterd = _needs_sub_msg
          .where((e) =>
              e.id.toString() ==
              SyncDB.myNotifier
                  .getList(Key: 'Searchfoundid')[SearchIndex]
                  .toString())
          .toList();
      final index = _needs_sub_msg.indexOf(Filterd[0]);
      _controller.animateTo(
        double.parse(index.toString()) * 10,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

  }

  _SearchListState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          isSearching = true;
          SyncDB.myNotifier.updateList(value: [], Key: 'Searchfoundid');
          SearchIndex = 0;
          setupNeeds_Msg(widget.usermastid);
        });
      } else {
        setState(() {
          isSearching = true;
          setupNeeds_Msg(widget.usermastid);
        });
        ScrollQuery();
      }
    });
  }

  Future<dynamic> setupNeeds_Msg(String pStrRedirectUserid) async {
    List<Need_Main_Sub_Chat> needsmsg = [];
    try {
      needsmsg = await SyncJSon.user_sub_main_chat_select();
    } catch (e) {}
    if (mounted) {
      setState(() {
        _needs_sub_msg = needsmsg;
      });
    }
  }

  Future<bool> onwillpop() {
    _selected_needs_sub_msg.isEmpty
        ? navigate == true
            ? Navigator.pushReplacement(
                context,
                RouteTransitions.slideTransition(widget.isContact ?? false
                    ? const Contacts()
                    : MdiMainPage()))
            : Navigator.pushReplacement(
                context,
                RouteTransitions.slideTransition(widget.isContact ?? false
                    ? const Contacts()
                    : MdiMainPage()))
        : {
            setState(() {
              _selected_needs_sub_msg.clear();
              selected_needs_sub_msg.clear();
              mBoolMsgSelectMode = false;
            })
          };
    return Future.value();
  }

  ConfirmClear() {
    Con_Wid.mConfirmDialog(
        context: context,
        title: "Clear all chat",
        message:
            'Are you sure you want to clear all messages and media from this chat ?',
        onOkPressed: () {
          setState(() {
            sql_sub_messages_tran.Sub_UserWiseClear(
                Constants_Usermast.user_id.toString(),
                int.parse(widget.usermastid.toString()));

            Navigator.pop(context);
          });
        },
        onCancelPressed: () {
          Navigator.pop(context);
        });
  }

  Cupertino_ConfirmClear() {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text(
            "Clear all chat",
          ),
          content: const Text(
              'Are you sure you want to clear all messages and media of from this chat ?'),
          actions: [
            CupertinoButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoButton(
                child: const Text("Ok"),
                onPressed: () {
                  setState(() {
                    sql_sub_messages_tran.Sub_UserWiseClear(
                        Constants_Usermast.user_id.toString(),
                        int.parse(widget.usermastid.toString()));

                    Navigator.pop(context);
                  });
                })
          ],
        );
      },
    );
  }

  ConfirmBlock(bool isblock) async {
    Con_Wid.mConfirmDialog(
        context: context,
        title: isblock ? "Block!" : "Unblock!",
        message:
            'Are you sure you want to ${isblock ? "Block" : "Unblock"} ${widget.mStrName} ?',
        onOkPressed: () {
          if (isblock) {
            setState(() {
              if (widget.mBlnBlock == false) {
                widget.mBlnBlock = true;
              } else {
                widget.mBlnBlock = false;
              }
              sql_contact_tran.mSetUserWiseUpdateFav(
                  widget.mStrMobile.toString(),
                  'user_is_block',
                  widget.mBlnBlock == true ? "1" : "0");
            });
          } else {
            setState(() {
              widget.mBlnBlock = false;
              sql_contact_tran.mSetUserWiseUpdateFav(
                  widget.mStrMobile.toString(), 'user_is_block', "0");
            });
          }
          Navigator.pop(context);
        },
        onCancelPressed: () {
          Navigator.pop(context);
        });
  }

  Cupertino_ConfirmBlock(bool isblock) async {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: isblock
              ? const Text(
                  "Block!",
                )
              : const Text('Unblock!'),
          content: Text(
              'Are you sure you want to ${isblock ? "Block" : "Unblock"} ${widget.mStrName} ?'),
          actions: [
            CupertinoButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoButton(
                child: const Text("Ok"),
                onPressed: () {
                  if (isblock) {
                    setState(() {
                      if (widget.mBlnBlock == false) {
                        widget.mBlnBlock = true;
                      } else {
                        widget.mBlnBlock = false;
                      }
                      sql_contact_tran.mSetUserWiseUpdateFav(
                          widget.mStrMobile.toString(),
                          'user_is_block',
                          widget.mBlnBlock == true ? "1" : "0");
                    });
                  } else {
                    setState(() {
                      widget.mBlnBlock = false;
                      sql_contact_tran.mSetUserWiseUpdateFav(
                          widget.mStrMobile.toString(), 'user_is_block', "0");
                    });
                  }
                  Navigator.pop(context);
                })
          ],
        );
      },
    );
  }

  Widget BlockWidget() {
    if (widget.mBlnBlock) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        child: Column(
          children: [
            RichText(
              textAlign: TextAlign.center,
              softWrap: true,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "You've blocked " +
                        (widget.mStrName == ""
                            ? widget.mStrLastfinalmobilenumber
                            : widget.mStrName.toString()),
                    style: TextStyle(
                        fontSize: 18.0,
                        color: getPlatformBrightness()
                            ? LightTheme_White
                            : Con_black),
                  ),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        ConfirmBlock(false);
                      },
                    text: " Unblock ",
                    style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Con_Main_1),
                  ),
                  TextSpan(
                    text: "and continue chat.",
                    style: TextStyle(
                        fontSize: 18.0,
                        color: getPlatformBrightness()
                            ? LightTheme_White
                            : Con_black),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    } else if (mBlnIsBlockUserMe) {
      return RichText(
        textAlign: TextAlign.center,
        softWrap: true,
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: (widget.mStrName == ""
                      ? widget.mStrLastfinalmobilenumber
                      : widget.mStrName.toString()) +
                  " blocked you",
              style: const TextStyle(fontSize: 18.0, color: Con_black),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  UserWiseBlock() async {
    mBlnIsBlockUserMe =
        await sql_contact_tran.GetUserWiseBlock(widget.usermastid);
  }

  Widget _getGroupSeparator(Need_Main_Sub_Chat e) {
    String pStrDate = e.date.substring(0, 11);
    pStrDate = DateFilter(pStrDate);
    return SizedBox(
      height: 50,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: getPlatformBrightness()
                ? Con_msg_auto_6
                :  ChipColor,
          ),
          child: Material(
            color: Con_transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10.0),
              child: Text(
                pStrDate,
                style: const TextStyle(
                  color: Con_msg_auto_6,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> SendMessage(String Value) async {
    try {
      await sql_sub_messages_tran.Send_Msg(
          sender_name: widget.mStrName,
          msg_content: Value,
          msg_type: "1",
          msg_document_url: '',
          from_id: Constants_Usermast.user_id,
          to_id: widget.usermastid.toString(),
          is_broadcast: "0",
          broadcast_id: '',
          server_key: widget.serverKey.toString());
    } catch (e) {}
    await SyncDB.SyncTable("USER_MSG1", true, widget.usermastid);
    if (_needs_sub_msg.isNotEmpty) {
      _controller.jumpTo(_controller.position.minScrollExtent);
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
    }
    return Future.value(false);
  }
}
