import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nextapp/Media/CamaraScreen.dart';
import 'package:nextapp/Media/DocumentScreen.dart';
import 'package:nextapp/Media/SongScreen.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../Constant/Con_Clr.dart';
import '../Constant/Con_Wid.dart';
import '../Constant/Image_picker/drishya_picker.dart';
import '../Constant/Image_picker/src/drishya_entity.dart';
import '../Constant/Warning_Dialog.dart';

class Media_Widget extends StatefulWidget {
  String usermastid, sender_name, is_broadcast, serverKey;
  bool? isauto;
  bool? vertical;
  String? isSelectedAuto;
  ValueChanged<bool>? MediaShare;
  ValueChanged<List<MediaModel>>? Selected_Image_Video;
  ValueChanged<List<File>>? Selected_Document;
  ValueChanged<List<SongModel>>? Selected_Song;
  GalleryController? controller;

  Media_Widget(this.usermastid, this.is_broadcast, this.serverKey,
      {super.key,
      this.isauto,
      this.isSelectedAuto,
      this.Selected_Image_Video,
      this.MediaShare,
      this.vertical,
      required this.controller,
      required this.sender_name,
      this.Selected_Document,
      this.Selected_Song});

  @override
  State<Media_Widget> createState() => _Media_WidgetState();
}

