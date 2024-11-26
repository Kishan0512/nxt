import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:nextapp/A_FB_Trigger/SharedPref.dart';
import 'package:nextapp/Constant/Con_Clr.dart';
import 'package:nextapp/Constant/Con_Icons.dart';
import 'package:nextapp/Constant/Constants.dart';
import 'package:nextapp/Emoji/emoji_widget.dart';
import 'package:nextapp/Media/Media_Picker.dart';
import 'package:nextapp/mdi_page/A_ChatBubble/ImageBubble.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../Constant/Image_picker/drishya_picker.dart';
import '../A_FB_Trigger/sql_need_quickreply.dart';
import '../ExtraDarts/widget/auto_scroll.dart';
import '../OSFind.dart';
import '../Settings/Folders/Folder.dart';
import 'Con_AppBar_ChatProfile.dart';

class Con_Wid {
  static Map Ticks_Style_1 = {
    'delivered': 'assets/images/Delivered_1.webp',
    'send': 'assets/images/Send_1.webp',
  };

  static Map Ticks_Style_2 = {
    'delivered': 'assets/images/Delivered_2.webp',
    'send': 'assets/images/Send_3.webp',
  };
  static Map Ticks_Style_3 = {
    'delivered': 'assets/images/Delivered_3.webp',
    'send': 'assets/images/Send_3.webp',
  };
  static Map Ticks_Style_4 = {
    'delivered': 'assets/images/Delivered_4.webp',
    'send': 'assets/images/Send_4.webp',
  };


  static Widget mAppBar(String pStrText) {
    return Text(pStrText);
  }

  static Widget buildInput_Suggestion(
    _quick_rep_strm_con,
    _quick_rep_box, {
    required ValueChanged<String> SendMessage,
  }) {
    return StreamBuilder<BoxEvent>(
      stream: _quick_rep_strm_con.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container();
        }
        List<Need_QuickReply> v = _quick_rep_box != null
            ? _quick_rep_box!.values.toList().cast<Need_QuickReply>()
            : [];
        return Container(
          color: Con_transparent,
          height: v.isEmpty ? 0 : 44.0,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 4.0),
            scrollDirection: Axis.horizontal,
            itemCount: v.length,
            itemBuilder: (context, index) {
              var QuickValue = v[index]
                  .user_quick_value
                  .toString()
                  .trim()
                  .trimLeft()
                  .trimRight();
              return GestureDetector(
                onTap: () {
                  SendMessage.call(QuickValue);
                },
                child: Container(
                  child: Wrap(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(4.0),
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.0,
                                color: getPlatformBrightness()
                                    ? Dark_ChatFieldBorder
                                    : Con_black),
                            color: getPlatformBrightness()
                                ? Dark_ChatFieldIcon
                                : Con_white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30.0))),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: GestureDetector(
                            onTap: () {
                              SendMessage.call(QuickValue);
                            },
                            child: Material(
                              color: Con_transparent,
                              child: Text(
                                QuickValue,
                                style: const TextStyle(
                                    fontSize: 14.0, color: Con_black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  static Future mConfirmDialog(
      {required String title,
      required context,
      required String message,
      required VoidCallback onCancelPressed,
      required VoidCallback onOkPressed}) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title,style: TextStyle(fontSize: 18,fontFamily: "Inter",color: Con_msg_auto_6,fontWeight: FontWeight.bold)),
              content: Text(message),
              actions: [
                Container(
                  child: OutlinedButton(
                    child: const Text("Cancel"),
                    onPressed: onCancelPressed,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  child: OutlinedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Con_msg_auto_6))
                    ,
                    child: const Text("Ok",style: TextStyle(color: Con_white)),
                    onPressed: onOkPressed,
                  ),
                )
              ],
            ));
  }

  static Widget mIconButton(
      {required VoidCallback onPressed,
      required Widget icon,
      double? iconSize,
      Color? color}) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      splashRadius: 20,
      iconSize: iconSize,
      color: color,
    );
  }

  static Future<Map<String, dynamic>> mReadGlbWallpaper(
      String pStrUserId) async {
    var isLocal = false;
    String wallpaper = await SharedPref.read_string("wall_" + pStrUserId);
    if (wallpaper.isEmpty) {
      wallpaper = await SharedPref.read_string("wall_default");
      isLocal = false;
      if (wallpaper.isEmpty) {
        wallpaper = getPlatformBrightness()
            ? 'assets/solid/Dark_Frame 142.webp'
            : 'assets/solid/default.webp';
      }
    } else {
      isLocal = true;
    }
    return {"wallpaper": wallpaper, "isLocal": isLocal};
  }

  static BoxDecoration mGlbWallpaper(
      String pWallpaper, String usermastid, bool isLocal) {
    if (pWallpaper.contains("com.app.nextapp") &&
        File(pWallpaper).existsSync()) {
      return BoxDecoration(
          image: DecorationImage(
              image: FileImage(File(pWallpaper)), fit: BoxFit.fill));
    } else {
      if (pWallpaper.contains("com.app.nextapp")) {
        if (isLocal == false && usermastid.isEmpty) {
          SharedPref.remove_key("wall_default");
          return BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(getPlatformBrightness()
                      ? 'assets/solid/Dark_Frame 142.webp'
                      : 'assets/solid/default.webp'),
                  fit: BoxFit.fill));
        } else {
          SharedPref.remove_key("wall_$usermastid");
          return BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(pWallpaper), fit: BoxFit.fill));
        }
      }
      return BoxDecoration(
          image:
              DecorationImage(image: AssetImage(pWallpaper), fit: BoxFit.fill));
    }
  }

  static BoxDecoration mGlbWallpaperSelection(int index, bool isFile) {
    return BoxDecoration(
      image: isFile
          ? DecorationImage(
              image: FileImage(File(Constants.wallpaperFiles[index].path)),
              fit: BoxFit.fill)
          : DecorationImage(
              image: AssetImage((getPlatformBrightness()
                  ? Constants.Dark_Solid_Color[index]
                  : Constants.Light_Solid_Color[index])),
              fit: BoxFit.fill),
    );
  }

  static Future<Object> downloadProfileImage(pStrImageUrl, pStrFileName) async {
    if (pStrImageUrl.toString().isEmpty) {
      return Constants();
    }
    String pStrReturnAssetPath = "";
    try {
      Directory? documentDirectory = await getExternalStorageDirectory();

      Directory(documentDirectory!.path + "Profile").create();
      String pStrLocPath = documentDirectory.path + "Profile";
      File file = File(pStrLocPath + "/$pStrFileName.png");
      if (await file.exists()) {
        pStrReturnAssetPath = file.path;
      } else {
        var response = await http.get(Uri.parse(pStrImageUrl));
        file.writeAsBytesSync(response.bodyBytes, mode: FileMode.append);
        pStrReturnAssetPath = file.path;
      }
    } catch (e) {
      print(e);
    }
    return pStrReturnAssetPath;
  }
}

