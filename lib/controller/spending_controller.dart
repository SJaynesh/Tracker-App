import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpendingController extends GetxController {
  String? spendingMode;
  DateTime? dateTime;
  TimeOfDay? timeOfDay;

  void getSpendingMode({required String mode}) {
    spendingMode = mode;

    update();
  }

  void getSpendingDate({required DateTime? date}) {
    dateTime = date;

    update();
  }

  void getSpendingTime({required TimeOfDay? time}) {
    timeOfDay = time;

    update();
  }
}
