import 'package:granth_flutter/models/author_model.dart';
import 'package:granth_flutter/models/bookdetail_model.dart';
import 'package:granth_flutter/models/category_model.dart';
import 'package:granth_flutter/models/configuration_model.dart';
import 'package:granth_flutter/models/pagination_model.dart';
import 'package:granth_flutter/models/slider_model.dart';
import 'package:granth_flutter/utils/model_keys.dart';

class DashboardResponse {
  List<CategoryBookResponse>? categoryBook;
  int? categoryBookCount;
  List<ConfigurationResponse>? configuration;
  bool? isPaypalConfiguration;
  bool? isPaytmConfiguration;
  String? message;

  List<BookDetailResponse>? popularBook;
  int? popularBookCount;
  List<BookDetailResponse>? recommendedBook;
  List<BookDetailResponse>? data;
  int? recommendedBookCount;
  List<SliderResponse>? slider;
  bool? status;
  Pagination? pagination;
  List<AuthorResponse>? topAuthor;
  List<BookDetailResponse>? topSearchBook;
  int? topSearchBookCount;
  List<BookDetailResponse>? topSellBook;
  int? topSellBookCount;
  List<BookDetailResponse>? historyCategory;
  int? historyCategoryCount;
  List<BookDetailResponse>? artCategory;
  int? artCategoryCount;
  List<BookDetailResponse>? mathCategory;
  int? mathCategoryCount;
  List<BookDetailResponse>? portugueseCategory;
  int? portugueseCategoryCount;
  List<BookDetailResponse>? geographyCategory;
  int? geographyCategoryCount;
  List<BookDetailResponse>? scienceCategory;
  int? scienceCategoryCount;

