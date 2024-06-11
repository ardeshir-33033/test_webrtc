import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppGlobalData {
  // static int userId = kIsWeb ? 1 : 391;
  // static int opponentUserId = kIsWeb ? 391 : 1;

  static int userId =
      // 1
      391
  ;
  static int opponentUserId =
      // 391
      1
  ;
  static int categoryId = 330;
  static String userName = "Siamak";
  static GlobalKey<NavigatorState>? navigatorKey;
}
