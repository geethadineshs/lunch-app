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
        body: Center(
          child: Stack(
            children: [
              Positioned(
                top: 200,
                left: 0,
                right: 0,
                child: _video(),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListView(
                    children: [
                      SizedBox(height: 50),
                      RequestCard(
                        title: 'Leave Request',
                        formUrl:
                            'https://pm.agilecyber.co.uk/wkleaverequest/edit',
                      ),
                      SizedBox(height: 5),
                      RequestCard(
                        title: 'Permission Request',
                        formUrl: 'https://forms.office.com/r/66E26dwVFf',
                      ),
                      SizedBox(height: 5),
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
                child: VideoPlayer(controller.videoController),
              )
            : CircularProgressIndicator();
      },
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
    Widget leadingWidget;
    if (title == 'Leave Request') {
      leadingWidget = _iconavatar(
        'assets/leave_request.svg',
      );
    } else if (title == 'Permission Request') {
      leadingWidget = _iconavatar(
        'assets/permission_request.svg',
      );
    } else {
      leadingWidget = _iconavatar(
        'assets/workfromhome_request.svg',
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 10.0, left: 10),
      child: Container(
        height: 70,
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: BorderSide(
              color: Color.fromARGB(255, 1, 37, 73),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 2.5),
            child: ListTile(
              leading: leadingWidget,
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 1, 37, 73),
                ),
              ),
              onTap: () => _handleTap(context),
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

  Widget _iconavatar(svgImagePath) {
    return Container(
      width: 50,
      height: 50,
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
        child: SvgPicture.asset(svgImagePath, height: 28, width: 28),
      ),
    );
  }
}
