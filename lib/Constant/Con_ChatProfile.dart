import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextapp/Constant/Con_AppBar_ChatProfile.dart';
import 'package:nextapp/Constant/Con_Clr.dart';
import 'package:nextapp/Constant/Constants.dart';

import '../mdi_page/Message/msg_sub_contactsdetails.dart';
import 'Con_Profile_Get.dart';
import 'Con_Wid.dart';

class ChatProfile extends StatefulWidget {
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

  ChatProfile(
      {Key? key,
      required this.mStrMobile,
      required this.usermastid,
      required this.mStrName,
      required this.mStrProfile,
      required this.mBlnFav,
      required this.mStrLastBio,
      required this.mStrLastBioDate,
      required this.mBlnLastOnline,
      required this.mStrLastLoginTime,
      required this.mStrLastBirthdate,
      required this.mStrLastfinalmobilenumber,
      required this.mBlnBlock})
      : super(key: key);

  @override
  _ChatProfileState createState() => _ChatProfileState();
}

class _ChatProfileState extends State<ChatProfile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Con_transparent,
          child: ListTile(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(
                      builder: (context) => sub_contactsdetails(
                          widget.mStrMobile,
                          widget.usermastid,
                          widget.mStrName,
                          widget.mStrProfile,
                          widget.mBlnFav,
                          widget.mStrLastBio,
                          widget.mStrLastBioDate,
                          widget.mBlnLastOnline,
                          widget.mStrLastLoginTime,
                          widget.mStrLastBirthdate,
                          widget.mStrLastfinalmobilenumber,
                          widget.mBlnBlock)));
            },
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(
                        builder: (context) => sub_show_profile_details(
                            widget.mStrMobile.toString(),
                            widget.mStrName.toString(),
                            widget.mStrProfile)));
              },
              child: widget.mBlnLastOnline == true
                  ? Stack(
                      children: [
                        Con_profile_get(
                          pStrImageUrl: widget.mStrProfile.isEmpty
                              ? ''
                              : widget.mStrProfile,
                          Size: 45,
                        ),
                        widget.mBlnLastOnline == true
                            ? Positioned(
                                left: 32,
                                top: 32,
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
                                        Radius.elliptical(
                                            48, 48.02000045776367)),
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    )
                  : Con_profile_get(
                      pStrImageUrl: widget.mStrProfile,
                      Size: 45,
                    ),
            ),
            title: Text(
              widget.mStrName,
              style: const TextStyle(
                fontSize: Constants_Fonts.mGblFontTitleSize,
              ),
            ),
            subtitle: Text(
              widget.mStrLastBio,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: Constants_Fonts.mGblFontSubTitleSize,
                  color: getPlatformBrightness()
                      ? Dark_AppGreyColor
                      : AppGreyColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
