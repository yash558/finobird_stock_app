// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../../custom/custom_checkbox.dart';
import '../../custom/custom_elevated_button.dart';
import '../../repository/feed_repo.dart';
import '../../constants/styles.dart';

mixin FilterMixin {
  void filterTheFeeds(
    BuildContext context,
    FeedRepo controller,
  ) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: Text(
                        "Filter Feeds",
                        style: Styles.semiBold,
                      ),
                      trailing: const Icon(LineIcons.filter),
                    ),
                    ListTile(
                      title: Text(
                        "Sources",
                        style: Styles.semiBold.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      subtitle: ValueListenableBuilder<List<FilterOption>>(
                        valueListenable: controller.filterNode,
                        builder: (context, option, child) => Row(
                          children: [
                            CustomCheckbox(
                              title: 'News',
                              value: option.contains(FilterOption.news),
                              onTap: () {
                                if (option.contains(FilterOption.news)) {
                                  controller.filterNode.value
                                      .remove(FilterOption.news);
                                } else {
                                  controller.filterNode.value
                                      .add(FilterOption.news);
                                }
                                controller.filterNode.notifyListeners();
                              },
                            ),
                            CustomCheckbox(
                              title: 'YouTube',
                              value: option.contains(FilterOption.youtube),
                              onTap: () {
                                if (option.contains(FilterOption.youtube)) {
                                  controller.filterNode.value
                                      .remove(FilterOption.youtube);
                                } else {
                                  controller.filterNode.value
                                      .add(FilterOption.youtube);
                                }
                                controller.filterNode.notifyListeners();
                              },
                            ),
                            CustomCheckbox(
                              title: 'Twitter',
                              value: option.contains(FilterOption.twitter),
                              onTap: () {
                                if (option.contains(FilterOption.twitter)) {
                                  controller.filterNode.value
                                      .remove(FilterOption.twitter);
                                } else {
                                  controller.filterNode.value
                                      .add(FilterOption.twitter);
                                }
                                controller.filterNode.notifyListeners();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Obx(
                      () => ListTile(
                        onTap: () async {
                          await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          ).then((value) {
                            if (value != null) {
                              controller.startDate.value =
                                  "${value.start.year}-${value.start.month}-${value.start.day}";
                              controller.endDate.value =
                                  "${value.end.year}-${value.end.month}-${value.end.day}";
                            }
                          });
                        },
                        title: Text(
                          "Time",
                          style: Styles.semiBold.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            controller.startDate.value.isEmpty
                                ? Text(
                                    "Select Date Range",
                                    style: Styles.text,
                                  )
                                : Visibility(
                                    visible:
                                        controller.startDate.value.isNotEmpty,
                                    child: Text(
                                      "Start Date: ${controller.startDate.value}",
                                      style: Styles.text,
                                    ),
                                  ),
                            Visibility(
                              visible: controller.endDate.value.isNotEmpty,
                              child: Text(
                                "End Date: ${controller.endDate.value}",
                                style: Styles.text,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CustomElevatedButton(
                onPressed: () {
                  Get.back();
                  controller.filterFeeds(more: false);
                },
                child: Center(
                  child: Text(
                    "Apply Filters",
                    style: Styles.text.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              CustomElevatedButton(
                color: Colors.red,
                onPressed: () {
                  Get.back();
                  controller.resetFilter();
                },
                child: Center(
                  child: Text(
                    "Reset Filters",
                    style: Styles.text.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
