import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/models/bookdetail_model.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/screen/auth/sign_in_screen.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/file_common.dart';
import 'package:granth_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../audiobook/audiobook_player_screen.dart';

class BookButtonComponent extends StatefulWidget {
  static String tag = '/ButtonCommonComponent';
  final BookDetailResponse? bookDetailResponse;

  BookButtonComponent({this.bookDetailResponse});

  @override
  BookButtonComponentState createState() => BookButtonComponentState();
}

class BookButtonComponentState extends State<BookButtonComponent> {
  BookDetailResponse? mBookDetail;

  bool _sampleFileExist = false;
  bool _purchasedFileExist = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (widget.bookDetailResponse != null) {
      mBookDetail = widget.bookDetailResponse;
      setState(() {});
    }

    if (isMobile) {
      _sampleFileExist = await checkFileIsExist(
        bookId: mBookDetail!.bookId.toString(),
        bookPath: mBookDetail!.fileSamplePath.validate(),
        sampleFile: true,
      );
      _purchasedFileExist = await checkFileIsExist(
        bookId: mBookDetail!.bookId.toString(),
        bookPath: mBookDetail!.filePath.validate(),
        sampleFile: false,
      );
      appStore.setSampleFileStatus(_sampleFileExist);
      appStore.setPurchasesFileStatus(_purchasedFileExist);
      setState(() {});
    }
  }

  Future<void> addBookToCart() async {
    appStore.setLoading(true);
    var request = {
      CommonKeys.bookId: mBookDetail!.bookId,
      CartModelKey.addQty: 1,
      BookRatingDataKey.userid: appStore.userId.validate()
    };
    await addToCart(request).then((result) {
      toast(result.message);
      appStore.setCartCount(appStore.cartCount = appStore.cartCount + 1);
      appStore.setLoading(false);
      cartItemListBookId.add(mBookDetail!.bookId.validate());
      LiveStream().emit(CART_DATA_CHANGED);
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: transparentColor,
      child: Center(
        child: Column(
          children: [
            if (widget.bookDetailResponse!.isBorrowed == 0) ...[
              if ((widget.bookDetailResponse!.availableCopies ?? 0) > 0)
                AppButton(
                  enableScaleAnimation: false,
                  color: defaultPrimaryColor,
                  width: context.width() / 2,
                  child: Marquee(
                    child: Text(
                      'Emprestar',
                      style: boldTextStyle(size: 14, color: whiteColor),
                    ),
                  ),
                  onTap: () async {
                    if (appStore.isLoggedIn) {
                    } else {
                      SignInScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                    }
                  },
                )
              else
                AppButton(
                  enableScaleAnimation: false,
                  color: Colors.grey,
                  width: context.width() / 2,
                  child: Marquee(
                    child: Text(
                      'Sem cópias disponíveis',
                      style: boldTextStyle(size: 14, color: whiteColor),
                    ),
                  ),
                  onTap: null,
                ),
            ] else ...[
              AppButton(
                enableScaleAnimation: false,
                color: defaultPrimaryColor,
                width: context.width() / 2,
                child: Marquee(
                  child: Text(
                    widget.bookDetailResponse!.format == 'ebook' ? 'Ler livro' : 'Ouvir AudioLivro',
                    style: boldTextStyle(size: 14, color: whiteColor),
                  ),
                ),
                onTap: () async {
                  if (widget.bookDetailResponse!.format == 'ebook') {
                    if (appStore.isDownloading) {
                      toast(language!.pleaseWait);
                    } else {
                      downloadBook(context,
                          bookDetailResponse: widget.bookDetailResponse, isSample: false);
                    }
                  } else {
                    Get.to(() => AudiobookPlayerScreen(
                          audiobookName: widget.bookDetailResponse!.title!,
                          audiobookUrl: widget.bookDetailResponse!.filePath!,
                        ));
                  }
                },
              ),
              SizedBox(height: 16),
              AppButton(
                enableScaleAnimation: false,
                color: defaultPrimaryColor,
                width: context.width() / 2,
                child: Marquee(
                  child: Text(
                    'Devolver',
                    style: boldTextStyle(size: 14, color: whiteColor),
                  ),
                ),
                onTap: () async {
                  // Implementar lógica de devolução aqui
                },
              ),
              AppButton(
                enableScaleAnimation: false,
                color: defaultPrimaryColor,
                width: context.width() / 2,
                child: Marquee(
                  child: Text(
                    'Renovar Empréstimo',
                    style: boldTextStyle(size: 14, color: whiteColor),
                  ),
                ),
                onTap: () async {
                  // Implementar lógica de renovação de empréstimo aqui
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
