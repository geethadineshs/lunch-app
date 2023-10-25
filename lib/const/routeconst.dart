import 'package:get/get.dart';
import 'package:test_app/TeaCoffee/teacoffeeview.dart';
import '../TeaCoffee/teacoffeebinding.dart';
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
      name: Appstring.TeaCoffee,
      page: () => TeaCoffeeView(),
      binding:TeaCoffeeBinging() ,

    ),
    
  ];
}
