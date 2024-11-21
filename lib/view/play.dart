import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../privider/provider.dart';

class VideoPage extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String channelName;
  final String des;

  const VideoPage({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.channelName,
    required this.des,
  });

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  // Define custom colors
  final Color backgroundColor = const Color(0xFF121212);
  final Color primaryTextColor = Colors.white;
  final Color secondaryTextColor = Colors.grey;
  final Color accentColor = const Color(0xFF1DB954);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<VideoProvider>(context, listen: false)
          .initializePlayer(widget.videoUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    var providerTrue = Provider.of<VideoProvider>(context);
    var providerFalse = Provider.of<VideoProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player Section
            providerTrue.chewieController != null &&
                providerTrue.videoPlayerController.value.isInitialized
                ? AspectRatio(
              aspectRatio:
              providerTrue.videoPlayerController.value.aspectRatio,
              child: Chewie(controller: providerTrue.chewieController!),
            )
                : const Center(
              child: CircularProgressIndicator(),
            ),

            // Video Details Section
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: primaryTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'By ${widget.channelName}',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.des,
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 14,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(Icons.add_circle_outline, 'Wishlist'),
                          _buildActionButton(Icons.share, 'Share'),
                          _buildActionButton(Icons.download, 'Download'),
                        ],
                      ),
                      const Divider(color: Colors.grey, height: 32),

                      // Related Videos Section
                      const Text(
                        'Related Videos',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FutureBuilder(
                        future: providerFalse.fetchApi(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ListView.builder(
                              itemCount: 6,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 80,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade800,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                );
                              },
                            );
                          } else {
                            final videos = providerTrue
                                .videoModal!.categories.first.videos
                                .where((video) =>
                            video.sources.first != widget.videoUrl)
                                .toList();

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: videos.length,
                              itemBuilder: (context, index) {
                                final video = videos[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => VideoPage(
                                          videoUrl: video.sources.first,
                                          title: video.title,
                                          channelName: video.subtitle.name,
                                          des: video.description,
                                        ),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                        video.thumb,
                                        height: 70,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    title: Text(
                                      video.title,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      'By ${video.subtitle.name}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: secondaryTextColor,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: accentColor, size: 30),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: secondaryTextColor, fontSize: 12),
        ),
      ],
    );
  }
}
