import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../Constant/Con_Usermast.dart';
import '../../../mdi_page/A_ChatBubble/audio/helpers/utils.dart';


import '../../../Constant/Con_Clr.dart';
import 'contact_noise.dart';
import 'duration.dart';
import 'noises.dart';

class VoiceMessage extends StatefulWidget {
  VoiceMessage({
    Key? key,
    required this.audioSrc,
    required this.me,
    required this.Duration,
    this.audioLocalSrc = "",
    this.noiseCount = 27,
    this.meBgColor = Con_pink,
    this.contactBgColor = Con_white,
    this.contactFgColor = Con_pink,
    this.mePlayIconColor = Con_black,
    this.contactPlayIconColor = Con_black26,
    this.meFgColor = Con_white,
    this.played = false,
    this.onPlay,
  }) : super(key: key);

  final String audioSrc;
  final String audioLocalSrc;
  final String Duration;
  final int noiseCount;
  final Color meBgColor,
      meFgColor,
      contactBgColor,
      contactFgColor,
      mePlayIconColor,
      contactPlayIconColor;
  final bool played, me;

  Function()? onPlay;

  @override
  _VoiceMessageState createState() => _VoiceMessageState();
}

class _VoiceMessageState extends State<VoiceMessage>
    with TickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();
  final double maxNoiseHeight = 6.w(), noiseWidth = 26.5.w();
  Duration _audioDuration = const Duration();
  double maxDurationForSlider = .0000001;
  bool _isPlaying = false, x2 = false, _audioConfigurationDone = false;
  int _playingStatus = 0, duration = 00;
  String _remaingTime = '00:00';

  AnimationController? _controller;
  bool download = false;
  var connresult;
  double progress = 0.0;
  int mIntDuration = 0;

  @override
  void initState() {
    _setDuration();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _sizerChild(context);

  Row _sizerChild(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _playButton(context),
        const SizedBox(width: 5),
        _durationWithNoise(context),
        const SizedBox(width: 1),

        /// x2 button will be added here.
        _speed(context),
      ],
    );
  }

  _playButton(BuildContext context) => GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.me ? widget.meFgColor : widget.contactFgColor,
          ),
          width: 8.w(),
          height: 8.w(),
          child: GestureDetector(
            onTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              await _downloadAndPlay();
              !_audioConfigurationDone ? null : _changePlayingStatus();
            },
            child: !_audioConfigurationDone
                ? (Constants_Usermast.user_chat_mobile_audio &&
                            connresult == ConnectivityResult.mobile) ||
                        (Constants_Usermast.user_chat_wifi_audio &&
                            connresult == ConnectivityResult.wifi) ||
                        download
                    ? progress == 0.0
                        ? const CircularProgressIndicator(
                            color: Con_Main_1,
                          )
                        : CircularProgressIndicator(
                            color: Con_Main_1,
                            value: progress,
                          )
                    : const Icon(
                        Icons.download,
                        color: AppBar_ThemeColor,
                      )
                : Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: widget.me
                        ? widget.mePlayIconColor
                        : widget.contactPlayIconColor,
                    size: 5.w(),
                  ),
          ),
        ),
      );

  _durationWithNoise(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _noise(context),
          SizedBox(height: .1.w()),
          Row(
            children: [
              Text(
                _remaingTime,
                style: const TextStyle(
                    fontSize: 6.5,
                    color: Con_black,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 65,
              ),
              Text(
                widget.Duration,
                style: const TextStyle(
                    fontSize: 6.5,
                    color: Con_black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      );

  /// Noise widget of audio.
  _noise(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final newTHeme = theme.copyWith(
      sliderTheme: SliderThemeData(
        trackShape: CustomTrackShape(),
        thumbShape: SliderComponentShape.noThumb,
        minThumbSeparation: 0,
      ),
    );

    /// document will be added
    return Theme(
      data: newTHeme,
      child: SizedBox(
        height: 6.5.w(),
        width: noiseWidth,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            widget.me ? const Noises() : const ContactNoise(),
            if (_audioConfigurationDone)
              AnimatedBuilder(
                animation:
                    CurvedAnimation(parent: _controller!, curve: Curves.ease),
                builder: (context, child) {
                  return Positioned(
                    left: _controller!.value,
                    child: Container(
                      width: noiseWidth,
                      height: 6.w(),
                      color: widget.me
                          ? widget.meBgColor.withOpacity(.15)
                          : widget.contactBgColor.withOpacity(.35),
                    ),
                  );
                },
              ),
            Opacity(
              opacity: .0,
              child: Container(
                width: noiseWidth,
                color: Colors.amber.withOpacity(1),
                child: Material(
                  color: Con_transparent,
                  child: Slider(
                    min: 0.0,
                    max: maxDurationForSlider,
                    onChangeStart: (__) => _stopPlaying(),
                    onChanged: (_) => _onChangeSlider(_),
                    value: duration + .0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _speed(BuildContext context) => GestureDetector(
        onTap: () => _toggle2x(),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 1.6.w()),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.8.w()),
            color: widget.meFgColor.withOpacity(.28),
          ),
          width: 9.8.w(),
          child: Text(
            !x2 ? '1X' : '2X',
            style: TextStyle(fontSize: 9.8, color: widget.meFgColor),
          ),
        ),
      );

  _setPlayingStatus() => _isPlaying = _playingStatus == 1;

  _startPlaying() async {
    _playingStatus = await _player.play(widget.audioLocalSrc, isLocal: true);
    _setPlayingStatus();
    _controller!.forward();
    if (_controller!.isAnimating) {
      _player.setPlaybackRate(x2 ? 2 : 1);
    }
  }

  _stopPlaying() async {
    _playingStatus = await _player.pause();
    _controller!.stop();
  }

  void _setDuration({bool allowdownload = false}) async {
    connresult = await Connectivity().checkConnectivity();
    if (await File(widget.audioLocalSrc).exists()) {
    } else if ((Constants_Usermast.user_chat_mobile_audio &&
            connresult == ConnectivityResult.mobile) ||
        (Constants_Usermast.user_chat_wifi_audio &&
            connresult == ConnectivityResult.wifi) ||
        allowdownload) {
      setState(() {
        download = true;
      });
      await Dio().download(widget.audioSrc, widget.audioLocalSrc,
          onReceiveProgress: (a, b) {
        if (mounted) {
          setState(() {
            progress = a / b;
          });
        }
      });
    } else {
      setState(() {
        download = false;
      });
    }
    // mIntDuration = int.parse(widget.Duration == 'null' ?  '0' : widget.Duration);
    mIntDuration = await _player.getDuration();
    _audioDuration = Duration(microseconds: mIntDuration);

    duration = _audioDuration.inSeconds;
    maxDurationForSlider = duration + .0;

    /// document will be added
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: noiseWidth,
      duration: _audioDuration,
    );

    /// document will be added
    _controller!.addListener(() {
      if (_controller!.isCompleted) {
        _controller!.reset();
        _isPlaying = false;
        x2 = false;
        _remaingTime = "00:00";
        if (mounted) {
          setState(() {});
        }
      }
    });
    _setAnimationCunfiguration(_audioDuration);
  }

  void _setAnimationCunfiguration(Duration? audioDuration) async {
    if (_controller!.isCompleted == false) {
      _listenToRemaningTime();
    }
    // _totalTime = VoiceDuration.getDuration(duration);
    _completeAnimationConfiguration();
  }

  void _completeAnimationConfiguration() =>
      setState(() => _audioConfigurationDone = true);

  void _toggle2x() {
    x2 = !x2;

    _controller!.duration = Duration(seconds: x2 ? duration ~/ 2 : duration);
    if (_controller!.isAnimating) {
      _controller!.forward();
      _player.setPlaybackRate(x2 ? 2 : 1);
    }
    setState(() {});
  }

  void _changePlayingStatus() async {
    if (widget.onPlay != null) widget.onPlay!();
    _isPlaying ? _stopPlaying() : _startPlaying();
    setState(() => _isPlaying = !_isPlaying);
  }

  _downloadAndPlay() {
    if (download == false) {
      _setDuration(allowdownload: true);
    }
  }

  @override
  void dispose() {
    if(mounted)
    _player.dispose();
    super.dispose();
  }

  void _listenToRemaningTime() {
    _player.onAudioPositionChanged.listen((Duration p) {
      final _newRemaingTime1 = p.toString().split('.')[0];
      final _newRemaingTime2 =
          _newRemaingTime1.substring(_newRemaingTime1.length - 5);
      if (_newRemaingTime2 != _remaingTime) {
        setState(() => _remaingTime = _newRemaingTime2);
      }
    });
  }

  /// document will be added
  _onChangeSlider(double d) async {
    if (_isPlaying) _changePlayingStatus();
    duration = d.round();
    _controller?.value = (noiseWidth) * duration / maxDurationForSlider;
    _remaingTime = VoiceDuration.getDuration(duration);
    await _player.seek(Duration(seconds: duration));
    setState(() {});
  }
}

/// document will be added
class CustomTrackShape extends RoundedRectSliderTrackShape {
  /// document will be added
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    const double trackHeight = 10;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
