import 'dart:developer';

import 'package:budget_tracker_app/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../helpers/db_helper.dart';

class CategoryController extends GetxController {
  int? categoryIndex;
  Future<List<CategoryModel>>? allCatetories;

  void getCategoryImageIndex({required int index}) {
    categoryIndex = index;

    update();
  }

  void assignDefaultIndex() {
    categoryIndex = null;

    update();
  }

  // INSERT CATEGORY RECORD
  Future<void> addCategory({
    required String name,
    required Uint8List image,
  }) async {
    int? res = await DBHelper.dbHelper.insertCategory(name: name, image: image);

    if (res != null) {
      Get.snackbar(
        "INSERTED",
        "$name is inserted... $res",
        backgroundColor: Colors.green.shade300,
      );
    } else {
      Get.snackbar(
        "Failed",
        "$name insertion is failed... $res",
        backgroundColor: Colors.red.shade300,
      );
    }
  }

  // FETCH CATEGORY RECORDS
  void getAllCategory() {
    allCatetories = DBHelper.dbHelper.fetchAllCategory();
  }

  // LIVE SEARCH CATEGORY RECORD
  void getSearchCategory({required String search}) {
    log("Search Method is called...");
    allCatetories = DBHelper.dbHelper.searchCategory(search: search);
    log("Search Method is end...");
    update();
  }

  // DELETE CATEGORY RECORD
  Future<void> deleteCategory({required int id}) async {
    int? res = await DBHelper.dbHelper.deleteCategory(id: id);

    if (res != null) {
      this.getAllCategory();
      Get.snackbar("DELETED", "Category is deleted...");
    } else {
      Get.snackbar(
        "DELETION",
        "Category deletion failed ...",
        backgroundColor: Colors.red.shade300,
      );
    }

    update();
  }

  // UPDATE CATEGORY RECORD
  Future<void> updateCategory({
    required String name,
    required Uint8List image,
    required int id,
  }) async {
    int? res = await DBHelper.dbHelper
        .updateCategory(id: id, name: name, image: image);

    if (res != null) {
      this.getAllCategory();
      Get.snackbar("Updated", "Category is updated...");
    } else {
      Get.snackbar(
        "DELETION",
        "Category updation failed ...",
        backgroundColor: Colors.red.shade300,
      );
    }

    update();
  }
}
