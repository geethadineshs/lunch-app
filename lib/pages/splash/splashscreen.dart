import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_app/const/Appcolor.dart';
import 'package:test_app/pages/splash/splashcontroller.dart';

class Splashview extends GetView<SplashController> {
  Splashview({Key? key}) : super(key: key) {
    controller.onload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Container(
          child: SvgPicture.asset(
            'assets/assets/acs_logo_color.png',
            placeholderBuilder: (BuildContext context) =>
                Container(child: const CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
