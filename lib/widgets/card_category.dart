import 'package:datamites/model/category_model.dart';
import 'package:datamites/pages/sub_page/course/category_course_list_page.dart';
import 'package:datamites/pages/sub_page/course/top_course_list_page.dart';
import 'package:flutter/material.dart';

class CardCategory extends StatelessWidget {
  final CategoryModel category;
  const CardCategory({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      elevation: 0,
      onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CategoryCourseListPage(title: category.course_name, categoryId: category.course_id.toString(),)),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
        width: 200.0,
        height: 120.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(image: NetworkImage(category.course_mob_img_link), fit: BoxFit.cover,)
        ),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            color: const Color(0xB8000000),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(category.course_name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800), textAlign: TextAlign.center,),
            ),
          ),
        ),
      ),
    );
  }
}
