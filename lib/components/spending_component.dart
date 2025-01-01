import 'dart:developer';

import 'package:budget_tracker_app/controller/spending_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

TextEditingController descController = TextEditingController();
TextEditingController amountController = TextEditingController();

class SpendingComponent extends StatelessWidget {
  const SpendingComponent({super.key});

  @override
  Widget build(BuildContext ctx) {
    SpendingController controller = Get.put(SpendingController());
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GetBuilder<SpendingController>(builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      lastDate: DateTime(2025),
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
          ],
        );
      }),
    );
  }
}
