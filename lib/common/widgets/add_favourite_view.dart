import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/favourite/controllers/favourite_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/util/app_colors.dart';

class AddFavouriteView extends StatefulWidget {
  final Item? item;
  final double? top, right;
  final double? left;
  final int? storeId;
  const AddFavouriteView(
      {super.key,
      required this.item,
      this.top = 15,
      this.right = 15,
      this.left,
      this.storeId});

  @override
  State<AddFavouriteView> createState() => _AddFavouriteViewState();
}

class _AddFavouriteViewState extends State<AddFavouriteView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      right: widget.right,
      left: widget.left,
      child: GetBuilder<FavouriteController>(builder: (favouriteController) {
        bool isWished;
        if (widget.storeId != null) {
          isWished =
              favouriteController.wishStoreIdList.contains(widget.storeId);
        } else {
          isWished =
              favouriteController.wishItemIdList.contains(widget.item!.id);
        }
        return InkWell(
          onTap: favouriteController.isRemoving
              ? null
              : () {
                  if (AuthHelper.isLoggedIn()) {
                    if (widget.storeId != null) {
                      isWished
                          ? favouriteController.removeFromFavouriteList(
                              widget.storeId, true)
                          : favouriteController.addToFavouriteList(
                              null, widget.storeId, true);
                    } else {
                      isWished
                          ? favouriteController.removeFromFavouriteList(
                              widget.item!.id, false)
                          : favouriteController.addToFavouriteList(
                              widget.item, null, false);
                    }
                  } else {
                    showCustomSnackBar('you_are_not_logged_in'.tr);
                  }
                  _controller.reverse().then((value) => _controller.forward());
                },
          child: ScaleTransition(
            scale: Tween(begin: 0.7, end: 1.0).animate(
                CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
            child: Container(
              height: 33,
              width: 33,
              decoration: BoxDecoration(
                gradient: isWished ? AppColors.mainGradient : null,
                color: isWished ? null : Theme.of(context).cardColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: isWished
                        ? AppColors.green.withOpacity(0.3)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                isWished ? CupertinoIcons.heart_solid : CupertinoIcons.heart,
                color: isWished ? Colors.white : Theme.of(context).primaryColor,
                size: isWished ? 18 : 22,
              ),
            ),
          ),
        );
      }),
    );
  }
}
