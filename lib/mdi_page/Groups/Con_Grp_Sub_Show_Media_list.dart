import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nextapp/Constant/Con_Clr.dart';
import 'package:nextapp/Constant/Con_Icons.dart';
import 'package:nextapp/Constant/Constants.dart';
import 'package:path/path.dart';

import '../../Constant/Con_Wid.dart';

class GroupMediaList extends StatefulWidget {
  final String pStrMobileNumber;

  const GroupMediaList(this.pStrMobileNumber, {Key? key}) : super(key: key);

  @override
  _GroupMediaList createState() => _GroupMediaList();
}

class _GroupMediaList extends State<GroupMediaList> {
  _GroupMediaList();

  int _currentIndex = 0;

  bool isExist = false;
  int pIntListCounter = 0;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppBar_PrimaryColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Con_white),
          actionsIconTheme: const IconThemeData(color: Con_white),
          backgroundColor: AppBar_PrimaryColor,
          elevation: 0.0,
          leading: Con_Wid.mIconButton(
              icon: Own_ArrowBack,
              onPressed: () {
                Navigator.pop(context);
              }),
          centerTitle: true,
          title: Constants.mAppBar('Media List'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: AppBar_PrimaryColor,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: _currentIndex != null
                  ? _currentIndex == 0
                      ? First_Photos()
                      : _currentIndex == 1
                          ? Second_Videos()
                          : _currentIndex == 2
                              ? Third_Audio()
                              : _currentIndex == 3
                                  ? Fourth_Docs()
                                  : Container()
                  : Container(),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Con_black,
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(icon: Own_Picture, label: 'Photos'),
            BottomNavigationBarItem(icon: Own_Video, label: 'Videos'),
            BottomNavigationBarItem(icon: Own_File_Audio, label: 'Audio'),
            BottomNavigationBarItem(icon: Own_File_Docs, label: 'Documents')
          ],
        ));
  }

  Widget First_Photos() {
    return Container();
  }

  Widget Second_Videos() {
    return Container();
  }

  Widget Third_Audio() {
    return Container();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
      } else if (index == 1) {
      } else if (index == 2) {}
    });
  }

  Widget Fourth_Docs() {
    return Container();
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
  }
}
