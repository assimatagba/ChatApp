import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  String imageUrl;
  String initials;
  double radius;

  CustomImage(this.imageUrl, this.initials, this.radius);

  @override
  Widget build(BuildContext context) {
    if ( imageUrl == null) {
      return CircleAvatar(
        radius: radius ?? 0.0,
        backgroundColor: Colors.blue,
        child: Text(
          initials ?? "",
          style: TextStyle(
            color: Colors.white,
            fontSize: radius
          ),),
      );
    } else {
      ImageProvider provider = CachedNetworkImageProvider(imageUrl);
      if (radius == null) {
        // image dans chat
        return InkWell(
          child: Image(image: provider, width: 250),
          onTap: () {
            // Montrer l'image
          },
        );
    } else {
      return InkWell(
        child: CircleAvatar(
          radius: radius,
          backgroundImage: provider,
        ),
        onTap: () {

        },
      );
      }
    }
  }
}