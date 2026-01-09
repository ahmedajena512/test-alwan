import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/address_widget.dart';
import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/address/controllers/address_controller.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/location/domain/models/zone_response_model.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_loader.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/util/app_colors.dart';
import 'package:sixam_mart/features/location/screens/pick_map_screen.dart';

class AddressBottomSheetWidget extends StatelessWidget {
  final bool fromDialog;
  const AddressBottomSheetWidget({super.key, this.fromDialog = false});

  @override
  Widget build(BuildContext context) {
    if (Get.find<AddressController>().addressList == null) {
      Get.find<AddressController>().getAddressList();
    }
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(fromDialog
              ? Dimensions.paddingSizeDefault
              : Dimensions.paddingSizeExtraLarge),
          topRight: Radius.circular(fromDialog
              ? Dimensions.paddingSizeDefault
              : Dimensions.paddingSizeExtraLarge),
          bottomLeft:
              Radius.circular(fromDialog ? Dimensions.paddingSizeDefault : 0),
          bottomRight:
              Radius.circular(fromDialog ? Dimensions.paddingSizeDefault : 0),
        ),
      ),
      child: GetBuilder<AddressController>(builder: (addressController) {
        AddressModel? selectedAddress =
            AddressHelper.getUserAddressFromSharedPref();
        return Column(mainAxisSize: MainAxisSize.min, children: [
          fromDialog
              ? Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  IconButton(
                    onPressed: () {
                      Get.find<SplashController>()
                          .saveWebSuggestedLocationStatus(true);
                      Get.back();
                    },
                    icon: const Icon(Icons.clear),
                  )
                ])
              : const SizedBox(),
          fromDialog
              ? const SizedBox()
              : Center(
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: Dimensions.paddingSizeDefault,
                        bottom: Dimensions.paddingSizeDefault),
                    height: 3,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).highlightColor,
                      borderRadius: BorderRadius.circular(
                          Dimensions.paddingSizeExtraSmall),
                    ),
                  ),
                ),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: fromDialog ? 50 : Dimensions.paddingSizeLarge,
                  vertical: Dimensions.paddingSizeSmall),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        '${'hey_welcome_back'.tr}\n${'which_location_do_you_want_to_select'.tr}',
                        textAlign: TextAlign.center,
                        style: robotoBold.copyWith(
                            fontSize: Dimensions.fontSizeDefault),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                    Center(
                      child: addressController.addressList != null &&
                              addressController.addressList!.isEmpty
                          ? Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                  Image.asset(Images.noAddress,
                                      width: fromDialog ? 180 : 200),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeDefault),
                                  SizedBox(
                                    width: 280,
                                    child: Text(
                                      'you_dont_have_any_saved_address_yet'.tr,
                                      textAlign: TextAlign.center,
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          color:
                                              Theme.of(context).disabledColor),
                                    ),
                                  ),
                                ])
                          : const SizedBox(),
                    ),
                    addressController.addressList != null &&
                            addressController.addressList!.isEmpty
                        ? const SizedBox(height: Dimensions.paddingSizeLarge)
                        : const SizedBox(),
                    (addressController.addressList != null && fromDialog)
                        ? const SizedBox(height: Dimensions.paddingSizeDefault)
                        : const SizedBox(),
                    Align(
                      alignment: addressController.addressList != null &&
                              addressController.addressList!.isEmpty &&
                              !fromDialog
                          ? Alignment.center
                          : Alignment.topCenter,
                      child: InkWell(
                        onTap: () {
                          Get.find<LocationController>()
                              .checkPermission(() async {
                            Get.dialog(const CustomLoaderWidget(),
                                barrierDismissible: false);
                            AddressModel address =
                                await Get.find<LocationController>()
                                    .getCurrentLocation(true);
                            ZoneResponseModel response =
                                await Get.find<LocationController>().getZone(
                                    address.latitude, address.longitude, false);
                            if (response.isSuccess) {
                              if (ResponsiveHelper.isDesktop(Get.context)) {
                                Get.find<SplashController>()
                                    .saveWebSuggestedLocationStatus(true);
                              }
                              Get.find<LocationController>()
                                  .saveAddressAndNavigate(
                                address,
                                false,
                                '',
                                false,
                                ResponsiveHelper.isDesktop(Get.context),
                              );
                              Get.find<LocationController>()
                                  .showSuggestedLocation(false);
                            } else {
                              Get.back();
                              if (ResponsiveHelper.isDesktop(Get.context)) {
                                Get.find<SplashController>()
                                    .saveWebSuggestedLocationStatus(true);
                                showGeneralDialog(
                                    context: Get.context!,
                                    pageBuilder: (_, __, ___) {
                                      return const SizedBox(
                                        height: 300,
                                        width: 300,
                                        child: PickMapScreen(
                                            fromSignUp: false,
                                            canRoute: false,
                                            fromAddAddress: true,
                                            route: null),
                                      );
                                    });
                              } else {
                                Get.toNamed(RouteHelper.getPickMapRoute(
                                    RouteHelper.accessLocation, false));
                              }
                              showCustomSnackBar(
                                  'service_not_available_in_current_location'
                                      .tr);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeDefault,
                              vertical: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            gradient: AppColors.mainGradient,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusDefault),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withValues(alpha: 0.2),
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.my_location,
                                  color: Theme.of(context).cardColor, size: 20),
                              const SizedBox(
                                  width: Dimensions.paddingSizeSmall),
                              Text(
                                'use_current_location'.tr,
                                style: robotoMedium.copyWith(
                                    color: Theme.of(context).cardColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    addressController.addressList != null
                        ? addressController.addressList!.isNotEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusDefault),
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      width: 1),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        Dimensions.paddingSizeExtraSmall,
                                    vertical: Dimensions.paddingSizeExtraSmall),
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount:
                                      addressController.addressList!.length > 5
                                          ? 5
                                          : addressController
                                              .addressList!.length,
                                  itemBuilder: (context, index) {
                                    bool selected = false;
                                    if (selectedAddress!.id ==
                                        addressController
                                            .addressList![index].id) {
                                      selected = true;
                                    }
                                    return Center(
                                        child: SizedBox(
                                            width: 700,
                                            child: AddressWidget(
                                              address: addressController
                                                  .addressList![index],
                                              fromAddress: false,
                                              isSelected: selected,
                                              fromDashBoard: true,
                                              onTap: () {
                                                Get.dialog(
                                                    const CustomLoaderWidget(),
                                                    barrierDismissible: false);
                                                AddressModel address =
                                                    addressController
                                                        .addressList![index];
                                                Get.find<LocationController>()
                                                    .saveAddressAndNavigate(
                                                  address,
                                                  false,
                                                  null,
                                                  false,
                                                  ResponsiveHelper.isDesktop(
                                                      context),
                                                );

                                                Get.find<LocationController>()
                                                    .showSuggestedLocation(
                                                        false);
                                                Get.find<SplashController>()
                                                    .saveWebSuggestedLocationStatus(
                                                        true);
                                              },
                                            )));
                                  },
                                ),
                              )
                            : const SizedBox()
                        : const Center(child: CircularProgressIndicator()),
                    SizedBox(
                        height: addressController.addressList != null &&
                                addressController.addressList!.isEmpty
                            ? 0
                            : Dimensions.paddingSizeSmall),
                    addressController.addressList != null &&
                            addressController.addressList!.isNotEmpty
                        ? Center(
                            child: TextButton.icon(
                              onPressed: () {
                                Get.find<SplashController>()
                                    .saveWebSuggestedLocationStatus(true);
                                Get.toNamed(RouteHelper.getAddAddressRoute(
                                    false, false, 0));
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeDefault),
                              ),
                              icon: Icon(Icons.add_circle_outline,
                                  color: Theme.of(context).primaryColor,
                                  size: 20),
                              label: Text('add_new_address'.tr,
                                  style: robotoMedium.copyWith(
                                      color: Theme.of(context).primaryColor)),
                            ),
                          )
                        : const SizedBox(),
                  ]),
            ),
          ),
        ]);
      }),
    );
  }
}
