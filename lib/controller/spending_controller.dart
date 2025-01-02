import 'package:budget_tracker_app/helpers/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/spending_model.dart';

class SpendingController extends GetxController {
  String? spendingMode;
  DateTime? dateTime;
  TimeOfDay? timeOfDay;
  int? categoryId;
  int? spendingIndex;

  // All Spending Records
  Future<List<SpendingModel>>? allSpending;

  // // Default Constructor
  // SpendingController() {
  //   fetchSpendingRecords();
  // }

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

  void getSpendingIndex({required int index, required int id}) {
    spendingIndex = index;
    categoryId = id;
    update();
  }

  void clearValue() {
    spendingMode = dateTime = timeOfDay = categoryId = spendingIndex = null;

    update();
  }

  // Insert Spending Record
  Future<void> addSpendingData({required SpendingModel model}) async {
    int? res = await DBHelper.dbHelper.insertSpending(
      desc: model.desc,
      amount: model.amount,
      mode: model.mode,
      date: model.date,
      time: model.time,
      categoryId: model.categoryId,
    );

    if (res != null) {
      Get.snackbar(
        "Inserted",
        "Spending is Inserted...",
        colorText: Colors.white,
        backgroundColor: Colors.green.shade300,
      );
    } else {
      Get.snackbar(
        "Failed",
        "Spending is insertion failed...",
        colorText: Colors.white,
        backgroundColor: Colors.red.shade300,
      );
    }
  }

  // fetch All Spending Records
  void fetchSpendingRecords() {
    allSpending = DBHelper.dbHelper.fetchAllSpending();
  }
}
