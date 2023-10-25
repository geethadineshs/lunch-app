import 'package:flutter/cupertino.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:test_app/const/routeconst.dart';



void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
    GetMaterialApp(
      initialRoute: Routeconst.initalpath,
      debugShowCheckedModeBanner: false,
      getPages: Routeconst.route,
    ),
  );
  FlutterNativeSplash.remove();
}
