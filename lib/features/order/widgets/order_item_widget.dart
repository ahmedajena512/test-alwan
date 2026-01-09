import 'package:sixam_mart/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart/common/widgets/custom_card.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/order/domain/models/order_details_model.dart';
import 'package:sixam_mart/features/order/domain/models/order_model.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/util/app_colors.dart';
import 'package:sixam_mart/common/widgets/gradient_text.dart';

class OrderItemWidget extends StatelessWidget {
  final OrderModel order;
  final OrderDetailsModel orderDetails;
  const OrderItemWidget(
      {super.key, required this.order, required this.orderDetails});

  @override
  Widget build(BuildContext context) {
    String addOnText = '';
    for (var addOn in orderDetails.addOns!) {
      addOnText =
          '$addOnText${(addOnText.isEmpty) ? '' : ',  '}${addOn.name} (${addOn.quantity})';
    }

    String? variationText = '';
    if (orderDetails.variation!.isNotEmpty) {
      if (orderDetails.variation!.isNotEmpty) {
        List<String> variationTypes =
            orderDetails.variation![0].type!.split('-');
        if (variationTypes.length ==
            orderDetails.itemDetails!.choiceOptions!.length) {
          int index = 0;
          for (var choice in orderDetails.itemDetails!.choiceOptions!) {
            variationText =
                '${variationText!}${(index == 0) ? '' : ',  '}${choice.title} - ${variationTypes[index]}';
            index = index + 1;
          }
        } else {
          variationText = orderDetails.itemDetails!.variations![0].type;
        }
      }
    } else if (orderDetails.foodVariation!.isNotEmpty) {
      for (FoodVariation variation in orderDetails.foodVariation!) {
        variationText =
            '${variationText!}${variationText.isNotEmpty ? ', ' : ''}${variation.name} (';
        if (variation.variationValues != null) {
          for (VariationValue value in variation.variationValues!) {
            variationText =
                '${variationText!}${variationText.endsWith('(') ? '' : ', '}${value.level}';
          }
        }
        variationText = '${variationText!})';
      }
    }

    return CustomCard(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            child: CustomImage(
              height: 50,
              width: 50,
              fit: BoxFit.cover,
              image: '${orderDetails.imageFullUrl}',
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                    child: Text(
                  orderDetails.itemDetails!.name!,
                  style:
                      robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.mainGradient.colors
                          .map((c) => c.withValues(alpha: 0.1))
                          .toList(),
                      begin: AppColors.mainGradient.begin,
                      end: AppColors.mainGradient.end,
                    ),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: GradientText(
                    'x${orderDetails.quantity}',
                    gradient: AppColors.mainGradient,
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeExtraSmall),
                  ),
                ),
              ]),
              const SizedBox(height: 4),
              Row(children: [
                Expanded(
                    child: GradientText(
                  PriceConverter.convertPrice(orderDetails.price),
                  gradient: AppColors.mainGradient,
                  style:
                      robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                )),
                ((Get.find<SplashController>()
                                .configModel!
                                .moduleConfig!
                                .module!
                                .unit! &&
                            orderDetails.itemDetails!.unitType != null) ||
                        (Get.find<SplashController>()
                                .configModel!
                                .moduleConfig!
                                .module!
                                .vegNonVeg! &&
                            Get.find<SplashController>()
                                .configModel!
                                .toggleVegNonVeg!))
                    ? Get.find<SplashController>()
                            .getModuleConfig(order.moduleType)
                            .newVariation!
                        ? CustomAssetImageWidget(
                            orderDetails.itemDetails!.veg == 0
                                ? Images.nonVegImage
                                : Images.vegImage,
                            height: 11,
                            width: 11,
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeExtraSmall,
                                horizontal: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radiusSmall),
                              color: Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.1),
                            ),
                            child: Text(
                              orderDetails.itemDetails!.unitType ?? '',
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeExtraSmall,
                                  color: Theme.of(context).primaryColor),
                            ),
                          )
                    : const SizedBox(),
                SizedBox(
                    width: orderDetails.itemDetails!.isStoreHalalActive! &&
                            orderDetails.itemDetails!.isHalalItem!
                        ? Dimensions.paddingSizeExtraSmall
                        : 0),
                orderDetails.itemDetails!.isStoreHalalActive! &&
                        orderDetails.itemDetails!.isHalalItem!
                    ? const CustomAssetImageWidget(Images.halalTag,
                        height: 13, width: 13)
                    : const SizedBox(),
              ]),
            ]),
          ),
        ]),
        (Get.find<SplashController>()
                    .getModuleConfig(order.moduleType)
                    .addOn! &&
                addOnText.isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.only(
                    top: Dimensions.paddingSizeExtraSmall),
                child: Row(children: [
                  const SizedBox(width: 60),
                  Text('${'addons'.tr}: ',
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall)),
                  Flexible(
                      child: Text(addOnText,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).disabledColor,
                          ))),
                ]),
              )
            : const SizedBox(),
        variationText!.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(
                    top: Dimensions.paddingSizeExtraSmall),
                child: Row(children: [
                  const SizedBox(width: 60),
                  Text('${'variations'.tr}: ',
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall)),
                  Flexible(
                      child: Text(variationText,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).disabledColor,
                          ))),
                ]),
              )
            : const SizedBox(),
      ]),
    );
  }
}
