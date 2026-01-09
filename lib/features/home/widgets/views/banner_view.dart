import 'package:carousel_slider/carousel_slider.dart';
import 'package:sixam_mart/features/banner/controllers/banner_controller.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/item/domain/models/basic_campaign_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/features/store/screens/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/util/app_colors.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:sixam_mart/common/widgets/custom_scale_button.dart';

class BannerView extends StatelessWidget {
  final bool isFeatured;
  const BannerView({super.key, required this.isFeatured});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BannerController>(builder: (bannerController) {
      List<String?>? bannerList = isFeatured
          ? bannerController.featuredBannerList
          : bannerController.bannerImageList;
      List<dynamic>? bannerDataList = isFeatured
          ? bannerController.featuredBannerDataList
          : bannerController.bannerDataList;

      return (bannerList != null && bannerList.isEmpty)
          ? const SizedBox()
          : Container(
              width: MediaQuery.of(context).size.width,
              height: GetPlatform.isDesktop
                  ? 500
                  : MediaQuery.of(context).size.width * 0.5,
              padding: const EdgeInsets.only(
                  top: Dimensions.paddingSizeDefault,
                  bottom: Dimensions.paddingSizeExtraSmall),
              child: bannerList != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: CarouselSlider.builder(
                            options: CarouselOptions(
                              autoPlay: true,
                              enlargeCenterPage: true,
                              disableCenter: true,
                              viewportFraction: 0.95,
                              autoPlayInterval: const Duration(seconds: 7),
                              onPageChanged: (index, reason) {
                                bannerController.setCurrentIndex(index, true);
                              },
                            ),
                            itemCount:
                                bannerList.isEmpty ? 1 : bannerList.length,
                            itemBuilder: (context, index, _) {
                              return CustomScaleButton(
                                onTap: () async {
                                  if (bannerDataList![index] is Item) {
                                    Item? item = bannerDataList[index];
                                    Get.find<ItemController>()
                                        .navigateToItemPage(item, context);
                                  } else if (bannerDataList[index] is Store) {
                                    Store? store = bannerDataList[index];
                                    if (isFeatured &&
                                        Get.find<SplashController>()
                                                .moduleList !=
                                            null) {
                                      for (ModuleModel module
                                          in Get.find<SplashController>()
                                              .moduleList!) {
                                        if (module.id == store!.moduleId) {
                                          Get.find<SplashController>()
                                              .setModule(module);
                                          break;
                                        }
                                      }
                                    }
                                    Get.toNamed(
                                      RouteHelper.getStoreRoute(
                                          id: store!.id,
                                          page:
                                              isFeatured ? 'module' : 'banner'),
                                      arguments: StoreScreen(
                                          store: store, fromModule: isFeatured),
                                    );
                                  } else if (bannerDataList[index]
                                      is BasicCampaignModel) {
                                    BasicCampaignModel campaign =
                                        bannerDataList[index];
                                    Get.toNamed(
                                        RouteHelper.getBasicCampaignRoute(
                                            campaign));
                                  } else {
                                    String url = bannerDataList[index];
                                    if (await canLaunchUrlString(url)) {
                                      await launchUrlString(url,
                                          mode: LaunchMode.externalApplication);
                                    } else {
                                      showCustomSnackBar(
                                          'unable_to_found_url'.tr);
                                    }
                                  }
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusLarge),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5,
                                          spreadRadius: 1)
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusLarge),
                                    child: GetBuilder<SplashController>(
                                        builder: (splashController) {
                                      return CustomImage(
                                        image: '${bannerList[index]}',
                                        fit: BoxFit.cover,
                                      );
                                    }),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: bannerList.map((bnr) {
                            int index = bannerList.indexOf(bnr);
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 3),
                              child: index == bannerController.currentIndex
                                  ? Container(
                                      height: 5,
                                      width: 12,
                                      decoration: BoxDecoration(
                                        gradient: AppColors.mainGradient,
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusDefault),
                                      ),
                                    )
                                  : Container(
                                      height: 5,
                                      width: 6,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusDefault),
                                      ),
                                    ),
                            );
                          }).toList(),
                        ),
                      ],
                    )
                  : Shimmer(
                      duration: const Duration(seconds: 2),
                      enabled: bannerList == null,
                      child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusLarge),
                            color: Colors.grey[300],
                          )),
                    ),
            );
    });
  }
}
