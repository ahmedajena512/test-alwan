import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:sixam_mart/common/widgets/address_widget.dart';
import 'package:sixam_mart/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart/common/widgets/no_internet_screen.dart';
import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/features/address/controllers/address_controller.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/location/domain/models/zone_response_model.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_loader.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/location/screens/pick_map_screen.dart';
import 'package:sixam_mart/features/location/screens/web_landing_page.dart';

class AccessLocationScreen extends StatefulWidget {
  final bool fromSignUp;
  final bool fromHome;
  final String? route;
  const AccessLocationScreen(
      {super.key,
      required this.fromSignUp,
      required this.fromHome,
      required this.route});

  @override
  State<AccessLocationScreen> createState() => _AccessLocationScreenState();
}

class _AccessLocationScreenState extends State<AccessLocationScreen> {
  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  void initState() {
    super.initState();

    if (AuthHelper.isLoggedIn()) {
      Get.find<AddressController>().getAddressList();
    }

    checkInternet();
  }

  void checkInternet() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    bool isConnected = connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile);
    if (!isConnected) {
      Get.offAll(() => const NoInternetScreen());
    }
  }

  void _onUseCurrentLocation() async {
    Get.find<LocationController>().checkPermission(() async {
      Get.dialog(const CustomLoaderWidget(), barrierDismissible: false);
      AddressModel address =
          await Get.find<LocationController>().getCurrentLocation(true);
      ZoneResponseModel response = await Get.find<LocationController>()
          .getZone(address.latitude, address.longitude, false);
      if (response.isSuccess) {
        Get.find<LocationController>().saveAddressAndNavigate(
          address,
          widget.fromSignUp,
          widget.route,
          widget.route != null,
          ResponsiveHelper.isDesktop(Get.context),
        );
      } else {
        Get.back();
        if (ResponsiveHelper.isDesktop(Get.context)) {
          showGeneralDialog(
              context: Get.context!,
              pageBuilder: (_, __, ___) {
                return SizedBox(
                    height: 300,
                    width: 300,
                    child: PickMapScreen(
                        fromSignUp: widget.fromSignUp,
                        canRoute: widget.route != null,
                        fromAddAddress: false,
                        route: widget.route ?? RouteHelper.accessLocation));
              });
        } else {
          Get.toNamed(RouteHelper.getPickMapRoute(
              widget.route ?? RouteHelper.accessLocation,
              widget.route != null));
          showCustomSnackBar('service_not_available_in_current_location'.tr);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (_canExit) {
          if (GetPlatform.isAndroid) {
            SystemNavigator.pop();
          } else if (GetPlatform.isIOS) {
            exit(0);
          } else {
            Navigator.pushNamed(context, RouteHelper.getInitialRoute());
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('back_press_again_to_exit'.tr,
                style: const TextStyle(color: Colors.white)),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          ));
          _canExit = true;
          Timer(const Duration(seconds: 2), () {
            _canExit = false;
          });
        }
      },
      child: Scaffold(
        endDrawer: const MenuDrawer(),
        endDrawerEnableOpenDragGesture: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              // Custom Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault,
                  vertical: Dimensions.paddingSizeDefault,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.fromHome
                        ? InkWell(
                            onTap: () => Get.back(),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                            ),
                          )
                        : const SizedBox(width: 40),
                    Text(
                      'set_location'.tr,
                      style: robotoBold.copyWith(
                        fontSize: Dimensions.fontSizeExtraLarge,
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              Expanded(
                child: GetBuilder<AddressController>(
                  builder: (addressController) {
                    bool isLoggedIn = AuthHelper.isLoggedIn();

                    if (ResponsiveHelper.isDesktop(context) &&
                        AddressHelper.getUserAddressFromSharedPref() == null) {
                      return WebLandingPage(
                        fromSignUp: widget.fromSignUp,
                        fromHome: widget.fromHome,
                        route: widget.route,
                      );
                    }

                    if (isLoggedIn &&
                        addressController.addressList != null &&
                        addressController.addressList!.isNotEmpty) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: FooterView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    addressController.addressList!.length,
                                padding: ResponsiveHelper.isDesktop(context)
                                    ? const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.paddingSizeExtraLarge,
                                        vertical: Dimensions.paddingSizeSmall,
                                      )
                                    : const EdgeInsets.all(
                                        Dimensions.paddingSizeDefault),
                                itemBuilder: (context, index) {
                                  return Center(
                                    child: SizedBox(
                                      width: 700,
                                      child: AddressWidget(
                                        address: addressController
                                            .addressList![index],
                                        fromAddress: false,
                                        onTap: () {
                                          Get.dialog(const CustomLoaderWidget(),
                                              barrierDismissible: false);
                                          AddressModel address =
                                              addressController
                                                  .addressList![index];
                                          Get.find<LocationController>()
                                              .saveAddressAndNavigate(
                                            address,
                                            widget.fromSignUp,
                                            widget.route,
                                            widget.route != null,
                                            ResponsiveHelper.isDesktop(context),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeLarge),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeDefault),
                                child: _buildButtons(context),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Default / No Address View (Redesigned like Old App)
                    return Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(Dimensions.paddingSizeLarge),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Illustration with gradient circle background
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blue.withOpacity(0.1),
                                          Colors.green.withOpacity(0.1),
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      ),
                                    ),
                                  ),
                                  CustomAssetImageWidget(
                                    Images.deliveryLocation,
                                    height: 180,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtremeLarge),

                              // Title with Gradient
                              Column(
                                children: [
                                  Text(
                                    'find_stores_and_items'.tr,
                                    textAlign: TextAlign.center,
                                    style: robotoBold.copyWith(
                                      fontSize: 24,
                                      height: 1.2,
                                    ),
                                  ),
                                  ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return const LinearGradient(
                                        colors: [
                                          Color(0xFF38BDF8),
                                          Color(0xFF4ADE80),
                                        ],
                                      ).createShader(bounds);
                                    },
                                    child: Text(
                                      'near_you'.tr,
                                      textAlign: TextAlign.center,
                                      style: robotoBold.copyWith(
                                        fontSize: 24,
                                        height: 1.2,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeLarge),
                                child: Text(
                                  'by_allowing_location_access'.tr,
                                  textAlign: TextAlign.center,
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).disabledColor,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtremeLarge),

                              // Buttons
                              _buildButtons(context),

                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        // Use Current Location Button with Gradient
        InkWell(
          onTap: _onUseCurrentLocation,
          child: Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF38BDF8),
                  Color(0xFF4ADE80),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF38BDF8).withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.my_location,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Text(
                  'user_current_location'.tr,
                  style: robotoBold.copyWith(
                    color: Colors.white,
                    fontSize: Dimensions.fontSizeLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        // Pick From Map Button
        InkWell(
          onTap: () {
            if (ResponsiveHelper.isDesktop(Get.context)) {
              showGeneralDialog(
                  context: Get.context!,
                  pageBuilder: (_, __, ___) {
                    return SizedBox(
                        height: 300,
                        width: 300,
                        child: PickMapScreen(
                            fromSignUp: widget.fromSignUp,
                            canRoute: widget.route != null,
                            fromAddAddress: false,
                            route: widget.route ?? RouteHelper.accessLocation));
                  });
            } else {
              Get.toNamed(RouteHelper.getPickMapRoute(
                widget.route ??
                    (widget.fromSignUp
                        ? RouteHelper.signUp
                        : RouteHelper.accessLocation),
                widget.route != null,
              ));
            }
          },
          child: Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              color: Theme.of(context).cardColor,
              border: Border.all(
                color: const Color(0xFF38BDF8).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.map,
                  color: Color(0xFF38BDF8),
                  size: 24,
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Text(
                  'set_from_map'.tr,
                  style: robotoBold.copyWith(
                    color: const Color(0xFF38BDF8),
                    fontSize: Dimensions.fontSizeLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
