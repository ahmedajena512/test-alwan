import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart/features/store/controllers/store_controller.dart';
import 'package:sixam_mart/util/app_colors.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/common/widgets/add_favourite_view.dart';
import 'package:sixam_mart/common/widgets/custom_ink_well.dart';
import 'package:sixam_mart/common/widgets/hover/text_hover.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/discount_tag.dart';
import 'package:sixam_mart/common/widgets/hover/on_hover.dart';
import 'package:sixam_mart/common/widgets/not_available_widget.dart';
import 'package:sixam_mart/features/store/screens/store_screen.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/features/location/domain/models/zone_response_model.dart';

class StoreCardWidget extends StatelessWidget {
  final Store? store;
  const StoreCardWidget({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    bool isAvailable = store!.open == 1 && store!.active!;
    double distance = Get.find<StoreController>().getRestaurantDistance(
      LatLng(
        double.parse(store!.latitude!),
        double.parse(store!.longitude!),
      ),
    );
    double deliveryCharge = _calculateDeliveryCharge(store!, distance);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
            color: Theme.of(context).disabledColor.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: CustomInkWell(
        onTap: () {
          if (store != null) {
            if (Get.find<SplashController>().moduleList != null) {
              for (ModuleModel module
                  in Get.find<SplashController>().moduleList!) {
                if (module.id == store!.moduleId) {
                  Get.find<SplashController>().setModule(module);
                  break;
                }
              }
            }
            Get.toNamed(
              RouteHelper.getStoreRoute(id: store!.id, page: 'item'),
              arguments: StoreScreen(store: store, fromModule: false),
            );
          }
        },
        radius: Dimensions.radiusDefault,
        child: Column(
          children: [
            // Image Section with Overlays
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(Dimensions.radiusDefault)),
                  child: ColorFiltered(
                    colorFilter: isAvailable
                        ? const ColorFilter.mode(
                            Colors.transparent, BlendMode.multiply)
                        : const ColorFilter.mode(
                            Colors.grey, BlendMode.saturation),
                    child: CustomImage(
                      image: '${store!.coverPhotoFullUrl}',
                      fit: BoxFit.cover,
                      height: 135,
                      width: double.infinity,
                    ),
                  ),
                ),

                // Overlay Gradient
                if (isAvailable)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(Dimensions.radiusDefault)),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                // Closed Status Overlay
                if (!isAvailable)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(Dimensions.radiusDefault)),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusLarge),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.lock_clock,
                                  color: Theme.of(context).colorScheme.error,
                                  size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'closed_now'.tr.toUpperCase(),
                                style: robotoBold.copyWith(
                                    color: Colors.white,
                                    fontSize: Dimensions.fontSizeSmall,
                                    letterSpacing: 0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                // Favorite Button
                AddFavouriteView(
                  top: 10,
                  right: 10,
                  item: null,
                  storeId: store!.id,
                ),
              ],
            ),

            // Content Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    // Logo and Header Row
                    Transform.translate(
                      offset: const Offset(0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Store Logo
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radiusSmall),
                              border: Border.all(
                                  color: Theme.of(context).cardColor, width: 3),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2)),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radiusSmall - 2),
                              child: CustomImage(
                                image: '${store!.logoFullUrl}',
                                fit: BoxFit.cover,
                                height: 45,
                                width: 45,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Name and Address
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    store!.name ?? '',
                                    style: robotoBold.copyWith(
                                        fontSize: Dimensions.fontSizeLarge),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    store!.address ?? '',
                                    style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Theme.of(context).disabledColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Delivery Price Tag
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.05),
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radiusSmall),
                              border: Border.all(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withValues(alpha: 0.2)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'delivery'.tr.toUpperCase(),
                                  style: robotoBold.copyWith(
                                      fontSize: 8,
                                      color: Theme.of(context).disabledColor),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  store!.freeDelivery!
                                      ? 'free'.tr
                                      : PriceConverter.convertPrice(
                                          deliveryCharge),
                                  style: robotoBold.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                    // Divider
                    Divider(
                        height: 1,
                        color: Theme.of(context)
                            .disabledColor
                            .withValues(alpha: 0.1)),
                    const SizedBox(height: 8),

                    // Footer Pills (Time, Rating, Distance)
                    Row(
                      children: [
                        // Time Pill
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .disabledColor
                                  .withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radiusDefault),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) => AppColors
                                      .mainGradient
                                      .createShader(bounds),
                                  child: const Icon(Icons.access_time_filled,
                                      size: 14, color: Colors.white),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  store!.deliveryTime ?? '',
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Rating Pill
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .disabledColor
                                  .withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radiusDefault),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) => AppColors
                                      .mainGradient
                                      .createShader(bounds),
                                  child: const Icon(Icons.star,
                                      size: 14, color: Colors.white),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  store!.avgRating?.toStringAsFixed(1) ?? '0.0',
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Distance Pill
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .disabledColor
                                  .withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radiusDefault),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) => AppColors
                                      .mainGradient
                                      .createShader(bounds),
                                  child: const Icon(Icons.location_on,
                                      size: 14, color: Colors.white),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${distance > 100 ? '100+' : distance.toStringAsFixed(2)} ${'km'.tr}',
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  double _calculateDeliveryCharge(Store store, double distance) {
    double deliveryCharge = 0;

    Pivot? moduleData;
    if (Get.find<SplashController>().moduleList != null) {
      for (ModuleModel module in Get.find<SplashController>().moduleList!) {
        if (module.id == store.moduleId) {
          if (AddressHelper.getUserAddressFromSharedPref()!.zoneData != null) {
            for (ZoneData zData
                in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
              for (Modules m in zData.modules!) {
                if (m.id == module.id && m.pivot!.zoneId == store.zoneId) {
                  moduleData = m.pivot;
                  break;
                }
              }
            }
          }
          break;
        }
      }
    }

    double perKmCharge = 0;
    double minimumCharge = 0;
    double? maximumCharge = 0;

    if (store.selfDeliverySystem == 1) {
      perKmCharge = store.perKmShippingCharge ?? 0;
      minimumCharge = store.minimumShippingCharge ?? 0;
      maximumCharge = store.maximumShippingCharge;
    } else if (store.selfDeliverySystem == 0 &&
        moduleData != null &&
        moduleData.deliveryChargeType == 'distance') {
      perKmCharge = moduleData.perKmShippingCharge ?? 0;
      minimumCharge = moduleData.minimumShippingCharge ?? 0;
      maximumCharge = moduleData.maximumShippingCharge;
    } else if (store.selfDeliverySystem == 0 &&
        moduleData != null &&
        moduleData.deliveryChargeType == 'fixed') {
      perKmCharge = moduleData.fixedShippingCharge ?? 0;
      minimumCharge = moduleData.fixedShippingCharge ?? 0;
      maximumCharge = moduleData.fixedShippingCharge;
    }

    if (store.selfDeliverySystem == 0 &&
        moduleData != null &&
        moduleData.deliveryChargeType == 'fixed') {
      deliveryCharge = minimumCharge;
    } else {
      deliveryCharge = distance * perKmCharge;
      if (deliveryCharge < minimumCharge) {
        deliveryCharge = minimumCharge;
      } else if (maximumCharge != null && deliveryCharge > maximumCharge) {
        deliveryCharge = maximumCharge;
      }
    }

    return deliveryCharge;
  }
}

class StoreCardShimmer extends StatelessWidget {
  const StoreCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      width: 500,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      ),
      child: Shimmer(
        duration: const Duration(seconds: 2),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(Dimensions.radiusSmall)),
              color: Theme.of(context).shadowColor,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        height: 15,
                        width: 200,
                        color: Theme.of(context).shadowColor),
                    const SizedBox(height: 5),
                    Container(
                        height: 10,
                        width: 130,
                        color: Theme.of(context).shadowColor),
                    const SizedBox(height: 5),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(Icons.star,
                            color: Theme.of(context).shadowColor, size: 15);
                      }),
                    ),
                  ]),
            ),
          ),
        ]),
      ),
    );
  }
}
