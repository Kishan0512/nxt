import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nextapp/A_Local_DB/Sync_Database.dart';
import 'package:nextapp/A_SQL_Trigger/sql_devicesession.dart';
import 'package:nextapp/Constant/Con_Clr.dart';
import 'package:nextapp/Constant/Con_Icons.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:nextapp/Constant/Con_Wid.dart';
import 'package:nextapp/Constant/Constants.dart';

import '../../A_FB_Trigger/SharedPref.dart';
import '../../A_FB_Trigger/sql_user_device_session.dart';
import '../../Constant/Qr_Scan.dart';
import '../../Login/Splash.dart';
import '../../OSFind.dart';
import '../set_sub_main_settings.dart';

class sub_actsession_settings extends StatefulWidget {
  bool isweb;

  sub_actsession_settings({super.key, required this.isweb});

  @override
  _sub_actsession_settings createState() => _sub_actsession_settings();
}

class _sub_actsession_settings extends State<sub_actsession_settings> {
  List<Need_DeviceSession> needs_thisdevice = [];
  List<Need_DeviceSession> needs_active = [];
  List<Need_DeviceSession> needs_session = [];
  bool loginIp = true, Proccess = false;
  String mStrIpAddress = "";
  var data;

  @override
  void initState() {
    super.initState();
    sql_devicesession_tran.setDeviceSession();
    if (Constants_List.session_active.isEmpty) {
      setupneeds();
    } else {
      needs_active = Constants_List.session_active;
      needs_thisdevice = needs_active
          .where((element) =>
              element.is_active == 1 && element.ipaddress == mStrIpAddress)
          .toList();
    }
    setupneeds();
    loadIpAddress();
    setState(() {});
  }

  loadIpAddress() async {
    mStrIpAddress = await sql_devicesession_tran.GetIPAddress();
    setState(() {});
  }

  Future<List<Need_DeviceSession>> setupneeds() async {
    List<Need_DeviceSession> needs =
        await sql_devicesession_tran.getActiveSessionDetails();
    setState(() {
      needs_thisdevice = needs
          .where((element) =>
              element.is_active == 1 && element.ipaddress == mStrIpAddress)
          .toList();
      needs_active = needs
          .where((element) =>
              element.is_active == 1 && element.ipaddress != mStrIpAddress)
          .toList();
      needs_session = needs.where((element) => element.is_active == 0).toList();
    });
    return needs;
  }

  Widget leadingdata(List<Need_DeviceSession> needsActive, int index) {
    return needsActive[index].isAndroid
        ? CircleAvatar(
            backgroundImage: AssetImage(Constants_Usermast.isAndoirdPic),
          )
        : needsActive[index].isIOS
            ? CircleAvatar(
                backgroundImage: AssetImage(Constants_Usermast.isIOSPic))
            : needsActive[index].isMacOS
                ? CircleAvatar(
                    backgroundImage: AssetImage(Constants_Usermast.isMacOSPic))
                : needsActive[index].isWindows
                    ? CircleAvatar(
                        backgroundImage:
                            AssetImage(Constants_Usermast.isWindowsPic))
                    : const CircleAvatar(
                        backgroundColor: App_Float_Back_Color,
                        radius: 20,
                        child: Icon(
                          Icons.android,
                        ));
  }

