import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonit/utils/constant.dart';
import 'package:flutter/material.dart';

final Stream<QuerySnapshot> _streamVerifikasi = FirebaseFirestore.instance.collection("verifikasi").snapshots();

class VerifikasiPage extends StatefulWidget {
  const VerifikasiPage({Key? key}) : super(key: key);

  @override
  _VerifikasiPageState createState() => _VerifikasiPageState();
}

class _VerifikasiPageState extends State<VerifikasiPage> {
  @override
  Widget build(BuildContext context) {
    String title = "Verifikasi";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(paddingDefault),
      ),
    );
  }
}
