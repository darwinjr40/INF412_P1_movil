import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CardSwiper extends StatelessWidget {
  final List<XFile> photos;
  const CardSwiper({Key key, @required this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (this.photos.length == 0) {
      return Container(
        width: double.infinity,
        height: size.height * 0.5,
        child: Center(
          // child: CircularProgressIndicator(),
          child: Container(),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: size.height * 0.5,
      //color: Colors.red,
      child: Swiper(
        itemCount: photos.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.6,
        itemBuilder: (_, int index) {
          final photo = photos[index];
          return GestureDetector(
            onTap: () {},
            child: Hero(
              tag: index,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: Image.file(File(photo.path)).image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
