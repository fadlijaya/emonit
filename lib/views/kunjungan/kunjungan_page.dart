import 'package:emonit/theme/colors.dart';
import 'package:emonit/views/kunjungan/dalam_proses_tab.dart';
import 'package:emonit/views/kunjungan/riwayat_tab.dart';
import 'package:flutter/material.dart';

class KunjunganPage extends StatefulWidget {
  const KunjunganPage({Key? key}) : super(key: key);

  @override
  _KunjunganPageState createState() => _KunjunganPageState();
}

class _KunjunganPageState extends State<KunjunganPage> {
  @override
  Widget build(BuildContext context) {
    String title = "Kunjungan";

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kWhite,
          title: Text(title),
          centerTitle: true,
          bottom: const PreferredSize(
              child: TabBar(indicatorColor: kRed, tabs: [
                SizedBox(
                  height: 48,
                  child: Tab(
                    text: "Riwayat",
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: Tab(
                    text: "Dalam Proses",
                  ),
                )
              ]),
              preferredSize: Size(0, 0)),
        ),
        body: const TabBarView(
            children: [RiwayatTab(), DalamProsesTab()]),
      ),
    );
  }
}

