import 'package:flutter/material.dart';
import 'package:nextapp/A_FB_Trigger/SharedPref.dart';
import 'package:nextapp/A_Local_DB/Sync_Json.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:nextapp/Constant/Constants.dart';

import '../A_FB_Trigger/sql_need_contact.dart';
import '../Constant/Con_Clr.dart';
import '../Constant/Con_Profile_Get.dart';
import '../Constant/Con_Wid.dart';
import 'Message/msg_sub_contactsdetails.dart';

class FavoriteContacts extends StatefulWidget {
  const FavoriteContacts({Key? key}) : super(key: key);

  @override
  _FavoriteContacts createState() => _FavoriteContacts();
}

class _FavoriteContacts extends State<FavoriteContacts> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Container(
        color: getPlatformBrightness() ? DarkTheme_Main : LightTheme_White,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Favourite Contacts',
                  ),
                ),
                PopupMenuButton<String>(
                  splashRadius: 20,
                  icon: const Icon(
                    Icons.more_horiz,
                  ),
                  onSelected: (String result) {
                    switch (result) {
                      case "Refresh":
                        setState(() {
                          SyncJSon.user_contact_select_contacts(2);
                        });
                        break;
                      case "Remove List":
                        if (mounted) {
                          setState(() {
                            Constants_Usermast
                                .user_chat_bln_favourite_contacts = false;
                            SharedPref.save_bool(
                                'user_chat_bln_favourite_contacts', false);
                          });
                        }
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      height: 30,
                      child: Text(
                        "Refresh",
                      ),
                      value: "Refresh",
                    ),
                    const PopupMenuItem(
                      height: 0,
                      enabled: false,
                      child: Divider(
                        color: Con_Main_1,
                      ),
                    ),
                    const PopupMenuItem(
                      height: 30,
                      child: Text(
                        "Remove List",
                      ),
                      value: "Remove List",
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
                height: 83.0,
                child: ReorderableListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: Constants_List.needs_fav.length,
                  itemBuilder: (BuildContext context, int index) {
                    Need_Contact need = Constants_List.needs_fav[index];
                    return GestureDetector(
                      key: ValueKey(index),
                      onTap: () {
                        Navigator.push(
                            context,
                            RouteTransitions.slideTransition(
                                sub_contactsdetails(
                                    need.id.toString(),
                                    need.user_mast_id.toString(),
                                    need.name.toString(),
                                    need.user_profileimage_path.toString(),
                                    need.user_is_favourite,
                                    need.user_bio,
                                    need.user_bio_last_datetime,
                                    need.user_is_online,
                                    need.user_last_login_time,
                                    need.user_birthdate,
                                    need.user_countrywithmobile,
                                    need.user_is_block)));
                      },
                      child: Column(
                        children: [
                          Con_profile_get(
                            pStrImageUrl: need.user_profileimage_path,
                            Size: 45,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: SizedBox(
                              width: 75,
                              child: Align(
                                  child: Text(
                                need.name,
                                overflow: TextOverflow.ellipsis,
                              )),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  onReorder: (int oldIndex, int newIndex) => setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final Need_Contact item =
                        Constants_List.needs_fav.removeAt(oldIndex);
                    Constants_List.needs_fav.insert(newIndex, item);
                  }),
                )),
          ],
        ),
      );
    });
  }
}
