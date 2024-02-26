import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:musico/common.dart';

///
class MusicSeek extends StatefulWidget {
  MusicSeek({required this.player, required this.duration, super.key});

  AudioPlayer player;

  Duration duration;

  @override
  State<MusicSeek> createState() => _MusicSeekState();
}

class _MusicSeekState extends State<MusicSeek> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.player.onPositionChanged,
      builder: (c, value) {
        return SeekBar(
          duration: widget.duration ?? Duration.zero,
          position: value.data ?? Duration.zero,
          bufferedPosition: value.data ?? Duration.zero,
          onChangeEnd: (d) {
            widget.player.seek(d);
          },
        );
      },
    );
  }
}
