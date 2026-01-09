import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/features/checkout/controllers/checkout_controller.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/string_extension.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/features/checkout/widgets/payment_method_bottom_sheet.dart';

class PaymentSection extends StatelessWidget {
  final int? storeId;
  final bool isCashOnDeliveryActive;
  final bool isDigitalPaymentActive;
  final bool isWalletActive;
  final double total;
  final CheckoutController checkoutController;
  final bool isOfflinePaymentActive;
  const PaymentSection({
    super.key,
    this.storeId,
    required this.isCashOnDeliveryActive,
    required this.isDigitalPaymentActive,
    required this.isWalletActive,
    required this.total,
    required this.checkoutController,
    required this.isOfflinePaymentActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
              blurRadius: 10)
        ],
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      margin: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeExtraSmall),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
              storeId != null
                  ? 'payment_method'.tr
                  : 'choose_payment_method'.tr,
              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
          storeId == null && !ResponsiveHelper.isDesktop(context)
              ? InkWell(
                  onTap: () {
                    if (isCashOnDeliveryActive ||
                        isDigitalPaymentActive ||
                        isWalletActive ||
                        isOfflinePaymentActive) {
                      Get.bottomSheet(
                        PaymentMethodBottomSheet(
                          isCashOnDeliveryActive: isCashOnDeliveryActive,
                          isDigitalPaymentActive: isDigitalPaymentActive,
                          isWalletActive: isWalletActive,
                          storeId: storeId,
                          totalPrice: total,
                          isOfflinePaymentActive: isOfflinePaymentActive,
                        ),
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                      );
                    } else {
                      showCustomSnackBar('no_payment_method_found'.tr);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    child: Image.asset(Images.paymentSelect,
                        height: 20,
                        width: 20,
                        color: Theme.of(context).primaryColor),
                  ),
                )
              : const SizedBox(),
        ]),
        const SizedBox(height: Dimensions.paddingSizeDefault),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
            border: Border.all(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                width: 1),
          ),
          padding: const EdgeInsets.symmetric(
              vertical: Dimensions.paddingSizeSmall,
              horizontal: Dimensions.paddingSizeDefault),
          child: storeId != null
              ? checkoutController.paymentMethodIndex == 0
                  ? Row(children: [
                      Image.asset(
                        Images.cash,
                        width: 20,
                        height: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(
                          child: Text(
                        'cash_on_delivery'.tr,
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall),
                      )),
                      Text(
                        PriceConverter.convertPrice(total),
                        textDirection: TextDirection.ltr,
                        style: robotoBold.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: Theme.of(context).primaryColor),
                      )
                    ])
                  : const SizedBox()
              : InkWell(
                  onTap: () {
                    if (checkoutController.paymentMethodIndex == -1) {
                      if (isCashOnDeliveryActive ||
                          isDigitalPaymentActive ||
                          isWalletActive ||
                          isOfflinePaymentActive) {
                        if (ResponsiveHelper.isDesktop(context)) {
                          Get.dialog(Dialog(
                              backgroundColor: Colors.transparent,
                              child: PaymentMethodBottomSheet(
                                isCashOnDeliveryActive: isCashOnDeliveryActive,
                                isDigitalPaymentActive: isDigitalPaymentActive,
                                isWalletActive: isWalletActive,
                                storeId: storeId,
                                totalPrice: total,
                                isOfflinePaymentActive: isOfflinePaymentActive,
                              )));
                        } else {
                          Get.bottomSheet(
                            PaymentMethodBottomSheet(
                              isCashOnDeliveryActive: isCashOnDeliveryActive,
                              isDigitalPaymentActive: isDigitalPaymentActive,
                              isWalletActive: isWalletActive,
                              storeId: storeId,
                              totalPrice: total,
                              isOfflinePaymentActive: isOfflinePaymentActive,
                            ),
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                          );
                        }
                      } else {
                        showCustomSnackBar('no_payment_method_found'.tr);
                      }
                    }
                  },
                  child: Row(children: [
                    checkoutController.paymentMethodIndex != -1
                        ? Image.asset(
                            checkoutController.paymentMethodIndex == 0
                                ? Images.cash
                                : checkoutController.paymentMethodIndex == 1
                                    ? Images.wallet
                                    : checkoutController.paymentMethodIndex == 2
                                        ? Images.digitalPayment
                                        : Images.cash,
                            width: 20,
                            height: 20,
                            color: Theme.of(context).primaryColor,
                          )
                        : Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 20,
                            color: Theme.of(context).disabledColor,
                          ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(
                        child: Row(children: [
                      Builder(builder: (context) {
                        return Text(
                          checkoutController.paymentMethodIndex == 0
                              ? '${'cash_on_delivery'.tr} ${checkoutController.isPartialPay ? '(${'partial'.tr})' : ''}'
                              : checkoutController.paymentMethodIndex == 1 &&
                                      !checkoutController.isPartialPay
                                  ? 'wallet_payment'.tr
                                  : checkoutController.paymentMethodIndex == 2
                                      ? '${'digital_payment'.tr} (${checkoutController.digitalPaymentName?.replaceAll('_', ' ').toTitleCase() ?? ''} - ${checkoutController.isPartialPay ? 'partial'.tr : ''})'
                                      : checkoutController.paymentMethodIndex ==
                                              3
                                          ? '${'offline_payment'.tr}(${checkoutController.offlineMethodList![checkoutController.selectedOfflineBankIndex].methodName} - ${checkoutController.isPartialPay ? 'partial'.tr : ''})'
                                          : 'select_payment_method'.tr,
                          style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: checkoutController.paymentMethodIndex == -1
                                ? Theme.of(context).disabledColor
                                : Theme.of(context).primaryColor,
                          ),
                        );
                      }),
                      checkoutController.paymentMethodIndex == -1
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: Dimensions.paddingSizeExtraSmall),
                              child: Icon(Icons.warning_rounded,
                                  size: 14,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .error
                                      .withValues(alpha: 0.6)),
                            )
                          : const SizedBox(),
                    ])),
                    if (checkoutController.paymentMethodIndex != -1)
                      PriceConverter.convertAnimationPrice(
                        checkoutController.viewTotalPrice,
                        textStyle: robotoBold.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: Theme.of(context).primaryColor),
                      ),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    if (checkoutController.paymentMethodIndex != -1)
                      Icon(Icons.check_circle,
                          size: 20, color: Theme.of(context).primaryColor),
                  ]),
                ),
        ),
      ]),
    );
  }
}
