import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonit/users/theme/colors.dart';
import 'package:emonit/users/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? uid;
  String? fullname;

  final Stream<QuerySnapshot> _streamKunjungan = FirebaseFirestore.instance
      .collection("users")
      .doc(_auth.currentUser!.uid)
      .collection("kunjungan")
      .orderBy("tanggal kunjungan")
      .snapshots();

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [header(), title(), listKunjungan()],
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      width: double.infinity,
      height: 170,
      decoration: const BoxDecoration(
        color: kRed,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(16), bottomLeft: Radius.circular(16))
      ),
      padding:
          const EdgeInsets.only(top: 40, left: paddingDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/logo_telkom.png",
                width: 72,
              ),
              const SizedBox(
                width: 12,
              ),
              const Text(
                "e-Monit",
                style: TextStyle(
                    fontSize: 20, color: kWhite, fontWeight: FontWeight.w500),
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Selamat Datang',
            style: TextStyle(color: kWhite),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "$fullname",
            style: const TextStyle(
                fontSize: 18, color: kWhite, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget title() {
    return Row(
      children: const [
        Padding(
          padding: EdgeInsets.only(top: 8, bottom: 8, left: paddingDefault,),
          child: Text(
            'Daftar Kunjungan',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: kBlack54),
          ),
        ),
      ],
    );
  }

  Widget listKunjungan() {
    return Expanded(
      flex: 1,
      child: StreamBuilder(
          stream: _streamKunjungan,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Error!"),
              );
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("Belum Ada Data"),
              );
            } else {
              return ListView(
                  physics: const ClampingScrollPhysics(),
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot data) {
                    return SizedBox(
                      height: 320,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                right: 16, left: 16, top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${data['nama mitra binaan']}",
                                      style: const TextStyle(
                                          color: kBlack54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    const Text("|"),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "${data['kode mitra binaan']}",
                                      style:
                                          const TextStyle(color: kBlack54),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "${data['nama lokasi']}",
                                  style: const TextStyle(
                                      fontSize: 12, color: kBlack54),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${data['tanggal kunjungan']}",
                                      style: const TextStyle(
                                          color: kBlack54, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                              child: data['file foto'] != null
                                  ? Container(
                                      width: double.infinity,
                                      height: 160.0,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  "${data['file foto']}"))),
                                    )
                                  : const SizedBox(
                                      height: 120,
                                      child: Center(
                                          child: Text(
                                        'Tidak Dapat Memuat Gambar',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey),
                                      )),
                                    )),
                          const SizedBox(height: 8),
                          data['status verifikasi'] == ""
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: paddingDefault),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.timelapse,
                                        color: kRed,
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "Dalam Proses Verifikasi",
                                        style: TextStyle(
                                            color: kRed, fontSize: 12),
                                      )
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: paddingDefault),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.check,
                                        color: kGreen,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        "Telah Diverifikasi",
                                        style: TextStyle(
                                            color: kGreen, fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                          const SizedBox(height: 8),
                          const Divider(
                            thickness: 1,
                          )
                        ],
                      ),
                    );
                  }).toList());
            }
          }),
    );
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
}
