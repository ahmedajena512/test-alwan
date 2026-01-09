import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/store/controllers/store_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/features/search/widgets/custom_check_box_widget.dart';
import 'package:sixam_mart/util/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterWidget extends StatefulWidget {
  final double? maxValue;
  const FilterWidget({super.key, required this.maxValue});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    StoreController storeController = Get.find<StoreController>();
    if (storeController.lowerValue > 0) {
      _minController.text = storeController.lowerValue.toInt().toString();
    }
    if (storeController.upperValue > 0) {
      _maxController.text = storeController.upperValue.toInt().toString();
    }
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isFood = Get.find<SplashController>().module != null &&
        Get.find<SplashController>().module!.moduleType.toString() ==
            AppConstants.food;

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.transparent,
      child: Container(
        width: ResponsiveHelper.isDesktop(context) ? 400 : 500,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeDefault,
            vertical: Dimensions.paddingSizeLarge),
        child: GetBuilder<StoreController>(builder: (storeController) {
          return SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('filter_by'.tr,
                            style: robotoBold.copyWith(
                                fontSize: Dimensions.fontSizeExtraLarge)),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.close,
                              color: Theme.of(context).disabledColor),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ]),
                  const Divider(height: 30),
                  isFood
                      ? Padding(
                          padding: const EdgeInsets.only(
                              bottom: Dimensions.paddingSizeSmall),
                          child: CustomCheckBoxWidget(
                            title: 'currently_available_items'.tr,
                            value: storeController.isAvailableItems,
                            onClick: () {
                              storeController.toggleAvailableItems();
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                  CustomCheckBoxWidget(
                    title: 'discounted_items'.tr,
                    value: storeController.isDiscountedItems,
                    onClick: () {
                      storeController.toggleDiscountedItems();
                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  Text('view_layout'.tr,
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Theme.of(context).disabledColor)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .disabledColor
                          .withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Row(children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => storeController.toggleViewLayout(false),
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusSmall),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: !storeController.isGrid
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radiusSmall),
                              boxShadow: !storeController.isGrid
                                  ? [
                                      BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.05),
                                          blurRadius: 5)
                                    ]
                                  : [],
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.list,
                                      size: 18,
                                      color: !storeController.isGrid
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).disabledColor),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  Text('list_view'.tr,
                                      style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: !storeController.isGrid
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).disabledColor,
                                      )),
                                ]),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: InkWell(
                          onTap: () => storeController.toggleViewLayout(true),
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusSmall),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: storeController.isGrid
                                  ? AppColors.mainGradient
                                  : null,
                              color: storeController.isGrid
                                  ? null
                                  : Colors.transparent,
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radiusSmall),
                              boxShadow: storeController.isGrid
                                  ? [
                                      BoxShadow(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withValues(alpha: 0.3),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4))
                                    ]
                                  : [],
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.grid_view_rounded,
                                      size: 18,
                                      color: storeController.isGrid
                                          ? Colors.white
                                          : Theme.of(context).disabledColor),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  Text('grid_view'.tr,
                                      style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: storeController.isGrid
                                            ? Colors.white
                                            : Theme.of(context).disabledColor,
                                      )),
                                ]),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  Text('price'.tr,
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Theme.of(context).disabledColor)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Row(children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('more_than'.tr,
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).disabledColor)),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .disabledColor
                                .withValues(alpha: 0.05),
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusDefault),
                            border: Border.all(
                                color: Theme.of(context)
                                    .disabledColor
                                    .withValues(alpha: 0.2)),
                          ),
                          child: TextField(
                            controller: _minController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '0',
                              border: InputBorder.none,
                              suffixText: Get.find<SplashController>()
                                  .configModel!
                                  .currencySymbol,
                            ),
                            style: robotoMedium,
                            onChanged: (value) {
                              storeController
                                  .setLowerValue(double.tryParse(value) ?? 0);
                            },
                          ),
                        ),
                      ],
                    )),
                    const SizedBox(width: Dimensions.paddingSizeDefault),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('less_than'.tr,
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).disabledColor)),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .disabledColor
                                .withValues(alpha: 0.05),
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusDefault),
                            border: Border.all(
                                color: Theme.of(context)
                                    .disabledColor
                                    .withValues(alpha: 0.2)),
                          ),
                          child: TextField(
                            controller: _maxController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText:
                                  widget.maxValue?.toInt().toString() ?? '1000',
                              border: InputBorder.none,
                              suffixText: Get.find<SplashController>()
                                  .configModel!
                                  .currencySymbol,
                            ),
                            style: robotoMedium,
                            onChanged: (value) {
                              storeController.setUpperValue(
                                  double.tryParse(value) ??
                                      widget.maxValue ??
                                      0);
                            },
                          ),
                        ),
                      ],
                    )),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  Text('ratings'.tr,
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Theme.of(context).disabledColor)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        bool isSelected = storeController.rating >= (index + 1);
                        return InkWell(
                          onTap: () => storeController.setRating(index + 1),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: Dimensions.paddingSizeSmall),
                            child: Icon(
                              isSelected
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              size: 32,
                              color: isSelected
                                  ? Colors.orange
                                  : Theme.of(context)
                                      .disabledColor
                                      .withValues(alpha: 0.4),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                  Row(children: [
                    Expanded(
                      child: CustomButton(
                        height: 50,
                        buttonText: 'clear_filter'.tr,
                        color: Theme.of(context)
                            .disabledColor
                            .withValues(alpha: 0.1),
                        textColor: Theme.of(context).textTheme.bodyLarge?.color,
                        onPressed: () {
                          storeController.resetFilter();
                          _minController.clear();
                          _maxController.clear();
                        },
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: AppColors.mainGradient,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusDefault),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4))
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            storeController.getStoreItemList(
                                storeController.store!.id,
                                1,
                                storeController.type,
                                true);
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusDefault)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('filter'.tr,
                                  style: robotoBold.copyWith(
                                      color: Colors.white,
                                      fontSize: Dimensions.fontSizeLarge)),
                              const SizedBox(
                                  width: Dimensions.paddingSizeExtraSmall),
                              const Icon(Icons.arrow_drop_down,
                                  color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ]),
          );
        }),
      ),
    );
  }
}
