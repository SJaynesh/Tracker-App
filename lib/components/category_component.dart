import 'package:budget_tracker_app/controller/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

List<String> categoryImages = [
  "assets/images/bill.png",
  "assets/images/cash.png",
  "assets/images/communication.png",
  "assets/images/deposit.png",
  "assets/images/food.png",
  "assets/images/gift.png",
  "assets/images/health.png",
  "assets/images/movie.png",
  "assets/images/rupee.png",
  "assets/images/salary.png",
  "assets/images/shopping.png",
  "assets/images/transport.png",
  "assets/images/wallet.png",
  "assets/images/withdraw.png",
  "assets/images/other.png",
];

GlobalKey<FormState> formKey = GlobalKey<FormState>();
TextEditingController categoryController = TextEditingController();

class CategoryComponent extends StatelessWidget {
  const CategoryComponent({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryController controller = Get.put(CategoryController());
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choice Category !!",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            TextFormField(
              controller: categoryController,
              validator: (val) => val!.isEmpty ? "Required..." : null,
              decoration: InputDecoration(
                labelText: "Category",
                hintText: "Enter category...",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.deepPurple,
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
              height: 25,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                ),
                itemCount: categoryImages.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    controller.getCategoryImageIndex(index: index);
                  },
                  child: GetBuilder<CategoryController>(
                    builder: (ctx) {
                      return Container(
                        decoration: BoxDecoration(
                          // color: Colors.grey,
                          border: Border.all(
                            color: (index == controller.categoryIndex)
                                ? Colors.grey
                                : Colors.transparent,
                          ),
                          image: DecorationImage(
                            image: AssetImage(
                              categoryImages[index],
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  onPressed: () async {
                    if (formKey.currentState!.validate() &&
                        controller.categoryIndex != null) {
                      String name = categoryController.text;

                      String imagePath =
                          categoryImages[controller.categoryIndex!];

                      // assetImage => ByteData => Uint8List

                      ByteData byteData = await rootBundle.load(imagePath);
                      Uint8List image = byteData.buffer.asUint8List();

                      await controller
                          .addCategory(name: name, image: image)
                          .then(
                        (value) {
                          categoryController.clear();
                          controller.assignDefaultIndex();
                        },
                      );
                    } else {
                      Get.snackbar(
                        "Required",
                        "All filed is required...",
                        backgroundColor: Colors.redAccent,
                      );
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Category"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
