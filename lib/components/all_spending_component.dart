import 'dart:developer';

import 'package:budget_tracker_app/controller/spending_controller.dart';
import 'package:budget_tracker_app/helpers/db_helper.dart';
import 'package:budget_tracker_app/models/category_model.dart';
import 'package:budget_tracker_app/models/spending_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllSpendingComponent extends StatelessWidget {
  const AllSpendingComponent({super.key});

  @override
  Widget build(BuildContext context) {
    SpendingController controller = Get.put(SpendingController());
    controller.fetchSpendingRecords();
    return GetBuilder<SpendingController>(builder: (context) {
      return FutureBuilder(
        future: controller.allSpending,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("ERROR : ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            List<SpendingModel> spendingData = snapshot.data ?? [];

            return ListView.builder(
              itemCount: spendingData.length,
              itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xff4c4c4c),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spendingData[index].desc,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "₹ ${spendingData[index].amount.toString()}/-",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text(
                          "DATE : ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          spendingData[index].date,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          "TIME : ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          spendingData[index].time,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        FutureBuilder(
                          future: DBHelper.dbHelper.fetchSingleCategory(
                            id: spendingData[index].categoryId,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<CategoryModel> data = snapshot.data ?? [];
                              log("Length : ${data.length}");
                              return (data.isNotEmpty)
                                  ? Image.memory(
                                      data[0].image,
                                      height: 50,
                                    )
                                  : Container();
                            }
                            return Container();
                          },
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        ActionChip(
                          color: WidgetStateProperty.all(
                            (spendingData[index].mode == 'online')
                                ? Colors.green.withOpacity(0.8)
                                : Colors.red.withOpacity(0.8),
                          ),
                          label: Text(
                            spendingData[index].mode,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              // fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    });
  }
}
