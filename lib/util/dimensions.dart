import 'package:get/get.dart';

class Dimensions {
  static double fontSizeOverSmall = Get.context!.width >= 1300 ? 12 : 10;
  static double fontSizeExtraSmall = Get.context!.width >= 1300 ? 14 : 12;
  static double fontSizeSmall = Get.context!.width >= 1300 ? 18 : 16;
  static double fontSizeDefault = Get.context!.width >= 1300 ? 20 : 18;
  static double fontSizeLarge = Get.context!.width >= 1300 ? 22 : 20;
  static double fontSizeExtraLarge = Get.context!.width >= 1300 ? 24 : 22;
  static double fontSizeOverLarge = Get.context!.width >= 1300 ? 30 : 28;

  static const double paddingSizeExtraSmall = 5.0;
  static const double paddingSizeSmall = 10.0;
  static const double paddingSizeDefault = 15.0;
  static const double paddingSizeLarge = 20.0;
  static const double paddingSizeExtraLarge = 25.0;
  static const double paddingSizeExtremeLarge = 30.0;
  static const double paddingSizeExtraOverLarge = 35.0;

  static const double radiusSmall = 10.0;
  static const double radiusMedium = 15.0;
  static const double radiusDefault = 20.0;
  static const double radiusLarge = 30.0;
  static const double radiusExtraLarge = 50.0;

  static const double webMaxWidth = 1170;
  static const int messageInputLength = 1000;

  static const double pickMapIconSize = 100.0;
}
