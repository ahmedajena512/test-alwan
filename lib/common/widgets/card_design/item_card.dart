import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart/common/widgets/custom_ink_well.dart';
import 'package:sixam_mart/common/widgets/hover/text_hover.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/add_favourite_view.dart';
import 'package:sixam_mart/common/widgets/cart_count_view.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/discount_tag.dart';
import 'package:sixam_mart/common/widgets/hover/on_hover.dart';
import 'package:sixam_mart/common/widgets/not_available_widget.dart';
import 'package:sixam_mart/common/widgets/organic_tag.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final bool isPopularItem;
  final bool isFood;
  final bool isShop;
  final bool isPopularItemCart;
  final int? index;
  const ItemCard(
      {super.key,
      required this.item,
      this.isPopularItem = false,
      required this.isFood,
      required this.isShop,
      this.isPopularItemCart = false,
      this.index});

  @override
  Widget build(BuildContext context) {
    double? discount = item.discount;
    String? discountType = item.discountType;

    return OnHover(
      isItem: true,
      child: Stack(children: [
        Container(
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            color: Theme.of(context).cardColor,
          ),
          child: CustomInkWell(
            onTap: () =>
                Get.find<ItemController>().navigateToItemPage(item, context),
            radius: Dimensions.radiusLarge,
            child: TextHover(
              builder: (isHovered) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Stack(children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: isPopularItem
                                    ? Dimensions.paddingSizeExtraSmall
                                    : 0,
                                left: isPopularItem
                                    ? Dimensions.paddingSizeExtraSmall
                                    : 0,
                                right: isPopularItem
                                    ? Dimensions.paddingSizeExtraSmall
                                    : 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(
                                    Dimensions.radiusLarge),
                                topRight: const Radius.circular(
                                    Dimensions.radiusLarge),
                                bottomLeft: Radius.circular(
                                    isPopularItem ? Dimensions.radiusLarge : 0),
                                bottomRight: Radius.circular(
                                    isPopularItem ? Dimensions.radiusLarge : 0),
                              ),
                              child: CustomImage(
                                isHovered: isHovered,
                                placeholder: Images.placeholder,
                                image: '${item.imageFullUrl}',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                          AddFavouriteView(
                            item: item,
                          ),
                          item.isStoreHalalActive! && item.isHalalItem!
                              ? const Positioned(
                                  top: 40,
                                  right: 15,
                                  child: CustomAssetImageWidget(
                                    Images.halalTag,
                                    height: 20,
                                    width: 20,
                                  ),
                                )
                              : const SizedBox(),
                          DiscountTag(
                            discount: discount,
                            discountType: discountType,
                            freeDelivery: false,
                          ),
                          OrganicTag(item: item, placeInImage: false),
                          (item.stock != null && item.stock! < 0)
                              ? Positioned(
                                  bottom: 10,
                                  left: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: Dimensions.paddingSizeSmall,
                                        vertical:
                                            Dimensions.paddingSizeExtraSmall),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withValues(alpha: 0.5),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(
                                            Dimensions.radiusLarge),
                                        bottomRight: Radius.circular(
                                            Dimensions.radiusLarge),
                                      ),
                                    ),
                                    child: Text('out_of_stock'.tr,
                                        style: robotoRegular.copyWith(
                                            color: Theme.of(context).cardColor,
                                            fontSize:
                                                Dimensions.fontSizeSmall)),
                                  ),
                                )
                              : const SizedBox(),
                          Get.find<ItemController>().isAvailable(item)
                              ? const SizedBox()
                              : NotAvailableWidget(
                                  radius: Dimensions.radiusLarge,
                                  isAllSideRound: isPopularItem),
                        ]),
                      ),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: Dimensions.paddingSizeSmall,
                              right: isShop ? 0 : Dimensions.paddingSizeSmall,
                              top: Dimensions.paddingSizeSmall,
                              bottom: isShop ? 0 : Dimensions.paddingSizeSmall),
                          child: Stack(clipBehavior: Clip.none, children: [
                            Align(
                              alignment: isPopularItem
                                  ? Alignment.center
                                  : Alignment.centerLeft,
                              child: Column(
                                  crossAxisAlignment: isPopularItem
                                      ? CrossAxisAlignment.center
                                      : CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    (isFood || isShop)
                                        ? Text(item.storeName ?? '',
                                            style: robotoRegular.copyWith(
                                                color: Theme.of(context)
                                                    .disabledColor),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis)
                                        : Text(item.name ?? '',
                                            style: robotoBold,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis),

                                    (isFood || isShop)
                                        ? Flexible(
                                            child: Text(
                                              item.name ?? '',
                                              style: robotoBold,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        : item.ratingCount! > 0
                                            ? Row(
                                                mainAxisAlignment: isPopularItem
                                                    ? MainAxisAlignment.center
                                                    : MainAxisAlignment.start,
                                                children: [
                                                    Icon(Icons.star,
                                                        size: 14,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                    const SizedBox(
                                                        width: Dimensions
                                                            .paddingSizeExtraSmall),
                                                    Text(
                                                        item.avgRating!
                                                            .toStringAsFixed(1),
                                                        style: robotoRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall)),
                                                    const SizedBox(
                                                        width: Dimensions
                                                            .paddingSizeExtraSmall),
                                                    Text(
                                                        "(${item.ratingCount})",
                                                        style: robotoRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor)),
                                                  ])
                                            : const SizedBox(),

                                    // showUnitOrRattings(context);
                                    (isFood || isShop)
                                        ? item.ratingCount! > 0
                                            ? Row(
                                                mainAxisAlignment: isPopularItem
                                                    ? MainAxisAlignment.center
                                                    : MainAxisAlignment.start,
                                                children: [
                                                    Icon(Icons.star,
                                                        size: 14,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                    const SizedBox(
                                                        width: Dimensions
                                                            .paddingSizeExtraSmall),
                                                    Text(
                                                        item.avgRating!
                                                            .toStringAsFixed(1),
                                                        style: robotoRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall)),
                                                    const SizedBox(
                                                        width: Dimensions
                                                            .paddingSizeExtraSmall),
                                                    Text(
                                                        "(${item.ratingCount})",
                                                        style: robotoRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor)),
                                                  ])
                                            : const SizedBox()
                                        : (Get.find<SplashController>()
                                                    .configModel!
                                                    .moduleConfig!
                                                    .module!
                                                    .unit! &&
                                                item.unitType != null)
                                            ? Text(
                                                '(${item.unitType ?? ''})',
                                                style: robotoRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeExtraSmall,
                                                    color: Theme.of(context)
                                                        .hintColor),
                                              )
                                            : const SizedBox(),

                                    // Price and Add Button Row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        // Price Column
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              discount != null && discount > 0
                                                  ? Text(
                                                      PriceConverter.convertPrice(
                                                          Get.find<
                                                                  ItemController>()
                                                              .getStartingPrice(
                                                                  item)),
                                                      style:
                                                          robotoMedium.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeExtraSmall,
                                                        color: Theme.of(context)
                                                            .disabledColor,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                      ),
                                                      textDirection:
                                                          TextDirection.ltr,
                                                    )
                                                  : const SizedBox(),
                                              ShaderMask(
                                                shaderCallback: (bounds) {
                                                  return const LinearGradient(
                                                    colors: [
                                                      Color(0xFF34D47F),
                                                      Color(0xFF21C0E5)
                                                    ],
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                  ).createShader(bounds);
                                                },
                                                blendMode: BlendMode.srcIn,
                                                child: Text(
                                                  PriceConverter.convertPrice(
                                                    Get.find<ItemController>()
                                                        .getStartingPrice(item),
                                                    discount: discount,
                                                    discountType: discountType,
                                                  ),
                                                  textDirection:
                                                      TextDirection.ltr,
                                                  style: robotoBold.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeLarge,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Add Button
                                        isShop ||
                                                Get.find<ItemController>()
                                                    .isAvailable(item)
                                            ? CartCountView(
                                                item: item,
                                                index: index,
                                                child: Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                        const LinearGradient(
                                                      colors: [
                                                        Color(0xFF34D47F),
                                                        Color(0xFF21C0E5)
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimensions
                                                                .radiusLarge),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: const Color(
                                                                0xFF34D47F)
                                                            .withValues(
                                                                alpha: 0.3),
                                                        blurRadius: 8,
                                                        offset:
                                                            const Offset(0, 4),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Icon(
                                                    isPopularItemCart
                                                        ? Icons
                                                            .add_shopping_cart
                                                        : Icons.add,
                                                    color: Colors.white,
                                                    size: 22,
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ]),
                            ),
                          ]),
                        ),
                      ),
                    ]);
              },
            ),
          ),
        ),
      ]),
    );
  }
}
