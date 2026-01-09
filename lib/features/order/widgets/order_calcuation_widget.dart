import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/util/app_colors.dart';
import 'package:sixam_mart/common/widgets/gradient_text.dart';
import 'package:sixam_mart/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart/common/widgets/custom_card.dart';
import 'package:sixam_mart/features/order/widgets/support_reason_bottom_sheet.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/order/controllers/order_controller.dart';
import 'package:sixam_mart/features/order/domain/models/order_model.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/features/order/widgets/order_item_widget.dart';
import 'package:sixam_mart/features/parcel/widgets/details_widget.dart';

class OrderCalculationWidget extends StatelessWidget {
  final OrderController orderController;
  final OrderModel order;
  final bool ongoing;
  final bool parcel;
  final bool prescriptionOrder;
  final double deliveryCharge;
  final double itemsPrice;
  final double discount;
  final double couponDiscount;
  final double tax;
  final double addOns;
  final double dmTips;
  final bool taxIncluded;
  final double subTotal;
  final double total;
  final Widget bottomView;
  final double extraPackagingAmount;
  final double referrerBonusAmount;
  final Function timerCancel;
  final Function startApiCall;

  const OrderCalculationWidget({
    super.key,
    required this.orderController,
    required this.order,
    required this.ongoing,
    required this.parcel,
    required this.prescriptionOrder,
    required this.deliveryCharge,
    required this.itemsPrice,
    required this.discount,
    required this.couponDiscount,
    required this.tax,
    required this.addOns,
    required this.dmTips,
    required this.taxIncluded,
    required this.subTotal,
    required this.total,
    required this.bottomView,
    required this.extraPackagingAmount,
    required this.referrerBonusAmount,
    required this.timerCancel,
    required this.startApiCall,
  });

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Column(children: [
      Padding(
        padding: EdgeInsets.only(
            top: isDesktop
                ? Dimensions.paddingSizeExtraLarge
                : Dimensions.paddingSizeSmall),
        child: CustomCard(
          borderRadius: isDesktop ? Dimensions.radiusDefault : 0,
          isBorder: false,
          padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            (isDesktop && orderController.orderDetails!.isNotEmpty)
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(Dimensions.radiusDefault)),
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.05),
                            blurRadius: 10)
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeLarge,
                        vertical: Dimensions.paddingSizeSmall),
                    child: parcel
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                DetailsWidget(
                                    title: 'sender_details'.tr,
                                    address: order.deliveryAddress),
                                const SizedBox(
                                    height: Dimensions.paddingSizeLarge),
                                DetailsWidget(
                                    title: 'receiver_details'.tr,
                                    address: order.receiverDetails),
                              ])
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      orderController.orderDetails!.length,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: Dimensions.paddingSizeSmall),
                                  itemBuilder: (context, index) {
                                    return OrderItemWidget(
                                        order: order,
                                        orderDetails: orderController
                                            .orderDetails![index]);
                                  },
                                ),
                              ]),
                  )
                : const SizedBox(),
            SizedBox(
                height: parcel && orderController.orderDetails!.isNotEmpty
                    ? Dimensions.paddingSizeLarge
                    : 0),
            SizedBox(
                height: (order.orderAttachmentFullUrl != null &&
                        order.orderAttachmentFullUrl!.isNotEmpty)
                    ? Dimensions.paddingSizeLarge
                    : 0),
            Text('billing_summary'.tr,
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            _billingItem(
                context,
                parcel ? 'delivery_fee'.tr : 'item_price'.tr,
                parcel
                    ? PriceConverter.convertPrice(order.deliveryCharge)
                    : PriceConverter.convertPrice(itemsPrice)),
            if (!parcel &&
                Get.find<SplashController>()
                    .getModuleConfig(order.moduleType)
                    .addOn!)
              _billingItem(context, 'addons'.tr,
                  '(+) ${PriceConverter.convertPrice(addOns)}'),
            if (!parcel && discount > 0)
              _billingItem(context, 'discount'.tr,
                  '(-) ${PriceConverter.convertPrice(discount)}'),
            if (!parcel && couponDiscount > 0)
              _billingItem(context, 'coupon_discount'.tr,
                  '(-) ${PriceConverter.convertPrice(couponDiscount)}'),
            if (!parcel && referrerBonusAmount > 0)
              _billingItem(context, 'referral_discount'.tr,
                  '(+) ${PriceConverter.convertPrice(referrerBonusAmount)}'),
            if (order.additionalCharge != null && order.additionalCharge! > 0)
              _billingItem(
                  context,
                  Get.find<SplashController>()
                      .configModel!
                      .additionalChargeName!,
                  '(+) ${PriceConverter.convertPrice(order.additionalCharge)}'),
            if ((tax != 0) && !taxIncluded)
              _billingItem(context, 'vat_tax'.tr,
                  '(+) ${PriceConverter.convertPrice(tax)}'),
            if (dmTips > 0)
              _billingItem(context, 'delivery_man_tips'.tr,
                  '(+) ${PriceConverter.convertPrice(dmTips)}'),
            if (extraPackagingAmount > 0)
              _billingItem(context, 'extra_packaging'.tr,
                  '(+) ${PriceConverter.convertPrice(extraPackagingAmount)}'),
            if (!parcel && deliveryCharge > 0)
              _billingItem(context, 'delivery_fee'.tr,
                  '(+) ${PriceConverter.convertPrice(deliveryCharge)}')
            else if (!parcel && deliveryCharge == 0)
              _billingItem(context, 'delivery_fee'.tr, 'free'.tr,
                  isPrimary: true),
            Divider(
                height: Dimensions.paddingSizeLarge,
                color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
            order.paymentMethod == 'partial_payment'
                ? Column(children: [
                    Divider(
                        height: Dimensions.paddingSizeLarge,
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.1)),
                    _billingItem(context, 'total_amount'.tr,
                        PriceConverter.convertPrice(total),
                        isBold: true, isPrimary: true),
                    _billingItem(
                        context,
                        'paid_by_wallet'.tr,
                        PriceConverter.convertPrice(
                            order.payments?[0].amount ?? 0)),
                    _billingItem(
                        context,
                        '${order.payments?[1].paymentStatus == 'paid' ? 'paid_by'.tr : 'due_amount'.tr} (${order.payments?[1].paymentMethod?.tr})',
                        PriceConverter.convertPrice(
                            order.payments?[1].amount ?? 0),
                        isBold: true),
                  ])
                : Row(children: [
                    GradientText(
                      'total_amount'.tr,
                      gradient: AppColors.mainGradient,
                      style: robotoBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge),
                    ),
                    taxIncluded
                        ? Text(' ${'vat_tax_inc'.tr}',
                            style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              color: Theme.of(context).disabledColor,
                            ))
                        : const SizedBox(),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    if (parcel)
                      Container(
                        decoration: BoxDecoration(
                          color: order.paymentStatus == 'paid'
                              ? Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.2)
                              : Theme.of(context)
                                  .colorScheme
                                  .error
                                  .withValues(alpha: 0.2),
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusSmall),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeExtraSmall,
                              vertical: 2),
                          child: Text(
                            order.paymentStatus == 'paid'
                                ? 'paid'.tr
                                : 'due'.tr,
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              color: order.paymentStatus == 'paid'
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ),
                    const Expanded(child: SizedBox()),
                    GradientText(
                      PriceConverter.convertPrice(total),
                      gradient: AppColors.mainGradient,
                      style: robotoBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge),
                    ),
                  ]),
            SizedBox(
                height: isDesktop
                    ? Dimensions.paddingSizeLarge
                    : Dimensions.paddingSizeSmall),
            order.parcelCancellation?.returnFee != null &&
                    order.parcelCancellation!.returnFee! > 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Text('return_fee'.tr,
                                    style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall)),
                                const SizedBox(
                                    width: Dimensions.paddingSizeExtraSmall),
                                Container(
                                  decoration: BoxDecoration(
                                    color: order.parcelCancellation!
                                                .returnFeePaymentStatus ==
                                            'paid'
                                        ? Theme.of(context)
                                            .primaryColor
                                            .withValues(alpha: 0.2)
                                        : Theme.of(context)
                                            .colorScheme
                                            .error
                                            .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSmall),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.paddingSizeExtraSmall,
                                        vertical: 2),
                                    child: Text(
                                      order.parcelCancellation!
                                                  .returnFeePaymentStatus ==
                                              'paid'
                                          ? 'paid'.tr
                                          : 'due'.tr,
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: order.parcelCancellation!
                                                    .returnFeePaymentStatus ==
                                                'paid'
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context)
                                                .colorScheme
                                                .error,
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              Text(
                                  '(+) ${PriceConverter.convertPrice(order.parcelCancellation?.returnFee)}',
                                  style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall),
                                  textDirection: TextDirection.ltr),
                            ]),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeExtraSmall),
                          child: Divider(
                              thickness: 1,
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.2)),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('total'.tr, style: robotoBold),
                              Text(
                                  PriceConverter.convertPrice(total +
                                      order.parcelCancellation!.returnFee!),
                                  style: robotoBold,
                                  textDirection: TextDirection.ltr),
                            ]),
                      ])
                : const SizedBox(),
            order.parcelCancellation?.returnFee != null &&
                    order.parcelCancellation!.returnFee! > 0
                ? SizedBox(
                    height: isDesktop
                        ? Dimensions.paddingSizeDefault
                        : Dimensions.paddingSizeSmall)
                : SizedBox(),
            isDesktop ? bottomView : const SizedBox(),
            SizedBox(height: isDesktop ? Dimensions.paddingSizeDefault : 0),
            isDesktop && AuthHelper.isLoggedIn()
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () async {
                          if (isDesktop) {
                            await Get.dialog(Dialog(
                                child: SupportReasonBottomSheet(
                              orderId: order.id!,
                              timerCancel: timerCancel,
                              startApiCall: startApiCall,
                            )));
                          } else {
                            await Get.bottomSheet(
                              SupportReasonBottomSheet(
                                orderId: order.id!,
                                timerCancel: timerCancel,
                                startApiCall: startApiCall,
                              ),
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                            );
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomAssetImageWidget(Images.chatSupport,
                                height: 20, width: 20),
                            const SizedBox(
                                width: Dimensions.paddingSizeExtraSmall),
                            Flexible(
                              child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: '${'message_to'.tr} ',
                                      style: robotoMedium.copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color),
                                    ),
                                    TextSpan(
                                      text: Get.find<SplashController>()
                                          .configModel!
                                          .businessName,
                                      style: robotoMedium.copyWith(
                                          color: Colors.blue,
                                          fontSize: Dimensions.fontSizeDefault,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ]),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ]),
        ),
      ),
      !isDesktop && AuthHelper.isLoggedIn()
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () async {
                  if (isDesktop) {
                    await Get.dialog(Dialog(
                        child: SupportReasonBottomSheet(
                      orderId: order.id!,
                      timerCancel: timerCancel,
                      startApiCall: startApiCall,
                    )));
                  } else {
                    await Get.bottomSheet(
                      SupportReasonBottomSheet(
                        orderId: order.id!,
                        timerCancel: timerCancel,
                        startApiCall: startApiCall,
                      ),
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                    );
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomAssetImageWidget(Images.chatSupport,
                        height: 20, width: 20),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    Flexible(
                      child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: '${'message_to'.tr} ',
                              style: robotoMedium.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color),
                            ),
                            TextSpan(
                              text: Get.find<SplashController>()
                                  .configModel!
                                  .businessName,
                              style: robotoMedium.copyWith(
                                  color: Colors.blue,
                                  fontSize: Dimensions.fontSizeDefault,
                                  decoration: TextDecoration.underline),
                            ),
                          ]),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox(),
    ]);
  }

  Widget _billingItem(BuildContext context, String title, String value,
      {bool isBold = false, bool isPrimary = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title,
            style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: isPrimary ? null : Theme.of(context).disabledColor)),
        isPrimary
            ? GradientText(
                value,
                gradient: AppColors.mainGradient,
                style: robotoMedium.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                ),
              )
            : Text(value,
                style: robotoMedium.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                ),
                textDirection: TextDirection.ltr),
      ]),
    );
  }
}
