import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/const/Appcolor.dart';
import 'package:test_app/const/stringconst.dart';
import 'package:test_app/pages/home/homeview.dart';
import 'package:test_app/pages/requests/requestcontroller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RequestView extends GetView<RequestViewController> {
  RequestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: ListView(
        children: [
          RequestCard(
            title: 'Leave Request',
            formUrl: 'https://pm.agilecyber.co.uk/wkleaverequest/edit',
          ),
          RequestCard(
            title: 'Permission Request',
            formUrl: 'https://forms.office.com/r/66E26dwVFf',
          ),
          RequestCard(
            title: 'Work from Home Request',
            formUrl: 'https://forms.office.com/r/KH8HnMWPgp',
          ),
        ],
      ),
        bottomNavigationBar: BottomNavigationBars(),
    );
  }

  _appbar() {
    return AppBar(
      title: Text(
        "Requests",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 34, 2, 74),
      foregroundColor: AppColors.white,
      automaticallyImplyLeading: false,
    );
  }
}

class RequestCard extends StatelessWidget {
  final String title;
  final String formUrl;

  const RequestCard({Key? key, required this.title, required this.formUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(width: 1, color: AppColors.grey),
        ),
        margin: EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 1, 37, 73),
            ),
          ),
          onTap: () => _handleTap(context),
        ),
      ),
    );
  }

  getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString(Appstring.loginid);
    return user;
  }

  Future<void> _handleTap(BuildContext context) async {
    if (title == "Leave Request") {
      String userId = await getuserid();
      Get.toNamed('/leaverequest', arguments: userId);
    } else {
      _launchFormUrl(context, formUrl, title: title);
    }
  }

  Future<void> _launchFormUrl(BuildContext context, String url,
      {required String title}) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'No internet connection, please make sure your are connected with the internet'),
        ),
      );
      return;
    }
    Get.to(() => _buildWebViewWithHeader(url, title));
  }

  _buildNoInternetWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            color: Colors.red,
            size: 40,
          ),
          SizedBox(height: 10),
          Text(
            "No internet connection",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebViewWithHeader(String url, String title) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 34, 2, 74),
          foregroundColor: AppColors.white,
        ),
        body: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            if (error.errorCode == -2) {
              return _buildNoInternetWidget();
            } else if (error.errorCode == 404) {
              return _buildNoInternetWidget();
            }

            print("WebView Error: ${error.description}");
          },
        ));
  }
}