class Con_Wid_Box extends StatefulWidget {
  MessageType messageType;
  String usermastid, serverKey, brodcastId, sender_name;
  ValueChanged<String> onSendMessage;
  VoidCallback? onTap;
  bool? ismedia;
  GalleryController? controller;

  Con_Wid_Box(
      {Key? key,
      required this.messageType,
      required this.usermastid,
      required this.onSendMessage,
      required this.sender_name,
      this.onTap,
      this.controller,
      this.ismedia,
      this.serverKey = "",
      this.brodcastId = ""})
      : super(key: key);

  @override
  State<Con_Wid_Box> createState() => _Con_Wid_BoxState();
}

class _Con_Wid_BoxState extends State<Con_Wid_Box> {
  bool isShowSticker = false, mBoolMediaShare = false, Emojishow = false;
  final TextEditingController _txtcont = TextEditingController();

  @override
  void initState() {
    if (widget.messageType == MessageType.broadcast) {
      if (widget.brodcastId == "") {
        throw AssertionError(
            "broadcastId required in case of MessageType.broadcast");
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WillPopScope(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: buildInput(),
              ),
            ],
          ),
          onWillPop: onBackPress,
        ),
        Offstage(
          offstage: !Emojishow,
          child: SizedBox(
            height: 255,
            child: Emoji_Widget(controller: _txtcont),
          ),
        ),
        Container(
          color: getPlatformBrightness() ? Dark_MediaBox : Con_white,
          child: Offstage(
            offstage: !mBoolMediaShare,
            child: SizedBox(
              height: 60,
              child: widget.messageType == MessageType.chat
                  ? Media_Widget(
                      widget.usermastid,
                      "0",
                      widget.serverKey,
                      sender_name: widget.sender_name,
                      MediaShare: (value) {
                        setState(() {
                          mBoolMediaShare = value;
                        });
                      },
                      controller: widget.controller,
                    )
                  : Media_Widget(
                      "1",
                      widget.brodcastId,
                      widget.serverKey,
                      sender_name: widget.sender_name,
                      MediaShare: (value) {
                        setState(() {
                          mBoolMediaShare = value;
                        });
                      },
                      controller: widget.controller,
                    ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildInput() {
    return Os.isIOS? WillPopScope(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 50.0,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      color: getPlatformBrightness()
                          ? Dark_ChatFieldBorder
                          : LightTheme_White),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Material(
                        child: Container(
                          child: Con_Wid.mIconButton(
                            icon: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: getPlatformBrightness()
                                            ? Dark_ChatFieldIcon
                                            : Chat_MsgBox),
                                    shape: BoxShape.circle),
                                child: AnimatedRotation(
                                  turns: mBoolMediaShare ? 0.13 : 0,
                                  duration: const Duration(milliseconds: 400),
                                  child: Icon(
                                    Icons.add,
                                    color: getPlatformBrightness()
                                        ? Dark_ChatFieldIcon
                                        : AppBar_ThemeColor,
                                  ),
                                )),
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {});
                              widget.controller!.ClosePenal();
                              mBoolMediaShare = !mBoolMediaShare;
                              Emojishow = false;
                              setState(() {});
                            },
                            color: AppBlueGreyColor2,
                          ),
                        ),
                        color: Con_transparent,
                      ),
                      Flexible(
                        child: Container(
                          height: 36,
                          padding: const EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Chat_MsgBox),
                          child: Material(
                            color: Con_transparent,
                            child: TextField(
                              maxLines: null,
                              onTap: () {
                                widget.onTap!.call();
                                widget.controller!.ClosePenal();
                                setState(() {
                                  Emojishow = false;
                                  mBoolMediaShare = false;
                                });
                              },
                              controller: _txtcont,
                              style: const TextStyle(
                                  fontSize: 14, color: Chat_ReadColor),
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: widget.messageType == MessageType.chat
                                    ? 'Type your message...'
                                    : 'Broadcast a message...',
                                hintStyle: const TextStyle(fontSize: 14),
                                border: InputBorder.none,
                                suffixIcon: Material(
                                  child: Con_Wid.mIconButton(
                                    icon: Center(
                                      child: Icon(Own_Face,
                                          size: 22,
                                          color: Emojishow == true
                                              ? AppBar_ThemeColor
                                              : null),
                                    ),
                                    onPressed: () async {
                                      isShowSticker = !isShowSticker;
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      setState(() {});
                                      await Future.delayed(
                                          const Duration(milliseconds: 50));
                                      setState(() {
                                        Emojishow = !Emojishow;
                                        mBoolMediaShare = false;
                                        widget.controller!.ClosePenal();
                                      });
                                    },
                                    color: AppBlueGreyColor2,
                                  ),
                                  color: Con_transparent,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: Con_Wid.mIconButton(
                            icon: AnimatedRotation(
                              turns: _txtcont.text.isEmpty ? 0 : 0.12,
                              duration: const Duration(milliseconds: 200),
                              child: _txtcont.text.isEmpty
                                  ? Image.asset(
                                      "assets/images/Send_Icon-1.webp",
                                    )
                                  : Image.asset(
                                      "assets/images/Send_Icon-2.webp",
                                    ),
                            ),
                            onPressed: () async {
                              setState(() {
                                mBoolMediaShare = false;
                                if ((_txtcont.text.trim() == "" ||
                                        _txtcont.text.isEmpty) &&
                                    (widget.ismedia ?? false) == false) {
                                  Fluttertoast.showToast(
                                    msg: 'Nothing to send',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                  );
                                  return;
                                } else {
                                  widget.onSendMessage(_txtcont.text);
                                  _txtcont.clear();
                                }
                              });
                            },
                            color: AppBlueGreyColor2,
                          ),
                        ),
                        color: Con_transparent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onWillPop: onBackPress):WillPopScope(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 50.0,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      color: getPlatformBrightness()
                          ? Dark_ChatFieldBorder
                          : LightTheme_White),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Material(
                        child: Container(
                          child: Con_Wid.mIconButton(
                            icon: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: getPlatformBrightness()
                                            ? Dark_ChatFieldIcon
                                            : Chat_MsgBox),
                                    shape: BoxShape.circle),
                                child: AnimatedRotation(
                                  turns: mBoolMediaShare ? 0.13 : 0,
                                  duration: const Duration(milliseconds: 400),
                                  child: Icon(
                                    Icons.add,
                                    color: getPlatformBrightness()
                                        ? Dark_ChatFieldIcon
                                        : AppBar_ThemeColor,
                                  ),
                                )),
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {});
                              widget.controller!.ClosePenal();
                              mBoolMediaShare = !mBoolMediaShare;
                              Emojishow = false;
                              setState(() {});
                            },
                            color: AppBlueGreyColor2,
                          ),
                        ),
                        color: Con_transparent,
                      ),
                      Flexible(
                        child: Container(
                          height: 36,
                          padding: const EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Chat_MsgBox),
                          child: Material(
                            color: Con_transparent,
                            child: CupertinoTextField(
                              maxLines: null,
                              onTap: () {
                                widget.onTap!.call();
                                widget.controller!.ClosePenal();
                                setState(() {
                                  Emojishow = false;
                                  mBoolMediaShare = false;
                                });
                              },
                              controller: _txtcont,
                              placeholder: widget.messageType == MessageType.chat
                                  ? 'Type your message...'
                                  : 'Broadcast a message...',
                              placeholderStyle: TextStyle(fontSize: 14),
                              suffix: Material(
                                child: Con_Wid.mIconButton(
                                  icon: Center(
                                    child: Icon(Own_Face,
                                        size: 22,
                                        color: Emojishow == true
                                            ? AppBar_ThemeColor
                                            : null),
                                  ),
                                  onPressed: () async {
                                    isShowSticker = !isShowSticker;
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    setState(() {});
                                    await Future.delayed(
                                        const Duration(milliseconds: 50));
                                    setState(() {
                                      Emojishow = !Emojishow;
                                      mBoolMediaShare = false;
                                      widget.controller!.ClosePenal();
                                    });
                                  },
                                  color: AppBlueGreyColor2,
                                ),
                                color: Con_transparent,
                              ) ,
                              style: const TextStyle(
                                  fontSize: 14, color: Chat_ReadColor),
                              
                              decoration: BoxDecoration(
                                border: Border.fromBorderSide(BorderSide.none),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: Con_Wid.mIconButton(
                            icon: AnimatedRotation(
                              turns: _txtcont.text.isEmpty ? 0 : 0.12,
                              duration: const Duration(milliseconds: 200),
                              child: _txtcont.text.isEmpty
                                  ? Image.asset(
                                "assets/images/Send_Icon-1.webp",
                              )
                                  : Image.asset(
                                "assets/images/Send_Icon-2.webp",
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                mBoolMediaShare = false;
                                if ((_txtcont.text.trim() == "" ||
                                    _txtcont.text.isEmpty) &&
                                    (widget.ismedia ?? false) == false) {
                                  Fluttertoast.showToast(
                                    msg: 'Nothing to send',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                  );
                                  return;
                                } else {
                                  widget.onSendMessage(_txtcont.text);
                                  _txtcont.clear();
                                }
                              });
                            },
                            color: AppBlueGreyColor2,
                          ),
                        ),
                        color: Con_transparent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onWillPop: onBackPress);
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }
    return Future.value(false);
  }
}

