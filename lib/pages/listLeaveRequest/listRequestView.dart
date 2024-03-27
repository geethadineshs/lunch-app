import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../const/Appcolor.dart';
import 'listRequestController.dart';

class LeaveRequestListView extends StatelessWidget {
  LeaveRequestListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LeaveRequestListController>(
      init: LeaveRequestListController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("All Leave Requests",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1,
              )),
          backgroundColor: AppColors.appBar,
          foregroundColor: AppColors.white,
        ),
        backgroundColor: AppColors.backgroundColor,
        body: Column(
          // Wrap the Row with a Column
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Month: ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 45),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.black),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedStatus.value,
                          onChanged: (String? newValue) {
                            _handleDropDownValueChange(controller, newValue);
                          },
                          items: <String>[
                            'All',
                            'Approved',
                            'Rejected',
                            'Submitted'
                          ]
                              .map<DropdownMenuItem<String>>(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Row(
                                    children: [
                                      if (value ==
                                          controller.selectedStatus.value)
                                        Icon(
                                          Icons.check,
                                          color: AppColors.appBar,
                                        ),
                                      SizedBox(width: 5),
                                      Text(
                                        value,
                                        style: TextStyle(
                                          color: value == 'Rejected'
                                              ? Colors.black
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() => _buildListView(controller)),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDropDownValueChange(
      LeaveRequestListController controller, String? newValue) {
    // Update the selected status in the controller
    controller.selectedStatus.value = newValue!;
    // Trigger the rebuild of the widget
    Get.forceAppUpdate();
    // Update the list based on the selected status
    controller.filterByStatus(newValue);
  }

  Widget _buildListView(LeaveRequestListController controller) {
    if (controller.filteredData.isEmpty) {
      return Center(
        child: Text("No matching data found"),
      );
    }

    return ListView.builder(
      itemCount: controller.filteredData.length,
      itemBuilder: (BuildContext context, int index) {
        final leaveRequest = controller.filteredData[index];
        final startDate = leaveRequest["start_date"].toString().split(" ")[0];
        Color statusColor;
        final borderColor = AppColors.appBar;
        switch (leaveRequest["status"]) {
          case "Approved":
            statusColor = AppColors.appBar;
            break;
          case "Rejected":
            statusColor = AppColors.red;
            break;
          case "Submitted":
            statusColor = Colors.grey;
            break;
          default:
            statusColor = Colors.yellow;
            break;
        }
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Date: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(startDate),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        margin: EdgeInsets.only(right: 10.0),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          leaveRequest["status"] ?? '',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                  child: Text(
                    "Name: ${leaveRequest["user_name"] ?? ''}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                  child: Text(
                    "Reason",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                  child: SingleChildScrollView(
                    child: Text(
                      leaveRequest["leave_reasons"] ?? '',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }
}
