import 'dart:developer';

import 'package:budget_tracker_app/controller/spending_controller.dart';
import 'package:budget_tracker_app/helpers/db_helper.dart';
import 'package:budget_tracker_app/models/category_model.dart';
import 'package:budget_tracker_app/models/spending_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

TextEditingController descController = TextEditingController();
TextEditingController amountController = TextEditingController();
GlobalKey<FormState> spendingKey = GlobalKey<FormState>();

class SpendingComponent extends StatelessWidget {
  const SpendingComponent({super.key});

  @override
  Widget build(BuildContext ctx) {
    SpendingController controller = Get.put(SpendingController());
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GetBuilder<SpendingController>(builder: (context) {
        return Form(
          key: spendingKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                maxLines: 2,
                controller: descController,
                validator: (val) =>
                    val!.isEmpty ? "Required spending description.." : null,
                decoration: InputDecoration(
                  labelText: "Desc",
                  hintText: "Enter spending description",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val!.isEmpty ? "Required spending amount.." : null,
                decoration: InputDecoration(
                  labelText: "Amount",
                  hintText: "Enter spending amount",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    "MODE : ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  GetBuilder<SpendingController>(builder: (context) {
                    return DropdownButton(
                      value: controller.spendingMode,
                      hint: const Text("Select Mode"),
                      items: const [
                        DropdownMenuItem(
                          value: "online",
                          child: Text("Online"),
                        ),
                        DropdownMenuItem(
                          value: "offline",
                          child: Text("Offline"),
                        ),
                      ],
                      onChanged: (value) {
                        controller.getSpendingMode(mode: value!);
                        log("MODE : $value");
                      },
                    );
                  }),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    "DATE : ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  IconButton(
                    onPressed: () async {
                      DateTime? date = await showDatePicker(
                        context: ctx,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2026),
                      );

                      controller.getSpendingDate(date: date);
                    },
                    icon: const Icon(Icons.date_range),
                  ),
                  if (controller.dateTime != null)
                    Text(
                        "${controller.dateTime!.day}/${controller.dateTime!.month}/${controller.dateTime!.year}")
                  else
                    const Text("DD/MM/YYYY"),
                ],
              ),
              Row(
                children: [
                  const Text(
                    "TIME : ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  IconButton(
                    onPressed: () async {
                      TimeOfDay? time = await showTimePicker(
                        context: ctx,
                        initialTime: TimeOfDay.now(),
                      );

                      controller.getSpendingTime(time: time);
                    },
                    icon: const Icon(CupertinoIcons.time_solid),
                  ),
                  if (controller.timeOfDay != null)
                    Text(
                        "${controller.timeOfDay!.hour % 12}:${controller.timeOfDay!.minute}  ${controller.timeOfDay!.period.toString().split('.')[1].toUpperCase()}")
                  else
                    const Text("HH:MM")
                ],
              ),
              Expanded(
                child: FutureBuilder(
                  future: DBHelper.dbHelper.fetchAllCategory(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("ERROR : ${snapshot.error}"),
                      );
                    } else if (snapshot.hasData) {
                      List<CategoryModel> category = snapshot.data ?? [];

                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: category.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            controller.getSpendingIndex(
                                index: index, id: category[index].id);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: (controller.spendingIndex == index)
                                    ? Colors.grey
                                    : Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: MemoryImage(category[index].image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  if (spendingKey.currentState!.validate() &&
                      controller.spendingMode != null &&
                      controller.dateTime != null &&
                      controller.timeOfDay != null &&
                      controller.spendingIndex != null) {
                    SpendingModel model = SpendingModel(
                      id: 0,
                      desc: descController.text,
                      amount: num.parse(amountController.text),
                      mode: controller.spendingMode!,
                      date:
                          "${controller.dateTime?.day}/${controller.dateTime?.month}/${controller.dateTime?.year}",
                      time:
                          "${controller.timeOfDay!.hour % 12}:${controller.timeOfDay!.minute}  ${controller.timeOfDay!.period.toString().split('.')[1].toUpperCase()}",
                      categoryId: controller.categoryId!,
                    );

                    controller.addSpendingData(model: model);

                    descController.clear();
                    amountController.clear();
                    controller.clearValue();
                  } else {
                    Get.snackbar(
                      "Required",
                      "all spending data are required...",
                      backgroundColor: Colors.red.shade300,
                    );
                  }
                },
                icon: const Icon(Icons.money),
                label: const Text("Add Spending"),
              )
            ],
          ),
        );
      }),
    );
  }
}
