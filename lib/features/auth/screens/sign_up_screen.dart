import 'package:sixam_mart/util/app_colors.dart';
import 'package:sixam_mart/features/auth/widgets/sign_up_widget.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  final bool exitFromApp;
  const SignUpScreen({super.key, this.exitFromApp = false});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)
          ? null
          : !widget.exitFromApp
              ? AppBar(
                  leading: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios_rounded,
                        color: Colors.white),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  actions: const [SizedBox()],
                )
              : null),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: Container(
        decoration: ResponsiveHelper.isDesktop(context)
            ? null
            : const BoxDecoration(gradient: AppColors.mainGradient),
        child: SafeArea(
          bottom: false,
          child: Center(
            child: Column(
              children: [
                if (!ResponsiveHelper.isDesktop(context))
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 10),
                    child: Column(
                      children: [
                        Text(
                          'your_business_name'.tr,
                          style: const TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'company_slogan'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Container(
                    width: context.width > 700 ? 700 : context.width,
                    padding: context.width > 700
                        ? const EdgeInsets.all(40)
                        : const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeLarge,
                          ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: context.width > 700
                          ? BorderRadius.circular(Dimensions.radiusSmall)
                          : const BorderRadius.vertical(
                              top: Radius.circular(40),
                            ),
                      boxShadow: ResponsiveHelper.isDesktop(context)
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.grey[Get.isDarkMode ? 700 : 300]!,
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ResponsiveHelper.isDesktop(context)
                                ? Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      onPressed: () => Get.back(),
                                      icon: const Icon(Icons.clear),
                                    ),
                                  )
                                : const SizedBox(),
                            if (ResponsiveHelper.isDesktop(context))
                              Image.asset(Images.logo, width: 125),
                            SizedBox(
                              height: ResponsiveHelper.isDesktop(context)
                                  ? Dimensions.paddingSizeExtraLarge
                                  : Dimensions.paddingSizeLarge,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'sign_up'.tr,
                                style: robotoBold.copyWith(
                                  fontSize: Dimensions.fontSizeExtraLarge,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: Dimensions.paddingSizeDefault,
                            ),
                            const SignUpWidget(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
