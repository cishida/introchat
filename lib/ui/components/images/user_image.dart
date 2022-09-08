import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/ui/components/empty_image.dart';

class UserImage extends StatelessWidget {
  final url;
  final radius;
  final bordered;

  UserImage({this.url, this.radius, this.bordered = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: url == null || url == ''
          ? EmptyImage(
              size: radius * 2,
            )
          : CachedNetworkImage(
              imageUrl: url,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    // colorFilter:
                    // ColorFilter.mode(Colors.red, BlendMode.colorBurn),
                  ),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
            ),
      width: radius * 2,
      height: radius * 2,
      padding: bordered && url != null && url != ''
          ? const EdgeInsets.all(3.0)
          : null, // borde width
      decoration: BoxDecoration(
        color: ConstantColors.BORDER, // border color
        shape: BoxShape.circle,
      ),
    );
    // return Container(
    //   width: radius * 2,
    //   height: radius * 2,
    //   decoration: BoxDecoration(
    //     color: const Color(0xff7c94b6),
    //     image: DecorationImage(
    //       image: NetworkImage(url),
    //       fit: BoxFit.cover,
    //     ),
    //     borderRadius: BorderRadius.all(Radius.circular(radius)),
    //     border: Border.all(
    //       color: Colors.red,
    //       width: 4.0,
    //     ),
    //   ),
    // );
  }
}
