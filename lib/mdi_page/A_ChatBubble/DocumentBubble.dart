import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../Constant/Con_Clr.dart';
import '../../Constant/Con_Usermast.dart';
import '../../Settings/Folders/Folder.dart';

class DocumentBubble extends StatefulWidget {
  String imageUrl;
  String pStrAudioName;
  String pStrMediaSize;
  String isRight;

  DocumentBubble(
      {required this.imageUrl,
      required this.pStrAudioName,
      required this.pStrMediaSize,
      required this.isRight,
      super.key});

  @override
  State<DocumentBubble> createState() => _DocumentBubbleState();
}

class _DocumentBubbleState extends State<DocumentBubble> {
  int imageNameFrom = 0, imageNameTo = 0;
  String imageName = '', imagePath = '';
  var connresult;
  bool download = false, isExists = false;
  String sentImagePath = '';
  double progress = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getimagepath();
  }

  getimagepath() async {
    try {
      if (widget.pStrAudioName == "null") {
        imageNameFrom = !widget.imageUrl.contains("image_picker")
            ? widget.imageUrl.indexOf("FCAP")
            : widget.imageUrl.indexOf("image_picker");
        imageNameTo = widget.imageUrl.indexOf("?a");
        try {
          imageName = !widget.imageUrl.contains("image_picker")
              ? widget.imageUrl
                  .substring(imageNameFrom, imageNameTo)
                  .replaceAll("FCAP", "nxt_")
              : widget.imageUrl
                  .substring(imageNameFrom, imageNameTo)
                  .replaceAll("image_picker", "nxt_");
        } catch (e) {}
      } else {
        imageName = widget.pStrAudioName;
      }
      if (widget.isRight == "1") {
        imagePath = "${Folder.sentdocument.path}/$imageName";
      } else {
        imagePath = "${Folder.Document.path}/$imageName";
      }
      ImageExistOrNot(widget.imageUrl, imagePath, false);
      if (!mounted) {
        setState(() {});
      }
    } catch (e) {}
  }

  ImageExistOrNot(String imageUrl, String imagePath, bool allowdownload) async {
    try {
      connresult = await Connectivity().checkConnectivity();
      //Left

      if (await File(imagePath).exists()) {
        sentImagePath = imagePath;
        setState(() {
          isExists = true;
        });
      } else if ((Constants_Usermast.user_chat_wifi_Document &&
              connresult == ConnectivityResult.wifi) ||
          (Constants_Usermast.user_chat_mobile_Document &&
              connresult == ConnectivityResult.mobile) ||
          allowdownload) {
        setState(() {
          download = true;
        });
        try {
          await Dio().download(imageUrl, imagePath, onReceiveProgress: (a, b) {
            setState(() {
              progress = a / b;
            });
            int percentage = ((a / b) * 100).floor();
            if (percentage > 100) {
              getimagepath();
            }
          });
        } on Exception {}
        if (await File(this.imagePath).exists()) {
          if (widget.isRight == "1") {
            if (await File(imagePath).exists()) {
              sentImagePath = File(imagePath).path;
            } else {
              sentImagePath = File("${Folder.Document.path}/$imageName").path;
            }
            if (!mounted) {
              setState(() {});
            }
          }
          setState(() {
            isExists = true;
          });
        } else {
          setState(() {
            isExists = false;
          });
        }
      } else {
        setState(() {
          download = false;
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return widget.isRight=="2"?Container(
      height: 50,
      decoration: BoxDecoration(
        // color: const Color(0xb0348296),
        color: const Color(0xfffffff),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 5),
          isExists
              ? Container(
            margin: const EdgeInsets.only(left: 5),
            width: 50,
            height: 50,

            decoration: BoxDecoration(color:Con_msg_auto_6,borderRadius: BorderRadius.circular(10)),
            child: Stack(
              children: [
                Center(child: Image.asset(height: 30,width: 30,"assets/images/Doc.webp")),
                Center(
                    child: Text(
                      (widget.pStrAudioName.split(".").last).toUpperCase(),
                      style: const TextStyle(fontSize: 9,color: Con_msg_auto_6),
                    )),
              ],
            ),
          )
              : download
              ? progress == 0.0
              ? const SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              color: Con_Main_1,
            ),
          )
              : SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              color: Con_Main_1,
              value: progress,
            ),
          )
              : InkWell(
            onTap: () {
              ImageExistOrNot(widget.imageUrl, imagePath, true);
            },
            child: const Icon(
              Icons.download,
              color: AppBar_PrimaryColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 5),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                widget.pStrAudioName.length > 16
                    ? widget.pStrAudioName.substring(0, 15) + "..."
                    : widget.pStrAudioName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Con_msg_auto_6,
                ),
              ),
              Container(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(3, 8, 3, 2),
                  child: Text(
                    "${widget.pStrMediaSize} • ${(widget.pStrAudioName.split(".").last).toUpperCase()}",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Con_msg_auto_6,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    ): Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 5),
          isExists
              ? Container(
                  margin: const EdgeInsets.only(left: 5),
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/Doc.webp"))),
                  child: Center(
                      child: Text(
                    (widget.pStrAudioName.split(".").last).toUpperCase(),
                    style: const TextStyle(fontSize: 8,),
                  )),
                )
              : download
                  ? progress == 0.0
                      ? const SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            color: Con_Main_1,
                          ),
                        )
                      : SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            color: Con_Main_1,
                            value: progress,
                          ),
                        )
                  : InkWell(
                      onTap: () {
                        ImageExistOrNot(widget.imageUrl, imagePath, true);
                      },
                      child: const Icon(
                        Icons.download,
                        color: AppBar_PrimaryColor,
                      ),
                    ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 5),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                widget.pStrAudioName.length > 16
                    ? widget.pStrAudioName.substring(0, 15) + "..."
                    : widget.pStrAudioName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Con_white,
                ),
              ),
              Container(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(3, 8, 3, 2),
                  child: Text(
                    "${widget.pStrMediaSize} • ${(widget.pStrAudioName.split(".").last).toUpperCase()}",
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      color: Con_white,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
