import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:nextapp/A_FB_Trigger/SharedPref.dart';
import 'package:nextapp/A_FB_Trigger/sql_need_contact.dart';
import 'package:nextapp/A_Local_DB/Sync_Database.dart';
import 'package:nextapp/A_Local_DB/Sync_Json.dart';
import 'package:nextapp/A_SQL_Trigger/sql_broadcat.dart';
import 'package:nextapp/A_SQL_Trigger/sql_sub_messages.dart';
import 'package:nextapp/Constant/Con_Clr.dart';
import 'package:nextapp/Constant/Con_Icons.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:nextapp/Constant/Constants.dart';
import 'package:nextapp/mdi_page/A_ChatBubble/ChatBubble.dart';
import 'package:nextapp/mdi_page/Broadcast/Con_Three_Broadcast.dart';
import 'package:nextapp/mdi_page/Wallpaper/chat_wallpaper.dart';

import '../../A_FB_Trigger/sql_need_broadcast_sub_msg.dart';
import '../../A_FB_Trigger/sql_need_main_sub_chat.dart';
import '../../Constant/Center_widget/grouped_list.dart';
import '../../Constant/Con_Profile_Get.dart';
import '../../Constant/Con_Wid.dart';
import '../../Constant/Image_picker/drishya_picker.dart';
import '../Message/Message_info/msg_info.dart';
import '../Message/msg_sub_show_media_list.dart';
import '../chat_mdi_page.dart';

class Con_Send_Broadcast extends StatefulWidget {
  late String id;
  late String name;
  late String image;
  late String br_exist_user;
  late String user_mast_id;

  Con_Send_Broadcast(
      this.id, this.name, this.image, this.br_exist_user, this.user_mast_id,
      {Key? key})
      : super(key: key);

  @override
  _Con_Send_Broadcast createState() => _Con_Send_Broadcast();
}

enum PopUpData { Info, Copy, Media, Search, Wallpaper, ClearChat }

class _Con_Send_Broadcast extends State<Con_Send_Broadcast> {
  _Con_Send_Broadcast();

  String selectpStrmess = "";
  List<Need_Broadcast_Sub_Msg> needs_mess_imfo = [];

  // int index = 0;
  String selectedmesstipe = "";
  String selectedmediasize = "";
  String selectedimagename = "";
  String selectedurl = "";
  bool isShowSticker = false,
      mBoolAppBarNew = false,
      Emojishow = false,
      iscenterdatehide = true,
      isSearching = false,
      mBoolMediaShare = false;
  final ScrollController _controller = ScrollController();
  final TextEditingController _txtcont = TextEditingController();
  final TextEditingController _searchQuery = TextEditingController();
  late final GalleryController controllerimage;
  List<Need_Broadcast_Sub_Msg> _needs_sub_broad = [];
  List broad_splitList = [];
  List<String> _selected_needs_sub_msg = [];
  List<Need_Broadcast_Sub_Msg> imageList = [];
  List<Need_Broadcast_Sub_Msg> videoList = [];
  List<Need_Broadcast_Sub_Msg> audioList = [];
  List<Need_Broadcast_Sub_Msg> docuList = [];
  String wallpaper = "";
  late StreamController<BoxEvent> _quick_rep_strm_con =
      StreamController<BoxEvent>();

  var _quick_rep_box;

  bool isLocal = false;

  getWallpaper() async {
    var data = await Con_Wid.mReadGlbWallpaper(widget.id);
    wallpaper = data['wallpaper'];
    isLocal = data['isLocal'];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _openBox();
    controllerimage = GalleryController();
    setState(() {
      broad_splitList = widget.br_exist_user.toString().split(',').toList();
    });
    _controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    setState(() {
      iscenterdatehide = true;
    });
    Future.delayed(Duration(seconds: 2)).then((value) {
      setState(() {
        iscenterdatehide = false;
      });
    });
  }

  @override
  dispose() {
    super.dispose();
    _selected_needs_sub_msg.clear();
    controllerimage.dispose();
    // _quick_rep_box.close();
    _quick_rep_strm_con.close();
    _controller.dispose();
  }

