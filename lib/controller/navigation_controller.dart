import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  RxInt bottomNavigationIndex = 0.obs;
  PageController pageController = PageController(
    initialPage: 0,
  );

  void getIndex({required int index}) {
    bottomNavigationIndex.value = index;
  }

  void changePageView({required int index}) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }
}
