/// document will be added
class VoiceDuration {
  /// document will be added
  static String getDuration(int duration) => duration < 60
      ? '00:' + (duration.toString().padLeft(2, '0'))
      : (duration ~/ 60).toString() +
          ':' +
          (duration % 60).toStringAsPrecision(2);
}
