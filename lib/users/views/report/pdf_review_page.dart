import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

final FirebaseAuth _auth = FirebaseAuth.instance;

class PdfPreviewPage extends StatefulWidget {
  const PdfPreviewPage({Key? key}) : super(key: key);

  @override
  _PdfPreviewPageState createState() => _PdfPreviewPageState();
}

class _PdfPreviewPageState extends State<PdfPreviewPage> {
  String? uid;
  String? fullname;
  String dateNow = DateFormat('dd-MM-yyyy kk:mm').format(DateTime.now());

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(build: (format) => generatePdf(format)),
    );
  }

  Future<Uint8List> generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    var dataList = await getDataKunjungan();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              header(),
              pw.SizedBox(height: 20),
              pw.Divider(thickness: 3),
              title(),
              pw.Divider(thickness: 3),
              pw.SizedBox(height: 8),
              dataKunjungan(dataList),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  header() {
    return pw.Container(
        child: pw
            .Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Text('e-Monit', style: const pw.TextStyle(fontSize: 24)),
        pw.Text(dateNow),
      ]),
      pw.SizedBox(height: 40),
      pw.Row(children: [
        pw.Text('Nama Pegawai :'),
        pw.SizedBox(width: 8),
        pw.Text("$fullname")
      ]),
      pw.SizedBox(height: 8),
      pw.Row(
          children: [pw.Text('UID :'), pw.SizedBox(width: 8), pw.Text("$uid")]),
    ]));
  }

  title() {
    return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          pw.Text("Status"),
          pw.Spacer(),
          pw.Text("Tgl. Verifikasi"),
          pw.Spacer(),
          pw.Text("Tgl. Kunjungan"),
          pw.Spacer(),
          pw.Text("Kode MB"),
        ]);
  }

  dataKunjungan(List listData) {
    return pw.Container(
        child: pw.ListView.builder(
            itemBuilder: (context, i) {
              DocumentSnapshot docSnap = listData[i];
              return pw.Container(
                  child: pw.Column(children: [
                pw.Row(children: [
                  docSnap['status verifikasi'] == ""
                  ? pw.Text("Dalam Proses")
                  : pw.Text("${docSnap['status verifikasi']}",),
                  pw.Spacer(),
                  docSnap['tanggal verifikasi'] == ""
                  ? pw.Text(" ------------------- ")
                  : pw.Text("${docSnap['tanggal verifikasi']}"),
                  pw.Spacer(),
                  pw.Text("${docSnap['tanggal kunjungan']}"),
                  pw.Spacer(),
                  pw.Text("${docSnap['kode mitra binaan']}"),
                ]),
                pw.SizedBox(height: 8)
              ]));
            },
            itemCount: listData.length));
  }

  Future<dynamic> getUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((result) {
      if (result.docs.isNotEmpty) {
        setState(() {
          uid = result.docs[0].data()['uid'];
          fullname = result.docs[0].data()['nama lengkap'];
        });
      }
    });
  }

  getDataKunjungan() async {
    var db = FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .collection("kunjungan");

    var document = await db.get();
    return document.docs;
  }
}
