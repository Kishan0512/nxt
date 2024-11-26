import 'package:flutter/material.dart';

import '../../A_FB_Trigger/USER_MSG_AUTOSENDER.dart';
import '../../A_Local_DB/Sync_Json.dart';
import '../../A_SQL_Trigger/sql_auto_sender.dart';
import '../../Constant/Con_Clr.dart';
import '../../Constant/Con_Icons.dart';
import '../../Constant/Con_Profile_Get.dart';
import '../../Constant/Con_Wid.dart';
import '../../Constant/Constants.dart';
import '../../mdi_page/Message/msg_auto_sender.dart';
import '../A_ChatBubble/ImageBubble.dart';

class Auto_Sender_List extends StatefulWidget {
  const Auto_Sender_List({super.key});

  @override
  State<Auto_Sender_List> createState() => _Auto_SenderState();
}

enum PopUpData { Edit, Delete }

class _Auto_SenderState extends State<Auto_Sender_List> {
  List<USER_MSG_AUTOSENDER> Auto_Sender_List = [], auto_send_priview = [];
  List<String> litems = ["General", "Birthday", "Meeting", "Event", "Task"];
  int _value = 0;
  bool isSelected = false, isloading = false;
  String pStrBtnType = "General";

  @override
  void initState() {
    super.initState();
    Get_Data();
    setState(() {});
  }

