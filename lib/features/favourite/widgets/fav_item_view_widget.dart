import 'package:sixam_mart/features/favourite/controllers/favourite_controller.dart';
import 'package:sixam_mart/features/favourite/widgets/wishlist_card_widget.dart';
import 'package:sixam_mart/features/favourite/widgets/wishlist_store_card.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/no_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavItemViewWidget extends StatelessWidget {
  final bool isStore;
  final bool isSearch;
  const FavItemViewWidget(
      {super.key, required this.isStore, this.isSearch = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FavouriteController>(builder: (favouriteController) {
      return RefreshIndicator(
        onRefresh: () async {
          await favouriteController.getFavouriteList();
        },
        child: (isStore
                ? favouriteController.wishStoreList != null &&
                    favouriteController.wishStoreList!.isNotEmpty
                : favouriteController.wishItemList != null &&
                    favouriteController.wishItemList!.isNotEmpty)
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ResponsiveHelper.isDesktop(context)
                    ? FooterView(
                        child: _buildContent(context, favouriteController),
                      )
                    : _buildContent(context, favouriteController),
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: NoDataScreen(
                    text: 'no_wish_data_found'.tr,
                  ),
                ),
              ),
      );
    });
  }

  Widget _buildContent(
      BuildContext context, FavouriteController favouriteController) {
    return Center(
      child: SizedBox(
        width: Dimensions.webMaxWidth,
        child: isStore
            ? GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveHelper.isMobile(context)
                      ? 1
                      : ResponsiveHelper.isTab(context)
                          ? 2
                          : 3,
                  mainAxisSpacing: Dimensions.paddingSizeLarge,
                  crossAxisSpacing: Dimensions.paddingSizeLarge,
                  mainAxisExtent: 260,
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                itemCount: favouriteController.wishStoreList!.length,
                itemBuilder: (context, index) {
                  return WishlistStoreCard(
                    store: favouriteController.wishStoreList![index]!,
                  );
                },
              )
            : ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault,
                  vertical: Dimensions.paddingSizeSmall,
                ),
                itemCount: favouriteController.wishItemList!.length,
                itemBuilder: (context, index) {
                  return WishlistCardWidget(
                    isStore: false,
                    item: favouriteController.wishItemList![index],
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: Dimensions.paddingSizeDefault,
                ),
              ),
      ),
    );
  }
}
