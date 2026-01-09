import 'dart:async';
import 'package:sixam_mart/common/models/response_model.dart';
import 'package:sixam_mart/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart/features/auth/domain/enum/centralize_login_enum.dart';
import 'package:sixam_mart/features/auth/screens/new_user_setup_screen.dart';
import 'package:sixam_mart/features/auth/widgets/sign_in/existing_user_bottom_sheet.dart';
import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/features/profile/domain/models/update_user_model.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart/features/verification/controllers/verification_controller.dart';
import 'package:sixam_mart/features/verification/domein/enum/verification_type_enum.dart';
import 'package:sixam_mart/features/verification/domein/models/verification_data_model.dart';
import 'package:sixam_mart/features/verification/screens/new_pass_screen.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationScreen extends StatefulWidget {
  final String? number;
  final String? email;
  final bool fromSignUp;
  final String? token;
  final String? password;
  final String loginType;
  final String? firebaseSession;
  final bool fromForgetPassword;
  final UpdateUserModel? userModel;
  final bool backFromThis;
  const VerificationScreen(
      {super.key,
      required this.number,
      required this.password,
      required this.fromSignUp,
      required this.token,
      this.email,
      required this.loginType,
      this.firebaseSession,
      required this.fromForgetPassword,
      this.userModel,
      this.backFromThis = false});

  @override
  VerificationScreenState createState() => VerificationScreenState();
}

class VerificationScreenState extends State<VerificationScreen> {
  String? _number;
  String? _email;
  Timer? _timer;
  int _seconds = 0;
  final ScrollController _scrollController = ScrollController();
  late StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();

    Get.find<VerificationController>()
        .updateVerificationCode('', canUpdate: false);
    if (widget.number != null && widget.number!.isNotEmpty) {
      _number = widget.number!.startsWith('+')
          ? widget.number
          : '+${widget.number!.substring(1, widget.number!.length)}';
    }
    _email = widget.email;
    _startTimer();

