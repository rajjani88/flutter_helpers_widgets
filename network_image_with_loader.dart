import 'package:flutter/material.dart';

class NetworkImageWithLoader extends StatelessWidget {
  final String imageUrl;
  final Image placeholderImage;

  const NetworkImageWithLoader({
    Key? key,
    required this.imageUrl,
    required this.placeholderImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.fill,
      errorBuilder: (context, error, stackTrace) {
        return placeholderImage;
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
