import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:nextapp/A_SQL_Trigger/sql_sub_messages.dart';
import 'package:nextapp/Constant/Con_Clr.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:nextapp/Settings/Folders/Folder.dart';
import 'package:path/path.dart' as Path;
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as vid;
import '../Constant/Con_Icons.dart';
import '../Constant/Con_Wid.dart';
import '../mdi_page/A_ChatBubble/ImageBubble.dart';

class CameraScreen extends StatefulWidget {
  late int count;

  late String usermastid;
  late String is_broadcast;
  String serverKey;
  String sender_name;

  CameraScreen({
    super.key,
    required this.count,
    required this.camera,
    required this.serverKey,
    required this.usermastid,
    required this.sender_name,
    required this.is_broadcast,
  });

  final CameraDescription camera;

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  late CameraDescription CamDescription;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool mBooltap = false, mBoolselfie = false, _isRecordingVideo = false;
  List<File> imagelist = [];
  bool _isRecording = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Cam_initialize(mBoolselfie);
  }

  Cam_initialize(mBoolselfie) {
    CamDescription = mBoolselfie
        ? const CameraDescription(
            name: '1',
            lensDirection: CameraLensDirection.front,
            sensorOrientation: 270)
        : widget.camera;
    _controller = CameraController(
      CamDescription,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      child: Scaffold(
        backgroundColor: Con_black,
        body: Stack(
          children: [
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Center(
                    child: SizedBox(
                        width: double.infinity,
                        child: CameraPreview(_controller)),
                  );
                } else {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Con_Main_1,
                  ));
                }
              },
            ),
            Positioned(
                top: 50.0,
                right: 1.0,
                left: 1.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Con_Wid.mIconButton(
                      onPressed: () {
                        imagelist.clear();
                        setState(() {});
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Con_white,
                      ),
                    ),
                  ],
                )),
            Positioned(
              bottom: 50.0,
              right: 1.0,
              left: 1.0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Con_Wid.mIconButton(
                        onPressed: () {
                          setState(() {
                            mBoolselfie = !mBoolselfie;
                          });
                          Cam_initialize(mBoolselfie);
                        },
                        icon: const Icon(
                          Icons.cameraswitch_rounded,
                          color: Con_white,
                          size: 30,
                        )),
                    SizedBox(
                        height: 100,
                        width: 100,
                        child: GestureDetector(
                            onLongPressStart: (details) async {
                              setState(() {
                                _isRecordingVideo = true;
                              });
                              await _initializeControllerFuture;
                              startVideoRecording();
                            },
                            onLongPressEnd: (details) async {
                              setState(() {
                                _isRecordingVideo = true;
                              });
                              await _initializeControllerFuture;
                              stopVideoRecording();
                            },
                            onTap: () async {
                              setState(() {
                                mBooltap = !mBooltap;
                              });
                              try {
                                await _initializeControllerFuture;
                                final _image = await _controller.takePicture();
                                imagelist.add(File(_image.path));
                                if (!mounted) return;
                                await Navigator.of(context).push(
                                  RouteTransitions.slideTransition(DisplayPictureScreen(
                                    widget.count,
                                    mBoolselfie,
                                    widget.usermastid,
                                    widget.is_broadcast,
                                    sender_name: widget.sender_name,
                                    serverKey: widget.serverKey,
                                    Medialist: List.generate(
                                        imagelist.length,
                                        (index) => MediaModel(
                                            Media: imagelist[index],
                                            isimg: true)),
                                  )),
                                );
                              } catch (e) {}
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Button container
                                AnimatedContainer(
                                  height: mBooltap
                                      ? 100
                                      : _isRecordingVideo
                                          ? 100
                                          : 75,
                                  width: mBooltap
                                      ? 100
                                      : _isRecordingVideo
                                          ? 100
                                          : 75,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _isRecordingVideo
                                          ? Con_red
                                          : Con_white,
                                      width: 4,
                                    ),
                                  ),
                                  duration: const Duration(milliseconds: 100),
                                  onEnd: () {
                                    setState(() {
                                      mBooltap = false;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    margin: const EdgeInsets.all(5),
                                    height: mBooltap ? 90 : 65,
                                    width: mBooltap ? 90 : 65,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: mBooltap ? Con_white : Con_white12,
                                    ),
                                    duration: const Duration(milliseconds: 100),
                                  ),
                                ),
                              ],
                            ))),
                    Con_Wid.mIconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.photo,
                          color: Con_white,
                          size: 30,
                        )),
                  ]),
            ),
          ],
        ),
      ),
      onWillPop: () {
        imagelist.clear();
        setState(() {});
        return Future(() => true);
      },
    ));
  }

  Future<void> startVideoRecording() async {
    if (!_controller.value.isInitialized) {
      return;
    }

    try {
      await _controller.startVideoRecording();
    } on CameraException catch (e) {
      print(e);
      return;
    }

    _isRecording = true;
  }

  Future<void> stopVideoRecording() async {
    if (!_controller.value.isRecordingVideo) {
      return;
    }

    _isRecording = false;

    try {
      final file = await _controller.stopVideoRecording();
      Navigator.pushReplacement(context, RouteTransitions.slideTransition(DisplayPictureScreen(
            widget.count,
            mBoolselfie,
            widget.usermastid,
            widget.is_broadcast,
            sender_name: widget.sender_name,
            Medialist: [MediaModel(Media: File(file.path), isimg: false)],
            serverKey: widget.serverKey,
          )
      ));
    } on CameraException catch (e) {
      print(e);
    }
  }
}

