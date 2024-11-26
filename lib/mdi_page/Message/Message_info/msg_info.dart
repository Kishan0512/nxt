import 'package:flutter/material.dart';
import 'package:nextapp/Constant/Con_Icons.dart';
import 'package:nextapp/Constant/Con_Wid.dart';

import '../../../Constant/Con_Clr.dart';
import '../../../Constant/Con_Profile_Get.dart';
import '../../A_ChatBubble/ImageBubble.dart';

class msg_info extends StatefulWidget {
  List<msginfo> Userlist;
  String msg_content;
  String msg_type;
  String send_time;
  String pStrBlurhash;
  bool is_alert;
  String Audioname;
  String imagename;
  String mediasize;

  msg_info(
      {Key? key,
      required this.Userlist,
      required this.msg_content,
      required this.msg_type,
      required this.send_time,
      required this.is_alert,
      required this.Audioname,
      required this.pStrBlurhash,
      required this.imagename,
      required this.mediasize})
      : super(key: key);

  @override
  State<msg_info> createState() => _msg_infoState();
}

class _msg_infoState extends State<msg_info> {
  bool zoom = false;
  List<msginfo> mListReadBy = [];
  List<msginfo> mListDeliverdTo = [];
  List<msginfo> mListRemaining = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mListReadBy = widget.Userlist.where(
        (e) => e.ReadTime != 'null' && e.DeliverdTime != 'null').toList();
    mListDeliverdTo = widget.Userlist.where(
        (e) => e.ReadTime == 'null' && e.DeliverdTime != 'null').toList();
    mListRemaining = widget.Userlist.where(
        (e) => e.ReadTime == 'null' && e.DeliverdTime == 'null').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: Con_Wid.mIconButton(
          icon: Own_ArrowBack,
          onPressed: () {
            Navigator.pop(context);
            widget.is_alert == false ? Navigator.pop(context) : null;
          },
        ),
        title: const Text(
          'Message info',
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: Column(
        children: [
          Stack(children: [
            Container(
              padding: const EdgeInsets.only(right: 5, top: 7),
              color: Con_transparent,
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: widget.msg_type == "3" || widget.msg_type == "4"
                        ? 235
                        : 250,
                  ),
                  decoration: BoxDecoration(
                    border: widget.msg_type == "2" || widget.msg_type == "5"
                        ? Border.all(
                            color: const Color(0xFF407F8F),
                          )
                        : null,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    color: widget.msg_type == "2" || widget.msg_type == "5"
                        ? Con_Clr_App_7.withOpacity(0.65)
                        : null,
                  ),
                  child: Padding(
                    padding: widget.msg_type == "2" || widget.msg_type == "5"
                        ? const EdgeInsets.only(
                            top: 1,
                            left: 1,
                            right: 1,
                          )
                        : widget.msg_type == "4"
                            ? const EdgeInsets.all(4.0)
                            : const EdgeInsets.all(8.0),
                    child: Wrap(children: [
                      if (widget.msg_type == "2" || widget.msg_type == "5")
                        ImageBubble(
                          imageUrl: widget.imagename,
                          blurhash: widget.pStrBlurhash,
                          imageName: widget.Audioname,
                          isRight: "1",
                          isVideo: widget.msg_type == "5" ? true : false,
                        )
                      else if (widget.msg_type == "1")
                        Container(
                          constraints: const BoxConstraints(
                              minHeight: 85, maxHeight: 430),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 20.0, bottom: 20, left: 20.0),
                            child: SingleChildScrollView(
                              reverse: true,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Container(
                                    constraints: widget.is_alert
                                        ? const BoxConstraints(
                                            maxWidth: 250,
                                          )
                                        : const BoxConstraints(
                                            maxWidth: 300,
                                          ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Wrap(
                                        alignment: WrapAlignment.end,
                                        children: [
                                          Text(
                                            widget.msg_content,
                                            softWrap: true,
                                          ),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10, left: 10),
                                              padding: EdgeInsets.zero,
                                              child: Text(
                                                widget.send_time,
                                                style: const TextStyle(
                                                    fontSize: 8),
                                              )),
                                        ],
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xFF407F8F)),
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            topRight: Radius.zero,
                                            bottomRight: Radius.circular(10)),
                                        color: const Color(0xE80784A4)
                                            .withOpacity(0.65)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      else if (widget.msg_type == "4")
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xb0348296),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(top: 8),
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/Doc.webp"))),
                                child: Center(
                                    child: Text(
                                  (widget.Audioname.split(".").last)
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 8,
                                  ),
                                )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 8),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.Audioname.length > 16
                                            ? widget.Audioname.substring(
                                                    1, 15) +
                                                "..."
                                            : widget.Audioname,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Con_white,
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  3, 8, 3, 3),
                                              child: Text(
                                                widget.mediasize,
                                                style: const TextStyle(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w500,
                                                  color: Con_white,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  3, 8, 3, 3),
                                              child: const Text(
                                                "•",
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w500,
                                                  color: Con_white,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  3, 8, 3, 3),
                                              child: Text(
                                                (widget.Audioname.split(".")
                                                        .last)
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w500,
                                                  color: Con_white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        )
                      else if (widget.msg_type == "3")
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(
                                widget.Audioname,
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            // VoiceMessage(
                            //   audioSrc: pStrImage,
                            //   audioLocalSrc:
                            //       "${Folder.audio.path}/$pStrAudioName",
                            //   me: true,
                            //   played: false,
                            //   meBgColor: Con_Main_1,
                            //   meFgColor: Con_white,
                            //   mePlayIconColor: Con_Main_1,
                            // ),
                          ],
                        ),
                    ]),
                  ),
                ),
              ),
            ),
          ]),
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 7),
                child: Container(
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 40 + (mListReadBy.length * 55)),
                        child: const Divider(
                          color: Color(0xffd2c6c6),
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Read By",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                mListRemaining.length + mListDeliverdTo.length >
                                        0
                                    ? Text(
                                        "${mListRemaining.length + mListDeliverdTo.length} Remaining",
                                        style: const TextStyle(
                                            color: Con_black54,
                                            fontWeight: FontWeight.w500),
                                      )
                                    : const Text(''),
                              ],
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            Container(
                              height: double.parse(
                                  (55 * mListReadBy.length).toString()),
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: mListReadBy.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: Con_profile_get(
                                      pStrImageUrl:
                                          mListReadBy[index].mStrProfile,
                                      Size: 40,
                                    ),
                                    title: Text(mListReadBy[index].mStrName),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Read : ${mListReadBy[index].ReadTime}',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Con_black54)),
                                        Text(
                                            'Delivered : ${mListReadBy[index].DeliverdTime}',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Con_black54)),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            mListRemaining.length + mListDeliverdTo.length > 0
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Delivered To",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      mListRemaining.length > 0
                                          ? Text(
                                              "${mListRemaining.length} Remaining",
                                              style: const TextStyle(
                                                  color: Con_black54,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          : Text(''),
                                    ],
                                  )
                                : Container(),
                            const SizedBox(
                              height: 7,
                            ),
                            mListDeliverdTo.isEmpty
                                ? Container()
                                : Container(
                                    height: double.parse(
                                        (55 * mListDeliverdTo.length)
                                            .toString()),
                                    child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: mListDeliverdTo.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          leading: Con_profile_get(
                                            pStrImageUrl: mListDeliverdTo[index]
                                                .mStrProfile,
                                            Size: 40,
                                          ),
                                          title: Text(
                                              mListDeliverdTo[index].mStrName),
                                          subtitle: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'Delivered : ${mListDeliverdTo[index].DeliverdTime}',
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Con_black54)),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffd2c6c6)),
                      color: getPlatformBrightness()
                          ? DarkTheme_AppBar
                          : const Color(0xfff8f2f2),
                      boxShadow: [
                        BoxShadow(
                            color: Con_black.withOpacity(0.16),
                            blurRadius: 3,
                            offset: const Offset(3, 0))
                      ],
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class msginfo {
  String Userid;
  String ReadTime;
  String DeliverdTime;
  String mStrName;
  String mStrProfile;

  msginfo({
    required this.Userid,
    required this.ReadTime,
    required this.DeliverdTime,
    required this.mStrName,
    required this.mStrProfile,
  });

  static Map<String, dynamic> toJson(msginfo h) {
    return {
      'Userid': h.Userid,
      'ReadTime': h.ReadTime,
      'DeliverdTime': h.DeliverdTime,
      'mStrName': h.mStrName,
      'mStrProfile': h.mStrProfile
    };
  }
}
