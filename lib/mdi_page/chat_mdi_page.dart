//todo                                                  /*  ॐ નમઃ શિવાય  */
import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../A_FB_Trigger/SharedPref.dart';
import '../../A_FB_Trigger/sql_user_broadcast.dart';
import '../../A_Local_DB/Sync_Database.dart';
import '../../A_Local_DB/Sync_Json.dart';
import '../../A_SQL_Trigger/sql_broadcat.dart';
import '../../A_SQL_Trigger/sql_contact.dart';
import '../../A_SQL_Trigger/sql_devicesession.dart';
import '../../A_SQL_Trigger/sql_main_messages.dart';
import '../../A_SQL_Trigger/sql_sub_messages.dart';
import '../../A_SQL_Trigger/sql_usermast.dart';
import '../../Con_Contacts/Con_Glb_Contacts.dart';
import '../../Con_Contacts/contacts.dart';
import '../../Constant/Con_ChatProfile.dart';
import '../../Constant/Con_Clr.dart';
import '../../Constant/Con_Icons.dart';
import '../../Constant/Con_Usermast.dart';
import '../../Constant/Con_Wid.dart';
import '../../Constant/Constants.dart';
import '../../OSFind.dart';
import '../../Settings/Folders/Folder.dart';
import '../A_FB_Trigger/sql_need_broadcast_sub_msg.dart';
import '../A_FB_Trigger/sql_need_contact.dart';
import '../A_FB_Trigger/sql_need_main_sub_chat.dart';
import '../A_FB_Trigger/sql_need_mainchat.dart';
import '../Constant/Con_Profile_Get.dart';
import '../Settings/Privacy/set_sub_actsession_settings.dart';
import '../Settings/set_sub_main_settings.dart';
import '../main.dart';
import 'A_ChatBubble/ChatBubble.dart';
import 'Broadcast/Con_First_Send_Broadcast.dart';
import 'Message/msg_auto_sender.dart';
import 'Message/msg_sub_contactsdetails.dart';

class MdiMainPage extends StatefulWidget {
  List<String>? selected_needs_sub_msg;
  int? tabindex;

  MdiMainPage({super.key, this.selected_needs_sub_msg, this.tabindex = 0});

  static List<String> mDelete = [];

  @override
  Mdi_Main_Page createState() => Mdi_Main_Page();
}

enum PopUpData {
  Favourite,
  EnaDisFav,
  Markallread,
  Nxtweb,
  Settings,
  AutoSender
}

enum PopUpData_Broad { SelectAll, UnselectAll }

