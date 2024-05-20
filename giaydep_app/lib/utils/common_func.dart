import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import '../model/shoe_type.dart';
import '../view/admin/admin_root_screen.dart';
import '../view/common_view/profile_screen.dart';
import '../view/customer/customer_home/customer_root_screen.dart';

class CommonFunc {
  static void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 12.0);
  }

  static void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.circle
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = Colors.grey
      ..indicatorSize = 32.0
      ..radius = 12.0
      ..lineWidth = 2.0
      ..progressColor = Colors.yellow
      ..indicatorColor = Colors.white
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  static void goToCustomerRootScreen() {
    Navigator.pushReplacement(
      navigationKey.currentContext!,
      MaterialPageRoute(builder: (context) => CustomerRootScreen()),
    );
  }

  static void goToAdminRootScreen() {
    print("go to admin root");
    Navigator.pushReplacement(
      navigationKey.currentContext!,
      MaterialPageRoute(builder: (context) => AdminRootScreen()),
    );
  }

  static void goToProfileScreen() {
    Navigator.push(
      navigationKey.currentContext!,
      MaterialPageRoute(builder: (context) => ProfileScreen()),
    );
  }

  static String getSenDaNameByType(String sendaType) {
    switch (sendaType) {
      case "ca_phe":
        return "Cà phê";
      case "tra_sua":
        return "Trà sữa";
      case "nuoc_ep":
        return "Nước ép";
      case "soda":
        return "Soda";
      default:
        return "Khác";
    }
  }

  static ShoeType getShoeTypeByName(String shoeType) {
    switch (shoeType) {
      case "ca_phe":
        return ShoeType.ca_phe;
      case "tra_sua":
        return ShoeType.tra_sua;
      case "nuoc_ep":
        return ShoeType.nuoc_ep;
      case "soda":
        return ShoeType.soda;
      default:
        return ShoeType.khac;
    }
  }

  static String getUsernameByEmail(String? email) {
    if (email == null) {
      return "Unknown username";
    }
    return email.split("@").first;
  }

  static String getOrderStatusName(String status) {
    switch (status) {
      case "NEW":
        return "Mới tạo";
      case "PROCESSING":
        return "Đang xử lý";
      case "DONE":
        return "Đã giao";
      case "CANCEL":
        return "Đã huỷ";
      default:
        return "Mới tạo";
    }
  }

  static Color getOrderStatusColor(String status) {
    switch (status) {
      case "NEW":
        return Colors.black;
      case "PROCESSING":
        return Colors.blueAccent;
      case "DONE":
        return Colors.green;
      default:
        return Colors.black;
    }
  }
}
