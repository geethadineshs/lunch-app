import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_app/pages/splash/splashcontroller.dart';

class Splashview extends GetView<SplashController> {
  Splashview({Key? key}) : super(key: key) {
    controller.onload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Colors.white,s
      body: Center(
          child: Container(
          child: SvgPicture.asset(
            'assets/acs_logo.svg',
             placeholderBuilder: (BuildContext context) => Container(
                child: const CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
