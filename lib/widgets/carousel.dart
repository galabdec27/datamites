import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:datamites/helper/notification_navigation_helper.dart';
import 'package:datamites/model/carousel_model.dart';
import 'package:datamites/model/carousel_response_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Carousel extends StatelessWidget {
  final List<CarouselModel> carouselList;

  const Carousel({required this.carouselList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CarouselSlider(
        options: CarouselOptions(
            autoPlayInterval: const Duration(seconds: 10),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            aspectRatio: 16 / 7,
            viewportFraction: 1),
        items: carouselList.map((carousel) {
          return Builder(
            builder: (BuildContext context) {
              return MaterialButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  NotificationNavigationHelper navhelper =
                      NotificationNavigationHelper();
                  navhelper.action = carousel.action;
                  if (carousel.sub_action != null) {
                    navhelper.sub_action = carousel.sub_action!;
                  }
                  if (carousel.external_url != null) {
                    navhelper.external_url = carousel.external_url!;
                  }
                  if (carousel.external_action != null) {
                    navhelper.external_action = carousel.external_action!;
                  }
                  if (carousel.image != null) {
                    navhelper.image = carousel.image;
                  }
                  navhelper.context = context;
                  navhelper.processNotification(false);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(carousel.image),
                          fit: BoxFit.fill)),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