  Get_Data() async {
    Auto_Sender_List = await SyncJSon.user_auto_sender_select();
    auto_send_priview = Auto_Sender_List.where(
            (e) => e.msgTypeBtn.toLowerCase() == litems[_value].toLowerCase())
        .toList();
    isloading = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Con_Wid.mIconButton(
          icon: Own_ArrowBack,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: true,
        title: Con_Wid.mAppBar("Auto Sender List"),
      ),
      body: Column(
        children: <Widget>[
          TopButton(),
          Expanded(child: messageInputArea()),
        ],
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
                            _value = (selected ? index : null)!;
                            isSelected = selected ? true : false;
                            pStrBtnType =
                                litems[index].toString().trim().trimLeft();
                          });
                          Get_Data();
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
        child: isloading
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: auto_send_priview.length,
                itemBuilder: (context, index) {
                  return Card(
                    shadowColor: getPlatformBrightness()
                        ? Dark_AppGreyColor
                        : AppBlueGreyColor2,
                    elevation: 2,
                    color: getPlatformBrightness()
                        ? Dark_MediaBox
                        : const Color(0xFFE5EDEF),
                    shape: RoundedRectangleBorder(
                        // side:
                        //     const BorderSide(color: Con_msg_auto_6, width: 1.5),
                        borderRadius: BorderRadius.circular(10)),
                    child: SizedBox(
                      height: auto_send_priview[index].mediaList.isNotEmpty
                          ? 400
                          : 180,
                      child: Column(children: [
                        Expanded(
                            child: Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Con_msg_auto_6))),
                          child: Row(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                      auto_send_priview[index]
                                          .msgTypeDateTime
                                          .toUpperCase(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  Text(auto_send_priview[index].msgTypeDateUtc),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(auto_send_priview[index]
                                    .msgTypeDateTimeUtc),
                                const SizedBox(
                                  height: 4,
                                )
                              ],
                            ),
                            const Spacer(),
                            PopupMenuButton<PopUpData>(
                              splashRadius: 20,
                              onSelected: (PopUpData result) {
                                setState(() {
                                  switch (result) {
                                    case PopUpData.Edit:
                                      Navigator.pushReplacement(
                                          context,
                                          RouteTransitions.slideTransition(Auto_Sender(
                                              auto_send_Edit:
                                                  auto_send_priview[index])));
                                      break;
                                    case PopUpData.Delete:
                                      sql_auto_sender_tran.Delete_Msg(
                                          id: auto_send_priview[index]
                                              .id
                                              .toString());
                                      auto_send_priview.removeAt(index);
                                      break;
                                  }
                                });
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<PopUpData>>[
                                const PopupMenuItem<PopUpData>(
                                  value: PopUpData.Edit,
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem<PopUpData>(
                                  value: PopUpData.Delete,
                                  child: Text('Delete'),
                                ),
                              ],
                            )
                          ]),
                        )),
                        auto_send_priview[index].mediaList.isNotEmpty
                            ? Expanded(
                                flex: 5,
                                child: Container(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Container(
                                          height: 20,
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Text(
                                              auto_send_priview[index]
                                                  .msgContent
                                                  .toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18)),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: GridView.builder(
                                              physics: auto_send_priview[index]
                                                      .mediaList
                                                      .any((e) =>
                                                          e.msgType == "3" ||
                                                          e.msgType == "4")
                                                  ? const BouncingScrollPhysics()
                                                  : const NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  auto_send_priview[index]
                                                      .mediaList
                                                      .length,
                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: auto_send_priview[index]
                                                          .mediaList
                                                          .any((e) =>
                                                              e.msgType == "3" ||
                                                              e.msgType == "4")
                                                      ? 1
                                                      : grid_count(auto_send_priview[index]
                                                          .mediaList
                                                          .length),
                                                  childAspectRatio: auto_send_priview[index]
                                                          .mediaList
                                                          .any((e) =>
                                                              e.msgType == "3" ||
                                                              e.msgType == "4")
                                                      ? 1 / 0.2
                                                      : aspect_ratio(
                                                          auto_send_priview[index]
                                                              .mediaList
                                                              .length),
                                                  mainAxisSpacing: 5,
                                                  crossAxisSpacing: 5),
                                              itemBuilder: (context, index1) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                      color: (auto_send_priview[index]
                                                                      .mediaList[
                                                                          index1]
                                                                      .msgType ==
                                                                  '3' ||
                                                              auto_send_priview[index]
                                                                      .mediaList[
                                                                          index1]
                                                                      .msgType ==
                                                                  '4')
                                                          ? getPlatformBrightness()
                                                              ? Dark_ChatField
                                                              : const Color(
                                                                  0xffecf5f7)
                                                          : Con_transparent
                                                              .withOpacity(
                                                                  0.03),
                                                      borderRadius: const BorderRadius.all(
                                                          Radius.circular(10)),
                                                      border: (auto_send_priview[index]
                                                                  .mediaList[index1]
                                                                  .msgType ==
                                                              '2')
                                                          ? Border.all(color: Con_transparent)
                                                          : Border.all(color: Con_msg_auto_6)),
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: (auto_send_priview[
                                                                  index]
                                                              .mediaList[index1]
                                                              .msgType ==
                                                          '2')
                                                      ? ImageBubble(
                                                          imageUrl:
                                                              auto_send_priview[
                                                                      index]
                                                                  .mediaList[
                                                                      index1]
                                                                  .msgDocumentUrl,
                                                          Padding: false,
                                                          blurhash: "",
                                                          imageName:
                                                              auto_send_priview[
                                                                      index]
                                                                  .mediaList[
                                                                      index1]
                                                                  .msgAudioName,
                                                          isRight: "1",
                                                          isVideo: false,
                                                          isCurve: true,
                                                          onTapChange: true,
                                                        )
                                                      : (auto_send_priview[
                                                                      index]
                                                                  .mediaList[
                                                                      index1]
                                                                  .msgType ==
                                                              '3')
                                                          ? Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(4),
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color:
                                                                          Con_msg_auto,
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(8)),
                                                                    ),
                                                                    child:
                                                                        Container(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              8),
                                                                      width: 34,
                                                                      height:
                                                                          34,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        image: DecorationImage(
                                                                            image:
                                                                                AssetImage("assets/images/no_cover11.webp")),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          child:
                                                                              Text(
                                                                            auto_send_priview[index].mediaList[index1].msgAudioName.length > 31
                                                                                ? auto_send_priview[index].mediaList[index1].msgAudioName.substring(0, 30) + '...'
                                                                                : auto_send_priview[index].mediaList[index1].msgAudioName,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Con_msg_auto_2,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          "<unknown> • ${auto_send_priview[index].mediaList[index1].msgMediaSize}"
                                                                          " • ${auto_send_priview[index].mediaList[index1].msgAudioName.split('.').last}",
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                8.6,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                Con_msg_auto,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          : (auto_send_priview[
                                                                          index]
                                                                      .mediaList[
                                                                          index1]
                                                                      .msgType ==
                                                                  '4')
                                                              ? Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                        padding:
                                                                            const EdgeInsets.all(4),
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          color:
                                                                              Con_msg_auto,
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(8)),
                                                                        ),
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              const EdgeInsets.only(top: 8),
                                                                          width:
                                                                              34,
                                                                          height:
                                                                              34,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            image:
                                                                                DecorationImage(image: AssetImage("assets/images/Doc.webp")),
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              auto_send_priview[index].mediaList[index1].msgAudioName.split('.').last.toUpperCase(),
                                                                              style: const TextStyle(fontSize: 8, color: Con_msg_auto),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        margin: const EdgeInsets.only(
                                                                            left:
                                                                                10),
                                                                        child: Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Container(
                                                                                margin: const EdgeInsets.symmetric(vertical: 10),
                                                                                child: Text(
                                                                                  auto_send_priview[index].mediaList[index1].msgAudioName.length > 31 ? auto_send_priview[index].mediaList[index1].msgAudioName.substring(0, 30) + '...' : auto_send_priview[index].mediaList[index1].msgAudioName,
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: getPlatformBrightness() ? Con_white : Con_msg_auto_2,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                "<unknown> • ${auto_send_priview[index].mediaList[index1].msgMediaSize}"
                                                                                " • ${auto_send_priview[index].mediaList[index1].msgAudioName.split('.').last}",
                                                                                style: TextStyle(
                                                                                  fontSize: 8.6,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: getPlatformBrightness() ? Con_white : Con_msg_auto,
                                                                                ),
                                                                              ),
                                                                            ]),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : (auto_send_priview[
                                                                              index]
                                                                          .mediaList[
                                                                              index1]
                                                                          .msgType ==
                                                                      '5')
                                                                  ? ImageBubble(
                                                                      imageUrl: auto_send_priview[
                                                                              index]
                                                                          .mediaList[
                                                                              index1]
                                                                          .msgDocumentUrl,
                                                                      Padding:
                                                                          false,
                                                                      blurhash:
                                                                          "",
                                                                      imageName: auto_send_priview[
                                                                              index]
                                                                          .mediaList[
                                                                              index1]
                                                                          .msgAudioName,
                                                                      isRight:
                                                                          "1",
                                                                      isVideo:
                                                                          true,
                                                                      isCurve:
                                                                          true,
                                                                      onTapChange:
                                                                          true,
                                                                    )
                                                                  : Container(),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      ]),
                                ))
                            : Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Center(
                                          child: Text(
                                              auto_send_priview[index]
                                                  .msgContent
                                                  .toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18)),
                                        ),
                                        height: 60),
                                  ],
                                ),
                              ),
                        Expanded(
                            child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              border: Border(
                                  top: BorderSide(color: Con_msg_auto_6))),
                          child: Stack(
                              children: auto_send_priview[index]
                                  .msgToUserMastIds
                                  .split(',')
                                  .map(int.parse)
                                  .toList()
                                  .map((e) {
                            List<int> intList = auto_send_priview[index]
                                .msgToUserMastIds
                                .split(',')
                                .map(int.parse)
                                .toList();
                            var index5 = auto_send_priview[index]
                                .msgToUserMastIds
                                .split(',')
                                .map(int.parse)
                                .toList()
                                .indexOf(e);
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: double.parse(index5.toString()) * 25),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      color: getPlatformBrightness()
                                          ? Dark_ChatField
                                          : const Color(0xfff4f4f4),
                                      shape: BoxShape.circle),
                                  child: Con_profile_get(
                                    pStrImageUrl: Constants_List.need_contact
                                            .any((e) =>
                                                e.user_mast_id.toString() ==
                                                intList[index5].toString())
                                        ? Constants_List.need_contact
                                            .where((element) =>
                                                element.user_mast_id
                                                    .toString() ==
                                                intList[index5].toString())
                                            .last
                                            .user_profileimage_path
                                        : "assets/images/blank_profile.webp",
                                    Size: 45,
                                  ),
                                ),
                              ),
                            );
                          }).toList()),
                        )),
                      ]),
                    ),
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(
                color: Con_Main_1,
              )));
  }

  int grid_count(int count) {
    int value = 0;
    if (count == 1) {
      value = 1;
      return value;
    } else if (count == 2) {
      value = 2;
      return value;
    } else {
      value = 2;
      return value;
    }
  }

  double aspect_ratio(int count) {
    if (count == 1) {
      return 1.5;
    } else if (count == 2) {
      return 0.76;
    } else {
      return 1.48;
    }
  }
}
