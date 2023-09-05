import 'package:flutter/material.dart';

class CardCategoryShimmer extends StatelessWidget {
  const CardCategoryShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
            width: 150.0,
            height: 80.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: const Color(0x45b6b6b6)))
      ],
    );
  }
}
