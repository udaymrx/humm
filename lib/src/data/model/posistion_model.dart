class PositionData {
  final Duration position;
  final Duration duration;
  final Duration? bufferedPosition;

  PositionData(this.position, this.duration, [this.bufferedPosition]);
}
