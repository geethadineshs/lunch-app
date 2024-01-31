import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/const/resourceconst.dart';

class LunchEntry {
  final int id; // Add ID property
  final String date;
  final String lunchOption;

  LunchEntry({required this.id, required this.date, required this.lunchOption});
}

class MenuListController extends GetxController {
  RxList<Map<String, dynamic>> groupedEntries = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  List<Map<String, dynamic>> get getDeletedEntries => deletedEntries;
  //  RxList<Map<String, dynamic>> deletedEntries = <Map<String, dynamic>>[].obs;

  // Create a Set to store deleted dates
  Set<String> deletedDates = {};
  // Singleton pattern
  static final MenuListController _instance = MenuListController._internal();
  factory MenuListController() => _instance;

  MenuListController._internal();
  void setGroupedEntries(List<Map<String, dynamic>> entries) {
    groupedEntries.assignAll(entries);
  }

  Future<void> init() async {
    await precheck();
  }

  /// The `precheck()` method is responsible for making an HTTP GET request to retrieve lunch entries
  /// from a specific endpoint. Here's a breakdown of what the method does:
  Future<void> precheck() async {
    var key = await getusercredential();

    // Get the start and end dates for the current month
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    // Format dates as strings in the 'YYYY-MM-DD' format
    String formattedFirstDay =
        "${firstDayOfMonth.year}-${firstDayOfMonth.month.toString().padLeft(2, '0')}-${firstDayOfMonth.day.toString().padLeft(2, '0')}";
    String formattedLastDay =
        "${lastDayOfMonth.year}-${lastDayOfMonth.month.toString().padLeft(2, '0')}-${lastDayOfMonth.day.toString().padLeft(2, '0')}";

    var endpoint = Uri.encodeFull(Resource.baseurl +
        '/projects/lunch/time_entries.json?set_filter=1&sort=spent_on:desc&f[]=spent_on&op[spent_on]=><&v[spent_on][]=$formattedFirstDay&v[spent_on][]=$formattedLastDay&f[]=user_id&op[user_id]==&v[user_id][]=me&f[]=&c[]=spent_on&c[]=user&c[]=activity&c[]=issue&c[]=comments&');
    print(endpoint);

    try {
      final response = await http.get(Uri.parse(endpoint), headers: {
        "Content-Type": "application/json",
        "Authorization": "Basic $key",
      });

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var entries = jsonResponse['time_entries'];

        List<LunchEntry> lunchEntries = entries.map<LunchEntry>((entry) {
          var entryId = entry['id'];
          var spentOn = entry['spent_on'];
          var customFields = entry['custom_fields'];
          var lunchOption;

          for (var field in customFields) {
            if (field['name'] == 'Lunch Option') {
              lunchOption = field['value'].toString();
            }
          }

          return LunchEntry(
            id: entryId,
            date: spentOn.substring(0, 10),
            lunchOption: lunchOption,
          );
        }).toList();

        // Update the grouped entries
        setGroupedEntries(groupLunchEntries(lunchEntries));

        isLoading.value = false;
      } else {
        print('API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
    }
  }

  // Function to load deleted entries from shared preferences
  Future<void> loadDeletedEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('deletedEntries');
    if (jsonString != null) {
      deletedEntries = List<Map<String, dynamic>>.from(json.decode(jsonString));
    }
  }

// Function to save deleted entries to shared preferences
  Future<void> saveDeletedEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(deletedEntries);
    prefs.setString('deletedEntries', jsonString);
  }

  // Function to delete entries
  Future<void> deleteEntries(int id, String date) async {
    var key = await getusercredential();
    var deleteEndpoint = Uri.parse('${Resource.baseurl}/time_entries/$id.json');

    print('Delete Endpoint for ID $id: $deleteEndpoint');

    try {
      final deleteResponse = await http.delete(deleteEndpoint, headers: {
        "Content-Type": "application/json; charset=utf-32",
        "Authorization": "Basic $key",
      });
      print(
          'API Response for ID $id: ${deleteResponse.statusCode} - ${deleteResponse.body}');
      if (deleteResponse.statusCode == 204) {
        // Entry deleted successfully
        print('Entry with ID $id deleted successfully');

        // Add the deleted entry details to the list
        deletedEntries.add({
          'id': id,
          'date': date,
        });

        // Refresh the data after deletion
        await precheck();
      } else {
        // Handle the case when the delete request fails
        print(
            'Failed to delete entry with ID $id. Status code: ${deleteResponse.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error deleting entry with ID $id: $e');
    }
  }

// Declare a list to store deleted entries
  List<Map<String, dynamic>> deletedEntries = [];

// Example of how to use the `deletedEntries` list
  void main() async {
    // Fetch the initial data before deletion
    await MenuListController().init();

    // Assuming the first entry is being deleted
    if (MenuListController().groupedEntries.isNotEmpty) {
      var entryToDelete = MenuListController().groupedEntries[0];
      var id = entryToDelete['id'];
      var date = entryToDelete['date'];

      await deleteEntries(id, date);
      print('Deleted Entries: $deletedEntries');
    } else {
      print('No entries to delete.');
    }
  }

  List<Map<String, dynamic>> groupLunchEntries(List<LunchEntry>lunchEntries) {
    var groupedEntries = {};

    for (var entry in lunchEntries) {
      var date = entry.date;

      if (!groupedEntries.containsKey(date)) {
        groupedEntries[date] = [];
      }

      groupedEntries[date]!.add({
        "id": entry.id,
        "options": entry
            .lunchOption, // Assuming lunchOption is a property in LunchEntry
      });
    }

    var lunchOptionDescriptions = {
      '1': 'Meals with chapati',
      '2': 'Chapati only',
      '3': 'No lunch required',
    };

    /// The code block you provided is a method called `groupLunchEntries` in the `MenuListController`
    /// class. This method takes a list of `LunchEntry` objects and groups them based on their date. It
    /// then maps each group to a new map object that contains the date, options, and id of the group.
    return groupedEntries.entries.map((entry) {
      var date = entry.key;
      var id = entry.value[0]['id'];

      var lunchOptions = entry.value.map((lunchEntry) {
        var description =
            lunchOptionDescriptions[lunchEntry['options']] ?? 'Unknown';

        return description;
      }).toList();

      return {
        'date': date,
        'options': lunchOptions,
        'id': id,
      };
    }).toList();
  }
}

/// The function `getusercredential` retrieves a user's credential from shared preferences.
///
/// Returns:
///   The method `getusercredential()` returns a `Future` object that resolves to a `String` or `null`
/// (`String?`).
Future<String?> getusercredential() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var key = prefs.getString('key');
  return key;
}
