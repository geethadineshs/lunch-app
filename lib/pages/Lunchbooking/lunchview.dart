import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:test_app/const/Appcolor.dart';
import 'package:test_app/pages/MenuList/menulistcontroller.dart';
// import 'package:test_app/services/notifi_service.dart';
import '../../const/stringconst.dart';
import 'lunchcontroller.dart';

class LunchView extends GetView<LunchController> {
  List<DateTime> bookedDates = [];

  // final NotificationService notificationService = NotificationService();
  LunchView({Key? key}) : super(key: key) {
    controller.init();
  }
// DateTime? selectedStartDate;
// DateTime? selectedEndDate;
  // String dropdownvalue = 'Meals with One Chapati';

  // // List of items in our dropdown menu
  // var items = [
  //   "Meals with One Chapati",
  //   'Chapathi only',
  // ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: _appbar(),
          body: !controller.isbooked.value
              ? _body(context)
              : _bookedpage(context),
          floatingActionButton: !controller.isbooked.value
              ? floatingbutton(context)
              : _cancelfoodfloattingbutton(),
        ));
  }

  _appbar() {
    return AppBar(
      title: Text("Book Lunch"),
      backgroundColor: Color.fromARGB(255, 34, 2, 74),
      foregroundColor: AppColors.white,
      actions: [
        IconButton(
            color: AppColors.white,
            onPressed: () {
              Get.offNamed(Appstring.home);
            },
            icon: Icon(Icons.home))
      ],
    );
  }

  _body(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _mainmanu(context),
          _dropdown(),
          _mainmanu1(context),
          _dropdown1(),
          Padding(padding: const EdgeInsets.all(20.0)),

          SfDateRangePicker(
            selectionMode: DateRangePickerSelectionMode.range,
            selectableDayPredicate: (DateTime date) {
              // Allow selection of all dates except Saturdays and Sundays
              return date.weekday != DateTime.saturday &&
                  date.weekday != DateTime.sunday;
            },
            minDate: DateTime.now(),
            initialSelectedDate: null,
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              selectedDates.clear(); // Clear the list before adding new dates
              DateTime now = DateTime.now();
              int selectedDays =
                  args.value.endDate.difference(args.value.startDate).inDays +
                      1;

              if (selectedDays > 16) {
                // Show a Snackbar if more than 15 days are selected
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please choose only 16 days.'),
                    backgroundColor: const Color.fromARGB(255, 34, 2, 74),
                  ),
                );

                // Reset the selection to the last 15 days
                args.value.startDate =
                    args.value.endDate.subtract(Duration(days: 15));
              }

              for (int i = args.value.startDate.day;
                  i <= args.value.endDate.day;
                  i++) {
                DateTime selectedDate = DateTime(
                    args.value.startDate.year, args.value.startDate.month, i);
                // Check if it's not Saturday or Sunday before adding
                if (selectedDate.weekday != DateTime.saturday &&
                    selectedDate.weekday != DateTime.sunday) {
                  selectedDates.add(selectedDate);
                }
              }

              selectedDateStrings = selectedDates
                  .map((date) => date.toString().split(' ')[0])
                  .toList();
              print(selectedDateStrings);
            },
            selectionColor: const Color.fromARGB(255, 4, 69, 122),
            rangeSelectionColor:
                const Color.fromARGB(255, 4, 69, 122).withOpacity(0.3),
          )

          // if (pickedStartDate != null) {
          //   DateTime pickedEndDate = pickedStartDate.add(Duration(days: 14));
          //   controller.startdate.value.text =
          //       DateFormat('yyyy-MM-dd').format(pickedStartDate);
          //   print("Selected Start Date: ${controller.startdate.value.text}");
          //   controller.enddate.value.text =
          //       DateFormat('yyyy-MM-dd').format(pickedEndDate);
          //   print("Selected End Date: ${controller.enddate.value.text}");
          // }

// Padding(padding: const EdgeInsets.all(20.0)),
// Obx(
//   () => TextField(
//     controller: controller.enddate.value,
//     decoration: const InputDecoration(
//       icon: Icon(Icons.calendar_today_rounded),
//       labelText: "End Date",
//     ),
//     onTap: () async {
//       DateTime? pickedEndDate = await showDatePicker(
//         context: context,
//         initialDate: DateTime.now(),
//         firstDate: DateTime(2000),
//         lastDate: DateTime(2101),
//         selectableDayPredicate: (DateTime date) {
//           // Disable Saturday (day 6) and Sunday (day 7)
//           return date.weekday != 6 && date.weekday != 7;

