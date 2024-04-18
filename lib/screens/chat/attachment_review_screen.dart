import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class AttachmentReviewScreen extends StatefulWidget {
  final String path;
  const AttachmentReviewScreen({super.key, required this.path});

  @override
  State<AttachmentReviewScreen> createState() => _AttachmentReviewScreenState();
}

class _AttachmentReviewScreenState extends State<AttachmentReviewScreen> {
  late VideoPlayerController controller;
  late Future<void> initializeVideoPlayer;

  @override
  void initState() {
    controller = VideoPlayerController.file(File(widget.path));
    initializeVideoPlayer = controller.initialize();
    controller.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
            height: Get.size.height * 0.75,
            width: Get.size.width * 0.9,
            child: FutureBuilder(
                future: initializeVideoPlayer,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(controller),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                })),
        Align(
          alignment: Alignment.center,
          child: InkWell(
            onTap: () {
              // setState(() {
              controller.value.isPlaying
                  ? controller.pause()
                  : controller.play();
              // });
            },
            child: Icon(
              controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 40,
            ),
          ),
        )
      ],
    );
  }
}
