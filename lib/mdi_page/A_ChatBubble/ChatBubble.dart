import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:nextapp/Constant/FindSearchWord.dart';
import 'package:nextapp/Settings/Folders/Folder.dart';
import 'package:open_file/open_file.dart';

import '../../Constant/Con_AppBar_ChatProfile.dart';
import '../../Constant/Con_Clr.dart';
import '../../Constant/Con_Wid.dart';
import 'DocumentBubble.dart';
import 'ImageBubble.dart';
import 'audio/voice_message.dart';

List<String> selected_needs_sub_msg = [];
bool mBoolMsgSelectMode = false;

class ChatBubble {
  Widget ShowChatBubble(
      BuildContext context,
      String pStrIsRight,
      String pStrMsgType,
      String pStrMsgContent,
      String pStrImage,
      String pStrAudioName,
      String pStrMediaSize,
      String pStrDate,
      String pStrIsRead,
      String pStrIsDelivered,
      String pStrCenterDate,
      String pStrId,
      String msgToUserMastId,
      String msgFromUserMastId,
      String pStrMsgSearch,
      String pStrFromName,
      String pStrblurhash,
      {required ValueChanged<List<String>> onSelected,
      String? SearchSelected,
      ValueChanged<String>? SearchChange}) {
    Widget child;
    if (pStrIsRight == "1") {
      child = Stack(
        children: [
          Container(
            // margin: EdgeInsets.only(top: 10),
            padding: const EdgeInsets.only(right: 5),
            color: (selected_needs_sub_msg.contains(pStrId) == false)
                ? Con_transparent
                : const Color(0xFF7AB5C2).withOpacity(0.60),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth:
                      pStrMsgType == "3" || pStrMsgType == "4" ? 260 : 250,
                ),
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   color: const Color(0xFF407F8F),
                  // ),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    bottomLeft: const Radius.circular(10),
                    topRight: pStrIsRight == "1"
                        ? const Radius.circular(10)
                        : Radius.zero,
                    bottomRight: const Radius.circular(10),
                  ),
                  color: Con_msg_auto_6,
                ),
                child: Padding(
                  padding: pStrMsgType == "2"
                      ? const EdgeInsets.only(
                          top: 1,
                          left: 1,
                          right: 1,
                        )
                      : pStrMsgType == "4" || pStrMsgType == "5"
                          ? const EdgeInsets.all(5.0)
                          : const EdgeInsets.only(right: 8.0,left: 8,top: 8,bottom: 13),
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: [
                      if (pStrMsgType == "1")
                        pStrMsgSearch.isEmpty
                            ? RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: pStrMsgContent,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: getPlatformBrightness()
                                            ? Con_white
                                            : Con_white,
                                        backgroundColor: Con_transparent,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : FindSearchWord(
                                OnChange: SearchChange!,
                                pStrText: pStrMsgContent,
                                pStrId: pStrId,
                                SearchSelected: SearchSelected!,
                                pStrTextController: pStrMsgSearch)
                      else if (pStrMsgType == "2" || pStrMsgType == "5")
                        InkWell(
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              String? imageName;
                              if (selected_needs_sub_msg.isNotEmpty) {
                                if (mBoolMsgSelectMode == true) {
                                  if (selected_needs_sub_msg.contains(pStrId)) {
                                    mBoolMsgSelectMode = false;
                                    selected_needs_sub_msg.remove(pStrId);
                                    onSelected(selected_needs_sub_msg);
                                    if (selected_needs_sub_msg.isNotEmpty) {
                                      mBoolMsgSelectMode = true;
                                    }
                                  } else {
                                    mBoolMsgSelectMode = true;
                                    selected_needs_sub_msg.add(pStrId);
                                    onSelected(selected_needs_sub_msg);
                                  }
                                } else {}
                              }
                              if (selected_needs_sub_msg.isEmpty) {
                                if (pStrAudioName == "null") {
                                  var imageNameFrom =
                                      !pStrImage.contains("image_picker")
                                          ? pStrImage.indexOf("FCAP")
                                          : pStrImage.indexOf("image_picker");
                                  var imageNameTo = pStrImage.indexOf("?");
                                  imageName = !pStrImage
                                          .contains("image_picker")
                                      ? pStrImage
                                          .substring(imageNameFrom, imageNameTo)
                                          .replaceAll("FCAP", "nxt_")
                                      : pStrImage
                                          .substring(imageNameFrom, imageNameTo)
                                          .replaceAll("image_picker", "nxt_");
                                } else {
                                  imageName = pStrAudioName;
                                }
                              }
                              String imagePath;
                              if (await File(pStrMsgType == "2"
                                      ? "${Folder.sentMedia.path}/$imageName"
                                      : "${Folder.sentVideo.path}/$imageName")
                                  .exists()) {
                                imagePath = pStrMsgType == "2"
                                    ? "${Folder.sentMedia.path}/$imageName"
                                    : "${Folder.sentVideo.path}/$imageName";
                              } else {
                                imagePath = pStrMsgType == "2"
                                    ? "${Folder.images.path}/$imageName"
                                    : "${Folder.video.path}/$imageName";
                              }
                              if (await File(imagePath).exists()) {
                                if (pStrMsgType == "2") {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  SecondaryAnimation) =>
                                              sub_show_photos_details(
                                                imagePath,
                                                isLocal: true,
                                                isRight: pStrIsRight,
                                                pStrFromName: pStrFromName,
                                                pStrDate: pStrDate,
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
                                          transitionDuration: const Duration(
                                              milliseconds: 5000)));
                                }
                              }
                            },
                            child: ImageBubble(
                              imageUrl: pStrImage,
                              imageName: pStrAudioName,
                              isRight: pStrIsRight,
                              blurhash: pStrblurhash,
                              isVideo: pStrMsgType == "5" ? true : false,
                              selected:
                                  selected_needs_sub_msg.isEmpty ? false : true,
                              pStrFromName: pStrFromName,
                              pStrdate: pStrDate,
                            ))
                      else if (pStrMsgType == "3")
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(
                                pStrAudioName,
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            VoiceMessage(
                              audioSrc: pStrImage,
                              audioLocalSrc:
                                  "${Folder.audio.path}/$pStrAudioName",
                              me: true,
                              Duration: pStrMediaSize,
                              played: false,
                              meBgColor: Con_Main_1,
                              meFgColor: Con_white,
                              mePlayIconColor: Con_Main_1,
                            ),
                          ],
                        )
                      else if (pStrMsgType == "4")
                        GestureDetector(
                          onTap: () async {
                            String imagePath;
                            if (selected_needs_sub_msg.isNotEmpty) {
                              if (mBoolMsgSelectMode == true) {
                                if (selected_needs_sub_msg.contains(pStrId)) {
                                  mBoolMsgSelectMode = false;
                                  selected_needs_sub_msg.remove(pStrId);
                                  onSelected(selected_needs_sub_msg);
                                  if (selected_needs_sub_msg.isNotEmpty) {
                                    mBoolMsgSelectMode = true;
                                  }
                                } else {
                                  mBoolMsgSelectMode = true;
                                  selected_needs_sub_msg.add(pStrId);
                                  onSelected(selected_needs_sub_msg);
                                }
                              } else {}
                            }
                            try {
                              if (await File(
                                      "${Folder.sentdocument.path}/$pStrAudioName")
                                  .exists()) {
                                imagePath =
                                    "${Folder.sentdocument.path}/$pStrAudioName";
                              } else {
                                imagePath =
                                    "${Folder.Document.path}/$pStrAudioName";
                              }
                              await OpenFile.open(imagePath);
                            } catch (e) {
                              print("ERROR "+e.toString());
                            }
                          },
                          child: DocumentBubble(
                              imageUrl: pStrImage,
                              pStrAudioName: pStrAudioName,
                              pStrMediaSize: pStrMediaSize,
                              isRight: pStrIsRight),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(width: 60,),

                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(right: 25,bottom: 2,
            child: Container(
              margin: pStrMsgType == "2" || pStrMsgType == "5"
                  ? const EdgeInsets.only(top: 0, left: 10, bottom: 3)
                  : pStrMsgType == "3"
                  ? const EdgeInsets.only(top: 0, left: 5)
                  : const EdgeInsets.only(top: 6, left: 10),
              padding: EdgeInsets.zero,
              child: Text(
                (pStrDate != null
                    ? (pStrDate.substring(11, pStrDate.length))
                    : '')
                    .trim()
                    .trimRight()
                    .trimLeft(),
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 9,
                  color:
                  getPlatformBrightness() ? Con_white : Con_white,
                ),
              ),
            ),
          ),
          Positioned(right: 10,bottom: 3,
            child: Container(
              margin: pStrMsgType == "2" || pStrMsgType == "5"
                  ? const EdgeInsets.only(
                  top: 0, left: 2.5, right: 5, bottom: 3.5)
                  : pStrMsgType == "3"
                  ? const EdgeInsets.only(top: 0, left: 5)
                  : const EdgeInsets.only(top: 5, left: 2),
              child: pStrIsDelivered != 'true'
                  ? Constants_Usermast.user_icon_selected == 0
                  ? Image.asset(Con_Wid.Ticks_Style_1['send'],
                  height: 10,
                  width: 10,
                  color: (getPlatformBrightness()
                      ? Con_white
                      : Con_white))
                  : Constants_Usermast.user_icon_selected == 1
                  ? Image.asset(Con_Wid.Ticks_Style_2['send'],
                  height: 10,
                  width: 10,
                  color: (getPlatformBrightness()
                      ? Con_white
                      : Con_white))
                  : Constants_Usermast.user_icon_selected == 2
                  ? Image.asset(
                  Con_Wid.Ticks_Style_3['send'],
                  height: 10,
                  width: 10,
                  color: (getPlatformBrightness()
                      ? Con_white
                      : Con_white))
                  : Constants_Usermast
                  .user_icon_selected ==
                  3
                  ? Image.asset(
                  Con_Wid.Ticks_Style_4['send'],
                  height: 10,
                  width: 10,
                  color: (getPlatformBrightness()
                      ? Con_white
                      : Con_white))
                  : const Icon(Icons.add)
                  : Constants_Usermast.user_icon_selected == 0
                  ? Image.asset(
                Con_Wid.Ticks_Style_1['delivered'],
                height: 10,
                width: 10,
                color: pStrIsRead.toLowerCase() != 'true'
                    ? (getPlatformBrightness()
                    ? Con_white
                    : Con_white)
                    : (getPlatformBrightness()
                    ? Dark_Read_Tick
                    : Con_white),
              )
                  : Constants_Usermast.user_icon_selected == 1
                  ? Image.asset(
                Con_Wid.Ticks_Style_2['delivered'],
                height: 10,
                width: 10,
                color:
                pStrIsRead.toLowerCase() != 'true'
                    ? (getPlatformBrightness()
                    ? Con_white
                    : Con_white)
                    : getPlatformBrightness()
                    ? Dark_Read_Tick
                    : Con_white,
              )
                  : Constants_Usermast.user_icon_selected == 2
                  ? Image.asset(
                Con_Wid.Ticks_Style_3['delivered'],
                height: 10,
                width: 10,
                color: pStrIsRead.toLowerCase() !=
                    'true'
                    ? (getPlatformBrightness()
                    ? Con_white
                    : Con_white)
                    : getPlatformBrightness()
                    ? Dark_Read_Tick
                    : Con_white,
              )
                  : Constants_Usermast
                  .user_icon_selected ==
                  3
                  ? Image.asset(
                Con_Wid
                    .Ticks_Style_4['delivered'],
                height: 10,
                width: 10,
                color: pStrIsRead
                    .toLowerCase() !=
                    'true'
                    ? (getPlatformBrightness()
                    ? Con_white
                    : Con_white)
                    : getPlatformBrightness()
                    ? Dark_Read_Tick
                    : Con_white,
              )
                  : const Icon(Icons.add),
            ),
          ),
          // Align(
          //   alignment: Alignment.topRight,
          //   child: Container(
          //     margin: EdgeInsets.only(right: 12),
          //     decoration: BoxDecoration(
          //         color: const Color(0xFF7AB5C2),
          //         borderRadius: BorderRadius.circular(5),
          //         border: Border.all(
          //           color: const Color(0xFF407F8F),
          //         )),
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //       child: Text(
          //         'BirthDay',
          //         style: TextStyle(color: Con_black, fontSize: 12),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      );
    }
    else if (pStrIsRight == "2") {
      child = Stack(
        children: [
          Container(
            color: (selected_needs_sub_msg.contains(pStrId) == false)
                ? Con_transparent
                : const Color(0xFF7AB5C2).withOpacity(0.60),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 5),
                constraints: BoxConstraints(
                  maxWidth:
                      pStrMsgType == "3" || pStrMsgType == "4" ? 235 : 250,
                ),
                decoration: BoxDecoration(
                  // border: Border.all(color: Con_Main_1, width: 0.5),
                  borderRadius: BorderRadius.only(
                    topLeft: pStrIsRight == "0"
                        ? const Radius.circular(10)
                        : Radius.zero,
                    bottomLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10),
                    bottomRight: const Radius.circular(10),
                  ),
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: pStrMsgType == "2"
                          ? const EdgeInsets.only(
                              top: 1,
                              left: 1,
                              right: 1,
                            )
                          : pStrMsgType == "4" || pStrMsgType == "5"
                              ? const EdgeInsets.all(5.0)
                              : const EdgeInsets.only(top: 8.0,left: 8,right: 8,bottom: 12),
                      child: Wrap(
                        runAlignment: WrapAlignment.end,
                        alignment: WrapAlignment.end,
                        children: [
                          if (pStrMsgType == "1")
                            pStrMsgSearch.isEmpty
                                ? RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: pStrMsgContent,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: getPlatformBrightness()
                                                ? Con_white
                                                : Con_msg_auto_6,
                                            backgroundColor:
                                                Con_Main_1.withOpacity(0.01),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : FindSearchWord(
                                    OnChange: SearchChange!,
                                    pStrText: pStrMsgContent,
                                    pStrId: pStrId,
                                    SearchSelected: SearchSelected!,
                                    pStrTextController: pStrMsgSearch)
                          else if (pStrMsgType == "2" || pStrMsgType == "5")
                            GestureDetector(
                                onTap: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  String imageName;
                                  if (selected_needs_sub_msg.isNotEmpty) {
                                    if (mBoolMsgSelectMode == true) {
                                      if (selected_needs_sub_msg.contains(pStrId)) {
                                        mBoolMsgSelectMode = false;
                                        selected_needs_sub_msg.remove(pStrId);
                                        onSelected(selected_needs_sub_msg);
                                        if (selected_needs_sub_msg.isNotEmpty) {
                                          mBoolMsgSelectMode = true;
                                        }
                                      } else {
                                        mBoolMsgSelectMode = true;
                                        selected_needs_sub_msg.add(pStrId);
                                        onSelected(selected_needs_sub_msg);
                                      }
                                    } else {}
                                  }
                                  if (selected_needs_sub_msg.isEmpty) {
                                    if (pStrAudioName == "null") {
                                      var imageNameFrom =
                                          !pStrImage.contains("image_picker")
                                              ? pStrImage.indexOf("FCAP")
                                              : pStrImage.indexOf("image_picker");
                                      var imageNameTo = pStrImage.indexOf("?");
                                      imageName = !pStrImage
                                              .contains("image_picker")
                                          ? pStrImage
                                              .substring(imageNameFrom, imageNameTo)
                                              .replaceAll("FCAP", "nxt_")
                                          : pStrImage
                                              .substring(imageNameFrom, imageNameTo)
                                              .replaceAll("image_picker", "nxt_");
                                    } else {
                                      imageName = pStrAudioName;
                                    }

                                    var imagePath = pStrMsgType == "2"
                                        ? "${Folder.images.path}/$imageName"
                                        : "${Folder.video.path}/$imageName";

                                    if (await File(imagePath).exists()) {
                                      if (pStrMsgType == "2") {
                                        Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                      SecondaryAnimation) =>
                                                  sub_show_photos_details(
                                                "${Folder.images.path}/$imageName",
                                                isLocal: true,
                                                isRight: pStrIsRight,
                                                pStrFromName: pStrFromName,
                                                pStrDate: pStrDate,
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
                                      }
                                    } else {}
                                  }
                                },
                                child: ImageBubble(
                                  imageUrl: pStrImage,
                                  imageName: pStrAudioName,
                                  isRight: pStrIsRight,
                                  blurhash: pStrblurhash,
                                  isVideo: pStrMsgType == "5" ? true : false,
                                  selected:
                                      selected_needs_sub_msg.isEmpty ? false : true,
                                  pStrFromName: pStrFromName,
                                  pStrdate: pStrDate,
                                ))
                          else if (pStrMsgType == "3")
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    pStrAudioName,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                VoiceMessage(
                                  audioSrc: pStrImage,
                                  audioLocalSrc:
                                      "${Folder.audio.path}/$pStrAudioName",
                                  me: true,
                                  played: false,
                                  Duration : pStrMediaSize,
                                  meBgColor: Con_Main_1,
                                  meFgColor: Con_white,
                                  mePlayIconColor: Con_Main_1,
                                ),
                              ],
                            )
                          else if (pStrMsgType == "4")
                            GestureDetector(
                              onTap: () async {
                                String? imagePath;
                                if (selected_needs_sub_msg.isNotEmpty) {
                                  if (mBoolMsgSelectMode == true) {
                                    if (selected_needs_sub_msg.contains(pStrId)) {
                                      mBoolMsgSelectMode = false;
                                      selected_needs_sub_msg.remove(pStrId);
                                      onSelected(selected_needs_sub_msg);
                                      if (selected_needs_sub_msg.isNotEmpty) {
                                        mBoolMsgSelectMode = true;
                                      }
                                    } else {
                                      mBoolMsgSelectMode = true;
                                      selected_needs_sub_msg.add(pStrId);
                                      onSelected(selected_needs_sub_msg);
                                    }
                                  } else {}
                                }
                                if (selected_needs_sub_msg.isEmpty) {
                                  try {
                                    if (await File(
                                            "${Folder.Document.path}/$pStrAudioName")
                                        .exists()) {
                                      imagePath =
                                          "${Folder.Document.path}/$pStrAudioName";
                                    } else {}
                                    await OpenFile.open(imagePath);
                                  } catch (e) {}
                                }
                              },
                              child: DocumentBubble(
                                  imageUrl: pStrImage,
                                  pStrAudioName: pStrAudioName,
                                  pStrMediaSize: pStrMediaSize,
                                  isRight: pStrIsRight),
                            ),
                          Container(width: 60,)
                        ],
                      ),
                    ),
                    Positioned(bottom: 3,
                      right: 10,
                      child: Container(
                        margin: pStrMsgType == "2" || pStrMsgType == "5"
                            ? const EdgeInsets.only(
                            top: 0, left: 2.5, right: 5, bottom: 3.5)
                            : pStrMsgType == "3"
                            ? const EdgeInsets.only(top: 0, left: 5)
                            : const EdgeInsets.only(top: 5, left: 2),
                        padding: EdgeInsets.zero,
                        child: Text(
                          (pStrDate != null
                              ? pStrDate.substring(11, pStrDate.length)
                              : '')
                              .trim()
                              .trimRight()
                              .trimLeft(),
                          style: TextStyle(
                            fontSize: 10,
                            color:
                            getPlatformBrightness() ? Con_white : Con_msg_auto_6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      );
    } else {
      child = Container();
    }
    return GestureDetector(
      onLongPress: pStrIsRight != "3"
          ? () {
              if (pStrMsgType == "1" ||
                  pStrMsgType == "2" ||
                  pStrMsgType == "3" ||
                  pStrMsgType == "4" ||
                  pStrMsgType == "5") {
                if (selected_needs_sub_msg.contains(pStrId)) {
                  mBoolMsgSelectMode = true;
                } else {
                  mBoolMsgSelectMode = true;
                  selected_needs_sub_msg.add(pStrId);
                }
                onSelected(selected_needs_sub_msg);
              }
            }
          : null,
      onTap: () {
        if (pStrMsgType == "1" ||
            pStrMsgType == "2" ||
            pStrMsgType == "3" ||
            pStrMsgType == "4" ||
            pStrMsgType == "5") {
          if (selected_needs_sub_msg.isNotEmpty) {
            if (mBoolMsgSelectMode == true) {
              if (selected_needs_sub_msg.contains(pStrId)) {
                mBoolMsgSelectMode = false;
                selected_needs_sub_msg.remove(pStrId);
                onSelected(selected_needs_sub_msg);
                if (selected_needs_sub_msg.isNotEmpty) {
                  mBoolMsgSelectMode = true;
                }
              } else {
                mBoolMsgSelectMode = true;
                selected_needs_sub_msg.add(pStrId);
                onSelected(selected_needs_sub_msg);
              }
            } else {}
          }
        }
      },
      child: Material(
        color: Con_transparent,
        child: ListTile(
          key: ValueKey(pStrId),
          visualDensity: const VisualDensity(vertical: -4),
          contentPadding: const EdgeInsets.only(left: 0, right: 0),
          title: child,
        ),
      ),
    );
  }

  static Widget CenterWidget(pStrDate) {
    pStrDate = DateFilter(pStrDate);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: getPlatformBrightness()
                ? const Color(0xff304f56)
                : const Color(0x61E4D5D5).withOpacity(
                    0.80,
                  ),
          ),
          child: Material(
            color: Con_transparent,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                pStrDate,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

DateTime Now = DateTime.now();
DateFormat DTF = DateFormat('MMM dd yyyy');
DateFormat DayF = DateFormat('EEEE');

DateFilter(String pStrDate) {
  pStrDate == GetDayDate(0)
      ? pStrDate = 'Today'
      : pStrDate == GetDayDate(1)
          ? pStrDate = 'Yesterday'
          : pStrDate == GetDayDate(2)
              ? pStrDate = GetDay(2)
              : pStrDate == GetDayDate(3)
                  ? pStrDate = GetDay(3)
                  : pStrDate == GetDayDate(4)
                      ? pStrDate = GetDay(4)
                      : pStrDate == GetDayDate(5)
                          ? pStrDate = GetDay(5)
                          : pStrDate == GetDayDate(6)
                              ? pStrDate = GetDay(6)
                              : pStrDate = pStrDate;

  return pStrDate;
}

GetDayDate(int Day) {
  if (Day == 0) {
    return DTF.format(Now);
  } else {
    return DTF.format(Now.subtract(Duration(days: Day))).toString();
  }
}

GetDay(int Day) {
  if (Day > 1) {
    return DayF.format(DTF.parse(GetDayDate(Day)));
  }
}
