import 'dart:async';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nextapp/A_FB_Trigger/sql_need_contact.dart';
import 'package:nextapp/A_SQL_Trigger/sql_auto_sender.dart';
import 'package:nextapp/Constant/Con_Clr.dart';
import 'package:nextapp/Constant/Con_Icons.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:nextapp/Constant/Con_Wid.dart';
import 'package:nextapp/Constant/Constants.dart';
import 'package:nextapp/Emoji/emoji_widget.dart';
import 'package:nextapp/Settings/Folders/Folder.dart';
import 'package:nextapp/main.dart';
import 'package:nextapp/mdi_page/Message/msg_auto_sender_list.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:url_launcher/url_launcher.dart';

import '../../A_FB_Trigger/USER_MSG_AUTOSENDER.dart';
import '../../A_Local_DB/Sync_Database.dart';
import '../../A_Local_DB/Sync_Json.dart';
import '../../Con_Contacts/Con_Glb_Contacts.dart';
import '../../Constant/Auto_Sender_Audio.dart';
import '../../Constant/Con_Profile_Get.dart';
import '../../Media/CamaraScreen.dart';
import '../../Media/Media_Picker.dart';
import '../../Constant/Image_picker/drishya_picker.dart';
import '../A_ChatBubble/ImageBubble.dart';

class Auto_Sender extends StatefulWidget {
  USER_MSG_AUTOSENDER? auto_send_Edit;

  Auto_Sender({super.key, this.auto_send_Edit});

  @override
  State<Auto_Sender> createState() => _Auto_SenderState();
}

enum PopUpData { AutoSenderList }

class _Auto_SenderState extends State<Auto_Sender> {
  List<Need_Contact> _Selected_Auto = [];
  List<MediaModel> Image_Video_List = [];
  List<File> DocumentList = [];
  List<SongModel> AudioList = [];
  List<Map<String, String>> MediaList = [],
      SendMediaList = [];
  List<String> litems = ["General", "Birthday", "Meeting", "Event", "Task"];

  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();

  final TextEditingController _dateController = TextEditingController(),
      _BirthController = TextEditingController(),
      _textFieldController = TextEditingController(),
      _timeController = TextEditingController();
  late final GalleryController controllerimage;
  String _hour = "",
      _minute = "",
      _time = "",
      pStrBtnType = "General",
      dropdownValue = 'onetime';

  bool isExist = false,
      Emojishow = false,
      Mediashow = false,
      isSelected = false,
      isprocess = false;

  int _value = 0,
      Selectedindex = 0;

  @override
  void initState() {
    super.initState();
    SyncDB.SyncTable(Constants.Table_Msg_AutoSender, false);
    controllerimage = GalleryController();
    if (widget.auto_send_Edit != null) {
      EditMsg();
    }
  }

  @override
  dispose() {
    super.dispose();
    controllerimage.dispose();
  }

  EditMsg() async {
    _textFieldController.text = widget.auto_send_Edit!.msgContent;
    dropdownValue =
        widget.auto_send_Edit!.msgTypeDateTime.toString().toLowerCase();
    pStrBtnType = widget.auto_send_Edit!.msgTypeBtn;
    _value = litems.indexWhere((e) => e == widget.auto_send_Edit!.msgTypeBtn);
    List<Need_Contact> _needs = await SyncJSon.user_contact_select_contacts(0);
    _Selected_Auto = _needs
        .where((u) =>
        widget.auto_send_Edit!.msgToUserMastIds
            .split(',')
            .any((e) => e.toString() == u.user_mast_id.toString()))
        .toList();
    isExist = true;
    selectedDate = DateTime.parse(widget.auto_send_Edit!.msgTypeDateUtc);
    selectedTime = stringToTimeOfDay(widget.auto_send_Edit!.msgTypeDateTimeUtc);
    MediaList = widget.auto_send_Edit!.mediaList
        .map((e) => MediaListClass.toJson(e))
        .toList();
    setState(() {});
  }

  TimeOfDay stringToTimeOfDay(String timeString) {
    List<String> parts = timeString.split(' ');
    String time = parts[0];
    String period = parts[1];
    List<String> timeParts = time.split(':');
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);
    if (period == 'PM' && hours != 12) {
      hours += 12;
    }

