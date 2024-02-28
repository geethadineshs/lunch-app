import 'package:flutter/material.dart';
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
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.request_page),
                label: 'Requests',
              ),
            ],
            selectedItemColor: Color.fromARGB(255, 1, 37, 73)),
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
      backgroundColor: Color.fromARGB(255, 34, 2, 74),
      foregroundColor: AppColors.white,
    );
  }

  // _floatting() {
  //   return FloatingActionButton.extended(
  //     onPressed: () {
  //   Get.to(() => MenuListView());
  // },
  //     label: Text("Lunch List"),
  //     icon: Icon(Icons.food_bank_outlined),
  //     backgroundColor: Color.fromARGB(255, 34, 2, 74),

  //   );
  // }

  _floattingcancell() {
    return FloatingActionButton.extended(
      onPressed: () {
        controller.cancel();
      },
      label: Text("Cancel Lunch"),
      icon: Icon(Icons.cancel_rounded),
      backgroundColor: AppColors.siteBlue,
    );
  }

  _appbar() {
    print(controller.name);
    return AppBar(
      backgroundColor: Color.fromARGB(255, 34, 2, 74),
      title: Obx(() => Text(
            "Hi ${controller.name} ${controller.lastname}",
            style: TextStyle(
                fontSize: 20, // Adjust the font size as needed
                color: Colors.white, // Change the text color to your preference
                fontWeight: FontWeight.w500, // You can set the font weigh
                fontFamily: 'Roboto'),
          )),
      actions: [
        // IconButton(
        //   tooltip: 'Delete',
        //   onPressed: () {
        //     Get.to(() => MenuListView());
        //   },
        //    icon: Icon(Icons.delete),
        //   ),
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
                    Get.offNamed(Appstring.login);
                  },
                  child: Text("Logout"),
                ),
                TextButton(
                  onPressed: () {
                    controller.logout();
                    Get.offNamed(Appstring.login);
                    Get.back(); // Close the dialog after logout
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
        _prevsinfo(context),
        _monthinfo(context),
        _empty(),
        _todayBooking()
      ],
    ));
  }

  _prevsinfo(context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20)),
          side: BorderSide(width: 1, color: AppColors.grey)),
      child: Column(
        children: [
          _prevcardfirstchild(),
          _prevCardSecondChild(),
          Container(
            height: 20,
          )
        ],
      ),
    );
  }

  _monthinfo(context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => MenuListView());
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20)),
            side: BorderSide(width: 1, color: AppColors.grey)),
        child: Column(
          children: [
            _cardfirstchild(),
            _cardsecoundchild(),
            Container(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  _cardfirstchild() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Obx(
        () => Text(
          controller.month.value.toString(),
          style: TextStyle(
              color: Color.fromARGB(255, 1, 37, 73),
              fontWeight: FontWeight.w600),
        ),
      ),
    ));
  }

  _cardsecoundchild() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
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
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Obx(() => Text(
              controller.prev_month.value.toString(),
              style: TextStyle(
                  color: Color.fromARGB(255, 1, 34, 68),
                  fontWeight: FontWeight.w600),
            )),
      ),
    );
  }

  _prevCardSecondChild() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
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
      height: 50,
    );
  }

  _todayBooking() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20)),
          side: BorderSide(width: 1, color: AppColors.grey)),
      child: Column(
        children: [
          _todayDate(),
          _selectedOption(),
          Container(
            height: 20,
          )
        ],
      ),
    );
  }

  _todayDate() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        "Bookings on " +
            DateTime.now().day.toString() +
            "-" +
            DateTime.now().month.toString() +
            "-" +
            DateTime.now().year.toString(),
        style: TextStyle(
            color: Color.fromARGB(255, 1, 36, 70), fontWeight: FontWeight.w600),
      ),
    ));
  }

  _selectedOption() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                "Main Course",
                style: TextStyle(fontWeight: FontWeight.w600),
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
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/requestIcon.svg',
              width: 24,
              height: 24,
            ),
            label: 'Requests',
          ),
        ],
        selectedItemColor: Color.fromARGB(255, 1, 37, 73),
      ),
    );
  }
}
