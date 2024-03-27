import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:test_app/const/Appcolor.dart';
import 'package:test_app/pages/login/logincontroller.dart';

import '../../const/stringconst.dart';

class LogininView extends GetView<LoginController> {
  LogininView({Key? key}) : super(key: key);
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _singlechild(context),
      backgroundColor: AppColors.backgroundColor,
    );
  }

  _singlechild(context) {
    return Obx(
      () => (controller.loader.value)
          ? SingleChildScrollView(child: _loginoutline(context))
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  _loginoutline(context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 50)),
            _icon(context),
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            form(context)
          ],
        ),
      ),
    );
  }

  _icon(context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        Container(
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/acs_logo.svg',
            placeholderBuilder: (BuildContext context) =>
                Container(child: const CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }

  form(context) {
    return Form(
        key: formkey,
        child: Column(
          children: [
            _username(),
            _password(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            _button(context),
          ],
        ));
  }

  _username() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 30,
        top: 10,
        right: 30,
      ),
      child: Container(
        height: 70,
        child: Obx(
          () => TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "No Username Found";
              }
              return null;
            },
            cursorColor: AppColors.black,
            autofocus: true,
            maxLength: 30,
            onEditingComplete: () {
              controller.removetext();
            },
            onChanged: (value) {
              controller.updateDeleteText(value.isNotEmpty);
            },
            controller: controller.username,
            decoration: InputDecoration(
              fillColor: AppColors.white,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.stroke,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.appBar,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              labelText: Appstring.username,
              contentPadding: EdgeInsets.fromLTRB(15.0, 24.0, 15.0, 2.0),
              labelStyle: TextStyle(
                color: AppColors.stroke,
              ),
              suffixIcon: controller.deletetext.value
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        controller.username.text = "";
                        controller.updateDeleteText(false);
                      },
                    )
                  : null,
              suffixIconColor: AppColors.button,
            ),
          ),
        ),
      ),
    );
  }

  Widget _password() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15, top: 15),
      child: Obx(
        () => TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Password cannot be Empty";
            }
            return null;
          },
          obscureText: !controller.showpassword.value,
          controller: controller.password,
          onChanged: (value) {
            controller.updatePasswordText(value.isNotEmpty);
          },
          decoration: InputDecoration(
              fillColor: AppColors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: AppColors.appBar,
              )),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.stroke,
                ),
              ),
              labelText: Appstring.password,
              labelStyle: TextStyle(color: AppColors.stroke),
              contentPadding: EdgeInsets.fromLTRB(15.0, 4.0, 15.0, 2.0),
              suffixIconColor: AppColors.button,
              suffixIcon: controller.hasPasswordText.value
                  ? IconButton(
                      onPressed: () {
                        controller.togglePasswordVisibility();
                      },
                      icon: Icon(controller.showpassword.value
                          ? Icons.visibility
                          : Icons.visibility_off),
                    )
                  : null),
        ),
      ),
    );
  }

  _button(context) {
    return ElevatedButton(
      onPressed: () {
        if (formkey.currentState!.validate()) {
          controller.formsubmit(
              controller.username.text, controller.password.text);
        }
      },
      child: Text(Appstring.loginButton),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.button,
        foregroundColor: AppColors.white,
        fixedSize: Size(MediaQuery.of(context).size.width * 0.85,
            MediaQuery.of(context).size.height * 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
      ),
    );
  }
}
