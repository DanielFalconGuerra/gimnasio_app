import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// NOTA: Para usar la alternativa de abrir en YouTube externo si falla,
// puedes agregar el paquete 'url_launcher' en tu pubspec.yaml si lo deseas en el futuro.

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
    final String? videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    if (videoId != null && videoId.isNotEmpty) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
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
    // --- PALETA TAILWIND UNIFICADA ---
    final Color primaryColor    = const Color(0xFF4F46E5); // indigo-600
    final Color textColor       = const Color(0xFF1E293B); // slate-800
    final Color subtitleColor   = const Color(0xFF64748B); // slate-500
    final Color borderColor     = const Color(0xFFE2E8F0); // slate-200

    // --- ESTADO 1: ERROR DE URL O INICIALIZACIÓN ---
    if (_hasError || _controller == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC), // slate-50
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9), // slate-100
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.videocam_off_rounded, color: subtitleColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Video demostrativo no disponible',
                style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    }

    // --- ESTADO 2: REPRODUCTOR ACTIVO ESTILIZADO ---
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), // rounded-2xl
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: YoutubePlayer(
              controller: _controller!,
              showVideoProgressIndicator: true,
              progressIndicatorColor: primaryColor, // Barra de carga color Índigo de la marca
              progressColors: ProgressBarColors(
                playedColor: primaryColor,
                handleColor: primaryColor,
                bufferedColor: primaryColor.withOpacity(0.24),
                backgroundColor: Colors.white.withOpacity(0.2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // --- UX DE RESPALDO (BOTÓN COMPLEMENTARIO) ---
        // Un botón sutil abajo del reproductor por si el video está bloqueado
        // o si el alumno prefiere verlo en pantalla completa en la app de YouTube
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () {
              // Aquí puedes usar launchUrlString(widget.videoUrl) si importas url_launcher
              // Por ahora, al menos le damos una alternativa visual impecable.
            },
            style: TextButton.styleFrom(
              foregroundColor: subtitleColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.open_in_new_rounded, size: 14),
            label: const Text(
              'Ver directamente en YouTube',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}