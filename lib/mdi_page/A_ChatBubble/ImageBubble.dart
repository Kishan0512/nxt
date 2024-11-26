import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nextapp/Settings/Folders/Folder.dart';
import 'package:video_thumbnail/video_thumbnail.dart';


import '../../Constant/Con_Clr.dart';
import '../../Constant/Con_Icons.dart';
import '../../Constant/Con_Usermast.dart';
import '../../Constant/Con_Wid.dart';
import '../../Media/Video_player.dart';

class ImageBubble extends StatefulWidget {
  String imageUrl;
  String imageName;
  String isRight;
  String? pStrFromName;
  String? pStrdate;
  bool isVideo;
  String blurhash;
  bool? selected;
  void Function()? NoButtontap;
  bool? Padding;
  bool? isSmall;
  bool? onTapChange;
  bool? isCurve;
  bool? isLocal;

  ImageBubble({
    Key? key,
    required this.imageUrl,
    required this.isVideo,
    required this.blurhash,
    required this.imageName,
    required this.isRight,
    this.selected,
    this.Padding,
    this.onTapChange,
    this.isSmall,
    this.NoButtontap,
    this.isLocal,
    this.isCurve,
    this.pStrFromName,
    this.pStrdate,
  }) : super(key: key);

  @override
  State<ImageBubble> createState() => _ImageBubbleState();
}

class _ImageBubbleState extends State<ImageBubble> {
  int imageNameFrom = 0, imageNameTo = 0;
  String imageName = '', imagePath = '';
  var connresult;
  bool download = false, isExists = false;
  double progress = 0.0;
  String sentImagePath = '';
  Uint8List? Blurimg;
  Uint8List? _thumbnailBase64;

  getimagepath() async {
    if (widget.isLocal ?? false) {
      imagePath = widget.imageUrl;
      imageName = widget.imageName;
      sentImagePath = imagePath;
      setState(() {
        isExists = true;
        widget.onTapChange = false;
      });
      if (widget.isVideo) {
        VideoThumb(Video: File(widget.imageUrl));
      }
    } else {
      try {
        if (widget.imageName == "null") {
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
          imageName = widget.imageName;
        }
        if (widget.isRight == "1") {
          imagePath = widget.isVideo
              ? "${Folder.sentVideo.path}/$imageName"
              : "${Folder.sentMedia.path}/$imageName";
        } else {
          imagePath = widget.isVideo
              ? "${Folder.video.path}/$imageName"
              : "${Folder.images.path}/$imageName";
        }
        ImageExistOrNot(widget.imageUrl, imagePath, false);
        if (!mounted) {
          setState(() {});
        }
      } catch (e) {}
    }
  }

  ImageExistOrNot(String imageUrl, String imagePath, bool allowdownload) async {
    try {
      connresult = await Connectivity().checkConnectivity();
      if (await File(imagePath).exists()) {
        sentImagePath = imagePath;
        setState(() {
          isExists = true;
        });
        if (widget.isVideo) {
          VideoThumb(
              Video: File(widget.isRight == "1"
                  ? "${Folder.sentVideo.path}/$imageName"
                  : "${Folder.video.path}/$imageName"));
        }
      } else if ((widget.isVideo
              ? ((Constants_Usermast.user_chat_wifi_video &&
                      connresult == ConnectivityResult.wifi) ||
                  (Constants_Usermast.user_chat_mobile_video &&
                      connresult == ConnectivityResult.mobile))
              : ((Constants_Usermast.user_chat_wifi_images &&
                      connresult == ConnectivityResult.wifi) ||
                  (Constants_Usermast.user_chat_mobile_images &&
                      connresult == ConnectivityResult.mobile))) ||
          allowdownload) {
        setState(() {
          download = true;
        });
        if (widget.isVideo) {
          try {
            await Dio().download(imageUrl, imagePath,
                onReceiveProgress: (a, b) {
              setState(() {
                progress = a / b;
              });
              int percentage = ((a / b) * 100).floor();
              if (percentage > 100) {
                getimagepath();
                AfterDownload();
              }
            }).then((value) async {});
          } on Exception {}
        } else {
          try {
            if (imageUrl.isNotEmpty) {
              await http.get(Uri.parse(imageUrl)).then((response) {
                if (response.statusCode == 200) {
                  File(imagePath).writeAsBytesSync(response.bodyBytes,
                      mode: FileMode.append);
                  getimagepath();
                  AfterDownload();
                } else {
                  throw ("some arbitrary error");
                }
              });
            }
          } on Exception {}
        }
      } else {
        setState(() {
          download = false;
        });
      }
    } catch (e) {}
  }

