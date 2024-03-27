import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LunchCountingAdminController extends GetxController {
  var lunchData = <Map<String, dynamic>>[].obs;
  var filteredData = <Map<String, dynamic>>[].obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://pm.agilecyber.co.uk/acsapi/public/redmine/lunch-count'));
    if (response.statusCode == 200) {
      var data =
          List<Map<String, dynamic>>.from(jsonDecode(response.body)['data']);
      // Sort the fetched data by username
      data.sort(
          (a, b) => (a['user_name'] ?? '').compareTo(b['user_name'] ?? ''));
      lunchData.assignAll(data);
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  void search(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      // If the query is empty, show the full list
      filteredData.assignAll(lunchData);
    } else {
      // If the query is not empty, filter the data based on the query
      final filteredList = lunchData.where((item) {
        final userName = item["user_name"].toString().toLowerCase();
        return userName.contains(query.toLowerCase());
      }).toList();

      // Update filteredData only if there are matching results
      if (filteredList.isNotEmpty) {
        filteredData.assignAll(filteredList);
      } else {
        filteredData.clear(); // Clear filteredData if no matches found
      }
    }
  }
}
