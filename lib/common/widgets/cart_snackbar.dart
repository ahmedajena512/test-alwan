import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/util/app_colors.dart';

void showCartSnackBar() {
  Get.closeCurrentSnackbar();
  Get.showSnackbar(GetSnackBar(
    backgroundColor: Colors.transparent,
    messageText: Container(
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 0)
        ],
        gradient: AppColors.mainGradient,
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Row(children: [
        const Icon(Icons.check_circle, color: Colors.white),
        const SizedBox(width: Dimensions.paddingSizeSmall),
        Expanded(
            child: Text('item_added_to_cart'.tr,
                style: robotoMedium.copyWith(color: Colors.white))),
        TextButton(
          onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
          child: Text('view_cart'.tr,
              style: robotoMedium.copyWith(
                  color: Colors.white, decoration: TextDecoration.underline)),
        ),
      ]),
    ),
    snackPosition: SnackPosition.TOP,
    margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
    borderRadius: Dimensions.radiusDefault,
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    reverseAnimationCurve: Curves.fastEaseInToSlowEaseOut,
    animationDuration: const Duration(milliseconds: 500),
    duration: const Duration(seconds: 3),
    snackStyle: SnackStyle.FLOATING,
    overlayBlur: 0.0,
    overlayColor: Colors.transparent,
  ));
}
