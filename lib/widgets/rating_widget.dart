import 'package:datamites/provider/rating_provider_all.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RatingWidget extends StatelessWidget {

  List<bool> rating = [];
  double height = 40;
  double width = 20;
  String type = "";

  RatingWidget({Key? key, required List<bool> rating, required double height, required double width, required String type}) : super(key: key){
    // ignore: prefer_initializing_formals
    this.rating = rating;
    this.height = height;
    this.type = type;
    this.width = width;
  }

  var starIcon = const Icon(
    Icons.star_border_outlined,
  );
  var starFilledIcon = const Icon(
    Icons.star,
    color: Colors.amber,
  );

  @override
  Widget build(BuildContext context) {
    void changeIcon(index, fill) {
      List<bool> newRating = [];
      for (int i = 0; i < rating.length; i++) {
        if (i <= index) {
          newRating.add(true);
        } else {
          newRating.add(false);
        }
      }
      int ratingCount = 0;
      for (int i = 0; i < newRating.length; i++) {
        if (newRating[i]) ratingCount += 1;
      }
      context.read<RatingProviderAll>().changeRatingByType(type, ratingCount);
    }
    return SizedBox(
      height: height,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: rating.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: width,
              child: IconButton(
                  onPressed: () {
                    changeIcon(index, false);
                  },
                  icon: rating[index] ? starFilledIcon : starIcon),
            );
          }),
    );
  }
}
