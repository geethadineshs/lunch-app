import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:test_app/const/Appcolor.dart';
import 'package:test_app/pages/leaverequest/leaverequestcontroller.dart';

class LeaveRequestView extends GetView<LeaveRequestController> {
  LeaveRequestView({Key? key}) : super(key: key) {
    controller.oninit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: _buildForm(context),
    );
  }

  _appbar() {
    return AppBar(
      title: Text(
        "New Leave Request",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 34, 2, 74),
      foregroundColor: AppColors.white,
    );
  }

  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0),
            Text(
              'Start Date',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: const Color.fromARGB(255, 34, 2, 74)),
            ),
            Container(
              height: 45.0,
              child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.amber,
                  hintText: 'Select start date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  contentPadding: EdgeInsets.only(right: 20, left: 20),
                ),
                controller: controller.startDateController,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    controller.startDateController.text =
                        pickedDate.toLocal().toString().split(' ')[0];
                  }
                },
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'End Date',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: const Color.fromARGB(255, 34, 2, 74)),
            ),
            Container(
              height: 45,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Select End date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  contentPadding: EdgeInsets.only(right: 20, left: 20),
                ),
                controller: controller.endDateController,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    controller.endDateController.text =
                        pickedDate.toLocal().toString().split(' ')[0];
                  }
                },
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Comment',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: const Color.fromARGB(255, 34, 2, 74)),
            ),
            Container(
              height: 70,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Comment',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  contentPadding:
                      EdgeInsets.only(left: 20, top: 20, bottom: 20),
                ),
                controller: controller.commentController,
                maxLines: 3,
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 34, 2, 74),
                foregroundColor: AppColors.white,
              ),
              onPressed: () {
                controller.submitForm();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
