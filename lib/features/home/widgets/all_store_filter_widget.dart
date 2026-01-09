import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/home/widgets/filter_view.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/store/controllers/store_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class AllStoreFilterWidget extends StatelessWidget {
  const AllStoreFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(
      builder: (storeController) {
        return Center(
          child: Container(
            width: Dimensions.webMaxWidth,
            transform: Matrix4.translationValues(0, -2, 0),
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeSmall),
            child: Row(children: [
              // Show filter button on the START side (Right in Arabic, Left in English)
              FilterView(storeController: storeController, showText: true),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Get.find<SplashController>()
                                .configModel!
                                .moduleConfig!
                                .module!
                                .showRestaurantText!
                            ? 'restaurants'.tr
                            : 'stores'.tr,
                        style: robotoBold.copyWith(
                            fontSize: Dimensions.fontSizeLarge),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        '${storeController.storeModel?.totalSize ?? 0} ${Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText! ? 'restaurants_near_you'.tr : 'stores_near_you'.tr}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: robotoRegular.copyWith(
                            color: Theme.of(context).disabledColor,
                            fontSize: Dimensions.fontSizeSmall),
                        textAlign: TextAlign.start,
                      ),
                    ]),
              ),
            ]),
          ),
        );
      },
    );
  }
}