  @override
  Widget build(BuildContext context) {
    return Os.isIOS
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: Con_Wid.mIconButton(
                icon: Own_ArrowBack,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Con_Wid.mAppBar("Active Sessions"),
            ),
            body: Stack(alignment: Alignment.center,
              children: [
                IgnorePointer(
                  ignoring: Proccess,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widget.isweb
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width /
                                                6,
                                        vertical:
                                            MediaQuery.of(context).size.height /
                                                26),
                                    // padding: EdgeInsets.all(
                                    //     MediaQuery.of(context).size.width / 8),
                                    child: Image.asset(
                                        'assets/images/WebBack.webp'),
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(200, 44),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      200.0))),
                                      onPressed: () async {
                                        Navigator.push(
                                            context,
                                            RouteTransitions.slideTransition(
                                                  const QRViewExample(),
                                            ));
                                      },
                                      child: const Text("Link a Device"))
                                ],
                              )
                            : Container(),
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 15.0, top: 20, bottom: 8.0),
                          child: Text(
                            "This Device",
                            style: TextStyle(
                              color: App_IconColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FutureBuilder(
                              future: setupneeds(),
                              builder: (context, snapshot) {
                                return ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    // new
                                    shrinkWrap: true,
                                    itemCount: needs_thisdevice.isNotEmpty
                                        ? needs_thisdevice.length
                                        : 0,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        onTap: () async {
                                          ConfirmClearIdWise(
                                              needs_thisdevice[index]
                                                  .id
                                                  .toString(),
                                              "THISDEVICE",
                                              index);
                                        },
                                        leading: leadingdata(
                                            needs_thisdevice, index),
                                        title: Text(
                                          "${needs_thisdevice[index].mobile_name} • ${needs_thisdevice[index].ipaddress}",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        subtitle: Text(
                                            "Nxt " +
                                                needs_thisdevice[index]
                                                    .mobile_version +
                                                "\n" +
                                                needs_thisdevice[index]
                                                    .device_location +
                                                "" +
                                                needs_thisdevice[index]
                                                    .login_date_time_show,
                                            style:
                                                const TextStyle(fontSize: 14)),
                                      );
                                    });
                              }),
                        ),
                        Constants.SettingBuildDivider(),
                        ListTile(
                          leading: Con_Wid.mIconButton(
                              onPressed: () {}, icon: Own_Logout),
                          title: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                ConfirmClear();
                              },
                              child: const Text(
                                "Tap to Logout All Other Sessions",
                                style: TextStyle(
                                    fontSize: 15, color: AppLogOutRed),
                              ),
                            ),
                          ),
                        ),
                        needs_active.isNotEmpty
                            ? const Padding(
                                padding: EdgeInsets.only(
                                    left: 15.0, top: 20, bottom: 8.0),
                                child: Text(
                                  "Active Sessions",
                                  style: TextStyle(
                                    color: App_IconColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                              )
                            : Container(),
                        needs_active.isNotEmpty
                            ? const SizedBox(
                                height: 10,
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: FutureBuilder(
                              future: setupneeds(),
                              builder: (context, snapshot) {
                                return ListView.separated(
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) {
                                      return Constants
                                          .ActiveSessionBuildDivider();
                                    },
                                    itemCount: needs_active.isNotEmpty
                                        ? needs_active.length
                                        : 0,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                          visualDensity: const VisualDensity(
                                              horizontal: 0, vertical: -4),
                                          onTap: () async {
                                            if (mStrIpAddress ==
                                                needs_active[index].ipaddress) {
                                              ConfirmClearIdWise(
                                                  needs_active[index]
                                                      .id
                                                      .toString(),
                                                  "THISDEVICE",
                                                  index);
                                            } else {
                                              ConfirmClearIdWise(
                                                  needs_active[index]
                                                      .id
                                                      .toString(),
                                                  "",
                                                  index);
                                            }
                                          },
                                          leading:
                                              leadingdata(needs_active, index),
                                          title: Text(
                                            "${needs_active[index].mobile_name} • ${needs_active[index].ipaddress}",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "Nxt " +
                                                      needs_active[index]
                                                          .mobile_version,
                                                  style: const TextStyle(
                                                      fontSize: 14)),
                                              Text(
                                                  needs_active[index]
                                                          .device_location
                                                          .isNotEmpty
                                                      ? (needs_active[index]
                                                              .device_location +
                                                          " , " +
                                                          needs_active[index]
                                                              .login_date_time_show)
                                                      : needs_active[index]
                                                          .login_date_time_show,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: AppGreyColor)),
                                            ],
                                          ));
                                    });
                              }),
                        ),
                        needs_session.isNotEmpty
                            ? const Padding(
                                padding: EdgeInsets.only(left: 15.0, top: 15.0),
                                child: Text(
                                  "Sessions",
                                  style: TextStyle(
                                    color: App_IconColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                              )
                            : Container(),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return Constants.ActiveSessionBuildDivider();
                              },
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              // new
                              shrinkWrap: true,
                              itemCount: needs_session.isNotEmpty
                                  ? needs_session.length
                                  : 0,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  visualDensity: const VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  leading: leadingdata(needs_session, index),
                                  title: Text(
                                    "${needs_session[index].mobile_name} • ${needs_session[index].ipaddress}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Nxt " +
                                              needs_session[index]
                                                  .mobile_version,
                                          style: const TextStyle(fontSize: 14)),
                                      Text(
                                          needs_session[index]
                                                  .device_location
                                                  .isNotEmpty
                                              ? (needs_session[index]
                                                      .device_location +
                                                  " , " +
                                                  needs_session[index]
                                                      .login_date_time_show)
                                              : needs_session[index]
                                                  .login_date_time_show,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: AppGreyColor)),
                                    ],
                                  ),
                                  isThreeLine: true,
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                Proccess ? CircularProgressIndicator() : Container(),
              ],
            ),
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
                middle: const Text(
                  "Active Sessions",
                  style: TextStyle(color: Con_white),
                )),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Material(
                    color: Con_transparent,
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 15.0, top: 20, bottom: 8.0),
                      child: Text(
                        "This Device",
                        style: TextStyle(
                          color: App_IconColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder(
                        future: setupneeds(),
                        builder: (context, snapshot) {
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: const AlwaysScrollableScrollPhysics(),
                              // new
                              shrinkWrap: true,
                              itemCount: needs_thisdevice.isNotEmpty
                                  ? needs_thisdevice.length
                                  : 0,
                              itemBuilder: (BuildContext context, int index) {
                                return CupertinoListTile(
                                  onTap: () async {
                                    Cupertino_ConfirmClearIdWise(
                                        needs_thisdevice[index].id.toString(),
                                        "THISDEVICE",
                                        index);
                                  },
                                  leading: leadingdata(needs_thisdevice, index),
                                  title: Text(
                                    "${needs_thisdevice[index].mobile_name} • ${needs_thisdevice[index].ipaddress}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  subtitle: Text(
                                      "Nxt " +
                                          needs_thisdevice[index]
                                              .mobile_version +
                                          "\n" +
                                          needs_thisdevice[index]
                                              .device_location +
                                          "" +
                                          needs_thisdevice[index]
                                              .login_date_time_show,
                                      style: const TextStyle(fontSize: 14)),
                                );
                              });
                        }),
                  ),
                  Constants.SettingBuildDivider(),
                  CupertinoListTile(
                    leading: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      child: Own_Logout,
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          Cupertino_ConfirmClear();
                        },
                        child: const Text(
                          "Tap to Logout All Other Sessions",
                          style: TextStyle(fontSize: 15, color: AppLogOutRed),
                        ),
                      ),
                    ),
                  ),
                  needs_active.isNotEmpty
                      ? const Material(
                          color: Con_transparent,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 15.0, top: 20, bottom: 8.0),
                            child: Text(
                              "Active Sessions",
                              style: TextStyle(
                                color: App_IconColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  needs_active.isNotEmpty
                      ? const SizedBox(
                          height: 10,
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: FutureBuilder(
                        future: setupneeds(),
                        builder: (context, snapshot) {
                          return ListView.separated(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              separatorBuilder: (context, index) {
                                return Constants.ActiveSessionBuildDivider();
                              },
                              itemCount: needs_active.isNotEmpty
                                  ? needs_active.length
                                  : 0,
                              itemBuilder: (BuildContext context, int index) {
                                return CupertinoListTile(
                                    onTap: () async {
                                      if (mStrIpAddress ==
                                          needs_active[index].ipaddress) {
                                        Cupertino_ConfirmClearIdWise(
                                            needs_active[index].id.toString(),
                                            "THISDEVICE",
                                            index);
                                      } else {
                                        Cupertino_ConfirmClearIdWise(
                                            needs_active[index].id.toString(),
                                            "",
                                            index);
                                      }
                                    },
                                    leading: leadingdata(needs_active, index),
                                    title: Text(
                                      "${needs_active[index].mobile_name} • ${needs_active[index].ipaddress}",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "Nxt " +
                                                needs_active[index]
                                                    .mobile_version,
                                            style:
                                                const TextStyle(fontSize: 14)),
                                        Text(
                                            needs_active[index]
                                                    .device_location
                                                    .isNotEmpty
                                                ? (needs_active[index]
                                                        .device_location +
                                                    " , " +
                                                    needs_active[index]
                                                        .login_date_time_show)
                                                : needs_active[index]
                                                    .login_date_time_show,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: AppGreyColor)),
                                      ],
                                    ));
                              });
                        }),
                  ),
                  needs_session.isNotEmpty
                      ? const Material(
                          color: Con_transparent,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15.0, top: 15.0),
                            child: Text(
                              "Sessions",
                              style: TextStyle(
                                color: App_IconColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return Constants.ActiveSessionBuildDivider();
                        },
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        // new
                        shrinkWrap: true,
                        itemCount:
                            needs_session.isNotEmpty ? needs_session.length : 0,
                        itemBuilder: (BuildContext context, int index) {
                          return CupertinoListTile(
                            leading: leadingdata(needs_session, index),
                            title: Text(
                              "${needs_session[index].mobile_name} • ${needs_session[index].ipaddress}",
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Nxt " +
                                        needs_session[index].mobile_version,
                                    style: const TextStyle(fontSize: 14)),
                                Text(
                                    needs_session[index]
                                            .device_location
                                            .isNotEmpty
                                        ? (needs_session[index]
                                                .device_location +
                                            " , " +
                                            needs_session[index]
                                                .login_date_time_show)
                                        : needs_session[index]
                                            .login_date_time_show,
                                    style: const TextStyle(
                                        fontSize: 14, color: AppGreyColor)),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ));
  }

  Future<void> ConfirmClear() async {
    Con_Wid.mConfirmDialog(
        context: context,
        title: "Logout All Sessions",
        message: 'Are you sure you want to logout all others sessions ?',
        onOkPressed: () async {
          setState(()  {
            Proccess = true;
          });
            if(await sql_devicesession_tran.setLogoutAllSession()) {
              Proccess = false;
              setState(() {});
            }
          setState(() {});
          Navigator.pop(context);
        },
        onCancelPressed: () {
          Navigator.pop(context);
        });
  }

  Future<void> Cupertino_ConfirmClear() async {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text(
            "Logout All Sessions",
          ),
          content: const Text(
              'Are you sure you want to logout all others sessions ?'),
          actions: [
            CupertinoButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoButton(
                child: const Text("Ok"),
                onPressed: () {
                  setState(() {
                    sql_devicesession_tran.setLogoutAllSession();
                  });
                  Navigator.pop(context);
                })
          ],
        );
      },
    );
  }

  Future<void> ConfirmClearIdWise(
      String pStrId, String pStrDevice, int index) async {
    Con_Wid.mConfirmDialog(
        context: context,
        title: "Logout",
        message: 'Are you sure you want to logout this sessions ?',
        onOkPressed: () async {
          if (pStrDevice == "THISDEVICE") {
            await sql_devicesession_tran.setLoginSessionDetails(false);
            SharedPref.save_bool('is_login', false);
            SharedPref.save_string('user_id', '');
            SharedPref.clear();
            deleteData().then((value) {
              Constants_List.Constants_List_Clear();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/Splash',
                    (_) => false,
              );
            });
          } else {
            sql_devicesession_tran.setLogoutIdSession(pStrId);
            SyncDB.SyncTable(Constants.Table_User_Device_Session, false);
            needs_active.removeAt(index);
            setupneeds();
          }
          Navigator.pop(context);
        },
        onCancelPressed: () {
          Navigator.pop(context);
        });
  }

  Future<void> Cupertino_ConfirmClearIdWise(
      String pStrId, String pStrDevice, int index) async {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text(
            "Logout",
          ),
          content:
              const Text('Are you sure you want to logout this sessions ?'),
          actions: [
            CupertinoButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoButton(
                child: const Text("Ok"),
                onPressed: () async {
                  if (pStrDevice == "THISDEVICE") {
                    await sql_devicesession_tran.setLoginSessionDetails(false);
                    SharedPref.save_bool('is_login', false);
                    SharedPref.save_string('user_id', '');
                    SharedPref.clear();
                    await Hive.close();
                    await Hive.deleteFromDisk();
                    await Hive.openBox('need_devicesession');
                    Constants_List.Constants_List_Clear();
                    Navigator.of(context).pushReplacement(RouteTransitions.slideTransition( const Splash()));
                  } else {
                    sql_devicesession_tran.setLogoutIdSession(pStrId);
                    SyncDB.SyncTable(
                        Constants.Table_User_Device_Session, false);
                    needs_active.removeAt(index);
                    setupneeds();
                  }
                  Navigator.pop(context);
                })
          ],
        );
      },
    );
  }
}
