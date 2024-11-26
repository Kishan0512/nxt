import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextapp/Constant/Con_Clr.dart';
import 'package:nextapp/Constant/Con_Icons.dart';

import '../A_FB_Trigger/sql_need_main_sub_chat.dart';
import '../OSFind.dart';
import '../mdi_page/Message/msg_sub_show_user_details.dart';
import 'Con_Profile_Get.dart';
import 'Con_Wid.dart';

class AppBarChatProfile extends StatefulWidget {
  late String mobilenumber;
  late String name;
  late String usermastid;
  late String user_profile;
  late String user_bio;
  late bool user_last_is_online;
  late String user_last_login_time;
  late String user_last_biodate;
  late bool mBlnIsBlockUserMe;
  late String user_last_birthdate;
  late String user_last_final_mobile_number;
  late bool user_block;
  late List<Need_Main_Sub_Chat> imageList;
  late List<Need_Main_Sub_Chat> videolist;
  late List<Need_Main_Sub_Chat> audiolist;
  late List<Need_Main_Sub_Chat> doculist;

  AppBarChatProfile({
    Key? key,
    required this.mobilenumber,
    required this.name,
    required this.usermastid,
    required this.user_profile,
    required this.user_bio,
    required this.user_last_is_online,
    required this.user_last_login_time,
    required this.user_last_biodate,
    required this.user_last_birthdate,
    required this.user_last_final_mobile_number,
    required this.user_block,
    required this.imageList,
    required this.mBlnIsBlockUserMe,
    required this.videolist,
    required this.audiolist,
    required this.doculist,
  }) : super(key: key);

  @override
  _ChatProfileState createState() => _ChatProfileState();
}

