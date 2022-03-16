import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonit/users/model/m_kunjungan.dart';
import 'package:emonit/users/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
var total;

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<ModelKunjungan> data = [
    ModelKunjungan('Jan', 7),
    ModelKunjungan('Feb', 11),
    ModelKunjungan('Mar', 0),
    ModelKunjungan('Apr', 0),
    ModelKunjungan('Mei', 0),
  ];

  @override
  void initState() {
    getTotalKunjungan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              title:
                  ChartTitle(text: "Analisis Kunjungan per Bulan Tahun 2022"),
              legend: Legend(isVisible: true),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<ModelKunjungan, String>>[
                LineSeries<ModelKunjungan, String>(
                    dataSource: data,
                    xValueMapper: (ModelKunjungan mKunjungan, _) =>
                        mKunjungan.bulan,
                    yValueMapper: (ModelKunjungan modelKunjungan, _) =>
                        modelKunjungan.kunjungan,
                    name: 'Kunjungan',
                    color: kRed,
                    // Enable data label
                    dataLabelSettings: const DataLabelSettings(isVisible: true))
              ],
            ),
            const SizedBox(height: 12),
            TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/pdfPreviewPage'),
                child: const Text(
                  "Cetak Report",
                  style: TextStyle(color: kRed),
                )),
          ],
        ),
      ),
    ));
  }

  Widget kunjungan() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .collection("kunjungan")
            .snapshots(),
        builder: (context, snapshot) {
          var total = snapshot.data!.docs.length;
          return Text(total.toString());
        });
  }

  getTotalKunjungan() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .collection("kunjungan")
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          total = snapshot.docs.length;
        });
      }
    });
  }
}
