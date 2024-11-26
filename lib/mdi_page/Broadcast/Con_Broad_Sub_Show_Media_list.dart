import 'package:path_provider/path_provider.dart';import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:nextapp/Constant/Con_Clr.dart';
import 'package:nextapp/Constant/Con_Icons.dart';
import 'package:nextapp/Constant/Constants.dart';
import 'package:path/path.dart';


import '../../A_FB_Trigger/sql_need_main_sub_chat.dart';
import '../../Constant/Con_Wid.dart';

class BroadMediaList extends StatefulWidget {
  final String pStrMobileNumber;

  const BroadMediaList(this.pStrMobileNumber, {super.key});

  @override
  _BroadMediaList createState() => _BroadMediaList();
}

class _BroadMediaList extends State<BroadMediaList> {
  _BroadMediaList();

  int _currentIndex = 0;
  final primaryColor = const Color(0xff203152);
  final greyColor2 = const Color(0xffE8E8E8);
  bool isExist = false;
  int pIntListCounter = 0;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppBar_PrimaryColor,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Con_white),
          actionsIconTheme: const IconThemeData(color: Con_white),
          leading: Con_Wid.mIconButton(
              icon: Own_ArrowBack,
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Constants.mAppBar('Media List'),
        ),
        body: WidgetRedirect(_currentIndex, context),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Con_black,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: SizedBox(
                    height: 30,
                    width: 30,
                    child: Image.asset(
                      'assets/images/Gallery_Icon.webp',
                      color: getPlatformBrightness()
                          ? Dark_AppGreyColor
                          : AppGreyColor,
                    )),
                activeIcon: SizedBox(
                    height: 30,
                    width: 30,
                    child: Image.asset(
                      'assets/images/Gallery_Icon.webp',
                      color: App_Float_Back_Color,
                    )),
                label: 'Photos'),
            BottomNavigationBarItem(
                icon: SizedBox(
                    height: 30,
                    width: 30,
                    child: Image.asset('assets/images/Videos_Icon.webp',
                        color: AppGreyColor)),
                activeIcon: SizedBox(
                    height: 30,
                    width: 30,
                    child: Image.asset(
                      'assets/images/Videos_Icon.webp',
                      color: App_Float_Back_Color,
                    )),
                label: 'Videos'),
            BottomNavigationBarItem(
                icon: SizedBox(
                    height: 30,
                    width: 30,
                    child: Image.asset('assets/images/Music_Icon.webp',
                        color: AppGreyColor)),
                activeIcon: SizedBox(
                    height: 30,
                    width: 30,
                    child: Image.asset(
                      'assets/images/Music_Icon.webp',
                      color: App_Float_Back_Color,
                    )),
                label: 'Audio'),
            BottomNavigationBarItem(
                icon: SizedBox(
                    height: 30,
                    width: 30,
                    child: Image.asset('assets/images/Doc_Icon.webp',
                        color: AppGreyColor)),
                activeIcon: SizedBox(
                    height: 30,
                    width: 30,
                    child: Image.asset(
                      'assets/images/Doc_Icon.webp',
                      color: App_Float_Back_Color,
                    )),
                label: 'Documents')
          ],
        ));
  }

  static List<Need_Main_Sub_Chat> imageList = [];
  static List<Need_Main_Sub_Chat> videoList = [];
  static List<Need_Main_Sub_Chat> Document = [];
  static List<Need_Main_Sub_Chat> AudioList = [];

  WidgetRedirect(int index, BuildContext context) {
    switch (index) {
      case 0:
        return First_Photos(
          imageList,
          "0",
          false,
          const [],
          (value) {},
          (value) {},
        );
      case 1:
        return Second_Videos(
          videoList,
          false,
          const [],
          (value) {},
          (value) {},
        );
      case 2:
        return Third_Audio(
          AudioList,
          false,
          const [],
          (value) {},
          (value) {},
        );
      case 3:
        return Fourth_Documents(
          Document,
          false,
          const [],
          (value) {},
          (value) {},
        );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class Constants_Download {
  static const String mStorageName_UserSong = 'user_song';
  static const String Audio = 'Audio';
  static const String Images = 'Images';
  static const String Video = 'Video';
  static String GlobalDirectoryPath = "";

  static getMainApppath() async {
    Directory? baseDir = await getExternalStorageDirectory(); //on
    GlobalDirectoryPath = baseDir!.path.toString();
    return (baseDir.path);
  }

  static Future<String> getCreateDirectory(String pStrType) async {
    getMainApppath();
    String finalDir = join(GlobalDirectoryPath, pStrType);
    final path = Directory(finalDir);
    if ((await path.exists())) {
    } else {
      path.create();
    }
    return path.path;
  }

  static Future<bool> getAudioCheckDirectoryExist(
      String pStrFromId, String pStrFileName, String pStrFileFormat) async {
    getMainApppath();
    var oldpath = await getCreateDirectory(Audio);
    bool _blnReturn = false;
    String finalDir =
        join(GlobalDirectoryPath, '$oldpath/${pStrFileName + pStrFileFormat}');
    final file = File(finalDir);
    if (file.existsSync()) {
      _blnReturn = true;
    } else {
      _blnReturn = false;
    }
    return _blnReturn;
  }

  static getDownloadAudio(String pStrFromId, String pStrFileName,
      String pStrFileFormat, String pStrDownloadUrl) async {
    var path = await getCreateDirectory(Audio);
    final File tempFile = File('$path/${pStrFileName + pStrFileFormat}');
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await tempFile.create(recursive: true);
    final firebase_storage.Reference ref = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('$pStrFromId/$mStorageName_UserSong/$pStrFileName');
  }
}
