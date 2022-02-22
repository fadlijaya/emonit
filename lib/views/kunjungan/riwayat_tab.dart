import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonit/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RiwayatTab extends StatefulWidget {
  const RiwayatTab({Key? key}) : super(key: key);

  @override
  _RiwayatTabState createState() => _RiwayatTabState();
}

class _RiwayatTabState extends State<RiwayatTab> {
  final Stream<QuerySnapshot> _streamRiwayatKunjungan = FirebaseFirestore
      .instance
      .collection("users")
      .doc(_auth.currentUser!.uid)
      .collection("kunjungan")
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _streamRiwayatKunjungan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error!"),
            );
          } else if (!snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Belum Ada Data!"),
            );
          } else {
             return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot data) {
                return SizedBox(
                  child: data['status verifikasi'] != ""
                  ? Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text("${data['kode mitra binaan']}", style: const TextStyle(fontWeight: FontWeight.bold, color: kBlack54),),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${data['nama lokasi']}"),
                              const SizedBox(height: 12,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("${data['tanggal kunjungan']}")
                                ],
                              ),
                              const SizedBox(height: 12,),
                              Text("${data['status verifikasi']}", style: const TextStyle(color: kBlue, fontSize: 12),)
                            ],
                          ),
                        ),
                      ),
                      const Divider(thickness: 2,)
                    ],
                  )
                  : Container()
                );
              }).toList(),
            );
          }
        });
  }
}
