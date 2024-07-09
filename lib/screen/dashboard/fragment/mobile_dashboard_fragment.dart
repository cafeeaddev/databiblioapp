import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:granth_flutter/component/app_scroll_behaviour.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/models/dashboard_model.dart';
import 'package:granth_flutter/screen/book/component/book_list_component.dart';
import 'package:granth_flutter/screen/book/view_all_book_screen.dart';
import 'package:granth_flutter/screen/dashboard/category_list_screen.dart';
import 'package:granth_flutter/screen/dashboard/component/author_list_component.dart';
import 'package:granth_flutter/screen/dashboard/component/category_component.dart';
import 'package:granth_flutter/screen/dashboard/component/see_all_component.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class MobileDashboardFragment extends StatelessWidget {
  final DashboardResponse? data;

  MobileDashboardFragment({this.data});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: AppScrollBehavior(),
      child: AnimatedScrollView(
        listAnimationType: ListAnimationType.FadeIn,
        dragStartBehavior: DragStartBehavior.start,
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 150,
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Image.asset(
                      'images/app_images/banner-1.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      'images/app_images/banner-2.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              ///Author List Details
              if (data!.topAuthor!.isNotEmpty)
                AuthorListComponent(authorList: data!.topAuthor.validate()),

              /*
              ///Top Search Book
              if (data!.topSearchBook!.isNotEmpty) 24.height,
              SeeAllComponent(
                isShowSeeAll: false,
                title: language!.topSearchBooks,
                onClick: () {
                  ViewAllBookScreen(type: TOP_SEARCH_BOOKS, title: language!.topSearchBooks)
                      .launch(context);
                },
              ).paddingSymmetric(horizontal: 16),
              16.height,
              BookListComponent(bookDetailsList: data!.topSearchBook.validate()),
              */
              ///Popular Search Book
              if (data!.popularBook!.isNotEmpty) 24.height,
              SeeAllComponent(
                isShowSeeAll: false,
                title: language!.popularBooks,
                onClick: () {
                  ViewAllBookScreen(type: POPULAR_BOOKS, title: language!.popularBooks)
                      .launch(context);
                },
              ).paddingSymmetric(horizontal: 16),
              16.height,
              BookListComponent(bookDetailsList: data!.popularBook.validate()),

              /*
              ///Category
              if (data!.categoryBook!.isNotEmpty) 24.height,
              SeeAllComponent(
                isShowSeeAll: false,
                title: language!.categories,
                onClick: () {
                  CategoryListScreen().launch(context);
                },
              ).paddingSymmetric(horizontal: 16),
              16.height,
              CategoryComponent(categoryBookList: data!.categoryBook.validate()),
              */
              /*
              ///Top Sell Book
              if (data!.topSellBook!.isNotEmpty) 24.height,
              SeeAllComponent(
                isShowSeeAll: false,
                title: language!.topSellBooks,
                onClick: () {
                  ViewAllBookScreen(type: TOP_SELL_BOOKS, title: language!.topSellBooks)
                      .launch(context);
                },
              ).paddingSymmetric(horizontal: 16),
              16.height,
              BookListComponent(bookDetailsList: data!.topSellBook.validate()),
              */

              ///Books by category
              ///History
              if (data!.historyCategory!.isNotEmpty) 24.height,
              SeeAllComponent(
                isShowSeeAll: false,
                title: language!.historyCategory,
                onClick: () {
                  ViewAllBookScreen(type: RECOMMENDED_BOOKS, title: language!.historyCategory)
                      .launch(context);
                },
              ).paddingSymmetric(horizontal: 16),
              16.height,
              if (data!.historyCategory!.isNotEmpty)
                BookListComponent(bookDetailsList: data!.historyCategory.validate()),

              ///Geography
              if (data!.geographyCategory!.isNotEmpty) 24.height,
              SeeAllComponent(
                isShowSeeAll: false,
                title: language!.geographyCategory,
                onClick: () {
                  ViewAllBookScreen(type: RECOMMENDED_BOOKS, title: language!.geographyCategory)
                      .launch(context);
                },
              ).paddingSymmetric(horizontal: 16),
              16.height,
              if (data!.geographyCategory!.isNotEmpty)
                BookListComponent(bookDetailsList: data!.geographyCategory.validate()),

              ///Science
              if (data!.scienceCategory!.isNotEmpty) 24.height,
              SeeAllComponent(
                isShowSeeAll: false,
                title: language!.scienceCategory,
                onClick: () {
                  ViewAllBookScreen(type: RECOMMENDED_BOOKS, title: language!.scienceCategory)
                      .launch(context);
                },
              ).paddingSymmetric(horizontal: 16),
              16.height,
              if (data!.scienceCategory!.isNotEmpty)
                BookListComponent(bookDetailsList: data!.scienceCategory.validate()),

              ///Art
              if (data!.artCategory!.isNotEmpty) 24.height,
              SeeAllComponent(
                isShowSeeAll: false,
                title: language!.artCategory,
                onClick: () {
                  ViewAllBookScreen(type: RECOMMENDED_BOOKS, title: language!.artCategory)
                      .launch(context);
                },
              ).paddingSymmetric(horizontal: 16),
              16.height,
              if (data!.artCategory!.isNotEmpty)
                BookListComponent(bookDetailsList: data!.artCategory.validate()),

              ///Math
              if (data!.mathCategory!.isNotEmpty) 24.height,
              SeeAllComponent(
                isShowSeeAll: false,
                title: language!.mathCategory,
                onClick: () {
                  ViewAllBookScreen(type: RECOMMENDED_BOOKS, title: language!.mathCategory)
                      .launch(context);
                },
              ).paddingSymmetric(horizontal: 16),
              16.height,
              if (data!.mathCategory!.isNotEmpty)
                BookListComponent(bookDetailsList: data!.mathCategory.validate()),

              ///Portuguese
              if (data!.portugueseCategory!.isNotEmpty) 24.height,
              SeeAllComponent(
                isShowSeeAll: false,
                title: language!.portugueseCategory,
                onClick: () {
                  ViewAllBookScreen(type: RECOMMENDED_BOOKS, title: language!.portugueseCategory)
                      .launch(context);
                },
              ).paddingSymmetric(horizontal: 16),
              16.height,
              if (data!.portugueseCategory!.isNotEmpty)
                BookListComponent(bookDetailsList: data!.portugueseCategory.validate()),

              ///Recommended Books
              if (data!.topSellBook!.isNotEmpty) 24.height,
              SeeAllComponent(
                isShowSeeAll: false,
                title: language!.recommendedBooks,
                onClick: () {
                  ViewAllBookScreen(type: RECOMMENDED_BOOKS, title: language!.recommendedBooks)
                      .launch(context);
                },
              ).paddingSymmetric(horizontal: 16),
              16.height,
              if (data!.recommendedBook!.isNotEmpty)
                BookListComponent(bookDetailsList: data!.recommendedBook.validate()),
              16.height,
            ],
          ),
        ],
      ),
    );
  }
}
