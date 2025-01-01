import 'dart:developer';

import 'package:budget_tracker_app/controller/category_controller.dart';
import 'package:budget_tracker_app/models/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'category_component.dart';

class AllCategoryComponent extends StatelessWidget {
  const AllCategoryComponent({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryController controller = Get.put(CategoryController());

    controller.getAllCategory();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            onChanged: (val) async {
              log(val);
              controller.getSearchCategory(search: val);
            },
            decoration: const InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(
                CupertinoIcons.search,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: GetBuilder<CategoryController>(builder: (context) {
              return FutureBuilder(
                future: controller.allCatetories,
                builder: (context, snapShot) {
                  if (snapShot.hasError) {
                    return Center(
                      child: Text("ERROR : ${snapShot.error}"),
                    );
                  } else if (snapShot.hasData) {
                    List<CategoryModel> categoriesData = snapShot.data ?? [];

                    return (categoriesData.isNotEmpty)
                        ? ListView.builder(
                            itemCount: categoriesData.length,
                            itemBuilder: (context, index) => Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage:
                                      MemoryImage(categoriesData[index].image),
                                ),
                                title: Text(categoriesData[index].name),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        categoryController.text =
                                            categoriesData[index].name;

                                        Get.bottomSheet(
                                          Container(
                                            height: double.infinity,
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(16),
                                                topRight: Radius.circular(16),
                                              ),
                                            ),
                                            child: Form(
                                              key: formKey,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Update Category",
                                                    style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        categoryController,
                                                    validator: (val) =>
                                                        val!.isEmpty
                                                            ? "Required..."
                                                            : null,
                                                    decoration: InputDecoration(
                                                      labelText: "Category",
                                                      hintText:
                                                          "Enter category...",
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        borderSide:
                                                            const BorderSide(
                                                          color:
                                                              Colors.deepPurple,
                                                        ),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        borderSide:
                                                            const BorderSide(
                                                          color:
                                                              Colors.redAccent,
                                                        ),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        borderSide:
                                                            const BorderSide(
                                                          color:
                                                              Colors.redAccent,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  Expanded(
                                                    child: GridView.builder(
                                                      gridDelegate:
                                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 5,
                                                        mainAxisSpacing: 5,
                                                        crossAxisSpacing: 5,
                                                      ),
                                                      itemCount:
                                                          categoryImages.length,
                                                      itemBuilder:
                                                          (context, index) =>
                                                              GestureDetector(
                                                        onTap: () {
                                                          controller
                                                              .getCategoryImageIndex(
                                                                  index: index);
                                                        },
                                                        child: GetBuilder<
                                                            CategoryController>(
                                                          builder: (ctx) {
                                                            return Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                // color: Colors.grey,
                                                                border:
                                                                    Border.all(
                                                                  color: (index ==
                                                                          controller
                                                                              .categoryIndex)
                                                                      ? Colors
                                                                          .grey
                                                                      : Colors
                                                                          .transparent,
                                                                ),
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      AssetImage(
                                                                    categoryImages[
                                                                        index],
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: FloatingActionButton
                                                        .extended(
                                                      onPressed: () async {
                                                        if (formKey
                                                                .currentState!
                                                                .validate() &&
                                                            controller
                                                                    .categoryIndex !=
                                                                null) {
                                                          String name =
                                                              categoryController
                                                                  .text;
                                                          // ASSETIMAGE => BYTEDATA => UINT8LIST
                                                          String assetPath =
                                                              categoryImages[
                                                                  controller
                                                                      .categoryIndex!];

                                                          ByteData byteData =
                                                              await rootBundle
                                                                  .load(
                                                                      assetPath);

                                                          Uint8List image =
                                                              byteData.buffer
                                                                  .asUint8List();

                                                          await controller
                                                              .updateCategory(
                                                            name: name,
                                                            image: image,
                                                            id: categoriesData[
                                                                    index]
                                                                .id,
                                                          );
                                                        }

                                                        Navigator.pop(context);
                                                        categoryController
                                                            .clear();
                                                      },
                                                      icon: const Icon(
                                                          Icons.edit),
                                                      label:
                                                          const Text("Update"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        size: 20,
                                        color: Colors.green.shade300,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Get.defaultDialog(
                                          title: "DELETE",
                                          middleText:
                                              "Are you sure ${categoriesData[index].name} delete ??",
                                          confirm: ElevatedButton(
                                            onPressed: () async {
                                              await controller.deleteCategory(
                                                  id: categoriesData[index].id);

                                              Navigator.pop(context);
                                            },
                                            child: const Text("Yes"),
                                          ),
                                          cancel: ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Text("No"),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        size: 20,
                                        color: Colors.red.shade300,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const Center(
                            child: Text("No Category Available"),
                          );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
