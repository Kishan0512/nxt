import 'package:flutter/material.dart';
import 'package:nextapp/A_SQL_Trigger/sql_sub_messages.dart';
import 'package:nextapp/Constant/Con_Clr.dart';
import 'package:nextapp/Constant/Con_Icons.dart';

import '../../A_FB_Trigger/sql_need_main_sub_chat.dart';
import '../../Constant/Con_Profile_Get.dart';
import '../../Constant/Con_Wid.dart';
import '../../Constant/Constants.dart';

class broad_msg_info extends StatefulWidget {
  String send_time, is_read_time, is_delivered_time;
  String is_read;
  String msg_content;
  String msg_type;
  String br_exist_user;
  String br_id;
  String broadcast_bulk_id;

  broad_msg_info({
    Key? key,
    required this.is_read,
    required this.is_read_time,
    required this.is_delivered_time,
    required this.send_time,
    required this.msg_content,
    required this.msg_type,
    required this.br_exist_user,
    required this.br_id,
    required this.broadcast_bulk_id,
  }) : super(key: key);

  @override
  State<broad_msg_info> createState() => _broad_msg_infoState();
}

class _broad_msg_infoState extends State<broad_msg_info> {
  bool zoom = false;
  List<Need_Main_Sub_Chat> show_contact_broad_read = [];
  List<Need_Main_Sub_Chat> show_contact_broad_delivered = [];

  Future<List<Need_Main_Sub_Chat>> _setupNeeds() async {
    List<Need_Main_Sub_Chat> list =
        await sql_sub_messages_tran.Sub_getMsg_broadcast(
            widget.broadcast_bulk_id, widget.br_id);
    setState(() {
      show_contact_broad_read =
          list.where((element) => element.is_read == '1').toList();
      show_contact_broad_delivered =
          list.where((element) => element.delivered_time != "null").toList();
    });
    return list;
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
          },
        ),
        title: const Text(
          'Message info',
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(right: 20.0, bottom: 20, left: 20.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    constraints: const BoxConstraints(
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
                              margin: const EdgeInsets.only(top: 10, left: 10),
                              padding: EdgeInsets.zero,
                              child: Text(
                                widget.send_time,
                                style: const TextStyle(fontSize: 8),
                              )),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF407F8F)),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            topRight: Radius.zero,
                            bottomRight: Radius.circular(10)),
                        color: const Color(0xE80784A4).withOpacity(0.65)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffd2c6c6)),
                    color: const Color(0xfff8f2f2),
                    boxShadow: [
                      BoxShadow(
                        color: Con_black.withOpacity(0.16),
                        blurRadius: 3,
                        offset: const Offset(3, 0),
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 15),
                      child: Text(
                        "Read",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppBar_ThemeColor),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: Divider(
                        indent: 3,
                        endIndent: 3,
                        color: Color(0xffd2c6c6),
                        thickness: 1,
                      ),
                    ),
                    FutureBuilder(
                        future: _setupNeeds(),
                        builder: (context, snapshot) {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: show_contact_broad_read.length,
                              itemBuilder: (BuildContext context, int index) {
                                var image = Constants_List.need_contact
                                        .where((element) =>
                                            element.user_mast_id.toString() ==
                                            show_contact_broad_read[index]
                                                .msg_to_user_mast_id)
                                        .isNotEmpty
                                    ? Constants_List.need_contact
                                        .where((element) =>
                                            element.user_mast_id.toString() ==
                                            show_contact_broad_read[index]
                                                .msg_to_user_mast_id)
                                        .first
                                        .user_profileimage_path
                                    : "";
                                var dispName = Constants_List.need_contact
                                        .where((element) =>
                                            element.user_mast_id.toString() ==
                                            show_contact_broad_read[index]
                                                .msg_to_user_mast_id)
                                        .isNotEmpty
                                    ? Constants_List.need_contact
                                        .where((element) =>
                                            element.user_mast_id.toString() ==
                                            show_contact_broad_read[index]
                                                .msg_to_user_mast_id)
                                        .first
                                        .name
                                    : "";
                                return ListTile(
                                    dense: true,
                                    onTap: () {},
                                    leading: Con_profile_get(
                                      pStrImageUrl: image,
                                      Size: 45,
                                    ),
                                    title: Text(
                                      dispName,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize:
                                              Constants_Fonts.mGblFontTitleSize,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    subtitle: Text(
                                      show_contact_broad_read[index].read_time,
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
                  ],
                ),
              ),
            ),
            Container(
              height: 15,
              color: Con_white,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffd2c6c6)),
                    color: const Color(0xfff8f2f2),
                    boxShadow: [
                      BoxShadow(
                          color: Con_black.withOpacity(0.16),
                          blurRadius: 3,
                          offset: const Offset(3, 0))
                    ],
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 15),
                      child: Text(
                        "Delivered",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppBar_ThemeColor),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: Divider(
                        indent: 3,
                        endIndent: 3,
                        color: Color(0xffd2c6c6),
                        thickness: 1,
                      ),
                    ),
                    FutureBuilder(
                        future: _setupNeeds(),
                        builder: (context, snapshot) {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: show_contact_broad_delivered.length,
                              itemBuilder: (BuildContext context, int index) {
                                var image = Constants_List.need_contact
                                        .where((element) =>
                                            element.user_mast_id.toString() ==
                                            show_contact_broad_delivered[index]
                                                .msg_to_user_mast_id)
                                        .isNotEmpty
                                    ? Constants_List.need_contact
                                        .where((element) =>
                                            element.user_mast_id.toString() ==
                                            show_contact_broad_delivered[index]
                                                .msg_to_user_mast_id)
                                        .first
                                        .user_profileimage_path
                                    : "";
                                var dispName = Constants_List.need_contact
                                        .where((element) =>
                                            element.user_mast_id.toString() ==
                                            show_contact_broad_delivered[index]
                                                .msg_to_user_mast_id)
                                        .isNotEmpty
                                    ? Constants_List.need_contact
                                        .where((element) =>
                                            element.user_mast_id.toString() ==
                                            show_contact_broad_delivered[index]
                                                .msg_to_user_mast_id)
                                        .first
                                        .name
                                    : "";
                                return ListTile(
                                    dense: true,
                                    onTap: () {},
                                    leading: Con_profile_get(
                                      pStrImageUrl: image,
                                      Size: 45,
                                    ),
                                    title: Text(
                                      dispName,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize:
                                              Constants_Fonts.mGblFontTitleSize,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    subtitle: Text(
                                      show_contact_broad_read[index]
                                          .delivered_time,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
