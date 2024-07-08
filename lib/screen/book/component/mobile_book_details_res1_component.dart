import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:granth_flutter/component/app_loader_widget.dart';
import 'package:granth_flutter/component/download_widget.dart';
import 'package:granth_flutter/models/all_book_details_model.dart';
import 'package:granth_flutter/models/book_ratting_list_model.dart';
import 'package:granth_flutter/network/common_api_call.dart';
import 'package:granth_flutter/screen/auth/sign_in_screen.dart';
import 'package:granth_flutter/screen/book/all_review_list_screen.dart';
import 'package:granth_flutter/screen/book/component/book_button_component.dart';
import 'package:granth_flutter/screen/book/component/book_details1_category_component.dart';
import 'package:granth_flutter/screen/book/component/book_details1_top_component.dart';
import 'package:granth_flutter/screen/book/component/book_list_component.dart';
import 'package:granth_flutter/screen/book/component/ratting_list_component.dart';
import 'package:granth_flutter/screen/book/component/ratting_view_component.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/screen/book/component/write_review_component.dart';
import 'package:granth_flutter/screen/book/view_all_book_screen.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/screen/dashboard/component/see_all_component.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class MobileBookDetailsRes1Component extends StatefulWidget {
  final AllBookDetailsModel bookData;
  final int? bookId;

  MobileBookDetailsRes1Component({required this.bookData, this.bookId});

  @override
  State<MobileBookDetailsRes1Component> createState() => _MobileBookDetailsRes1ComponentState();
}