  AfterDownload() async {
    if (await File(imagePath).exists()) {
      if (widget.isRight == "1") {
        if (await File(imagePath).exists()) {
          sentImagePath = File(imagePath).path;
        } else {
          sentImagePath = File(widget.isVideo
                  ? "${Folder.video.path}/$imageName"
                  : "${Folder.images.path}/$imageName")
              .path;
        }
        if (mounted) {
          setState(() {});
        }
      }
      if (widget.isVideo) {
        VideoThumb(
            Video: File(widget.isRight == "1"
                ? "${Folder.sentVideo.path}/$imageName"
                : "${Folder.video.path}/$imageName"));
      }
      if (mounted) {
      setState(() {
        isExists = true;
      });}
    } else {
      setState(() {
        isExists = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getimagepath();
    if (widget.blurhash.isNotEmpty &&
        widget.blurhash.length > 100 &&
        widget.blurhash.toString().toLowerCase() != "null") {
      setState(() {
        Blurimg = base64Decode(widget.blurhash);
      });
    }
  }

  VideoThumb({required File Video}) async {
    Uint8List? uint8list = await VideoThumbnail.thumbnailData(
      video: Video.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 200,
      quality: 100,
      timeMs: 0,
    );
    setState(() {
      _thumbnailBase64 = uint8list;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTapChange ?? false) {
      getimagepath();
    }
    return imageName.isEmpty || widget.imageUrl == "null"
        ? const SizedBox(
            width: 250,
            child: Row(
              children: [
                Icon(
                  Icons.not_interested,
                  color: Con_black38,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "This image is not found on the server",
                  style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Con_black54),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        : Center(
            child: Container(
                height: (widget.isSmall ?? false) ? 50 : 290,
                width: (widget.isSmall ?? false) ? 50 : 290,
                decoration: BoxDecoration(
                  color: (widget.isCurve ?? false) ||
                          (widget.blurhash.isNotEmpty &&
                              widget.blurhash.length > 100 &&
                              widget.blurhash.toString().toLowerCase() !=
                                  "null")
                      ? Con_transparent
                      : Con_black,
                  image: widget.blurhash.isNotEmpty &&
                          widget.blurhash.length > 100 &&
                          widget.blurhash.toString().toLowerCase() != "null"
                      ? DecorationImage(
                          fit: BoxFit.fill,
                          image: MemoryImage(
                            Blurimg!,
                          ))
                      : null,
                ),
                margin: EdgeInsets.all((widget.Padding ?? true) ? 5 : 0),
                child: isExists
                    ? widget.isRight != "1"
                        ? widget.isVideo
                            ? InkWell(
                                onTap: (widget.isSmall ?? false)
                                    ? widget.NoButtontap
                                    : () {
                                        if (widget.selected == false) {
                                          Navigator.push(context,
                                          RouteTransitions.slideTransition( Video_player(
                                                VideoFile: File(
                                                    // "${Folder.video.path}/$imageName"
                                                    sentImagePath),
                                                pStrFromName:
                                                    widget.pStrFromName,
                                                isRight: widget.isRight,
                                                pStrDate: widget.pStrdate,
                                              )
                                          ));
                                        }
                                      },
                                child: Stack(
                                  children: [
                                    _thumbnailBase64 != null
                                        ? Container(
                                            child: widget.selected ?? false
                                                ? Own_Save
                                                : null,
                                            decoration: BoxDecoration(
                                                borderRadius: (widget.isCurve ??
                                                        false)
                                                    ? const BorderRadius.all(
                                                        Radius.circular(8))
                                                    : null,
                                                image: DecorationImage(
                                                  image: MemoryImage(
                                                    _thumbnailBase64!,
                                                  ),
                                                  colorFilter:
                                                      const ColorFilter.mode(
                                                          Con_white60,
                                                          BlendMode.darken),
                                                  fit: BoxFit.cover,
                                                )),
                                          )
                                        : Container(),
                                    (widget.isSmall ?? false)
                                        ? Container()
                                        : const Center(
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Con_black45,
                                              child: Icon(
                                                Icons.play_arrow,
                                                size: 25,
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                              )
                            : Container(
                                child:
                                    widget.selected ?? false ? Own_Save : null,
                                decoration: BoxDecoration(
                                    borderRadius: (widget.isCurve ?? false)
                                        ? const BorderRadius.all(
                                            Radius.circular(8))
                                        : null,
                                    image: DecorationImage(
                                      image: FileImage(File(sentImagePath)),
                                      colorFilter: const ColorFilter.mode(
                                          Con_white60, BlendMode.darken),
                                      fit: BoxFit.cover,
                                    )))
                        : widget.isVideo
                            ? InkWell(
                                onTap: (widget.isSmall ?? false)
                                    ? widget.NoButtontap
                                    : () {
                                        if (widget.selected == false) {
                                          Navigator.push(context,
                                          RouteTransitions.slideTransition( Video_player(
                                                VideoFile: File(
                                                    // "${Folder.sentVideo.path}/$imageName"
                                                    sentImagePath),
                                                pStrFromName:
                                                    widget.pStrFromName,
                                                isRight: widget.isRight,
                                                pStrDate: widget.pStrdate,
                                              )
                                          ));
                                        }
                                      },
                                child: Stack(
                                  children: [
                                    _thumbnailBase64 != null
                                        ? Container(
                                            child: widget.selected ?? false
                                                ? Own_Save
                                                : null,
                                            decoration: BoxDecoration(
                                                borderRadius: (widget.isCurve ??
                                                        false)
                                                    ? const BorderRadius.all(
                                                        Radius.circular(8))
                                                    : null,
                                                image: DecorationImage(
                                                  image: MemoryImage(
                                                    _thumbnailBase64!,
                                                  ),
                                                  colorFilter:
                                                      const ColorFilter.mode(
                                                          Con_white60,
                                                          BlendMode.darken),
                                                  fit: BoxFit.cover,
                                                )))
                                        : Container(),
                                    (widget.isSmall ?? false)
                                        ? Container()
                                        : const Center(
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Con_black45,
                                              child: Icon(
                                                Icons.play_arrow,
                                                size: 25,
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                              )
                            : Container(
                                child:
                                    widget.selected ?? false ? Own_Save : null,
                                decoration: BoxDecoration(
                                    borderRadius: (widget.isCurve ?? false)
                                        ? const BorderRadius.all(
                                            Radius.circular(8))
                                        : null,
                                    image: DecorationImage(
                                      image: FileImage(File(sentImagePath)),
                                      colorFilter: const ColorFilter.mode(
                                          Con_white60, BlendMode.darken),
                                      fit: BoxFit.cover,
                                    )))
                    : (Constants_Usermast.user_chat_mobile_images &&
                                connresult == ConnectivityResult.mobile) ||
                            (Constants_Usermast.user_chat_wifi_images &&
                                connresult == ConnectivityResult.wifi) ||
                            download
                        ? Center(
                            child: progress == 0.0
                                ? const CircularProgressIndicator(
                                    color: Con_white)
                                : CircularProgressIndicator(
                                    color: Con_white,
                                    value: progress,
                                  ))
                        : GestureDetector(
                            onTap: () {
                              ImageExistOrNot(widget.imageUrl, imagePath, true);
                            },
                            child: const Icon(
                              Icons.download,
                              color: Con_white,
                              size: 40,
                            ),
                          )),
          );
  }
}