enum MessageType { chat, broadcast }

class Third_Audio extends StatefulWidget {
  List AudioList;
  bool isSelected;
  List<String> mListSelected_id;
  ValueChanged<bool> onSelected;
  ValueChanged<List<String>> Selected_id;

  Third_Audio(this.AudioList, this.isSelected, this.mListSelected_id,
      this.onSelected, this.Selected_id,
      {super.key});

  @override
  State<Third_Audio> createState() => _Third_AudioState();
}

class _Third_AudioState extends State<Third_Audio> {
  final AudioPlayer _player = AudioPlayer();
  bool mblnSelect = false;
  List<bool> SelectedList = [];
  List<String> mListSelected_id = [];

  bool play = false;
  List<bool> playbutton = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playbutton = List.filled(widget.AudioList.length, false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _player.pause();
  }

  @override
  Widget build(BuildContext context) {
    mblnSelect = widget.isSelected;
    mListSelected_id = widget.mListSelected_id;
    if (widget.AudioList.isNotEmpty) {
      return ListView.builder(
        itemCount: widget.AudioList.length,
        itemBuilder: (context, index) {
          String centerdatetwo = "", centerdate = "";
          bool showtime = true;
          centerdate = widget.AudioList[index].date.substring(0, 11);
          if (index != 0) {
            centerdatetwo = widget.AudioList[(index - 1)].date.substring(0, 11);
            if (widget.AudioList.length == 2) {
              if (widget.AudioList.where(
                          (e) => e.date.substring(0, 11) == centerdatetwo)
                      .first
                      .id ==
                  widget.AudioList[index].id) {
                showtime = true;
              } else {
                showtime = false;
              }
            } else {
              if (widget.AudioList.where(
                          (e) => e.date.substring(0, 11) == centerdatetwo)
                      .first
                      .id ==
                  widget.AudioList[index].id) {
                showtime = true;
              } else {
                showtime = false;
              }
            }
          }
          if (!mblnSelect) {
            SelectedList = List.filled(widget.AudioList.length, false);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              showtime
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: Material(
                        color: Con_transparent,
                        child: Text(
                          centerdate,
                          style: TextStyle(
                              fontSize: Constants_Fonts.mGblFontSubTitleSize,
                              color: getPlatformBrightness()
                                  ? Dark_AppGreyColor
                                  : AppGreyColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ))
                  : Container(),
              Column(
                children: [
                  Material(
                    color: Con_transparent,
                    child: ListTile(
                      visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity),
                      onLongPress: () {
                        if (!mblnSelect) {
                          setState(() {
                            mblnSelect = true;
                            widget.onSelected.call(mblnSelect);
                            SelectedList[index] = true;
                            mListSelected_id.add(widget.AudioList[index].id);
                            widget.Selected_id.call(mListSelected_id);
                          });
                        }
                      },
                      onTap: () {
                        setState(() {
                          SelectedList[index] = !SelectedList[index];

                          if (!mListSelected_id
                              .contains(widget.AudioList[index].id)) {
                            mListSelected_id.add(widget.AudioList[index].id);
                            widget.Selected_id.call(mListSelected_id);
                          } else {
                            mListSelected_id.remove(widget.AudioList[index].id);
                            widget.Selected_id.call(mListSelected_id);
                          }
                          if (mListSelected_id.isEmpty) {
                            mblnSelect = false;
                            widget.Selected_id.call(mListSelected_id);
                            widget.onSelected.call(mblnSelect);
                          }
                        });
                      },
                      selected: SelectedList[index] == true,
                      selectedTileColor: Selected_tileColor,
                      selectedColor: AppBar_ThemeColor,
                      trailing: Container(
                        decoration: const BoxDecoration(
                            color: Con_black12, shape: BoxShape.circle),
                        height: 30,
                        width: 30,
                        child: Center(
                            child: Con_Wid.mIconButton(
                          icon: playbutton[index]
                              ? Own_audio_pause
                              : Own_audio_play,
                          onPressed: () async {
                            if (playbutton[index]) {
                              _player.stop();
                              playbutton[index] = false;
                              setState(() {});
                            } else {
                              playbutton =
                                  List.filled(widget.AudioList.length, false);

                              getPdfFile(index);
                            }
                          },
                        )),
                      ),
                      title: TextScroll(
                          "${widget.AudioList[index].msg_audio_name}            "),
                      leading: CircleAvatar(
                        child: Image.asset("assets/images/no_cover1.webp",
                            color: AppBar_ThemeColor),
                      ),
                      subtitle:
                          Text("${widget.AudioList[index].msg_media_size}"),
                    ),
                  )
                ],
              ),
            ],
          );
        },
      );
    } else {
      return Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: Image.asset('assets/images/No-Media.webp'),
        ),
      );
    }
  }

  Future<void> getPdfFile(int index) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      File file = File(
          "${Folder.audio.path}/${widget.AudioList[index].msg_audio_name}");
      if (!file.existsSync()) {
        await file.create(recursive: true);
        ByteData data = await rootBundle.load(
            "${Folder.audio.path}/${widget.AudioList[index].msg_audio_name}");
        await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
      }
      if (file.existsSync()) {
        int result = await _player.play(file.path, isLocal: true);
        if (result == 1) {
          playbutton[index] = true;
          setState(() {});
        } else {}
      }
    } catch (e) {
      print("audio_error $e");
    }
  }
}

