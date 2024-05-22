import 'package:granth_flutter/utils/model_keys.dart';

class LocatorModel {
  int? bookId;
  String? href;
  LocatorData? locator;

  LocatorModel({ this.bookId, this.href, this.locator });

  factory LocatorModel.fromJson(Map<String, dynamic> json) {
    return LocatorModel(
        bookId: json[LocatorModelKeys.bookId],
        href: json[LocatorModelKeys.href],
        locator: LocatorData.fromJson(json[LocatorModelKeys.locations])
    );
  }
}

class LocatorData {
  String? cfi;

  LocatorData({ this.cfi });

  factory LocatorData.fromJson(Map<String, dynamic> json) {
    return LocatorData(
      cfi: json[LocatorModelKeys.cfi]
    );
  }
}

class PostLocatorResponse {
  bool success;
  String message;

  PostLocatorResponse({ required this.success, required this.message });

  factory PostLocatorResponse.fromJson(Map<String, dynamic> json) {
    return PostLocatorResponse(
      success: json[LocatorModelKeys.success],
      message: json[LocatorModelKeys.message]
    );
  }
}