class _Media_WidgetState extends State<Media_Widget> {
  XFile? media;
  final ImagePicker _picker = ImagePicker();
  late final ValueNotifier<Data> _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = ValueNotifier(Data());
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.vertical == true
        ? Stack(
            alignment: Alignment.topCenter,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: ValueListenableBuilder<Data>(
                  valueListenable: _notifier,
                  builder: (context, data, child) {
                    return GalleryViewField(
                      onCamaraPress: () async {
                        WidgetsFlutterBinding.ensureInitialized();
                        List<CameraDescription> cameras =
                            await availableCameras();
                        CameraDescription firstCamera = cameras[0];
                        if (widget.isauto ?? false) {
                        } else {
                          widget.MediaShare!.call(false);
                          Navigator.push(
                              context,
                              RouteTransitions.slideTransition(CameraScreen(
                                count: 2,
                                camera: firstCamera,
                                usermastid: widget.usermastid,
                                is_broadcast: widget.is_broadcast,
                                sender_name: widget.sender_name,
                                serverKey: widget.serverKey,
                              )));
                        }
                      },
                      setting: gallerySetting.copyWith(
                        maximumCount: 5,
                        albumSubtitle: 'Image only',
                        requestType: data.requestType,
                        selectedEntities: data.entities,
                      ),
                      controller: widget.controller,
                      onChanged: (entity, remove) {
                        final entities = _notifier.value.entities.toList();
                        remove ? entities.remove(entity) : entities.add(entity);
                        _notifier.value =
                            _notifier.value.copyWith(entities: entities);
                      },
                      onSubmitted: (list) async {
                        _notifier.value =
                            _notifier.value.copyWith(entities: list);
                        List<MediaModel> imagelist = [];
                        for (var e in list) {
                          File? u = await e.file;
                          imagelist.add(MediaModel(
                              Media: u!,
                              isimg: e.mimeType!.toLowerCase().contains('image')
                                  ? true
                                  : false));
                          if (list.length == imagelist.length) {
                            if (widget.isauto ?? false) {
                              widget.Selected_Image_Video!.call(imagelist);
                            } else {
                              Navigator.push(
                                  context,
                                  RouteTransitions.slideTransition(
                                      DisplayPictureScreen(
                                    1,
                                    false,
                                    widget.usermastid,
                                    widget.is_broadcast,
                                    sender_name: widget.sender_name,
                                    serverKey: widget.serverKey,
                                    Medialist: imagelist,
                                  )));
                            }
                          }
                        }
                        widget.MediaShare!.call(false);
                        if (_notifier.value.entities.isNotEmpty) {
                          _notifier.value.entities.clear();
                        }
                      },
                      child: child,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                        color: Color(0xCDE4EAFF),
                        border: Border.all(
                            width: 1.5,
                            color: getPlatformBrightness()
                                ? Dark_MediaBox_Item
                                : Color(0xCDE4EAFF)),
                        borderRadius: BorderRadius.circular(10)),
                    child: Image.asset(
                      "assets/images/Gallery_Icon.webp",
                      color: getPlatformBrightness()
                          ? Dark_MediaBox_Item
                          : Con_msg_auto_6,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                    onTap: () async {
                      if ((widget.isauto ?? false) &&
                          widget.isSelectedAuto!.isNotEmpty &&
                          widget.isSelectedAuto! != 'DOCUMENT') {
                        showWarningDialog(
                            context: context,
                            title: "Warning!",
                            message:
                                "Selecting a document will remove the currently selected ${widget.isSelectedAuto!.toLowerCase()}. Do You Want To Continue ?",
                            onYesPressed: () {
                              PickDoc(context);
                            });
                      } else {
                        PickDoc(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          color: Color(0xCDE4EAFF),
                          border: Border.all(
                              width: 1.5,
                              color: getPlatformBrightness()
                                  ? Dark_MediaBox_Item
                                  : Color(0xCDE4EAFF)),
                          borderRadius: BorderRadius.circular(10)),
                      child: Image.asset(
                        "assets/images/Doc_Icon.webp",
                        color: getPlatformBrightness()
                            ? Dark_MediaBox_Item
                            : Con_msg_auto_6,
                      ),
                    )),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                    onTap: () {
                      if ((widget.isauto ?? false) &&
                          widget.isSelectedAuto!.isNotEmpty &&
                          widget.isSelectedAuto! != 'AUDIO') {
                        showWarningDialog(
                            context: context,
                            title: "Warning!",
                            message:
                                "Selecting a audio will remove the currently selected ${widget.isSelectedAuto!.toLowerCase()}. Do You Want To Continue ?",
                            onYesPressed: () {
                              PickAudio(context);
                            });
                      } else {
                        PickAudio(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          color: Color(0xCDE4EAFF),
                          border: Border.all(
                              width: 1.5,
                              color: getPlatformBrightness()
                                  ? Dark_MediaBox_Item
                                  : Color(0xCDE4EAFF)),
                          borderRadius: BorderRadius.circular(10)),
                      child: Image.asset(
                        "assets/images/Music_Icon.webp",
                        color: getPlatformBrightness()
                            ? Dark_MediaBox_Item
                            : Con_msg_auto_6,
                      ),
                    )),
              )
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ValueListenableBuilder<Data>(
                valueListenable: _notifier,
                builder: (context, data, child) {
                  return GalleryViewField(
                    onCamaraPress: () async {
                      WidgetsFlutterBinding.ensureInitialized();
                      List<CameraDescription> cameras =
                          await availableCameras();
                      CameraDescription firstCamera = cameras[0];
                      if (widget.isauto ?? false) {
                      } else {
                        widget.MediaShare!.call(false);
                        Navigator.push(
                            context,
                            RouteTransitions.slideTransition(CameraScreen(
                              count: 2,
                              camera: firstCamera,
                              usermastid: widget.usermastid,
                              is_broadcast: widget.is_broadcast,
                              sender_name: widget.sender_name,
                              serverKey: widget.serverKey,
                            )));
                      }
                    },
                    setting: gallerySetting.copyWith(
                      maximumCount: 5,
                      albumSubtitle: 'Image only',
                      requestType: data.requestType,
                      selectedEntities: data.entities,
                    ),
                    controller: widget.controller,
                    onChanged: (entity, remove) {
                      final entities = _notifier.value.entities.toList();
                      remove ? entities.remove(entity) : entities.add(entity);
                      _notifier.value =
                          _notifier.value.copyWith(entities: entities);
                    },
                    onSubmitted: (list) async {
                      _notifier.value =
                          _notifier.value.copyWith(entities: list);
                      List<MediaModel> imagelist = [];
                      for (var e in list) {
                        File? u = await e.file;
                        imagelist.add(MediaModel(
                            Media: u!,
                            isimg: e.mimeType!.toLowerCase().contains('image')
                                ? true
                                : false));
                        if (list.length == imagelist.length) {
                          if (widget.isauto ?? false) {
                            widget.Selected_Image_Video!.call(imagelist);
                          } else {
                            Navigator.push(
                                context,
                                RouteTransitions.slideTransition(
                                    DisplayPictureScreen(
                                  1,
                                  false,
                                  widget.usermastid,
                                  widget.is_broadcast,
                                  sender_name: widget.sender_name,
                                  serverKey: widget.serverKey,
                                  Medialist: imagelist,
                                )));
                          }
                        }
                      }
                      widget.MediaShare!.call(false);
                      if (_notifier.value.entities.isNotEmpty) {
                        _notifier.value.entities.clear();
                      }
                    },
                    child: child,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1.5,
                          color: getPlatformBrightness()
                              ? Dark_MediaBox_Item
                              : Con_Clr_App_1),
                      shape: BoxShape.circle),
                  child: Image.asset(
                    "assets/images/Gallery_Icon.webp",
                    color: getPlatformBrightness()
                        ? Dark_MediaBox_Item
                        : AppGreyColor,
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () async {
                    if ((widget.isauto ?? false) &&
                        widget.isSelectedAuto!.isNotEmpty &&
                        widget.isSelectedAuto! != 'DOCUMENT') {
                      showWarningDialog(
                          context: context,
                          title: "Warning!",
                          message:
                              "Selecting a document will remove the currently selected ${widget.isSelectedAuto!.toLowerCase()}. Do You Want To Continue ?",
                          onYesPressed: () {
                            PickDoc(context);
                          });
                    } else {
                      PickDoc(context);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.5,
                            color: getPlatformBrightness()
                                ? Dark_MediaBox_Item
                                : Con_Clr_App_1),
                        shape: BoxShape.circle),
                    child: Image.asset(
                      "assets/images/Doc_Icon.webp",
                      color: getPlatformBrightness()
                          ? Dark_MediaBox_Item
                          : AppGreyColor,
                    ),
                  )),
              GestureDetector(
                  onTap: () {
                    if ((widget.isauto ?? false) &&
                        widget.isSelectedAuto!.isNotEmpty &&
                        widget.isSelectedAuto! != 'AUDIO') {
                      showWarningDialog(
                          context: context,
                          title: "Warning!",
                          message:
                              "Selecting a audio will remove the currently selected ${widget.isSelectedAuto!.toLowerCase()}. Do You Want To Continue ?",
                          onYesPressed: () {
                            PickAudio(context);
                          });
                    } else {
                      PickAudio(context);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.5,
                            color: getPlatformBrightness()
                                ? Dark_MediaBox_Item
                                : Con_Clr_App_1),
                        shape: BoxShape.circle),
                    child: Image.asset(
                      "assets/images/Music_Icon.webp",
                      color: getPlatformBrightness()
                          ? Dark_MediaBox_Item
                          : AppGreyColor,
                    ),
                  )),
            ],
          );
  }

  PickAudio(context) async {
    try {
      if (widget.isauto ?? false) {
        Navigator.push(
            context,
            RouteTransitions.slideTransition(SongScreen(
              usermastid: widget.usermastid,
              is_broadcast: widget.is_broadcast,
              sender_name: widget.sender_name,
              server_key: widget.serverKey,
              Selected: (value) {
                widget.Selected_Song!.call(value);
              },
              is_AutoMsg: true,
            )));
      } else {
        widget.MediaShare!.call(false);
        Navigator.push(
            context,
            RouteTransitions.slideTransition(SongScreen(
                server_key: widget.serverKey,
                sender_name: widget.sender_name,
                usermastid: widget.usermastid,
                is_broadcast: widget.is_broadcast)));
      }
    } catch (e) {}
  }

  PickDoc(context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      if (files.any((e) => e.lengthSync() > 50000000)) {
        Fluttertoast.showToast(
          msg: 'Document exceed the size limit of 50 MB',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else if (files.length > 5) {
        Fluttertoast.showToast(
          msg: 'You Can Select Only 5 Document',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        if (widget.isauto ?? false) {
          widget.Selected_Document!.call(files);
        } else {
          widget.MediaShare!.call(false);
          Navigator.push(
              context,
              RouteTransitions.slideTransition(DisplayDocumentScreen(
                  1, widget.usermastid, widget.is_broadcast,
                  sender_name: widget.sender_name,
                  DocumnetList: files,
                  serverKey: widget.serverKey)));
        }
      }
    } else {}
  }

  GallerySetting get gallerySetting => const GallerySetting(
        enableCamera: true,
        maximumCount: 10,
        requestType: RequestType.all,
      );
}

class Data {
  Data({
    this.entities = const [],
    this.maxLimit = 10,
    this.requestType = RequestType.all,
  });

  final List<DrishyaEntity> entities;
  final int maxLimit;
  final RequestType requestType;

  Data copyWith({
    List<DrishyaEntity>? entities,
    int? maxLimit,
    RequestType? requestType,
  }) {
    return Data(
      entities: entities ?? this.entities,
      maxLimit: maxLimit ?? this.maxLimit,
      requestType: requestType ?? this.requestType,
    );
  }
}