class MediaList {
  MediaList();
}

class First_Photos extends StatefulWidget {
  List imageList;
  String media;
  String? pStrFromName;
  bool isSelected;
  List mListSelected;
  ValueChanged<bool> onSelected;
  ValueChanged<List> Selected;

  First_Photos(this.imageList, this.media, this.isSelected, this.mListSelected,
      this.onSelected, this.Selected,
      [this.pStrFromName]);

  @override
  State<First_Photos> createState() => _First_PhotosState();
}

class _First_PhotosState extends State<First_Photos> {
  bool mblnSelect = false;
  List<List<bool>> SelectedList = [];
  List mListSelected = [];

  @override
  Widget build(BuildContext context) {
    List<String> centerdate = [];
    List<List> Datalist = [];
    mblnSelect = widget.isSelected;
    mListSelected = widget.mListSelected;

    for (int i = 0; i < widget.imageList.length; i++) {
      if (widget.imageList.length != 1) {
        String centerdatetwo = "";
        if (i != 0) {
          centerdatetwo = widget.imageList[(i - 1)].date.substring(0, 11);
          if (widget.imageList
                  .where((e) => e.date.substring(0, 11) == centerdatetwo)
                  .last
                  .id ==
              widget.imageList[i].id) {
            Datalist.add(widget.imageList
                .where((e) => e.date.substring(0, 11) == centerdatetwo)
                .toList());
            centerdate.add(Datalist.where(
                    (e) => e[0].date.substring(0, 11) == centerdatetwo)
                .last[0]
                .date
                .substring(0, 11));
          }
        } else {
          if (widget.imageList[(i)].date.substring(0, 11).toString() !=
              widget.imageList[(i + 1)].date.substring(0, 11).toString()) {
            Datalist.add(widget.imageList
                .where((e) =>
                    e.date.substring(0, 11) ==
                    widget.imageList[i].date.substring(0, 11).toString())
                .toList());
            centerdate.add(Datalist.where((e) =>
                    e[0].date.substring(0, 11) ==
                    widget.imageList[i].date.substring(0, 11).toString())
                .last[0]
                .date
                .substring(0, 11));
          }
        }
      } else {
        Datalist.add(widget.imageList
            .where((e) =>
                e.date.substring(0, 11) ==
                widget.imageList[i].date.substring(0, 11).toString())
            .toList());
        centerdate.add(Datalist.where((e) =>
                e[0].date.substring(0, 11) ==
                widget.imageList[i].date.substring(0, 11).toString())
            .last[0]
            .date
            .substring(0, 11));
      }
    }
    if (Datalist.isNotEmpty) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: Datalist.length,
                itemBuilder: (context, index) {
                  if (!mblnSelect) {
                    SelectedList = List.generate(Datalist.length,
                        (index) => List.filled(Datalist[index].length, false));
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Datalist.isNotEmpty
                          ? Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              child: Text(
                                centerdate[index],
                                style: TextStyle(
                                    fontSize:
                                        Constants_Fonts.mGblFontSubTitleSize,
                                    color: getPlatformBrightness()
                                        ? Dark_AppGreyColor
                                        : AppGreyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : Container(),
                      Datalist.isNotEmpty
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),
                              itemCount: Datalist[index].length,
                              itemBuilder: (context, index1) {
                                Datalist[index]
                                    .where((e) => e == true)
                                    .map((e) => print(e));
                                return InkWell(
                                  onLongPress: () {
                                    if (!mblnSelect) {
                                      setState(() {
                                        mblnSelect = true;
                                        widget.onSelected.call(mblnSelect);
                                        SelectedList[index][index1] = true;
                                        mListSelected
                                            .add(Datalist[index][index1]);
                                        widget.Selected.call(mListSelected);
                                      });
                                    }
                                  },
                                  onTap: mblnSelect
                                      ? () {
                                          setState(() {
                                            SelectedList[index][index1] =
                                                !SelectedList[index][index1];

                                            if (!mListSelected.contains(
                                                Datalist[index][index1])) {
                                              mListSelected
                                                  .add(Datalist[index][index1]);
                                              widget.Selected.call(
                                                  mListSelected);
                                            } else {
                                              mListSelected.remove(
                                                  Datalist[index][index1]);
                                              widget.Selected.call(
                                                  mListSelected);
                                            }
                                            if (mListSelected.isEmpty) {
                                              mblnSelect = false;
                                              widget.Selected.call(
                                                  mListSelected);
                                              widget.onSelected
                                                  .call(mblnSelect);
                                            }
                                          });
                                        }
                                      : () async {
                                          var imagePath = Datalist[index]
                                                          [index1]
                                                      .isRight
                                                      .toString() ==
                                                  '1'
                                              ? "${Folder.sentMedia.path}/${Datalist[index][index1].msg_audio_name}"
                                              : "${Folder.images.path}/${Datalist[index][index1].msg_audio_name}";

                                          if (await File(imagePath).exists()) {
                                            Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder: (context,
                                                          animation,
                                                          SecondaryAnimation) =>
                                                      sub_show_photos_details(
                                                    imagePath,
                                                    isLocal: true,
                                                    isRight: Datalist[index]
                                                            [index1]
                                                        .isRight,
                                                    pStrFromName:
                                                        widget.pStrFromName,
                                                    pStrMediaName:
                                                        Datalist[index][index1]
                                                            .msg_audio_name,
                                                    pStrDate: Datalist[index]
                                                            [index1]
                                                        .date,
                                                  ),
                                                  transitionsBuilder: (context,
                                                      animation,
                                                      SecondaryAnimation,
                                                      child) {
                                                    return SizeTransition(
                                                      sizeFactor: animation,
                                                      child: child,
                                                    );
                                                  },
                                                ));
                                          } else {}
                                        },
                                  child: Stack(
                                    children: [
                                      ImageBubble(
                                        imageUrl: Datalist[index][index1]
                                            .document_url,
                                        isVideo: false,
                                        imageName: Datalist[index][index1]
                                            .msg_audio_name,
                                        blurhash: Datalist[index][index1]
                                            .msg_blurhash,
                                        isRight:
                                            Datalist[index][index1].is_right,
                                        pStrFromName: widget.pStrFromName,
                                        pStrdate: Datalist[index][index1].date,
                                      ),
                                      SelectedList[index][index1] == true
                                          ? Container(
                                              height: double.infinity,
                                              width: double.infinity,
                                              color: getPlatformBrightness()
                                                  ? Dark_Divider_Shadow
                                                  : Con_black45,
                                              child: Own_Save_white,
                                            )
                                          : Container(),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Container(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: Image.asset('assets/images/No-Media.webp'),
        ),
      );
    }
  }
}

class Second_Videos extends StatefulWidget {
  List videoList;
  String? pStrFromName;
  bool isSelected;
  List<String> mListSelected_id;
  ValueChanged<bool> onSelected;
  ValueChanged<List<String>> Selected_id;

  Second_Videos(this.videoList, this.isSelected, this.mListSelected_id,
      this.onSelected, this.Selected_id,
      [this.pStrFromName]);

  @override
  State<Second_Videos> createState() => _Second_VideosState();
}

class _Second_VideosState extends State<Second_Videos> {
  bool mblnSelect = false;
  List<List<bool>> SelectedList = [];
  List<String> mListSelected_id = [];

  @override
  Widget build(BuildContext context) {
    List<String> centerdate = [];
    List<List> Datalist = [];
    mblnSelect = widget.isSelected;
    mListSelected_id = widget.mListSelected_id;

    for (int i = 0; i < widget.videoList.length; i++) {
      if (widget.videoList.length != 1) {
        String centerdatetwo = "";
        if (i != 0) {
          centerdatetwo = widget.videoList[(i - 1)].date.substring(0, 11);
          if (widget.videoList
                  .where((e) => e.date.substring(0, 11) == centerdatetwo)
                  .last
                  .id ==
              widget.videoList[i].id) {
            Datalist.add(widget.videoList
                .where((e) => e.date.substring(0, 11) == centerdatetwo)
                .toList());
            centerdate.add(Datalist.where(
                    (e) => e[0].date.substring(0, 11) == centerdatetwo)
                .last[0]
                .date
                .substring(0, 11));
          }
        } else {
          if (widget.videoList[(i)].date.substring(0, 11).toString() !=
              widget.videoList[(i + 1)].date.substring(0, 11).toString()) {
            Datalist.add(widget.videoList
                .where((e) =>
                    e.date.substring(0, 11) ==
                    widget.videoList[i].date.substring(0, 11).toString())
                .toList());
            centerdate.add(Datalist.where((e) =>
                    e[0].date.substring(0, 11) ==
                    widget.videoList[i].date.substring(0, 11).toString())
                .last[0]
                .date
                .substring(0, 11));
          }
        }
      } else {
        Datalist.add(widget.videoList
            .where((e) =>
                e.date.substring(0, 11) ==
                widget.videoList[i].date.substring(0, 11).toString())
            .toList());
        centerdate.add(Datalist.where((e) =>
                e[0].date.substring(0, 11) ==
                widget.videoList[i].date.substring(0, 11).toString())
            .last[0]
            .date
            .substring(0, 11));
      }
    }

    if (Datalist.isNotEmpty) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: Datalist.length,
                itemBuilder: (context, index) {
                  if (!mblnSelect) {
                    SelectedList = List.generate(Datalist.length,
                        (index) => List.filled(Datalist[index].length, false));
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Datalist.isNotEmpty
                          ? Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              child: Text(
                                centerdate[index],
                                style: TextStyle(
                                    fontSize:
                                        Constants_Fonts.mGblFontSubTitleSize,
                                    color: getPlatformBrightness()
                                        ? Dark_AppGreyColor
                                        : AppGreyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : Container(),
                      Datalist.isNotEmpty
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),
                              itemCount: Datalist[index].length,
                              itemBuilder: (context, index1) {
                                return InkWell(
                                  onLongPress: () {
                                    if (!mblnSelect) {
                                      setState(() {
                                        mblnSelect = true;
                                        widget.onSelected.call(mblnSelect);
                                        SelectedList[index][index1] = true;
                                        mListSelected_id
                                            .add(Datalist[index][index1].id);
                                        widget.Selected_id.call(
                                            mListSelected_id);
                                      });
                                    }
                                  },
                                  onTap: mblnSelect
                                      ? () {
                                          setState(() {
                                            SelectedList[index][index1] =
                                                !SelectedList[index][index1];
                                            if (!mListSelected_id.contains(
                                                Datalist[index][index1].id)) {
                                              mListSelected_id.add(
                                                  Datalist[index][index1].id);
                                              widget.Selected_id.call(
                                                  mListSelected_id);
                                            } else {
                                              mListSelected_id.remove(
                                                  Datalist[index][index1].id);
                                              widget.Selected_id.call(
                                                  mListSelected_id);
                                            }
                                            if (mListSelected_id.isEmpty) {
                                              mblnSelect = false;
                                              widget.Selected_id.call(
                                                  mListSelected_id);
                                              widget.onSelected
                                                  .call(mblnSelect);
                                            }
                                          });
                                        }
                                      : () {},
                                  child: Stack(
                                    children: [
                                      ImageBubble(
                                        imageUrl: Datalist[index][index1]
                                            .document_url,
                                        isVideo: true,
                                        imageName: Datalist[index][index1]
                                            .msg_audio_name,
                                        blurhash: Datalist[index][index1]
                                            .msg_blurhash,
                                        pStrdate: Datalist[index][index1].date,
                                        pStrFromName: widget.pStrFromName,
                                        selected: mblnSelect,
                                        isRight:
                                            Datalist[index][index1].is_right,
                                      ),
                                      SelectedList[index][index1] == true
                                          ? Container(
                                              height: double.infinity,
                                              width: double.infinity,
                                              color: getPlatformBrightness()
                                                  ? Dark_Divider_Shadow
                                                  : Con_black45,
                                              child: Own_Save_white,
                                            )
                                          : Container(),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Container(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: Image.asset('assets/images/No-Media.webp'),
        ),
      );
    }
  }
}

class Fourth_Documents extends StatefulWidget {
  List Documentlist;
  bool isSelected;
  List<String> mListSelected_id;
  ValueChanged<bool> onSelected;
  ValueChanged<List<String>> Selected_id;

  Fourth_Documents(this.Documentlist, this.isSelected, this.mListSelected_id,
      this.onSelected, this.Selected_id,
      {super.key});

  @override
  State<Fourth_Documents> createState() => _Fourth_DocumentsState();
}

class _Fourth_DocumentsState extends State<Fourth_Documents> {
  bool mblnSelect = false;
  List<bool> SelectedList = [];
  List<String> mListSelected_id = [];

  @override
  Widget build(BuildContext context) {
    mblnSelect = widget.isSelected;
    mListSelected_id = widget.mListSelected_id;
    String imagePath;
    if (widget.Documentlist.isNotEmpty) {
      return ListView.builder(
        itemCount: widget.Documentlist.length,
        itemBuilder: (context, index) {
          String centerdatetwo = "", centerdate = "";
          bool showtime = true;
          centerdate = widget.Documentlist[index].date.substring(0, 11);
          if (index != 0) {
            centerdatetwo =
                widget.Documentlist[(index - 1)].date.substring(0, 11);
            if (widget.Documentlist.length == 2) {
              if (widget.Documentlist.where(
                          (e) => e.date.substring(0, 11) == centerdatetwo)
                      .first
                      .id ==
                  widget.Documentlist[index].id) {
                showtime = true;
              } else {
                showtime = false;
              }
            } else {
              if (widget.Documentlist.where(
                          (e) => e.date.substring(0, 11) != centerdatetwo)
                      .first
                      .id ==
                  widget.Documentlist[index].id) {
                showtime = true;
              } else {
                showtime = false;
              }
            }
          } else {
            if (widget.Documentlist.where(
                    (e) => e.date.substring(0, 11) != centerdatetwo).first.id ==
                widget.Documentlist[index].id) {
              showtime = true;
            } else {
              showtime = false;
            }
          }

          if (!mblnSelect) {
            SelectedList = List.filled(widget.Documentlist.length, false);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              showtime
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: Text(
                        centerdate,
                        style: TextStyle(
                            fontSize: Constants_Fonts.mGblFontSubTitleSize,
                            color: getPlatformBrightness()
                                ? Dark_AppGreyColor
                                : AppGreyColor,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : Container(),
              ListTile(
                onTap: mblnSelect
                    ? () {
                        setState(() {
                          SelectedList[index] = !SelectedList[index];

                          if (!mListSelected_id
                              .contains(widget.Documentlist[index].id)) {
                            mListSelected_id.add(widget.Documentlist[index].id);
                            widget.Selected_id.call(mListSelected_id);
                          } else {
                            mListSelected_id
                                .remove(widget.Documentlist[index].id);
                            widget.Selected_id.call(mListSelected_id);
                          }
                          if (mListSelected_id.isEmpty) {
                            mblnSelect = false;
                            widget.Selected_id.call(mListSelected_id);
                            widget.onSelected.call(mblnSelect);
                          }
                        });
                      }
                    : () async {
                        try {
                          if (widget.Documentlist[index].isRight == "1") {
                            imagePath =
                                "${Folder.sentdocument.path}/${widget.Documentlist[index].msg_audio_name}";
                          } else {
                            imagePath =
                                "${Folder.Document.path}/${widget.Documentlist[index].msg_audio_name}";
                          }
                          await OpenFile.open(imagePath);
                        } catch (e) {}
                      },
                selected: SelectedList[index] == true,
                selectedTileColor: Selected_tileColor,
                selectedColor: AppBar_ThemeColor,
                onLongPress: () {
                  if (!mblnSelect) {
                    setState(() {
                      mblnSelect = true;
                      widget.onSelected.call(mblnSelect);
                      SelectedList[index] = true;
                      mListSelected_id.add(widget.Documentlist[index].id);
                      widget.Selected_id.call(mListSelected_id);
                    });
                  }
                },
                title: Text("${widget.Documentlist[index].msg_audio_name}"),
                leading: Image.asset(
                  "assets/images/doc1.webp",
                  height: 30,
                  width: 30,
                ),
                subtitle: Text("${widget.Documentlist[index].msg_media_size}"),
              ),
            ],
          );
        },
      );
    } else {
      return Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: Image.asset('assets/images/No-Media.webp'),
        ),
      );
    }
  }
}

bool getPlatformBrightness() {
  final Brightness platformBrightness =
      SchedulerBinding.instance.window.platformBrightness;
  if (platformBrightness == Brightness.dark) {
    return true;
  } else {
    return false;
  }
}

class RouteTransitions {
  static MaterialPageRoute slideTransition(Widget page) {
    return MaterialPageRoute(
      builder: (context) => page,
      settings: RouteSettings(name: page.toStringShort()),
    );
  }
}
// class RouteTransitions.slideTransition extends PageRouteBuilder {
//   final Widget page;
//
//   RouteTransitions.slideTransition(this.page)
//       : super(
//             pageBuilder: (context, animation, anotherAnimation) => page,
//             transitionDuration: Duration(milliseconds: 800),
//             reverseTransitionDuration: Duration(milliseconds: 400),
//             transitionsBuilder: (context, animation, anotherAnimation, child) {
//               animation = CurvedAnimation(
//                   curve: Curves.fastLinearToSlowEaseIn,
//                   parent: animation,
//                   reverseCurve: Curves.fastOutSlowIn);
//               return SlideTransition(
//                 position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
//                     .animate(animation),
//                 child: page,
//               );
//             });
// }
