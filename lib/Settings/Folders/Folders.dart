import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nextapp/Constant/Con_Icons.dart';
import 'package:nextapp/Constant/Con_Wid.dart';
import 'package:nextapp/Constant/Constants.dart';
import 'package:nextapp/Settings/Folders/Folder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constant/Con_Clr.dart';
import '../../OSFind.dart';

class Folders extends StatefulWidget {
  const Folders({Key? key}) : super(key: key);

  @override
  FoldersState createState() => FoldersState();
}

class FoldersState extends State<Folders> {
  String? audio, video, images, document;
  bool restart = false;
  String? a, b, c, d;

  readimagesdir() async {
    String? img = await FilePicker.platform.getDirectoryPath();
    setState(() {
      images = img.toString();
      restart = true;
    });
    SharedPreferences diref = await SharedPreferences.getInstance();
    diref.setString("images", images.toString());
    if (images.toString() == "null") {
      restart = false;
      images = Folder.img;
    }
  }

  readvideodir() async {
    String? vid = await FilePicker.platform.getDirectoryPath();
    setState(() {
      video = vid.toString();
      restart = true;
    });
    SharedPreferences diref = await SharedPreferences.getInstance();
    diref.setString("video", video.toString());
    if (video.toString() == "null") {
      restart = false;
      video = Folder.vid;
    }
  }

  readaudiodir() async {
    String? aud = await FilePicker.platform.getDirectoryPath();
    setState(() {
      audio = aud.toString();
      restart = true;
    });
    SharedPreferences diref = await SharedPreferences.getInstance();
    diref.setString("audio", audio.toString());
    if (audio.toString() == "null") {
      restart = false;
      audio = Folder.aud;
    }
  }

  readdocumentdir() async {
    String? doc = await FilePicker.platform.getDirectoryPath();
    setState(() {
      document = doc.toString();
      restart = true;
    });
    SharedPreferences diref = await SharedPreferences.getInstance();
    diref.setString("document", document.toString());
    if (document.toString() == "null") {
      restart = false;
      document = Folder.doc;
    }
  }

  getstr() async {
    await Folder.createdir();
    SharedPreferences diref = await SharedPreferences.getInstance();
    images = diref.getString("images");
    video = diref.getString("video");
    audio = diref.getString("audio");
    document = diref.getString("document");
    setState(() {
      if (images.toString() == "null") {
        images = Folder.img;
      }
      if (video.toString() == "null") {
        video = Folder.vid;
      }
      if (audio.toString() == "null") {
        audio = Folder.aud;
      }
      if (document.toString() == "null") {
        document = Folder.doc;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getstr();
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
              title: Con_Wid.mAppBar("Folders"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListTile(
                      title: const Text(
                        "Nxt Images",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(images.toString(),style: TextStyle(color: Con_grey,fontSize: 12)),
                      trailing: const Icon(Icons.folder_open),
                      onTap: () {
                        readimagesdir();
                      }),
                  Constants.SettingBuildDivider(),
                  ListTile(
                      title: const Text(
                        "Nxt Video",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(video.toString(),style: TextStyle(color: Con_grey,fontSize: 12)),
                      trailing: const Icon(Icons.folder_open),
                      onTap: () {
                        readvideodir();
                      }),
                  Constants.SettingBuildDivider(),
                  ListTile(
                    title: const Text(
                      "Nxt Audio",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(audio.toString(),style: TextStyle(color: Con_grey,fontSize: 12)),
                    trailing: const Icon(Icons.folder_open),
                    onTap: () {
                      readaudiodir();
                    },
                  ),
                  Constants.SettingBuildDivider(),
                  ListTile(
                      title: const Text(
                        "Nxt Documents",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(document.toString(),style: TextStyle(color: Con_grey,fontSize: 12)),
                      trailing: const Icon(Icons.folder_open),
                      onTap: () {
                        readdocumentdir();
                      }),
                  Constants.SettingBuildDivider(),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Text(
                      "Note: After apply changes, your future content will be stored in new directory and your old directory are still remain so that you can move your old content to new directory.",
                      style:
                          TextStyle(fontSize: 10,fontFamily: "Inter"),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Expanded(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(200, 45),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(200.0))),
                              onPressed: restart == true
                                  ? () {
                                      Navigator.pop(context);
                                      Folder.createdir();
                                      Fluttertoast.showToast(
                                          msg: "Changes applied successfully.");
                                      setState(() {
                                        restart = false;
                                      });
                                    }
                                  : null,
                              child: const Text("Apply Changes")),
                        )),
                  )
                ],
              ),
            ))
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
                  "Folders",
                  style: TextStyle(color: Con_white),
                )),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  CupertinoListTile(
                      title: const Text(
                        "Nxt Images",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(images.toString()),
                      trailing: const Icon(CupertinoIcons.folder_open),
                      onTap: () {
                        readimagesdir();
                      }),
                  Constants.SettingBuildDivider(),
                  CupertinoListTile(
                      title: const Text(
                        "Nxt Video",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(video.toString()),
                      trailing: const Icon(CupertinoIcons.folder_open),
                      onTap: () {
                        readvideodir();
                      }),
                  Constants.SettingBuildDivider(),
                  CupertinoListTile(
                    title: const Text(
                      "Nxt Audio",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(audio.toString()),
                    trailing: const Icon(CupertinoIcons.folder_open),
                    onTap: () {
                      readaudiodir();
                    },
                  ),
                  Constants.SettingBuildDivider(),
                  CupertinoListTile(
                      title: const Text(
                        "Nxt Documents",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(document.toString()),
                      trailing: const Icon(CupertinoIcons.folder_open),
                      onTap: () {
                        readdocumentdir();
                      }),
                  Constants.SettingBuildDivider(),
                  const Material(
                    color: Con_transparent,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text(
                        "Note: After apply changes, your future content will be stored in new directory and your old directory are still remain so that you can move your old content to new directory.",
                        style:
                            TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(200, 45),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(200.0))),
                              onPressed: restart == true
                                  ? () {
                                      Navigator.pop(context);
                                      Folder.createdir();
                                      Fluttertoast.showToast(
                                          msg: "Changes applied successfully.");
                                      setState(() {
                                        restart = false;
                                      });
                                    }
                                  : null,
                              child: const Text("Apply Changes")),
                        )),
                  )
                ],
              ),
            ));
  }
}
