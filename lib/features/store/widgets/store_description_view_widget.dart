import 'package:sixam_mart/features/store/controllers/store_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/favourite/controllers/favourite_controller.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_colors.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreDescriptionViewWidget extends StatelessWidget {
  final Store? store;
  const StoreDescriptionViewWidget({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    bool isAvailable = Get.find<StoreController>()
        .isStoreOpenNow(store!.active!, store!.schedules);
    Color? textColor =
        ResponsiveHelper.isDesktop(context) ? Colors.white : null;
    // Module? moduleData;
    // for(ZoneData zData in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
    //   for(Modules m in zData.modules!) {
    //     if(m.id == Get.find<SplashController>().module!.id) {
    //       moduleData = m as Module?;
    //       break;
    //     }
    //   }
    // }
    return Column(children: [
      ResponsiveHelper.isDesktop(context)
          ? Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                child: Stack(children: [
                  CustomImage(
                    image: '${store!.logoFullUrl}',
                    height: ResponsiveHelper.isDesktop(context) ? 140 : 60,
                    width: ResponsiveHelper.isDesktop(context) ? 140 : 70,
                    fit: BoxFit.cover,
                  ),
                  isAvailable
                      ? const SizedBox()
                      : Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                  bottom:
                                      Radius.circular(Dimensions.radiusSmall)),
                              color: Colors.black.withValues(alpha: 0.6),
                            ),
                            child: Text(
                              'closed_now'.tr,
                              textAlign: TextAlign.center,
                              style: robotoRegular.copyWith(
                                  color: Colors.white,
                                  fontSize: Dimensions.fontSizeSmall),
                            ),
                          ),
                        ),
                ]),
              ),
              const SizedBox(width: Dimensions.paddingSizeDefault),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(children: [
                      Expanded(
                          child: Text(
                        store!.name!,
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: textColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      // ResponsiveHelper.isDesktop(context) ? InkWell(
                      //   onTap: () => Get.toNamed(RouteHelper.getSearchStoreItemRoute(store!.id)),
                      //   child: ResponsiveHelper.isDesktop(context) ? Container(
                      //     padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusDefault), color: Theme.of(context).primaryColor),
                      //     child: const Center(child: Icon(Icons.search, color: Colors.white)),
                      //   ) : Icon(Icons.search, color: Theme.of(context).primaryColor),
                      // ) : const SizedBox(),
                      // const SizedBox(width: Dimensions.paddingSizeSmall),
                      GetBuilder<FavouriteController>(
                          builder: (favouriteController) {
                        bool isWished = favouriteController.wishStoreIdList
                            .contains(store!.id);
                        return InkWell(
                          onTap: () {
                            if (AuthHelper.isLoggedIn()) {
                              isWished
                                  ? favouriteController.removeFromFavouriteList(
                                      store!.id, true)
                                  : favouriteController.addToFavouriteList(
                                      null, store?.id, true);
                            } else {
                              showCustomSnackBar('you_are_not_logged_in'.tr);
                            }
                          },
                          child: ResponsiveHelper.isDesktop(context)
                              ? Container(
                                  padding: const EdgeInsets.all(
                                      Dimensions.paddingSizeExtraSmall),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusSmall),
                                      border: Border.all(color: Colors.white)),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        ShaderMask(
                                          shaderCallback: (bounds) => AppColors
                                              .mainGradient
                                              .createShader(bounds),
                                          blendMode: BlendMode.srcIn,
                                          child: Icon(
                                              isWished
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: Colors.white,
                                              size: 14),
                                        ),
                                        const SizedBox(
                                            width: Dimensions
                                                .paddingSizeExtraSmall),
                                        Text('wish_list'.tr,
                                            style: robotoRegular.copyWith(
                                                fontWeight: FontWeight.w200,
                                                color: Colors.white,
                                                fontSize:
                                                    Dimensions.fontSizeSmall)),
                                      ],
                                    ),
                                  ),
                                )
                              : isWished
                                  ? Container(
                                      height: 36,
                                      width: 36,
                                      decoration: BoxDecoration(
                                        gradient: AppColors.mainGradient,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.green
                                                .withValues(alpha: 0.3),
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.favorite,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    )
                                  : Icon(
                                      Icons.favorite_border,
                                      color: Theme.of(context).disabledColor,
                                    ),
                        );
                      }),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    Row(children: [
                      Expanded(
                        child: Text(
                          store!.address ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).disabledColor),
                        ),
                      ),
                    ]),
                    SizedBox(
                        height: ResponsiveHelper.isDesktop(context)
                            ? Dimensions.paddingSizeSmall
                            : 0),
                    Row(children: [
                      Text('minimum_order_amount'.tr,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: Theme.of(context).disabledColor,
                          )),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Expanded(
                          child: Text(
                        PriceConverter.convertPrice(store!.minimumOrder),
                        textDirection: TextDirection.ltr,
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: Theme.of(context).primaryColor),
                      )),
                    ]),
                  ])),
            ])
          : const SizedBox(),
      SizedBox(
          height: ResponsiveHelper.isDesktop(context)
              ? 30
              : Dimensions.paddingSizeSmall),
      ResponsiveHelper.isDesktop(context)
          ? Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      spreadRadius: 2)
                ],
              ),
              child: IntrinsicHeight(
                child: Row(children: [
                  Expanded(
                      child: _buildInfoItem(
                    context,
                    title: store!.avgRating!.toStringAsFixed(1),
                    subTitle: '${store!.ratingCount} + ${'ratings'.tr}',
                    icon: Icons.star,
                    onTap: () => Get.toNamed(RouteHelper.getStoreReviewRoute(
                        store!.id, store!.name, store!)),
                  )),
                  const VerticalDivider(width: 1),
                  Expanded(
                      child: _buildInfoItem(
                    context,
                    title: 'location'.tr,
                    subTitle: 'view_on_map'.tr,
                    icon: Icons.location_on,
                    onTap: () => Get.toNamed(RouteHelper.getMapRoute(
                      AddressModel(
                        id: store!.id,
                        address: store!.address,
                        latitude: store!.latitude,
                        longitude: store!.longitude,
                        contactPersonNumber: '',
                        contactPersonName: '',
                        addressType: '',
                      ),
                      'store',
                      Get.find<SplashController>()
                          .getModuleConfig(
                              Get.find<SplashController>().module!.moduleType!)
                          .newVariation!,
                      storeName: store!.name,
                    )),
                  )),
                  const VerticalDivider(width: 1),
                  Expanded(
                      child: _buildInfoItem(
                    context,
                    title: store!.deliveryTime!,
                    subTitle: 'delivery_time'.tr,
                    icon: Icons.timer,
                  )),
                  const VerticalDivider(width: 1),
                  Expanded(
                      child: _buildInfoItem(
                    context,
                    title: _getDeliveryCharge(store!),
                    subTitle: 'delivery_fee'.tr,
                    icon: Icons.delivery_dining,
                  )),
                ]),
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Row(children: [
                Expanded(
                    child: _buildInfoItem(
                  context,
                  title: store!.avgRating!.toStringAsFixed(1),
                  subTitle: '${store!.ratingCount}+ ${'ratings'.tr}',
                  icon: Icons.star,
                  onTap: () => Get.toNamed(RouteHelper.getStoreReviewRoute(
                      store!.id, store!.name, store!)),
                )),
                Expanded(
                    child: _buildInfoItem(
                  context,
                  title: 'location'.tr,
                  subTitle: 'map'.tr,
                  icon: Icons.location_on,
                  onTap: () => Get.toNamed(RouteHelper.getMapRoute(
                    AddressModel(
                      id: store!.id,
                      address: store!.address,
                      latitude: store!.latitude,
                      longitude: store!.longitude,
                      contactPersonNumber: '',
                      contactPersonName: '',
                      addressType: '',
                    ),
                    'store',
                    Get.find<SplashController>()
                        .getModuleConfig(
                            Get.find<SplashController>().module!.moduleType!)
                        .newVariation!,
                    storeName: store!.name,
                  )),
                )),
                Expanded(
                    child: _buildInfoItem(
                  context,
                  title: store!.deliveryTime!,
                  subTitle: 'delivery'.tr,
                  icon: Icons.timer,
                )),
                Expanded(
                    child: _buildInfoItem(
                  context,
                  title: _getDeliveryCharge(store!),
                  subTitle: 'fee'.tr,
                  icon: Icons.delivery_dining,
                )),
              ]),
            ),
    ]);
  }

  Widget _buildInfoItem(BuildContext context,
      {required String title,
      required String subTitle,
      required IconData icon,
      VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ShaderMask(
            shaderCallback: (bounds) =>
                AppColors.mainGradient.createShader(bounds),
            blendMode: BlendMode.srcIn,
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          Flexible(
              child: Text(
            title,
            style: robotoBold.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).textTheme.bodyLarge!.color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
        ]),
        Text(
          subTitle,
          style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall,
              color: Theme.of(context).disabledColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ]),
    );
  }

  String _getDeliveryCharge(Store store) {
    if (store.freeDelivery! || store.selfDeliverySystem == 0) {
      if (store.freeDelivery!) {
        return 'free'.tr;
      }
      return 'calculating'.tr;
    }

    double deliveryCharge = -1;
    double? distance = store.distance;

    if (distance != null && distance != -1) {
      double perKmCharge = store.perKmShippingCharge ?? 0;
      double minimumCharge = store.minimumShippingCharge ?? 0;
      double? maximumCharge = store.maximumShippingCharge;

      deliveryCharge = distance * perKmCharge;

      if (deliveryCharge < minimumCharge) {
        deliveryCharge = minimumCharge;
      } else if (maximumCharge != null && deliveryCharge > maximumCharge) {
        deliveryCharge = maximumCharge;
      }
    }

    return deliveryCharge != -1
        ? PriceConverter.convertPrice(deliveryCharge)
        : 'calculating'.tr;
  }
}
