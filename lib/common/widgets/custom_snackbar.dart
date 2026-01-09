import 'package:sixam_mart/common/widgets/coustom_toast.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackBar(String? message,
    {bool isError = true,
    bool getXSnackBar = false,
    int? showDuration,
    SnackPosition snackPosition = SnackPosition.TOP}) {
  if (message != null && message.isNotEmpty) {
    if (getXSnackBar) {
      Get.closeCurrentSnackbar();
      Get.showSnackbar(GetSnackBar(
        backgroundColor: Colors.transparent,
        messageText: CustomToast(text: message, isError: isError),
        maxWidth: 500,
        duration: Duration(seconds: showDuration ?? 3),
        snackStyle: SnackStyle.FLOATING,
        snackPosition: snackPosition,
        margin: EdgeInsets.only(
            left: Dimensions.paddingSizeSmall,
            right: Dimensions.paddingSizeSmall,
            bottom: snackPosition == SnackPosition.BOTTOM
                ? 100
                : Dimensions.paddingSizeSmall,
            top: snackPosition == SnackPosition.TOP
                ? Dimensions.paddingSizeSmall
                : 0),
        borderRadius: 50,
        isDismissible: true,
        dismissDirection: snackPosition == SnackPosition.TOP
            ? DismissDirection.up
            : DismissDirection.down,
        forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
        reverseAnimationCurve: Curves.fastEaseInToSlowEaseOut,
        animationDuration: const Duration(milliseconds: 500),
      ));
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        dismissDirection: DismissDirection.endToStart,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        content: CustomToast(text: message, isError: isError),
        duration: Duration(seconds: showDuration ?? 2),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }
}
