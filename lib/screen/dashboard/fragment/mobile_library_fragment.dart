import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/models/bookdetail_model.dart';
import 'package:granth_flutter/screen/book/component/book_component.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../network/rest_apis.dart';

class MobileLibraryFragment extends StatefulWidget {
  @override
  _MobileLibraryFragmentState createState() => _MobileLibraryFragmentState();
}

class _MobileLibraryFragmentState extends State<MobileLibraryFragment> {
  List<BookDetailResponse> downloadedList = [];
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    LiveStream().on(REFRESH_lIBRARY_LIST, (p0) async {
      if (mounted) {
        await fetchData();
      }
    });
    init();
  }

  void init() async {
    fetchData();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  // DownloadedBook? isExists(List<DownloadedBook> tasks, BookDetailResponse mBookDetail) {
  //   DownloadedBook? exist;
  //   tasks.forEach((task) {
  //     if (task.bookId == mBookDetail.bookId.toString() && task.fileType == PURCHASED_BOOK) {
  //       exist = task;
  //     }
  //   });
  //   if (exist == null) {
  //     exist = defaultBook(mBookDetail, PURCHASED_BOOK);
  //   }
  //   return exist;
  // }

  Future<void> fetchData() async {
    appStore.setLoading(true);
    downloadedList = await getEmprestimos();

    appStore.setLoading(false);
    setState(() {
      isDataLoaded = true;
    });

    // if (appStore.isLoggedIn) {
    //   purchasedBookList().then((result) async {
    //     BookListModel response = BookListModel.fromJson(result);

    //     await setValue(LIBRARY_BOOK_DATA, jsonEncode(response));
    //     setLibraryData(response, books);

    //     appStore.setLoading(false);
    //     setState(() {
    //       isDataLoaded = true;
    //     });
    //   }).catchError((error) async {
    //     appStore.setLoading(false);
    //     toast(error.toString());
    //     setLibraryData(
    //         BookListModel.fromJson(jsonDecode(getStringAsync(LIBRARY_BOOK_DATA))), books);
    //   });
    // } else {
    //   isDataLoaded = true;
    //   setState(() {});
    //   appStore.setLoading(false);
    // }
  }

  @override
  void dispose() {
    LiveStream().dispose(REFRESH_lIBRARY_LIST);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                expandedHeight: 90,
                pinned: true,
                titleSpacing: 16,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(language!.myLibrary, style: boldTextStyle()),
                  titlePadding: EdgeInsets.only(bottom: 30, left: 16),
                ),
              )
            ];
          },
          body: downloadedList.isNotEmpty
              ? GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .7,
                  ),
                  itemCount: downloadedList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return BookComponent(
                      bookData: downloadedList[index],
                      bookWidth: context.width(),
                      isWishList: false,
                      isCenterBookInfo: false,
                      isLeftDisTag: 0,
                    );
                  },
                )
              : NoDataWidget(title: language!.noPurchasedBookAvailable).visible(
                  isDataLoaded && !appStore.isLoading,
                ),
        ),
      ),
    );
  }
}
