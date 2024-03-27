import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import '../../const/Appcolor.dart';
import '../requests/requestview.dart';
import 'lunchCountAdminController.dart';

class LunchCountingAdminView extends GetView<LunchCountingAdminController> {
  const LunchCountingAdminView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String currentMonth = DateFormat('MMMM').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBar,
        foregroundColor: AppColors.white,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Lunch Count - ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 1,
                ),
              ),
            ),
            Text(
              currentMonth,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.only(top: 20, bottom: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, bottom: 10, left: 20, right: 20),
              child: SizedBox(
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    filled: true,
                    fillColor: AppColors.white,
                    hintStyle: TextStyle(color: AppColors.stroke),
                    contentPadding: EdgeInsets.zero,
                    // Hint text color
                    prefixIcon: Icon(Icons.search, color: AppColors.stroke),
                    // Search icon color
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: AppColors.stroke),
                      // Border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: AppColors.appBar),
                      // Border color
                    ),
                  ),
                  onChanged: controller.search,
                  // Call the search method on change
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () {
                  final List<Map<String, dynamic>> displayedData =
                      controller.filteredData.isEmpty &&
                              controller.searchQuery.isNotEmpty
                          ? []
                          : controller.filteredData.isEmpty
                              ? controller.lunchData
                              : controller.filteredData;

                  if (displayedData.isEmpty) {
                    return Center(
                      child: Text("No data found"),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: displayedData.length,
                      itemBuilder: (BuildContext context, int index) {
                        final lunchItem = displayedData[index];
                        int days = lunchItem["days"] ?? 0;
                        int amount = days * 10;

                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: AppColors.appBar),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      lunchItem["user_name"] ?? '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 30.0),
                                    child: Text(
                                      'Amount: ₹ $amount',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text("Days: $days"),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
