import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/models/book_list_model.dart';
import 'package:granth_flutter/models/bookdetail_model.dart';
import 'package:granth_flutter/models/downloaded_book.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/screen/book/component/library_componet.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/file_common.dart';
import 'package:nb_utils/nb_utils.dart';

class MobileLibraryFragment extends StatefulWidget {
  @override
  _MobileLibraryFragmentState createState() => _MobileLibraryFragmentState();
}

class _MobileLibraryFragmentState extends State<MobileLibraryFragment> {
  List<DownloadedBook> purchasedList = [];
  List<DownloadedBook> sampleList = [];
  List<DownloadedBook> downloadedList = [];

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

  DownloadedBook? isExists(List<DownloadedBook> tasks, BookDetailResponse mBookDetail) {
    DownloadedBook? exist;
    tasks.forEach((task) {
      if (task.bookId == mBookDetail.bookId.toString() && task.fileType == PURCHASED_BOOK) {
        exist = task;
      }
    });
    if (exist == null) {
      exist = defaultBook(mBookDetail, PURCHASED_BOOK);
    }
    return exist;
  }

  ///fetch book data call
  Future<void> fetchData() async {
    appStore.setLoading(true);
    List<DownloadedBook>? books = await dbHelper.queryAllRows();

    if (books.isNotEmpty) {
      List<DownloadedBook>? samples = [];
      List<DownloadedBook>? downloadable = [];
      books.forEach((DownloadedBook? book) {
        if (book!.fileType == SAMPLE_BOOK) {
          samples.add(book);
        }
        if (book.fileType == PURCHASED_BOOK) {
          downloadable.add(book);
        }
      });
      setState(() {
        sampleList.clear();
        downloadedList.clear();
        sampleList.addAll(samples);
        downloadedList.addAll(downloadable);

        downloadedList.forEach((purchaseItem) async {
          String filePath =
              await getBookFilePathFromName(purchaseItem.bookName.validate(), isSampleFile: false);
          if (!File(filePath).existsSync()) {
            purchaseItem.isDownloaded = false;
          } else {
            purchaseItem.isDownloaded = true;
          }
        });
      });
    } else {
      sampleList.clear();
      downloadedList.clear();
    }

    if (appStore.isLoggedIn) {
      purchasedBookList().then((result) async {
        BookListModel response = BookListModel.fromJson(result);

        await setValue(LIBRARY_BOOK_DATA, jsonEncode(response));
        setLibraryData(response, books);

        appStore.setLoading(false);
        setState(() {
          isDataLoaded = true;
        });
      }).catchError((error) async {
        appStore.setLoading(false);
        toast(error.toString());
        setLibraryData(
            BookListModel.fromJson(jsonDecode(getStringAsync(LIBRARY_BOOK_DATA))), books);
      });
    } else {
      isDataLoaded = true;
      setState(() {});
      appStore.setLoading(false);
    }
  }

  Future<void> removeBook(DownloadedBook task, context, isSample) async {
    String filePath =
        await getBookFilePathFromName(task.bookName.toString(), isSampleFile: isSample);
    if (!File(filePath).existsSync()) {
      toast("Path: File you're trying to remove doesn't Exist");
    } else {
      await dbHelper
          .delete(task.bookId.validate().toInt())
          .then((value) => toast('Removed from Downloads'));
      await File(filePath).delete();

      init();

      setState(() {});
      LiveStream().emit(REFRESH_lIBRARY_LIST);
    }
  }

  void setLibraryData(BookListModel response, List<DownloadedBook> books) {
    List<DownloadedBook> purchased = [];
    if (response.data!.isNotEmpty) {
      DownloadedBook? book;

      response.data!.forEach((bookDetail) async {
        if (books.isNotEmpty) {
          book = isExists(books, bookDetail);
          if (book!.taskId != null) {
          } else {
            book = defaultBook(bookDetail, PURCHASED_BOOK);
          }
        } else {
          book = defaultBook(bookDetail, SAMPLE_BOOK);
        }
        purchased.add(book!);
      });
      setState(() {
        purchasedList.clear();
        purchasedList.addAll(purchased);
        purchasedList.forEach((purchaseItem) async {
          String filePath =
              await getBookFilePathFromName(purchaseItem.bookName.toString(), isSampleFile: false);
          if (File(filePath).existsSync()) {
            purchaseItem.isDownloaded = true;
          } else {
            purchaseItem.isDownloaded = false;
          }
        });
      });
    }
  }

  ///remove book

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
              ? LibraryComponent(
                  list: downloadedList,
                  i: 2,
                  isSampleExits: false,
                  onRemoveBookUpdate: (DownloadedBook bookDetail) {
                    removeBook(bookDetail, context, false);
                    setState(() {});
                  },
                  onDownloadUpdate: () {
                    fetchData();
                    setState(() {});
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
