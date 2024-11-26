import 'dart:core';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:nextapp/A_SQL_Trigger/sql_sub_messages.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path/path.dart' as Path;

import '../Constant/Con_Clr.dart';
import '../Constant/Con_Icons.dart';
import '../Constant/Con_Wid.dart';

class SongScreen extends StatefulWidget {
  String usermastid;
  String is_broadcast;
  String server_key;
  String sender_name;
  bool? is_AutoMsg;
  ValueChanged<List<SongModel>>? Selected;

  SongScreen(
      {required this.usermastid,
      required this.is_broadcast,
      this.is_AutoMsg,
      required this.server_key,
      required this.sender_name,
      this.Selected,
      super.key});

  @override
  _SongScreenState createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _player = AudioPlayer();
  List<SongModel> mList_All_Song = [];
  List<SongModel> mList_Search_Song = [];

  List<int> mList_Selected_Song = [];
  List<bool> mList_Play_Song = [];
  bool is_box_value = false, isSearching = false;

  final TextEditingController _searchQuery = TextEditingController();
  String playid = "";
  int songindex = 0;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    LogConfig logConfig = LogConfig(logType: LogType.DEBUG);
    _audioQuery.setLogConfig(logConfig);
    checkAndRequestPermissions();
    getsong();
  }

  getsong() async {
    mList_All_Song = await _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    mList_Play_Song = List.filled(mList_All_Song.length, false);

    setState(() {});
  }

  checkAndRequestPermissions({bool retry = false}) async {
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    _hasPermission ? setState(() {}) : null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _player.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: mList_Selected_Song.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: (widget.is_AutoMsg ?? false)
                  ? () {
                      List<SongModel> SendSong = [];
                      for (var a in mList_Selected_Song) {
                        SendSong.add(
                            mList_All_Song.where((e) => e.id == a).toList()[0]);
                      }
                      if (SendSong.isNotEmpty) {
                        widget.Selected!.call(SendSong);
                      }
                      Navigator.pop(context);
                    }
                  : () {
                      savedata();
                      Navigator.pop(context);
                    },
              child: (widget.is_AutoMsg ?? false)
                  ? const Icon(Icons.check_rounded)
                  : const Icon(Icons.send),
            ),
      appBar: AppBar(
        title: isSearching
            ? TextField(
                autofocus: true,
                style: const TextStyle(color: Con_white),
                keyboardType: TextInputType.text,
                controller: _searchQuery,
                onChanged: (value) {
                  setState(() {
                    searchmethod(value);
                  });
                },
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Search.."),
              )
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Send to ${widget.sender_name}",
                    style: TextStyle(
                      fontSize: 20,
                    )),
                Text(
                    mList_Selected_Song.isEmpty
                        ? "Tap To Select"
                        : '${mList_Selected_Song.length} Selected',
                    style: TextStyle(fontSize: 10, color: Con_white70)),
              ]),
        leading: Con_Wid.mIconButton(
          icon: Own_ArrowBack,
          onPressed: () {
            if (isSearching) {
              isSearching = false;
            } else {
              mList_Selected_Song.clear();
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          Con_Wid.mIconButton(
            icon: isSearching ? Own_Delete_Search : Own_Search,
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
              });
            },
          ),
        ],
      ),
      body: Center(
        child: !_hasPermission
            ? noAccessToLibraryWidget()
            : mList_All_Song.isNotEmpty
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: isSearching
                        ? mList_Search_Song.length
                        : mList_All_Song.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: ListTile(
                          visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity),
                          onTap: () {
                            setState(() {
                              if (mList_Selected_Song.contains(isSearching
                                  ? mList_Search_Song[index].id
                                  : mList_All_Song[index].id)) {
                                mList_Selected_Song.remove(isSearching
                                    ? mList_Search_Song[index].id
                                    : mList_All_Song[index].id);
                              } else {
                                mList_Selected_Song.add(isSearching
                                    ? mList_Search_Song[index].id
                                    : mList_All_Song[index].id);
                              }
                            });
                          },
                          selected: mList_Selected_Song.contains(isSearching
                              ? mList_Search_Song[index].id
                              : mList_All_Song[index].id),
                          selectedTileColor: Selected_tileColor,
                          selectedColor: AppBar_ThemeColor,
                          title: Text((isSearching
                                  ? mList_Search_Song[index].title
                                  : mList_All_Song[index].title) ??
                              "No Title"),
                          subtitle: Text(
                              (isSearching
                                      ? mList_Search_Song[index].artist
                                      : mList_All_Song[index].artist) ??
                                  "No Artist",
                              style: const TextStyle(fontSize: 10)),
                          trailing: Container(
                            // margin: EdgeInsets.only(right: 15, bottom: 15),
                            decoration: BoxDecoration(
                                color: getPlatformBrightness()
                                    ? DarkTheme_AppBar
                                    : Con_black12,
                                shape: BoxShape.circle),
                            height: 30,
                            width: 30,
                            child: Center(
                                child: Con_Wid.mIconButton(
                              icon: mList_Play_Song[index]
                                  ? (getPlatformBrightness()
                                      ? Dark_audio_pause
                                      : Own_audio_pause)
                                  : (getPlatformBrightness()
                                      ? Dark_audio_play
                                      : Own_audio_play),
                              onPressed: () {
                                setState(() {
                                  songindex = index;
                                });
                                if (mList_Play_Song[index]) {
                                  _player.pause();
                                  mList_Play_Song[index] = false;
                                  setState(() {});
                                } else {
                                  mList_Play_Song =
                                      List.filled(mList_All_Song.length, false);
                                  mList_Play_Song[index] = true;
                                  _player.play(
                                      isSearching
                                          ? mList_Search_Song[index].data
                                          : mList_All_Song[index].data,
                                      isLocal: true);
                                }
                                setState(() {});
                              },
                            )),
                          ),
                          leading: QueryArtworkWidget(
                            artworkHeight: 35,
                            artworkWidth: 35,
                            controller: _audioQuery,
                            id: mList_All_Song[index].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: Image.asset(
                              "assets/images/no_cover1.webp",
                              height: 35,
                              width: 35,
                              color: AppBar_ThemeColor,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Container(),
      ),
      bottomNavigationBar: mList_All_Song.isNotEmpty
          ? mList_Play_Song[songindex]
              ? Card(
                  color: getPlatformBrightness()
                      ? Dark_MediaBox
                      : AppBar_PrimaryColor1,
                  child: ListTile(
                    visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity),
                    title: Text(mList_All_Song[songindex].title ?? "No Title"),
                    subtitle: Text(
                        (mList_All_Song[songindex].artist) ?? "No Artist",
                        style: const TextStyle(fontSize: 10)),
                    trailing: Container(
                      // margin: EdgeInsets.only(right: 15, bottom: 15),
                      decoration: BoxDecoration(
                          color: getPlatformBrightness()
                              ? Dark_ChatField
                              : Con_black12,
                          shape: BoxShape.circle),
                      height: 30,
                      width: 30,
                      child: Center(
                          child: Con_Wid.mIconButton(
                        icon: mList_Play_Song[songindex]
                            ? (getPlatformBrightness()
                                ? Dark_audio_pause2
                                : Own_audio_pause)
                            : (getPlatformBrightness()
                                ? Dark_audio_play
                                : Own_audio_play),
                        onPressed: () {
                          if (mList_Play_Song[songindex]) {
                            _player.pause();
                            // isplaying = false;
                            mList_Play_Song[songindex] = false;
                            setState(() {});
                          } else {
                            mList_Play_Song =
                                List.filled(mList_Play_Song.length, false);
                            mList_Play_Song[songindex] = true;
                            // isplaying = true;
                            _player.play(mList_All_Song[songindex].data,
                                isLocal: true);
                          }
                          setState(() {});
                        },
                      )),
                    ),
                    leading: QueryArtworkWidget(
                      artworkHeight: 35,
                      artworkWidth: 35,
                      controller: _audioQuery,
                      id: mList_All_Song[songindex].id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: Image.asset(
                        "assets/images/no_cover1.webp",
                        height: 35,
                        width: 35,
                        color: AppBar_ThemeColor,
                      ),
                    ),
                  ),
                )
              : Container(
                  height: 0,
                )
          : Container(
              height: 0,
            ),
    );
  }

  Widget noAccessToLibraryWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Con_redAccent.withOpacity(0.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Application doesn't have access to the library"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => checkAndRequestPermissions(retry: true),
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }

  Future<void> savedata() async {
    late File _image;
    List<SongModel> SendSong = [];
    for (var a in mList_Selected_Song) {
      SendSong.add(mList_All_Song.where((e) => e.id == a).toList()[0]);
    }
    for (var e in SendSong) {
      String _path = e.data;

      int seconds = (e.duration! / 1000).truncate();
      int minutes = (seconds / 60).truncate();
      int remainingSeconds = seconds % 60;
      firebase_storage.Reference storageReference =
          firebase_storage.FirebaseStorage.instance.ref().child(
              '${widget.is_broadcast != "0" ? 'user_Broadcast_audio' : 'user_message_audio'}/${Constants_Usermast.mobile_number}/${widget.is_broadcast != "0" ? widget.usermastid : widget.is_broadcast}/${Path.basename(_path)}');
      _image = File((_path));
      firebase_storage.UploadTask uploadTask = storageReference.putFile(_image);
      uploadTask.whenComplete(() => 'print');
      var dowurl = await (await uploadTask.whenComplete(() => null))
          .ref
          .getDownloadURL();
      if (dowurl.isNotEmpty) {
        await sql_sub_messages_tran.Send_Msg(
            msg_content: "",
            msg_type: "3",
            msg_document_url: dowurl.toString().toString(),
            msg_audio_name: Path.basename(_path),
            msg_media_size:
                minutes.toString() + ':' + remainingSeconds.toString(),
            from_id: Constants_Usermast.user_id,
            to_id: widget.is_broadcast != "0" ? "" : widget.usermastid,
            is_broadcast: widget.is_broadcast != "0" ? "1" : "0",
            server_key: widget.server_key,
            sender_name: widget.sender_name,
            broadcast_id:
                widget.is_broadcast != "0" ? widget.is_broadcast : "");
      }
    }
  }

  searchmethod(String value) {
    if (isSearching) {
      setState(() {
        mList_Search_Song = mList_All_Song
            .where((element) =>
                element.title
                    .toString()
                    .toLowerCase()
                    .contains(value.toLowerCase()) ||
                element.artist
                    .toString()
                    .toLowerCase()
                    .contains(value.toLowerCase()))
            .toList();
      });
    }
  }
}