    errorController = StreamController<ErrorAnimationType>();
  }

  void _startTimer() {
    _seconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds = _seconds - 1;
      if (_seconds == 0) {
        timer.cancel();
        _timer?.cancel();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
    errorController.close();
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header (Matching Old App Style)
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  Text(
                    _email != null
                        ? 'email_verification'.tr
                        : 'phone_verification'.tr,
                    style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                    ),
                  ),
                  const SizedBox(width: 40), // Balance the back button
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Center(
                  child: SizedBox(
                    width: context.width > 700 ? 500 : context.width,
                    child: GetBuilder<VerificationController>(
                      builder: (verificationController) {
                        return Column(
                          children: [
                            const SizedBox(height: Dimensions.paddingSizeLarge),

                            // Image
                            CustomAssetImageWidget(
                              Images.otpVerification, // Using the PNG we copied
                              height: 120,
                            ),
                            const SizedBox(height: 40),

                            // Instructions
                            Text(
                              'enter_the_verification_sent_to'.tr,
                              style: robotoRegular.copyWith(
                                color: Theme.of(context).disabledColor,
                                fontSize: Dimensions.fontSizeDefault,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),

                            // Phone Number / Email
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(
                                _email ?? _number ?? '',
                                style: robotoBold.copyWith(
                                  fontSize: 20,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 40),

                            // Pin Code Field
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeSmall,
                                ),
                                child: PinCodeTextField(
                                  length: 6,
                                  appContext: context,
                                  keyboardType: TextInputType.number,
                                  animationType: AnimationType.slide,
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    fieldHeight: 55,
                                    fieldWidth: 45,
                                    borderWidth: 1,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusDefault),
                                    selectedColor: const Color(
                                        0xFF38BDF8), // Cyan for focus
                                    selectedFillColor:
                                        Theme.of(context).cardColor,
                                    inactiveFillColor:
                                        Theme.of(context).cardColor,
                                    inactiveColor: Theme.of(context)
                                        .disabledColor
                                        .withValues(alpha: 0.2),
                                    activeColor: const Color(
                                        0xFF38BDF8), // Cyan for active
                                    activeFillColor:
                                        Theme.of(context).cardColor,
                                  ),
                                  animationDuration:
                                      const Duration(milliseconds: 300),
                                  backgroundColor: Colors.transparent,
                                  enableActiveFill: true,
                                  onChanged: verificationController
                                      .updateVerificationCode,
                                  beforeTextPaste: (text) => true,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Timer & Resend
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF38BDF8)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.timer_outlined,
                                    size: 18,
                                    color: const Color(0xFF38BDF8),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '00:${_seconds.toString().padLeft(2, '0')}',
                                    style: robotoBold.copyWith(
                                      color: const Color(0xFF38BDF8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),

                            TextButton(
                              onPressed: _seconds < 1
                                  ? () async {
                                      if (widget.firebaseSession != null) {
                                        await Get.find<AuthController>()
                                            .firebaseVerifyPhoneNumber(
                                          _number!,
                                          widget.token,
                                          widget.loginType,
                                          fromSignUp: widget.fromSignUp,
                                          canRoute: false,
                                        );
                                        _startTimer();
                                      } else {
                                        _resendOtp();
                                      }
                                    }
                                  : null,
                              child: Text(
                                'resend'.tr,
                                style: robotoBold.copyWith(
                                  color: _seconds < 1
                                      ? const Color(0xFF38BDF8)
                                      : Theme.of(context).disabledColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),

                            const SizedBox(height: 50),

                            // Verify Button (Gradient)
                            GetBuilder<ProfileController>(
                              builder: (profileController) {
                                return CustomButton(
                                  radius: Dimensions.radiusDefault,
                                  buttonText: 'verify'.tr,
                                  icon: Icons.check_circle_outline,
                                  isLoading: verificationController.isLoading ||
                                      profileController.isLoading,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF38BDF8), // Cyan
                                      Color(0xFF4ADE80), // Green
                                    ],
                                  ),
                                  onPressed: verificationController
                                              .verificationCode.length <
                                          6
                                      ? null
                                      : () {
                                          if (widget.firebaseSession != null &&
                                              widget.userModel == null) {
                                            verificationController
                                                .verifyFirebaseOtp(
                                              phoneNumber: _number!,
                                              session: widget.firebaseSession!,
                                              loginType: widget.loginType,
                                              otp: verificationController
                                                  .verificationCode,
                                              token: widget.token,
                                              isForgetPassPage:
                                                  widget.fromForgetPassword,
                                              isSignUpPage: widget.loginType ==
                                                      CentralizeLoginType
                                                          .otp.name
                                                  ? false
                                                  : true,
                                            )
                                                .then((value) {
                                              if (value.isSuccess) {
                                                _handleVerifyResponse(
                                                  value,
                                                  _number,
                                                  _email,
                                                );
                                              } else {
                                                showCustomSnackBar(
                                                  value.message,
                                                );
                                              }
                                            });
                                          } else if (widget.userModel != null) {
                                            widget.userModel!.otp =
                                                verificationController
                                                    .verificationCode;
                                            Get.find<ProfileController>()
                                                .updateUserInfo(
                                              widget.userModel!,
                                              Get.find<AuthController>()
                                                  .getUserToken(),
                                              fromButton: true,
                                            )
                                                .then((response) async {
                                              if (response.isSuccess) {
                                                profileController.getUserInfo();
                                                Get.back();
                                                Get.back();
                                                showCustomSnackBar(
                                                  response.message,
                                                  isError: false,
                                                );
                                              } else if (!response.isSuccess &&
                                                  response.updateProfileResponseModel !=
                                                      null) {
                                                showCustomSnackBar(
                                                  response
                                                      .updateProfileResponseModel!
                                                      .message,
                                                );
                                              } else {
                                                showCustomSnackBar(
                                                  response.message,
                                                );
                                              }
                                            });
                                          } else if (widget.fromSignUp) {
                                            verificationController
                                                .verifyPhone(
                                              data: VerificationDataModel(
                                                phone: _number,
                                                email: _email,
                                                verificationType:
                                                    _number != null
                                                        ? VerificationTypeEnum
                                                            .phone.name
                                                        : VerificationTypeEnum
                                                            .email.name,
                                                otp: verificationController
                                                    .verificationCode,
                                                loginType: widget.loginType,
                                                guestId:
                                                    AuthHelper.getGuestId(),
                                              ),
                                            )
                                                .then((value) {
                                              if (value.isSuccess) {
                                                _handleVerifyResponse(
                                                  value,
                                                  _number,
                                                  _email,
                                                );
                                              } else {
                                                showCustomSnackBar(
                                                  value.message,
                                                );
                                              }
                                            });
                                          } else {
                                            verificationController
                                                .verifyToken(
                                              phone: _number,
                                              email: _email,
                                            )
                                                .then((value) {
                                              if (value.isSuccess) {
                                                if (ResponsiveHelper.isDesktop(
                                                    Get.context!)) {
                                                  Get.back();
                                                  Get.dialog(
                                                    Center(
                                                      child: NewPassScreen(
                                                        resetToken:
                                                            verificationController
                                                                .verificationCode,
                                                        number: _number,
                                                        email: _email,
                                                        fromPasswordChange:
                                                            false,
                                                        fromDialog: true,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  Get.toNamed(
                                                    RouteHelper
                                                        .getResetPasswordRoute(
                                                      phone: _number,
                                                      email: _email,
                                                      token:
                                                          verificationController
                                                              .verificationCode,
                                                      page: 'reset-password',
                                                    ),
                                                  );
                                                }
                                              } else {
                                                showCustomSnackBar(
                                                  value.message,
                                                );
                                              }
                                            });
                                          }
                                        },
                                );
                              },
                            ),
                            const SizedBox(height: Dimensions.paddingSizeLarge),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleVerifyResponse(
    ResponseModel response,
    String? number,
    String? email,
  ) {
    if (response.authResponseModel != null &&
        response.authResponseModel!.isExistUser != null) {
      if (ResponsiveHelper.isDesktop(context)) {
        Get.back();
        Get.dialog(
          Center(
            child: ExistingUserBottomSheet(
              userModel: response.authResponseModel!.isExistUser!,
              number: _number,
              email: _email,
              loginType: widget.loginType,
              otp: Get.find<VerificationController>().verificationCode,
              backFromThis: widget.backFromThis,
            ),
          ),
        );
      } else {
        Get.bottomSheet(
          ExistingUserBottomSheet(
            userModel: response.authResponseModel!.isExistUser!,
            number: _number,
            email: _email,
            loginType: widget.loginType,
            otp: Get.find<VerificationController>().verificationCode,
            backFromThis: widget.backFromThis,
          ),
        );
      }
    } else if (response.authResponseModel != null &&
        !response.authResponseModel!.isPersonalInfo!) {
      if (ResponsiveHelper.isDesktop(context)) {
        Get.back();
        Get.dialog(
          NewUserSetupScreen(
            name: '',
            loginType: widget.loginType,
            phone: number,
            email: email,
            backFromThis: widget.backFromThis,
          ),
        );
      } else {
        Get.toNamed(
          RouteHelper.getNewUserSetupScreen(
            name: '',
            loginType: widget.loginType,
            phone: number,
            email: email,
            backFromThis: widget.backFromThis,
          ),
        );
      }
    } else {
      if (widget.fromForgetPassword) {
        Get.toNamed(
          RouteHelper.getResetPasswordRoute(
            phone: _number,
            email: _email,
            token: Get.find<VerificationController>().verificationCode,
            page: 'reset-password',
          ),
        );
      } else {
        if (widget.backFromThis) {
          Get.find<LocationController>().syncZoneData();
          Get.back();
          Get.back();
        } else {
          Get.find<LocationController>().navigateToLocationScreen(
            'verification',
            offNamed: true,
          );
        }
      }
    }
  }

  void _resendOtp() {
    if (widget.userModel != null) {
      Get.find<ProfileController>().updateUserInfo(
        widget.userModel!,
        Get.find<AuthController>().getUserToken(),
        fromVerification: true,
      );
    } else if (widget.fromSignUp) {
      if (widget.loginType == CentralizeLoginType.otp.name) {
        Get.find<AuthController>()
            .otpLogin(
          phone: _number!,
          otp: '',
          loginType: widget.loginType,
          verified: '',
        )
            .then((response) {
          if (response.isSuccess) {
            _startTimer();
            showCustomSnackBar('resend_code_successful'.tr, isError: false);
          } else {
            showCustomSnackBar(response.message);
          }
        });
      } else {
        Get.find<AuthController>()
            .login(
          emailOrPhone: _number != null ? _number! : _email ?? '',
          password: widget.password!,
          loginType: widget.loginType,
          fieldType: _number != null
              ? VerificationTypeEnum.phone.name
              : VerificationTypeEnum.email.name,
        )
            .then((value) {
          if (value.isSuccess) {
            _startTimer();
            showCustomSnackBar('resend_code_successful'.tr, isError: false);
          } else {
            showCustomSnackBar(value.message);
          }
        });
      }
    } else {
      Get.find<VerificationController>()
          .forgetPassword(phone: _number, email: _email)
          .then((value) {
        if (value.isSuccess) {
          _startTimer();
          showCustomSnackBar('resend_code_successful'.tr, isError: false);
        } else {
          showCustomSnackBar(value.message);
        }
      });
    }
  }
}
