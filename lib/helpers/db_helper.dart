import 'dart:developer';

import 'package:budget_tracker_app/models/category_model.dart';
import 'package:budget_tracker_app/models/spending_model.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static DBHelper dbHelper = DBHelper._();

  Logger logger = Logger();

  Database? db;

  // Category Table Attributes
  String categoryTable = "category";
  String categoryName = "category_name";
  String categoryImage = "category_image";

  // Spending Table Attributes
  String spendingTable = "spending";
  String spendingId = "spending_id";
  String spendingDes = "spending_desc";
  String spendingAmount = "spending_amount";
  String spendingMode = "spending_mode";
  String spendingDate = "spending_date";
  String spendingTime = "spending_time";
  String spendingCategoryId = "spending_category_id";

  // TODO: Create Database
  Future<void> initDB() async {
    String databasePath = await getDatabasesPath();

    String path = "${databasePath}budget.db";
    // TODO: Create Tables
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        String query = '''CREATE TABLE $categoryTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          $categoryName TEXT NOT NULL,
          $categoryImage BLOB NOT NULL
        );''';
        String query2 = '''CREATE TABLE $spendingTable (
          $spendingId INTEGER PRIMARY KEY AUTOINCREMENT,
          $spendingDes TEXT NOT NULL,
          $spendingAmount NUMERIC NOT NULL,
          $spendingMode TEXT NOT NULL,
          $spendingDate TEXT,
          $spendingTime TEXT,
          $spendingCategoryId INTEGER NOT NULL
        );''';

        await db.execute(query).then(
          (value) {
            logger.i("Category table is created successfully...");
          },
        ).onError(
          (error, _) {
            logger.e(
              "Category table is not created...",
              error: error,
            );
          },
        );

        await db.execute(query2).then(
          (value) {
            logger.i("Spending Table is created....");
          },
        ).onError(
          (error, _) {
            logger.e("Spending table is not created...", error: error);
          },
        );
      },
    );
  }

  // TODO: Insert Records
  Future<int?> insertCategory({
    required String name,
    required Uint8List image,
  }) async {
    await initDB();

    // C Language => int a=23;  printf("%d",a);

    // SQL => query Parameter => ?

    String query =
        "INSERT INTO $categoryTable($categoryName, $categoryImage) VALUES(?, ?)";

    List arg = [name, image];

    return await db?.rawInsert(query, arg);
  }

  Future<int?> insertSpending({
    required String desc,
    required num amount,
    required String mode,
    required String date,
    required String time,
    required int categoryId,
  }) async {
    await initDB();

    String query =
        "INSERT INTO $spendingTable ($spendingDes,$spendingAmount,$spendingMode,$spendingDate,$spendingTime,$spendingCategoryId) VALUES(?,?,?,?,?,?);";

    List arg = [desc, amount, mode, date, time, categoryId];

    return await db?.rawInsert(query, arg);
  }

  // TODO: Fetch Records
  Future<List<CategoryModel>> fetchAllCategory() async {
    await initDB();

    String query = "SELECT * FROM $categoryTable;";
    List<Map<String, dynamic>> res = await db?.rawQuery(query) ?? [];

    return res
        .map(
          (e) => CategoryModel.formData(data: e),
        )
        .toList();
  }

  Future<List<SpendingModel>> fetchAllSpending() async {
    await initDB();

    String query = "SELECT * FROM $spendingTable;";

    List<Map<String, dynamic>> res = await db?.rawQuery(query) ?? [];

    return res
        .map(
          (e) => SpendingModel.fromMap(data: e),
        )
        .toList();
  }

  Future<List<CategoryModel>> fetchSingleCategory({required int id}) async {
    await initDB();

    log("ID : $id");

    String query = "SELECT * FROM $categoryTable WHERE id=?";

    List arg = [id];

    List<Map<String, dynamic>> res = await db?.rawQuery(query, arg) ?? [];

    return res
        .map(
          (e) => CategoryModel.formData(data: e),
        )
        .toList();
  }

  Future<List<CategoryModel>> searchCategory({required String search}) async {
    logger.i("SEARCH : $search");
    String query =
        "SELECT * FROM $categoryTable WHERE $categoryName LIKE '%$search%';";

    List<Map<String, dynamic>> res = await db?.rawQuery(query) ?? [];

    logger.i("RESPONSE : $res");

    return res
        .map(
          (e) => CategoryModel.formData(data: e),
        )
        .toList();
  }

  // TODO: Update Record
  Future<int?> updateCategory(
      {required String name, required Uint8List image, required int id}) async {
    await initDB();

    String query =
        "UPDATE $categoryTable SET $categoryName=?, $categoryImage=? WHERE id = $id;";

    List arg = [name, image];

    return await db?.rawUpdate(query, arg);
  }

  // TODO: Delete Record
  Future<int?> deleteCategory({required int id}) async {
    await initDB();

    String query = "DELETE FROM $categoryTable WHERE id=$id;";

    return await db?.rawDelete(query);
  }
}