class MediaModel {
  bool isimg;
  File Media;

  MediaModel({required this.Media, required this.isimg});

  static Map<String, dynamic> toJson(MediaModel m) {
    return {
      "isimg": m.isimg,
      "Media": m.Media,
    };
  }
}

class DisplayPictureScreen extends StatefulWidget {
  final int count;
  final String usermastid;
  final List<MediaModel> Medialist;
  bool mBoolselfie;
  final String is_broadcast;
  String serverKey;
  String sender_name;

  DisplayPictureScreen(
      this.count, this.mBoolselfie, this.usermastid, this.is_broadcast,
      {super.key,
      required this.Medialist,
      required this.sender_name,
      required this.serverKey});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

late File _image;
String mStrDownloadUrl = "";
int mIntSelectedindex = 0;

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  @override
  Widget build(BuildContext context) {
    widget.Medialist.forEach((e) => print(MediaModel.toJson(e)));

    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          return Future(() => true);
        },
        child: Scaffold(
          backgroundColor: Con_black,
          body: Stack(
            children: [
              widget.Medialist.isNotEmpty &&
                      (widget.Medialist[mIntSelectedindex].isimg == true)
                  ? (widget.mBoolselfie
                      ? Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: Center(
                              child: SizedBox(
                            width: double.infinity,
                            child: Image.file(File(
                              widget.Medialist[mIntSelectedindex].Media.path,
                            )),
                          )),
                        )
                      : Center(
                          child: SizedBox(
                              width: double.infinity,
                              child: Image.file(File(
                                widget.Medialist[mIntSelectedindex].Media.path,
                              )))))
                  : ImageBubble(
                      imageUrl: widget.Medialist[mIntSelectedindex].Media.path,
                      Padding: false,
                      blurhash: "",
                      isCurve: true,
                      imageName: widget.Medialist[mIntSelectedindex].Media.path
                          .split("/")
                          .last,
                      isRight: "1",
                      isVideo: true,
                      isLocal: true,
                      selected: false,
                      onTapChange: true,
                    ),
              Positioned(
                  top: 50.0,
                  right: 1.0,
                  left: 1.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Con_Wid.mIconButton(
                        onPressed: () {
                          // if (widget.imagelist.isNotEmpty) {
                          //   widget.imagelist.clear();
                          // }
                          // if (widget.VideoFile.isNotEmpty) {
                          //   widget.VideoFile.clear();
                          // }
                          Navigator.pop(context);
                        },
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                              color: Con_black45, shape: BoxShape.circle),
                          child: const Icon(
                            Icons.close,
                            color: Con_white,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          widget.Medialist[mIntSelectedindex].isimg
                              ? Con_Wid.mIconButton(
                                  onPressed: () {
                                    _cropImage(
                                        pickedFile: widget.Medialist.length == 1
                                            ? XFile(
                                                widget.Medialist[0].Media.path)
                                            : XFile(widget
                                                .Medialist[mIntSelectedindex]
                                                .Media
                                                .path));
                                  },
                                  icon: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                        color: Con_black45,
                                        shape: BoxShape.circle),
                                    child: const Icon(
                                      Icons.crop_rotate_rounded,
                                      color: Con_white,
                                    ),
                                  ),
                                )
                              : Container(),
                          Con_Wid.mIconButton(
                            onPressed: () {},
                            icon: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                  color: Con_black45, shape: BoxShape.circle),
                              child: const Icon(
                                Own_Face,
                                color: Con_white,
                              ),
                            ),
                          ),
                          Con_Wid.mIconButton(
                            onPressed: () {},
                            icon: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                  color: Con_black45, shape: BoxShape.circle),
                              child: const Icon(
                                Icons.text_fields_outlined,
                                color: Con_white,
                              ),
                            ),
                          ),
                          Con_Wid.mIconButton(
                            onPressed: () {},
                            icon: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                  color: Con_black45, shape: BoxShape.circle),
                              child: const Icon(
                                Icons.edit_outlined,
                                color: Con_white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              WillPopScope(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Con_Wid_Box(
                        messageType: MessageType.chat,
                        usermastid: widget.usermastid,
                        serverKey: widget.serverKey.toString(),
                        sender_name: widget.sender_name,
                        ismedia: true,
                        onSendMessage: (String value) async {
                          getImage(widget.Medialist);
                          // if (widget.Medialist.isNotEmpty) {
                          //   for (var e in widget.Medialist) {
                          //     if (e.isimg == true) {
                          //       getImage(e.Media.path.toString(), true);
                          //     } else {
                          //       getImage(e.Media.path.toString(), false);
                          //     }
                          //   }
                          // }
                          if (value.isNotEmpty) {
                            await sql_sub_messages_tran.Send_Msg(
                                msg_content:
                                    value.trim().trimLeft().trimRight(),
                                msg_type: "1",
                                msg_document_url: '',
                                sender_name: Constants_Usermast.user_login_name,
                                from_id: Constants_Usermast.user_id,
                                to_id: widget.usermastid,
                                is_broadcast: widget.is_broadcast,
                                server_key: widget.serverKey,
                                broadcast_id: '');
                          }
                          setState(() {});
                          int count = 0;
                          Navigator.of(context)
                              .popUntil((_) => count++ >= widget.count);
                        },
                      ),
                    ),
                  ],
                ),
                onWillPop: onBackPress,
              ),
              widget.Medialist.length > 1
                  ? Positioned(
                      right: 1,
                      left: 1,
                      bottom: 120,
                      child: SizedBox(
                          height: 70,
                          child: ListView.builder(
                            itemCount: widget.Medialist.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              if (widget.Medialist[index].isimg == true) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      mIntSelectedindex = index;
                                    });
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: mIntSelectedindex == index
                                            ? BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        const Color(0xff06809F),
                                                    width: 2),
                                              )
                                            : null,
                                        margin: const EdgeInsets.all(1),
                                        width: 70,
                                        child: Image.file(
                                          widget.Medialist[index].Media,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 2,
                                        right: 2,
                                        child: InkWell(
                                          child: Own_Remove_Media,
                                          onTap: () {
                                            setState(() {
                                              mIntSelectedindex == index
                                                  ? widget.Medialist.removeAt(
                                                      mIntSelectedindex)
                                                  : widget.Medialist.removeAt(
                                                      index);
                                              if (widget.Medialist.length > 2 &&
                                                  index < mIntSelectedindex) {
                                                mIntSelectedindex =
                                                    mIntSelectedindex - 1;
                                              } else {
                                                // mIntSelectedindex = 0;
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Stack(
                                  children: [
                                    Container(
                                        decoration: mIntSelectedindex == index
                                            ? BoxDecoration(
                                                border: Border.all(
                                                    color: Con_Main_1,
                                                    width: 2),
                                              )
                                            : null,
                                        margin: const EdgeInsets.all(1),
                                        width: 70,
                                        child: ImageBubble(
                                          imageUrl: widget
                                              .Medialist[index].Media.path,
                                          Padding: false,
                                          blurhash: "",
                                          imageName: widget
                                              .Medialist[index].Media.path
                                              .split("/")
                                              .last,
                                          isRight: "1",
                                          isVideo: true,
                                          isLocal: true,
                                          isSmall: true,
                                          NoButtontap: () {
                                            setState(() {
                                              mIntSelectedindex = index;
                                            });
                                          },
                                        )

                                        // Video_player(
                                        //   VideoFile:
                                        //       ,
                                        //   Showbutton: false,
                                        //   // NoButtontap: () {
                                        //   //   setState(() {
                                        //   //     mStrSelectedVideo =
                                        //   //         widget.VideoFile[index].path;
                                        //   //     mIntSelectedindex = index;
                                        //   //   });
                                        //   // },
                                        // ),
                                        ),
                                    Positioned(
                                      top: 2,
                                      right: 2,
                                      child: InkWell(
                                        child: Own_Remove_Media,
                                        onTap: () {
                                          setState(() {
                                            mIntSelectedindex == index
                                                ? widget.Medialist.removeAt(
                                                    mIntSelectedindex)
                                                : widget.Medialist.removeAt(
                                                    index);
                                            if (widget.Medialist.length > 2 &&
                                                index < mIntSelectedindex) {
                                              mIntSelectedindex =
                                                  mIntSelectedindex - 1;
                                            } else {
                                              // mIntSelectedindex = 0;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          )),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Future getImage(List<MediaModel> Medialist) async {
    for (int i = 0; i < Medialist.length;) {
      String _path = Medialist[i].Media.path;
      bool isImage = Medialist[i].isimg;
      firebase_storage.Reference storageReference =
          firebase_storage.FirebaseStorage.instance.ref().child(
              '${widget.is_broadcast != "0" ? isImage ? 'user_Broadcast_pictures' : 'user_Broadcast_video' : isImage ? 'user_message_pictures' : 'user_message_video'}/${Constants_Usermast.mobile_number}/${widget.is_broadcast != "0" ? widget.usermastid : widget.is_broadcast}/${Path.basename(_path)}');
      _image = File(_path);
      String _thumbnailBase64 = '';
      if (isImage) {
        final originalImage = img.decodeImage(_image.readAsBytesSync())!;
        final thumbnail = img.copyResize(originalImage, width: 50, height: 50);
        final blurredThumbnail = img.gaussianBlur(thumbnail, radius: 1);
        final compressedThumbnail =
            img.encodeJpg(blurredThumbnail, quality: 50);
        _thumbnailBase64 = base64Encode(compressedThumbnail);
      } else {
        final uint8list = await VideoThumbnail.thumbnailData(
          video: _image.path,
          imageFormat: vid.ImageFormat.JPEG,
          maxWidth: 50,
          quality: 50,
          timeMs: 0,
        );
        _thumbnailBase64 = base64.encode(uint8list!.toList());
      }
      firebase_storage.UploadTask uploadTask = storageReference.putFile(_image);
      uploadTask.whenComplete(() => 'print');
      var dowurl = await (await uploadTask.whenComplete(() => null))
          .ref
          .getDownloadURL();
      if (dowurl.isNotEmpty) {
        mStrDownloadUrl = dowurl.toString();
        await sql_sub_messages_tran.Send_Msg(
            msg_content: "",
            msg_type: isImage ? "2" : "5",
            msg_blurhash: _thumbnailBase64,
            msg_document_url: mStrDownloadUrl.toString(),
            msg_audio_name: Path.basename(_path),
            from_id: Constants_Usermast.user_id,
            sender_name: Constants_Usermast.user_login_name,
            to_id: widget.is_broadcast != "0" ? "" : widget.usermastid,
            server_key: widget.serverKey,
            is_broadcast: widget.is_broadcast != "0" ? "1" : "0",
            broadcast_id:
                widget.is_broadcast != "0" ? widget.is_broadcast : "");
        String sentpath = isImage
            ? Path.join(Folder.sentMedia.path, Path.basename(_path))
            : Path.join(Folder.sentVideo.path, Path.basename(_path));
        await File(_path).copy(sentpath);
        i++;
      }
    }
  }

  Future<bool> onBackPress() {
    return Future.value(false);
  }

  Future<void> _cropImage({required XFile pickedFile}) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: AppBar_ThemeColor,
            toolbarWidgetColor: Con_white,
            initAspectRatio: CropAspectRatioPreset.original,
            activeControlsWidgetColor: AppBar_ThemeColor,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );
    if (croppedFile != null) {
      setState(() {
        widget.Medialist.removeAt(mIntSelectedindex);
        widget.Medialist.insert(mIntSelectedindex,
            MediaModel(Media: File(croppedFile.path), isimg: true));
      });
    }
  }
}
