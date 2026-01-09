import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/store/controllers/store_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/util/app_colors.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';

class HomeFilterWidget extends StatelessWidget {
  const HomeFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      child: GetBuilder<StoreController>(builder: (storeController) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close,
                      color: Theme.of(context).disabledColor, size: 24),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                Text('filter_stores'.tr,
                    style: robotoBold.copyWith(
                        fontSize: Dimensions.fontSizeExtraLarge)),
                const SizedBox(width: 40), // Balance the close button
              ]),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              // Sort By section
              Text('sort_by'.tr,
                  style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).textTheme.bodyLarge?.color)),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Row(children: [
                Expanded(
                  child: _SortButton(
                    title: 'nearest'.tr,
                    icon: Icons.near_me_rounded,
                    isSelected: storeController.sortBy == 'distance',
                    onTap: () => storeController.setSortBy('distance'),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(
                  child: _SortButton(
                    title: 'rating'.tr,
                    icon: Icons.star_rounded,
                    isSelected: storeController.sortBy == 'rating',
                    onTap: () => storeController.setSortBy('rating'),
                  ),
                ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              // Filters section
              _FilterToggle(
                title: 'discounted_items'.tr,
                value:
                    storeController.isDiscountedItems, // Reusing existing field
                onTap: () => storeController.toggleDiscountedItems(),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              _FilterToggle(
                title: 'currently_available_items'.tr,
                value:
                    storeController.isAvailableItems, // Reusing existing field
                onTap: () => storeController.toggleAvailableItems(),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              _FilterToggle(
                title: 'free_delivery'.tr,
                value: storeController.isFreeDelivery,
                onTap: () => storeController.toggleFreeDelivery(),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              // View Layout section
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('view_layout'.tr,
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).textTheme.bodyLarge?.color)),
                const Text('view_layout',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontFamily: 'monospace')),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Container(
                height: 55,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: Theme.of(context)
                          .disabledColor
                          .withValues(alpha: 0.1)),
                ),
                child: Row(children: [
                  Expanded(
                    child: _LayoutButton(
                      title: 'grid_view'.tr,
                      icon: Icons.grid_view_rounded,
                      isSelected: storeController.isGrid,
                      onTap: () => storeController.toggleViewLayout(true),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: _LayoutButton(
                      title: 'list_view'.tr,
                      icon: Icons.view_list_rounded,
                      isSelected: !storeController.isGrid,
                      onTap: () => storeController.toggleViewLayout(false),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              // Ratings section
              Text('ratings'.tr,
                  style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).textTheme.bodyLarge?.color)),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: TextDirection.rtl,
                  children: List.generate(5, (index) {
                    bool isSelected = storeController.rating >= (5 - index);
                    return InkWell(
                      onTap: () => storeController.setRating(5 - index),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          isSelected
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          size: 38,
                          color: isSelected
                              ? Colors.amber[400]
                              : Theme.of(context)
                                  .disabledColor
                                  .withValues(alpha: 0.3),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

              // Footer Actions
              Row(children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      gradient: AppColors.mainGradient,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5))
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        storeController.getStoreList(1, true);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('apply'.tr,
                              style: robotoBold.copyWith(
                                  color: Colors.white,
                                  fontSize: Dimensions.fontSizeLarge)),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          const Icon(Icons.filter_alt_rounded,
                              color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(
                  flex: 2,
                  child: CustomButton(
                    height: 55,
                    buttonText: 'reset'.tr,
                    color:
                        Theme.of(context).disabledColor.withValues(alpha: 0.1),
                    textColor: Theme.of(context).textTheme.bodyLarge?.color,
                    radius: 15,
                    onPressed: () {
                      storeController.resetFilter();
                      storeController.getStoreList(1, true);
                    },
                  ),
                ),
              ]),
            ],
          ),
        );
      }),
    );
  }
}

class _SortButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortButton(
      {required this.title,
      required this.icon,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.mainGradient : null,
          color: isSelected ? null : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          border: isSelected
              ? null
              : Border.all(
                  color:
                      Theme.of(context).disabledColor.withValues(alpha: 0.2)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color:
                          Theme.of(context).primaryColor.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ]
              : [],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon,
              size: 18,
              color:
                  isSelected ? Colors.white : Theme.of(context).disabledColor),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          Text(title,
              style: robotoBold.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color:
                    isSelected ? Colors.white : Theme.of(context).disabledColor,
              )),
        ]),
      ),
    );
  }
}

class _FilterToggle extends StatelessWidget {
  final String title;
  final bool value;
  final VoidCallback onTap;

  const _FilterToggle(
      {required this.title, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title,
              style: robotoMedium.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: value
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).textTheme.bodyLarge?.color)),
          Checkbox(
            value: value,
            onChanged: (v) => onTap(),
            activeColor: Theme.of(context).primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            side: BorderSide(
                color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
          ),
        ]),
      ),
    );
  }
}

class _LayoutButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _LayoutButton(
      {required this.title,
      required this.icon,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.mainGradient : null,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ]
              : [],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon,
              size: 20,
              color:
                  isSelected ? Colors.white : Theme.of(context).disabledColor),
          const SizedBox(width: 8),
          Text(title,
              style: robotoBold.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color:
                    isSelected ? Colors.white : Theme.of(context).disabledColor,
              )),
        ]),
      ),
    );
  }
}
