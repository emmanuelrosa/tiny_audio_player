extension DurationUtils on Duration {
  /// Formats the duration in the HH:MM:SS format.
  String toHHMMSS() {
    final buffer = StringBuffer();

    buffer.write(inHours > 0 ? '$inHours'.padLeft(2, '0') : '00');
    buffer.write(':');
    buffer.write(
      inMinutes > 0 ? '${inMinutes.remainder(60)}'.padLeft(2, '0') : '00',
    );
    buffer.write(':');
    buffer.write(
      inSeconds > 0 ? '${inSeconds.remainder(60)}'.padLeft(2, '0') : '00',
    );

    return buffer.toString();
  }

  /// Returns the smallest (lesser) [Duration].
  Duration min(Duration other) => this <= other ? this : other;

  /// Returns the largest (greater) [Duration].
  Duration max(Duration other) => this >= other ? this : other;
}
