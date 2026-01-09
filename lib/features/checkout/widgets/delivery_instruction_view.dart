import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_ink_well.dart';
import 'package:sixam_mart/features/checkout/controllers/checkout_controller.dart';
import 'package:sixam_mart/features/checkout/widgets/delivery_instraction_bottom_sheet_widget.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class DeliveryInstructionView extends StatefulWidget {
  const DeliveryInstructionView({super.key});

  @override
  State<DeliveryInstructionView> createState() =>
      _DeliveryInstructionViewState();
}

class _DeliveryInstructionViewState extends State<DeliveryInstructionView> {
  ExpansibleController controller = ExpansibleController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
              blurRadius: 10)
        ],
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeLarge,
          vertical: Dimensions.paddingSizeSmall),
      margin: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeExtraSmall),
      child: GetBuilder<CheckoutController>(builder: (orderController) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CustomInkWell(
            onTap: () {
              if (ResponsiveHelper.isDesktop(context)) {
                Get.dialog(const Dialog(
                    child: DeliveryInstractionBottomSheetWidget()));
              } else {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (con) =>
                      const DeliveryInstractionBottomSheetWidget(),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeExtraSmall),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('add_more_delivery_instruction'.tr,
                        style: robotoMedium.copyWith(
                            color: Theme.of(context).primaryColor)),
                    Icon(Icons.add_circle_outline,
                        color: Theme.of(context).primaryColor, size: 20),
                  ]),
            ),
          ),
          orderController.selectedInstruction != -1
              ? Padding(
                  padding:
                      const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .primaryColor
                          .withValues(alpha: 0.05),
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    child: Row(children: [
                      Expanded(
                        child: Text(
                          AppConstants
                              .deliveryInstructionList[
                                  orderController.selectedInstruction]
                              .tr,
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                      InkWell(
                        onTap: () => orderController.setInstruction(-1),
                        child: Icon(Icons.cancel,
                            size: 18,
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ]),
                  ),
                )
              : const SizedBox(),
        ]);
      }),
    );
  }
}
