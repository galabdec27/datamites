import 'package:flutter/material.dart';

class CardCoursePreviewShimmer extends StatelessWidget {
  const CardCoursePreviewShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.fromLTRB(16, 32, 0, 8),
              width: 150.0,
              height: 24.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: const Color(0x45b6b6b6))),
          Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              height: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: const Color(0x45b6b6b6))),
          Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              height: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: const Color(0x45b6b6b6))),
          Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              height: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: const Color(0x45b6b6b6))),
          Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              height: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: const Color(0x45b6b6b6))),
          Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              height: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: const Color(0x45b6b6b6))),
          Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              height: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: const Color(0x45b6b6b6))),
        ],
      ),
    );
  }
}
