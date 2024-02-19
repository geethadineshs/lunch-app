import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:test_app/const/Appcolor.dart';
import 'package:test_app/pages/leaverequest/leaverequestcontroller.dart';

class LeaveRequestView extends GetView<LeaveRequestController> {
  LeaveRequestView({Key? key}) : super(key: key) {
    controller.onInit();
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
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Color(0xFFCCCCFF),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 35, right: 10.0, left: 10, bottom: 10),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  titleForm('Leave Type'),
                  _dropdown(),
                  SizedBox(height: 16.0),
                  titleForm('Start Date'),
                  _startDate(context),
                  SizedBox(height: 16.0),
                  titleForm('End Date'),
                  _endDate(context),
                  SizedBox(height: 16.0),
                  titleForm('Reason'),
                  _comment(),
                  SizedBox(height: 16.0),
                  _submit(),
                ],
                ),
              ),
            ),
          ),
        ),
    );
  }

  Widget titleForm(heading) {
    return Text(
      heading,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
        color: const Color.fromARGB(255, 34, 2, 74),
      ),
    );
  }

  Widget _dropdown() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 34, 2, 74),
        ),
        borderRadius: BorderRadius.circular(100.0),
        color: Colors.white,
      ),
      child: Obx(
        () => DropdownButtonFormField(
          value: controller.selectedLeaveType.value,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 20),
            prefixIcon: _iconavatar(Icons.menu_book_rounded),
          ),
          onChanged: (value) {
            controller.selectedLeaveType.value = value.toString();
          },
          items: controller.leaveTypes.map((item) {
            return DropdownMenuItem(
              value: item['value'].toString(),
              child: Text(
                item['label'],
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Colors.black),
              ),
            );
          }).toList(),
          hint: Text('Select Leave Type'),
        ),
      ),
    );
  }

  Widget _comment() {
    return Container(
      height: 70,
      child: TextFormField(
        decoration: InputDecoration(
            hintText: 'Type your Reason',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100.0),
              borderSide: BorderSide(),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100.0),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 34, 2, 74),
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: _iconavatar(Icons.comment_sharp)),
        controller: controller.commentController,
        maxLines: 3,
      ),
    );
  }

  Widget _endDate(context) {
    return GestureDetector(
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
          if (controller.startDateController.text.isNotEmpty &&
              pickedDate.isBefore(
                  DateTime.parse(controller.startDateController.text))) {
            controller.startDateController.text =
                controller.endDateController.text;
          }
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
              hintText: 'Select end date',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: BorderSide(
                  color: const Color.fromARGB(255, 34, 2, 74),
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: _iconavatar(Icons.calendar_month_rounded)),
          controller: controller.endDateController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'End Date is required';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _startDate(context) {
    return GestureDetector(
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
          if (controller.endDateController.text.isNotEmpty &&
              pickedDate
                  .isAfter(DateTime.parse(controller.endDateController.text))) {
            controller.endDateController.text =
                controller.startDateController.text;
          }
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
              hintText: 'Select start date',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: BorderSide(
                  color: const Color.fromARGB(255, 34, 2, 74),
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: _iconavatar(Icons.calendar_month_rounded)),
          controller: controller.startDateController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Start Date is required';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _submit() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 34, 2, 74),
        foregroundColor: AppColors.white,
        minimumSize: Size(double.infinity, 60),
      ),
      onPressed: () {
        Map<String, dynamic> requestBody = {
          "start_date": controller.startDateController.text,
          "end_date": controller.endDateController.text,
          "leave_reasons": controller.commentController.text,
          "leave_type_id": controller.selectedLeaveType.value,
        };
        controller.submitLeaveRequest(requestBody);
      },
      child: Text('Submit'),
    );
  }

  Widget _iconavatar(iconData) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 22, 26, 232),
              Color.fromARGB(255, 34, 2, 74),
            ],
          ),
        ),
        child: Center(
          child: Icon(
            iconData,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
