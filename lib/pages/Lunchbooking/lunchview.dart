import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:test_app/const/Appcolor.dart';
import 'package:test_app/pages/MenuList/menulistcontroller.dart';
import '../../const/stringconst.dart';
import 'lunchcontroller.dart';

class LunchView extends GetView<LunchController> {
  List<DateTime> bookedDates = [];

  LunchView({Key? key}) : super(key: key) {
    controller.init();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: AppColors.backgroundColor,
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
      title: Text(
        "Book Lunch",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1),
      ),
      centerTitle: true,
      backgroundColor: AppColors.appBar,
      foregroundColor: AppColors.white,
      actions: [
        IconButton(
            color: AppColors.white,
            onPressed: () {
              Get.offAllNamed(Appstring.home);
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
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 19.0, left: 15),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(
                  color: AppColors.stroke,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: SfDateRangePicker(
                selectionMode: DateRangePickerSelectionMode.range,
                selectableDayPredicate: (DateTime date) {
                  return date.weekday != DateTime.saturday &&
                      date.weekday != DateTime.sunday;
                },
                minDate: DateTime.now(),
                initialSelectedDate: null,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  selectedDates.clear();
                  // DateTime now = DateTime.now();
                  int selectedDays = args.value.endDate
                          ?.difference(args.value.startDate)
                          ?.inDays +
                      1;

                  if (selectedDays > 16) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please choose only 16 days.'),
                        backgroundColor: AppColors.appBar,
                      ),
                    );

                    args.value.startDate =
                        args.value.endDate.subtract(Duration(days: 15));
                  }

                  for (int i = args.value.startDate.day;
                      i <= args.value.endDate.day;
                      i++) {
                    DateTime selectedDate = DateTime(args.value.startDate.year,
                        args.value.startDate.month, i);
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
                selectionColor: AppColors.appBar,
                rangeSelectionColor: AppColors.stroke,
                backgroundColor: Colors.white,
                todayHighlightColor: AppColors.appBar,
                endRangeSelectionColor: AppColors.appBar,
                startRangeSelectionColor: AppColors.appBar,
              ),
            ),
          )
          , if (controller.loading.value)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _mainmanu1(context) {
    return SizedBox(
      height: 35,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 0, top: 10, bottom: 0),
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
      padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
      child: Obx(
        () => Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(
              color: AppColors.stroke,
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 3.0),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              items: [
                for (var data in controller.mainiteams.value)
                  DropdownMenuItem(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(data),
                    ),
                    value: data,
                  ),
              ],
              onChanged: (value) => controller.selected.value = value as String,
              style: TextStyle(color: AppColors.black),
              hint: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  'Select your dish',
                  style: TextStyle(
                    color: AppColors.stroke,
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(top: 2, right: 15.0),
                child: Icon(Icons.keyboard_arrow_down, color: AppColors.stroke),
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
      ),
    );
  }

  _dropdown1() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
      child: Obx(
        () => Container(
          // height: 90,
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(
              color: AppColors.stroke,
            ),
            borderRadius: BorderRadius.circular(4),
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
            searchable: false,
            buttonText: Text(
              'Select your preferences',
              style: TextStyle(fontSize: 16, color: AppColors.stroke),
            ),
            selectedItemsTextStyle: TextStyle(
                backgroundColor: AppColors.white, color: AppColors.white),
            backgroundColor: AppColors.backgroundColor,
            checkColor: Colors.red,
            selectedColor: AppColors.appBar,
            unselectedColor: AppColors.stroke,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            buttonIcon:
                Icon(Icons.keyboard_arrow_down, color: AppColors.stroke),
          ),
        ),
      ),
    );
  }

  List<DateTime> selectedDates = [];
  var selectedDateStrings;
  bool isToday(String dateString) {
    var selectedDate = DateTime.parse(dateString);
    var today = DateTime.now();
    return selectedDate.year == today.year &&
        selectedDate.month == today.month &&
        selectedDate.day == today.day;
  }

  Widget floatingbutton(BuildContext context) {
    List<Map<String, dynamic>> deletedEntries =
        MenuListController().deletedEntries;

    return ElevatedButton(
      child: Text("Book Lunch"),
      onPressed: () async {
        if (selectedDateStrings.isEmpty) {
          selectedDateStrings = [DateTime.now().toString().split(' ')[0]];
        }
        if (isDateInDeletedEntries(selectedDateStrings, deletedEntries)) {
          showDeletedEntryAlert(context);
          return;
        }
        if (controller.selected.value.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Please select your dish.',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              backgroundColor: AppColors.appBar,
            ),
          );
          return;
        }
        var isbookedonselecteddate =
            await controller.checkbookingalreadyexist(selectedDateStrings);

        print(isbookedonselecteddate["total_count"]);
        print(isbookedonselecteddate);
        // var dateBookingResponse = await controller.getTodaLunch(context);
        if (isbookedonselecteddate["total_count"] != 0) {
          showDateAlreadyBookedAlert(context);
          ;
        } else {
          var lunchBookingResponse =
              await controller.booklunch(selectedDateStrings, deletedEntries);
          
          if (lunchBookingResponse == 200) {
            Get.offAllNamed(Appstring.home);
          } else if (lunchBookingResponse == 409) {
            showDeletedEntryAlert(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Failed to book lunch. Please try again.',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                backgroundColor: AppColors.appBar,
              ),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.button,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        minimumSize: Size(MediaQuery.of(context).size.width * 0.9,
            MediaQuery.of(context).size.height * 0.075),
      ),
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Date Already Booked'),
          content: Text('You cannot book on the same date again.'),
          actions: [
            TextButton(
              onPressed: () {
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
      height: 45,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
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
        color: AppColors.appBar,
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
}
