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
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: const [
                                  DataColumn(label: Text('ID')),
                                  DataColumn(label: Text('Páginas')),
                                  DataColumn(label: Text('Tipo')),
                                  DataColumn(label: Text('Observações')),
                                  DataColumn(label: Text('Faixa Etária')),
                                ],
                                rows: challenges != null
                                    ? challenges!.map((challenge) {
                                        return DataRow(
                                          cells: [
                                            DataCell(
                                                Text(challenge.id.toString())),
                                            DataCell(
                                                Text(challenge.paginas ?? '')),
                                            DataCell(
                                                Text(challenge.tipo ?? '')),
                                            DataCell(Text(
                                                challenge.observacoes ?? '')),
                                            DataCell(Text(
                                                challenge.faixaEtaria ?? '')),
                                          ],
                                        );
                                      }).toList()
                                    : [],
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