//         },
//       );

// if (pickedEndDate != null) {
//         DateTime pickedStartDate = DateTime.now();
//         if (pickedStartDate.isBefore(pickedEndDate)) {
//           Duration difference = pickedEndDate.difference(pickedStartDate);
//           if (difference.inDays == 14) {
//             controller.enddate.value.text =
//                 DateFormat('yyyy-MM-dd').format(pickedEndDate);
//             print("Selected End Date: ${controller.enddate.value.text}");
//           } else {
//             // Show an error message if the date difference is not 15 days
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               content: Text("Please choose a date range of exactly 15 days."),
//             ));
//           }
//         } else {
//           // Show an error message if the end date is before the start date
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text("End date must be after the start date."),
//           ));
//         }
//       }
//     },
//   ),
// )

          // ListView.builder(itemBuilder: (context, index)
          // {

          // }),
          // ListTile(
          //     leading: Icon(Icons.rice_bowl_sharp),
          //     title: Obx(() => Text(controller.mainiteams[0].toString())),
          //     trailing: Obx(() => Radio(
          //           value: "riceandchapati",
          //           groupValue: controller.selected.value,
          //           onChanged: ((value) {
          //             controller.selected.value = value.toString();
          //           }),
          //         ))),
          // ListTile(
          //     leading: Icon(Icons.circle),
          //     title: Obx(() => Text(controller.mainiteams[1].toString())),
          //     trailing: Obx(() => Radio(
          //           value: "ricewithchapathi",
          //           groupValue: controller.selected.value,
          //           onChanged: ((value) {
          //             controller.selected.value = value.toString();
          //           }),
          //         ))),

          //   Container(
          //       width: MediaQuery.of(context).size.width,
          //       height: MediaQuery.of(context).size.height * 0.3,
          //       child: Obx(() => ListView.builder(
          //             itemCount: controller.extraiteam.length,
          //             itemBuilder: (context, index) {
          //               return ListTile(
          //                   leading: Icon(Icons.circle),
          //                   title: Obx(() =>
          //                       Text(controller.extraiteam[index].toString())),
          //                   trailing: Obx(() => Radio(
          //                         value: controller.extraiteam[index].toString(),
          //                         groupValue: controller.selected.value,
          //                         onChanged: ((value) {
          //                           controller.selected.value = value.toString();
          //                         }),
          //                       )));
          //             },
          //           ))),
        ],
      ),
    );
  }

  Widget _mainmanu1(context) {
    return SizedBox(
      height: 30,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 5),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            "Tea or coffee preferences",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  _dropdown() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
      child: Obx(
        () => Container(
          height: 50, // Adjust the height as needed
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 4, 69, 122),
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              border: InputBorder.none, // Remove the default underline
            ),
            items: [
              for (var data in controller.mainiteams.value)
                DropdownMenuItem(
                  child: Text(data),
                  value: data,
                ),
            ],
            onChanged: (value) => controller.selected.value = value as String,
            hint: Padding(
              padding: const EdgeInsets.only(
                  left: 8), // Adjust the left padding as needed
              child: Text(
                'Select your dish',
                style: TextStyle(
                    color: Colors.grey), // Customize the style if needed
              ),
            ),
            alignment: Alignment.centerLeft, // Align the text to the center
          ),
        ),
      ),
    );
  }

  _dropdown1() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
      child: Obx(
        () => Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 4, 69, 122),
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: MultiSelectDialogField(
            items: controller.extraiteam.value
                .map((data) => MultiSelectItem<String>(data, data))
                .toList(),
            listType: MultiSelectListType.CHIP,
            onSelectionChanged: (value) {
              controller.selectedItems = value;
            },
            onConfirm: (values) {
              if (values.isNotEmpty) {
                List<String> selectedValues = List<String>.from(values);

                controller.extra.value =
                    (selectedValues.isNotEmpty ? selectedValues[0] : null)!;

                print('Selected Values: $selectedValues');
              }
            },
            searchable: false, // Set to true if you want a searchable dropdown
            buttonText: Text(
              'Select your preferences',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              // Adjust the font size as needed
            ), // Placeholder text
            selectedItemsTextStyle: TextStyle(),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }

  List<DateTime> selectedDates = [];
  var selectedDateStrings;
  // var getTodaLunch;
  // var showDateAlreadyBookedAlert;
  bool isToday(String dateString) {
    var selectedDate = DateTime.parse(dateString);
    var today = DateTime.now();
    return selectedDate.year == today.year &&
        selectedDate.month == today.month &&
        selectedDate.day == today.day;
  }

  Widget floatingbutton(BuildContext context) {
    // Access deletedEntries from MenuListController
    List<Map<String, dynamic>> deletedEntries =
        MenuListController().deletedEntries;

    return FloatingActionButton.extended(
      onPressed: () async {
        // If no date is selected, set today's date as default
        if (selectedDateStrings.isEmpty) {
          selectedDateStrings = [DateTime.now().toString().split(' ')[0]];
        }

        // Check if the selected date is in deletedEntries
        if (isDateInDeletedEntries(selectedDateStrings, deletedEntries)) {
          showDeletedEntryAlert(context);
          return; // Return early if the date is in deletedEntries
        }

        // If the dish is not selected, show a snack bar
        if (controller.selected.value.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Please select your dish.',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              backgroundColor: Color.fromARGB(255, 34, 2, 74),
            ),
          );
          return; // Return early if the dish is not selected
        }

        // Check if the date is already booked
        var dateBookingResponse = await controller.getTodaLunch(context);

        if (dateBookingResponse.containsKey('error')) {
          // Date is already booked, show an alert only if it's today
          if (isToday(selectedDateStrings[0])) {
            showDateAlreadyBookedAlert(context);
          }
        } else {
          // Date is not booked, proceed with booking
          var isDateAlreadyBooked = dateBookingResponse['isDateAlreadyBooked'];

          if (isToday(selectedDateStrings[0]) && isDateAlreadyBooked) {
            // Date is today and already booked, show an alert
            showDateAlreadyBookedAlert(context);
          } else {
            // Date is not booked or not today, proceed with booking
            var lunchBookingResponse =
                await controller.booklunch(selectedDateStrings, deletedEntries);

            if (lunchBookingResponse == 200) {
              Get.offAllNamed(Appstring.home);
            } else if (lunchBookingResponse == 409) {
              // Conflict status (e.g., entry is already deleted)
              showDeletedEntryAlert(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Failed to book lunch. Please try again.',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  backgroundColor: Color.fromARGB(255, 34, 2, 74),
                ),
              );
            }
          }
        }
      },
      label: Text("Book Lunch"),
      icon: Icon(Icons.breakfast_dining),
      backgroundColor: const Color.fromARGB(255, 34, 2, 74),
      foregroundColor: Colors.white,
    );
  }

  bool isDateInDeletedEntries(
      List<String> dates, List<Map<String, dynamic>> deletedEntries) {
    for (var date in dates) {
      if (deletedEntries.any((entry) => entry['date'] == date)) {
        return true;
      }
    }
    return false;
  }

  void showDeletedEntryAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Entry Deleted"),
          content:
              Text("You already deleted this entry. Please book in Redmine."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void showDateAlreadyBookedAlert(BuildContext context) {
    // Example: Show an alert dialog to inform the user that the date is already booked
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Date Already Booked'),
          content: Text('You cannot book on the same date again.'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _mainmanu(BuildContext context) {
    return SizedBox(
      height: 30,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 5),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            "Select Your Dish",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  _cancelfoodfloattingbutton() {
    return FloatingActionButton.extended(
      onPressed: () {
        controller.cancel();
      },
      label: Text("Cancel Booking"),
      icon: Icon(Icons.cancel),
    );
  }

  _bookedpage(context) {
    return Center(
      child: Container(
        color: const Color.fromARGB(255, 5, 57, 147),
        alignment: Alignment.center,
        child: Text(
          "You have booked you meals",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        height: 150,
        width: MediaQuery.of(context).size.width * 0.9,
      ),
    );
  }

  //   items: list.map<DropdownMenuItem<String>>((String value) {
  //     return DropdownMenuItem<String>(
  //       value: value,
  //       child: Text(value),
  //     );
  //   }).toList(),
  // );
  _Homefloattingbutton() {
    return FloatingActionButton.extended(
      onPressed: () {
        Get.toNamed(Appstring.home);
      },
      label: Text("Back Home"),
      icon: Icon(Icons.home),
    );
  }
}
