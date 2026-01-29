import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/cart/controllers/cart_controller.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/util/app_colors.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';

class BottomCartWidget extends StatelessWidget {
  const BottomCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Get.width,
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall,
                vertical: Dimensions.paddingSizeSmall),
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 25,
                      offset: const Offset(0, -10),
                    )
                  ],
                  border: Border.all(
                      color: Theme.of(context)
                          .primaryColor
                          .withValues(alpha: 0.05)),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    textDirection: TextDirection.ltr,
                    children: [
                      Container(
                        width: 140,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: AppColors.mainGradient,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusLarge),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: CustomButton(
                          buttonText: 'view_cart'.tr,
                          color: Colors.transparent,
                          textColor: Colors.white,
                          iconColor: Colors.white,
                          transparent: true,
                          width: 140,
                          height: 50,
                          radius: Dimensions.radiusLarge,
                          icon: Get.find<LocalizationController>().isLtr
                              ? Icons.arrow_forward_rounded
                              : Icons.arrow_back_rounded,
                          onPressed: () =>
                              Get.toNamed(RouteHelper.getCartRoute()),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        textDirection: TextDirection.ltr,
                        children: [
                          Column(
                            crossAxisAlignment:
                                Get.find<LocalizationController>().isLtr
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${cartController.cartList.length} ${'items'.tr}',
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).disabledColor,
                                ),
                              ),
                              Text(
                                PriceConverter.convertPrice(
                                    cartController.calculationCart()),
                                style: robotoBold.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                                ),
                                textDirection: TextDirection.ltr,
                              ),
                            ],
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              gradient: AppColors.mainGradient,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withValues(alpha: 0.3),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                )
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 2.0), // Optical correction
                                  child: Icon(Icons.shopping_bag_outlined,
                                      color: Colors.white, size: 24),
                                ),
                                Positioned(
                                  top: -5,
                                  right: -5,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withValues(alpha: 0.2)),
                                    ),
                                    constraints: const BoxConstraints(
                                        minWidth: 18, minHeight: 18),
                                    child: Center(
                                      child: Text(
                                        '${cartController.cartList.length}',
                                        style: robotoBold.copyWith(
                                          fontSize: 9,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
          ),
        ],
      );
    });
  }
}
