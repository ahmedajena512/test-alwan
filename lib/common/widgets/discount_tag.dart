import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiscountTag extends StatelessWidget {
  final double? discount;
  final String? discountType;
  final double fromTop;
  final double? fontSize;
  final bool inLeft;
  final bool? freeDelivery;
  final bool? isFloating;
  final bool? fromTaxi;
  final EdgeInsets? padding;
  const DiscountTag({
    super.key,
    required this.discount,
    required this.discountType,
    this.fromTop = 10,
    this.fontSize,
    this.freeDelivery = false,
    this.inLeft = true,
    this.isFloating = true,
    this.fromTaxi = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    bool isRightSide =
        Get.find<SplashController>().configModel!.currencySymbolDirection ==
            'right';
    String currencySymbol =
        Get.find<SplashController>().configModel!.currencySymbol!;

    return (discount! > 0 || freeDelivery!)
        ? Positioned(
            top: fromTop,
            left: inLeft
                ? isFloating!
                    ? Dimensions.paddingSizeSmall
                    : 0
                : null,
            right: inLeft ? null : 0,
            child: Container(
              padding: padding ??
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF34D47F), Color(0xFF21C0E5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: fromTaxi!
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(Dimensions.radiusDefault),
                        bottomRight: Radius.circular(Dimensions.radiusDefault))
                    : BorderRadius.circular(Dimensions.radiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF34D47F).withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                discount! > 0
                    ? '${(isRightSide || discountType == 'percent') ? '' : currencySymbol}$discount${discountType == 'percent' ? '%' : isRightSide ? currencySymbol : ''} ${'off'.tr}'
                    : 'free_delivery'.tr,
                style: robotoBold.copyWith(
                  color: Colors.white,
                  fontSize: fontSize ??
                      (ResponsiveHelper.isMobile(context) ? 12 : 14),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        : const SizedBox();
  }
}
