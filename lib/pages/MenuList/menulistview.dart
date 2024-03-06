import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/const/Appcolor.dart';
import 'package:test_app/const/stringconst.dart';
import 'package:test_app/pages/MenuList/menulistcontroller.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:test_app/pages/home/homecontroller.dart';

class MenuListView extends GetView<MenuListController> {
  MenuListView({Key? key}) : super(key: key) {
    controller.init();
  }
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _appbar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 229, 240, 245),
              const Color.fromARGB(255, 200, 225, 244),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else if (controller.groupedEntries.isEmpty) {
                return Center(child: Text('No data available'));
              } else {
                return DataTable2(
                  columnSpacing: 16,
                  dataRowHeight: 80.0,
                  columns: [
                    DataColumn2(
                      label: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 9, 8, 8),
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      size: ColumnSize.L,
                    ),
                    DataColumn2(
                      label: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Lunch',
                              // overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 10, 10, 10),
                                fontSize: 15.0,
                              ),
                            ),
                            Text(
                              'Options',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 10, 10, 10),
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      size: ColumnSize.L,
                    ),
                    DataColumn2(
                      label: Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Text(
                              'Actions',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 11, 11, 11),
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      size: ColumnSize.L,
                    ),
                  ],
                  rows: controller.groupedEntries
                      .asMap()
                      .map(
                        (index, entry) => MapEntry(
                          index,
                          DataRow(
                            cells: [
                              DataCell(
                                Container(
                                  width: double.infinity,
                                  child: Center(
                                    child: Text(
                                      entry['date'],
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: _isDateInPast(entry['date'])
                                            ? Colors.grey
                                            : const Color.fromARGB(
                                                255, 14, 14, 14),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  width: double.infinity,
                                  child: Center(
                                    child: Text(
                                      entry['options'].join(', '),
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: _isDateInPast(entry['date'])
                                            ? Colors.grey
                                            : const Color.fromARGB(
                                                255, 7, 7, 7),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    Expanded(
                                      child: Hero(
                                        tag: 'deleteButton_$index',
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: _isDateInPast(entry['date'])
                                                ? Colors.grey
                                                : Colors.red,
                                          ),
                                          onPressed: _isDateInPast(
                                                  entry['date'])
                                              ? null
                                              : () async {
                                                  bool confirmDelete =
                                                      await showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'Confirm Delete'),
                                                        content: Text(
                                                            'Are you sure you want to delete this item?'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(
                                                                      false); // Cancel the delete
                                                            },
                                                            child:
                                                                Text('Cancel'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(
                                                                      true); // Confirm the delete
                                                            },
                                                            child: Text('OK'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  if (confirmDelete == true) {
                                                    try {
                                                      // Show loader while deletion is in progress
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        },
                                                      );

                                                      var id = entry['id'];
                                                      var date = entry['date'];
                                                      await controller
                                                          .deleteEntries(
                                                              id, date);

                                                      // Hide loader once deletion is complete
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();

                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            'Deleted successfully!',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16.0,
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  34,
                                                                  2,
                                                                  74),
                                                        ),
                                                      );
                                                    } catch (e) {
                                                      // Handle errors
                                                      print('Error: $e');
                                                    }
                                                  }
                                                },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .values
                      .toList(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  bool _isDateInPast(String date) {
    // Add your logic to check if the date is in the past (yesterday or earlier)
    DateTime currentDate = DateTime.now();
    DateTime entryDate =
        DateTime.parse(date); // Assuming date is in ISO 8601 format

    // Check if the entry date is before or equal to today
    return entryDate.isBefore(currentDate.subtract(Duration(days: 1)));
  }

  _appbar() {
    return AppBar(
      title: Text(
        "This Month",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1),
      ),
      centerTitle: true, // Center-align the title
      backgroundColor: AppColors.appBar,
      foregroundColor: AppColors.white,

      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () async {
          Get.offAllNamed(Appstring.home);
        },
      ),
    );
  }
}
