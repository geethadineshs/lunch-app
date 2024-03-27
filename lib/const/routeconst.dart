import 'package:get/get.dart';
import 'package:test_app/pages/MenuList/menulistview.dart';
import 'package:test_app/pages/leaverequest/leaverequestbinding.dart';
import 'package:test_app/pages/leaverequest/leaverequestview.dart';
import 'package:test_app/pages/listLeaveRequest/listRequestView.dart';
import 'package:test_app/pages/listLeaveRequest/listRequestbinding.dart';
import 'package:test_app/pages/lunchCountAdmin/lunchCountAdmin.dart';
import 'package:test_app/pages/lunchCountAdmin/lunchCountAdminBinding.dart';

import 'package:test_app/pages/requests/requestbinding.dart';
import 'package:test_app/pages/requests/requestview.dart';
import '../pages/Lunchbooking/lunchbinding.dart';
import '../pages/Lunchbooking/lunchview.dart';
import '../pages/home/homebinding.dart';
import '../pages/home/homeview.dart';
import '../pages/login/loginbinding.dart';
import '../pages/login/loginview.dart';
import '../pages/splash/splashbinding.dart';
import '../pages/splash/splashscreen.dart';
import 'stringconst.dart';

class Routeconst {
  Routeconst._();
  static const initalpath = Appstring.intital;

  static final route = [
    GetPage(
      name: initalpath,
      page: () => Splashview(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Appstring.login,
      page: () => LogininView(),
      binding: Loginbinding(),
    ),
    GetPage(
      name: Appstring.home,
      page: () => HomeView(),
      binding: Homebinging(),
    ),
    GetPage(
      name: Appstring.foodorder,
      page: () => LunchView(),
      binding: LunchBinging(),
    ),
    GetPage(
      name: Appstring.menulist,
      page: () => MenuListView(),
      binding: LunchBinging(),
    ),
    GetPage(
      name: Appstring.requests,
      page: () => RequestView(),
      binding: RequestBinging(),
    ),
    GetPage(
      name: Appstring.leaverequest,
      page: () => LeaveRequestView(),
      binding: LeaveRequestBinging(),
    ),
    GetPage(
      name: Appstring.listleave,
      page: () => LeaveRequestListView(),
      binding: LeaveRequestListbinding(),
    ),
        GetPage(
      name: Appstring.lunchcount,
      page: () => LunchCountingAdminView(),
      binding: LunchCountingAdminbinding(),
    ),
  ];
}
