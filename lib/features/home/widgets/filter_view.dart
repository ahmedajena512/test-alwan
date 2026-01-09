import 'package:sixam_mart/features/home/widgets/home_filter_widget.dart';
import 'package:sixam_mart/util/app_colors.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/store/controllers/store_controller.dart';

class FilterView extends StatelessWidget {
  final StoreController storeController;
  final bool showText;
  const FilterView(
      {super.key, required this.storeController, this.showText = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (storeController.storeModel != null) {
          Get.bottomSheet(
            const HomeFilterWidget(),
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Container(
          height: 40,
          padding: showText
              ? const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault)
              : EdgeInsets.zero,
          width: showText ? null : 40,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            border: Border.all(
              color: storeController.storeModel != null
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).disabledColor,
              width: 1.5,
            ),
            boxShadow: storeController.storeModel != null
                ? [
                    BoxShadow(
                      color:
                          Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              storeController.storeModel != null
                  ? ShaderMask(
                      shaderCallback: (bounds) =>
                          AppColors.mainGradient.createShader(bounds),
                      blendMode: BlendMode.srcIn,
                      child: const Icon(Icons.filter_list_rounded,
                          color: Colors.white, size: 20),
                    )
                  : Icon(Icons.filter_list_rounded,
                      color: Theme.of(context).disabledColor, size: 20),
              if (showText) ...[
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(
                  'filter'.tr,
                  style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: storeController.storeModel != null
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).disabledColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
