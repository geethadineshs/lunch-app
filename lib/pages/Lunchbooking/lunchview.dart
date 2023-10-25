import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../const/Appcolor.dart';
import '../../const/stringconst.dart';
import 'lunchcontroller.dart';
import 'package:intl/intl.dart';

class LunchView extends GetView<LunchController> {
  
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
      backgroundColor: AppColors.siteBlue,
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
    final now = DateTime.now();
    // Allow selection of all dates except Saturdays and Sundays
    if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      return false;
    }
    return true; // Allow selection of all other days
  },
  minDate: DateTime.now(),
  onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
    selectedDates.clear();
    for (int i = args.value.startDate.day;
        i <= args.value.endDate.day;
        i++) {
      DateTime selectedDate = DateTime(
          args.value.startDate.year, args.value.startDate.month, i);
      // Check if it's not Saturday or Sunday before adding
      if (selectedDate.weekday != DateTime.saturday && selectedDate.weekday != DateTime.sunday) {
        selectedDates.add(selectedDate);
      }
    }

    if (selectedDates.length > 15) {
      // Show a snack bar if more than 15 days are selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please choose only 15 days.'),
        ),
      );
    }

    selectedDateStrings = selectedDates
        .map((date) => date.toString().split(' ')[0])
        .toList();
    print(selectedDateStrings);
  },
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

  _mainmanu1(context) {
    return SizedBox(
        height: 20,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 5),
          child: Text(
            "Extra Dish",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ));
  }

  _dropdown() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
      child: Obx(() => DropdownButtonFormField(
          // focusColor: Colors.red,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  gapPadding: 20,
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: Colors.indigoAccent, width: 1))),
          items: [
            for (var data in controller.mainiteams.value)
              DropdownMenuItem(
                child: Text(data),
                value: data,
              ),
          ],
          onChanged: (value) => controller.selected.value = value as String)),
    );
  }

  _dropdown1() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
      child: Obx(() => DropdownButtonFormField(
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: Colors.indigoAccent, width: 1))),
          items: [
            for (var data in controller.extraiteam.value)
              DropdownMenuItem(
                child: Text(data),
                value: data,
              ),
          ],
          onChanged: (value) => controller.extra.value = value as String)),
    );
  }

  List<DateTime> selectedDates = [];
  var selectedDateStrings;
floatingbutton(BuildContext context) {
  return FloatingActionButton.extended(
    onPressed: () async {
      if (controller.selected.value.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select your dish and calendar dates.'),
          ),
        );
      } else {
        var response = await controller.booklunch(selectedDateStrings);
        if (response == 200) {
          controller.booked();
          Future.delayed(Duration.zero, () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Your lunch has been booked successfully.'),
              ),
            );
          });
          Get.offAndToNamed(Appstring.home);
        }
      }
    },
    label: Text("Book Lunch"),
    icon: Icon(Icons.breakfast_dining),
  );
}



  Widget _mainmanu(BuildContext context) {
    return context != null
        ? SizedBox(
            height: 20,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 5),
              
              child: Text(
                "Select Your Dish",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
             
              ),
              
            ),
            
          )
        : Text(
            "Please fill this field",
            style: TextStyle(
              color: Colors.red,
              fontSize: 15,
              fontWeight: FontWeight.bold,
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
        color: Colors.blueAccent,
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
