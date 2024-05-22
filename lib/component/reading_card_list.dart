import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:granth_flutter/models/locator_model.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
import 'package:granth_flutter/utils/model_keys.dart';
import '../main.dart';

//import 'epub_viewer_lib/epub_viewer.dart';
//import 'epub_viewer_lib/model/epub_locator.dart';
//import 'epub_viewer_lib/utils/util.dart';
/*
class ReadingListCard extends StatelessWidget {
  final String bookImage;
  final VoidCallback onTap;

  ReadingListCard({Key? key, required this.bookImage, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(left: 10.r),
          child: Imageview(
            image: bookImage,
            width: 160.r,
            height: 240.r,
            radius: 8.r,
          ),
        ));
  }
}
*/
class EpuB extends StatefulWidget {
  EpuB({required this.id, required this.path, required this.darkMode});

final int id;
final String path;
final bool darkMode;

  @override
  _EpuBState createState() => _EpuBState(bookId: this.id.toString(), darkMode: this.darkMode);
}

class _EpuBState extends State<EpuB> {
  _EpuBState({required this.bookId, required this.darkMode});
  EpubLocator? epubLocator;
  final String bookId;
  final bool darkMode;
  Future<PostLocatorResponse>? future;

  @override
  void initState() {
    Get.back();
    epubLocator = EpubLocator(bookId: this.bookId);
    /*
    future = getCategoryWiseBookDetail(
      page: page,
      categoryId: widget.categoryId.validate(),
      books: bookList,
      callback: (res) {
        isLastPage = res;
      },
    );

     */
    VocsyEpub.setConfig(
        themeColor: Colors.blue,
        identifier: "book",
        scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
        allowSharing: false,
        enableTts: true,
        nightMode: darkMode);
    open();
    super.initState();
  }

  open() async {
    String? locatorPref;
    SharedPreferences pref = await SharedPreferences.getInstance();
    locatorPref = pref.getString('locator');
    /*
    try {

      Future<List<LocatorModel>> locatorList = getLocatorData(appStore.userId, widget.id);
      LocatorModel? locator = locatorList.firstOrNull;
      if (locator != null) {
        EpubLocator loc = EpubLocator(bookId: locator.bookId.toString(),
                                      href: locator.href,
                                      locations: Locations(cfi: locator.locator?.cfi));
        locatorPref = jsonEncode(loc.toJson());
      }
    } catch (e, t) {
      print('GET Locator Error ==== $e  $t');
      locatorPref = pref.getString('locator');
    }

     */

    VocsyEpub.locatorStream.listen((locator) {});
    try {
      if (locatorPref != null) {
        Map<String, dynamic> r = jsonDecode(locatorPref);
        setState(() {
          epubLocator = EpubLocator.fromJson(r);
        });
      }
    } on Exception catch (e, t) {
      print('EPUB Error ==== jsonDecode $e  $t');
      epubLocator = EpubLocator();
      pref.remove('locator');
    }

    try {
      VocsyEpub.open(widget.path, lastLocation: epubLocator);
    } catch (e, t) {
      print('EPUB Error==== open $e  $t');
    }
    VocsyEpub.locatorStream.listen((locator) {
      print('LOCATOR: ${EpubLocator.fromJson(jsonDecode(locator))}');
      pref.clear();
      pref.remove('locator');
      pref.setString('locator', locator);
      Map<String, dynamic> decodedLocator = jsonDecode(locator);
      Map<String, dynamic> locatorMap = new Map();
      locatorMap[LocatorModelKeys.bookId] = widget.id;
      locatorMap[LocatorModelKeys.userId] = appStore.userId;
      locatorMap[LocatorModelKeys.href] = decodedLocator[LocatorModelKeys.href];
      locatorMap[LocatorModelKeys.locator] = decodedLocator["locations"];

      postLocatorApi(locatorMap);

    });
  }

  Future<void> postLocatorApi(Map<dynamic, dynamic> locator) async {
    try {
      postLocatorData(locator).then((result) {
        print('LOCATOR POST: ${result}');
      });
    } catch (e, t) {
      print('LOCATOR POST Error: $e  $t');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
