import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import 'package:sixam_mart/features/banner/controllers/banner_controller.dart';
import 'package:sixam_mart/features/brands/controllers/brands_controller.dart';
import 'package:sixam_mart/features/home/controllers/advertisement_controller.dart';
import 'package:sixam_mart/features/home/controllers/home_controller.dart';
import 'package:sixam_mart/features/home/widgets/all_store_filter_widget.dart';
import 'package:sixam_mart/features/home/widgets/cashback_logo_widget.dart';
import 'package:sixam_mart/features/home/widgets/cashback_dialog_widget.dart';
import 'package:sixam_mart/features/home/widgets/refer_bottom_sheet_widget.dart';
import 'package:sixam_mart/features/item/controllers/campaign_controller.dart';
import 'package:sixam_mart/features/category/controllers/category_controller.dart';
import 'package:sixam_mart/features/coupon/controllers/coupon_controller.dart';
import 'package:sixam_mart/features/flash_sale/controllers/flash_sale_controller.dart';

import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/features/notification/controllers/notification_controller.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/store/controllers/store_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/features/address/controllers/address_controller.dart';
import 'package:sixam_mart/features/home/screens/modules/food_home_screen.dart';
import 'package:sixam_mart/features/home/screens/modules/grocery_home_screen.dart';
import 'package:sixam_mart/features/home/screens/modules/pharmacy_home_screen.dart';
import 'package:sixam_mart/features/home/screens/modules/shop_home_screen.dart';
import 'package:sixam_mart/features/parcel/controllers/parcel_controller.dart';
import 'package:sixam_mart/features/rental_module/home/controllers/taxi_home_controller.dart';
import 'package:sixam_mart/features/rental_module/home/screens/taxi_home_screen.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/features/rental_module/rental_cart_screen/controllers/taxi_cart_controller.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';

