import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/const/Appcolor.dart';
import 'package:test_app/const/stringconst.dart';
import 'package:test_app/pages/home/homeview.dart';
import 'package:test_app/pages/requests/requestcontroller.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RequestView extends GetView<RequestViewController> {
  RequestView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appbar(),
        backgroundColor: AppColors.backgroundColor,
        body: Center(
          child: Stack(
            children: [
              Positioned(
                top: 260,
                left: 0,
                right: 0,
                child: SvgPicture.asset(
                  'assets/requestPage.svg',
                  // color: Cs.white,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.39,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(4),
                    // boxShadow: [
                    // BoxShadow(
                    // color: Colors.white,
                    // spreadRadius: 5,
                    // blurRadius: 7,
                    // offset: Offset(0, 3),
                    // ),
                    // ],
                  ),
                  child: ListView(
                    children: [
                      SizedBox(height: 40),
                      RequestCard(
                        title: 'Leave Request',
                        formUrl:
                            'https://pm.agilecyber.co.uk/wkleaverequest/edit',
                      ),
                      SizedBox(height: 10),
                      RequestCard(
                        title: 'Permission Request',
                        formUrl: 'https://forms.office.com/r/66E26dwVFf',
                      ),
                      SizedBox(height: 10),
                      RequestCard(
                        title: 'Work from Home Request',
                        formUrl: 'https://forms.office.com/r/KH8HnMWPgp',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar());
  }

  Widget _video() {
    return GetBuilder<RequestViewController>(
      builder: (controller) {
        return controller.videoController.value.isInitialized
            ? AspectRatio(
                aspectRatio: controller.videoController.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(controller.videoController),
                    if (!controller.videoController.value.isPlaying)
                      CircularProgressIndicator(),
                  ],
                ),
              )
            : CircularProgressIndicator();
      },
    );
  }

  _appbar() {
    return AppBar(
      title: Text(
        "Requests",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1),
      ),
      centerTitle: true,
      backgroundColor: AppColors.appBar,
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
    Widget leadingWidget;
    if (title == 'Leave Request') {
      leadingWidget = _iconavatar(
        'assets/leaveRequestIcon.svg',
      );
    } else if (title == 'Permission Request') {
      leadingWidget = _iconavatar(
        'assets/permissionRequestIcon.svg',
      );
    } else {
      leadingWidget = _iconavatar(
        'assets/workfromhomeIcon.svg',
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 15.0, left: 15),
      child: GestureDetector(
        onTap: () => _handleTap(context),
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.stroke),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                leadingWidget,
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
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
          content:
              Text('please make sure your are connected with the internet'),
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
          backgroundColor: AppColors.appBar,
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

  Widget _iconavatar(svgImagePath) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SvgPicture.asset(svgImagePath, height: 28, width: 28),
      ),
    );
  }
}
