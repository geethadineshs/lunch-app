import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LeaveRequestListController extends GetxController {
  var leaveRequests = <Map<String, dynamic>>[].obs;
  var filteredData = <Map<String, dynamic>>[].obs;
  var searchQuery = ''.obs;
  var selectedStatus = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://pm.agilecyber.co.uk/acsapi/public/redmine/leave-status'));
      if (response.statusCode == 200) {
        var data =
            List<Map<String, dynamic>>.from(jsonDecode(response.body)['data']);

        // Sort the data by date
        data.sort((a, b) {
          DateTime dateA = DateTime.parse(a["start_date"]);
          DateTime dateB = DateTime.parse(b["start_date"]);
          return dateA.compareTo(dateB);
        });

        leaveRequests.assignAll(data);
        // Initial filtering with 'All' status
        filterByStatus('All');
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (error) {
      print('Error fetching leave requests: $error');
    }
  }

  // void search(String query) {
  //   searchQuery.value = query;
  //   if (query.isEmpty) {
  //     // If the query is empty, show the full list
  //     filteredData.assignAll(leaveRequests);
  //   } else {
  //     final filteredList = leaveRequests.where((item) {
  //       final userName = item["user_name"].toString().toLowerCase();
  //       return userName.contains(query.toLowerCase());
  //     }).toList();

  //     if (filteredList.isNotEmpty) {
  //       filteredData.assignAll(filteredList);
  //     } else {
  //       filteredData.clear();
  //     }
  //   }
  // }

  void filterByStatus(String? status) {
    selectedStatus.value = status ?? 'All';
    if (status == null || status == 'All') {
      filteredData.assignAll(leaveRequests);
    } else {
      filteredData.assignAll(leaveRequests.where((leaveRequest) {
        return leaveRequest["status"] == status;
      }));
    }
  }

  String getMonthFromFirstRequest() {
    if (leaveRequests.isNotEmpty) {
      String firstStartDate = leaveRequests[0]["start_date"];
      DateTime firstDate = DateTime.parse(firstStartDate);
      return "${firstDate.month.toString()} ${firstDate.year.toString()}";
    } else {
      return "";
    }
  }

  // void filterByStartDateAndStatus(
  //     DateTime selectedDate, String selectedStatus) {
  //   filteredData.assignAll(leaveRequests.where((leaveRequest) {
  //     DateTime leaveStartDate = DateTime.parse(leaveRequest["start_date"]);
  //     String status = leaveRequest["status"];
  //     return leaveStartDate.isAtSameMomentAs(selectedDate) &&
  //         status == selectedStatus;
  //   }));
  // }
}
