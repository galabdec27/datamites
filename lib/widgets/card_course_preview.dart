import 'package:datamites/model/course/course_list_model.dart';
import 'package:datamites/pages/sub_page/course/course_detail_general.dart';
import 'package:flutter/material.dart';

class CardCoursePreview extends StatelessWidget {
  final CourseListModel course;

  const CardCoursePreview({required this.course});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CourseDetailgeneral(
                     course.course_name,
                    course.coursePriceModel.countryModel.country_id,
                    course.course_id,
                    course.course_mob_img_link)));
      },
      child: Container(
        height: 100,
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0)),
                    image: DecorationImage(
                        image: NetworkImage(course.course_mob_img_link != ""
                            ? course.course_mob_img_link
                            : "https://yt3.ggpht.com/ytc/AKedOLQyLbr5JiBv-sec0HMpR5lJPsd5LT40OIxyieMA=s900-c-k-c0x00ffffff-no-rj"),
                        fit: BoxFit.fill)),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                    color: Color(0xfff6f6f6),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(course.course_name),
                    Row(
                      children: [
                        Text(
                          "${course.coursePriceModel.countryModel.currency_symbol
                                  .toUpperCase()}: ${course.coursePriceModel.classroom_dprice}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          course.coursePriceModel.classroom_bprice,
                          style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Center(
                            child: Text(
                              course.course_shortname,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
