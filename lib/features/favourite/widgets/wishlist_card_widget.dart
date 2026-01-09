import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/features/favourite/controllers/favourite_controller.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_colors.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/discount_tag.dart';
import 'package:sixam_mart/common/widgets/not_available_widget.dart';
import 'package:sixam_mart/common/widgets/item_bottom_sheet.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistCardWidget extends StatelessWidget {
  final Item? item;
  final Store? store;
  final bool isStore;
  const WishlistCardWidget({
    super.key,
    this.item,
    this.store,
    this.isStore = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    bool isAvailable = false;

    if (isStore) {
      isAvailable = store!.open == 1 && store!.active!;
    } else {
      isAvailable = DateConverter.isAvailable(
        item!.availableTimeStarts,
        item!.availableTimeEnds,
      );
    }

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side - Heart and Plus buttons
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Heart icon - RED for favorite screen
              GetBuilder<FavouriteController>(
                builder: (favouriteController) {
                  return InkWell(
                    onTap: () {
                      if (isStore) {
                        favouriteController.removeFromFavouriteList(
                          store!.id,
                          true,
                        );
                      } else {
                        favouriteController.removeFromFavouriteList(
                          item!.id,
                          false,
                        );
                      }
                    },
                    child: Icon(
                      Icons.favorite,
                      size: 24,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 12),
              
              // Plus button (gradient)
              InkWell(
                onTap: () {
                  if (isStore) {
                    Get.toNamed(
                      RouteHelper.getStoreRoute(id: store!.id, page: 'store'),
                    );
                  } else {
                    ResponsiveHelper.isMobile(context)
                        ? Get.bottomSheet(
                            ItemBottomSheet(
                              itemId: item!.id!,
                              item: item,
                              inStorePage: false,
                              isCampaign: false,
                            ),
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                          )
                        : Get.dialog(
                            Dialog(
                              child: ItemBottomSheet(
                                itemId: item!.id!,
                                item: item,
                                inStorePage: false,
                              ),
                            ),
                          );
                  }
                },
                child: Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    gradient: AppColors.mainGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.green.withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(width: Dimensions.paddingSizeDefault),
          
          // Middle - Text content
          Expanded(
            child: InkWell(
              onTap: () {
                if (isStore) {
                  Get.toNamed(
                    RouteHelper.getStoreRoute(id: store!.id, page: 'store'),
                  );
                } else {
                  ResponsiveHelper.isMobile(context)
                      ? Get.bottomSheet(
                          ItemBottomSheet(
                            itemId: item!.id!,
                            item: item,
                            inStorePage: false,
                            isCampaign: false,
                          ),
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                        )
                      : Get.dialog(
                          Dialog(
                            child: ItemBottomSheet(
                              itemId: item!.id!,
                              item: item,
                              inStorePage: false,
                            ),
                          ),
                        );
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isStore ? store!.name! : item!.name!,
                    style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  if (!isStore && item!.storeName != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        item!.storeName!,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).disabledColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  // Price section
                  if (!isStore)
                    Row(
                      children: [
                        if (item!.discount! > 0)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              PriceConverter.convertPrice(item!.price),
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).disabledColor,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                        ShaderMask(
                          shaderCallback: (bounds) => AppColors
                              .mainGradient
                              .createShader(bounds),
                          child: Text(
                            PriceConverter.convertPrice(
                              item!.price,
                              discount: item!.discount,
                              discountType: item!.discountType,
                            ),
                            style: robotoBold.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  
                  if (isStore && store!.address != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        store!.address!,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          color: Theme.of(context).disabledColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: Dimensions.paddingSizeSmall),
          
          // Right side - Image
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.05),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  child: CustomImage(
                    image: isStore
                        ? '${store!.logoFullUrl}'
                        : '${item!.imageFullUrl}',
                    height: isDesktop ? 100 : 80,
                    width: isDesktop ? 100 : 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              if (!isStore)
                DiscountTag(
                  discount: item!.discount,
                  discountType: item!.discountType,
                ),

              if (!isAvailable)
                NotAvailableWidget(isStore: isStore),
            ],
          ),
        ],
      ),
    );
  }
}
