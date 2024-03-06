import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:test_app/pages/MenuList/menulistview.dart';
import 'package:test_app/services/notifi_service.dart';

import '../../const/Appcolor.dart';
import '../../const/stringconst.dart';
import 'homecontroller.dart';

class HomeView extends GetView<Homecontroller> {
  HomeView({Key? key}) : super(key: key) {
    controller.oninit();
  }
  final notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _appbar(),
      body: RefreshIndicator(
        onRefresh: () async {
          // You can put your refresh logic here
          await Future.delayed(Duration(seconds: 1));

          controller.oninit();
          // Refresh completed
        },
        child: _body(context),
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
          ),
          Align(
            child: _flotting(),
            alignment: Alignment.bottomRight,
          )
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: (index) {
              controller.changeIndex(index);
              if (controller.prevIndex.value == index) {
                return;
              }
              if (index == 0) {
                Get.offNamed('/home');
              } else if (index == 1) {
                Get.offNamed('/requests');
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/homeIcon.svg',
                  color: AppColors.appBar,
                  width: 24,
                  height: 24,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/requestIcon.svg',
                  width: 24,
                  height: 24,
                  color: Colors.grey,
                ),
                label: 'Requests',
              ),
            ],
            selectedItemColor: AppColors.appBar),
      ),
    );
  }

  _flotting() {
    return FloatingActionButton.extended(
      onPressed: () {
        DateTime now = DateTime.now();
        int hour = now.hour;
        int minute = now.minute;

        if (hour == 2) {
          if (minute >= 30) {
            // Show Snackbar for booking after 11:30 am
            Get.snackbar(
              "Time is up",
              "Book in redmine sorry for inconvenience",
              messageText: Text(
                "Book in redmine sorry for inconvenience",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              icon: Icon(Icons.close, color: Color.fromARGB(255, 165, 17, 17)),
              snackPosition: SnackPosition.BOTTOM,
              snackStyle: SnackStyle.FLOATING,
            );
          } else {
            // Move to "foodorder" page
            Get.offAndToNamed(Appstring.foodorder);
          }
        } else if (hour >= 119) {
          // Show Snackbar for booking after 12 pm
          Get.snackbar(
            "Time is up",
            "Book in redmine sorry for inconvenience",
            messageText: Text(
              "Book in redmine sorry for inconvenience",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            icon: Icon(Icons.close, color: Color.fromARGB(255, 165, 17, 17)),
            snackPosition: SnackPosition.BOTTOM,
            snackStyle: SnackStyle.FLOATING,
          );
        } else {
          // Move to "foodorder" page
          Get.offAndToNamed(Appstring.foodorder);
        }
      },
      label: Text("Book Lunch"),
      icon: Icon(Icons.food_bank_outlined),
      backgroundColor: AppColors.appBar,
      foregroundColor: AppColors.white,
    );
  }


  _appbar() {
    print(controller.name);
    return AppBar(
      centerTitle: true,
      backgroundColor: AppColors.appBar,
      title: Obx(() => Text(
            "Hi ${controller.name} ${controller.lastname}",
            style: TextStyle(
                fontSize: 20, // Adjust the font size as needed
                color: Colors.white, // Change the text color to your preference
                fontWeight: FontWeight.w500, // You can set the font weigh
                fontFamily: 'Roboto'),
          )),
      actions: [

        IconButton(
          color: AppColors.white,
          tooltip: 'Logout',
          onPressed: () {
            Get.defaultDialog(
              title: "Logout",
              content: Text("Are you sure you want to logout?"),
              actions: [
                TextButton(
                  onPressed: () {
                    controller.logout();
                    Get.offAllNamed(Appstring.login);
                  },
                  child: Text("Logout"),
                ),
                TextButton(
                  onPressed: () {
                    // Get.offAllNamed(Appstring.login);
                    Get.back();
                  },
                  child: Text("Cancel"),
                ),
              ],
            );
          },
          icon: Icon(Icons.logout),
        )
      ],
    );
  }

  _body(context) {
    return _lunchCount(context);
  }

  _lunchCount(context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        SizedBox(
          height: 10,
        ),
        _prevsinfo(context),
        _monthinfo(context),
        _empty(),
        _todayBooking()
      ],
    ));
  }

  _prevsinfo(context) {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(
              color: AppColors.stroke,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              _prevcardfirstchild(),
              _prevCardSecondChild(),
              Container(
                height: 10,
              )
            ],
          ),
        ));
  }

  _monthinfo(context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => MenuListView());
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 15, left: 15),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(
              color: AppColors.stroke,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              _cardfirstchild(),
              _cardsecoundchild(),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  _cardfirstchild() {
    return Center(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 5),
          child: SvgPicture.asset('assets/calendar.svg', height: 28, width: 28),
        ),
        Obx(
          () => Container(
            child: Text(
              controller.month.value.toString(),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Divider(
          color: AppColors.stroke,
          thickness: 1.0,
        ),
      ],
    ));
  }

  _cardsecoundchild() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                "Days",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Obx(
                    () => Text(controller.current_monthcount.value.toString())),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "Amount",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Obx(() => Text(controller.amount.value.toString())),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _prevcardfirstchild() {
    return Center(
        child: Column(children: [
      Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 5),
        child: SvgPicture.asset('assets/calendar.svg', height: 28, width: 28),
      ),
      Obx(() => Container(
            child: Text(
              controller.prev_month.value.toString(),
              style: TextStyle(
                  color: AppColors.black, fontWeight: FontWeight.w600),
            ),
          )),
      Divider(
        color: AppColors.stroke,
        thickness: 1.0,
      ),
    ]));
  }

  _prevCardSecondChild() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                "Days",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child:
                    Obx(() => Text(controller.prev_monthcont.value.toString())),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "Amount",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Obx(() => Text(controller.prev_amount.value.toString())),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _empty() {
    return Container(
      height: 10,
    );
  }

  _todayBooking() {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 15, right: 15),
      child: Container(
        // height:70,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(
            color: AppColors.stroke,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Container(
              height: 10,
            ),
            _todayDate(),
            _selectedOption(),
            Container(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  _todayDate() {
    return Center(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5),
          child: SvgPicture.asset('assets/calendar.svg', height: 24, width: 24),
        ),
        Text(
          "Bookings on " +
              DateTime.now().day.toString() +
              "-" +
              DateTime.now().month.toString() +
              "-" +
              DateTime.now().year.toString(),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        Divider(
          color: AppColors.stroke,
          thickness: 1.0,
        ),
      ],
    ));
  }

  _selectedOption() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Column(
        children: [
          Text(
            "Main Course",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            color: AppColors.stroke,
            thickness: 1,
          ),
          SizedBox(
            height: 5,
          ),
          Obx(() {
            if (controller.lunchOptionId == 3) {
              return Text(
                "No Lunch Option",
                style: TextStyle(fontSize: 14),
              );
            } else if (controller.lunchOptionId == 1) {
              return Text(
                "Meals with chapati",
                style: TextStyle(fontSize: 14),
              );
            } else if (controller.lunchOptionId == 2) {
              return Text(
                "Chapati only",
                style: TextStyle(fontSize: 14),
              );
            } else {
              return Text(
                "No Lunch Option",
              );
            }
          }),
        ],
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final RxInt _currentIndex = 1.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        currentIndex: _currentIndex.value,
        onTap: (index) {
          _currentIndex.value = index;
          if (index == 1) {
            Get.offNamed('/requests');
          } else if (index == 0) {
            Get.offNamed('/home');
          }
        },

        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/homeIcon.svg',
              width: 24,
              height: 24,
              color: Colors.grey,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/requestIcon.svg',
              width: 24,
              height: 24,
              color: AppColors.appBar,
            ),
            label: 'Requests',
          ),
        ],
        selectedItemColor: AppColors.appBar,
      ),
    );
  }
}
