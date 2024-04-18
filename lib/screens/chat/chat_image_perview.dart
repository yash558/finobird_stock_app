import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatImagePreview extends StatelessWidget {
  final String image;
  const ChatImagePreview({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey.withOpacity(0.1),
      ),
      body: Center(
        child: Hero(
          tag: "imageAnimation",
          child: CachedNetworkImage(
            imageUrl: image,
            placeholder: (context, url) => const SizedBox(
              height: 00,
            ),
            errorWidget: (context, url, error) => const SizedBox(
              height: 00,
            ),
          ),
        ),
      ),
    );
  }
}