  DashboardResponse({
    this.categoryBook,
    this.categoryBookCount,
    this.configuration,
    this.isPaypalConfiguration,
    this.isPaytmConfiguration,
    this.message,
    this.popularBook,
    this.popularBookCount,
    this.recommendedBook,
    this.recommendedBookCount,
    this.slider,
    this.status,
    this.data,
    this.topAuthor,
    this.topSearchBook,
    this.topSearchBookCount,
    this.topSellBook,
    this.topSellBookCount,
    this.historyCategory,
    this.historyCategoryCount,
    this.artCategory,
    this.artCategoryCount,
    this.geographyCategory,
    this.geographyCategoryCount,
    this.mathCategory,
    this.mathCategoryCount,
    this.portugueseCategory,
    this.portugueseCategoryCount,
    this.scienceCategory,
    this.scienceCategoryCount
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      categoryBook: json[DashboardKeys.categoryBook] != null
          ? (json[DashboardKeys.categoryBook] as List)
              .map((i) => CategoryBookResponse.fromJson(i))
              .toList()
          : null,
      categoryBookCount: json[DashboardKeys.categoryBookCount],
      configuration: json[DashboardKeys.configuration] != null
          ? (json[DashboardKeys.configuration] as List)
              .map((i) => ConfigurationResponse.fromJson(i))
              .toList()
          : null,
      isPaypalConfiguration: json[DashboardKeys.isPaypalConfiguration],
      isPaytmConfiguration: json[DashboardKeys.isPaytmConfiguration],
      message: json[CommonKeys.message],
      popularBook: json[DashboardKeys.popularBook] != null
          ? (json[DashboardKeys.popularBook] as List)
              .map((i) => BookDetailResponse.fromJson(i))
              .toList()
          : null,
      popularBookCount: json[DashboardKeys.popularBookCount],
      recommendedBook: json[DashboardKeys.recommendedBook] != null
          ? (json[DashboardKeys.recommendedBook] as List)
              .map((i) => BookDetailResponse.fromJson(i))
              .toList()
          : null,
      recommendedBookCount: json[DashboardKeys.recommendedBookCount],
      slider: json[DashboardKeys.slider] != null
          ? (json[DashboardKeys.slider] as List).map((i) => SliderResponse.fromJson(i)).toList()
          : null,
      status: json[CommonKeys.status],
      data: json[CommonKeys.data] != null
          ? (json[CommonKeys.data] as List).map((i) => BookDetailResponse.fromJson(i)).toList()
          : null,
      topAuthor: json[DashboardKeys.topAuthor] != null
          ? (json[DashboardKeys.topAuthor] as List).map((i) => AuthorResponse.fromJson(i)).toList()
          : null,
      topSearchBook: json[DashboardKeys.topSearchBook] != null
          ? (json[DashboardKeys.topSearchBook] as List)
              .map((i) => BookDetailResponse.fromJson(i))
              .toList()
          : null,
      topSearchBookCount: json[DashboardKeys.topSearchBookCount],
      topSellBook: json[DashboardKeys.topSellBook] != null
          ? (json[DashboardKeys.topSellBook] as List)
              .map((i) => BookDetailResponse.fromJson(i))
              .toList()
          : null,
      topSellBookCount: json[DashboardKeys.topSellBookCount],
      historyCategory: json[DashboardKeys.historyCategory] != null
          ? (json[DashboardKeys.historyCategory] as List)
          .map((i) => BookDetailResponse.fromJson(i))
          .toList()
          : null,
      historyCategoryCount: json[DashboardKeys.historyCategoryCount],
      geographyCategory: json[DashboardKeys.geographyCategory] != null
          ? (json[DashboardKeys.geographyCategory] as List)
          .map((i) => BookDetailResponse.fromJson(i))
          .toList()
          : null,
      geographyCategoryCount: json[DashboardKeys.geographyCategoryCount],
      artCategory: json[DashboardKeys.artCategory] != null
          ? (json[DashboardKeys.artCategory] as List)
          .map((i) => BookDetailResponse.fromJson(i))
          .toList()
          : null,
      artCategoryCount: json[DashboardKeys.artCategoryCount],
      scienceCategory: json[DashboardKeys.scienceCategory] != null
          ? (json[DashboardKeys.scienceCategory] as List)
          .map((i) => BookDetailResponse.fromJson(i))
          .toList()
          : null,
      scienceCategoryCount: json[DashboardKeys.scienceCategoryCount],
      mathCategory: json[DashboardKeys.mathCategory] != null
          ? (json[DashboardKeys.mathCategory] as List)
          .map((i) => BookDetailResponse.fromJson(i))
          .toList()
          : null,
      mathCategoryCount: json[DashboardKeys.mathCategoryCount],
      portugueseCategory: json[DashboardKeys.portugueseCategory] != null
          ? (json[DashboardKeys.portugueseCategory] as List)
          .map((i) => BookDetailResponse.fromJson(i))
          .toList()
          : null,
      portugueseCategoryCount: json[DashboardKeys.portugueseCategoryCount],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[DashboardKeys.categoryBookCount] = this.categoryBookCount;
    data[DashboardKeys.isPaypalConfiguration] = this.isPaypalConfiguration;
    data[DashboardKeys.isPaytmConfiguration] = this.isPaytmConfiguration;
    data[CommonKeys.message] = this.message;
    data[DashboardKeys.popularBookCount] = this.popularBookCount;
    data[DashboardKeys.recommendedBookCount] = this.recommendedBookCount;
    data[CommonKeys.status] = this.status;
    data[DashboardKeys.topSearchBookCount] = this.topSellBookCount;
    data[DashboardKeys.topSellBookCount] = this.topSellBookCount;
    if (this.categoryBook != null) {
      data[DashboardKeys.categoryBook] = this.categoryBook!.map((v) => v.toJson()).toList();
    }
    if (this.configuration != null) {
      data[DashboardKeys.configuration] = this.configuration!.map((v) => v.toJson()).toList();
    }
    if (this.popularBook != null) {
      data[DashboardKeys.popularBook] = this.popularBook!.map((v) => v.toJson()).toList();
    }
    if (this.recommendedBook != null) {
      data[DashboardKeys.recommendedBook] = this.recommendedBook!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data[DashboardKeys.recommendedBook] = this.recommendedBook!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data[CommonKeys.data] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.slider != null) {
      data[DashboardKeys.slider] = this.slider!.map((v) => v.toJson()).toList();
    }
    if (this.topAuthor != null) {
      data[DashboardKeys.topAuthor] = this.topAuthor!.map((v) => v.toJson()).toList();
    }
    if (this.topSearchBook != null) {
      data[DashboardKeys.topSearchBook] = this.topSearchBook!.map((v) => v.toJson()).toList();
    }
    if (this.topSellBook != null) {
      data[DashboardKeys.topSellBook] = this.topSellBook!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