class Mdi_Main_Page extends State<MdiMainPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  List<Need_MainChat> _firstchatlist = [];
  List<Need_Contact> _SecondNeeds_online = [];
  List<Need_Broadcast> _FourthBroadcastOnline = [];
  List<Need_Broadcast_Sub_Msg> _needs_sub_broad = [];
  List<Need_Main_Sub_Chat> _needs_sub_msg = [];
  List<Need_Contact> _ContactList = [];
  List<String> Selected_Forword_Contact = [];

  final TextEditingController _searchQuery = TextEditingController();

  int mIntCurrentIndex = 0, mIntBroadCount = 0;

  bool mBoolAppBarNew = false,
      mBoolIsSearching = false,
      mBoolMsgSelectMode = false,
      mBoolGroupSelectMode = false,
      isSelected = false,
      mBoolBroadSelectMode = false;

  String mStrEnterMoNoValue = "",
      selectpStrmess = "",
      selectedmesstipe = "",
      selectedmediasize = "",
      selectedimagename = "",
      selectedurl = "";

  final ScrollController _controller = ScrollController();
  var _Main_chat_box,
      _Main_chat_Unread_box,
      _Main_bro_box,
      _Main_fav_box,
      _Main_online_box,
      mycolor = Con_white;
  late TabController _tabController;
  late StreamSubscription periodicSub;

  late StreamController<BoxEvent> _main_chat_strm_con =
          StreamController<BoxEvent>(),
      _Unread_chat_strm_con = StreamController<BoxEvent>(),
      _main_bro_strm_con = StreamController<BoxEvent>(),
      _main_fav_strm_con = StreamController<BoxEvent>(),
      _main_online_strm_con = StreamController<BoxEvent>();

  @override
  void initState() {
    super.initState();
    GetToken();
    hasLoginname();
    setState(() {
      logout = false;
    });
    _openbox();
    setState(() {
      navigate = false;
    });
    if (widget.selected_needs_sub_msg != null) {
      _setupNeeds();
    }
    mIntBroadCount = 0;
    setState(() {
      loadApis();
    });
    setState(() {
      _tabController = TabController(
          vsync: this, length: widget.selected_needs_sub_msg == null ? 3 : 2)
        ..addListener(() {
          setState(() {
            if (widget.selected_needs_sub_msg == null) {
              setState(() {
                mIntCurrentIndex = _tabController.index;
              });
              switch (_tabController.index) {
                case 0:
                  setState(() {
                    First_Chat_List();
                  });
                  break;
                case 1:
                  setState(() {
                    Second_Online_List();
                  });
                  break;
                // case 3:
                //   break;
                case 2:
                  setState(() {
                    Fourth_Broadcasts_Api();
                  });
                  break;
              }
            } else {
              switch (_tabController.index) {
                case 0:
                  First_Contact_Forward_List();
                  break;
                case 1:
                  Fourth_Broadcasts_Api();
                  break;
              }
            }
          });
        });
      if (widget.tabindex != null) {
        setState(() {
          _tabController.index = widget.tabindex!;
        });
      }
    });

    periodicSub =
        Stream.periodic(const Duration(seconds: 4)).listen((event) async {
      if (Constants_List.need_contact.isEmpty) {
        SyncDB.SyncTable(Constants.Table_Contacts_user_wise, false);
        SyncDB.SyncTable(Constants.usersubmsg, false);
      }
      bool _blnSession = await sql_devicesession_tran.getCurrentSessionActive();
      if (_blnSession) {
        logoutmethod();
        return;
      }
      SyncDB.SyncTableAuto(true);
    });
  }

  @override
  dispose() {
    super.dispose();
    _Main_chat_box.close();
    _main_chat_strm_con.close();
    _Main_bro_box.close();
    _main_bro_strm_con.close();
    _Unread_chat_strm_con.close();
    List data = widget.selected_needs_sub_msg ?? [];
    if (data.isNotEmpty) {
      // _Main_fav_box.close();
    }
    // _Main_fav_box.close();
    // _main_fav_strm_con.close();
    // _Main_online_box.close();
    // _main_online_strm_con.close();
    _tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  GetToken() async {
    String? deviceKey = await FirebaseMessaging.instance.getToken();
    sql_usermast_tran.mSetUserOtpDetail('', deviceKey: deviceKey ?? '');
  }

  Future<void> logoutmethod() async {
    await sql_devicesession_tran.setLoginSessionDetails(false);
    SharedPref.save_bool('is_login', false);
    SharedPref.save_string('user_id', '');
    SharedPref.clear();
    deleteData().then((value) {
      Constants_List.Constants_List_Clear();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/Splash',
          (_) => false,
        );
      }
    });
  }

  Future<List<Need_Contact>> _setupNeeds() async {
    if (_searchQuery.text.isEmpty) {
      // Constants_List.show_contact = await SyncJSon.user_contact_select(0);
      Constants_List.need_contact =
          (await SyncJSon.user_contact_select_contacts_stream());
      _ContactList = Constants_List.need_contact;
    } else {
      _ContactList = Constants_List.need_contact
          .where((element) =>
              element.name
                  .toLowerCase()
                  .toString()
                  .contains(_searchQuery.text.toLowerCase().toString()) ||
              element.mobile_number
                  .toLowerCase()
                  .toString()
                  .contains(_searchQuery.text.toLowerCase().toString()) ||
              element.user_bio
                  .toLowerCase()
                  .toString()
                  .contains(_searchQuery.text.toLowerCase().toString()))
          .toList();
      if (mounted) {
        setState(() {});
      }
    }
    return _ContactList;
  }

  loadApis() async {
    WidgetsBinding.instance.addObserver(this);
    sql_usermast_tran.SelectUserTable();
    sql_contact_tran.SaveContactDetail();
    SyncJSon.user_contact_select_contacts_stream();
    sql_devicesession_tran.setDeviceSession();
    sql_devicesession_tran.setLoginSessionDetails(true);
    sql_main_messages_tran.UpdateDeliveryDataMain();
    sql_usermast_tran.mSetUserOnlineOffline(true);
  }

  Future<void> _openbox() async {
    _Main_chat_box = await SyncJSon.user_main_chat_box();
    try {
      // if (!_main_chat_strm_con.isClosed) {
      //   _main_chat_strm_con = StreamController<BoxEvent>.broadcast();
      //   _Main_chat_box.watch()
      //       .listen((event) => _main_chat_strm_con.add(event));
      // }
      if (!_main_chat_strm_con.isClosed) {
        _main_chat_strm_con = StreamController<BoxEvent>.broadcast();
        _Main_chat_box?.watch()?.listen((event) {
          if (_main_chat_strm_con.isClosed) return;
          _main_chat_strm_con.add(event);
        });
      }
    } catch (E) {
    }
    _Main_chat_Unread_box = await SyncJSon.user_main_chat_UnreadCount();
    if (!_Unread_chat_strm_con.isClosed) {
      _Unread_chat_strm_con = StreamController<BoxEvent>.broadcast();
      _Main_chat_Unread_box.watch()
          .listen((event) => _Unread_chat_strm_con.add(event));
    }
    _Main_bro_box = await SyncJSon.user_broadcast_select();
    if (!_main_bro_strm_con.isClosed) {
      _main_bro_strm_con = StreamController<BoxEvent>.broadcast();
      _Main_bro_box.watch().listen((event) => _main_bro_strm_con.add(event));
    }
    _Main_fav_box = await SyncJSon.user_contact_select_fav_box();

    setState(() {
      Constants_List.needs_fav = _Main_fav_box.values
          .toList()
          .where((element) =>
              element.user_is_favourite == true &&
              element.user_exist_in_mobile == true &&
              element.user_is_block == false)
          .toList();
    });
    if (!_main_fav_strm_con.isClosed) {
      _main_fav_strm_con = StreamController<BoxEvent>.broadcast();
      _Main_fav_box.watch().listen((event) => _main_fav_strm_con.add(event));
    }
    _Main_online_box = await SyncJSon.user_contact_box();
    if (!_main_online_strm_con.isClosed) {
      _main_online_strm_con = StreamController<BoxEvent>.broadcast();
      _Main_online_box.watch()
          .listen((event) => _main_online_strm_con.add(event));
    }
  }

  Widget AppBarTitle() {
    if (mBoolBroadSelectMode && _FourthBroadcastOnline.isNotEmpty) {
      setState(() {
        mIntBroadCount = 0;
        for (var i = 0; i < _FourthBroadcastOnline.length; i++) {
          mBoolAppBarNew = true;
          mBoolBroadSelectMode = true;
          if (_FourthBroadcastOnline[i].is_selected == true) {
            mIntBroadCount++;
          }
        }
      });
      if (mIntBroadCount > 0) {
        return Text(mIntBroadCount.toString() + " Selected",
            style: TextStyle(
              fontSize: 16,
              color: Con_white,
            ));
      } else {
        return Container();
      }
    }

    if (mBoolMsgSelectMode && _firstchatlist.isNotEmpty) {
      setState(() {
        mIntBroadCount = 0;
        for (var i = 0; i < _firstchatlist.length; i++) {
          mBoolAppBarNew = true;
          mBoolMsgSelectMode = true;
          if (_firstchatlist[i].is_selected == 1) {
            mIntBroadCount++;
          }
        }
      });
      if (mIntBroadCount > 0) {
        return Text(mIntBroadCount.toString() + " Selected",
            style: const TextStyle(
              fontSize: 16,
              color: Con_white,
            ));
      } else {
        return Container();
      }
    }
    return Container();
  }

  _SearchListState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          switch (_tabController.index) {
            case 0:
              First_Chat_Api();
              break;
            case 1:
              Second_Online_Api();
              break;
            case 2:
              Fourth_Broadcasts_Api();
              break;
          }
        });
      } else {
        setState(() {
          mBoolIsSearching = true;
          switch (_tabController.index) {
            case 0:
              First_Chat_Api();
              break;
            case 1:
              Second_Online_Api();
              break;
            case 2:
              Fourth_Broadcasts_Api();
              break;
          }
        });
      }
    });
  }

  Profileget() async {
    String profile = await SharedPref.read_string('profile_pic');
    if (Constants_Usermast.user_profileimage_path != profile) {
      Constants_Usermast.user_profileimage_path = profile;
    }
  }

  int index = 0;

  Future<bool> onBackPress() {
    if (selected_needs_sub_msg.isNotEmpty ||
        mBoolMsgSelectMode ||
        mBoolBroadSelectMode ||
        mBoolIsSearching ||
        mIntBroadCount != 0 ||
        mBoolAppBarNew) {
      setState(() {
        selected_needs_sub_msg.clear();
        _firstchatlist
            .where((e) => e.is_selected == 1)
            .map((e) => e.is_selected = 0);
        mBoolMsgSelectMode = false;
        _FourthBroadcastOnline.where((e) => e.is_selected == true)
            .map((e) => e.is_selected = false);
        mBoolBroadSelectMode = false;
        mBoolAppBarNew = false;
        mBoolIsSearching = false;
        mIntBroadCount = 0;
      });
    } else if (_searchQuery.text.isNotEmpty) {
      setState(() {
        _searchQuery.clear();
      });
    } else if (widget.selected_needs_sub_msg != null) {
      Navigator.pop(context);
      // Navigator.pushReplacement(
      //     context,
      //     RouteTransitions.slideTransition(
      //       sub_contactsdetails(
      //         _firstchatlist[index].uc_contact_id.toString(),
      //         _firstchatlist[index].user_mast_id.toString(),
      //         _firstchatlist[index].disp_name,
      //         _firstchatlist[index].user_profileimage_path,
      //         _firstchatlist[index].user_is_favourite,
      //         _firstchatlist[index].user_bio,
      //         _firstchatlist[index].user_bio_last_datetime,
      //         _firstchatlist[index].user_is_online,
      //         _firstchatlist[index].user_last_login_time,
      //         _firstchatlist[index].user_birthdate,
      //         _firstchatlist[index].user_countrywithmobile,
      //         _firstchatlist[index].user_is_block,
      //         serverKey: _firstchatlist[index].server_key,
      //       ),
      //     ));
    } else {
      SystemNavigator.pop();
      // Navigator.pop(context);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    PopupMenuItem<PopUpData> dividerPopupMenuItem =
        const PopupMenuItem<PopUpData>(
      height: 0,
      enabled: false,
      child: Divider(
        color: Con_Main_1,
      ),
    );
    try {
      return Os.isIOS
          ? DefaultTabController(
              length: widget.selected_needs_sub_msg == null ? 3 : 2,
              child: WillPopScope(
                onWillPop: onBackPress,
                child: Scaffold(
                    resizeToAvoidBottomInset: true,
                    floatingActionButton: widget.selected_needs_sub_msg == null
                        ? FloatingActionButton(
                            backgroundColor: App_Float_Back_Color,
                            child: Own_Float_Addressbook,
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  RouteTransitions.slideTransition(
                                      const Contacts()));
                            })
                        : widget.selected_needs_sub_msg != null &&
                                (Selected_Forword_Contact.isNotEmpty ||
                                    _FourthBroadcastOnline.any(
                                        (e) => e.is_selected == true))
                            ? FloatingActionButton(
                                backgroundColor: App_Float_Back_Color,
                                child: const Icon(Icons.send),
                                onPressed: () {
                                  var msgIds = widget.selected_needs_sub_msg
                                      ?.map((e) => e.trim())
                                      .join(",");
                                  String toids =
                                      Selected_Forword_Contact.join(",");
                                  List broadToIds = [];
                                  _FourthBroadcastOnline.where(
                                          (e) => e.is_selected == true)
                                      .toList()
                                      .forEach((element) {
                                    broadToIds.add(element.id);
                                  });
                                  String brodtoid = broadToIds.join(",");
                                  ForwordMessage(
                                      toids, brodtoid, msgIds.toString());
                                  selected_needs_sub_msg.clear();
                                  for (var element in _FourthBroadcastOnline) {
                                    if (element.is_selected == true) {
                                      element.is_selected = false;
                                    }
                                  }
                                  Navigator.pop(context);
                                  // _firstchatlist = Constants_List.needs_main_chat;
                                  // Navigator.pushReplacement(
                                  //     context,
                                  //     RouteTransitions.slideTransition(
                                  //       sub_contactsdetails(
                                  //         _firstchatlist[index]
                                  //             .uc_contact_id
                                  //             .toString(),
                                  //         _firstchatlist[index]
                                  //             .user_mast_id
                                  //             .toString(),
                                  //         _firstchatlist[index].disp_name,
                                  //         _firstchatlist[index]
                                  //             .user_profileimage_path,
                                  //         _firstchatlist[index].user_is_favourite,
                                  //         _firstchatlist[index].user_bio,
                                  //         _firstchatlist[index]
                                  //             .user_bio_last_datetime,
                                  //         _firstchatlist[index].user_is_online,
                                  //         _firstchatlist[index]
                                  //             .user_last_login_time,
                                  //         _firstchatlist[index].user_birthdate,
                                  //         _firstchatlist[index]
                                  //             .user_countrywithmobile,
                                  //         _firstchatlist[index].user_is_block,
                                  //         serverKey:
                                  //             _firstchatlist[index].server_key,
                                  //       ),
                                  //     ));
                                }, //icon inside button
                              )
                            : null,
                    appBar: mBoolIsSearching == true
                        ? SearchAppBar(context)
                        : (mBoolAppBarNew
                            ? SelectedRecordAppBar(context)
                            : widget.selected_needs_sub_msg == null
                                ? AppBar(
                                    automaticallyImplyLeading: false,
                                    leading: Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: Stack(
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  if (Constants_Usermast
                                                          .user_id !=
                                                      "") {
                                                    Navigator.push(
                                                        context,
                                                        RouteTransitions
                                                            .slideTransition(
                                                                const sub_main_settings()));
                                                  }
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 3.0, top: 0.0),
                                                  child: FutureBuilder(builder:
                                                      (context, snapshot) {
                                                    return Con_profile_get(
                                                      pStrImageUrl:
                                                          Constants_Usermast
                                                              .user_profileimage_path,
                                                      Size: 60,
                                                    );
                                                  }),
                                                ),
                                              ),
                                              Positioned(
                                                right: 0,
                                                top: 38,
                                                child: Container(
                                                  width: (13),
                                                  height: (13),
                                                  decoration: BoxDecoration(
                                                    color: Con_Clr_App_5,
                                                    border: Border.all(
                                                      width: (2),
                                                      color: Con_Clr_App_6,
                                                    ),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.elliptical(
                                                                48,
                                                                48.02000045776367)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Con_Wid.mAppBar('NxtApp'),
                                    actions: [
                                      Con_Wid.mIconButton(
                                        icon: Own_Search,
                                        onPressed: () {
                                          setState(() {
                                            mBoolIsSearching = true;
                                            mBoolAppBarNew = false;
                                          });
                                        },
                                      ),
                                      PopupMenuButton(
                                        elevation: 3,
                                        splashRadius: 10,
                                        onSelected: (PopUpData result) async {
                                          {
                                            switch (result) {
                                              case PopUpData.Favourite:
                                                navigatenew(context);
                                                break;
                                              case PopUpData.EnaDisFav:
                                                Constants_Usermast
                                                        .user_chat_bln_favourite_contacts =
                                                    !Constants_Usermast
                                                        .user_chat_bln_favourite_contacts;
                                                setState(() {
                                                  SharedPref.save_bool(
                                                      'user_chat_bln_favourite_contacts',
                                                      Constants_Usermast
                                                          .user_chat_bln_favourite_contacts);
                                                });
                                                break;
                                              case PopUpData.AutoSender:
                                                Navigator.push(
                                                    context,
                                                    RouteTransitions
                                                        .slideTransition(
                                                            Auto_Sender()));
                                                break;
                                              case PopUpData.Markallread:
                                                for (var e in _firstchatlist) {
                                                  sql_main_messages_tran
                                                      .ReadUserWiseMsg(
                                                          e.user_mast_id
                                                              .toString(),
                                                          Constants_Usermast
                                                              .user_id);
                                                }
                                                break;
                                              case PopUpData.Settings:
                                                Navigator.push(
                                                    context,
                                                    RouteTransitions
                                                        .slideTransition(
                                                            const sub_main_settings()));
                                                break;
                                              case PopUpData.Nxtweb:
                                                Navigator.push(
                                                    context,
                                                    RouteTransitions
                                                        .slideTransition(
                                                            sub_actsession_settings(
                                                      isweb: true,
                                                    )));
                                                break;
                                            }
                                          }
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry<PopUpData>>[
                                          const PopupMenuItem<PopUpData>(
                                            height: 30,
                                            value: PopUpData.Favourite,
                                            child: Text('Show Favourites List'),
                                          ),
                                          dividerPopupMenuItem,
                                          PopupMenuItem<PopUpData>(
                                            height: 30,
                                            value: PopUpData.EnaDisFav,
                                            child: Text(Constants_Usermast
                                                        .user_chat_bln_favourite_contacts ==
                                                    false
                                                ? 'Enable Favourites List '
                                                : 'Disable Favourites List '),
                                          ),
                                          dividerPopupMenuItem,
                                          const PopupMenuItem<PopUpData>(
                                            height: 30,
                                            value: PopUpData.AutoSender,
                                            child: Text('Auto Sender'),
                                          ),
                                          dividerPopupMenuItem,
                                          const PopupMenuItem<PopUpData>(
                                            height: 30,
                                            value: PopUpData.Nxtweb,
                                            child: Text('Nxt Web'),
                                          ),
                                          dividerPopupMenuItem,
                                          const PopupMenuItem<PopUpData>(
                                            height: 30,
                                            value: PopUpData.Markallread,
                                            child: Text('Mark all as Read'),
                                          ),
                                          dividerPopupMenuItem,
                                          const PopupMenuItem<PopUpData>(
                                            height: 30,
                                            value: PopUpData.Settings,
                                            child: Text('Settings'),
                                          ),
                                        ],
                                      ),
                                    ],
                                    bottom: bottom_bar(),
                                  )
                                : AppBar(
                                    title: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: mIntBroadCount == 0
                                          ? const Text("Forward to...")
                                          : Text("$mIntBroadCount Selected"),
                                    ),
                                    leading: Con_Wid.mIconButton(
                                      icon: Own_ArrowBack,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    actions: [
                                      Con_Wid.mIconButton(
                                          onPressed: () {}, icon: Own_Search)
                                    ],
                                    bottom: bottom_bar(),
                                  )),
                    body: TabBarView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                        if (widget.selected_needs_sub_msg == null)
                          First_Chat_List()
                        else
                          First_Contact_Forward_List(),
                        if (widget.selected_needs_sub_msg == null)
                          Second_Online_List(),
                        Fourth_Broadcast_List(),
                      ],
                    )),
              ),
            )
          : CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                  trailing: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(
                        CupertinoIcons.app_badge,
                        color: Con_white,
                      ),
                      onPressed: () => showCupertinoModalPopup(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState1) {
                                  return CupertinoActionSheet(
                                    cancelButton: CupertinoActionSheetAction(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                            color: Con_redAccent,
                                          ),
                                        )),
                                    actions: [
                                      CupertinoActionSheetAction(
                                          onPressed: () {
                                            navigatenew(context);
                                          },
                                          child: const Text(
                                              "Show Favourites List")),
                                      CupertinoActionSheetAction(
                                        onPressed: () {
                                          Constants_Usermast
                                                  .user_chat_bln_favourite_contacts =
                                              !Constants_Usermast
                                                  .user_chat_bln_favourite_contacts;
                                          setState(() {
                                            setState1(() {
                                              SharedPref.save_bool(
                                                  'user_chat_bln_favourite_contacts',
                                                  Constants_Usermast
                                                      .user_chat_bln_favourite_contacts);
                                            });
                                          });
                                        },
                                        child: Text(Constants_Usermast
                                                    .user_chat_bln_favourite_contacts ==
                                                false
                                            ? 'Enable Favourites List '
                                            : 'Disable Favourites List '),
                                      ),
                                      CupertinoActionSheetAction(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                RouteTransitions
                                                    .slideTransition(
                                                        Auto_Sender()));
                                          },
                                          child: const Text("Auto Sender")),
                                      CupertinoActionSheetAction(
                                          onPressed: () {
                                            for (var e in _firstchatlist) {
                                              sql_main_messages_tran
                                                  .ReadUserWiseMsg(
                                                      e.user_mast_id.toString(),
                                                      Constants_Usermast
                                                          .user_id);
                                            }
                                          },
                                          child:
                                              const Text("Mark all as Read")),
                                      CupertinoActionSheetAction(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                RouteTransitions.slideTransition(
                                                    const sub_main_settings()));
                                          },
                                          child: const Text("Setting")),
                                    ],
                                  );
                                },
                              );
                            },
                          )),
                  leading: Row(
                    children: [
                      SizedBox(
                        width: 45,
                        height: 45,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (Constants_Usermast.user_id != "") {
                                  Navigator.push(
                                      context,
                                      RouteTransitions.slideTransition(
                                          const sub_main_settings()));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10.0,
                                ),
                                child:
                                    FutureBuilder(builder: (context, snapshot) {
                                  return Con_profile_get(
                                    pStrImageUrl: Constants_Usermast
                                        .user_profileimage_path,
                                    Size: 50,
                                  );
                                }),
                              ),
                            ),
                            Positioned(
                              right: 2,
                              top: 30,
                              child: Container(
                                width: (13),
                                height: (13),
                                decoration: BoxDecoration(
                                  color: Con_Clr_App_5,
                                  border: Border.all(
                                    width: (2),
                                    color: Con_Clr_App_6,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.elliptical(48, 48.02000045776367)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Material(
                          color: Con_transparent,
                          child: Text(
                            Constants_Usermast.user_login_name,
                            style: TextStyle(
                              color: Con_white,
                            ),
                          )),
                    ],
                  ),
                  padding: EdgeInsetsDirectional.zero,
                  backgroundColor: App_Float_Back_Color),
              child: Container(
                child: Stack(alignment: Alignment.bottomRight, children: [
                  CupertinoTabScaffold(
                    tabBar: CupertinoTabBar(
                        activeColor: Con_white,
                        inactiveColor: Con_grey,
                        backgroundColor: App_Float_Back_Color,
                        items: const [
                          BottomNavigationBarItem(
                              label: "Chat",
                              icon: Icon(CupertinoIcons.chat_bubble_2_fill)),
                          BottomNavigationBarItem(
                              label: "Online",
                              icon: Icon(CupertinoIcons.sun_max_fill)),
                          BottomNavigationBarItem(
                              label: "Broadcasts",
                              icon: Icon(CupertinoIcons.chat_bubble_2_fill))
                        ]),
                    tabBuilder: (context, index) {
                      return CupertinoTabView(
                        builder: (context) {
                          switch (index) {
                            case 0:
                              return SafeArea(
                                  child: Cupertino_First_Chat_List());
                            case 1:
                              return SafeArea(
                                  child: Cupertino_Second_Online_List());
                            case 2:
                              return SafeArea(
                                  child: Cupertino_Fourth_Broadcast_List());
                          }
                          return Container();
                        },
                      );
                    },
                  ),
                  widget.selected_needs_sub_msg == null
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 60, right: 10),
                          child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              borderRadius: BorderRadius.circular(30),
                              color: App_Float_Back_Color,
                              child: const Icon(CupertinoIcons.text_bubble),
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    RouteTransitions.slideTransition(
                                        const Contacts()));
                              }),
                        )
                      : CupertinoButton(
                          padding: EdgeInsets.zero,
                          color: App_Float_Back_Color,
                          child: const Icon(Icons.send),
                          onPressed: () {
                            var msgIds = widget.selected_needs_sub_msg
                                ?.map((e) => e.trim())
                                .join(",");
                            List ToIds = [];
                            _firstchatlist
                                .where((e) => e.is_selected == 1)
                                .toList()
                                .forEach((element) {
                              ToIds.add(element.user_mast_id);
                            });
                            String toids = ToIds.join(",");
                            List broadToIds = [];
                            _FourthBroadcastOnline.where(
                                    (e) => e.is_selected == true)
                                .toList()
                                .forEach((element) {
                              broadToIds.add(element.id);
                            });
                            String brodtoid = broadToIds.join(",");
                            ForwordMessage(toids, brodtoid, msgIds.toString());
                            selected_needs_sub_msg.clear();
                            for (var element in _FourthBroadcastOnline) {
                              if (element.is_selected == true) {
                                element.is_selected = false;
                              }
                            }
                            Navigator.pop(context);
                          }, //icon inside button
                        ),
                ]),
              ));
    } catch (e) {
      return Scaffold(
        body: ListView(children: [
          Text('$e'),
        ]),
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        sql_usermast_tran.mSetUserOnlineOffline(false);
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        WidgetsFlutterBinding.ensureInitialized();
        sql_usermast_tran.mSetUserOnlineOffline(true);
        break;
      case AppLifecycleState.detached:
        sql_usermast_tran.mSetUserOnlineOffline(false);
        break;
    }
  }

  AppBar SearchAppBar(BuildContext context) {
    return AppBar(
      title: TextField(
        autofocus: true,
        style: TextStyle(
          color: Con_white,
        ),
        keyboardType: TextInputType.text,
        controller: _searchQuery,
        onChanged: (value) {
          setState(() {
            _SearchListState();
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
      leading: Con_Wid.mIconButton(
        icon: Own_ArrowBack,
        onPressed: () {
          setState(() {
            mBoolIsSearching = false;
            _searchQuery.text = "";
            First_Chat_Api();
            Second_Online_Api();
            Fourth_Broadcasts_Api();
          });
        },
      ),
      actions: [
        Con_Wid.mIconButton(
            icon: Own_Delete_Search,
            onPressed: () {
              setState(() {
                _searchQuery.text = "";
                First_Chat_Api();
                Second_Online_Api();
                Fourth_Broadcasts_Api();
                mBoolIsSearching = false;
              });
            }),
      ],
      bottom: bottom_bar(),
    );
  }

  AppBar SelectedRecordAppBar(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double yourWidth = width / 6;
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: AppBarTitle(),
      ),
      leading: Con_Wid.mIconButton(
        icon: Own_ArrowBack,
        onPressed: () {
          setState(() {
            mBoolAppBarNew = false;
            mIntBroadCount = 0;
            if (mBoolBroadSelectMode) {
              for (var i = 0; i < _FourthBroadcastOnline.length; i++) {
                _FourthBroadcastOnline[_FourthBroadcastOnline.indexWhere(
                        (element) =>
                            element.id == _FourthBroadcastOnline[i].id)]
                    .is_selected = false;
              }
              mBoolBroadSelectMode = false;
            }
            if (mBoolMsgSelectMode) {
              for (var i = 0; i < _firstchatlist.length; i++) {
                _firstchatlist[_firstchatlist
                        .indexWhere((e) => e.id == _firstchatlist[i].id)]
                    .is_selected = 0;
              }
              mBoolMsgSelectMode = false;
            }
          });
        },
      ),
      actions: [
        Con_Wid.mIconButton(
            icon: Own_Delete_White,
            onPressed: () {
              setState(() {
                mBoolAppBarNew = false;
                mIntBroadCount = 0;
                if (mBoolBroadSelectMode) //Broadcast
                {
                  if (_FourthBroadcastOnline.isNotEmpty) {
                    var ids = _FourthBroadcastOnline.where(
                            (element) => element.is_selected == true)
                        .map((e) => e.id.toString())
                        .join(",");
                    _FourthBroadcastOnline.removeWhere(
                        (e) => e.is_selected == true);
                    sql_broadcast_tran.main_broadcast_delete_clear(
                        ids.toString(), "DELETE");
                  }
                  mBoolBroadSelectMode = false;
                }
                if (mBoolMsgSelectMode) //Chats
                {
                  if (_firstchatlist.isNotEmpty) {
                    _firstchatlist.where((e) => e.is_selected == 1).forEach(
                          (e) => sql_sub_messages_tran.Sub_UserWiseDelete(
                            e.msg_from_user_mast_id.toString(),
                            e.msg_to_user_mast_id.toString(),
                            false,
                          ),
                        );
                    _firstchatlist.where((e) => e.is_selected == 1).forEach(
                        (e) => sql_sub_messages_tran.Sub_UserWiseClear(
                            e.msg_from_user_mast_id.toString(),
                            e.msg_to_user_mast_id));

                    _firstchatlist
                        .removeWhere((element) => element.is_selected == 1);
                  }
                }
                mBoolMsgSelectMode = false;
              });
            }),
        Con_Wid.mIconButton(
            onPressed: () {
              setState(() {
                mBoolAppBarNew = false;
                mIntBroadCount = 0;
                mIntBroadCount = 0;
                if (mBoolBroadSelectMode) {
                  if (_FourthBroadcastOnline.isNotEmpty) {
                    var ids = _FourthBroadcastOnline.where(
                            (element) => element.is_selected == true)
                        .map((e) => e.id.toString())
                        .join(",");
                    sql_broadcast_tran.main_broadcast_delete_clear(
                        ids.toString(), "CLEAR");
                  }
                  mBoolBroadSelectMode = false;
                }
                if (mBoolMsgSelectMode) //Chats
                {
                  if (_firstchatlist.isNotEmpty) {
                    _firstchatlist.where((e) => e.is_selected == 1).forEach(
                        (e) => sql_sub_messages_tran.Sub_UserWiseClear(
                            e.msg_from_user_mast_id.toString(),
                            e.msg_to_user_mast_id));
                    setState(() {});

                    setState(() {
                      _firstchatlist.removeWhere((e) => e.is_selected == 1);
                    });
                  }
                }
                mBoolMsgSelectMode = false;
              });
            },
            icon: Chat_Clear),
        PopupMenuButton<PopUpData_Broad>(
          splashRadius: 20,
          onSelected: (PopUpData_Broad result) {
            {
              setState(() {
                if (Constants_Usermast.mBoolPopupSelect == false) {
                  Constants_Usermast.mBoolPopupSelect = true;
                } else if (Constants_Usermast.mBoolPopupSelect == true) {
                  Constants_Usermast.mBoolPopupSelect = false;
                }
              });
              switch (result) {
                case PopUpData_Broad.SelectAll:
                  if (mBoolBroadSelectMode) {
                    setState(() {
                      for (var i = 0; i < _FourthBroadcastOnline.length; i++) {
                        mBoolAppBarNew = true;
                        mBoolBroadSelectMode = true;
                        _FourthBroadcastOnline[i].is_selected = true;
                      }
                      Constants_Usermast.mBoolPopupSelect !=
                          Constants_Usermast.mBoolPopupSelect;
                    });
                  }
                  if (mBoolMsgSelectMode) {
                    setState(() {
                      for (var i = 0; i < _firstchatlist.length; i++) {
                        mBoolAppBarNew = true;
                        mBoolMsgSelectMode = true;
                        _firstchatlist[i].is_selected = 1;
                      }
                    });
                  }
                  break;
                case PopUpData_Broad.UnselectAll:
                  if (mBoolBroadSelectMode) {
                    setState(() {
                      for (var i = 0; i < _FourthBroadcastOnline.length; i++) {
                        mBoolAppBarNew = false;
                        mBoolBroadSelectMode = false;
                        _FourthBroadcastOnline[i].is_selected = false;
                      }
                      Constants_Usermast.mBoolPopupSelect !=
                          Constants_Usermast.mBoolPopupSelect;
                    });
                  }
                  if (mBoolMsgSelectMode) {
                    setState(() {
                      for (var i = 0; i < _firstchatlist.length; i++) {
                        mBoolAppBarNew = false;
                        mBoolMsgSelectMode = false;
                        _firstchatlist[i].is_selected = 0;
                      }
                    });
                  }
                  break;
              }
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
        )
      ],
      bottom: PreferredSize(
          preferredSize: Size(yourWidth, 50),
          child: TabBar(
              unselectedLabelColor: Con_white,
              labelPadding: EdgeInsets.symmetric(
                  horizontal: (width - (yourWidth * 3)) / 8),
              controller: _tabController,
              isScrollable: true,
              indicatorColor: tab_indicator_color,
              splashBorderRadius: BorderRadius.circular(20),
              tabs: [
                Tab(
                  child: Row(
                    children: [
                      const Text('CHATS'),
                      if (_firstchatlist.isNotEmpty)
                        _firstchatlist[0].msg_unread_count_total > 0
                            ? const SizedBox(width: 6)
                            : const SizedBox(
                                width: 0,
                              ),
                      if (_firstchatlist.isNotEmpty)
                        _firstchatlist[0].msg_unread_count_total > 0
                            ? Container(
                                height: 20,
                                width: 20,
                                child: Center(
                                  child: Text(
                                      _firstchatlist[0]
                                          .msg_unread_count_total
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Con_Main_1.withOpacity(0.70))),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Con_white,
                                ),
                              )
                            : const SizedBox(),
                    ],
                  ),
                ),
                if (widget.selected_needs_sub_msg == null)
                  const Tab(text: 'ONLINE'),
                const Tab(text: 'BROADCASTS'),
              ])),
    );
  }

   bottom_bar() {
    return TabBar(
        labelStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 15.0),
        unselectedLabelColor: Con_white,
        controller: _tabController,
        indicatorColor: tab_indicator_color,
        splashFactory: NoSplash.splashFactory,
        tabs: [
          Tab(
            child: StreamBuilder<BoxEvent>(
                stream: _Unread_chat_strm_con.stream,
                builder: (context, snapshot) {
                  List<Need_MainChat> _Unreadlist = _Main_chat_Unread_box
                          ?.values
                          ?.toList()
                          ?.cast<Need_MainChat>() ??
                      [];
                  if (_Unreadlist.isEmpty) {
                    _Unreadlist = Constants_List.needs_main_chat;
                  }
                  int msg_unread_count = 0;
                  _Unreadlist.map((item) {
                    msg_unread_count += item.msg_unread_count;
                  }).toList();
                  return Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Chats'),
                      if (_Unreadlist.isNotEmpty)
                        msg_unread_count > 0
                            ? const SizedBox(
                                width: 6,
                              )
                            : const SizedBox(
                                width: 0,
                              ),
                      if (_Unreadlist.isNotEmpty)
                        msg_unread_count > 0
                            ? Container(
                                height: 22,
                                width: msg_unread_count.toString().length > 2
                                    ? msg_unread_count.toString().length > 3
                                        ? 40
                                        : 30
                                    : 22,
                                child: Center(
                                  child: Text(msg_unread_count.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color:
                                              Con_Main_1.withOpacity(0.70))),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Con_white,
                                ),
                              )
                            : const SizedBox(),
                    ],
                  );
                }),
          ),
          if (widget.selected_needs_sub_msg == null)
            const Tab(child: Text('Online',textAlign: TextAlign.center,)),
          const Tab(child: Text('Broadcasts',textAlign: TextAlign.center)),

        ]);
  }

  Future<List<Need_MainChat>> First_Chat_Api() async {
    if (mIntCurrentIndex != 0) {
      return _firstchatlist;
    }
    if (_searchQuery.text.isEmpty) {
      mBoolIsSearching = false;
      if (!mBoolMsgSelectMode) {
        // _FirstChatList = await SyncJSon.user_main_chat_select();
        if (mounted) {
          setState(() {});
        }
      }
    } else {
      setState(() {
        _firstchatlist = Constants_List.needs_main_chat
            .where((element) =>
                element.disp_name
                    .toLowerCase()
                    .toString()
                    .contains(_searchQuery.text.toLowerCase().toString()) ||
                element.user_countrywithmobile
                    .toLowerCase()
                    .toString()
                    .contains(_searchQuery.text.toLowerCase().toString()) ||
                element.msg_content
                    .toLowerCase()
                    .toString()
                    .contains(_searchQuery.text.toLowerCase().toString()))
            .toList();
      });
    }
    if (_firstchatlist.isEmpty) {
      return _firstchatlist;
    } else {
      return _firstchatlist;
    }
  }

  Widget First_Chat_List() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              StreamBuilder<BoxEvent>(
                stream: _main_fav_strm_con.stream,
                builder: (context, snapshot) {
                  return Constants_List.needs_fav.isNotEmpty &&
                          Constants_Usermast.user_chat_bln_favourite_contacts
                      ? Container(
                          // color: const Con_Clr_App_4,
                          color: getPlatformBrightness()
                              ? Con_Clr_App_3
                              : Con_Clr_App_4,
                          child: Container(
                            decoration: BoxDecoration(
                               border: Border(bottom: BorderSide(color: Color(
                                   0x80DAEAEE),width: 2)),
                                // color: Chat_ReadColors,
                                color: getPlatformBrightness()
                                    ? DarkTheme_Main
                                    : LightTheme_White,
                                ),
                            // child: Container(
                            // color: Con_black,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        'Favourite Contacts',style: TextStyle(fontSize: 14,color: App_Float_Back_Color,fontWeight: FontWeight.bold,fontFamily: "Inter"),
                                      ),
                                    ),
                                    PopupMenuButton<String>(

                                      splashRadius: 20,
                                      icon: const Icon(
                                        Icons.more_horiz,
                                        color: App_Float_Back_Color
                                      ),
                                      onSelected: (String result) {
                                        switch (result) {
                                          case "Refresh":
                                            setState(() {
                                              SyncJSon
                                                  .user_contact_select_contacts(
                                                      2);
                                            });
                                            break;
                                          case "Remove List":
                                            if (mounted) {
                                              setState(() {
                                                Constants_Usermast
                                                        .user_chat_bln_favourite_contacts =
                                                    false;
                                                SharedPref.save_bool(
                                                    'user_chat_bln_favourite_contacts',
                                                    false);
                                              });
                                            }
                                            break;
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          height: 30,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(),
                                              Text(
                                                "Refresh",
                                              ),
                                            ],
                                          ),
                                          value: "Refresh",
                                        ),
                                        PopupMenuItem(
                                          height: 0,
                                          enabled: false,
                                          child: Divider(
                                            color: Con_Main_1,
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          height: 30,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(),
                                              Text(
                                                "Remove List",
                                              ),
                                            ],
                                          ),
                                          value: "Remove List",
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                    height: 90.0,
                                    child: ReorderableListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          Constants_List.needs_fav.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        Need_Contact need =
                                            Constants_List.needs_fav[index];
                                        return GestureDetector(
                                          key: ValueKey(index),
                                          onTap: () => Navigator.pushReplacement(
                                              context,
                                              RouteTransitions.slideTransition(
                                                  sub_contactsdetails(
                                                      need.id.toString(),
                                                      need.user_mast_id
                                                          .toString(),
                                                      need.name.toString(),
                                                      need.user_profileimage_path
                                                          .toString(),
                                                      need.user_is_favourite,
                                                      need.user_bio,
                                                      need.user_bio_last_datetime,
                                                      need.user_is_online,
                                                      need.user_last_login_time,
                                                      need.user_birthdate,
                                                      need.user_countrywithmobile,
                                                      need.user_is_block))),
                                          child: Padding(
                                            padding: index==0  ?EdgeInsets.only(left: 10,right: 4):  EdgeInsets.symmetric(horizontal: 3),
                                            child: Column(
                                              children: [
                                                Con_profile_get(
                                                  pStrImageUrl: need
                                                          .user_profileimage_path
                                                          .isEmpty
                                                      ? ''
                                                      : need
                                                          .user_profileimage_path,
                                                  Size: 53,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 3.0),
                                                  child: SizedBox(
                                                    width: 55,
                                                    child: Align(
                                                        child: Text(
                                                      need.name.length > 8
                                                          ? need.name.substring(
                                                                  0, 5) +
                                                              '...'
                                                          : need.name,
                                                      textAlign: TextAlign.center,
                                                      style:
                                                          TextStyle(fontSize: 11),
                                                    )),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      onReorder: (int oldIndex, int newIndex) =>
                                          setState(() {
                                        if (oldIndex < newIndex) {
                                          newIndex -= 1;
                                        }
                                        final Need_Contact item = Constants_List
                                            .needs_fav
                                            .removeAt(oldIndex);
                                        Constants_List.needs_fav
                                            .insert(newIndex, item);
                                      }),
                                    )),
                              ],
                            ),
                            // )
                          ))
                      : Container();
                },
              ),
              Expanded(
                child: StreamBuilder<BoxEvent>(
                    stream: _main_chat_strm_con.stream,
                    // stream: SyncJSon.user_main_chat_stream(),
                    builder: (context, snapshot) {
                      if (mBoolIsSearching == false) {
                        if (!mBoolMsgSelectMode && mIntBroadCount == 0) {
                          _firstchatlist = _Main_chat_box?.values
                                  ?.toList()
                                  ?.cast<Need_MainChat>() ??
                              [];
                        }
                        if (_firstchatlist.isEmpty) {
                          _firstchatlist = Constants_List.needs_main_chat;
                        } else {
                          Constants_List.needs_main_chat = _firstchatlist;
                        }
                      }
                      if (_firstchatlist.isEmpty) {
                        return Container();
                      }
                      if (_firstchatlist.isNotEmpty) {
                        for (int i = 0; i < _firstchatlist.length; i++) {
                          if (!MdiMainPage.mDelete.contains(
                              _firstchatlist[i].user_mast_id.toString())) {
                            MdiMainPage.mDelete
                                .add(_firstchatlist[i].user_mast_id.toString());
                          }
                        }
                      }
                      if (_firstchatlist[index].inserted_time != null &&
                          _firstchatlist[index]
                                  .inserted_time
                                  .toString()
                                  .toLowerCase() !=
                              "false") {
                        _firstchatlist.sort(
                          (b, a) => a.inserted_time.compareTo(b.inserted_time),
                        );
                      }
                      return _firstchatlist.isNotEmpty
                          ? Container(
                              decoration: BoxDecoration(
                                  boxShadow: getPlatformBrightness()
                                      ? [
                                          const BoxShadow(
                                            color: Dark_Divider_Shadow,
                                            blurStyle: BlurStyle.outer,
                                            blurRadius: 2,
                                          ),
                                          // BoxShadow(offset: Offset(0, -5)),
                                        ]
                                      : []),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _firstchatlist.length + 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index != _firstchatlist.length && _firstchatlist[index].user_countrywithmobile!="") {
                                      return ListTile(
                                          selected: _firstchatlist[index]
                                                      .is_selected ==
                                                  0
                                              ? false
                                              : true,
                                          onLongPress: () {
                                            setState(
                                              () {
                                                setState(
                                                  () {
                                                    _FourthBroadcastOnline
                                                        .where((e) =>
                                                            e.is_selected ==
                                                            true).map((e) =>
                                                        e.is_selected = false);
                                                    mBoolBroadSelectMode =
                                                        false;
                                                    _firstchatlist[index]
                                                        .is_selected = 1;
                                                    mBoolMsgSelectMode = true;
                                                    mBoolAppBarNew = true;
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          onTap: () {
                                            setState(
                                              () {
                                                if (mBoolMsgSelectMode) {
                                                  if (_firstchatlist[index]
                                                          .is_selected ==
                                                      0) {
                                                    _firstchatlist[index]
                                                        .is_selected = 1;
                                                  } else if (_firstchatlist[
                                                              index]
                                                          .is_selected ==
                                                      1) {
                                                    _firstchatlist[index]
                                                        .is_selected = 0;
                                                  }
                                                  mIntBroadCount =
                                                      _firstchatlist
                                                          .where((e) =>
                                                              e.is_selected ==
                                                              1)
                                                          .length;
                                                  setState(() {});
                                                  if (mIntBroadCount == 0) {
                                                    mBoolMsgSelectMode = false;
                                                    mBoolAppBarNew = false;
                                                  }
                                                } else {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      RouteTransitions
                                                          .slideTransition(
                                                        sub_contactsdetails(
                                                          _firstchatlist[index]
                                                              .uc_contact_id
                                                              .toString(),
                                                          _firstchatlist[index]
                                                              .user_mast_id
                                                              .toString(),
                                                          _firstchatlist[index]
                                                              .disp_name
                                                              .toString(),
                                                          _firstchatlist[index]
                                                              .user_profileimage_path,
                                                          _firstchatlist[index]
                                                              .user_is_favourite,
                                                          _firstchatlist[index]
                                                              .user_bio,
                                                          _firstchatlist[index]
                                                              .user_bio_last_datetime,
                                                          _firstchatlist[index]
                                                              .user_is_online,
                                                          _firstchatlist[index]
                                                              .user_last_login_time,
                                                          _firstchatlist[index]
                                                              .user_birthdate,
                                                          _firstchatlist[index]
                                                              .user_countrywithmobile,
                                                          _firstchatlist[index]
                                                              .user_is_block,
                                                          serverKey:
                                                              _firstchatlist[
                                                                      index]
                                                                  .server_key,
                                                        ),
                                                      ));
                                                }
                                              },
                                            );
                                          },
                                          leading: _firstchatlist[index]
                                                      .is_selected ==
                                                  1
                                              ? Con_profile_get(
                                                  pStrImageUrl: "",
                                                  Size: 46,
                                                  selected: true)
                                              : Con_profile_get(
                                                  pStrImageUrl: _firstchatlist[
                                                              index]
                                                          .user_profileimage_path
                                                          .isEmpty
                                                      ? ''
                                                      : _firstchatlist[index]
                                                          .user_profileimage_path,
                                                  Size: 46,
                                                ),
                                          selectedTileColor: Selected_tileColor,
                                          selectedColor: AppBar_ThemeColor,
                                          dense: true,
                                          title: Text(
                                            _firstchatlist[index].disp_name,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: Constants_Fonts
                                                    .mGblFontTitleSize,
                                                fontWeight: _firstchatlist[
                                                                    index]
                                                                .msg_unread_count >
                                                            0 ||
                                                        _firstchatlist[index]
                                                                .is_selected ==
                                                            1
                                                    ? FontWeight.w600
                                                    : FontWeight.w600),
                                          ),
                                          subtitle: Row(
                                            children: [
                                              if (_firstchatlist[index]
                                                      .msg_last_id
                                                      .toString() !=
                                                  Constants_Usermast.user_id
                                                      .toString())
                                                _firstchatlist[index]
                                                            .msg_delivered &&
                                                        _firstchatlist[index]
                                                                .msg_content
                                                                .toString()
                                                                .trim()
                                                                .trimRight()
                                                                .trimLeft() !=
                                                            ""
                                                    ? Constants_Usermast
                                                                .user_icon_selected ==
                                                            0
                                                        ? Image.asset(
                                                            Con_Wid.Ticks_Style_1[
                                                                'delivered'],
                                                            height: 10,
                                                            width: 10,
                                                            color: _firstchatlist[
                                                                            index]
                                                                        .msg_read
                                                                        .toLowerCase() !=
                                                                    'true'
                                                                ? (getPlatformBrightness()
                                                                    ? Dark_AppGreyColor
                                                                    : Colors
                                                                        .black)
                                                                : getPlatformBrightness()
                                                                    ? Dark_Read_Tick
                                                                    : Light_Read_Tick,
                                                          )
                                                        : Constants_Usermast
                                                                    .user_icon_selected ==
                                                                1
                                                            ? Image.asset(
                                                                Con_Wid.Ticks_Style_2[
                                                                    'delivered'],
                                                                height: 10,
                                                                width: 10,
                                                                color: _firstchatlist[index]
                                                                            .msg_read
                                                                            .toLowerCase() !=
                                                                        'true'
                                                                    ? (getPlatformBrightness()
                                                                        ? Dark_AppGreyColor
                                                                        : Colors
                                                                            .black)
                                                                    : getPlatformBrightness()
                                                                        ? Dark_Read_Tick
                                                                        : Light_Read_Tick,
                                                              )
                                                            : Constants_Usermast
                                                                        .user_icon_selected ==
                                                                    2
                                                                ? Image.asset(
                                                                    Con_Wid.Ticks_Style_3[
                                                                        'delivered'],
                                                                    height: 10,
                                                                    width: 10,
                                                                    color: _firstchatlist[index].msg_read.toLowerCase() !=
                                                                            'true'
                                                                        ? (getPlatformBrightness()
                                                                            ? Dark_AppGreyColor
                                                                            : Con_black)
                                                                        : getPlatformBrightness()
                                                                            ? Dark_Read_Tick
                                                                            : Light_Read_Tick,
                                                                  )
                                                                : Constants_Usermast.user_icon_selected ==
                                                                        3
                                                                    ? Image
                                                                        .asset(
                                                                        Con_Wid.Ticks_Style_4[
                                                                            'delivered'],
                                                                        height:
                                                                            14,
                                                                        width:
                                                                            14,
                                                                        color: _firstchatlist[index].msg_read.toLowerCase() !=
                                                                                'true'
                                                                            ? (getPlatformBrightness()
                                                                                ? Dark_AppGreyColor
                                                                                : Con_black)
                                                                            : getPlatformBrightness()
                                                                                ? Dark_Read_Tick
                                                                                : Light_Read_Tick,
                                                                      )
                                                                    : const Icon(Icons
                                                                        .add)
                                                    : _firstchatlist[index]
                                                                .msg_content
                                                                .toString()
                                                                .trim()
                                                                .trimRight()
                                                                .trimLeft() !=
                                                            ""
                                                        ? Constants_Usermast
                                                                    .user_icon_selected ==
                                                                0
                                                            ? Image.asset(
                                                                Con_Wid.Ticks_Style_1[
                                                                    'send'],
                                                                height: 10,
                                                                width: 10,
                                                                color: getPlatformBrightness()
                                                                    ? Dark_AppGreyColor
                                                                    : Colors
                                                                        .black,
                                                              )
                                                            : Constants_Usermast
                                                                        .user_icon_selected ==
                                                                    1
                                                                ? Image.asset(
                                                                    Con_Wid.Ticks_Style_2[
                                                                        'send'],
                                                                    height: 10,
                                                                    width: 10,
                                                                    color: getPlatformBrightness()
                                                                        ? Dark_AppGreyColor
                                                                        : Colors
                                                                            .black,
                                                                  )
                                                                : Constants_Usermast.user_icon_selected == 2
                                                                    ? Image.asset(
                                                                        Con_Wid.Ticks_Style_3[
                                                                            'send'],
                                                                        height:
                                                                            10,
                                                                        width:
                                                                            10,
                                                                        color: getPlatformBrightness()
                                                                            ? Dark_AppGreyColor
                                                                            : Con_black,
                                                                      )
                                                                    : Constants_Usermast.user_icon_selected == 3
                                                                        ? Image.asset(
                                                                            Con_Wid.Ticks_Style_4['send'],
                                                                            height:
                                                                                12,
                                                                            width:
                                                                                12,
                                                                            color: getPlatformBrightness()
                                                                                ? Dark_AppGreyColor
                                                                                : Con_black,
                                                                          )
                                                                        : Icon(
                                                                            Icons.add,
                                                                            color:
                                                                                Con_grey.shade600,
                                                                          )
                                                        : Container()
                                              else
                                                Container(),
                                              _firstchatlist[index]
                                                              .msg_last_id
                                                              .toString() !=
                                                          Constants_Usermast
                                                              .user_id
                                                              .toString() &&
                                                      _firstchatlist[index]
                                                              .msg_content
                                                              .toString()
                                                              .trim()
                                                              .trimRight()
                                                              .trimLeft() !=
                                                          ""
                                                  ? const SizedBox(
                                                      width: 5,
                                                    )
                                                  : const SizedBox(
                                                      width: 0,
                                                    ),
                                              Flexible(
                                                child: _firstchatlist[index]
                                                            .msg_type ==
                                                        1
                                                    ? Text(
                                                        _firstchatlist[index]
                                                            .msg_content
                                                            .replaceAll(
                                                                "\n", ""),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontFamily: "Inter",
                                                            fontSize:
                                                                Constants_Fonts
                                                                    .mGblFontSubTitleSize,
                                                            color: getPlatformBrightness()
                                                                ? Dark_AppGreyColor
                                                                : AppGreyColor,
                                                            fontWeight: (_firstchatlist[
                                                                            index]
                                                                        .msg_unread_count >
                                                                    0
                                                                ? FontWeight
                                                                    .bold
                                                                : FontWeight
                                                                    .normal)),
                                                      )
                                                    : _firstchatlist[index]
                                                                .msg_type ==
                                                            2
                                                        ? Row(
                                                            children: [
                                                              Icon(
                                                                Icons.image,
                                                                size: 15,
                                                                color: getPlatformBrightness()
                                                                    ? Dark_AppGreyColor
                                                                    : AppGreyColor,
                                                              ),
                                                              const SizedBox(
                                                                width: 3,
                                                              ),
                                                              Text(
                                                                "Photo",
                                                                style:
                                                                    TextStyle(
                                                                  color: getPlatformBrightness()
                                                                      ? Dark_AppGreyColor
                                                                      : AppGreyColor,
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        : _firstchatlist[index]
                                                                    .msg_type ==
                                                                3
                                                            ? Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .headphones,
                                                                    size: 15,
                                                                    color: getPlatformBrightness()
                                                                        ? Dark_AppGreyColor
                                                                        : AppGreyColor,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 3,
                                                                  ),
                                                                  Text(
                                                                    "Audio",
                                                                    style:
                                                                        TextStyle(
                                                                      color: getPlatformBrightness()
                                                                          ? Dark_AppGreyColor
                                                                          : AppGreyColor,
                                                                    ),
                                                                  )
                                                                ],
                                                              )
                                                            : _firstchatlist[
                                                                            index]
                                                                        .msg_type ==
                                                                    5
                                                                ? Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .videocam,
                                                                        size:
                                                                            15,
                                                                        color: getPlatformBrightness()
                                                                            ? Dark_AppGreyColor
                                                                            : AppGreyColor,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            3,
                                                                      ),
                                                                      Text(
                                                                        "Video",
                                                                        style:
                                                                            TextStyle(
                                                                          color: getPlatformBrightness()
                                                                              ? Dark_AppGreyColor
                                                                              : AppGreyColor,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  )
                                                                : _firstchatlist[index]
                                                                            .msg_type ==
                                                                        4
                                                                    ? Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.description,
                                                                            size:
                                                                                15,
                                                                            color: getPlatformBrightness()
                                                                                ? Dark_AppGreyColor
                                                                                : AppGreyColor,
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                3,
                                                                          ),
                                                                          Text(
                                                                            "Document",
                                                                            style:
                                                                                TextStyle(
                                                                              color: getPlatformBrightness() ? Dark_AppGreyColor : AppGreyColor,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      )
                                                                    : Container(),
                                              ),
                                            ],
                                          ),
                                          trailing: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  Modified_Time(
                                                      _firstchatlist[index]
                                                          .inserted_time_show),
                                                  style: TextStyle(
                                                    fontFamily: "Inter",
                                                    fontWeight: FontWeight.w600,
                                                    color: _firstchatlist[
                                                    index]
                                                        .msg_unread_count >0
                                                        ?Con_msg_auto_6:Color(0xff979797),

                                                    fontSize: Constants_Fonts
                                                        .mGblFontTimeShowSize,
                                                  ),
                                                ),
                                                if (_firstchatlist[index]
                                                        .msg_unread_count >
                                                    0)
                                                  Container(
                                                    height: 20,
                                                    width: _firstchatlist[index]
                                                                .msg_unread_count
                                                                .toString()
                                                                .length >
                                                            2
                                                        ? _firstchatlist[index]
                                                                    .msg_unread_count
                                                                    .toString()
                                                                    .length >
                                                                3
                                                            ? 40
                                                            : 30
                                                        : 20,
                                                    child: Center(
                                                      child: Text(
                                                          _firstchatlist[index]
                                                              .msg_unread_count
                                                              .toString(),
                                                          style: const TextStyle(color: Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      color:
                                                          getPlatformBrightness()
                                                              ? const Color(
                                                                  0xff1c849d)
                                                              : const Color(
                                                                      0xff06809F)
                                                                  .withOpacity(
                                                                      0.70),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ));
                                    } else {
                                      return const SizedBox(
                                        height: 80,
                                      );
                                    }
                                  }),
                            )
                          : Container();
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget First_Contact_Forward_List() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: FutureBuilder(
                      future: _setupNeeds(),
                      builder: (context, snapshot) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: _ContactList.length,
                            itemBuilder: (BuildContext context, int index) {
                              Need_Contact need = _ContactList[index];
                              bool IsSelected =
                                  Selected_Forword_Contact.contains(
                                      need.user_mast_id.toString());

                              return ListTile(
                                  dense: true,
                                  onTap: () {
                                    setState(() {
                                      if (IsSelected) {
                                        Selected_Forword_Contact.remove(
                                            need.user_mast_id.toString());
                                        mIntBroadCount -= 1;
                                      } else {
                                        Selected_Forword_Contact.add(
                                            need.user_mast_id.toString());
                                        mIntBroadCount += 1;
                                      }
                                    });
                                  },
                                  selected: IsSelected,
                                  selectedTileColor: Selected_tileColor,
                                  selectedColor: AppBar_ThemeColor,
                                  leading: IsSelected
                                      ? Con_profile_get(
                                          pStrImageUrl: "",
                                          Size: 46,
                                          selected: true)
                                      : Con_profile_get(
                                          pStrImageUrl:
                                              need.user_profileimage_path,
                                          Size: 46,
                                        ),
                                  title: Text(
                                    need.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize:
                                            Constants_Fonts.mGblFontTitleSize,
                                        fontWeight: IsSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  ),
                                  subtitle: Text(
                                    need.user_bio,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: Constants_Fonts
                                            .mGblFontSubTitleSize,
                                        color: getPlatformBrightness()
                                            ? Dark_AppGreyColor
                                            : AppGreyColor,
                                        fontWeight: FontWeight.bold),
                                  ));
                            });
                      }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget Cupertino_First_Chat_List() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CupertinoSearchTextField(
            controller: _searchQuery,
            onChanged: (value) {
              setState(() {
                _SearchListState();
              });
            },
          ),
        ),
        Expanded(
          child: Column(
            children: [
              widget.selected_needs_sub_msg == null
                  ? StreamBuilder<BoxEvent>(
                      stream: _main_fav_strm_con.stream,
                      builder: (context, snapshot) {
                        Constants_List.needs_fav = _Main_fav_box != null
                            ? _Main_fav_box!.values
                                .toList()
                                .cast<Need_Contact>()
                            : [];
                        return Constants_List.needs_fav.isNotEmpty &&
                                Constants_Usermast
                                    .user_chat_bln_favourite_contacts
                            ? Container(
                                // color: const Con_Clr_App_4,
                                color: getPlatformBrightness()
                                    ? Con_Clr_App_3
                                    : Con_Clr_App_4,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 7),
                                  decoration: const BoxDecoration(
                                      ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Material(
                                            color: Con_transparent,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 8.0,
                                                  top: 10,
                                                  bottom: 10),
                                              child: Text(
                                                'Favourite Contacts',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height: 83.0,
                                          child: ReorderableListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount:
                                                Constants_List.needs_fav.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              Need_Contact need = Constants_List
                                                  .needs_fav[index];
                                              return GestureDetector(
                                                key: ValueKey(index),
                                                onTap: () => Navigator.of(
                                                        context,
                                                        rootNavigator: true)
                                                    .push(CupertinoPageRoute(
                                                        builder: (context) => sub_contactsdetails(
                                                            need.id.toString(),
                                                            need.user_mast_id
                                                                .toString(),
                                                            need.name
                                                                .toString(),
                                                            need.user_profileimage_path
                                                                .toString(),
                                                            need.user_is_favourite,
                                                            need.user_bio,
                                                            need.user_bio_last_datetime,
                                                            need.user_is_online,
                                                            need.user_last_login_time,
                                                            need.user_birthdate,
                                                            need.user_countrywithmobile,
                                                            need.user_is_block))),
                                                child: Column(
                                                  children: [
                                                    Con_profile_get(
                                                      pStrImageUrl: need
                                                          .user_profileimage_path,
                                                      Size: 45,
                                                    ),
                                                    Material(
                                                      color: Con_transparent,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 3.0),
                                                        child: SizedBox(
                                                          width: 75,
                                                          child: Align(
                                                              child: Text(
                                                            need.name,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                            onReorder:
                                                (int oldIndex, int newIndex) =>
                                                    setState(() {
                                              if (oldIndex < newIndex) {
                                                newIndex -= 1;
                                              }
                                              final Need_Contact item =
                                                  Constants_List.needs_fav
                                                      .removeAt(oldIndex);
                                              Constants_List.needs_fav
                                                  .insert(newIndex, item);
                                            }),
                                          )),
                                    ],
                                  ),
                                  // )
                                ))
                            : Container();
                      },
                    )
                  : Container(),
              Expanded(
                child: StreamBuilder<BoxEvent>(
                    stream: _main_chat_strm_con.stream,
                    // stream: SyncJSon.user_main_chat_stream(),
                    builder: (context, snapshot) {
                      if (mBoolIsSearching == false) {
                        if (!mBoolMsgSelectMode && mIntBroadCount == 0) {
                          _firstchatlist = _Main_chat_box?.values
                                  ?.toList()
                                  ?.cast<Need_MainChat>() ??
                              [];
                        }
                      }
                      if (_firstchatlist.isEmpty) {
                        _firstchatlist = Constants_List.needs_main_chat;
                      } else {
                        Constants_List.needs_main_chat = _firstchatlist;
                      }
                      if (_firstchatlist.isEmpty) {
                        return Container();
                      }
                      if (_firstchatlist.isNotEmpty) {
                        for (int i = 0; i < _firstchatlist.length; i++) {
                          if (!MdiMainPage.mDelete.contains(
                              _firstchatlist[i].user_mast_id.toString())) {
                            MdiMainPage.mDelete
                                .add(_firstchatlist[i].user_mast_id.toString());
                          }
                        }
                      }
                      if (_firstchatlist[index].inserted_time != null &&
                          _firstchatlist[index]
                                  .inserted_time
                                  .toString()
                                  .toLowerCase() !=
                              "false") {
                        _firstchatlist.sort(
                          (b, a) => a.inserted_time.compareTo(b.inserted_time),
                        );
                      }
                      return _firstchatlist.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: _firstchatlist.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CupertinoContextMenu(
                                    previewBuilder:
                                        (context, animation, child) {
                                      return FutureBuilder(
                                          future: SyncJSon
                                              .user_sub_main_chat_select(),
                                          builder: (context,
                                              AsyncSnapshot<dynamic> snapshot) {
                                            _needs_sub_msg = (snapshot.hasData
                                                ? snapshot.data.reversed
                                                        .toList()
                                                    as List<Need_Main_Sub_Chat>
                                                : []);
                                            if (_needs_sub_msg.isNotEmpty) {
                                              _needs_sub_msg.sort(
                                                (b, a) => a.msg_timestamp
                                                    .replaceAll(')/', '')
                                                    .replaceAll('/Date(', '')
                                                    .compareTo(b.msg_timestamp
                                                        .replaceAll(')/', '')
                                                        .replaceAll(
                                                            '/Date(', '')),
                                              );
                                              return Container(
                                                decoration: BoxDecoration(
                                                    color:
                                                        Con_black.withOpacity(
                                                            0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Container(
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    shrinkWrap: true,
                                                    reverse: true,
                                                    controller: _controller,
                                                    itemCount: _needs_sub_msg
                                                                .length <=
                                                            5
                                                        ? _needs_sub_msg.length
                                                        : 5,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index1) {
                                                      String centerdatetwo = "",
                                                          centerdate = "";
                                                      bool showtime = false;
                                                      centerdate =
                                                          _needs_sub_msg[index1]
                                                              .date
                                                              .substring(0, 11);

                                                      if (_needs_sub_msg
                                                              .length !=
                                                          1) {
                                                        if (index1 != 0) {
                                                          centerdatetwo =
                                                              _needs_sub_msg[
                                                                      (index1 -
                                                                          1)]
                                                                  .date
                                                                  .substring(
                                                                      0, 11);
                                                          if (_needs_sub_msg
                                                                  .length !=
                                                              2) {
                                                            if (_needs_sub_msg
                                                                    .where((e) =>
                                                                        e.date.substring(
                                                                            0,
                                                                            11) ==
                                                                        centerdatetwo)
                                                                    .last
                                                                    .id ==
                                                                _needs_sub_msg[
                                                                        index1]
                                                                    .id) {
                                                              showtime = true;
                                                            } else {
                                                              showtime = false;
                                                            }
                                                          } else {
                                                            showtime = true;
                                                          }
                                                        } else {
                                                          if (_needs_sub_msg[
                                                                      index1]
                                                                  .date
                                                                  .substring(
                                                                      0, 11)
                                                                  .toString() !=
                                                              _needs_sub_msg[
                                                                      (index1 +
                                                                          1)]
                                                                  .date
                                                                  .substring(
                                                                      0, 11)
                                                                  .toString()) {
                                                            showtime = true;
                                                          }
                                                        }
                                                      } else {
                                                        showtime = true;
                                                        centerdate =
                                                            _needs_sub_msg[
                                                                    index1]
                                                                .date
                                                                .substring(
                                                                    0, 11);
                                                      }
                                                      return Column(
                                                        children: [
                                                          showtime
                                                              ? ChatBubble
                                                                  .CenterWidget(
                                                                      centerdate)
                                                              : Container(),
                                                          ChatBubble()
                                                              .ShowChatBubble(
                                                            context,
                                                            _needs_sub_msg[
                                                                    index1]
                                                                .is_right,
                                                            _needs_sub_msg[
                                                                    index1]
                                                                .msg_type,
                                                            _needs_sub_msg[
                                                                    index1]
                                                                .msg_content,
                                                            _needs_sub_msg[
                                                                    index1]
                                                                .document_url,
                                                            _needs_sub_msg[
                                                                    index1]
                                                                .msg_audio_name,
                                                            _needs_sub_msg[
                                                                    index1]
                                                                .msg_media_size,
                                                            _needs_sub_msg[
                                                                    index1]
                                                                .date,
                                                            _needs_sub_msg[
                                                                    index1]
                                                                .is_read,
                                                            _needs_sub_msg[
                                                                    index1]
                                                                .is_delivered,
                                                            _needs_sub_msg[
                                                                    index1]
                                                                .center_date,
                                                            _needs_sub_msg[
                                                                    index1]
                                                                .id,
                                                            _needs_sub_msg[
                                                                    index1]
                                                                .msg_to_user_mast_id,
                                                            "",
                                                            _searchQuery.text
                                                                .toString()
                                                                .toLowerCase(),
                                                            _firstchatlist[
                                                                    index]
                                                                .disp_name,
                                                            "",
                                                            onSelected:
                                                                (List<String>
                                                                    value) {
                                                              selectpStrmess =
                                                                  _needs_sub_msg[
                                                                          index]
                                                                      .is_right;
                                                              selectedmesstipe =
                                                                  _needs_sub_msg[
                                                                          index]
                                                                      .msg_type;
                                                              selectedimagename =
                                                                  _needs_sub_msg[
                                                                          index]
                                                                      .msg_audio_name;
                                                              selectedurl =
                                                                  _needs_sub_msg[
                                                                          index]
                                                                      .document_url;
                                                              selectedmediasize =
                                                                  _needs_sub_msg[
                                                                          index]
                                                                      .msg_media_size;
                                                            },
                                                          )
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          });
                                    },
                                    actions: [
                                      CupertinoContextMenuAction(
                                        trailingIcon:
                                            CupertinoIcons.slash_circle,
                                        child: const Text('Block'),
                                        onPressed: () {},
                                      ),
                                      CupertinoContextMenuAction(
                                        trailingIcon: CupertinoIcons.delete,
                                        child: const Text('Delete'),
                                        onPressed: () {},
                                      ),
                                      CupertinoContextMenuAction(
                                        isDestructiveAction: true,
                                        trailingIcon: CupertinoIcons.delete,
                                        child: const Text('Delete Chat'),
                                        onPressed: () {},
                                      ),
                                    ],
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          _firstchatlist[index].is_selected == 1
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0, top: 8.0),
                                                  child: Con_profile_get(
                                                      pStrImageUrl: "",
                                                      Size: 46,
                                                      selected: true),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0, top: 8.0),
                                                  child: Con_profile_get(
                                                    pStrImageUrl: _firstchatlist[
                                                            index]
                                                        .user_profileimage_path,
                                                    Size: 46,
                                                  ),
                                                ),
                                          Expanded(
                                            child: CupertinoListTile(
                                                onTap:
                                                    widget.selected_needs_sub_msg ==
                                                            null
                                                        ? () {
                                                            setState(
                                                              () {
                                                                if (mBoolMsgSelectMode) {
                                                                  if (_firstchatlist[
                                                                              index]
                                                                          .is_selected ==
                                                                      0) {
                                                                    _firstchatlist[
                                                                            index]
                                                                        .is_selected = 1;
                                                                  } else if (_firstchatlist[
                                                                              index]
                                                                          .is_selected ==
                                                                      1) {
                                                                    _firstchatlist[
                                                                            index]
                                                                        .is_selected = 0;
                                                                  }
                                                                  mIntBroadCount =
                                                                      _firstchatlist
                                                                          .where((e) =>
                                                                              e.is_selected ==
                                                                              1)
                                                                          .length;
                                                                  setState(
                                                                      () {});
                                                                  if (mIntBroadCount ==
                                                                      0) {
                                                                    mBoolMsgSelectMode =
                                                                        false;
                                                                    mBoolAppBarNew =
                                                                        false;
                                                                  }
                                                                } else {
                                                                  Navigator.of(
                                                                          context,
                                                                          rootNavigator:
                                                                              true)
                                                                      .pushReplacement(
                                                                          CupertinoPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            sub_contactsdetails(
                                                                      _firstchatlist[
                                                                              index]
                                                                          .uc_contact_id
                                                                          .toString(),
                                                                      _firstchatlist[
                                                                              index]
                                                                          .user_mast_id
                                                                          .toString(),
                                                                      _firstchatlist[
                                                                              index]
                                                                          .disp_name
                                                                          .toString(),
                                                                      _firstchatlist[
                                                                              index]
                                                                          .user_profileimage_path,
                                                                      _firstchatlist[
                                                                              index]
                                                                          .user_is_favourite,
                                                                      _firstchatlist[
                                                                              index]
                                                                          .user_bio,
                                                                      _firstchatlist[
                                                                              index]
                                                                          .user_bio_last_datetime,
                                                                      _firstchatlist[
                                                                              index]
                                                                          .user_is_online,
                                                                      _firstchatlist[
                                                                              index]
                                                                          .user_last_login_time,
                                                                      _firstchatlist[
                                                                              index]
                                                                          .user_birthdate,
                                                                      _firstchatlist[
                                                                              index]
                                                                          .user_countrywithmobile,
                                                                      _firstchatlist[
                                                                              index]
                                                                          .user_is_block,
                                                                      serverKey:
                                                                          _firstchatlist[index]
                                                                              .server_key,
                                                                    ),
                                                                  ));
                                                                }
                                                              },
                                                            );
                                                          }
                                                        : () {
                                                            setState(() {
                                                              if (_firstchatlist[
                                                                          index]
                                                                      .is_selected ==
                                                                  0) {
                                                                _firstchatlist[
                                                                        index]
                                                                    .is_selected = 1;
                                                                mIntBroadCount +=
                                                                    1;
                                                              } else if (_firstchatlist[
                                                                          index]
                                                                      .is_selected ==
                                                                  1) {
                                                                _firstchatlist[
                                                                        index]
                                                                    .is_selected = 0;
                                                                mIntBroadCount -=
                                                                    1;
                                                              }
                                                            });
                                                          },
                                                title: Text(
                                                  _firstchatlist[index]
                                                      .disp_name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontFamily: "Inter",
                                                      fontSize: Constants_Fonts
                                                          .mGblFontTitleSize,
                                                      fontWeight: _firstchatlist[
                                                                          index]
                                                                      .msg_unread_count >
                                                                  0 ||
                                                              _firstchatlist[
                                                                          index]
                                                                      .is_selected ==
                                                                  1
                                                          ? FontWeight.bold
                                                          : FontWeight.normal),
                                                ),
                                                subtitle: Row(
                                                  children: [
                                                    if (_firstchatlist[index]
                                                            .msg_last_id
                                                            .toString() !=
                                                        Constants_Usermast
                                                            .user_id
                                                            .toString())
                                                      _firstchatlist[index]
                                                                      .msg_read
                                                                      .toLowerCase() ==
                                                                  "false" &&
                                                              _firstchatlist[index]
                                                                      .msg_content
                                                                      .toString()
                                                                      .trim()
                                                                      .trimRight()
                                                                      .trimLeft() !=
                                                                  ""
                                                          ? Constants_Usermast
                                                                      .user_icon_selected ==
                                                                  0
                                                              ? Icon(
                                                                  Icons
                                                                      .check_circle,
                                                                  size: 10,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade600,
                                                                )
                                                              : Constants_Usermast
                                                                          .user_icon_selected ==
                                                                      1
                                                                  ? Icon(
                                                                      Icons
                                                                          .image,
                                                                      size: 10,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade600,
                                                                    )
                                                                  : Constants_Usermast.user_icon_selected ==
                                                                          2
                                                                      ? Icon(
                                                                          Icons
                                                                              .print,
                                                                          size:
                                                                              10,
                                                                          color: Colors
                                                                              .grey
                                                                              .shade600,
                                                                        )
                                                                      : Constants_Usermast.user_icon_selected ==
                                                                              3
                                                                          ? Icon(
                                                                              Icons.chat,
                                                                              size: 10,
                                                                              color: Con_grey.shade600,
                                                                            )
                                                                          : const Icon(Icons
                                                                              .add)
                                                          : _firstchatlist[index]
                                                                      .msg_content
                                                                      .toString()
                                                                      .trim()
                                                                      .trimRight()
                                                                      .trimLeft() !=
                                                                  ""
                                                              ? Constants_Usermast.user_icon_selected == 0
                                                                  ? Icon(
                                                                      Icons
                                                                          .check_circle_outline,
                                                                      size: 10,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade600,
                                                                    )
                                                                  : Constants_Usermast.user_icon_selected == 1
                                                                      ? Icon(
                                                                          Icons
                                                                              .update,
                                                                          size:
                                                                              10,
                                                                          color: Colors
                                                                              .grey
                                                                              .shade600,
                                                                        )
                                                                      : Constants_Usermast.user_icon_selected == 2
                                                                          ? Icon(
                                                                              Icons.clear,
                                                                              size: 10,
                                                                              color: Con_grey.shade600,
                                                                            )
                                                                          : Constants_Usermast.user_icon_selected == 3
                                                                              ? Icon(
                                                                                  Icons.exit_to_app,
                                                                                  size: 10,
                                                                                  color: Con_grey.shade600,
                                                                                )
                                                                              : Icon(
                                                                                  Icons.add,
                                                                                  color: Con_grey.shade600,
                                                                                )
                                                              : Container()
                                                    else
                                                      Container(),
                                                    _firstchatlist[index]
                                                                    .msg_last_id
                                                                    .toString() !=
                                                                Constants_Usermast
                                                                    .user_id
                                                                    .toString() &&
                                                            _firstchatlist[
                                                                        index]
                                                                    .msg_content
                                                                    .toString()
                                                                    .trim()
                                                                    .trimRight()
                                                                    .trimLeft() !=
                                                                ""
                                                        ? const SizedBox(
                                                            width: 5,
                                                          )
                                                        : const SizedBox(
                                                            width: 0,
                                                          ),
                                                    Flexible(
                                                      child: _firstchatlist[
                                                                      index]
                                                                  .msg_type ==
                                                              1
                                                          ? Text(
                                                              _firstchatlist[
                                                                      index]
                                                                  .msg_content
                                                                  .replaceAll(
                                                                      "\n", ""),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      Constants_Fonts
                                                                          .mGblFontSubTitleSize,
                                                                  color: getPlatformBrightness()
                                                                      ? Dark_AppGreyColor
                                                                      : AppGreyColor,
                                                                  fontWeight: (_firstchatlist[index]
                                                                              .msg_unread_count >
                                                                          0
                                                                      ? FontWeight
                                                                          .bold
                                                                      : FontWeight
                                                                          .normal)),
                                                            )
                                                          : _firstchatlist[
                                                                          index]
                                                                      .msg_type ==
                                                                  2
                                                              ? Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .image,
                                                                      size: 15,
                                                                      color: getPlatformBrightness()
                                                                          ? Dark_AppGreyColor
                                                                          : AppGreyColor,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 3,
                                                                    ),
                                                                    Text(
                                                                      "Photo",
                                                                      style:
                                                                          TextStyle(
                                                                        color: getPlatformBrightness()
                                                                            ? Dark_AppGreyColor
                                                                            : AppGreyColor,
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                              : _firstchatlist[
                                                                              index]
                                                                          .msg_type ==
                                                                      3
                                                                  ? Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .headphones,
                                                                          size:
                                                                              15,
                                                                          color: getPlatformBrightness()
                                                                              ? Dark_AppGreyColor
                                                                              : AppGreyColor,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              3,
                                                                        ),
                                                                        Text(
                                                                          "Audio",
                                                                          style:
                                                                              TextStyle(
                                                                            color: getPlatformBrightness()
                                                                                ? Dark_AppGreyColor
                                                                                : AppGreyColor,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    )
                                                                  : _firstchatlist[index]
                                                                              .msg_type ==
                                                                          5
                                                                      ? Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.videocam,
                                                                              size: 15,
                                                                              color: getPlatformBrightness() ? Dark_AppGreyColor : AppGreyColor,
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 3,
                                                                            ),
                                                                            Text(
                                                                              "Video",
                                                                              style: TextStyle(
                                                                                color: getPlatformBrightness() ? Dark_AppGreyColor : AppGreyColor,
                                                                              ),
                                                                            )
                                                                          ],
                                                                        )
                                                                      : _firstchatlist[index].msg_type ==
                                                                              4
                                                                          ? Row(
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.description,
                                                                                  size: 15,
                                                                                  color: getPlatformBrightness() ? Dark_AppGreyColor : AppGreyColor,
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 3,
                                                                                ),
                                                                                Text(
                                                                                  "Document",
                                                                                  style: TextStyle(
                                                                                    color: getPlatformBrightness() ? Dark_AppGreyColor : AppGreyColor,
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            )
                                                                          : Container(),
                                                    ),
                                                  ],
                                                ),
                                                trailing: Material(
                                                  color: Con_transparent,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          _firstchatlist[index]
                                                              .inserted_time_show,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                _firstchatlist[index]
                                                                            .msg_unread_count >
                                                                        0
                                                                    ? FontWeight
                                                                        .bold
                                                                    : FontWeight
                                                                        .normal,
                                                            fontSize:
                                                                Constants_Fonts
                                                                    .mGblFontTimeShowSize,
                                                          ),
                                                        ),
                                                        if (_firstchatlist[
                                                                    index]
                                                                .msg_unread_count >
                                                            0)
                                                          Container(
                                                            height: 20,
                                                            width: _firstchatlist[
                                                                            index]
                                                                        .msg_unread_count
                                                                        .toString()
                                                                        .length >
                                                                    2
                                                                ? _firstchatlist[index]
                                                                            .msg_unread_count
                                                                            .toString()
                                                                            .length >
                                                                        3
                                                                    ? 40
                                                                    : 30
                                                                : 20,
                                                            child: Center(
                                                              child: Text(
                                                                  _firstchatlist[
                                                                          index]
                                                                      .msg_unread_count
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal)),
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                              color: getPlatformBrightness()
                                                                  ? const Color(
                                                                      0xff1c849d)
                                                                  : const Color(
                                                                          0xff06809F)
                                                                      .withOpacity(
                                                                          0.70),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ));
                              })
                          : Container();
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  hasLoginname() async {
    String LoginName = await (SharedPref.read_string('user_login_name') ?? "");
    String About = await (SharedPref.read_string('user_about') ?? "");
    String phone = await (SharedPref.read_string('user_phone') ?? "");
    String profile = await SharedPref.read_string('profile_pic');
    String countryCode = await (SharedPref.read_string('country_code') ?? "");
    bool favList =
        await (SharedPref.read_bool('user_chat_bln_favourite_contacts') ??
            false);
    setState(() {
      Constants_Usermast.user_login_name =
          LoginName.isEmpty ? Constants_Usermast.user_login_name : LoginName;
      Constants_Usermast.user_bio = About;
      Constants_Usermast.disp_mobile_number = phone;
      Constants_Usermast.user_profileimage_path = profile;
      Constants_Usermast.country_code = countryCode;
      Constants_Usermast.user_chat_bln_favourite_contacts = favList;
    });
    await Folder.createdir();
  }

  Second_Online_Api() {
    if (mIntCurrentIndex != 1) {
      return _SecondNeeds_online;
    }
    if (_searchQuery.text.isEmpty) {
      mBoolIsSearching = false;
      if (mounted) {
        setState(() {});
      }
    } else {
      _SecondNeeds_online = Constants_List.needs_online
          .where((element) =>
              element.name
                  .toLowerCase()
                  .toString()
                  .contains(_searchQuery.text.toLowerCase().toString()) ||
              element.user_countrywithmobile
                  .toLowerCase()
                  .toString()
                  .contains(_searchQuery.text.toLowerCase().toString()) ||
              element.user_bio
                  .toLowerCase()
                  .toString()
                  .contains(_searchQuery.text.toLowerCase().toString()) ||
              element.user_last_msg
                  .toLowerCase()
                  .toString()
                  .contains(_searchQuery.text.toLowerCase().toString()))
          .toList();
      setState(() {});
      if (mounted) {
        setState(() {});
      }
    }
    return _SecondNeeds_online;
  }

  Widget Cupertino_Second_Online_List() {
    return StreamBuilder<BoxEvent>(
      stream: _main_online_strm_con.stream,
      builder: (context, snapshot) {
        if (mBoolIsSearching == false) {
          if (!mBoolBroadSelectMode && mIntBroadCount == 0) {
            _SecondNeeds_online = _Main_online_box != null
                ? _Main_online_box!.values
                    .where((e) =>
                        e.user_is_online == true &&
                        e.user_exist_in_mobile == true)
                    .toList()
                : [];
          }
        }
        Constants_List.needs_online = _SecondNeeds_online;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoSearchTextField(
                controller: _searchQuery,
                onChanged: (value) {
                  setState(() {
                    _SearchListState();
                  });
                },
              ),
            ),
            Visibility(
              visible: true,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _SecondNeeds_online.length,
                itemBuilder: (BuildContext context, int index) {
                  Need_Contact need = _SecondNeeds_online[index];
                  return GestureDetector(
                    onTap: () async => await Navigator.push(
                        context,
                        RouteTransitions.slideTransition(sub_contactsdetails(
                            need.id.toString(),
                            need.user_mast_id.toString(),
                            need.name.toString(),
                            need.user_profileimage_path.toString(),
                            need.user_is_favourite,
                            need.user_bio,
                            need.user_bio_last_datetime,
                            true,
                            need.user_last_login_time,
                            need.user_birthdate,
                            need.user_countrywithmobile,
                            need.user_is_block))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ChatProfile(
                            mStrMobile: need.id.toString(),
                            usermastid: need.user_mast_id.toString(),
                            mStrName: need.name.toString(),
                            mStrProfile: need.user_profileimage_path.toString(),
                            mBlnFav: need.user_is_favourite,
                            mStrLastBio: need.user_bio,
                            mStrLastBioDate: need.user_bio_last_datetime,
                            mBlnLastOnline: true,
                            mStrLastLoginTime: need.user_last_login_time,
                            mStrLastBirthdate: need.user_birthdate,
                            mStrLastfinalmobilenumber:
                                need.user_countrywithmobile,
                            mBlnBlock: need.user_is_block),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget Second_Online_List() {
    return StreamBuilder<BoxEvent>(
      stream: _main_online_strm_con.stream,
      builder: (context, snapshot) {
        if (mBoolIsSearching == false) {
          if (!mBoolBroadSelectMode && mIntBroadCount == 0) {
            _SecondNeeds_online = _Main_online_box != null
                ? _Main_online_box!.values
                    .where((e) =>
                        e.user_is_online == true &&
                        e.user_exist_in_mobile == true)
                    .toList()
                : [];
          }
        }
        Constants_List.needs_online = _SecondNeeds_online;
        return Column(
          children: [
            Visibility(
              visible: true,
              child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    (kToolbarHeight *
                        (MediaQuery.of(context).size.height / 284)),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _SecondNeeds_online.length,
                  itemBuilder: (BuildContext context, int index) {
                    Need_Contact need = _SecondNeeds_online[index];
                    return GestureDetector(
                      onTap: () async => await Navigator.push(
                          context,
                          RouteTransitions.slideTransition(sub_contactsdetails(
                              need.id.toString(),
                              need.user_mast_id.toString(),
                              need.name.toString(),
                              need.user_profileimage_path.toString(),
                              need.user_is_favourite,
                              need.user_bio,
                              need.user_bio_last_datetime,
                              true,
                              need.user_last_login_time,
                              need.user_birthdate,
                              need.user_countrywithmobile,
                              need.user_is_block))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ChatProfile(
                              mStrMobile: need.id.toString(),
                              usermastid: need.user_mast_id.toString(),
                              mStrName: need.name.toString(),
                              mStrProfile:
                                  need.user_profileimage_path.toString(),
                              mBlnFav: need.user_is_favourite,
                              mStrLastBio: need.user_bio,
                              mStrLastBioDate: need.user_bio_last_datetime,
                              mBlnLastOnline: true,
                              mStrLastLoginTime: need.user_last_login_time,
                              mStrLastBirthdate: need.user_birthdate,
                              mStrLastfinalmobilenumber:
                                  need.user_countrywithmobile,
                              mBlnBlock: need.user_is_block),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget Fourth_Broadcast_List() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: StreamBuilder<BoxEvent>(
          stream: _main_bro_strm_con.stream,
          builder: (context, snapshot) {

            if (mBoolIsSearching == false && !mBoolBroadSelectMode) {
              if (!mBoolBroadSelectMode && mIntBroadCount == 0) {
                _FourthBroadcastOnline = _Main_bro_box != null
                    ? _Main_bro_box!.values.toList().cast<Need_Broadcast>()
                    : [];
              }

              if (_FourthBroadcastOnline.isNotEmpty) {
                Constants_List.need_broadcast = _FourthBroadcastOnline;
                if (_FourthBroadcastOnline[index].br_modified_time != false) {
                  _FourthBroadcastOnline.sort(
                    (b, a) => a.br_modified_time
                        .toString()
                        .compareTo(b.br_modified_time.toString()),
                  );
                }
              } else {
                _FourthBroadcastOnline = Constants_List.need_broadcast;
              }
            }
            log(_FourthBroadcastOnline.map((e) => Need_Broadcast.toJson(e)).toString());
            return _FourthBroadcastOnline.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _FourthBroadcastOnline.length,
                    itemBuilder: (BuildContext context, int index) {
                      Need_Broadcast need = _FourthBroadcastOnline[index];
                      return GestureDetector(
                        onTap: () async {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              selected:
                                  _FourthBroadcastOnline[index].is_selected ==
                                          false
                                      ? false
                                      : true,
                              onLongPress: widget.selected_needs_sub_msg == null
                                  ? () {
                                      setState(
                                        () {
                                          _firstchatlist
                                              .where((e) => e.is_selected == 1)
                                              .map((e) => e.is_selected = 0);
                                          mBoolMsgSelectMode = false;
                                          _FourthBroadcastOnline[index]
                                              .is_selected = true;
                                          mBoolBroadSelectMode = true;
                                          mBoolAppBarNew = true;
                                        },
                                      );
                                    }
                                  : () {},
                              onTap: widget.selected_needs_sub_msg == null
                                  ? () {
                                      setState(
                                        () {
                                          if (mBoolBroadSelectMode) {
                                            if (_FourthBroadcastOnline[index]
                                                    .is_selected ==
                                                false) {
                                              _FourthBroadcastOnline[index]
                                                  .is_selected = true;
                                            } else if (_FourthBroadcastOnline[
                                                        index]
                                                    .is_selected ==
                                                true) {
                                              _FourthBroadcastOnline[index]
                                                  .is_selected = false;
                                            }
                                            mIntBroadCount =
                                                _FourthBroadcastOnline.where(
                                                    (element) =>
                                                        element.is_selected ==
                                                        true).length;
                                            setState(() {});
                                            if (mIntBroadCount == 0) {
                                              mBoolBroadSelectMode = false;
                                              mBoolAppBarNew = false;
                                            }
                                          } else {
                                            Navigator.pushReplacement(
                                              context,
                                              RouteTransitions.slideTransition(
                                                Con_Send_Broadcast(
                                                  need.id.toString(),
                                                  need.br_name,
                                                  need.br_profile_pic,
                                                  need.br_exist_user,
                                                  need.user_mast_id.toString(),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    }
                                  : () {
                                      if (_FourthBroadcastOnline[index]
                                              .is_selected ==
                                          false) {
                                        _FourthBroadcastOnline[index]
                                            .is_selected = true;
                                        mIntBroadCount +=
                                            _FourthBroadcastOnline.where(
                                                (element) =>
                                                    element.is_selected ==
                                                    true).length;
                                      } else if (_FourthBroadcastOnline[index]
                                              .is_selected ==
                                          true) {
                                        _FourthBroadcastOnline[index]
                                            .is_selected = false;
                                        mIntBroadCount -=
                                            _FourthBroadcastOnline.where(
                                                (element) =>
                                                    element.is_selected ==
                                                    false).length;
                                      }
                                      setState(() {});
                                    },
                              leading:
                                  _FourthBroadcastOnline[index].is_selected == 1
                                      ? Con_profile_get(
                                          pStrImageUrl: need.br_profile_pic,
                                          Size: 46,
                                          selected: true,
                                          isbroadcast: true)
                                      : Con_profile_get(
                                          pStrImageUrl: need.br_profile_pic,
                                          Size: 46,
                                          selected: false,
                                          isbroadcast: true),
                              selectedTileColor: Selected_tileColor,
                              selectedColor: AppBar_ThemeColor,
                              dense: true,
                              title: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      need.br_name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontWeight: FontWeight.bold,
                                        fontSize:
                                            Constants_Fonts.mGblFontTitleSize,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    Modified_Time(need.br_modified_time_show),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: Constants_Fonts
                                            .mGblFontTimeShowSize),
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: need.br_msg_type == 1
                                          ? Text(
                                              need.br_msg_content
                                                  .replaceAll("\n", ""),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: "Inter",
                                                  fontSize: Constants_Fonts
                                                      .mGblFontSubTitleSize,
                                                  color: getPlatformBrightness()
                                                      ? Dark_AppGreyColor
                                                      : AppGreyColor,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )
                                          : need.br_msg_type == 2
                                              ? Row(
                                                  children: [
                                                    Icon(
                                                      Icons.image,
                                                      size: 15,
                                                      color:
                                                          getPlatformBrightness()
                                                              ? Dark_AppGreyColor
                                                              : AppGreyColor,
                                                    ),
                                                    const SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(
                                                      "Photo",
                                                      style: TextStyle(
                                                          color: AppGreyColor),
                                                    )
                                                  ],
                                                )
                                              : need.br_msg_type == 3
                                                  ? Row(
                                                      children: [
                                                        Icon(
                                                          Icons.headphones,
                                                          size: 15,
                                                          color: getPlatformBrightness()
                                                              ? Dark_AppGreyColor
                                                              : AppGreyColor,
                                                        ),
                                                        const SizedBox(
                                                          width: 3,
                                                        ),
                                                        Text(
                                                          "Audio",
                                                          style: TextStyle(
                                                              color:
                                                                  AppGreyColor),
                                                        )
                                                      ],
                                                    )
                                                  : need.br_msg_type == 5
                                                      ? Row(
                                                          children: [
                                                            Icon(
                                                              Icons.videocam,
                                                              size: 15,
                                                              color:
                                                                  AppGreyColor,
                                                            ),
                                                            SizedBox(
                                                              width: 3,
                                                            ),
                                                            Text(
                                                              "Video",
                                                              style: TextStyle(
                                                                  color:
                                                                      AppGreyColor),
                                                            )
                                                          ],
                                                        )
                                                      : need.br_msg_type == 4
                                                          ? Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .description,
                                                                  size: 15,
                                                                  color:
                                                                      AppGreyColor,
                                                                ),
                                                                SizedBox(
                                                                  width: 3,
                                                                ),
                                                                Text(
                                                                  "Document",
                                                                  style: TextStyle(
                                                                      color:
                                                                          AppGreyColor),
                                                                )
                                                              ],
                                                            )
                                                          : Container(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Container();
          },
        )),
      ],
    );
  }

  Widget Cupertino_Fourth_Broadcast_List() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CupertinoSearchTextField(
            controller: _searchQuery,
            onChanged: (value) {
              setState(() {
                _SearchListState();
              });
            },
          ),
        ),
        Expanded(
            child: StreamBuilder<BoxEvent>(
          stream: _main_bro_strm_con.stream,
          builder: (context, snapshot) {
            if (mBoolIsSearching == false) {
              if (!mBoolBroadSelectMode && mIntBroadCount == 0) {
                _FourthBroadcastOnline = _Main_bro_box != null
                    ? _Main_bro_box!.values.toList().cast<Need_Broadcast>()
                    : [];
              }
            }
            if (_FourthBroadcastOnline.isNotEmpty) {
              Constants_List.need_broadcast = _FourthBroadcastOnline;
              if (_FourthBroadcastOnline[index].br_modified_time_show !=
                  false) {
                _FourthBroadcastOnline.sort(
                  (b, a) => a.br_modified_time_show
                      .compareTo(b.br_modified_time_show),
                );
              }
            }
            return _FourthBroadcastOnline.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _FourthBroadcastOnline.length,
                    itemBuilder: (BuildContext context, int index) {
                      Need_Broadcast need = _FourthBroadcastOnline[index];
                      return CupertinoContextMenu(
                          previewBuilder: (context, animation, child) {
                            return FutureBuilder(
                                future:
                                    SyncJSon.user_msg_broadcast_select(need.id),
                                builder:
                                    (context, AsyncSnapshot<dynamic> snapshot) {
                                  _needs_sub_broad = snapshot.hasData
                                      ? snapshot.data.reversed.toList()
                                          as List<Need_Broadcast_Sub_Msg>
                                      : [];
                                  _needs_sub_broad.sort(
                                    (b, a) => a.msg_timestamp
                                        .replaceAll(')/', '')
                                        .replaceAll('/Date(', '')
                                        .compareTo(b.msg_timestamp
                                            .replaceAll(')/', '')
                                            .replaceAll('/Date(', '')),
                                  );
                                  return ListView.builder(
                                    reverse: true,
                                    scrollDirection: Axis.vertical,
                                    controller: _controller,
                                    itemCount: _needs_sub_broad.length <= 5
                                        ? _needs_sub_broad.length
                                        : 5,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      String centerdatetwo = "",
                                          centerdate = "";
                                      bool showtime = false;
                                      centerdate = _needs_sub_broad[index]
                                          .date
                                          .substring(0, 11);
                                      if (_needs_sub_broad.length != 1) {
                                        if (index != 0) {
                                          centerdatetwo =
                                              _needs_sub_broad[(index - 1)]
                                                  .date
                                                  .substring(0, 11);
                                          if (_needs_sub_broad.length != 2) {
                                            if (_needs_sub_broad
                                                    .where((e) =>
                                                        e.date
                                                            .substring(0, 11) ==
                                                        centerdatetwo)
                                                    .last
                                                    .id ==
                                                _needs_sub_broad[index].id) {
                                              showtime = true;
                                            } else {
                                              showtime = false;
                                            }
                                          } else {
                                            showtime = true;
                                          }
                                        } else {
                                          if (_needs_sub_broad[index]
                                                  .date
                                                  .substring(0, 11)
                                                  .toString() !=
                                              _needs_sub_broad[(index + 1)]
                                                  .date
                                                  .substring(0, 11)
                                                  .toString()) {
                                            showtime = true;
                                          }
                                        }
                                      } else {
                                        showtime = true;
                                        centerdate = _needs_sub_broad[index]
                                            .date
                                            .substring(0, 11);
                                      }
                                      return Column(
                                        children: [
                                          showtime
                                              ? ChatBubble.CenterWidget(
                                                  centerdate)
                                              : Container(),
                                          ChatBubble().ShowChatBubble(
                                              context,
                                              _needs_sub_broad[index].is_right,
                                              _needs_sub_broad[index].msg_type,
                                              _needs_sub_broad[index]
                                                  .msg_content,
                                              _needs_sub_broad[index]
                                                  .document_url,
                                              _needs_sub_broad[index]
                                                  .msg_audio_name,
                                              _needs_sub_broad[index]
                                                  .msg_media_size,
                                              _needs_sub_broad[index].date,
                                              _needs_sub_broad[index].is_read,
                                              _needs_sub_broad[index]
                                                  .is_delivered,
                                              _needs_sub_broad[index]
                                                  .center_date,
                                              _needs_sub_broad[index].id,
                                              "",
                                              "",
                                              _searchQuery.text,
                                              "Broad",
                                              "",
                                              onSelected: (List<String> value) {
                                            selectpStrmess =
                                                _needs_sub_broad[index]
                                                    .is_right;
                                            selectedmesstipe =
                                                _needs_sub_broad[index]
                                                    .msg_type;
                                            selectedimagename =
                                                _needs_sub_broad[index]
                                                    .msg_audio_name;
                                            selectedurl =
                                                _needs_sub_broad[index]
                                                    .document_url;
                                            selectedmediasize =
                                                _needs_sub_broad[index]
                                                    .msg_media_size;
                                          })
                                        ],
                                      );
                                    },
                                  );
                                });
                          },
                          actions: const [
                            CupertinoContextMenuAction(
                                trailingIcon: CupertinoIcons.trash,
                                child: Text("Delete")),
                          ],
                          child: Container(
                            child: Row(
                              children: [
                                _FourthBroadcastOnline[index].is_selected == 1
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 8.0),
                                        child: Con_profile_get(
                                            pStrImageUrl: need.br_profile_pic,
                                            Size: 46,
                                            selected: true,
                                            isbroadcast: true),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 8.0),
                                        child: Con_profile_get(
                                            pStrImageUrl: need.br_profile_pic,
                                            Size: 46,
                                            selected: false,
                                            isbroadcast: true),
                                      ),
                                Expanded(
                                  child: CupertinoListTile(
                                    onTap: widget.selected_needs_sub_msg == null
                                        ? () {
                                            setState(
                                              () {
                                                if (mBoolBroadSelectMode) {
                                                  if (_FourthBroadcastOnline[
                                                              index]
                                                          .is_selected ==
                                                      false) {
                                                    _FourthBroadcastOnline[
                                                            index]
                                                        .is_selected = true;
                                                  } else if (_FourthBroadcastOnline[
                                                              index]
                                                          .is_selected ==
                                                      true) {
                                                    _FourthBroadcastOnline[
                                                            index]
                                                        .is_selected = false;
                                                  }
                                                  mIntBroadCount =
                                                      _FourthBroadcastOnline
                                                          .where((element) =>
                                                              element
                                                                  .is_selected ==
                                                              true).length;
                                                  setState(() {});
                                                  if (mIntBroadCount == 0) {
                                                    mBoolBroadSelectMode =
                                                        false;
                                                    mBoolAppBarNew = false;
                                                  }
                                                } else {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .push(
                                                    CupertinoPageRoute(
                                                      builder: (context) =>
                                                          Con_Send_Broadcast(
                                                        need.id.toString(),
                                                        need.br_name,
                                                        need.br_profile_pic,
                                                        need.br_exist_user,
                                                        need.user_mast_id
                                                            .toString(),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            );
                                          }
                                        : () {
                                            if (_FourthBroadcastOnline[index]
                                                    .is_selected ==
                                                false) {
                                              _FourthBroadcastOnline[index]
                                                  .is_selected = true;
                                              mIntBroadCount +=
                                                  _FourthBroadcastOnline.where(
                                                      (element) =>
                                                          element.is_selected ==
                                                          true).length;
                                            } else if (_FourthBroadcastOnline[
                                                        index]
                                                    .is_selected ==
                                                true) {
                                              _FourthBroadcastOnline[index]
                                                  .is_selected = false;
                                              mIntBroadCount -=
                                                  _FourthBroadcastOnline.where(
                                                      (element) =>
                                                          element.is_selected ==
                                                          false).length;
                                            }
                                            setState(() {});
                                          },
                                    title: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            need.br_name,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: Constants_Fonts
                                                  .mGblFontTitleSize,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          need.br_modified_time_show,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: Constants_Fonts
                                                  .mGblFontTimeShowSize),
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 3.0),
                                      child: Row(
                                        children: [
                                          need.br_msg_content
                                                      .toString()
                                                      .trim()
                                                      .trimRight()
                                                      .trimLeft() !=
                                                  ""
                                              ? const SizedBox(
                                                  width: 5,
                                                )
                                              : const SizedBox(
                                                  width: 0,
                                                ),
                                          Flexible(
                                            child: need.br_msg_type == 1
                                                ? Text(
                                                    need.br_msg_content
                                                        .replaceAll("\n", ""),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: Constants_Fonts
                                                            .mGblFontSubTitleSize,
                                                        color: getPlatformBrightness()
                                                            ? Dark_AppGreyColor
                                                            : AppGreyColor,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  )
                                                : need.br_msg_type == 2
                                                    ? Row(
                                                        children: [
                                                          Icon(
                                                            Icons.image,
                                                            size: 15,
                                                            color: getPlatformBrightness()
                                                                ? Dark_AppGreyColor
                                                                : AppGreyColor,
                                                          ),
                                                          const SizedBox(
                                                            width: 3,
                                                          ),
                                                          const Text(
                                                            "Photo",
                                                            style: TextStyle(
                                                                color:
                                                                    AppGreyColor),
                                                          )
                                                        ],
                                                      )
                                                    : need.br_msg_type == 3
                                                        ? Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .headphones,
                                                                size: 15,
                                                                color: getPlatformBrightness()
                                                                    ? Dark_AppGreyColor
                                                                    : AppGreyColor,
                                                              ),
                                                              const SizedBox(
                                                                width: 3,
                                                              ),
                                                              const Text(
                                                                "Audio",
                                                                style: TextStyle(
                                                                    color:
                                                                        AppGreyColor),
                                                              )
                                                            ],
                                                          )
                                                        : need.br_msg_type == 5
                                                            ? const Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .videocam,
                                                                    size: 15,
                                                                    color:
                                                                        AppGreyColor,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 3,
                                                                  ),
                                                                  Text(
                                                                    "Video",
                                                                    style: TextStyle(
                                                                        color:
                                                                            AppGreyColor),
                                                                  )
                                                                ],
                                                              )
                                                            : need.br_msg_type ==
                                                                    4
                                                                ? const Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .description,
                                                                        size:
                                                                            15,
                                                                        color:
                                                                            AppGreyColor,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            3,
                                                                      ),
                                                                      Text(
                                                                        "Document",
                                                                        style: TextStyle(
                                                                            color:
                                                                                AppGreyColor),
                                                                      )
                                                                    ],
                                                                  )
                                                                : Container(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                  )
                : Container();
          },
        )),
      ],
    );
  }

  Future<List<Need_Broadcast>> Fourth_Broadcasts_Api() async {
    if (mIntCurrentIndex != 2) {
      return _FourthBroadcastOnline;
    }
    if (_searchQuery.text.isEmpty) {
      mBoolIsSearching = false;
      if (!mBoolBroadSelectMode) {
        _FourthBroadcastOnline = Constants_List.need_broadcast;
        if (mounted) {
          setState(
            () {},
          );
        }
      }
    } else {
      _FourthBroadcastOnline = Constants_List.need_broadcast
          .where((element) =>
              element.br_name
                  .toLowerCase()
                  .toString()
                  .contains(_searchQuery.text.toLowerCase().toString()) ||
              element.br_msg_content
                  .toLowerCase()
                  .toString()
                  .contains(_searchQuery.text.toLowerCase().toString()))
          .toList();
      setState(() {});
      if (mounted) {
        setState(
          () {},
        );
      }
    }
    return _FourthBroadcastOnline;
  }

  void toggleSelection() {
    setState(
      () {
        if (isSelected) {
          mycolor = Con_white;
          isSelected = false;
        } else {
          mycolor = Con_grey;
          isSelected = true;
        }
      },
    );
  }

  Modified_Time(String pStrDate) {
    return pStrDate;
  }
  Future<void> ForwordMessage(
      String toId, String broadcastId, String msgIds) async {
    try {
      await sql_sub_messages_tran.Forword_Msg(
          from_id: Constants_Usermast.user_id,
          to_id: toId,
          broadcast_id: broadcastId,
          msg_ids: msgIds);
    } catch (e) {}
  }

  navigatenew(BuildContext context) async {
    await Navigator.push(
      context,
      RouteTransitions.slideTransition(
        Con_Global_Contacts(
          "Favourite",
          Selected: (List<Need_Contact> value) {},
        ),
      ),
    );
  }
}
