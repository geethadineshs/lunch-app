
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:test_app/TeaCoffee/teacoffeecontroller.dart';

// ignore: must_be_immutable
class TeaCoffeeView extends GetView<TeaCoffeeController> {
  TeaCoffeeView({Key? key}) : super(key: key);
  // Add a variable to store the selected date.
  List<DateTime> selectedDates = [];
  var selectedDateStrings;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
        children: [
          SfDateRangePicker(
            selectionMode: DateRangePickerSelectionMode.range,
            selectableDayPredicate: (DateTime date) =>
                date.weekday >= 1 && date.weekday <= 5,
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              selectedDates.clear(); // Clear the list before adding new dates
              for (int i = args.value.startDate.day;
                  i <= args.value.endDate.day;
                  i++) {
                selectedDates.add(DateTime(
                    args.value.startDate.year, args.value.startDate.month, i));
              }
              selectedDateStrings = selectedDates
                  .map((date) => date.toString().split(' ')[0])
                  .toList();
              print(selectedDateStrings);
            },
          ),

          SizedBox(height: 20), // Add some spacing
          ElevatedButton(
            onPressed: () {
              for (var date in selectedDateStrings){
              controller.booklunch();
              }
                            
              controller.booklunch();
            
            },
            child: Text('Submit'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
          ),
        ],
      ),
      ),
    );
  }
  
}
