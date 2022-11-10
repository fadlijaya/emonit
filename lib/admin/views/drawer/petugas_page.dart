import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonit/users/theme/colors.dart';
import 'package:emonit/users/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final Stream<QuerySnapshot> _streamPetugas =
    FirebaseFirestore.instance.collection('users').snapshots();

class PetugasPage extends StatefulWidget {
  const PetugasPage({Key? key}) : super(key: key);

  @override
  _PetugasPageState createState() => _PetugasPageState();
}

class _PetugasPageState extends State<PetugasPage> {
  String title = "Data Petugas";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: kRed,
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: StreamBuilder<QuerySnapshot>(
            stream: _streamPetugas,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error!'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "Belum Ada Data!",
                    style: TextStyle(color: kBlack54),
                  ),
                );
              } else {
                return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPetugasPage(
                                  uid: data['uid'],
                                  username: data['username'],
                                  email: data['email'],
                                  namaPetugas: data['nama lengkap'],
                                  lokasiKerja: data['lokasi kerja'],
                                  nomorHp: data['nomor hp'],
                                  alamat: data['alamat'],
                                  agama: data['agama'],
                                  jenisKelamin: data['jenis kelamin'],
                                  nik: data['nik'],
                                  noKk: data['kk'],
                                  ttl: data['tempat tanggal lahir']))),
                      leading: const Icon(
                        Icons.account_circle,
                        size: 36,
                      ),
                      title: Text(
                        "${data['nama lengkap']}",
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            "${data['lokasi kerja']}",
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Divider(
                            thickness: 2,
                          )
                        ],
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (BuildContext context) {
                          return <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'hapus',
                              child: Row(
                                children: const [
                                  Icon(Icons.delete),
                                  Padding(
                                    padding: EdgeInsets.only(left: 4),
                                    child: Text("Hapus"),
                                  )
                                ],
                              ),
                            )
                          ];
                        },
                        onSelected: (String value) async {
                          if (value == 'hapus') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Konfirmasi'),
                                  content: Text(
                                      'Apa kamu ingin menghapus Akun dari ${data['nama lengkap']}?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Tidak'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Hapus'),
                                      onPressed: () {
                                        document.reference.delete();
                                        Navigator.pop(context);
                                        Fluttertoast.showToast(
                                            msg: "Data Berhasil Terhapus!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  );
                }).toList());
              }
            }),
      ),
    );
  }
}

class DetailPetugasPage extends StatefulWidget {
  final String uid;
  final String username;
  final String email;
  final String namaPetugas;
  final String lokasiKerja;
  final String nomorHp;
  final String alamat;
  final String agama;
  final String jenisKelamin;
  final String nik;
  final String noKk;
  final String ttl;

  const DetailPetugasPage(
      {Key? key,
      required this.uid,
      required this.username,
      required this.email,
      required this.namaPetugas,
      required this.lokasiKerja,
      required this.nomorHp,
      required this.alamat,
      required this.agama,
      required this.jenisKelamin,
      required this.nik,
      required this.noKk,
      required this.ttl})
      : super(key: key);

  @override
  _DetailPetugasPageState createState() => _DetailPetugasPageState();
}

class _DetailPetugasPageState extends State<DetailPetugasPage> {
  String title = "Detail Data Petugas";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: kRed,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(paddingDefault),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "UID",
                       style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Flexible(child: Text(widget.uid, textAlign: TextAlign.end,)),
                  ],
                ),
              ),
              const Divider(thickness: 1,),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Username",
                       style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Flexible(child: Text(widget.username, textAlign: TextAlign.end,)),
                  ],
                ),
              ),
              const Divider(thickness: 1,),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Email",
                       style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Flexible(child: Text(widget.email, textAlign: TextAlign.end,)),
                  ],
                ),
              ),
              const Divider(thickness: 1,),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Nama Lengkap",
                       style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Flexible(child: Text(widget.namaPetugas, textAlign: TextAlign.end,)),
                  ],
                ),
              ),
              const Divider(thickness: 1,),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Lokasi Kerja",
                       style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Flexible(child: Text(widget.lokasiKerja, textAlign: TextAlign.end,)),
                  ],
                ),
              ),
              const Divider(thickness: 1,),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8), 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Nomor Handphone",
                       style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Flexible(child: Text(widget.nomorHp, textAlign: TextAlign.end,)),
                  ],
                ),
              ),
              const Divider(thickness: 1,),
              Container(
               padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Alamat",
                       style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Flexible(child: Text(widget.alamat, textAlign: TextAlign.end,)),
                  ],
                ),
              ),
              const Divider(thickness: 1,),
              Container(
               padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Agama",
                       style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Flexible(child: Text(widget.agama, textAlign: TextAlign.end,)),
                  ],
                ),
              ),
              const Divider(thickness: 1,),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8), 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Jenis Kelamin",
                       style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Flexible(child: Text(widget.jenisKelamin, textAlign: TextAlign.end,)),
                  ],
                ),
              ),
              const Divider(thickness: 1,),
              Container(
               padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "NIK",
                       style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Flexible(child: Text(widget.nik, textAlign: TextAlign.end,)),
                  ],
                ),
              ),
              const Divider(thickness: 1,),
              Container(
               padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "No. KK",
                       style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Flexible(child: Text(widget.noKk, textAlign: TextAlign.end,)),
                  ],
                ),
              ),
              const Divider(thickness: 1,),
              Container(
               padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Tempat Tanggal Lahir",
                       style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Flexible(child: Text(widget.ttl, textAlign: TextAlign.end,)),
                  ],
                ),
              ),
              const Divider(thickness: 1,),
            ],
          ),
        ),
      ),
    );
  }
}
