import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextapp/A_SQL_Trigger/sql_usermast.dart';
import 'package:nextapp/Con_Contacts/Con_Glb_Contacts.dart';
import 'package:nextapp/Constant/Con_Clr.dart';
import 'package:nextapp/Constant/Con_Icons.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:nextapp/Constant/Con_Wid.dart';
import 'package:nextapp/Constant/Constants.dart';
import 'package:nextapp/Settings/Privacy/set_sub_actsession_settings.dart';

import '../../A_FB_Trigger/sql_need_contact.dart';
import '../../A_Local_DB/Sync_Database.dart';
import '../../OSFind.dart';

class sub_privacy_settings extends StatefulWidget {
  const sub_privacy_settings({Key? key}) : super(key: key);

  @override
  _sub_privacy_settings createState() => _sub_privacy_settings();
}

class _sub_privacy_settings extends State<sub_privacy_settings> {
  List mlistpinfo = ["Everyone", "My Contact", "Nobody"];

  @override
  void initState() {
    super.initState();
    SyncDB.SyncTable(Constants.Table_User_Device_Session, false);
  }

  @override
  Widget build(BuildContext context) {
    return Os.isIOS
        ? Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: Con_Wid.mIconButton(
                icon: Own_ArrowBack,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Con_Wid.mAppBar("Privacy and Security"),
            ),
            body: _myListView(context),
          )
        : CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              backgroundColor: App_IconColor,
              padding: EdgeInsetsDirectional.zero,
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                child:
                    const Icon(CupertinoIcons.left_chevron, color: Con_white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              middle: const Text("Privacy and Secrity",
                  style: TextStyle(color: Con_white)),
            ),
            child: Cupertino_myListView(context));
  }

  Widget _myListView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: ListView(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text('Who can see my personal info',
                style: TextStyle(
                  color: App_IconColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                title: const Text('Profile Picture',style: TextStyle(fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold),),
                onTap: () => showMenu(context: context, position: RelativeRect.fromLTRB(100, 130, 30, 200), items: <PopupMenuEntry>[
                  PopupMenuItem(child: Text("Profile Picture",style: TextStyle(color: Con_msg_auto_6,fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold),)),
                  PopupMenuItem(
                    child: RadioListTile(
                        visualDensity: VisualDensity(vertical: VisualDensity.minimumDensity,horizontal: VisualDensity.minimumDensity),
                        value: 0,
                        activeColor: App_IconColor,
                        groupValue:
                        Constants_Usermast.use_show_profilepicture,
                        title: const Text("Everyone"),
                        onChanged: (int? val) {
                          {
                            setState(() {
                              Constants_Usermast.use_show_profilepicture =
                              val!;
                            });

                            Navigator.pop(
                                context, setSelectedProfilePicture(val!));
                          }
                        }),
                  ),
                  PopupMenuItem(
                    child: RadioListTile(
                        visualDensity: VisualDensity(vertical: VisualDensity.minimumDensity,horizontal: VisualDensity.minimumDensity),
                        value: 1,
                        activeColor: App_IconColor,
                        groupValue:
                        Constants_Usermast.use_show_profilepicture,
                        title: const Text("My Contacts"),
                        onChanged: (int? val) {
                          {
                            setState(() {
                              Constants_Usermast.use_show_profilepicture =
                              val!;
                            });
                            Navigator.pop(
                                context, setSelectedProfilePicture(val!));
                          }
                        }),
                  ),
                  PopupMenuItem(
                    child: RadioListTile(
                        visualDensity: VisualDensity(vertical: VisualDensity.minimumDensity,horizontal: VisualDensity.minimumDensity),
                        value: 2,
                        activeColor: App_IconColor,
                        groupValue:
                        Constants_Usermast.use_show_profilepicture,
                        title: const Text("Nobody"),
                        onChanged: (int? val) {
                          {
                            setState(() {
                              Constants_Usermast.use_show_profilepicture =
                              val!;
                            });
                            Navigator.pop(
                                context, setSelectedProfilePicture(val!));
                          }
                        }),
                  ),
                ])),
          ),
          Constants.SettingBuildDivider(),
          ListTile(
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              title: const Text('Last Seen & Online',style: TextStyle(fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold),),
              onTap: () => showMenu(context: context, position: RelativeRect.fromLTRB(200, 180, 30, 400), items: [
                PopupMenuItem(child: Text('Last Seen & Online',style: TextStyle(fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold,color: Con_msg_auto_6),)),
                PopupMenuItem(
                  child: RadioListTile(
                      visualDensity: VisualDensity(vertical: VisualDensity.minimumDensity,horizontal: VisualDensity.minimumDensity),
                      value: 0,
                      activeColor: App_IconColor,
                      groupValue: Constants_Usermast.user_show_last_seen,
                      title: const Text("Everyone"),
                      onChanged: (int? val) {
                        {
                          setState(() {
                            Constants_Usermast.user_show_last_seen = val!;
                          });
                          Navigator.pop(
                              context, setSelectedLastSeenOnline(val!));
                        }
                      }),
                ),
                PopupMenuItem(
                  child: RadioListTile(
                      visualDensity: VisualDensity(vertical: VisualDensity.minimumDensity,horizontal: VisualDensity.minimumDensity),
                      value: 1,
                      activeColor: App_IconColor,
                      groupValue: Constants_Usermast.user_show_last_seen,
                      title: const Text("My Contacts"),
                      onChanged: (int? val) {
                        {
                          setState(() {
                            Constants_Usermast.user_show_last_seen = val!;
                          });
                          Navigator.pop(
                              context, setSelectedLastSeenOnline(val!));
                        }
                      }),
                ),
                PopupMenuItem(
                  child: RadioListTile(
                      visualDensity: VisualDensity(vertical: VisualDensity.minimumDensity,horizontal: VisualDensity.minimumDensity),
                      value: 2,
                      activeColor: App_IconColor,
                      groupValue: Constants_Usermast.user_show_last_seen,
                      title: const Text("Nobody"),
                      onChanged: (int? val) {
                        {
                          setState(() {
                            Constants_Usermast.user_show_last_seen = val!;
                          });
                          Navigator.pop(
                              context, setSelectedLastSeenOnline(val!));
                        }
                      }),
                ),
              ])),
          Constants.SettingBuildDivider(),
          ListTile(
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              title: const Text('Birthdate',style: TextStyle(fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold),),
              onTap: () => showMenu(context: context, position: RelativeRect.fromLTRB(100, 240, 30, 400), items: [
                PopupMenuItem(child: Text("Birthdate",style: TextStyle(color: Con_msg_auto_6,fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold),)),
                PopupMenuItem(
                  child: RadioListTile(
                      visualDensity: VisualDensity(vertical: VisualDensity.minimumDensity,horizontal: VisualDensity.minimumDensity),
                      value: 0,
                      activeColor: App_IconColor,
                      groupValue: Constants_Usermast.user_show_mybirthday,
                      title: const Text("Everyone"),
                      onChanged: (int? val) {
                        setState(() {
                          Constants_Usermast.user_show_mybirthday = val!;
                        });
                        Navigator.pop(
                            context, setSelectedMyBirthday(val!));
                      }),
                ),
                PopupMenuItem(
                  child: RadioListTile(
                      visualDensity: VisualDensity(vertical: VisualDensity.minimumDensity,horizontal: VisualDensity.minimumDensity),
                      value: 1,
                      activeColor: App_IconColor,
                      groupValue: Constants_Usermast.user_show_mybirthday,
                      title: const Text("My Contacts"),
                      onChanged: (int? val) {
                        setState(() {
                          Constants_Usermast.user_show_mybirthday = val!;
                        });
                        Navigator.pop(
                            context, setSelectedMyBirthday(val!));
                      }),
                ),
                PopupMenuItem(
                  child: RadioListTile(
                      visualDensity: VisualDensity(vertical: VisualDensity.minimumDensity,horizontal: VisualDensity.minimumDensity),
                      value: 2,
                      activeColor: App_IconColor,
                      groupValue: Constants_Usermast.user_show_mybirthday,
                      title: const Text("Nobody"),
                      onChanged: (int? val) {
                        setState(() {
                          Constants_Usermast.user_show_mybirthday = val!;
                        });
                        Navigator.pop(
                            context, setSelectedMyBirthday(val!));
                      }),
                ),
              ])),

          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 15.0,
            ),
            child: Text("Privacy",
                style: TextStyle(
                  color: App_IconColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                title: const Text('Active Sessions',style: TextStyle(fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold),),
                onTap: () {

                  Navigator.push(
                      context,
                      RouteTransitions.slideTransition( sub_actsession_settings(
                                isweb: false,
                              )));
                }),
          ),
          Constants.SettingBuildDivider(),
          ListTile(
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              title: const Text('Block Contacts',style: TextStyle(fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold),),
              onTap: () {
                Navigator.push(
                    context,
                    RouteTransitions.slideTransition( Con_Global_Contacts(
                              "Block",
                              Selected: (List<Need_Contact> value) {},
                            )));
              }),
          Constants.SettingBuildDivider(),
        ],
      ),
    );
  }

  Widget Cupertino_myListView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: ListView(
        children: <Widget>[
          const Material(
            color: Con_transparent,
            child: Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text('Who can see my personal info',
                  style: TextStyle(
                    color: App_IconColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CupertinoListTile(
                title: const Text('Profile Picture'),
                onTap: () => showCupertinoModalPopup(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState1) {
                            return CupertinoActionSheet(
                              title: const Text("Show Profile Picture"),
                              actions: [
                                CupertinoListTile(
                                    onTap: () {
                                      setState(() {
                                        setState1(() {
                                          Constants_Usermast
                                              .use_show_profilepicture = 0;
                                        });
                                      });
                                    },
                                    leading: Constants_Usermast
                                                .use_show_profilepicture ==
                                            0
                                        ? const Icon(
                                            CupertinoIcons.checkmark_alt)
                                        : const Icon(CupertinoIcons.circle_fill,
                                            color: Con_transparent),
                                    title: const Text("Everyone")),
                                CupertinoListTile(
                                    onTap: () {
                                      setState(() {
                                        setState1(() {
                                          Constants_Usermast
                                              .use_show_profilepicture = 1;
                                        });
                                      });
                                    },
                                    leading: Constants_Usermast
                                                .use_show_profilepicture ==
                                            1
                                        ? const Icon(
                                            CupertinoIcons.checkmark_alt)
                                        : const Icon(CupertinoIcons.circle_fill,
                                            color: Con_transparent),
                                    title: const Text("My Contact")),
                                CupertinoListTile(
                                    onTap: () {
                                      setState(() {
                                        setState1(() {
                                          Constants_Usermast
                                              .use_show_profilepicture = 2;
                                        });
                                      });
                                    },
                                    leading: Constants_Usermast
                                                .use_show_profilepicture ==
                                            2
                                        ? const Icon(
                                            CupertinoIcons.checkmark_alt)
                                        : const Icon(CupertinoIcons.circle_fill,
                                            color: Con_transparent),
                                    title: const Text("Nobady")),
                              ],
                            );
                          },
                        );
                      },
                    )),
          ),
          Constants.SettingBuildDivider(),
          CupertinoListTile(
              title: const Text('Last Seen & Online'),
              onTap: () => showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState1) {
                          return CupertinoActionSheet(
                            title: const Text("Show Last Seen & Online"),
                            actions: [
                              CupertinoListTile(
                                  onTap: () {
                                    setState(() {
                                      setState1(() {
                                        Constants_Usermast.user_show_last_seen =
                                            0;
                                      });
                                    });
                                  },
                                  leading: Constants_Usermast
                                              .user_show_last_seen ==
                                          0
                                      ? const Icon(CupertinoIcons.checkmark_alt)
                                      : const Icon(CupertinoIcons.circle_fill,
                                          color: Con_transparent),
                                  title: const Text("Everyone")),
                              CupertinoListTile(
                                  onTap: () {
                                    setState(() {
                                      setState1(() {
                                        Constants_Usermast.user_show_last_seen =
                                            1;
                                      });
                                    });
                                  },
                                  leading: Constants_Usermast
                                              .user_show_last_seen ==
                                          1
                                      ? const Icon(CupertinoIcons.checkmark_alt)
                                      : const Icon(CupertinoIcons.circle_fill,
                                          color: Con_transparent),
                                  title: const Text("My Contact")),
                              CupertinoListTile(
                                  onTap: () {
                                    setState(() {
                                      setState1(() {
                                        Constants_Usermast.user_show_last_seen =
                                            2;
                                      });
                                    });
                                  },
                                  leading: Constants_Usermast
                                              .user_show_last_seen ==
                                          2
                                      ? const Icon(CupertinoIcons.checkmark_alt)
                                      : const Icon(CupertinoIcons.circle_fill,
                                          color: Con_transparent),
                                  title: const Text("Nobady")),
                            ],
                          );
                        },
                      );
                    },
                  )),
          Constants.SettingBuildDivider(),
          CupertinoListTile(
              title: const Text('Birthdate'),
              onTap: () => showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState1) {
                          return CupertinoActionSheet(
                            title: const Text("Show Birthdate"),
                            actions: [
                              CupertinoListTile(
                                  onTap: () {
                                    setState(() {
                                      setState1(() {
                                        Constants_Usermast
                                            .user_show_mybirthday = 0;
                                      });
                                    });
                                  },
                                  leading: Constants_Usermast
                                              .user_show_mybirthday ==
                                          0
                                      ? const Icon(CupertinoIcons.checkmark_alt)
                                      : const Icon(CupertinoIcons.circle_fill,
                                          color: Con_transparent),
                                  title: const Text("Everyone")),
                              CupertinoListTile(
                                  onTap: () {
                                    setState(() {
                                      setState1(() {
                                        Constants_Usermast
                                            .user_show_mybirthday = 1;
                                      });
                                    });
                                  },
                                  leading: Constants_Usermast
                                              .user_show_mybirthday ==
                                          1
                                      ? const Icon(CupertinoIcons.checkmark_alt)
                                      : const Icon(CupertinoIcons.circle_fill,
                                          color: Con_transparent),
                                  title: const Text("My Contact")),
                              CupertinoListTile(
                                  onTap: () {
                                    setState(() {
                                      setState1(() {
                                        Constants_Usermast
                                            .user_show_mybirthday = 2;
                                      });
                                    });
                                  },
                                  leading: Constants_Usermast
                                              .user_show_mybirthday ==
                                          2
                                      ? const Icon(CupertinoIcons.checkmark_alt)
                                      : const Icon(CupertinoIcons.circle_fill,
                                          color: Con_transparent),
                                  title: const Text("Nobady")),
                            ],
                          );
                        },
                      );
                    },
                  )),
          Constants.SettingBuildDivider(),
          const SizedBox(
            height: 10,
          ),
          const Material(
            color: Con_transparent,
            child: Padding(
              padding: EdgeInsets.only(
                left: 15.0,
              ),
              child: Text("Privacy",
                  style: TextStyle(
                    color: App_IconColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CupertinoListTile(
                title: const Text('Active Sessions'),
                onTap: () {
                  Navigator.push(
                      context,
                      RouteTransitions.slideTransition( sub_actsession_settings(
                                isweb: false,
                              )));
                }),
          ),
          Constants.SettingBuildDivider(),
          CupertinoListTile(
              title: const Text('Block Contacts'),
              onTap: () {
                Navigator.push(
                    context,
                    RouteTransitions.slideTransition( Con_Global_Contacts(
                              "Block",
                              Selected: (List<Need_Contact> value) {},
                            )));
              }),
          Constants.SettingBuildDivider(),
        ],
      ),
    );
  }

  setSelectedProfilePicture(int value) {
    setState(() {
      sql_usermast_tran.mSetUserUpdateBln(
          'user_show_profilepicture', (value.toString()));
      Constants_Usermast.use_show_profilepicture = value;
    });
  }

  setSelectedLastSeenOnline(int value) {
    setState(() {
      sql_usermast_tran.mSetUserUpdateBln(
          'user_show_last_seen', (value.toString()));
      Constants_Usermast.user_show_last_seen = value;
    });
  }

  setSelectedMyPhoneNumber(int value) {
    setState(() {
      sql_usermast_tran.mSetUserUpdateBln(
          'user_show_phonenumber', (value.toString()));
    });
  }

  setSelectedMyBirthday(int value) {
    setState(() {
      sql_usermast_tran.mSetUserUpdateBln(
          'user_show_mybirthday', (value.toString()));
      Constants_Usermast.user_show_mybirthday = value;
    });
  }
}
