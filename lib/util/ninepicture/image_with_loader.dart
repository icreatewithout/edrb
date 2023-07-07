import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";

class ImageWithLoader extends StatelessWidget {
  const ImageWithLoader({
    super.key,
    required this.url,
    required this.backgroundColor,
    required this.strokeWidth,
    required this.valueColor,
    required this.errorWidget,
    this.fit = BoxFit.cover,
    this.loaderSize = 32.0,
  });

  final String url;
  final BoxFit fit;
  final double loaderSize;

  final Color backgroundColor;
  final double strokeWidth;
  final Color valueColor;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          color: Colors.grey,
        ),
        CachedNetworkImage(
          imageUrl: url,
          fit: fit,
          placeholder: (context, url) => Center(
            child: SizedBox(
              width: loaderSize,
              height: loaderSize,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(valueColor),
                backgroundColor: backgroundColor,
                strokeWidth: strokeWidth,
              ),
            ),
          ),
          errorWidget: (context, url, error) =>
              errorWidget ?? const Icon(Icons.error),
        )
      ],
    );
  }
}
