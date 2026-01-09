import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/features/favourite/controllers/favourite_controller.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_colors.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistStoreCard extends StatelessWidget {
  final Store store;
  final Function()? onTap;
  const WishlistStoreCard({
    super.key,
    required this.store,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isAvailable = store.open == 1 && store.active!;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: Theme.of(context).disabledColor.withOpacity(0.1),
        ),
        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap ??
            () {
              if (store.active!) {
                Get.toNamed(
                  RouteHelper.getStoreRoute(
                    id: store.id,
                    page: 'store',
                  ),
                );
              } else {
                showCustomSnackBar('store_is_not_available'.tr);
              }
            },
        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
        child: Column(
          children: [
            // Image Section with Overlays
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(Dimensions.radiusExtraLarge),
                  ),
                  child: ColorFiltered(
                    colorFilter: isAvailable
                        ? const ColorFilter.mode(
                            Colors.transparent,
                            BlendMode.multiply,
                          )
                        : const ColorFilter.mode(
                            Colors.grey,
                            BlendMode.saturation,
                          ),
                    child: CustomImage(
                      image: '${store.coverPhotoFullUrl}',
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
                          top: Radius.circular(Dimensions.radiusExtraLarge),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                // Premium Closed Status Overlay
                if (!isAvailable)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(Dimensions.radiusExtraLarge),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              Dimensions.radiusLarge,
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.lock_clock,
                                color: Theme.of(context).colorScheme.error,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'closed_now'.tr.toUpperCase(),
                                    style: robotoBold.copyWith(
                                      color: Colors.white,
                                      fontSize: Dimensions.fontSizeSmall,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                // Favorite Button
                Positioned(
                  top: 10,
                  right: 10,
                  child: GetBuilder<FavouriteController>(
                    builder: (favouriteController) {
                      bool isWished = favouriteController.wishStoreIdList
                          .contains(store.id);
                      return InkWell(
                        onTap: () {
                          favouriteController.removeFromFavouriteList(
                            store.id,
                            true,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            isWished ? Icons.favorite : Icons.favorite_border,
                            size: 20,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      );
                    },
                  ),
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
                              borderRadius: BorderRadius.circular(
                                Dimensions.radiusSmall,
                              ),
                              border: Border.all(
                                color: Theme.of(context).cardColor,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                Dimensions.radiusSmall - 2,
                              ),
                              child: CustomImage(
                                image: '${store.logoFullUrl}',
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
                                    store.name ?? '',
                                    style: robotoBold.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    store.address ?? '',
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Delivery Tag
                          if (store.freeDelivery ?? false)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radiusSmall,
                                ),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).primaryColor.withOpacity(0.2),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'delivery'.tr.toUpperCase(),
                                    style: robotoBold.copyWith(
                                      fontSize: 8,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'free'.tr,
                                    style: robotoBold.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Theme.of(context).primaryColor,
                                    ),
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
                      color: Theme.of(
                        context,
                      ).disabledColor.withOpacity(0.1),
                    ),
                    const SizedBox(height: 5),

                    // Footer Pills (Time & Rating)
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).disabledColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(
                                Dimensions.radiusDefault,
                              ),
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
                                  child: const Icon(
                                    Icons.access_time_filled,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  store.deliveryTime ?? '',
                                  style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).disabledColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(
                                Dimensions.radiusDefault,
                              ),
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
                                  child: const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  store.avgRating?.toStringAsFixed(1) ?? '0.0',
                                  style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                  overflow: TextOverflow.ellipsis,
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
}
