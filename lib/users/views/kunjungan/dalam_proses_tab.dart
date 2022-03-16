import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonit/users/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class DalamProsesTab extends StatefulWidget {
  const DalamProsesTab({Key? key}) : super(key: key);

  @override
  _DalamProsesTabState createState() => _DalamProsesTabState();
}

class _DalamProsesTabState extends State<DalamProsesTab> {
  final Stream<QuerySnapshot> _streamProsesKunjungan = FirebaseFirestore
      .instance
      .collection("users")
      .doc(_auth.currentUser!.uid)
      .collection("kunjungan")
      .orderBy("tanggal kunjungan")
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _streamProsesKunjungan,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              child: Text("Belum Ada Data!"),
            );
          } else {
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot data) {
                return SizedBox(
                    child: data['status verifikasi'] == ""
                        ? Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      Flexible(
                                          child: Text(
                                              "${data['nama mitra binaan']}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: kBlack54))),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      const Text("|"),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        "${data['kode mitra binaan']}", style: const TextStyle(color: kBlack54),
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "${data['nama lokasi']}",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "${data['tanggal kunjungan']}",
                                            style:
                                                const TextStyle(fontSize: 12),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        children: const [
                                          Icon(
                                            Icons.timelapse,
                                            color: kRed,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            "Dalam Proses Verifikasi",
                                            style: TextStyle(
                                                color: kRed, fontSize: 12),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                thickness: 2,
                              )
                            ],
                          )
                        : Container());
              }).toList(),
            );
          }
        });
  }
}
