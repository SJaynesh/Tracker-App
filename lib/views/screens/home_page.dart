import 'package:budget_tracker_app/components/all_category_component.dart';
import 'package:budget_tracker_app/components/all_spending_component.dart';
import 'package:budget_tracker_app/components/category_component.dart';
import 'package:budget_tracker_app/components/spending_component.dart';
import 'package:budget_tracker_app/controller/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    NavigationController controller = Get.put(NavigationController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Budget Tracker"),
      ),
      body: PageView(
        controller: controller.pageController,
        onPageChanged: (index) {
          controller.getIndex(index: index);
        },
        children: const [
          AllSpendingComponent(),
          SpendingComponent(),
          AllCategoryComponent(),
          CategoryComponent()
        ],
      ),
      bottomNavigationBar: Obx(() {
        return NavigationBar(
          selectedIndex: controller.bottomNavigationIndex.value,
          onDestinationSelected: (index) {
            controller.getIndex(index: index);
            controller.changePageView(index: index);
            logger.i("INDEX : $index");
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.price_check),
              label: "All Spending",
            ),
            NavigationDestination(
              icon: Icon(Icons.attach_money),
              label: "Spending",
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long),
              label: "All Category",
            ),
            NavigationDestination(
              icon: Icon(Icons.category),
              label: "Category",
            ),
          ],
        );
      }),
    );
  }
}
