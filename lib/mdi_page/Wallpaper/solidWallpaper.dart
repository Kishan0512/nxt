import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nextapp/A_FB_Trigger/SharedPref.dart';
import 'package:nextapp/Constant/Con_Icons.dart';
import 'package:nextapp/Constant/Con_Wid.dart';
import 'package:nextapp/mdi_page/A_ChatBubble/ChatBubble.dart';
import 'package:nextapp/mdi_page/Wallpaper/chat_wallpaper.dart';

import '../../Constant/Con_Clr.dart';
import '../../Constant/Constants.dart';
import '../../OSFind.dart';

class SolidWallpaper extends StatefulWidget {
  String usermastid, username;
  bool wallpaperchanged;

  SolidWallpaper(this.usermastid, this.wallpaperchanged, this.username,
      {super.key});

  @override
  State<SolidWallpaper> createState() => _SolidWallpaperState();
}

class _SolidWallpaperState extends State<SolidWallpaper> {
  @override
  Widget build(BuildContext context) {
    return Os.isIOS
        ? Scaffold(
            appBar: AppBar(
              leading: Con_Wid.mIconButton(
                icon: Own_ArrowBack,
                onPressed: () {
                  if (!widget.wallpaperchanged) {
                    Navigator.pushReplacement(context, RouteTransitions.slideTransition(chat_wallpaper(
                            widget.usermastid, widget.username)
                    ));
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              title: Con_Wid.mAppBar('Solid Colors'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.6),
                  itemCount: (getPlatformBrightness()
                      ? Constants.Dark_Solid_Color.length
                      : Constants.Light_Solid_Color.length),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              RouteTransitions.slideTransition( SolidWallpaperView(
                                      index,
                                      widget.usermastid,
                                      false,
                                      widget.username)));
                        },
                        child: Container(
                          child: Image.asset(
                              (getPlatformBrightness()
                                  ? Constants.Dark_Solid_Color[index]
                                  : Constants.Light_Solid_Color[index]),
                              fit: BoxFit.fill),
                        ));
                  }),
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
                  "Solid Colors",
                  style: TextStyle(color: Con_white),
                )),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.6),
                  itemCount: (getPlatformBrightness()
                      ? Constants.Dark_Solid_Color.length
                      : Constants.Light_Solid_Color.length),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              RouteTransitions.slideTransition( SolidWallpaperView(
                                      index,
                                      widget.usermastid,
                                      false,
                                      widget.username)));
                        },
                        child: Container(
                          child: Image.asset(
                              (getPlatformBrightness()
                                  ? Constants.Dark_Solid_Color[index]
                                  : Constants.Light_Solid_Color[index]),
                              fit: BoxFit.fill),
                        ));
                  }),
            ));
  }
}

class SolidWallpaperView extends StatefulWidget {
  late int mStrProfile;
  late String usermastid, username;
  bool isFile;

  SolidWallpaperView(
      this.mStrProfile, this.usermastid, this.isFile, this.username,
      {Key? key})
      : super(key: key);

  @override
  _SolidWallpaperViewPageState createState() => _SolidWallpaperViewPageState();
}

class _SolidWallpaperViewPageState extends State<SolidWallpaperView> {
  _SolidWallpaperViewPageState();

  late PageController pageController;
  int length = 0;
  bool wallpaperchanged = false;

  @override
  void initState() {
    super.initState();
    if (widget.isFile) {
      length = Constants.wallpaperFiles.length;
    } else {
      length = (getPlatformBrightness()
          ? Constants.Dark_Solid_Color.length
          : Constants.Light_Solid_Color.length);
    }
    pageController = PageController(initialPage: widget.mStrProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Preview", style: TextStyle(color: Con_white)),
          leading: Con_Wid.mIconButton(
            icon: Own_ArrowBack,
            onPressed: () {
              if (!wallpaperchanged) {
                Navigator.pushReplacement(context,
                    RouteTransitions.slideTransition(
                SolidWallpaper(
                        widget.usermastid, wallpaperchanged, widget.username)
                ));
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: PageView(
          controller: pageController,
          children: [
            for (int i = 0; i < length; i++)
              Container(
                  decoration: Con_Wid.mGlbWallpaperSelection(i, widget.isFile),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (int i = 0; i < Constants.WallpaperChat.length; i++)
                          ChatBubble().ShowChatBubble(
                              context,
                              Constants.WallpaperChat[i]['is_right'],
                              Constants.WallpaperChat[i]['msg_type'],
                              Constants.WallpaperChat[i]['msg_content'],
                              "",
                              "",
                              "",
                              DateFormat("MMM dd y h:mm a")
                                  .format(DateTime.now()),
                              Constants.WallpaperChat[i]['is_read'],
                              '',
                              Constants.WallpaperChat[i]['center_date'],
                              Constants.WallpaperChat[i]['id'],
                              "",
                              "",
                              "",
                              "",
                              "",
                              onSelected: (List<String> value) {}),
                        Expanded(child: Container()),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                height: 50.0,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 100),
                                width: double.infinity,
                                child: Container(
                                    margin: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1.0,
                                            color: Con_white.withOpacity(0.70)),
                                        color: Con_Main_1.withOpacity(0.70),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(30.0) //
                                            )),
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 2),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (widget.usermastid.isNotEmpty) {
                                            widget.isFile
                                                ? SharedPref.save_string(
                                                    "wall_" + widget.usermastid,
                                                    Constants
                                                        .wallpaperFiles[i].path
                                                        .toString())
                                                : SharedPref.save_string(
                                                    "wall_" + widget.usermastid,
                                                    (getPlatformBrightness()
                                                            ? Constants
                                                                    .Dark_Solid_Color[
                                                                i]
                                                            : Constants
                                                                .Light_Solid_Color[i])
                                                        .toString());
                                          } else {
                                            widget.isFile
                                                ? SharedPref.save_string(
                                                    "wall_default",
                                                    Constants
                                                        .wallpaperFiles[i].path
                                                        .toString())
                                                : SharedPref.save_string(
                                                    "wall_default",
                                                    (getPlatformBrightness()
                                                            ? Constants
                                                                    .Dark_Solid_Color[
                                                                i]
                                                            : Constants
                                                                .Light_Solid_Color[i])
                                                        .toString());
                                          }
                                          Fluttertoast.showToast(
                                            msg: "Wallpaper Set Successfully",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                          );
                                          setState(() {
                                            wallpaperchanged = true;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Center(
                                          child: Text(
                                            "Apply Wallpaper",
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Con_white),
                                          ),
                                        ),
                                      ),
                                    ))))
                      ])),
          ],
        ));
  }
}