class _MobileBookDetailsRes1ComponentState extends State<MobileBookDetailsRes1Component> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: context.height(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BookDetails1TopComponent(
                      bookData: widget.bookData.bookDetailResponse!.first),
                  16.height,
                  Text(
                    widget.bookData.bookDetailResponse!.first.name
                        .validate()
                        .capitalizeFirstLetter(),
                    style: boldTextStyle(size: 18),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ).center(),
                  8.height,
                  Text(widget.bookData.authorDetail!.first.name.validate(),
                          style: secondaryTextStyle())
                      .center(),
                  16.height,

                  /// ratting list
                  // RattingViewComponent(bookDetailResponse: bookData.bookDetailResponse!.first, isCenterInfo: true),
                  // 16.height,

                  /// category name
                  BookDetails1CategoryComponent(
                      bookDetailResponse: widget.bookData.bookDetailResponse!.first,
                      isCenterInfo: true),
                  24.height,

                  BookButtonComponent(
                      bookDetailResponse: widget.bookData.bookDetailResponse!.first),
                  24.height,

                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),

                  12.height,

                  ///Introduction title
                  Text(language!.introduction, style: boldTextStyle(size: 24)),
                  8.height,
                  ReadMoreText(
                    widget.bookData.bookDetailResponse!.first.description.validate(),
                    textAlign: TextAlign.justify,
                    style: primaryTextStyle(),
                    colorClickableText: Colors.grey,
                  ),
                  // if (widget.bookData.bookRatingData!.length != 0) 24.height,
                  // if (widget.bookData.bookRatingData!.length != 0)

                  //   ///Top Review
                  //   SeeAllComponent(
                  //     isShowSeeAll:
                  //         widget.bookData.bookRatingData!.length != 0 ? true : false,
                  //     title: language!.topReviews,
                  //     onClick: () async {
                  //       AllReviewListScreen(
                  //         bookRatingData: widget.bookData.bookRatingData.validate(),
                  //         totalRatting: widget.bookData
                  //             .bookDetailResponse!.first.totalRating
                  //             .validate(),
                  //         bookId: widget.bookId,
                  //       ).launch(context);
                  //     },
                  //   ),

                  // if (widget.bookData.bookRatingData!
                  //     .any((element) => element.userId == appStore.userId))
                  //   SizedBox()
                  // else
                  //   Align(
                  //     alignment: Alignment.topRight,
                  //     child: AppButton(
                  //       enableScaleAnimation: false,
                  //       text: language!.writeReview,
                  //       height: 20,
                  //       color: defaultPrimaryColor,
                  //       onTap: () {
                  //         showInDialog(
                  //           context,
                  //           shape: RoundedRectangleBorder(
                  //               borderRadius: radius(defaultRadius)),
                  //           contentPadding: EdgeInsets.all(0),
                  //           builder: (BuildContext context) {
                  //             BookRatingData? mData;

                  //             bool isReview = widget.bookData.bookRatingData!.any(
                  //                 (element) =>
                  //                     element.userId == appStore.userId);
                  //             if (isReview)
                  //               mData = widget.bookData.bookRatingData!.firstWhere(
                  //                   (element) =>
                  //                       element.userId == appStore.userId);

                  //             return WriteReviewComponent(
                  //                 bookRatingData: mData,
                  //                 bookId: widget.bookId,
                  //                 isUpdate: false);
                  //           },
                  //         );
                  //       },
                  //     ),
                  //   ).paddingOnly(top: 16).visible(appStore.isLoggedIn),
                  // 16.height,
                  // ListView.builder(
                  //   shrinkWrap: true,
                  //   physics: NeverScrollableScrollPhysics(),
                  //   itemCount: widget.bookData.bookRatingData!.length,
                  //   itemBuilder: (BuildContext context, int index) {
                  //     BookRatingData mData = widget.bookData.bookRatingData![index];
                  //     return RattingListComponent(
                  //       bookRatingData: mData,
                  //       bookId: widget.bookId,
                  //     ).paddingSymmetric(vertical: 8);
                  //   },
                  // ),
                  // 24.height,
                  // if (widget.bookData.recommendedBook!.isNotEmpty)

                  //   ///Recommended Book
                  //   SeeAllComponent(
                  //     isShowSeeAll: true,
                  //     title: language!.recommendedBooks,
                  //     onClick: () {
                  //       ViewAllBookScreen(
                  //               type: RECOMMENDED_BOOKS,
                  //               title: language!.recommendedBooks)
                  //           .launch(context);
                  //     },
                  //   ),
                  // 16.height,
                  // BookListComponent(
                  //     bookDetailsList: widget.bookData.recommendedBook, padding: 0),
                  // 24.height,

                  // if (widget.bookData.authorBookList!.isNotEmpty)

                  //   ///Author Book
                  //   SeeAllComponent(
                  //       isShowSeeAll: false, title: language!.authorBook),
                  // 16.height,
                  // BookListComponent(
                  //         bookDetailsList: widget.bookData.authorBookList, padding: 0)
                  //     .paddingBottom(64),
                ],
              ),
            ),
          ),
          // Align(
          //     alignment: Alignment.bottomCenter,
          //     child: BookButtonComponent(
          //         bookDetailResponse: bookData.bookDetailResponse!.first)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_outlined),
                onPressed: () {
                  finish(context);
                },
              ),
              Row(
                children: [
                  // IconButton(
                  //   icon: Icon(Icons.share),
                  //   onPressed: () {
                      
                  //   },
                  // ),
                  IconButton(
                    onPressed: () async {
                      if (appStore.isLoggedIn) {
                        if (widget.bookData!.bookDetailResponse!.first.isWishlist.validate() == 1) {
                          appStore.bookWishList.remove(widget.bookData!.bookDetailResponse!.first);
                          widget.bookData!.bookDetailResponse!.first.isWishlist = 0;
                        } else {

                          widget.bookData!.bookDetailResponse!.first.isWishlist = 1;
                          appStore.bookWishList.add(widget.bookData!.bookDetailResponse!.first);
                        }
                        setState(() {
                          
                        });
                        await addRemoveWishListApi(
                                widget.bookData!.bookDetailResponse!.first.bookId.validate(),
                                widget.bookData!.bookDetailResponse!.first.isWishlist.validate())
                            .then((value) {})
                            .catchError((e) {
                          log("Error : ${e.toString()}");
                        });
                      } else {
                        SignInScreen().launch(context);
                      }
                    },
                    icon: Icon(
                        widget.bookData!.bookDetailResponse!.first.isWishlist == 1
                            ? Icons.favorite:
                             Icons.favorite_outline,
                        color: redColor),
                  )
                ],
              )
            ],
          ),

          Observer(builder: (context) {
            return AppLoaderWidget().center().visible(appStore.isLoading);
          }),
          Observer(
            builder: (context) {
              return DownloadWidget(
                downloadPercentage: appStore.downloadPercentageStore,
              ).visible(appStore.isDownloading);
            },
          ),
        ],
      ).paddingAll(16),
    );
  }
}
