import 'package:granth_flutter/models/challenge_model.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:granth_flutter/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/material.dart';

class MobileChallengesFragment extends StatefulWidget {
  @override
  _MobileChallengesFragmentState createState() =>
      _MobileChallengesFragmentState();
}

class _MobileChallengesFragmentState extends State<MobileChallengesFragment> {
  bool isDataLoaded = false;
  List<ChallengeModel>? challenges;

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

  Future<void> fetchData() async {
    appStore.setLoading(true);
    challenges = await getChallengesData(appStore.userId.toString());
    setState(() {
      isDataLoaded = true;
    });
    appStore.setLoading(false);
  }

  @override
  void dispose() {
    LiveStream().dispose(REFRESH_lIBRARY_LIST);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => DefaultTabController(
        length: appStore.isLoggedIn && appStore.isNetworkConnected ? 3 : 2,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: 110,
                  pinned: true,
                  titleSpacing: 16,
                  actions: <Widget>[],
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      language!.myChallenges,
                      style: boldTextStyle(),
                    ),
                    titlePadding: EdgeInsets.only(bottom: 20, left: 16),
                  ),
                ),
              ];
            },
            body: isDataLoaded
                ? Stack(
                    children: [
                      appStore.isLoggedIn && appStore.isNetworkConnected
                          ? SingleChildScrollView(
                              // scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: challenges != null
                                      ? challenges!
                                          .map((challenge) => Column(
                                                children: [
                                                  Card(
                                                    margin: const EdgeInsets
                                                        .only(
                                                        bottom:
                                                            16.0),
                                                    child: Container(
                                                      width: double
                                                          .infinity,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[300],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16.0),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors
                                                                .grey[500]!
                                                                .withOpacity(
                                                                    0.5),
                                                            offset: Offset(
                                                                5.0, 5.0),
                                                            blurRadius: 10.0,
                                                            spreadRadius: 1.0,
                                                          ),
                                                          BoxShadow(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.5),
                                                            offset: Offset(
                                                                -5.0, -5.0),
                                                            blurRadius: 10.0,
                                                            spreadRadius: 1.0,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(24.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Id: ${challenge.id}',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(height: 8),
                                                            Text(
                                                              'Páginas: ${challenge.paginas ?? ''}',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(height: 8),
                                                            Text(
                                                              'Tipo: ${challenge.tipo ?? ''}',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(height: 8),
                                                            Text(
                                                              'Observações: ${challenge.observacoes ?? ''}',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(height: 8),
                                                            Text(
                                                              'Faixa Etária: ${challenge.faixaEtaria ?? ''}',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ))
                                          .toList()
                                      : [],
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  )
                : Container(),
          ),
        ),
      ),
    );
  }
}
