import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

import '../Constant/Con_Clr.dart';
import '../Constant/Con_Icons.dart';
import '../Constant/Con_Wid.dart';

class Video_player extends StatefulWidget {
  File VideoFile;
  bool? Showbutton, ConChange = false, AppBar_Slider = true;
  void Function()? NoButtontap;
  String? isRight, pStrFromName, pStrDate;

  Video_player(
      {super.key,
      required this.VideoFile,
      this.isRight,
      this.Showbutton,
      this.AppBar_Slider,
      this.ConChange,
      this.pStrDate,
      this.pStrFromName});

  @override
  State<Video_player> createState() => _Video_playerState();
}

class _Video_playerState extends State<Video_player> {
  late VideoPlayerController _controller;
  bool VideoPlay = false;
  final ValueNotifier<double> _sliderValue = ValueNotifier(0.0);
  final ValueNotifier<Duration> _currentTime = ValueNotifier(Duration.zero);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.file(File(widget.VideoFile.path))
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.addListener(() {
      if (_controller.value.position ==
          _controller.value.duration) {
        _controller.pause();
        setState(() {
          VideoPlay = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _sliderValue.dispose();
    _currentTime.dispose();
    _controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized) {
      return Scaffold(
        appBar: (widget.AppBar_Slider ?? true)
            ? AppBar(
                titleSpacing: 0,
                leadingWidth: 42,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Con_Wid.mIconButton(
                    icon: Own_ArrowBack,
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                  ),
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (widget.pStrFromName ?? '').isEmpty &&
                          (widget.pStrDate ?? '').isEmpty
                      ? []
                      : [
                          Text(
                              "${widget.isRight == "1" ? "You" : widget.pStrFromName}"),
                          Text(
                            "${widget.pStrDate}",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                ),
                backgroundColor: Con_transparent.withOpacity(0.60),
              )
            : null,
        backgroundColor: AppBar_Font_PrimaryColor,
        body: Video_widget(),
      );
    } else {
      return Container();
    }
  }

  Widget Video_widget() {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: GestureDetector(
          onTap: widget.Showbutton ?? true
              ? () {
                  setState(() {
                    _controller.pause();
                    VideoPlay = false;
                  });
                }
              : widget.NoButtontap,
          child: Stack(
            children: [
              Center(
                child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller)),
              ),
              VideoPlay
                  ? (widget.AppBar_Slider ?? true)
                      ? Positioned(
                          bottom: 40,
                          left: 0,
                          right: 0,
                          top: 610,
                          child: Container(
                              height: 30,
                              color: Con_black54,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Video_Slider(
                                    _controller,
                                    allowScrubbing: true,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 1, horizontal: 15),
                                    colors: const VideoProgressColors(
                                      playedColor: App_Float_Back_Color,
                                      bufferedColor: Con_grey,
                                      backgroundColor: Con_black26,
                                    ),
                                  ),
                                ],
                              )))
                      : Container()
                  : Container(),
              (widget.Showbutton ?? true)
                  ? VideoPlay
                      ? Container()
                      : Center(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _controller.play();
                                VideoPlay = true;
                              });
                            },
                            child: const CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.black45,
                              child: Icon(
                                Icons.play_arrow,
                                size: 50,
                              ),
                            ),
                          ),
                        )
                  : Container(),
            ],
          )),
    );
  }
}

class Video_Slider extends StatefulWidget {
  const Video_Slider(
    this.controller, {
    super.key,
    this.colors = const VideoProgressColors(),
    required this.allowScrubbing,
    this.padding = const EdgeInsets.only(top: 5.0),
  });

  final VideoPlayerController controller;
  final VideoProgressColors colors;
  final bool allowScrubbing;
  final EdgeInsets padding;

  @override
  State<Video_Slider> createState() => _Video_SliderState();
}

class _Video_SliderState extends State<Video_Slider> {
  _Video_SliderState() {
    listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
  }

  late VoidCallback listener;

  VideoPlayerController get controller => widget.controller;

  VideoProgressColors get colors => widget.colors;

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void deactivate() {
    controller.removeListener(listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    Widget progressIndicator;
    if (controller.value.isInitialized) {
      final int duration = controller.value.duration.inMilliseconds;
      final int position = controller.value.position.inMilliseconds;

      int maxBuffering = 0;
      for (final DurationRange range in controller.value.buffered) {
        final int end = range.end.inMilliseconds;
        if (end > maxBuffering) {
          maxBuffering = end;
        }
      }
      progressIndicator = Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "${Duration(milliseconds: position).inMinutes}:${(Duration(milliseconds: position).inSeconds % 60).toString().padLeft(2, '0')}",
              style: const TextStyle(
                color: Con_white,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          SizedBox(
            height: 5,
            width: 260,
            child: Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
                Slider(
                  value: position.toDouble(),
                  min: 0,
                  max: duration.toDouble(),
                  onChanged: (double value) {
                    // Handle slider value change here
                    // You can update the position of the video player accordingly
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              "${Duration(milliseconds: maxBuffering).inMinutes}:${(Duration(milliseconds: maxBuffering).inSeconds % 60).toString().padLeft(2, '0')}",
              style: const TextStyle(color: Con_white, fontSize: 12),
            ),
          ),
        ],
      );
    } else {
      progressIndicator = LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(colors.playedColor),
        backgroundColor: colors.backgroundColor,
      );
    }
    final Widget paddedProgressIndicator = Padding(
      padding: widget.padding,
      child: progressIndicator,
    );
    if (widget.allowScrubbing) {
      return VideoScrubber(
        controller: controller,
        child: paddedProgressIndicator,
      );
    } else {
      return paddedProgressIndicator;
    }
  }
}
