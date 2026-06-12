import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  YoutubePlayerController? _controller;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    // Convierte URL completa (watch?v=...) en un ID de video de YouTube de forma segura
    final String? videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    if (videoId != null && videoId.isNotEmpty) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false, // Evita consumir datos si el alumno no le da Play
          mute: false,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
        ),
      );
    } else {
      setState(() => _hasError = true);
    }
  }

  @override
  void deactivate() {
    // Pausa el video si el diálogo se empieza a cerrar
    _controller?.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError || _controller == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(Icons.videocam_off, color: Colors.grey),
            SizedBox(width: 8),
            Text('Video no disponible para este ejercicio', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blue,
        progressColors: const ProgressBarColors(
          playedColor: Colors.blue,
          handleColor: Colors.blueAccent,
        ),
      ),
    );
  }
}