  Future<void> _openBox() async {
    _quick_rep_box = await SyncJSon.user_quick_rep_box();
    _quick_rep_strm_con = StreamController<BoxEvent>.broadcast();
    _quick_rep_box.watch().listen((event) => _quick_rep_strm_con.add(event));
  }

  void SetBroadData(List<Need_Contact> _needs) {
    if (broad_splitList.isNotEmpty) {
      setState(() {
        for (var i = 0; i < _needs.length; i++) {
          var contain = broad_splitList.where((element) =>
              element.toString() == _needs[i].user_mast_id.toString());
          if (contain.isNotEmpty) {
            _needs[i].is_broadcast = true;
          } else {
            _needs[i].is_broadcast = false;
          }
        }
        _needs.removeWhere((element) => element.is_broadcast == false);
      });
    }
  }

  Widget AppBarTitle() {
    if (_selected_needs_sub_msg.isNotEmpty) {
      return Text(
        "${_selected_needs_sub_msg.length} Selected",
        style: const TextStyle(
          fontSize: 14,
          color: Con_white,
        ),
      );
    } else {
      return Container();
    }
  }

  AppBar SelectedRecordAppBar(BuildContext context) {
    return AppBar(
      title: AppBarTitle(),
      leading: Con_Wid.mIconButton(
        icon: Own_Delete_Search,
        onPressed: () {
          mBoolMsgSelectMode = false;
          _selected_needs_sub_msg.clear();
          setState(() {});
        },
      ),
      // Con_Wid.mIconButton(
      //   icon: Own_ArrowBack,
      //   onPressed: () {
      //     mBoolMsgSelectMode = false;
      //     setState(
      //       () {
      //         _selected_needs_sub_msg.clear();
      //       },
      //     );
      //   },
      // ),
      actions: <Widget>[
        if (_selected_needs_sub_msg.isNotEmpty &&
            _selected_needs_sub_msg.length == 1)
          Con_Wid.mIconButton(
              onPressed: () async {
                needs_mess_imfo.clear();
                needs_mess_imfo = _needs_sub_broad
                    .where((e) => e.id == _selected_needs_sub_msg[0])
                    .toList();

                if (selectpStrmess == "1") {
                  List<Need_Main_Sub_Chat> Chatlist =
                      await SyncJSon.user_sub_main_chat_select();
                  List<msginfo> info = [];
                  for (Need_Main_Sub_Chat e in Chatlist) {
                    if (e.broadcast_id == widget.id &&
                        e.broadcast_bulk_id ==
                            needs_mess_imfo[0].broadcast_bulk_id) {
                      Need_Contact Userdata = Constants_List.need_contact
                          .firstWhere((u) =>
                              u.user_mast_id.toString() ==
                              e.msg_to_user_mast_id.toString());
                      info.add(msginfo(
                        mStrName: Userdata.name,
                        mStrProfile: Userdata.user_profileimage_path,
                        Userid: e.msg_to_user_mast_id,
                        ReadTime: e.read_time.toString(),
                        DeliverdTime: e.delivered_time.toString(),
                      ));
                    }
                  }
                  // print("dixithirpara");
                  // info.forEach((e) => print(msginfo.toJson(e)));
                  Navigator.push(
                      context,
                      RouteTransitions.slideTransition(msg_info(
                        Userlist: info,
                        msg_content: needs_mess_imfo[0].msg_content,
                        pStrBlurhash: "",
                        msg_type: selectedmesstipe,
                        is_alert: true,
                        send_time: needs_mess_imfo[0]
                            .date
                            .substring(needs_mess_imfo[0].date.length - 8),
                        Audioname: selectedimagename,
                        imagename: selectedurl,
                        mediasize: selectedmediasize,
                      )));
                }
              },
              icon: const Icon(Icons.info_outline)),
        if (_selected_needs_sub_msg.isNotEmpty)
          Con_Wid.mIconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    RouteTransitions.slideTransition(MdiMainPage(
                        selected_needs_sub_msg: _selected_needs_sub_msg)));
              },
              icon: Image.asset(
                'assets/images/forward.webp',
              )),
        Con_Wid.mIconButton(
            icon: Own_Delete_White,
            onPressed: () {
              var ids = _selected_needs_sub_msg.map((e) => e.trim()).join(",");
              setState(() {
                _selected_needs_sub_msg.map((e) => _needs_sub_broad.removeWhere(
                    (element) => element.id == e.toString().trim()));
              });
              sql_broadcast_tran.sub_broadcast_delete_clear(
                  widget.id,
                  ids,
                  Constants_Usermast.mBoolPopupSelect == true
                      ? "true"
                      : "false");
              Future.delayed(
                const Duration(milliseconds: 500),
                () => setState(
                  () {
                    mBoolMsgSelectMode = false;
                    _selected_needs_sub_msg.clear();
                  },
                ),
              );
            }),
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
                  if (mBoolMsgSelectMode) {
                    setState(
                      () {
                        for (var i = 0;
                            i < _selected_needs_sub_msg.length;
                            i++) {
                          if (_needs_sub_broad[i].msg_type == '1' ||
                              _needs_sub_broad[i].msg_type == '2' ||
                              _needs_sub_broad[i].msg_type == '3' ||
                              _needs_sub_broad[i].msg_type == '4') {
                            mBoolMsgSelectMode = true;
                            if (_selected_needs_sub_msg ==
                                _needs_sub_broad[i].id) {
                              _selected_needs_sub_msg
                                  .remove(_needs_sub_broad[i].id);
                            } else {
                              _selected_needs_sub_msg
                                  .add(_needs_sub_broad[i].id);
                            }
                          }
                        }
                      },
                    );
                  }
                  break;
                case PopUpData_Broad.UnselectAll:
                  if (mBoolMsgSelectMode) {
                    setState(
                      () {
                        _selected_needs_sub_msg.clear();
                        mBoolMsgSelectMode = false;
                      },
                    );
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
                    child: Text('Select All'),
                  )
                : const PopupMenuItem<PopUpData_Broad>(
                    value: PopUpData_Broad.UnselectAll,
                    child: Text('UnSelect All'),
                  ),
          ],
        )
      ],
    );
  }

  AppBar SearchAppBar(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return AppBar(
      titleSpacing: -2,
      leadingWidth: 48,
      leading: isSearching
          ? Con_Wid.mIconButton(
              icon: Own_ArrowBack,
              onPressed: () {
                setState(() {
                  isSearching = false;
                  _searchQuery.text = "";
                });
              },
            )
          : Con_Wid.mIconButton(
              icon: Own_ArrowBack,
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
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
              setState(() {});
            }),
        Con_Wid.mIconButton(
            icon: Own_Down,
            onPressed: () {
              setState(() {});
            }),
      ],
    );
  }

  // AppBar SelectedAppBar(BuildContext context) {
  //   return AppBar(
  //     titleSpacing: 0,
  //     title: Text(_selected_needs_sub_msg.length.toString()),
  //     leadingWidth: 45,
  //     leading: Con_Wid.mIconButton(
  //       icon: Own_ArrowBack,
  //       onPressed: () {
  //         setState(() {
  //           Navigator.pop(context);
  //         });
  //       },
  //     ),
  //     actions: <Widget>[
  //       if (_selected_needs_sub_msg.isNotEmpty)
  //         Con_Wid.mIconButton(onPressed: () {}, icon: Own_Delete_Search),
  //       _selected_needs_sub_msg.length == 1
  //           ? Con_Wid.mIconButton(
  //               onPressed: () {
  //                 Navigator.push(context, MaterialPageRoute(
  //                   builder: (context) {
  //                     return broad_msg_info(
  //                       broadcast_bulk_id:
  //                           _needs_sub_broad[index].broadcast_bulk_id,
  //                       br_id: widget.id,
  //                       br_exist_user: widget.br_exist_user,
  //                       is_read: _needs_sub_broad[index].is_read,
  //                       is_read_time: _needs_sub_broad[index].read_time,
  //                       is_delivered_time:
  //                           _needs_sub_broad[index].delivered_time,
  //                       msg_content: _needs_sub_broad[index].msg_content,
  //                       msg_type: "1",
  //                       send_time: _needs_sub_broad[index]
  //                           .date
  //                           .substring(_needs_sub_broad[index].date.length - 7),
  //                     );
  //                   },
  //                 ));
  //               },
  //               icon: const Icon(Icons.info_outline))
  //           : Container(),
  //       PopupMenuButton<PopUpData>(
  //         splashRadius: 20,
  //         onSelected: (PopUpData result) {
  //           setState(() {
  //             switch (result) {
  //               case PopUpData.Info:
  //                 Navigator.push(context, MaterialPageRoute(
  //                   builder: (context) {
  //                     return broad_msg_info(
  //                       broadcast_bulk_id:
  //                           _needs_sub_broad[index].broadcast_bulk_id,
  //                       br_id: widget.id.toString(),
  //                       br_exist_user: widget.br_exist_user,
  //                       is_read: _needs_sub_broad[index].is_read,
  //                       is_read_time: _needs_sub_broad[index].read_time,
  //                       is_delivered_time:
  //                           _needs_sub_broad[index].delivered_time,
  //                       msg_content: _needs_sub_broad[index].msg_content,
  //                       msg_type: "1",
  //                       send_time: _needs_sub_broad[index]
  //                           .date
  //                           .substring(_needs_sub_broad[index].date.length - 7),
  //                     );
  //                   },
  //                 ));
  //                 break;
  //               case PopUpData.Copy:
  //                 Clipboard.setData(ClipboardData(
  //                     text: (_needs_sub_broad[index]
  //                         .msg_content
  //                         .toString()
  //                         .trimRight()
  //                         .trimLeft()
  //                         .trimLeft())));
  //                 Fluttertoast.showToast(
  //                   msg: "Copied",
  //                   toastLength: Toast.LENGTH_SHORT,
  //                   gravity: ToastGravity.BOTTOM,
  //                 );
  //                 break;
  //               case PopUpData.Media:
  //                 break;
  //               case PopUpData.Search:
  //                 break;
  //               case PopUpData.Wallpaper:
  //                 break;
  //               case PopUpData.ClearChat:
  //                 break;
  //             }
  //           });
  //         },
  //         itemBuilder: (BuildContext context) => <PopupMenuEntry<PopUpData>>[
  //           const PopupMenuItem<PopUpData>(
  //               value: PopUpData.Info, child: Text('Info   ')),
  //           const PopupMenuItem<PopUpData>(
  //               value: PopUpData.Copy, child: Text('Copy   ')),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget PoupupMenuButtons() {
    return PopupMenuButton<PopUpData>(
      splashRadius: 20,
      onSelected: (PopUpData result) {
        setState(() {
          switch (result) {
            case PopUpData.Info:
              Navigator.push(
                  context,
                  RouteTransitions.slideTransition(Con_Broadcast(
                      widget.id.toString(),
                      widget.name.toString(),
                      widget.image,
                      true,
                      broad_splitList,
                      widget.br_exist_user.toString())));
              break;
            case PopUpData.Media:
              imageList = _needs_sub_broad
                  .where((element) =>
                      element.document_url != "null" && element.msg_type == "2")
                  .toList();
              videoList = _needs_sub_broad
                  .where((element) =>
                      element.document_url != "null" && element.msg_type == "5")
                  .toList();
              audioList = _needs_sub_broad
                  .where((element) =>
                      element.document_url != "null" && element.msg_type == "3")
                  .toList();
              docuList = _needs_sub_broad
                  .where((element) =>
                      element.document_url != "null" && element.msg_type == "4")
                  .toList();
              Navigator.push(
                  context,
                  RouteTransitions.slideTransition(MsgMediaList(
                      widget.id,
                      widget.name,
                      widget.user_mast_id,
                      imageList,
                      videoList,
                      audioList,
                      docuList)));
              break;
            case PopUpData.Search:
              setState(() {
                isSearching = true;
                _selected_needs_sub_msg.clear();
              });
              break;
            case PopUpData.Wallpaper:
              Navigator.push(context,
                  RouteTransitions.slideTransition(chat_wallpaper(widget.id, widget.name)));
              break;
            case PopUpData.ClearChat:
              ConfirmClear();
              break;
            case PopUpData.Copy:
              break;
          }
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<PopUpData>>[
        const PopupMenuItem<PopUpData>( height: 30,
            value: PopUpData.Info, child: Text('Broadcast list info')),
        const PopupMenuItem(
          height: 0,
          enabled: false,
          child: Divider(
            color: Con_Main_1,
          ),
        ),
        const PopupMenuItem<PopUpData>( height: 30,
            value: PopUpData.Media, child: Text('Broadcast list media')),
        const PopupMenuItem(
          height: 0,
          enabled: false,
          child: Divider(
            color: Con_Main_1,
          ),
        ),
        const PopupMenuItem<PopUpData>( height: 30,
            value: PopUpData.Search, child: Text('Search')),
        const PopupMenuItem(
          height: 0,
          enabled: false,
          child: Divider(
            color: Con_Main_1,
          ),
        ),
        const PopupMenuItem<PopUpData>( height: 30,
            value: PopUpData.Wallpaper, child: Text('Wallpaper')),
        const PopupMenuItem(
          height: 0,
          enabled: false,
          child: Divider(
            color: Con_Main_1,
          ),
        ),
        const PopupMenuItem<PopUpData>( height: 30,
          value: PopUpData.ClearChat,
          child: Text('Clear chat'),
        ),
      ],
    );
  }

  Future<bool> onBackPress() {
    Navigator.pushReplacement(
        context,
        RouteTransitions.slideTransition(MdiMainPage(
          tabindex: 2,
        )));

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    getWallpaper();
    imageList = _needs_sub_broad
        .where((element) =>
            element.document_url != "null" && element.msg_type == "2")
        .toList();
    videoList = _needs_sub_broad
        .where((element) =>
            element.document_url != "null" && element.msg_type == "5")
        .toList();
    audioList = _needs_sub_broad
        .where((element) =>
            element.document_url != "null" && element.msg_type == "3")
        .toList();
    docuList = _needs_sub_broad
        .where((element) =>
            element.document_url != "null" && element.msg_type == "4")
        .toList();
    return SlidableGallery(
      controller: controllerimage,
      child: WillPopScope(
        onWillPop: onBackPress,
        child: Scaffold(
          appBar: isSearching == true
              ? SearchAppBar(context)
              : (_selected_needs_sub_msg.isNotEmpty)
                  ? SelectedRecordAppBar(context)
                  : AppBar(
                      automaticallyImplyLeading: false,
                      leading: Con_Wid.mIconButton(
                        icon: Own_ArrowBack,
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              RouteTransitions.slideTransition(MdiMainPage(
                                tabindex: 2,
                              )));
                        },
                      ),
                      titleSpacing: -11,
                      leadingWidth: 42,
                      title: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                RouteTransitions.slideTransition(Con_Broadcast(
                                    widget.id.toString(),
                                    widget.name.toString(),
                                    widget.image,
                                    true,
                                    broad_splitList,
                                    widget.br_exist_user.toString())));
                          },
                          leading: Con_profile_get(
                            pStrImageUrl: widget.image,
                            Size: 40,
                            isbroadcast: true,
                          ),
                          title: Text(widget.name,
                              style: const TextStyle(
                                  color: Con_white,
                                  overflow: TextOverflow.ellipsis)),
                          subtitle: const Text(
                              "tap here for broadcast list info",
                              style: TextStyle(
                                  color: Con_white,
                                  overflow: TextOverflow.ellipsis))),
                      actions: <Widget>[
                        PoupupMenuButtons(),
                      ],
                    ),
          body: Container(
            decoration: Con_Wid.mGlbWallpaper(wallpaper, widget.id, isLocal),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: ChatData()),
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
                        },
                      )
                    : Container(),
                Con_Wid_Box(
                  controller: controllerimage,
                  messageType: MessageType.broadcast,
                  usermastid: "",
                  brodcastId: widget.id,
                  sender_name: widget.name,
                  onSendMessage: (String value) {
                    SendMessage(value);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _SearchListState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          isSearching = true;
        });
      } else {
        setState(() {
          isSearching = true;
        });
      }
    });
  }

  ConfirmClear() async {
    Con_Wid.mConfirmDialog(
        context: context,
        title: "Clear all chat",
        message:
            'Are you sure you want to clear all messages and media of from this chat ?',
        onOkPressed: () {
          setState(() {
            var ids = _needs_sub_broad.map((e) => e.id.trim()).join(",");
            setState(() {
              _selected_needs_sub_msg.map((e) => _needs_sub_broad
                  .removeWhere((element) => element.id == e.toString().trim()));
            });
            sql_broadcast_tran.sub_broadcast_delete_clear(
                widget.id, ids, "true");
            SharedPref.remove("BROAD_ID" + widget.id);
            Future.delayed(
              const Duration(milliseconds: 500),
              () => setState(
                () {
                  mBoolMsgSelectMode = false;
                  _selected_needs_sub_msg.clear();
                },
              ),
            );
          });
          Navigator.pop(context);
        },
        onCancelPressed: () {
          Navigator.pop(context);
        });
  }

  Widget _getGroupSeparator(Need_Broadcast_Sub_Msg e) {
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
              padding: const EdgeInsets.all(6.0),
              child: Text(
                pStrDate,
                style: const TextStyle(color:Con_msg_auto_6 ,

                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget ChatData() {
    return FutureBuilder(
        future: SyncJSon.user_msg_broadcast_select(widget.id),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          _needs_sub_broad = snapshot.hasData
              ? snapshot.data.reversed.toList() as List<Need_Broadcast_Sub_Msg>
              : [];
          _needs_sub_broad.sort(
            (b, a) => a.msg_timestamp
                .replaceAll(')/', '')
                .replaceAll('/Date(', '')
                .compareTo(b.msg_timestamp
                    .replaceAll(')/', '')
                    .replaceAll('/Date(', '')),
          );
          return GroupedListView<Need_Broadcast_Sub_Msg, DateTime>(
            reverse: true,
            physics: BouncingScrollPhysics(),
            elements: _needs_sub_broad,
            order: GroupedListOrder.DESC,
            controller: _controller,
            IsDatehide: iscenterdatehide,
            useStickyGroupSeparators: true,
            groupBy: (Need_Broadcast_Sub_Msg e) => DateTime(
              DateFormat("MMM dd yyyy hh:mm a").parse(e.date).year,
              DateFormat("MMM dd yyyy hh:mm a").parse(e.date).month,
              DateFormat("MMM dd yyyy hh:mm a").parse(e.date).day,
            ),
            floatingHeader: true,
            sort: true,
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
                  "",
                  "",
                  _searchQuery.text,
                  "Broad",
                  "", onSelected: (List<String> value) {
                _selected_needs_sub_msg = value;
                selectpStrmess = chat.is_right;
                selectedmesstipe = chat.msg_type;
                selectedimagename = chat.msg_audio_name;
                selectedurl = chat.document_url;
                selectedmediasize = chat.msg_media_size;
              });
            },
          );
        });
  }

  Future<void> SendMessage(String Value) async {
    try {
      print({ 'msg_content': Value,
          'msg_type': "1",
          'msg_document_url': "",
          'from_id': Constants_Usermast.user_id,
          'to_id': "",
          'is_broadcast': "1",
          'broadcast_id': widget.id.toString()});
      await sql_sub_messages_tran.Send_Msg(
          msg_content: Value,
          msg_type: "1",
          msg_document_url: "",
          from_id: Constants_Usermast.user_id,
          to_id: "",
          is_broadcast: "1",
          broadcast_id: widget.id.toString());
      SyncDB.SyncTable(Constants.Table_Msg_broadcast, false);
      _controller.jumpTo(_controller.position.minScrollExtent);
    } catch (e) {
      print("Brod_msg_not_send $e");
    }
  }
}