class _ChatProfileState extends State<AppBarChatProfile> {
  @override
  Widget build(BuildContext context) {
    return Os.isIOS
        ? widget.user_last_login_time.isNotEmpty
            ? ListTile(
                leading: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        RouteTransitions.slideTransition(sub_show_profile_details(
                            widget.mobilenumber.toString(),
                            widget.name.toString(),
                            widget.user_profile)));
                  },
                  child: Con_profile_get(
                    pStrImageUrl: widget.user_profile,
                    Size: 40,
                  ),
                ),
                title: GestureDetector(
                  onTap: () {
                    setState(() {
                      ReturnPage();
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: (widget.user_last_login_time.isEmpty ||
                                widget.mBlnIsBlockUserMe
                            ? 10.0
                            : 5.0)),
                    child: Text(widget.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Con_white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                subtitle: widget.mBlnIsBlockUserMe
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            ReturnPage();
                          });
                        },
                        child: Text(
                          widget.user_last_is_online == true
                              ? "Online"
                              : "Last Seen at " +
                                  widget.user_last_login_time.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 10,
                              color: Con_white70,
                              fontWeight: FontWeight.bold),
                        ),
                      ))
            : Material(
                color: Con_transparent,
                child: ListTile(
                  leading: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            RouteTransitions.slideTransition(sub_show_profile_details(
                                widget.mobilenumber.toString(),
                                widget.name.toString(),
                                widget.user_profile)));
                      },
                      child: Con_profile_get(
                        pStrImageUrl: widget.user_profile,
                        Size: 40,
                      )),
                  title: GestureDetector(
                    onTap: () {
                      setState(() {
                        ReturnPage();
                      });
                    },
                    child: Text(widget.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Con_white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              )
        : widget.user_last_login_time.isNotEmpty
            ? Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0.0, top: 4, right: 4, bottom: 4),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            RouteTransitions.slideTransition(sub_show_profile_details(
                                widget.mobilenumber.toString(),
                                widget.name.toString(),
                                widget.user_profile)));
                      },
                      child: Con_profile_get(
                        pStrImageUrl: widget.user_profile,
                        Size: 40,
                      ),
                    ),
                  ),
                  Expanded(
                    child: CupertinoListTile(
                        padding: EdgeInsets.zero,
                        title: GestureDetector(
                          onTap: () {
                            setState(() {
                              ReturnPage();
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: (widget.user_last_login_time.isEmpty
                                    ? 15.0
                                    : 5.0)),
                            child: Text(widget.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Con_white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        subtitle: GestureDetector(
                          onTap: () {
                            setState(() {
                              ReturnPage();
                            });
                          },
                          child: Text(
                            widget.user_last_is_online == true
                                ? "Online"
                                : "Last Seen at " +
                                    widget.user_last_login_time.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Con_white,
                                fontWeight: FontWeight.normal),
                          ),
                        )),
                  ),
                ],
              )
            : Material(
                color: Con_transparent,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 0.0, top: 4, right: 4, bottom: 4),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                RouteTransitions.slideTransition(sub_show_profile_details(
                                    widget.mobilenumber.toString(),
                                    widget.name.toString(),
                                    widget.user_profile)));
                          },
                          child: Con_profile_get(
                            pStrImageUrl: widget.user_profile,
                            Size: 40,
                          )),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CupertinoListTile(
                          padding: EdgeInsets.zero,
                          title: GestureDetector(
                            onTap: () {
                              setState(() {
                                ReturnPage();
                              });
                            },
                            child: Text(widget.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Con_white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }

  ReturnPage() {
    Navigator.push(
      context,
      RouteTransitions.slideTransition(
        sub_show_user_details(
          widget.usermastid,
          widget.mobilenumber.toString(),
          widget.name.toString(),
          widget.user_profile,
          widget.user_bio,
          widget.user_last_biodate,
          widget.user_last_birthdate,
          widget.user_last_final_mobile_number,
          widget.user_block,
          widget.imageList,
          widget.videolist,
          widget.audiolist,
          widget.doculist,
        ),
      ),
    );
  }
}

class sub_show_profile_details extends StatefulWidget {
  late String mStrMobile;
  late String mStrName;
  late String mStrProfile;

  sub_show_profile_details(this.mStrMobile, this.mStrName, this.mStrProfile,
      {Key? key})
      : super(key: key);

  @override
  _sub_show_profile_detailsPageState createState() =>
      _sub_show_profile_detailsPageState();
}

class _sub_show_profile_detailsPageState
    extends State<sub_show_profile_details> {
  _sub_show_profile_detailsPageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Con_black,
        title: Text(widget.mStrName, style: const TextStyle(color: Con_white)),
        leading: Container(
          margin: const EdgeInsets.only(left: 6),
          child: Con_Wid.mIconButton(
            icon: Own_ArrowBack,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: InteractiveViewer(
        child: Container(
          color: Con_black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                child: Con_profile_get(
                  pStrImageUrl: widget.mStrProfile,
                  Size: MediaQuery.of(context).size.width,
                  isSquare: true,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class sub_show_photos_details extends StatefulWidget {
  late String mStrProfile;
  String? pStrMediaName;
  String? isRight;
  String? pStrFromName;
  String? pStrDate;
  bool isLocal = false;

  sub_show_photos_details(this.mStrProfile,
      {Key? key,
      this.isLocal = false,
      this.pStrMediaName,
      this.pStrFromName,
      this.pStrDate,
      this.isRight})
      : super(key: key);

  @override
  _sub_show_photos_detailsPageState createState() =>
      _sub_show_photos_detailsPageState();
}

class _sub_show_photos_detailsPageState extends State<sub_show_photos_details> {
  _sub_show_photos_detailsPageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        titleSpacing: 0,
        leadingWidth: 42,
        leading: Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: Con_Wid.mIconButton(
            icon: Own_ArrowBack,
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${widget.isRight == "1" ? "You" : widget.pStrFromName}"),
            Text(
              "${widget.pStrDate}",
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        backgroundColor: Con_transparent.withOpacity(0.60),
      ),
      backgroundColor: AppBar_Font_PrimaryColor,
      body: InteractiveViewer(
        child: Container(
          color: Con_black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                  alignment: Alignment.center,
                  child: widget.isLocal
                      ? Image.file(File(widget.mStrProfile))
                      : Con_profile_get(
                          pStrImageUrl: widget.mStrProfile,
                          Size: double.infinity,
                          isSquare: true,
                        )),
            ],
          ),
        ),
      ),
    );
  }
}
