import 'package:sixam_mart/common/widgets/cart_count_view.dart';
import 'package:sixam_mart/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart/common/widgets/custom_favourite_widget.dart';
import 'package:sixam_mart/common/widgets/custom_ink_well.dart';
import 'package:sixam_mart/common/widgets/hover/text_hover.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/favourite/controllers/favourite_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/discount_tag.dart';
import 'package:sixam_mart/common/widgets/not_available_widget.dart';
import 'package:sixam_mart/common/widgets/organic_tag.dart';
import 'package:sixam_mart/features/store/screens/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemGridWidget extends StatelessWidget {
  final Item? item;
  final Store? store;
  final bool isStore;
  final int index;
  final int? length;
  final bool inStore;
  final bool isCampaign;
  final bool isFeatured;
  final bool fromCartSuggestion;

  const ItemGridWidget({
    super.key,
    required this.item,
    required this.isStore,
    required this.store,
    required this.index,
    required this.length,
    this.inStore = false,
    this.isCampaign = false,
    this.isFeatured = false,
    this.fromCartSuggestion = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isAvailable;
    double? discount;
    String? discountType;

    if (isStore) {
      discount = store!.discount != null ? store!.discount!.discount : 0;
      discountType =
          store!.discount != null ? store!.discount!.discountType : 'percent';
      isAvailable = store!.open == 1 && store!.active!;
    } else {
      discount = item!.discount;
      discountType = item!.discountType;
      isAvailable = DateConverter.isAvailable(
          item!.availableTimeStarts, item!.availableTimeEnds);
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)
            ],
          ),
          child: CustomInkWell(
            onTap: () {
              if (isStore) {
                if (store != null) {
                  Get.toNamed(
                    RouteHelper.getStoreRoute(id: store!.id, page: 'item'),
                    arguments: StoreScreen(store: store, fromModule: false),
                  );
                }
              } else {
                Get.find<ItemController>().navigateToItemPage(item, context,
                    inStore: inStore, isCampaign: isCampaign);
              }
            },
            radius: Dimensions.radiusDefault,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(Dimensions.radiusDefault),
                        topRight: Radius.circular(Dimensions.radiusDefault),
                      ),
                      child: CustomImage(
                        image:
                            '${isStore ? store != null ? store!.coverPhotoFullUrl : '' : item!.imageFullUrl}',
                        height: 120, // Mobile optimized height
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    DiscountTag(
                      discount: discount,
                      discountType: discountType,
                      freeDelivery: isStore ? store!.freeDelivery : false,
                    ),
                    isAvailable
                        ? const SizedBox()
                        : NotAvailableWidget(isStore: isStore),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GetBuilder<FavouriteController>(
                          builder: (favouriteController) {
                        bool isWished = isStore
                            ? favouriteController.wishStoreIdList
                                .contains(store!.id)
                            : favouriteController.wishItemIdList
                                .contains(item!.id);
                        return CustomFavouriteWidget(
                          isWished: isWished,
                          isStore: isStore,
                          store: store,
                          item: item,
                        );
                      }),
                    ),
                  ],
                ),

                // Details Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isStore ? store!.name! : item!.name!,
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                                height: Dimensions.paddingSizeExtraSmall),

                            Text(
                              isStore
                                  ? store!.address ?? ''
                                  : item!.storeName ?? '',
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                                color: Theme.of(context).disabledColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(
                                height: Dimensions.paddingSizeExtraSmall),

                            // Rating Row
                            Row(
                              children: [
                                Icon(Icons.star,
                                    size: 14,
                                    color: Theme.of(context).primaryColor),
                                const SizedBox(
                                    width: Dimensions.paddingSizeExtraSmall),
                                Text(
                                  isStore
                                      ? store!.avgRating!.toStringAsFixed(1)
                                      : item!.avgRating!.toStringAsFixed(1),
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall),
                                ),
                                const SizedBox(
                                    width: Dimensions.paddingSizeExtraSmall),
                                Text(
                                  '(${isStore ? store!.ratingCount : item!.ratingCount})',
                                  style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall,
                                      color: Theme.of(context).disabledColor),
                                ),
                                if (isStore && store!.distance != null) ...[
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  Text(
                                    '• ${(store!.distance! / 1000).toStringAsFixed(1)} ${'km'.tr}',
                                    style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeExtraSmall,
                                        color: Theme.of(context).disabledColor),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),

                        // Price and Add Button Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (!isStore)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                      PriceConverter.convertPrice(item!.price,
                                          discount: discount,
                                          discountType: discountType),
                                      style: robotoBold.copyWith(
                                          fontSize: Dimensions.fontSizeSmall),
                                    ),
                                  ),
                                  if (discount! > 0)
                                    Text(
                                      PriceConverter.convertPrice(item!.price),
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeExtraSmall,
                                        color: Theme.of(context).disabledColor,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                ],
                              ),
                            if (!isStore)
                              InkWell(
                                onTap: () {
                                  Get.find<ItemController>().navigateToItemPage(
                                      item, context,
                                      inStore: inStore, isCampaign: isCampaign);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF34D47F),
                                        Color(0xFF21C0E5)
                                      ], // Using hex codes directly or AppColors if available
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF34D47F)
                                            .withValues(alpha: 0.4),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(
                                      Dimensions.paddingSizeExtraSmall),
                                  child: const Icon(Icons.add,
                                      size: 20, color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
