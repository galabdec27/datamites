import 'dart:convert';

import 'package:datamites/model/category_model.dart';
import 'package:datamites/widgets/card_category.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final List<CategoryModel> categoryList;

  CategoryPage({required this.categoryList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
          child: Text(
            "Categories",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
          height: 120,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: categoryList
                .map((cat) => CardCategory(
                      category: cat,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
