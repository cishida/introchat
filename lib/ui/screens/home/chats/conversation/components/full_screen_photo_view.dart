import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenPhotoView extends StatelessWidget {
  FullScreenPhotoView(this.imageDownloadUrl);
  final String imageDownloadUrl;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.down,
      key: Key('fullScreenPhotoView'),
      onDismissed: (_) {
        Navigator.pop(context);
      },
      child: Container(
          constraints: BoxConstraints(
            minWidth: 0.0,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: CachedNetworkImage(
            imageUrl: imageDownloadUrl,
            placeholder: (context, url) => CircularProgressIndicator(),
          )),
    );
  }
}
