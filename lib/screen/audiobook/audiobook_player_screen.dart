import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class AudiobookPlayerScreen extends StatefulWidget {
  static String tag = '/AudiobookPlayerScreen';

  String audiobookName;
  String audiobookUrl;

  AudiobookPlayerScreen({required this.audiobookName, required this.audiobookUrl});

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudiobookPlayerScreen> {
  late AudioPlayer _audioPlayer;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _position = position;
      });
    });

    _audioPlayer.durationStream.listen((duration) {
      setState(() {
        _duration = duration ?? Duration.zero;
      });
    });

    _audioPlayer.setUrl(widget.audiobookUrl);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _play() async {
    _audioPlayer.play();
  }

  void _pause() {
    _audioPlayer.pause();
  }

  void _stop() {
    _audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.audiobookName),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProgressBar(
            progress: _position,
            buffered: _audioPlayer.bufferedPosition,
            total: _duration,
            onSeek: (duration) {
              _audioPlayer.seek(duration);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: _play,
              ),
              IconButton(
                icon: Icon(Icons.pause),
                onPressed: _pause,
              ),
              IconButton(
                icon: Icon(Icons.stop),
                onPressed: _stop,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
