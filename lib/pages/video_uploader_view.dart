// lib/widgets/video_uploader_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/video_uploader_controller.dart';
import '../pages/video_player_page.dart';

class VideoUploaderView extends StatelessWidget {
  const VideoUploaderView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VideoUploaderController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadVideos();
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Videolarım',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Obx(() {
              if (controller.isUploading.value) {
                return const Padding(
                  padding: EdgeInsets.all(8),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.upload),
                onPressed: controller.pickAndUploadVideo,
              );
            }),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final urls = controller.videoUrls;
          if (urls.isEmpty) {
            return const Text('Henüz video yüklenmedi.');
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: urls.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (_, i) {
              return GestureDetector(
                onTap: () {
                  Get.to(() => VideoPlayerPage(videoUrl: urls[i]));
                },
                child: Stack(
                  children: [
                    Card(
                      elevation: 2,
                      child: Positioned.fill(
                        child: Image.network(
                          urls[i],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                          const Center(child: Icon(Icons.videocam_off)),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        onPressed: () => controller.deleteVideo(i),
                      ),
                    ),
                    const Positioned(
                      bottom: 8,
                      left: 8,
                      child: Icon(Icons.play_circle_fill, color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