import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/item_view.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/paginated_list_view.dart';
import 'package:sixam_mart/common/widgets/web_menu_bar.dart';
import 'package:sixam_mart/features/home/screens/web_new_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/home/widgets/module_view.dart';
import 'package:sixam_mart/features/parcel/screens/parcel_category_screen.dart';
import 'package:sixam_mart/util/app_colors.dart'; // Added Import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Future<void> loadData(bool reload, {bool fromModule = false}) async {
    Get.find<LocationController>().syncZoneData();
    Get.find<FlashSaleController>().setEmptyFlashSale(fromModule: fromModule);
    if (AuthHelper.isLoggedIn()) {
      Get.find<StoreController>()
          .getVisitAgainStoreList(fromModule: fromModule);
    }
    if (Get.find<SplashController>().module != null &&
        !Get.find<SplashController>()
            .configModel!
            .moduleConfig!
            .module!
            .isParcel! &&
        !Get.find<SplashController>()
            .configModel!
            .moduleConfig!
            .module!
            .isTaxi!) {
      Get.find<BannerController>().getBannerList(reload);
      Get.find<StoreController>().getRecommendedStoreList();
      if (Get.find<SplashController>().module!.moduleType.toString() ==
          AppConstants.grocery) {
        Get.find<FlashSaleController>().getFlashSale(reload, false);
      }
      if (Get.find<SplashController>().module!.moduleType.toString() ==
          AppConstants.ecommerce) {
        Get.find<ItemController>().getFeaturedCategoriesItemList(false, false);
        Get.find<FlashSaleController>().getFlashSale(reload, false);
        Get.find<BrandsController>().getBrandList();
      }
      Get.find<BannerController>().getPromotionalBannerList(reload);
      Get.find<ItemController>()
          .getDiscountedItemList(offset: '1', firstTimeCategoryLoad: true);
      Get.find<ItemController>()
          .getPopularItemList(offset: '1', firstTimeCategoryLoad: true);
      Get.find<ItemController>()
          .getReviewedItemList(offset: '1', firstTimeCategoryLoad: true);
      Get.find<CategoryController>().getCategoryList(reload);
      Get.find<StoreController>().getPopularStoreList(reload, 'all', false);
      Get.find<CampaignController>().getBasicCampaignList(reload);
      Get.find<CampaignController>().getItemCampaignList(reload);
      Get.find<StoreController>().getLatestStoreList(reload, 'all', false);
      Get.find<StoreController>().getTopOfferStoreList(reload, false);
      Get.find<ItemController>().getRecommendedItemList(reload, 'all', false);
      Get.find<StoreController>().getStoreList(1, reload);
      Get.find<AdvertisementController>().getAdvertisementList();
    }
    if (AuthHelper.isLoggedIn()) {
      await Get.find<ProfileController>().getUserInfo();
      Get.find<NotificationController>().getNotificationList(reload);
      Get.find<CouponController>().getCouponList();
    }
    Get.find<SplashController>().getModules();
    if (Get.find<SplashController>().module == null &&
        Get.find<SplashController>().configModel!.module == null) {
      Get.find<BannerController>().getFeaturedBanner();
      Get.find<StoreController>().getFeaturedStoreList();
      if (AuthHelper.isLoggedIn()) {
        Get.find<AddressController>().getAddressList();
      }
    }
    if (Get.find<SplashController>().module != null &&
        Get.find<SplashController>()
            .configModel!
            .moduleConfig!
            .module!
            .isParcel!) {
      Get.find<ParcelController>().getParcelCategoryList();
    }
    if (Get.find<SplashController>().module != null &&
        Get.find<SplashController>().module!.moduleType.toString() ==
            AppConstants.pharmacy) {
      Get.find<ItemController>().getBasicMedicine(reload, false);
      Get.find<StoreController>().getFeaturedStoreList();
      await Get.find<ItemController>().getCommonConditions(false);
      if (Get.find<ItemController>().commonConditions!.isNotEmpty) {
        Get.find<ItemController>().getConditionsWiseItem(
            Get.find<ItemController>().commonConditions![0].id!, false);
      }
    }
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// ... (Keep existing imports)

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool searchBgShow = false;
  final GlobalKey _headerKey = GlobalKey();
  bool _showAppBarContent = true; // Added
  double _lastScrollOffset = 0.0; // Added

  @override
  void initState() {
    super.initState();

    // Added Scroll Listener for AppBar Animation
    _scrollController.addListener(() {
      if (_scrollController.offset > 50) {
        if (_scrollController.offset > _lastScrollOffset &&
            _showAppBarContent) {
          setState(() {
            _showAppBarContent = false;
          });
        } else if (_scrollController.offset < _lastScrollOffset &&
            !_showAppBarContent) {
          setState(() {
            _showAppBarContent = true;
          });
        }
      } else {
        if (!_showAppBarContent) {
          setState(() {
            _showAppBarContent = true;
          });
        }
      }
      _lastScrollOffset = _scrollController.offset;
    });

    // ... (Keep existing init logic)
    // PusherHelper.initializePusher();

    HomeScreen.loadData(false).then((value) {
      Get.find<SplashController>().getReferBottomSheetStatus();

      if ((Get.find<ProfileController>().userInfoModel?.isValidForDiscount ??
              false) &&
          Get.find<SplashController>().showReferBottomSheet) {
        _showReferBottomSheet();
      }
    });

    if (!ResponsiveHelper.isWeb()) {
      Get.find<LocationController>().getZone(
        AddressHelper.getUserAddressFromSharedPref()!.latitude,
        AddressHelper.getUserAddressFromSharedPref()!.longitude,
        false,
        updateInAddress: true,
      );
    }

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (Get.find<HomeController>().showFavButton) {
          Get.find<HomeController>().changeFavVisibility();
          Future.delayed(const Duration(milliseconds: 800),
              () => Get.find<HomeController>().changeFavVisibility());
        }
      } else {
        if (Get.find<HomeController>().showFavButton) {
          Get.find<HomeController>().changeFavVisibility();
          Future.delayed(const Duration(milliseconds: 800),
              () => Get.find<HomeController>().changeFavVisibility());
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _showReferBottomSheet() {
    ResponsiveHelper.isDesktop(context)
        ? Get.dialog(
            Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(Dimensions.radiusExtraLarge)),
              insetPadding: const EdgeInsets.all(22),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: const ReferBottomSheetWidget(),
            ),
            useSafeArea: false,
          ).then((value) =>
            Get.find<SplashController>().saveReferBottomSheetStatus(false))
        : showModalBottomSheet(
            isScrollControlled: true,
            useRootNavigator: true,
            context: Get.context!,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.radiusExtraLarge),
                  topRight: Radius.circular(Dimensions.radiusExtraLarge)),
            ),
            builder: (context) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8),
                child: const ReferBottomSheetWidget(),
              );
            },
          ).then((value) =>
            Get.find<SplashController>().saveReferBottomSheetStatus(false));
  }

  Future<void> loadTaxiApis() async {
    await Get.find<TaxiHomeController>().getTaxiBannerList(true);
    await Get.find<TaxiHomeController>().getTopRatedCarList(1, true);
    if (AuthHelper.isLoggedIn()) {
      await Get.find<AddressController>().getAddressList();
      await Get.find<TaxiHomeController>().getTaxiCouponList(true);
      await Get.find<TaxiCartController>().getCarCartList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (splashController) {
      if (splashController.moduleList != null &&
          splashController.moduleList!.length == 1) {
        splashController.switchModule(0, true);
      }
      bool showMobileModule = !ResponsiveHelper.isDesktop(context) &&
          splashController.module == null &&
          splashController.configModel!.module == null;
      bool isParcel = splashController.module != null &&
          splashController.module!.moduleType.toString() == AppConstants.parcel;
      bool isPharmacy = splashController.module != null &&
          splashController.module!.moduleType.toString() ==
              AppConstants.pharmacy;
      bool isFood = splashController.module != null &&
          splashController.module!.moduleType.toString() == AppConstants.food;
      bool isShop = splashController.module != null &&
          splashController.module!.moduleType.toString() ==
              AppConstants.ecommerce;
      bool isGrocery = splashController.module != null &&
          splashController.module!.moduleType.toString() ==
              AppConstants.grocery;
      bool isTaxi = splashController.module != null &&
          splashController.module!.moduleType.toString() == AppConstants.taxi;

      return GetBuilder<HomeController>(builder: (homeController) {
        return Scaffold(
          appBar:
              ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
          endDrawer: const MenuDrawer(),
          endDrawerEnableOpenDragGesture: false,
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: isParcel
              ? const ParcelCategoryScreen()
              : SafeArea(
                  bottom: false, // Ensure edge-to-edge
                  top: false, // Allow AppBar to extend behind status bar
                  child: RefreshIndicator(
                    onRefresh: () async {
                      // ... (Keep existing refresh logic)
                      splashController.setRefreshing(true);
                      if (Get.find<SplashController>().module != null &&
                          !isTaxi) {
                        await Get.find<LocationController>().syncZoneData();
                        await Get.find<BannerController>().getBannerList(true);
                        if (isGrocery) {
                          await Get.find<FlashSaleController>()
                              .getFlashSale(true, true);
                        }
                        await Get.find<BannerController>()
                            .getPromotionalBannerList(true);
                        await Get.find<ItemController>()
                            .getDiscountedItemList(offset: '1');
                        await Get.find<CategoryController>()
                            .getCategoryList(true);
                        await Get.find<StoreController>()
                            .getPopularStoreList(true, 'all', false);
                        await Get.find<CampaignController>()
                            .getItemCampaignList(true);
                        Get.find<CampaignController>()
                            .getBasicCampaignList(true);
                        await Get.find<ItemController>()
                            .getPopularItemList(offset: '1');
                        await Get.find<StoreController>()
                            .getLatestStoreList(true, 'all', false);
                        await Get.find<StoreController>()
                            .getTopOfferStoreList(true, false);
                        await Get.find<ItemController>()
                            .getReviewedItemList(offset: '1');
                        await Get.find<StoreController>().getStoreList(1, true);
                        Get.find<AdvertisementController>()
                            .getAdvertisementList();
                        if (AuthHelper.isLoggedIn()) {
                          await Get.find<ProfileController>().getUserInfo();
                          await Get.find<NotificationController>()
                              .getNotificationList(true);
                          Get.find<CouponController>().getCouponList();
                        }
                        if (isPharmacy) {
                          Get.find<ItemController>()
                              .getBasicMedicine(true, true);
                          Get.find<ItemController>().getCommonConditions(true);
                        }
                        if (isShop) {
                          await Get.find<FlashSaleController>()
                              .getFlashSale(true, true);
                          Get.find<ItemController>()
                              .getFeaturedCategoriesItemList(true, true);
                          Get.find<BrandsController>().getBrandList();
                        }
                      } else if (isTaxi) {
                        await loadTaxiApis();
                      } else {
                        await Get.find<BannerController>().getFeaturedBanner();
                        await Get.find<SplashController>().getModules();
                        if (AuthHelper.isLoggedIn()) {
                          await Get.find<AddressController>().getAddressList();
                        }
                        await Get.find<StoreController>()
                            .getFeaturedStoreList();
                      }
                      splashController.setRefreshing(false);
                    },
                    child: ResponsiveHelper.isDesktop(context)
                        ? WebNewHomeScreen(
                            scrollController: _scrollController,
                          )
                        : CustomScrollView(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            slivers: [
                              /// Gradient App Bar
                              SliverAppBar(
                                pinned: true,
                                floating: true,
                                snap: true,
                                toolbarHeight: 0,
                                expandedHeight: 130, // Adjusted height
                                backgroundColor: Colors.transparent,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(30),
                                  ),
                                ),
                                flexibleSpace: Container(
                                  decoration: const BoxDecoration(
                                    gradient: AppColors.mainGradient,
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(30),
                                    ),
                                  ),
                                  child: FlexibleSpaceBar(
                                    titlePadding: EdgeInsets.zero,
                                    centerTitle: true,
                                    expandedTitleScale: 1,
                                    title: AnimatedOpacity(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      opacity: _showAppBarContent ? 1.0 : 0.0,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 30,
                                          left: Dimensions.paddingSizeDefault,
                                          right: Dimensions.paddingSizeDefault,
                                          bottom: 75, // Adjusted padding
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            (splashController.module != null &&
                                                    splashController
                                                            .configModel!
                                                            .module ==
                                                        null &&
                                                    splashController
                                                            .moduleList !=
                                                        null &&
                                                    splashController.moduleList!
                                                            .length !=
                                                        1)
                                                ? InkWell(
                                                    onTap: () =>
                                                        splashController
                                                            .removeModule(),
                                                    child: const Icon(
                                                      Icons.grid_view_rounded,
                                                      size: 25,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            SizedBox(
                                                width: (splashController
                                                                .module !=
                                                            null &&
                                                        splashController
                                                                .configModel!
                                                                .module ==
                                                            null &&
                                                        splashController
                                                                .moduleList !=
                                                            null &&
                                                        splashController
                                                                .moduleList!
                                                                .length !=
                                                            1)
                                                    ? Dimensions
                                                        .paddingSizeSmall
                                                    : 0),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () => Get.find<
                                                        LocationController>()
                                                    .navigateToLocationScreen(
                                                        'home'),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.location_on,
                                                          size: 16,
                                                          color: Colors.white70,
                                                        ),
                                                        const SizedBox(
                                                            width: 4),
                                                        Text(
                                                          AuthHelper
                                                                  .isLoggedIn()
                                                              ? AddressHelper
                                                                      .getUserAddressFromSharedPref()!
                                                                  .addressType!
                                                                  .tr
                                                              : 'your_location'
                                                                  .tr,
                                                          style: robotoMedium
                                                              .copyWith(
                                                            color:
                                                                Colors.white70,
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Row(
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            AddressHelper
                                                                    .getUserAddressFromSharedPref()!
                                                                .address!,
                                                            style: robotoBold
                                                                .copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: Dimensions
                                                                  .fontSizeLarge,
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        const Icon(
                                                          Icons.expand_more,
                                                          color: Colors.white,
                                                          size: 20,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () => Get.toNamed(
                                                  RouteHelper
                                                      .getNotificationRoute()),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.2),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.3),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    const Icon(
                                                      Icons.notifications,
                                                      size: 24,
                                                      color: Colors.white,
                                                    ),
                                                    GetBuilder<
                                                        NotificationController>(
                                                      builder:
                                                          (notificationController) {
                                                        return notificationController
                                                                .hasNotification
                                                            ? Positioned(
                                                                top: -2,
                                                                right: -2,
                                                                child:
                                                                    Container(
                                                                  height: 10,
                                                                  width: 10,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .red,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      width:
                                                                          1.5,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : const SizedBox();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                bottom: PreferredSize(
                                  preferredSize: const Size.fromHeight(70),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: Dimensions.paddingSizeDefault,
                                      right: Dimensions.paddingSizeDefault,
                                      bottom: 20,
                                    ),
                                    child: InkWell(
                                      onTap: () => Get.toNamed(
                                          RouteHelper.getSearchRoute()),
                                      child: Container(
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.paddingSizeSmall,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.05),
                                              spreadRadius: 1,
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.mic,
                                              size: 25,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            const SizedBox(
                                              width:
                                                  Dimensions.paddingSizeSmall,
                                            ),
                                            Expanded(
                                              child: Text(
                                                Get.find<SplashController>()
                                                        .configModel!
                                                        .moduleConfig!
                                                        .module!
                                                        .showRestaurantText!
                                                    ? 'search_food_or_restaurant'
                                                        .tr
                                                    : 'search_item_or_store'.tr,
                                                style: robotoRegular.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeSmall,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              CupertinoIcons.search,
                                              size: 25,
                                              color: Theme.of(context)
                                                  .disabledColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SliverToBoxAdapter(
                                child: Center(
                                    child: SizedBox(
                                  width: Dimensions.webMaxWidth,
                                  child: !showMobileModule
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                              isGrocery
                                                  ? const GroceryHomeScreen()
                                                  : isPharmacy
                                                      ? const PharmacyHomeScreen()
                                                      : isFood
                                                          ? const FoodHomeScreen()
                                                          : isShop
                                                              ? const ShopHomeScreen()
                                                              : isTaxi
                                                                  ? const TaxiHomeScreen()
                                                                  : const SizedBox(),
                                            ])
                                      : ModuleView(
                                          splashController: splashController),
                                )),
                              ),

                              !showMobileModule && !isTaxi
                                  ? SliverPersistentHeader(
                                      key: _headerKey,
                                      pinned: true,
                                      delegate: SliverDelegate(
                                        height: 85,
                                        callback: (val) {
                                          searchBgShow = val;
                                        },
                                        child: const AllStoreFilterWidget(),
                                      ),
                                    )
                                  : const SliverToBoxAdapter(),

                              SliverToBoxAdapter(
                                  child: !showMobileModule && !isTaxi
                                      ? Center(
                                          child: GetBuilder<StoreController>(
                                              builder: (storeController) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: ResponsiveHelper
                                                          .isDesktop(context)
                                                      ? 0
                                                      : 100),
                                              child: PaginatedListView(
                                                scrollController:
                                                    _scrollController,
                                                totalSize: storeController
                                                    .storeModel?.totalSize,
                                                offset: storeController
                                                    .storeModel?.offset,
                                                onPaginate:
                                                    (int? offset) async =>
                                                        await storeController
                                                            .getStoreList(
                                                                offset!, false),
                                                itemView: ItemsView(
                                                  isStore: true,
                                                  items: null,
                                                  isGrid:
                                                      storeController.isGrid,
                                                  isFoodOrGrocery:
                                                      (isFood || isGrocery),
                                                  stores: storeController
                                                      .storeModel?.stores,
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: ResponsiveHelper
                                                            .isDesktop(context)
                                                        ? Dimensions
                                                            .paddingSizeExtraSmall
                                                        : Dimensions
                                                            .paddingSizeSmall,
                                                    vertical: ResponsiveHelper
                                                            .isDesktop(context)
                                                        ? Dimensions
                                                            .paddingSizeExtraSmall
                                                        : Dimensions
                                                            .paddingSizeDefault,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                        )
                                      : const SizedBox()),
                            ],
                          ),
                  ),
                ),
          floatingActionButton: AuthHelper.isLoggedIn() &&
                  homeController.cashBackOfferList != null &&
                  homeController.cashBackOfferList!.isNotEmpty
              ? homeController.showFavButton
                  ? Padding(
                      padding: EdgeInsets.only(
                          bottom: 50.0,
                          right: ResponsiveHelper.isDesktop(context) ? 50 : 0),
                      child: InkWell(
                        onTap: () => Get.dialog(const CashBackDialogWidget()),
                        child: const CashBackLogoWidget(),
                      ),
                    )
                  : null
              : null,
        );
      });
    });
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;
  Function(bool isPinned)? callback;
  bool isPinned = false;

  SliverDelegate({required this.child, this.height = 50, this.callback});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    isPinned = shrinkOffset == maxExtent /*|| shrinkOffset < maxExtent*/;
    callback!(isPinned);
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != height ||
        oldDelegate.minExtent != height ||
        child != oldDelegate.child;
  }
}
