import 'package:flutter/material.dart';

class CarouselShimmer extends StatelessWidget {
  const CarouselShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        width: width,
        height: width * 7 / 16,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: const Color(0x45b6b6b6)));
  }
}
