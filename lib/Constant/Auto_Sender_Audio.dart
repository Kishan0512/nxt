import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'Con_Clr.dart';
import 'Con_Wid.dart';

class SongListWidget extends StatefulWidget {
  List<SongModel> songList;
  List<Map<String, String>> MediaList = [];
  ValueChanged<List<SongModel>> ListUpdate;

  SongListWidget({
    super.key,
    required this.songList,
    required this.MediaList,
    required this.ListUpdate,
  });

  @override
  _SongListWidgetState createState() => _SongListWidgetState();
}

class _SongListWidgetState extends State<SongListWidget> {
  int? songindex;
  int isLocal = 0;
  final AudioPlayer _player = AudioPlayer();
  List<bool> mList_Play_Song = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Init();
  }

  Init() {
    if (widget.MediaList.isEmpty && widget.songList.isNotEmpty) {
      setState(() {
        isLocal = 1;
      });
    } else if (widget.MediaList.isNotEmpty && widget.songList.isNotEmpty) {
      setState(() {
        isLocal = 2;
      });
    } else {
      setState(() {
        isLocal = 0;
      });
    }
    if (isLocal == 1) {
      mList_Play_Song = List.filled(widget.songList.length, false);
    } else if (isLocal == 2) {
      mList_Play_Song =
          List.filled(widget.songList.length + widget.MediaList.length, false);
    } else {
      mList_Play_Song = List.filled(widget.MediaList.length, false);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Init();
    return Container(
      constraints:  const BoxConstraints.expand(
        height: 200.0,
      ),
      padding: const EdgeInsets.all(6),
      alignment: Alignment.topRight,
      margin: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Con_blue),
      ),
      child: ListView.separated(
        itemCount: isLocal == 1
            ? widget.songList.length
            : isLocal == 2
                ? (widget.songList.length + widget.MediaList.length)
                : widget.MediaList.length,
        itemBuilder: (context, index) {
          String? pStrMediaSize;
          if (isLocal == 1) {
            pStrMediaSize = widget.songList[index].size < 1001
                ? "${widget.songList[index].size} BYTE"
                : widget.songList[index].size < 1000001
                    ? "${(widget.songList[index].size / 1000).toStringAsFixed(2)} KB"
                    : "${(widget.songList[index].size / 1000000).toStringAsFixed(2)} MB";
          } else if (isLocal == 2) {
            pStrMediaSize = (widget.songList.length > index)
                ? widget.songList[index].size < 1001
                    ? "${widget.songList[index].size} BYTE"
                    : widget.songList[index].size < 1000001
                        ? "${(widget.songList[index].size / 1000).toStringAsFixed(2)} KB"
                        : "${(widget.songList[index].size / 1000000).toStringAsFixed(2)} MB"
                : widget.MediaList[index - widget.MediaList.length]
                    ['msg_media_size'];
          } else {
            pStrMediaSize = widget.MediaList[index]['msg_media_size'];
          }

          return InkWell(
            onTap: () {
              try {
                setState(() {
                  songindex = index;
                });
                if (mList_Play_Song[index]) {
                  _player.pause();
                  mList_Play_Song[index] = false;
                  setState(() {});
                } else {
                  if (isLocal == 1) {
                    mList_Play_Song =
                        List.filled(widget.songList.length, false);
                  } else if (isLocal == 2) {
                    mList_Play_Song = List.filled(
                        widget.songList.length + widget.MediaList.length,
                        false);
                  } else {
                    mList_Play_Song =
                        List.filled(widget.MediaList.length, false);
                  }
                  setState(() {
                    mList_Play_Song[index] = true;
                  });
                  if (isLocal == 1) {
                    _player.play(widget.songList[index].data, isLocal: true);
                  } else if (isLocal == 2) {
                    if (widget.songList.length > index) {
                      _player.play(widget.songList[index].data, isLocal: true);
                    } else {
                      _player.play(
                          widget.MediaList[index - widget.MediaList.length]
                              ['msg_document_url']!,
                          isLocal: false);
                    }
                  } else {
                    _player.play(widget.MediaList[index]['msg_document_url']!,
                        isLocal: false);
                  }
                }
                setState(() {});
              } catch (e) {
                print("PlaySongError ---> $e");
              }
            },
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: Stack(
              children: [
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: getPlatformBrightness()
                        ? Dark_ChatField
                        : Con_msg_auto_1,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Con_msg_auto,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Container(
                              padding: const EdgeInsets.only(top: 8),
                              width: 52,
                              height: 52,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/no_cover11.webp")),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isLocal == 1
                                      ? widget.songList[index].title.length > 22
                                          ? (widget.songList[index].title.split('.').first.length > 22
                                              ? widget.songList[index].title.substring(0, 21) +
                                                  '...'
                                              : widget.songList[index].title
                                                  .split('.')
                                                  .first)
                                          : widget.songList[index].title
                                      : isLocal == 2
                                          ? ((widget.songList.length > index)
                                              ? widget.songList[index].title.length >
                                                      22
                                                  ? (widget.songList[index].title.split('.').first.length > 22
                                                      ? widget.songList[index].title.substring(0, 21) +
                                                          '...'
                                                      : widget.songList[index].title
                                                          .split('.')
                                                          .first)
                                                  : widget.songList[index].title
                                              : widget.MediaList[index - widget.MediaList.length]['msg_audio_name']!.length >
                                                      22
                                                  ? (widget.MediaList[index - widget.MediaList.length]['msg_audio_name']!.split('.').first.length > 22
                                                      ? widget.MediaList[index - widget.MediaList.length]['msg_audio_name']!.substring(0, 21) +
                                                          '...'
                                                      : widget.MediaList[index - widget.MediaList.length]['msg_audio_name']!
                                                          .split('.')
                                                          .first)
                                                  : widget.MediaList[index - widget.MediaList.length]
                                                      ['msg_audio_name']!)
                                          : widget.MediaList[index]['msg_audio_name']!.length >
                                                  22
                                              ? (widget.MediaList[index]['msg_audio_name']!.split('.').first.length > 22
                                                  ? widget.MediaList[index]['msg_audio_name']!.substring(0, 21) + '...'
                                                  : widget.MediaList[index]['msg_audio_name']!.split('.').first)
                                              : widget.MediaList[index]['msg_audio_name']!,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: getPlatformBrightness()
                                        ? Con_white
                                        : Con_msg_auto_2,
                                  ),
                                ),
                                Container(
                                  child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(3, 8, 3, 2),
                                    child: Text(
                                      "${isLocal == 1 ? widget.songList[index].artist : '<unknown>'} • $pStrMediaSize" " • ${isLocal == 1 ? widget.songList[index].fileExtension : isLocal == 2 ? (widget.songList.length > index) ? widget.songList[index].fileExtension : widget.MediaList[index - widget.MediaList.length]['msg_audio_name']!.split('.').last : widget.MediaList[index]['msg_audio_name']!.split('.').last}",
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w500,
                                        color: getPlatformBrightness()
                                            ? Con_white
                                            : Con_msg_auto,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 46, right: 4),
                        child: Container(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                widget.songList.removeAt(index);
                                widget.ListUpdate.call(widget.songList);
                              });
                            },
                            child: const Icon(
                              Icons.close,
                              color: Con_white,
                              size: 12,
                            ),
                          ),
                          width: (16),
                          height: (16),
                          decoration: const BoxDecoration(
                            color: Con_msg_auto,
                            borderRadius: BorderRadius.all(
                                Radius.elliptical(48, 48.02000045776367)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                mList_Play_Song[index] == true
                    ? Container(
                        height: 70,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Con_msg_auto_4,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Icon(Icons.pause_rounded,
                                  size: 60, color: Con_msg_auto_5),
                            )),
                      )
                    : Container(),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 6,
          );
        },
      ),
    );
  }
}