    return TimeOfDay(hour: hours, minute: minutes);
  }

  @override
  Widget build(BuildContext context) {

    return SlidableGallery(
      controller: controllerimage,
      child: Scaffold(
        appBar: AppBar(
          leading: Con_Wid.mIconButton(
            icon: Own_ArrowBack,
            onPressed: () {
              if (widget.auto_send_Edit != null) {
                Navigator.pushReplacement(
                    context,
                    RouteTransitions.slideTransition(const Auto_Sender_List()));
              } else {
                Navigator.pop(context);
              }
            },
          ),
          automaticallyImplyLeading: true,
          title: Con_Wid.mAppBar("Auto Sender"),
          actions: <Widget>[
            Con_Wid.mIconButton(
              icon: Own_Send,
              onPressed: () {
                if ((_textFieldController.text.isEmpty &&
                    MediaList.isEmpty &&
                    Image_Video_List.isEmpty &&
                    DocumentList.isEmpty &&
                    AudioList.isEmpty)) {
                  Fluttertoast.showToast(
                    msg: 'No Media or Message For Send',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                } else if (_Selected_Auto.isEmpty) {
                  Fluttertoast.showToast(
                    msg: 'No Contacts Selected',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                  // } else if (compareTimeOfDay(
                  //     selectedDate, TimeOfDay.now(), selectedTime)) {
                  //   Fluttertoast.showToast(
                  //     msg: 'Please Select Date & Time',
                  //     toastLength: Toast.LENGTH_SHORT,
                  //     gravity: ToastGravity.BOTTOM,
                  //   );
                } else {
                  setState(() {
                    isprocess = true;
                  });
                  sendmsg();
                }
              },
            ),
            PopupMenuButton<PopUpData>(
              splashRadius: 20,
              onSelected: (PopUpData result) {
                setState(() {
                  switch (result) {
                    case PopUpData.AutoSenderList:
                      Navigator.pushReplacement(
                          context,
                          RouteTransitions.slideTransition(
                              const Auto_Sender_List()));
                      break;
                  }
                });
              },
              itemBuilder: (BuildContext context) =>
              <PopupMenuEntry<PopUpData>>[
                const PopupMenuItem<PopUpData>(
                  value: PopUpData.AutoSenderList,
                  child: Text('Auto Sender List'),
                ),
              ],
            )
          ],
        ),
        body: Stack(
          children: [
            IgnorePointer(
              ignoring: isprocess,
              child: Column(
                children: <Widget>[
                  TopButton(),
                  messageInputArea(),
                  Expanded(child: first_enableUpload()),
                  buildButtonSetting(context),
                  !Emojishow?SizedBox(
                      height: 10
                  ):Container(),
                  buildFooterInput(),
                  !Emojishow?SizedBox(
                    height: 10
                  ):Container(),
                  Offstage(
                    offstage: !Emojishow,
                    child: SizedBox(
                      height: 255,
                      child: Emoji_Widget(controller: _textFieldController),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height/17,
              left: MediaQuery.of(context).size.width/1.45,
              child: AnimatedContainer(

                height: Mediashow?MediaQuery.of(context).size.height/5.5:0,
                width: MediaQuery.of(context).size.width/7,
                duration: Duration(seconds: 1),
                child: Media_Widget(
                  vertical: true,
                  controller: controllerimage,
                  '',
                  "0",
                  '',
                  isauto: true,
                  isSelectedAuto: (Image_Video_List.isNotEmpty &&
                      Image_Video_List.any((e) => e.isimg)) ||
                      (MediaList.isNotEmpty &&
                          MediaList.any((e) => e['msg_type'] == '2'))
                      ? 'IMAGE'
                      : (Image_Video_List.isNotEmpty &&
                      Image_Video_List.any(
                              (e) => !e.isimg)) ||
                      (MediaList.isNotEmpty &&
                          MediaList.any(
                                  (e) => e['msg_type'] == '5'))
                      ? 'VIDEO'
                      : AudioList.isNotEmpty ||
                      (MediaList.isNotEmpty &&
                          MediaList.any(
                                  (e) => e['msg_type'] == '3'))
                      ? 'AUDIO'
                      : DocumentList.isNotEmpty ||
                      (MediaList.isNotEmpty &&
                          MediaList.any((e) =>
                          e['msg_type'] == '4'))
                      ? 'DOCUMENT'
                      : '',
                  sender_name: '',
                  Selected_Document: (value) {
                    setState(() {
                      for (var file in value) {
                        bool fileExists = DocumentList.any(
                                (File) => File.path == file.path);
                        if (!fileExists) {
                          DocumentList.add(file);
                        }
                      }
                      Image_Video_List = [];
                      AudioList = [];
                      Mediashow = false;
                    });
                  },
                  Selected_Image_Video: (value) {
                    setState(() {
                      for (var file in value) {
                        bool fileExists = Image_Video_List.any(
                                (File) =>
                            File.Media.path == file.Media.path);
                        if (!fileExists) {
                          Image_Video_List.add(file);
                        }
                      }
                      DocumentList = [];
                      AudioList = [];
                      Mediashow = false;
                    });
                  },
                  // Selected_Image: (value) {
                  //   setState(() {
                  //     for (var file in value) {
                  //       bool fileExists = ImageList.any((File) =>
                  //       File.path == file.path);
                  //       if (!fileExists) {
                  //         ImageList.add(file);
                  //       }
                  //     }
                  //     VideoList = [];
                  //     DocumentList = [];
                  //     AudioList = [];
                  //     Mediashow = false;
                  //     Selectedindex = 0;
                  //   });
                  // },
                  // Selected_Video: (value) {
                  //   setState(() {
                  //     for (var file in value) {
                  //       bool fileExists = VideoList.any((File) =>
                  //       File.path == file.path);
                  //       if (!fileExists) {
                  //         VideoList.add(file);
                  //       }
                  //     }
                  //     Mediashow = false;
                  //     ImageList = [];
                  //     DocumentList = [];
                  //     AudioList = [];
                  //     Selectedindex = 0;
                  //   });
                  // },
                  Selected_Song: (value) {
                    setState(() {
                      for (var file in value) {
                        bool fileExists =
                        AudioList.any((File) => File.id == file.id);
                        if (!fileExists) {
                          AudioList.add(file);
                        }
                      }
                      DocumentList = [];
                      Image_Video_List = [];
                      Mediashow = false;
                    });
                  },
                ),
              ),
            ),
            isprocess
                ? const Center(
                child: CircularProgressIndicator(
                  color: Con_Main_1,
                ))
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget TopButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
          height: 50.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: litems.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 7.0, right: 7.0),
                  child: Wrap(
                    spacing: 15.0,
                    runSpacing: 4.0,
                    children: <Widget>[
                      ChoiceChip(
                        shadowColor: Con_white.withOpacity(0.10),
                        shape: const StadiumBorder(
                            side: BorderSide(
                              width: 1,
                              color: AppBar_ThemeColor,
                            )),
                        selected: _value == index,
                        selectedColor: AppBar_ThemeColor,
                        backgroundColor: getPlatformBrightness()
                            ? DarkTheme_Main
                            : Con_white,
                        onSelected: (bool selected) {
                          setState(() {
                            _value = (selected ? index : 0);
                            isSelected = selected ? true : false;
                            pStrBtnType =
                                litems[index].toString().trim().trimLeft();
                          });
                        },
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            litems[index]
                                .toString()
                                .trim()
                                .trimLeft()
                                .trimRight(),
                            style: TextStyle(
                                fontSize: 14.0,
                                color: _value == index
                                    ? Con_white
                                    : getPlatformBrightness()
                                    ? Con_white
                                    : AppBar_ThemeColor,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })),
    );
  }

  Padding messageInputArea() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color(0xF7F7FCFF),
                      borderRadius: BorderRadius.circular(10),
                     ),
                  child: Center(
                    child: TextField(
                      maxLines: null,
                      controller: _textFieldController,
                      onChanged: (value) {},
                      onTap: () {
                        setState(() {
                          Emojishow = false;
                          Mediashow = false;
                        });
                      },
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Type your message",
                        hintStyle: TextStyle(
                            color: getPlatformBrightness()
                                ? LightTheme_White
                                : AppGreyColor,
                            fontSize: 16),
                        contentPadding: const EdgeInsets.only(
                            left: 5, bottom: 11, top: 11, right: 5),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget first_enableUpload() {
    if (Image_Video_List.isNotEmpty ||
        (widget.auto_send_Edit != null &&
            MediaList.isNotEmpty &&
            (MediaList.any((e) => e['msg_type'] == '2')) ||
            (MediaList.any((e) => e['msg_type'] == '5')))) {
      return StatefulBuilder(
        builder: (context, setState1) {
          return Container(
            // padding: const EdgeInsets.only(right: 10.0),
            margin: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Con_msg_auto_1,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: App_Float_Back_Color, width: 2),
            ),
            child: Stack(
              children: [
                Container(
                    padding: const EdgeInsets.all(6),
                    alignment: Alignment.topRight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        if (Image_Video_List.isNotEmpty &&
                            Image_Video_List[Selectedindex].isimg &&
                            MediaList.isEmpty &&
                            widget.auto_send_Edit == null)
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: FileImage(
                                    File(Image_Video_List[Selectedindex]
                                        .Media
                                        .path),
                                  ),
                                  fit: BoxFit.cover,
                                )),
                          )
                        else
                          if (Image_Video_List.isEmpty &&
                              MediaList.isNotEmpty &&
                              widget.auto_send_Edit != null &&
                              MediaList.any((e) => e['msg_type'] == '2'))
                            ImageBubble(
                              imageUrl: MediaList[Selectedindex]
                              ['msg_document_url']!,
                              Padding: false,
                              blurhash: "",
                              imageName: MediaList[Selectedindex]
                              ['msg_audio_name']!,
                              isRight: "1",
                              isCurve: true,
                              isVideo: false,
                              onTapChange: true,
                            )
                          else
                            if (Image_Video_List.isNotEmpty &&
                                Image_Video_List[Selectedindex].isimg &&
                                MediaList.isNotEmpty &&
                                widget.auto_send_Edit != null &&
                                MediaList.any((e) => e['msg_type'] == '2'))
                              if (Selectedindex < Image_Video_List.length)
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: FileImage(
                                          File(Image_Video_List[Selectedindex]
                                              .Media
                                              .path),
                                        ),
                                        fit: BoxFit.cover,
                                      )),
                                )
                              else
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ImageBubble(
                                    imageUrl: MediaList[MediaList.length == 1
                                        ? 0
                                        : Selectedindex - MediaList.length]
                                    ['msg_document_url']!,
                                    blurhash: "",
                                    Padding: false,
                                    imageName: MediaList[MediaList.length == 1
                                        ? 0
                                        : Selectedindex - MediaList.length]
                                    ['msg_audio_name']!,
                                    isRight: "1",
                                    isVideo: false,
                                    isCurve: true,
                                    onTapChange: true,
                                  ),
                                )
                            else
                              Container(),
                        if (Image_Video_List.isNotEmpty &&
                            (!Image_Video_List[Selectedindex].isimg) &&
                            MediaList.isEmpty &&
                            widget.auto_send_Edit == null)
                          ImageBubble(
                            imageUrl:
                            Image_Video_List[Selectedindex].Media.path,
                            Padding: false,
                            blurhash: "",
                            isCurve: true,
                            imageName: Image_Video_List[Selectedindex]
                                .Media
                                .path
                                .split("/")
                                .last,
                            isRight: "1",
                            isVideo: true,
                            isLocal: true,
                            selected: false,
                            onTapChange: true,
                          )
                        else
                          if (Image_Video_List.isEmpty &&
                              MediaList.isNotEmpty &&
                              widget.auto_send_Edit != null &&
                              MediaList.any((e) => e['msg_type'] == '5'))
                            ImageBubble(
                              imageUrl: MediaList[Selectedindex]
                              ['msg_document_url']!,
                              Padding: false,
                              blurhash: "",
                              imageName: MediaList[Selectedindex]
                              ['msg_audio_name']!,
                              isRight: "1",
                              isCurve: true,
                              isVideo: false,
                              onTapChange: true,
                            )
                          else
                            if (Image_Video_List.isNotEmpty &&
                                (!Image_Video_List[Selectedindex].isimg) &&
                                MediaList.isNotEmpty &&
                                widget.auto_send_Edit != null &&
                                MediaList.any((e) => e['msg_type'] == '5'))
                              if (Selectedindex < Image_Video_List.length)
                                ImageBubble(
                                  imageUrl:
                                  Image_Video_List[Selectedindex].Media.path,
                                  Padding: false,
                                  blurhash: "",
                                  isCurve: true,
                                  imageName: Image_Video_List[Selectedindex]
                                      .Media
                                      .path
                                      .split("/")
                                      .last,
                                  isRight: "1",
                                  isVideo: true,
                                  isLocal: true,
                                  onTapChange: true,
                                )
                              else
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ImageBubble(
                                    imageUrl: MediaList[MediaList.length == 1
                                        ? 0
                                        : Selectedindex - MediaList.length]
                                    ['msg_document_url']!,
                                    blurhash: "",
                                    Padding: false,
                                    imageName: MediaList[MediaList.length == 1
                                        ? 0
                                        : Selectedindex - MediaList.length]
                                    ['msg_audio_name']!,
                                    isRight: "1",
                                    isVideo: false,
                                    isCurve: true,
                                    onTapChange: true,
                                  ),
                                )
                            else
                              Container(),
                        Positioned(
                          right: 4,
                          child: Baseline(
                            baseline: 26,
                            baselineType: TextBaseline.alphabetic,
                            child: Container(
                              child: InkWell(
                                  onTap: () =>
                                      setState(() =>
                                          RemoveTap(index: Selectedindex)),
                                  child: const Icon(Icons.close,
                                      color: Con_white, size: 18)),
                              width: (26),
                              height: (26),
                              decoration: BoxDecoration(
                                color: App_Float_Back_Color,
                                border: Border.all(
                                  width: (1),
                                  color: Con_black.withOpacity(0.5),
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.elliptical(48, 48.02000045776367)),
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
                Image_Video_List.length > 1 ||
                    (widget.auto_send_Edit != null &&
                        MediaList.length > 1) ||
                    ((widget.auto_send_Edit != null &&
                        MediaList.length + Image_Video_List.length > 1))
                    ? Positioned(
                  bottom: 12,
                  left: MediaQuery
                      .of(context)
                      .size
                      .width / 36,
                  right: MediaQuery
                      .of(context)
                      .size
                      .width / 36,
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width - 50,
                    child: ListView.builder(
                        itemCount: Image_Video_List.isEmpty &&
                            (widget.auto_send_Edit != null &&
                                MediaList.isNotEmpty)
                            ? MediaList.length
                            : Image_Video_List.isNotEmpty &&
                            (widget.auto_send_Edit != null &&
                                MediaList.isNotEmpty)
                            ? (Image_Video_List.length +
                            MediaList.length)
                            : Image_Video_List.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          // (Image_Video_List.isNotEmpty && VideoList.isEmpty) ||
                          // (widget.auto_send_Edit != null &&
                          // MediaList.isNotEmpty &&
                          // MediaList.any(
                          // (e) => e['msg_type'] == '2'))
                          if ((Image_Video_List.isNotEmpty &&
                              Image_Video_List[index].isimg) ||
                              (MediaList.isNotEmpty &&
                                  MediaList[index]['msg_type'] == '2')) {
                            return InkWell(
                              onTap: () {
                                setState1(() {
                                  Selectedindex = index;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 1, color: Con_black26)
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Selectedindex == index
                                          ? App_Float_Back_Color
                                          : Con_transparent,
                                      width: 2),
                                ),
                                child: ImageListBox(index),
                                margin: const EdgeInsets.all(2),
                                height: 50,
                                width: 50,
                              ),
                            );
                          } else {
                            return InkWell(
                                onTap: () {
                                  setState1(() {
                                    Selectedindex = index;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                          blurRadius: 1,
                                          color: Con_black26)
                                    ],
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Selectedindex == index
                                            ? App_Float_Back_Color
                                            : Con_transparent,
                                        width: 2),
                                  ),
                                  child: VideoListBox(
                                    index: index,
                                    NoButtontap: () {
                                      setState(() {
                                        setState1(() {
                                          Selectedindex = index;
                                        });
                                      });
                                    },
                                  ),
                                ));
                          }
                        }),
                    // : ListView.builder(
                    //     itemCount: VideoList.isEmpty &&
                    //             (widget.auto_send_Edit != null &&
                    //                 MediaList.isNotEmpty)
                    //         ? MediaList.length
                    //         : VideoList.isNotEmpty &&
                    //                 (widget.auto_send_Edit != null &&
                    //                     MediaList.isNotEmpty)
                    //             ? (VideoList.length +
                    //                 MediaList.length)
                    //             : VideoList.length,
                    //     scrollDirection: Axis.horizontal,
                    //     itemBuilder: (context, index) {
                    //       return InkWell(
                    //           onTap: () {
                    //             setState1(() {
                    //               Selectedindex = index;
                    //             });
                    //           },
                    //           child: Container(
                    //             decoration: BoxDecoration(
                    //               boxShadow: const [
                    //                 BoxShadow(
                    //                     blurRadius: 1,
                    //                     color: Con_black26)
                    //               ],
                    //               borderRadius:
                    //                   BorderRadius.circular(10),
                    //               border: Border.all(
                    //                   color: Selectedindex == index
                    //                       ? App_Float_Back_Color
                    //                       : Con_transparent,
                    //                   width: 2),
                    //             ),
                    //             child: VideoListBox(
                    //               index: index,
                    //               NoButtontap: () {
                    //                 setState(() {
                    //                   setState1(() {
                    //                     Selectedindex = index;
                    //                   });
                    //                 });
                    //               },
                    //             ),
                    //           ));
                    //       // return InkWell(
                    //       //   onTap: () {
                    //       //     setState(() {
                    //       //       setState1(() {
                    //       //         Selectedindex = index;
                    //       //       });
                    //       //     });
                    //       //   },
                    //       //   child: Container(
                    //       //     decoration: BoxDecoration(
                    //       //       boxShadow: const [
                    //       //         BoxShadow(
                    //       //             blurRadius: 1,
                    //       //             color: Con_black26)
                    //       //       ],
                    //       //       // borderRadius: BorderRadius.circular(10),
                    //       //       border: Border.all(
                    //       //           color: Selectedindex == index
                    //       //               ? App_Float_Back_Color
                    //       //               : Con_transparent,
                    //       //           width: 1),
                    //       //     ),
                    //       //     child: (VideoList.isNotEmpty &&
                    //       //         (widget.auto_send_Edit ==
                    //       //             null &&
                    //       //             MediaList.isEmpty)) ||
                    //       //         (VideoList.isNotEmpty &&
                    //       //             (widget.auto_send_Edit !=
                    //       //                 null &&
                    //       //                 MediaList.isNotEmpty))
                    //       //         ? ((VideoList.length > index)
                    //       //         ? Video_player(
                    //       //       VideoFile: VideoList[index],
                    //       //       ischat: true,
                    //       //       Showbutton: false,
                    //       //       NoButtontap: () {
                    //       //         setState(() {
                    //       //           Selectedindex = index;
                    //       //         });
                    //       //       },
                    //       //     )
                    //       //         : Video_player(
                    //       //       isLocal: false,
                    //       //       MediaMap: MediaList[
                    //       //       MediaList.length == 1
                    //       //           ? 0
                    //       //           : (index -
                    //       //           MediaList
                    //       //               .length)],
                    //       //       ischat: true,
                    //       //       Showbutton: false,
                    //       //       NoButtontap: () {
                    //       //         setState(() {
                    //       //           Selectedindex = index;
                    //       //         });
                    //       //       },
                    //       //     ))
                    //       //         : Video_player(
                    //       //       isLocal: false,
                    //       //       MediaMap: MediaList[index],
                    //       //       ischat: true,
                    //       //       Showbutton: false,
                    //       //       NoButtontap: () {
                    //       //         setState(() {
                    //       //           Selectedindex = index;
                    //       //         });
                    //       //       },
                    //       //     ),
                    //       //     margin: const EdgeInsets.all(2),
                    //       //     height: 50,
                    //       //     width: 50,
                    //       //   ),
                    //       // );
                    //     }),
                  ),
                )
                    : Container(),
              ],
            ),
          );
        },
      );
    } else if (DocumentList.isNotEmpty ||
        (widget.auto_send_Edit != null &&
            (MediaList.isNotEmpty &&
                MediaList.any((e) => e['msg_type'] == '4')))) {
      return Container(
        constraints: const BoxConstraints.expand(
          height: 200.0,
        ),
        padding: const EdgeInsets.all(6),
        alignment: Alignment.topRight,
        margin: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: App_Float_Back_Color),
        ),
        child: ListView.separated(
          itemCount: DocumentList.isEmpty &&
              (widget.auto_send_Edit != null && MediaList.isNotEmpty)
              ? MediaList.length
              : DocumentList.isNotEmpty &&
              (widget.auto_send_Edit != null && MediaList.isNotEmpty)
              ? (DocumentList.length + MediaList.length)
              : DocumentList.length,
          itemBuilder: (context, index) {
            String? pStrMediaSize;
            if (DocumentList.isNotEmpty && MediaList.isEmpty) {
              pStrMediaSize = DocumentList[index].lengthSync() < 1001
                  ? "${DocumentList[index].lengthSync()} BYTE"
                  : DocumentList[index].lengthSync() < 1000001
                  ? "${(DocumentList[index].lengthSync() / 1000)
                  .toStringAsFixed(2)} KB"
                  : "${(DocumentList[index].lengthSync() / 1000000)
                  .toStringAsFixed(2)} MB";
            } else if (MediaList.isNotEmpty && DocumentList.isEmpty) {
              pStrMediaSize = MediaList[index]['msg_media_size'];
            } else if (MediaList.isNotEmpty && DocumentList.isNotEmpty) {
              pStrMediaSize = (DocumentList.length > index)
                  ? DocumentList[index].lengthSync() < 1001
                  ? "${DocumentList[index].lengthSync()} BYTE"
                  : DocumentList[index].lengthSync() < 1000001
                  ? "${(DocumentList[index].lengthSync() / 1000)
                  .toStringAsFixed(2)} KB"
                  : "${(DocumentList[index].lengthSync() / 1000000)
                  .toStringAsFixed(2)} MB"
                  : MediaList[index - MediaList.length]['msg_media_size'];
            }

            return InkWell(
              onTap: () async {
                if (DocumentList.isNotEmpty && MediaList.isEmpty) {
                  OpenFile.open(DocumentList[index].path);
                } else if (MediaList.isNotEmpty && DocumentList.isEmpty) {
                  if (!await launchUrl(
                      Uri.parse(MediaList[index]['msg_document_url'] ?? ''))) {
                    throw Exception(
                        'Could not launch ${MediaList[index]['msg_audio_name']}');
                  }
                } else if (MediaList.isNotEmpty && DocumentList.isNotEmpty) {
                  if (DocumentList.length > index) {
                    OpenFile.open(DocumentList[index].path);
                  } else {
                    if (!await launchUrl(Uri.parse(
                        MediaList[index - MediaList.length]
                        ['msg_document_url'] ??
                            ''))) {
                      throw Exception(
                          'Could not launch ${MediaList[index -
                              MediaList.length]['msg_audio_name']}');
                    }
                  }
                }
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color:
                  getPlatformBrightness() ? Dark_ChatField : Con_msg_auto_1,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: Con_msg_auto,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Container(
                          padding: const EdgeInsets.only(top: 8),
                          width: 42,
                          height: 42,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/Doc.webp"))),
                          child: Center(
                              child: Text(
                                (widget.auto_send_Edit != null &&
                                    MediaList.isNotEmpty &&
                                    DocumentList.isEmpty)
                                    ? MediaList[index]['msg_audio_name']
                                    ?.split(".")
                                    .last
                                    .toUpperCase() ??
                                    ''
                                    : (DocumentList.length > index)
                                    ? (DocumentList[index]
                                    .path
                                    .split('/')
                                    .last
                                    .split(".")
                                    .last)
                                    .toUpperCase()
                                    : MediaList[index - MediaList.length]
                                ['msg_audio_name']
                                    ?.split(".")
                                    .last
                                    .toUpperCase() ??
                                    '',
                                style: const TextStyle(
                                    fontSize: 6, color: Con_msg_auto),
                              )),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 8, right: 8, top: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (widget.auto_send_Edit != null &&
                                    MediaList.isNotEmpty) &&
                                    DocumentList.isEmpty
                                    ? (MediaList[index].length < 22
                                    ? MediaList[index]['msg_audio_name']!
                                    .substring(0, 21) +
                                    '...'
                                    : MediaList[index]['msg_audio_name'] ??
                                    '')
                                    : (DocumentList.length > index)
                                    ? (DocumentList[index].path
                                    .split('/')
                                    .last
                                    .length > 26
                                    ? (DocumentList[index]
                                    .path
                                    .split('/')
                                    .last
                                    .split('.')
                                    .first
                                    .length >
                                    26
                                    ? DocumentList[index]
                                    .path
                                    .split('/')
                                    .last
                                    .substring(0, 25) +
                                    '...'
                                    : DocumentList[index]
                                    .path
                                    .split('/')
                                    .last
                                    .split('.')
                                    .first)
                                    : DocumentList[index]
                                    .path
                                    .split('/')
                                    .last)
                                    : (MediaList[index - MediaList.length]
                                    .length < 26
                                    ? MediaList[index - MediaList.length]
                                ['msg_audio_name']!
                                    .substring(0, 25) +
                                    '...'
                                    : MediaList[index - MediaList.length]
                                ['msg_audio_name'] ??
                                    ''),
                                style: TextStyle(
                                  fontSize:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.035,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                  color: getPlatformBrightness()
                                      ? Con_white
                                      : Con_msg_auto_2,
                                ),
                              ),
                              Container(
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(3, 8, 3, 2),
                                  child: Text(
                                    "$pStrMediaSize • ${(widget
                                        .auto_send_Edit != null &&
                                        MediaList.isNotEmpty) &&
                                        DocumentList.isEmpty
                                        ? MediaList[index]['msg_audio_name']
                                        ?.split(".")
                                        .last
                                        .toUpperCase() ?? ''
                                        : (DocumentList.length > index)
                                        ? (DocumentList[index].path
                                        .split('/')
                                        .last
                                        .split(".")
                                        .last).toUpperCase()
                                        : MediaList[index -
                                        MediaList.length]['msg_audio_name']
                                        ?.split(".")
                                        .last
                                        .toUpperCase() ?? ''}",
                                    style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w500,
                                      color: getPlatformBrightness()
                                          ? Con_white
                                          : Con_msg_auto,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ]),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 46, right: 4),
                      child: Container(
                        child: InkWell(
                            onTap: () {
                              setState(() async {
                                if (DocumentList.length > index) {
                                  DocumentList.removeAt(index);
                                } else {
                                  MediaList.removeAt(index - MediaList.length);
                                }
                              });
                            },
                            child: const Icon(Icons.close,
                                color: Con_white, size: 14)),
                        width: (18),
                        height: (18),
                        decoration: const BoxDecoration(
                          color: Con_msg_auto,
                          borderRadius: BorderRadius.all(
                              Radius.elliptical(48, 48.02000045776367)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 6,
            );
          },
        ),
      );
    } else if (AudioList.isNotEmpty ||
        (widget.auto_send_Edit != null &&
            (MediaList.isNotEmpty &&
                MediaList.any((e) => e['msg_type'] == '3')))) {
      return SongListWidget(
        MediaList: MediaList.isEmpty ? [] : MediaList,
        songList: AudioList.isEmpty ? [] : AudioList,
        ListUpdate: (value) {
          setState(() {
            AudioList = value;
          });
        },
      );
    } else {
      return Container(
        constraints: const BoxConstraints.expand(
          height: 200.0,
        ),
        alignment: Alignment.topRight,
        margin: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Color(0xF7F7FCFF),
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(color: App_Float_Back_Color),
        ),
        child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            onTap: () =>
                setState(() {
                  Mediashow = !Mediashow;
                  FocusManager.instance.primaryFocus?.unfocus();
                }),
            child: Center(
              child: Container(
                height: 140,
                width: 110,
                padding: const EdgeInsets.only(top: 130),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                        const AssetImage('assets/images/Group.png'),
                        opacity: getPlatformBrightness() ? .8 : .8)),

              ),
            )),
      );
    }
  }

  void RemoveTap({required int index}) {
    if ((Image_Video_List.isNotEmpty && (!Image_Video_List[index].isimg)) ||
        MediaList.any((e) => e['msg_type'] == '5')) {
      if (Image_Video_List.isNotEmpty &&
          MediaList.isEmpty &&
          widget.auto_send_Edit == null) {
        Image_Video_List.removeAt(index);
        Selectedindex = Image_Video_List.length - 1;
      } else if (Image_Video_List.isEmpty &&
          MediaList.isNotEmpty &&
          widget.auto_send_Edit != null &&
          MediaList.any((e) => e['msg_type'] == '5')) {
        MediaList.removeAt(index);
        Selectedindex = MediaList.length - 1;
      } else if (Image_Video_List.isNotEmpty &&
          MediaList.isNotEmpty &&
          widget.auto_send_Edit != null &&
          MediaList.any((e) => e['msg_type'] == '5')) {
        if (index < Image_Video_List.length) {
          Image_Video_List.removeAt(index);
          Selectedindex = Image_Video_List.length - 1;
        } else {
          MediaList.removeAt(index - MediaList.length);
          Selectedindex = MediaList.length - 1;
        }
      }
    } else {
      if ((Image_Video_List.isNotEmpty && (Image_Video_List[index].isimg)) ||
          MediaList.isEmpty && widget.auto_send_Edit == null) {
        Image_Video_List.removeAt(index);
        Selectedindex = Image_Video_List.length - 1;
      } else if (Image_Video_List.isEmpty &&
          MediaList.isNotEmpty &&
          widget.auto_send_Edit != null &&
          MediaList.any((e) => e['msg_type'] == '2')) {
        MediaList.removeAt(index);
        Selectedindex = MediaList.length - 1;
      } else if (Image_Video_List.isNotEmpty &&
          MediaList.isNotEmpty &&
          widget.auto_send_Edit != null &&
          MediaList.any((e) => e['msg_type'] == '2')) {
        if (index < Image_Video_List.length) {
          Image_Video_List.removeAt(index);
          Selectedindex = Image_Video_List.length - 1;
        } else {
          MediaList.removeAt(index - MediaList.length);
          Selectedindex = MediaList.length - 1;
        }
      }
    }
  }

  Widget VideoListBox(
      {required int index, required void Function() NoButtontap}) {
    if (Image_Video_List.isNotEmpty &&
        MediaList.isEmpty &&
        widget.auto_send_Edit == null) {
      return ImageBubble(
        imageUrl: Image_Video_List[index].Media.path,
        Padding: false,
        blurhash: "",
        isCurve: true,
        imageName: Image_Video_List[index].Media.path
            .split("/")
            .last,
        isRight: "1",
        isVideo: true,
        isLocal: true,
        isSmall: true,
        NoButtontap: NoButtontap,
      );
    } else if (Image_Video_List.isEmpty &&
        MediaList.isNotEmpty &&
        widget.auto_send_Edit != null &&
        MediaList.any((e) => e['msg_type'] == '5')) {
      return ImageBubble(
        imageUrl: MediaList[index]['msg_document_url']!,
        Padding: false,
        blurhash: "",
        isCurve: true,
        imageName: MediaList[index]['msg_audio_name']!,
        isRight: "1",
        isVideo: true,
        isSmall: true,
        NoButtontap: NoButtontap,
      );
    } else if (Image_Video_List.isNotEmpty &&
        MediaList.isNotEmpty &&
        widget.auto_send_Edit != null &&
        MediaList.any((e) => e['msg_type'] == '5')) {
      if (index < Image_Video_List.length) {
        return ImageBubble(
          imageUrl: Image_Video_List[index].Media.path,
          Padding: false,
          blurhash: "",
          isCurve: true,
          imageName: Image_Video_List[index].Media.path
              .split("/")
              .last,
          isRight: "1",
          isVideo: true,
          isLocal: true,
          isSmall: true,
          NoButtontap: NoButtontap,
        );
      } else {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ImageBubble(
            imageUrl: MediaList[MediaList.length == 1
                ? 0
                : (index - MediaList.length)]['msg_document_url']!,
            blurhash: "",
            Padding: false,
            isCurve: true,
            imageName: MediaList[MediaList.length == 1
                ? 0
                : (index - MediaList.length)]['msg_audio_name']!,
            isRight: "1",
            isVideo: true,
            isSmall: true,
            NoButtontap: NoButtontap,
          ),
        );
      }
    } else {
      return Container();
    }
  }

  Widget ImageListBox(index) {
    if (Image_Video_List.isNotEmpty &&
        MediaList.isEmpty &&
        widget.auto_send_Edit == null) {
      return ImageBubble(
        imageUrl: Image_Video_List[index].Media.path,
        Padding: false,
        blurhash: "",
        isCurve: true,
        imageName: Image_Video_List[index].Media.path
            .split("/")
            .last,
        isRight: "1",
        isLocal: true,
        isVideo: false,
      );
    } else if (Image_Video_List.isEmpty &&
        MediaList.isNotEmpty &&
        widget.auto_send_Edit != null &&
        MediaList.any((e) => e['msg_type'] == '2')) {
      return ImageBubble(
        imageUrl: MediaList[index]['msg_document_url']!,
        Padding: false,
        blurhash: "",
        isCurve: true,
        imageName: MediaList[index]['msg_audio_name']!,
        isRight: "1",
        isVideo: false,
      );
    } else if (Image_Video_List.isNotEmpty &&
        MediaList.isNotEmpty &&
        widget.auto_send_Edit != null &&
        MediaList.any((e) => e['msg_type'] == '2')) {
      if (index < Image_Video_List.length) {
        return ImageBubble(
          imageUrl: Image_Video_List[index].Media.path,
          Padding: false,
          blurhash: "",
          isCurve: true,
          imageName: Image_Video_List[index].Media.path
              .split("/")
              .last,
          isRight: "1",
          isLocal: true,
          isVideo: false,
        );
      } else {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ImageBubble(
            imageUrl: MediaList[MediaList.length == 1
                ? 0
                : (index - MediaList.length)]['msg_document_url']!,
            blurhash: "",
            Padding: false,
            isCurve: true,
            imageName: MediaList[MediaList.length == 1
                ? 0
                : (index - MediaList.length)]['msg_audio_name']!,
            isRight: "1",
            isVideo: false,
          ),
        );
      }
    } else {
      return Container();
    }
  }

  Widget buildButtonSetting(BuildContext context) {
    return Column(
      children: <Widget>[
        Wrap(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding:
                  const EdgeInsets.only(top: 2.0, left: 18.0, bottom: 23.0),
                  child: Container(
                    child: ClipOval(
                      child: Material(
                        color: getPlatformBrightness()
                            ? DarkTheme_Main
                            : Con_white,
                        shadowColor: Con_black,
                        child: InkWell(
                          child: SizedBox(
                              width: 44,
                              height: 44,
                              child: Con_Wid.mIconButton(
                                  icon: isExist
                                      ? Center(
                                    child: Text(
                                        _Selected_Auto.length.toString(),
                                        style: TextStyle(
                                            color: getPlatformBrightness()
                                                ? Con_white
                                                : Con_black,
                                            fontSize: 18.0)),
                                  )
                                      : Icon(Icons.add,
                                      size: 24,
                                      color: getPlatformBrightness()
                                          ? Con_white
                                          : Con_black),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      RouteTransitions.slideTransition(
                                          Con_Global_Contacts(
                                            'Auto',
                                            Selected_Contact:
                                            _Selected_Auto,
                                            Selected: (value) {
                                              setState(() {
                                                _Selected_Auto = value;
                                                if (_Selected_Auto
                                                    .isNotEmpty) {
                                                  isExist = true;
                                                } else {
                                                  isExist = false;
                                                }
                                              });
                                            },
                                          )),
                                    );
                                    setState(() {});
                                  })),
                          onTap: () {
                            _Selected_Auto.clear();
                            // _navigateAndDisplaySelection(context);
                          },
                        ),
                      ),
                    ),
                    width: 44.0,
                    height: 44.0,
                    decoration: BoxDecoration(
                      color: Con_msg_auto_3,
                      borderRadius:
                      const BorderRadius.all(Radius.circular(50.0)),
                      border: Border.all(
                        color: getPlatformBrightness() ? Con_white : Con_black,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                isExist
                    ? Container()
                    : const Padding(
                  padding: EdgeInsets.only(left: 10.0, bottom: 23.0),
                  child: Text("Add your contacts",
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                Expanded(
                  child: SizedBox(
                    height: 80,
                    child: isExist
                        ? ListView.builder(
                      padding: const EdgeInsets.only(left: 10.0),
                      itemCount: _Selected_Auto.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 44,
                          width: 44,
                          margin:
                          const EdgeInsets.only(bottom: 20, right: 8),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: getPlatformBrightness()
                                    ? Con_white
                                    : Con_black,
                              ),
                              shape: BoxShape.circle),
                          child: Stack(
                            children: [
                              Con_profile_get(
                                pStrImageUrl: _Selected_Auto[index]
                                    .user_profileimage_path,
                                Size: 60,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 24),
                                child: Baseline(
                                  baseline: 16,
                                  baselineType: TextBaseline.alphabetic,
                                  child: Container(
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _Selected_Auto.remove(
                                                _Selected_Auto[index]);
                                            if (_Selected_Auto.isEmpty) {
                                              isExist = false;
                                            }
                                          });
                                        },
                                        child: const Icon(Icons.close,
                                            color: Con_white, size: 12)),
                                    width: (18),
                                    height: (18),
                                    decoration: BoxDecoration(
                                      color: App_Float_Back_Color,
                                      border: Border.all(
                                        width: (1),
                                        color: getPlatformBrightness()
                                            ? Con_white.withOpacity(0.5)
                                            : Con_black.withOpacity(0.5),
                                      ),
                                      borderRadius:
                                      const BorderRadius.all(
                                          Radius.elliptical(
                                              48, 48.02000045776367)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                        : Container(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget buildFooterInput() {
    PopupMenuItem<PopUpData> dividerPopupMenuItem =
    const PopupMenuItem<PopUpData>(
      height: 0,
      enabled: false,
      child: Divider(
        color: Con_Main_1,
      ),
    );
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(width: 10,),
          Expanded(flex: 4, child: InkWell(
            onTap: () =>
                showMenu(context: context,
                    position: RelativeRect.fromLTRB(0, MediaQuery
                        .of(context)
                        .size
                        .height / 1.4, 0, 0),
                    items: [
                      PopupMenuItem(height: 30,
                        onTap: () {
                          setState(() {
                            dropdownValue = "OneTime";
                          });
                        },
                        child: Text('OneTime'),
                      ),
                      dividerPopupMenuItem,
                      PopupMenuItem(height: 30,
                        onTap: () {
                          setState(() {
                            dropdownValue = "Daily";
                          });
                        },
                        child: Text('Daily'),
                      ),
                      dividerPopupMenuItem,
                      PopupMenuItem(height: 30, onTap: () {
                        setState(() {
                          dropdownValue = "Weekly";
                        });
                      },
                        child: Text('Weekly'),
                      ),
                      dividerPopupMenuItem,
                      PopupMenuItem(height: 30, onTap: () {
                        setState(() {
                          dropdownValue = "Monthly";
                        });
                      },
                        child: Text('Monthly'),
                      )
                      ,
                    ]),
            child: Container(height: 30,
                   decoration: BoxDecoration( color: Color(0xFFE7F2F4),borderRadius: BorderRadius.circular(10)),

              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text(dropdownValue, style: TextStyle(fontSize: 16,color: Con_msg_auto_6),),
                Icon(Icons.arrow_drop_down, color: Con_msg_auto_6,),
              ]),),
          )),
          SizedBox(width: 5,),
          Expanded(flex: 5,
              child: InkWell(onTap: () => getDateTime(),
                child: Container(

                  height: 30.0,
                  decoration: BoxDecoration( color: Color(0xFFE7F2F4),borderRadius: BorderRadius.circular(10)),

                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                    Text(
                      (DateFormat("dd-MM-yy")
                          .format(selectedDate)
                          .toString()) + " "+

                          formatDate(
                              DateTime(2019, 08, 1, selectedTime.hour,
                                  selectedTime.minute),
                              [hh, ':', nn,""]).toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: getPlatformBrightness()
                            ? LightTheme_White
                            : Con_msg_auto_6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ]),),
              )),
          SizedBox(width: 5),
          Expanded(flex: 2,child: Container(
            alignment: Alignment.topCenter,
            height: 30.0,
            child: IconButton(padding: EdgeInsets.zero,
            icon:
            getPlatformBrightness() ? Dark_Attachment : Own_Attachment,
            onPressed: () =>
                setState(() {
                  Mediashow = !Mediashow;
                  Emojishow = false;
                  FocusManager.instance.primaryFocus?.unfocus();
                }),
          ),)),
          SizedBox(width: 5,),
          Expanded(flex: 2,child: Container(
            height: 30.0,
           child:
          IconButton(padding: EdgeInsets.zero,
            icon: Icon(
              Own_Face,
              color: Emojishow == true
                  ? AppBar_ThemeColor
                  : getPlatformBrightness()
                  ? LightTheme_White
                  : Con_msg_auto_6,
            ),
            onPressed: () async {
              FocusManager.instance.primaryFocus?.unfocus();

              setState(() {});
              await Future.delayed(const Duration(milliseconds: 50));
              Mediashow = false;
              Emojishow = !Emojishow;
              setState(() {});
            },
            color: Con_black,
          )
            ,)),
          SizedBox(width: 5,),
          // Container(
          //   margin: const EdgeInsets.symmetric(horizontal: 10),
          //   child: Center(
          //     child: DropdownButton(
          //       dropdownColor: getPlatformBrightness()
          //           ? DarkTheme_AppBar
          //           : LightTheme_White,
          //       value: dropdownValue,
          //       items: const [
          //         DropdownMenuItem(value: 'onetime', child: Text('OneTime')),
          //         DropdownMenuItem(value: 'daily', child: Text('Daily')),
          //         DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
          //         DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
          //       ],
          //       onChanged: (String? value) {
          //         setState(() {
          //           dropdownValue = value!;
          //         });
          //       },
          //     ),
          //   ),
          // ),
          // Material(
          //   child: Container(
          //     margin: const EdgeInsets.symmetric(horizontal: 1.0),
          //     child: Center(
          //       child: Text(
          //         (DateFormat("dd-MM-yyyy").format(selectedDate).toString()) +
          //             "\n" +
          //             formatDate(
          //                 DateTime(2019, 08, 1, selectedTime.hour,
          //                     selectedTime.minute),
          //                 [hh, ':', nn, " ", am]).toString(),
          //         style: TextStyle(
          //           fontSize: 14,
          //           color: getPlatformBrightness()
          //               ? LightTheme_White
          //               : AppGreyColor,
          //         ),
          //         textAlign: TextAlign.center,
          //       ),
          //     ),
          //   ),
          //   color: getPlatformBrightness() ? DarkTheme_Main : LightTheme_White,
          // ),
          // Material(
          //   child: Container(
          //     margin: const EdgeInsets.symmetric(horizontal: 1.0),
          //     child: IconButton(
          //       icon: getPlatformBrightness() ? Dark_Calander : Own_Calander,
          //       onPressed: () => getDateTime(),
          //     ),
          //   ),
          //   color: getPlatformBrightness() ? DarkTheme_Main : LightTheme_White,
          // ),
          // Material(
          //   child: Container(
          //     margin: const EdgeInsets.symmetric(horizontal: 1.0),
          //     child: IconButton(
          //       icon:
          //           getPlatformBrightness() ? Dark_Attachment : Own_Attachment,
          //       onPressed: () => setState(() {
          //         Mediashow = !Mediashow;
          //         Emojishow = false;
          //         FocusManager.instance.primaryFocus?.unfocus();
          //       }),
          //     ),
          //   ),
          //   color: getPlatformBrightness() ? DarkTheme_Main : LightTheme_White,
          // ),
          // Material(
          //   child: Container(
          //     margin: const EdgeInsets.symmetric(horizontal: 1.0),
          //     child: IconButton(
          //       icon: Icon(
          //         Own_Face,
          //         color: Emojishow == true
          //             ? AppBar_ThemeColor
          //             : getPlatformBrightness()
          //                 ? LightTheme_White
          //                 : AppGreyColor,
          //       ),
          //       onPressed: () async {
          //         FocusManager.instance.primaryFocus?.unfocus();
          //
          //         setState(() {});
          //         await Future.delayed(const Duration(milliseconds: 50));
          //         Mediashow = false;
          //         Emojishow = !Emojishow;
          //         setState(() {});
          //       },
          //       color: Con_black,
          //     ),
          //   ),
          //   color: getPlatformBrightness() ? DarkTheme_Main : LightTheme_White,
          // ),
        ],
      ),
      width: double.infinity,
      height: 30.0,
      decoration: BoxDecoration(
          // border: const Border(top: BorderSide(color: greyColor2, width: 0.5)),
          color: getPlatformBrightness() ? DarkTheme_Main : LightTheme_White),
    );
  }

  send() async {
    SendMediaList.addAll(MediaList);
    await sql_auto_sender_tran.Send_Msg(
        id: widget.auto_send_Edit != null
            ? widget.auto_send_Edit!.id.toString()
            : '',
        msgContent: _textFieldController.text,
        msgFromUserMastId: Constants_Usermast.user_id,
        msgToUserMastIds:
        _Selected_Auto.map((e) => e.user_mast_id.toString().trim())
            .join(','),
        msgTypeDateUtc: selectedDate
            .toString()
            .split(' ')
            .first,
        msgTypeDateTimeUtc: formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString(),
        msgTypeBtn: pStrBtnType,
        msgTypeDateTime: dropdownValue,
        mediaList: SendMediaList,
        tran_type: widget.auto_send_Edit != null ? 'UPDATE' : 'INSERT')
        .then((value) {
      Fluttertoast.showToast(
        msg: 'Your message sent successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      setState(() {
        isprocess = false;
      });
      Navigator.pushReplacement(context,
          RouteTransitions.slideTransition(const Auto_Sender_List()));
    });
  }

  sendmsg() {
    if (Image_Video_List.isNotEmpty) {
      for (var e in Image_Video_List) {
        if (e.isimg) {
          getImage(e.Media.path.toString(), true);
        } else {
          getImage(e.Media.path.toString(), false);
        }
      }
    } else if (DocumentList.isNotEmpty) {
      for (var e in DocumentList) {
        getDocument(e.path.toString());
      }
    } else if (AudioList.isNotEmpty) {
      for (var e in AudioList) {
        savedata(e.data.toString());
      }
    } else {
      send();
    }
  }

  Future getImage(String _path, bool isImage) async {
    late File _image;
    firebase_storage.Reference storageReference =
    firebase_storage.FirebaseStorage.instance.ref().child(
        '${isImage
            ? 'Auto_Sender_pictures'
            : 'Auto_Sender_video'}/${Constants_Usermast.mobile_number}/${path
            .basename(_path)}');
    _image = File(_path);
    var filesize = _image.lengthSync() < 1001
        ? "${_image.lengthSync()} BYTE"
        : _image.lengthSync() < 1000001
        ? "${(_image.lengthSync() / 1000).toStringAsFixed(2)} KB"
        : "${(_image.lengthSync() / 1000000).toStringAsFixed(2)} MB";
    firebase_storage.UploadTask uploadTask = storageReference.putFile(_image);
    uploadTask.whenComplete(() => 'print');
    var dowurl =
    await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    if (dowurl.isNotEmpty) {
      String mStrDownloadUrl = dowurl.toString();
      setState(() {
        SendMediaList.add({
          'msg_document_url': mStrDownloadUrl.trim(),
          'msg_audio_name': path.basename(_path).trim(),
          'msg_media_size': filesize.trim(),
          'msg_type': isImage ? '2' : '5',
        });
      });

      if (Image_Video_List.length == SendMediaList.length) {
        send();
      }

      String sentpath = isImage
          ? path.join(Folder.sentMedia.path,
          '${path
              .basename(_path)
              .split('.')
              .first}.webp')
          : path.join(Folder.sentVideo.path, path.basename(_path));
      await File(_path).copy(sentpath);
    }
  }

  Future getDocument(String _path) async {
    late File _file;
    firebase_storage.Reference storageReference =
    firebase_storage.FirebaseStorage.instance.ref().child(
        '${'Auto_Sender_document'}/${Constants_Usermast.mobile_number}/${path
            .basename(_path)}');
    _file = File((_path));
    var filesize = _file.lengthSync() < 1001
        ? "${_file.lengthSync()} BYTE"
        : _file.lengthSync() < 1000001
        ? "${(_file.lengthSync() / 1000).toStringAsFixed(2)} KB"
        : "${(_file.lengthSync() / 1000000).toStringAsFixed(2)} MB";
    firebase_storage.UploadTask uploadTask = storageReference.putFile(_file);
    uploadTask.whenComplete(() => 'print');
    var dowurl =
    await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    if (dowurl.isNotEmpty) {
      String mStrDownloadUrl = dowurl.toString();
      setState(() {
        SendMediaList.add({
          'msg_document_url': mStrDownloadUrl.trim(),
          'msg_audio_name': path.basename(_path).trim(),
          'msg_media_size': filesize.trim(),
          'msg_type': '4',
        });
      });
      if (DocumentList.length == SendMediaList.length) {
        send();
      }
      String sentpath =
      path.join(Folder.sentdocument.path, path.basename(_path));
      await File(_path).copy(sentpath);
    }
  }

  Future<void> savedata(String _path) async {
    late File _image;
    firebase_storage.Reference storageReference =
    firebase_storage.FirebaseStorage.instance.ref().child(
        '${'Auto_Sender_Audio'}/${Constants_Usermast.mobile_number}/${path
            .basename(_path)}');
    _image = File((_path));
    var filesize = _image.lengthSync() < 1001
        ? "${_image.lengthSync()} BYTE"
        : _image.lengthSync() < 1000001
        ? "${(_image.lengthSync() / 1000).toStringAsFixed(2)} KB"
        : "${(_image.lengthSync() / 1000000).toStringAsFixed(2)} MB";
    firebase_storage.UploadTask uploadTask = storageReference.putFile(_image);
    uploadTask.whenComplete(() => 'print');
    var mStrDownloadUrl =
    await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    if (mStrDownloadUrl.isNotEmpty) {
      setState(() {
        SendMediaList.add({
          'msg_document_url': mStrDownloadUrl.trim(),
          'msg_audio_name': path.basename(_path).trim(),
          'msg_media_size': filesize.trim(),
          'msg_type': '3',
        });
      });
      if (AudioList.length == SendMediaList.length) {
        send();
      }
    }
  }

  Future getDateTime() async {
    _selectTime(context);
    _selectDate(context);
    _BirthController.text = DateFormat("dd MMM yyyy").format(selectedDate);
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
    }
  }

  bool compareTimeOfDay(DateTime SeletedDate, TimeOfDay time1,
      TimeOfDay time2) {
    if (SeletedDate.year > DateTime
        .now()
        .year) {
      return true;
    } else if (SeletedDate.year < DateTime
        .now()
        .year) {
      return false;
    } else {
      if (SeletedDate.month > DateTime
          .now()
          .month) {
        return true;
      } else if (SeletedDate.month < DateTime
          .now()
          .month) {
        return false;
      } else {
        if (SeletedDate.day > DateTime
            .now()
            .day) {
          return true;
        } else if (SeletedDate.day < DateTime
            .now()
            .day) {
          return false;
        } else {
          if (time1.hour > time2.hour) {
            return false;
          } else if (time1.hour < time2.hour) {
            return true;
          } else {
            if (time1.minute > time2.minute) {
              return false;
            } else if (time1.minute < time2.minute) {
              return true;
            } else {
              return false;
            }
          }
        }
      }
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null &&
        picked != selectedTime &&
        compareTimeOfDay(selectedDate, TimeOfDay.now(), picked)) {
      setState(() {
        setState(() {
          selectedTime = picked;
          _hour = selectedTime.hour.toString();
          _minute = selectedTime.minute.toString();
          _time = _hour + ' : ' + _minute;
          _timeController.text = _time;
          _timeController.text = formatDate(
              DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
              [hh, ':', nn, " ", am]).toString();
        });
      });
    } else {
      // setState(() {
      //   selectedTime = TimeOfDay.now();
      // });
      Fluttertoast.showToast(
        msg: "Please Select Correct Time",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
