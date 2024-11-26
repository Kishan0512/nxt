import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nextapp/A_FB_Trigger/SharedPref.dart';
import 'package:nextapp/Constant/Con_Clr.dart';
import 'package:nextapp/Constant/Con_Icons.dart';
import 'package:nextapp/Constant/Constants.dart';
import 'package:nextapp/Settings/Folders/Folder.dart';
import 'package:nextapp/mdi_page/Wallpaper/solidWallpaper.dart';
import 'package:path/path.dart';

import '../../Constant/Con_Wid.dart';
import '../../OSFind.dart';

class chat_wallpaper extends StatefulWidget {
  String usermastid;
  String username;

  chat_wallpaper(this.usermastid, this.username, {super.key});

  @override
  _ChatWallPaperState createState() => _ChatWallPaperState();
}

class _ChatWallPaperState extends State<chat_wallpaper>
    with TickerProviderStateMixin {
  final picker = ImagePicker();
  bool expand1 = true;
  late AnimationController controller1;
  late Animation<double> animation1, animation1View;
  int SolidColorLength = 3;
  String wallpaper = "";
  int index = 0;

  getWallpaperFiles() async {
    var wallpaperFiles = Folder.wallpaper.listSync();
    Constants.wallpaperFiles.clear();
    Constants.wallpaperFiles.addAll(wallpaperFiles.reversed);
    setState(() {});
  }

  getWallpaper() async {
    var data = await Con_Wid.mReadGlbWallpaper(widget.usermastid);
    wallpaper = data['wallpaper'];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    animation1 = Tween(begin: 0.0, end: 180.0).animate(controller1);
    animation1View = CurvedAnimation(parent: controller1, curve: Curves.linear);
    controller1.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    getWallpaperFiles();
    getWallpaper();
    return WillPopScope(
        onWillPop: () {
          return Future.value(true);
        },
        child: Os.isIOS
            ? Scaffold(
                appBar: AppBar(
                  leading: Con_Wid.mIconButton(
                    icon: Own_ArrowBack,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  actions: const [],
                  title: Con_Wid.mAppBar('Chat Wallpaper'),
                ),
                body: Container(

                  child: ListView(shrinkWrap: false, children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16,top: 20,bottom: 15),
                      child: Text("Message",style: TextStyle(fontSize: 14,fontFamily: "Inter",color: Con_msg_auto_6,fontWeight: FontWeight.bold)),
                    ),
                    Container(
                        // margin: const EdgeInsets.only(bottom: 6, top: 8.5),
                        // decoration: BoxDecoration(boxShadow: [
                        //   BoxShadow(
                        //     color: getPlatformBrightness()
                        //         ? Dark_Divider_Shadow
                        //         : Light_Divider_Shadow,
                        //     blurStyle: BlurStyle.outer,
                        //     blurRadius: 2,
                        //   ),
                        // ]),
                        child: Container(
                          color: getPlatformBrightness()
                              ? DarkTheme_Main
                              : LightTheme_White,
                          child: Column(
                            children: [
                              ListTile(
                                visualDensity: const VisualDensity(
                                    horizontal: 0, vertical: -4),

                                title: const Text(
                                  'Add from Gallery',style: TextStyle(fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold)
                                ),
                                onTap: () async {
                                  final pickedFile = await (picker.pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 50));
                                  String pickedFileName =
                                      pickedFile?.name ?? "";
                                  String pickedFilePath =
                                      pickedFile?.path ?? "";
                                  try {
                                    String destinationPath = join(
                                        Folder.wallpaper.path, pickedFileName);
                                    var data = await File(pickedFilePath)
                                        .readAsBytes();
                                    pickedFile?.saveTo(destinationPath);

                                    for (int i = 0;
                                        i < Constants.wallpaperFiles.length;
                                        i++) {

                                      if (File(Constants.wallpaperFiles[i].path)
                                              .readAsBytesSync()
                                              .toString() ==
                                          data.toString()) {
                                        File(Constants.wallpaperFiles[i].path)
                                            .deleteSync();
                                      }
                                    }
                                  } catch (e) {
                                    print('Wallpaper Set Error ---> $e');
                                  }
                                  setState(() {});
                                },

                              ),
                            ],
                          ),
                        )),
                    if (Constants.wallpaperFiles.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 190,
                          child: ListView.builder(
                              reverse: false,
                              scrollDirection: Axis.horizontal,
                              itemCount: Constants.wallpaperFiles.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          RouteTransitions.slideTransition(SolidWallpaperView(
                                              index,
                                              widget.usermastid,
                                              true,
                                              widget.username)));
                                    },
                                    onLongPress: () async {
                                      ConfirmClearwallpaper(false, context);
                                    },
                                    child: Stack(children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10.0, bottom: 3),
                                        child: SizedBox(
                                          height: 190,
                                          child: Container(
                                            decoration: wallpaper ==
                                                    Constants
                                                        .wallpaperFiles[index]
                                                        .path
                                                ? BoxDecoration(
                                                    border: Border.all(
                                                        width: 3,
                                                        color: App_IconColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3))
                                                : null,
                                            width: 120,
                                            child: Image.file(
                                              File(Constants
                                                  .wallpaperFiles[index].path),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (wallpaper ==
                                          Constants.wallpaperFiles[index].path)
                                        const Positioned(
                                            left: 5,
                                            top: 5,
                                            child: Icon(
                                              Icons.check_circle,
                                              color: App_IconColor,
                                              size: 20,
                                            ))
                                    ]));
                              }),
                        ),
                      ),
                    Constants.SettingBuildDivider(),
                    Container(
                        // margin: const EdgeInsets.only(bottom: 6, top: 8.5),
                        // decoration: BoxDecoration(boxShadow: [
                        //   BoxShadow(
                        //     color: getPlatformBrightness()
                        //         ? Dark_Divider_Shadow
                        //         : Light_Divider_Shadow,
                        //     blurStyle: BlurStyle.outer,
                        //     blurRadius: 2,
                        //   ),
                        // ]),
                        child: Container(
                          color: getPlatformBrightness()
                              ? DarkTheme_Main
                              : LightTheme_White,
                          child: Column(
                            children: [
                              ListTile(
                                visualDensity: const VisualDensity(
                                    horizontal: 0, vertical: -4),
                                title: const Text(
                                  'Solid Colors',style: TextStyle(fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold)
                                ),
                                onTap: () async {
                                  Navigator.pushReplacement(
                                      context,
                                      RouteTransitions.slideTransition(SolidWallpaper(
                                          widget.usermastid,
                                          false,
                                          widget.username)));
                                },
                                trailing: Text("See all",style: TextStyle(fontSize: 14,fontFamily: "Inter",color: Con_msg_auto_6,fontWeight: FontWeight.bold)),

                              ),
                            ],
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 200,
                        child: ListView.builder(
                            itemCount: getPlatformBrightness()
                                ? Constants.Dark_Solid_Color.length
                                : Constants.Light_Solid_Color.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          RouteTransitions.slideTransition(SolidWallpaperView(
                                              index,
                                              widget.usermastid,
                                              false,
                                              widget.username)));
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: 120,
                                          decoration: wallpaper ==
                                                  (getPlatformBrightness()
                                                      ? Constants
                                                              .Dark_Solid_Color[
                                                          index]
                                                      : Constants
                                                              .Light_Solid_Color[
                                                          index])
                                              ? BoxDecoration(
                                                  border: Border.all(
                                                      width: 3,
                                                      color: App_IconColor),
                                                  borderRadius:
                                                      BorderRadius.circular(3))
                                              : null,
                                          child: Image.asset(
                                            (getPlatformBrightness()
                                                ? Constants
                                                    .Dark_Solid_Color[index]
                                                : Constants
                                                    .Light_Solid_Color[index]),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        if (wallpaper ==
                                            (getPlatformBrightness()
                                                ? Constants
                                                    .Dark_Solid_Color[index]
                                                : Constants
                                                    .Light_Solid_Color[index]))
                                          const Positioned(
                                              left: 5,
                                              top: 5,
                                              child: Icon(
                                                Icons.check_circle,
                                                color: App_IconColor,
                                                size: 20,
                                              ))
                                      ],
                                    )),
                              );
                            }),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(bottom: 6, top: 8.5),

                        child: Container(
                          color: getPlatformBrightness()
                              ? DarkTheme_Main
                              : LightTheme_White,
                          child: Column(
                            children: [
                              ListTile(
                                visualDensity: const VisualDensity(
                                    horizontal: 0, vertical: -4),

                                title: widget.usermastid.isEmpty
                                    ? const Text(
                                        'Remove Default Wallpaper',style: TextStyle(fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold)
                                      )
                                    : Text(
                                        "Remove ${widget.username}'s Wallpaper",style: TextStyle(fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold)
                                      ),
                                onTap: () async {
                                  ConfirmClearwallpaper(true, context);
                                },
                              ),
                            ],
                          ),
                        )),
                  ]),
                ),
              )
            : CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                    padding: EdgeInsetsDirectional.zero,
                    leading: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(CupertinoIcons.back, color: Con_white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    backgroundColor: App_Float_Back_Color,
                    middle: const Text(
                      "Chat Wallpaper",
                      style: TextStyle(color: Con_white),
                    )),
                child: Container(
                  color:
                      getPlatformBrightness() ? Con_Clr_App_3 : Con_Clr_App_4,
                  child: ListView(shrinkWrap: false, children: [
                    Container(
                        margin: const EdgeInsets.only(bottom: 6, top: 8.5),
                        // decoration: BoxDecoration(boxShadow: [
                        // BoxShadow(
                        //   color: SchedulerBinding
                        //               .instance.window.platformBrightness ==
                        //           Brightness.dark
                        //       ? Dark_Divider_Shadow
                        //       : Light_Divider_Shadow,
                        //   blurStyle: BlurStyle.outer,
                        //   blurRadius: 2,
                        // ),
                        // ]),
                        child: Container(
                          color: getPlatformBrightness()
                              ? DarkTheme_Main
                              : LightTheme_White,
                          child: Column(
                            children: [
                              CupertinoListTile(
                                leading: Icon(
                                  CupertinoIcons.photo,
                                  color: getPlatformBrightness()
                                      ? Dark_AppGreyColor
                                      : AppGreyColor,
                                ),
                                title: const Text(
                                  'Add from Gallery',
                                ),
                                onTap: () async {
                                  final pickedFile = await (picker.pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 50));
                                  String pickedFileName =
                                      pickedFile?.name ?? "";
                                  String pickedFilePath =
                                      pickedFile?.path ?? "";
                                  String destinationPath = join(
                                      Folder.wallpaper.path, pickedFileName);
                                  var data =
                                      await File(pickedFilePath).readAsBytes();
                                  pickedFile?.saveTo(destinationPath);
                                  for (int i = 0;
                                      i < Constants.wallpaperFiles.length;
                                      i++) {
                                    if (File(Constants.wallpaperFiles[i].path)
                                            .readAsBytesSync()
                                            .toString() ==
                                        data.toString()) {
                                      File(Constants.wallpaperFiles[i].path)
                                          .deleteSync();
                                    }
                                  }
                                  setState(() {});
                                },
                                trailing:
                                    const Icon(CupertinoIcons.chevron_right),
                              ),
                            ],
                          ),
                        )),
                    if (Constants.wallpaperFiles.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 190,
                          child: ListView.builder(
                              reverse: false,
                              scrollDirection: Axis.horizontal,
                              itemCount: Constants.wallpaperFiles.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          RouteTransitions.slideTransition(SolidWallpaperView(
                                              index,
                                              widget.usermastid,
                                              true,
                                              widget.username)));
                                    },
                                    onLongPress: () async {
                                      ConfirmClearwallpaper(false, context);
                                    },
                                    child: Stack(children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10.0, bottom: 3),
                                        child: SizedBox(
                                          height: 190,
                                          child: Container(
                                            decoration: wallpaper ==
                                                    Constants
                                                        .wallpaperFiles[index]
                                                        .path
                                                ? BoxDecoration(
                                                    border: Border.all(
                                                        width: 3,
                                                        color: App_IconColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3))
                                                : null,
                                            width: 120,
                                            child: Image.file(
                                              File(Constants
                                                  .wallpaperFiles[index].path),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (wallpaper ==
                                          Constants.wallpaperFiles[index].path)
                                        const Positioned(
                                            left: 5,
                                            top: 5,
                                            child: Icon(
                                              Icons.check_circle,
                                              color: App_IconColor,
                                              size: 20,
                                            ))
                                    ]));
                              }),
                        ),
                      ),
                    Container(
                        //margin: const EdgeInsets.only(bottom: 6, top: 8.5),
                        // decoration: BoxDecoration(boxShadow: [
                        //   BoxShadow(
                        //     color: SchedulerBinding
                        //                 .instance.window.platformBrightness ==
                        //             Brightness.dark
                        //         ? Dark_Divider_Shadow
                        //         : Light_Divider_Shadow,
                        //     blurStyle: BlurStyle.outer,
                        //     blurRadius: 2,
                        //   ),
                        // ]),
                        child: Container(
                      color: getPlatformBrightness()
                          ? DarkTheme_Main
                          : LightTheme_White,
                      child: Column(
                        children: [
                          CupertinoListTile(
                            leading: Icon(
                              CupertinoIcons.color_filter,
                              color: getPlatformBrightness()
                                  ? Dark_AppGreyColor
                                  : AppGreyColor,
                            ),
                            title: const Text(
                              'Solid Colors',
                            ),
                            onTap: () async {
                              Navigator.pushReplacement(
                                  context,
                                  RouteTransitions.slideTransition(SolidWallpaper(
                                      widget.usermastid,
                                      false,
                                      widget.username)));
                            },
                            trailing: const Icon(CupertinoIcons.chevron_right),
                          ),
                        ],
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 200,
                        child: ListView.builder(
                            itemCount: getPlatformBrightness()
                                ? Constants.Dark_Solid_Color.length
                                : Constants.Light_Solid_Color.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          RouteTransitions.slideTransition(SolidWallpaperView(
                                              index,
                                              widget.usermastid,
                                              false,
                                              widget.username)));
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: 120,
                                          decoration: wallpaper ==
                                                  (getPlatformBrightness()
                                                      ? Constants
                                                              .Dark_Solid_Color[
                                                          index]
                                                      : Constants
                                                              .Light_Solid_Color[
                                                          index])
                                              ? BoxDecoration(
                                                  border: Border.all(
                                                      width: 3,
                                                      color: App_IconColor),
                                                  borderRadius:
                                                      BorderRadius.circular(3))
                                              : null,
                                          child: Image.asset(
                                            (getPlatformBrightness()
                                                ? Constants
                                                    .Dark_Solid_Color[index]
                                                : Constants
                                                    .Light_Solid_Color[index]),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        if (wallpaper ==
                                            (getPlatformBrightness()
                                                ? Constants
                                                    .Dark_Solid_Color[index]
                                                : Constants
                                                    .Light_Solid_Color[index]))
                                          const Positioned(
                                              left: 5,
                                              top: 5,
                                              child: Icon(
                                                Icons.check_circle,
                                                color: App_IconColor,
                                                size: 20,
                                              ))
                                      ],
                                    )),
                              );
                            }),
                      ),
                    ),
                    Container(
                        // margin: const EdgeInsets.only(bottom: 6, top: 8.5),
                        // decoration: BoxDecoration(boxShadow: [
                        //   BoxShadow(
                        //     color: SchedulerBinding
                        //                 .instance.window.platformBrightness ==
                        //             Brightness.dark
                        //         ? Dark_Divider_Shadow
                        //         : Light_Divider_Shadow,
                        //     blurStyle: BlurStyle.outer,
                        //     blurRadius: 2,
                        //   ),
                        // ]),
                        child: Container(
                      color: getPlatformBrightness()
                          ? DarkTheme_Main
                          : LightTheme_White,
                      child: Column(
                        children: [
                          CupertinoListTile(
                            leading: Icon(
                              getPlatformBrightness()
                                  ? CupertinoIcons.delete_simple
                                  : CupertinoIcons.xmark,
                            ),
                            title: widget.usermastid.isEmpty
                                ? const Text(
                                    'Remove Default Wallpaper',
                                  )
                                : Text(
                                    "Remove ${widget.username}'s Wallpaper",
                                  ),
                            onTap: () async {
                              ConfirmClearwallpaper(true, context);
                            },
                          ),
                        ],
                      ),
                    )),
                  ]),
                )));
  }

  ConfirmClearwallpaper(isWallpaper, context) {
    Con_Wid.mConfirmDialog(
        context: context,
        title: isWallpaper ? "Remove Wallpaper" : "Remove Image",
        message:
            'Are you sure you want to Remove ${isWallpaper ? "Wallpaper" : "Image"} ?',
        onOkPressed: () {
          setState(() {
            if (isWallpaper) {
              if (widget.usermastid.isEmpty) {
                setState(() {
                  SharedPref.remove_key("wall_default");
                });
              } else {
                setState(() {
                  SharedPref.remove_key("wall_${widget.usermastid}");
                });
              }
            } else {
              setState(() {
                if (widget.usermastid.isEmpty) {
                  var Selectedwallpaper =
                      SharedPref.read_string("wall_default");
                  if (Selectedwallpaper ==
                      Constants.wallpaperFiles[index].path) {
                    setState(() {
                      SharedPref.remove_key("wall_default");
                    });
                  }
                  File(Constants.wallpaperFiles[index].path).deleteSync();
                } else {
                  var Selectedwallpaper =
                      SharedPref.read_string("wall_${widget.usermastid}");
                  if (Selectedwallpaper ==
                      Constants.wallpaperFiles[index].path) {
                    setState(() {
                      SharedPref.remove_key("wall_${widget.usermastid}");
                    });
                  }
                  File(Constants.wallpaperFiles[index].path).deleteSync();
                }
              });
            }
            Navigator.pop(context);
          });
        },
        onCancelPressed: () {
          Navigator.pop(context);
        });
  }

  togglePanel1() {
    if (!expand1) {
      controller1.forward();
    } else {
      controller1.reverse();
    }
    expand1 = !expand1;
  }
}
