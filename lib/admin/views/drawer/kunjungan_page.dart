import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonit/admin/views/drawer/petugas_page.dart';
import 'package:emonit/users/theme/colors.dart';
import 'package:emonit/users/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

final Stream<QuerySnapshot> _streamKunjungan =
    FirebaseFirestore.instance.collection("kunjungan").snapshots();

class KunjunganPage extends StatefulWidget {
  const KunjunganPage({Key? key}) : super(key: key);

  @override
  _KunjunganPageState createState() => _KunjunganPageState();
}

class _KunjunganPageState extends State<KunjunganPage> {
  @override
  Widget build(BuildContext context) {
    String title = "Data Kunjungan";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: kRed,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: streamBuilder(),
      ),
    );
  }

  Widget streamBuilder() {
    return StreamBuilder<QuerySnapshot>(
        stream: _streamKunjungan,
        builder: ((context, snapshot) {
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
              child: Text(
                "Belum Ada Data!",
                style: TextStyle(color: kBlack54),
              ),
            );
          } else {
            return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot data) {
              return Container(
                padding: const EdgeInsets.all(8),
                child: ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailKunjunganPage(
                              docId: data['docId'],
                              uid: data['uid'],
                              tanggalKunjungan: data['tanggal kunjungan'],
                              nomorHp: data['nomor HP'],
                              namaMB: data['nama mitra binaan'],
                              namaLokasi: data['nama lokasi'],
                              koordinatLokasi: data['koordinat lokasi'],
                              kodeMB: data['kode mitra binaan'],
                              keterangan: data['keterangan'],
                              fileFoto: data['file foto'],
                              alamat: data['alamat'],
                              statusVerifikasi: data['status verifikasi']))),
                  title: Row(
                    children: [
                      Text(
                        "${data['nama mitra binaan']}",
                        style: const TextStyle(
                            color: kBlack54, fontWeight: FontWeight.bold),
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
                        style: const TextStyle(
                          color: kBlack54,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Text("${data['nama lokasi']}"),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${data['tanggal kunjungan']}",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      data['status verifikasi'] == ""
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Icon(
                                  Icons.timelapse,
                                  size: 16,
                                  color: kRed,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "Dalam Proses Pemeriksaan",
                                  style: TextStyle(color: kRed, fontSize: 12),
                                ),
                              ],
                            )
                          : Row(
                              children: const [
                                Icon(
                                  Icons.check,
                                  size: 16,
                                  color: kGreen,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text("Telah Diperiksa",
                                    style:
                                        TextStyle(color: kGreen, fontSize: 12)),
                              ],
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
                                  'Apa kamu ingin menghapus Akun dari ${data['nama mitra binaan']}?'),
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
                                    data.reference.delete();
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
        }));
  }
}

class DetailKunjunganPage extends StatefulWidget {
  final String docId;
  final String uid;
  final String tanggalKunjungan;
  final String nomorHp;
  final String namaMB;
  final String namaLokasi;
  final GeoPoint koordinatLokasi;
  final String kodeMB;
  final String keterangan;
  final String fileFoto;
  final String alamat;
  final String statusVerifikasi;
  const DetailKunjunganPage(
      {Key? key,
      required this.docId,
      required this.uid,
      required this.tanggalKunjungan,
      required this.nomorHp,
      required this.namaMB,
      required this.namaLokasi,
      required this.koordinatLokasi,
      required this.kodeMB,
      required this.keterangan,
      required this.fileFoto,
      required this.alamat,
      required this.statusVerifikasi})
      : super(key: key);

  @override
  _DetailKunjunganPageState createState() => _DetailKunjunganPageState();
}

class _DetailKunjunganPageState extends State<DetailKunjunganPage> {
  String? _uid;
  String? _fullname;
  String? _username;
  String? _email;
  String? _nik;
  String? _phoneNumber;
  String? _workLocation;
  String? _noKtp;
  String? _noKk;
  String? _gender;
  String? _religion;
  String? _placeBirth;
  String? _address;

  String statusVerifikasi1 = "Terverifikasi";
  String statusVerifikasi2 = "Tidak Terverifikasi";

  String tglVerifikasi = DateFormat('dd-MM-yyyy kk:mm').format(DateTime.now());

  bool isVisible = false;

  Future getUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where(widget.uid)
        .get()
        .then((result) {
      if (result.docs.isNotEmpty) {
        setState(() {
          _uid = result.docs[0].data()['uid'];
          _fullname = result.docs[0].data()['nama lengkap'];
          _username = result.docs[0].data()['username'];
          _email = result.docs[0].data()['email'];
          _nik = result.docs[0].data()['nik'];
          _phoneNumber = result.docs[0].data()['nomor hp'];
          _workLocation = result.docs[0].data()['lokasi kerja'];
          _noKtp = result.docs[0].data()['ktp'];
          _noKk = result.docs[0].data()['kk'];
          _gender = result.docs[0].data()['jenis kelamin'];
          _religion = result.docs[0].data()['agama'];
          _placeBirth = result.docs[0].data()['tempat tanggal lahir'];
          _address = result.docs[0].data()['alamat'];
        });
      }
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String title = "Detail Data Kunjungan";

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
              const Center(
                  child: Text(
                "Petugas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Nama Petugas",
                    style: TextStyle(color: kBlack54),
                  ),
                  Flexible(
                      child: Text(
                    "$_fullname",
                    style: const TextStyle(
                        color: kBlack54, fontWeight: FontWeight.bold),
                  ))
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPetugasPage(
                                  uid: _uid.toString(),
                                  username: _username.toString(),
                                  email: _email.toString(),
                                  namaPetugas: _fullname.toString(),
                                  lokasiKerja: _workLocation.toString(),
                                  nomorHp: _phoneNumber.toString(),
                                  alamat: _address.toString(),
                                  agama: _religion.toString(),
                                  jenisKelamin: _gender.toString(),
                                  nik: _nik.toString(),
                                  noKk: _noKk.toString(),
                                  ttl: _placeBirth.toString()))),
                      child: const Text(
                        "Lihat Detail",
                        style: TextStyle(color: kGreen),
                      ))
                ],
              ),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "ID Kunjungan",
                    style: TextStyle(color: kBlack54),
                  ),
                  Text(widget.docId)
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              const Center(
                  child: Text(
                "Mitra Binaan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Kode Mitra Binaan",
                style: TextStyle(color: kBlack54),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                widget.kodeMB,
                style: const TextStyle(
                  color: kBlack54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Nama Mitra Binaan",
                style: TextStyle(color: kBlack54),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                widget.namaMB,
                style: const TextStyle(
                  color: kBlack54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Lokasi",
                style: TextStyle(color: kBlack54),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                widget.namaLokasi,
                style: const TextStyle(
                  color: kBlack54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Koordinat",
                style: TextStyle(color: kBlack54),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "Lat: ${widget.koordinatLokasi.latitude}, Lon: ${widget.koordinatLokasi.longitude}",
                style: const TextStyle(
                  color: kBlack54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Tanggal Kunjungan",
                style: TextStyle(color: kBlack54),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                widget.tanggalKunjungan,
                style: const TextStyle(
                  color: kBlack54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Alamat",
                style: TextStyle(color: kBlack54),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                widget.alamat,
                style: const TextStyle(
                  color: kBlack54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Nomor HP Mitra Binaan",
                style: TextStyle(color: kBlack54),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                widget.nomorHp,
                style: const TextStyle(
                  color: kBlack54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Keterangan",
                style: TextStyle(color: kBlack54),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                widget.keterangan,
                style: const TextStyle(
                    color: kBlack54, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Foto Kunjungan",
                style: TextStyle(color: kBlack54),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.fileFoto))),
              ),
              const SizedBox(
                height: 24,
              ),
              widget.statusVerifikasi == ""
                  ? Column(
                      children: [
                        buttonValid(),
                        const SizedBox(
                          height: 8,
                        ),
                        buttonInvalid()
                      ],
                    )
                  : Visibility(
                      visible: isVisible,
                      child: Column(
                        children: [
                          buttonValid(),
                          const SizedBox(
                            height: 8,
                          ),
                          buttonInvalid()
                        ],
                      ))
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonValid() {
    return ElevatedButton(
        onPressed: terverifikasi,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(kGreen),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)))),
        child: Container(
            width: double.infinity,
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: const Center(
              child: Text(
                "Valid",
                style: TextStyle(color: kWhite),
              ),
            )));
  }

  Widget buttonInvalid() {
    return ElevatedButton(
        onPressed: penolakan,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(kWhite),
            side: MaterialStateProperty.all(const BorderSide(color: kRed)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)))),
        child: Container(
            width: double.infinity,
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: const Center(
              child: Text(
                "Invalid",
                style: TextStyle(color: kRed),
              ),
            )));
  }

  Future<void> updateStatusKunjungan1() {
    CollectionReference kunjungan =
        FirebaseFirestore.instance.collection("kunjungan");
    return kunjungan
        .doc(widget.docId)
        .update({
          'status verifikasi': statusVerifikasi1,
          'tanggal verifikasi': tglVerifikasi
        })
        .then((value) => "Updated")
        .catchError((error) => "Failed to updated: $error");
  }

  Future<void> updateStatusKunjungan2() {
    CollectionReference kunjungan =
        FirebaseFirestore.instance.collection("kunjungan");
    return kunjungan
        .doc(widget.docId)
        .update({
          'status verifikasi': statusVerifikasi2,
          'tanggal verifikasi': tglVerifikasi
        })
        .then((value) => "Updated")
        .catchError((error) => "Failed to updated: $error");
  }

  Future<void> updateStatusUsersKunjungan1() {
    CollectionReference usersKunjungan =
        FirebaseFirestore.instance.collection("users");
    return usersKunjungan
        .doc(widget.uid)
        .collection("kunjungan")
        .doc(widget.docId)
        .update({
          'status verifikasi': statusVerifikasi1,
          'tanggal verifikasi': tglVerifikasi
        })
        .then((value) => "Updated")
        .catchError((error) => "Failed to updated: $error");
  }

  Future<void> updateStatusUsersKunjungan2() {
    CollectionReference usersKunjungan =
        FirebaseFirestore.instance.collection("users");
    return usersKunjungan
        .doc(widget.uid)
        .collection("kunjungan")
        .doc(widget.docId)
        .update({
          'status verifikasi': statusVerifikasi2,
          'tanggal verifikasi': tglVerifikasi
        })
        .then((value) => "Updated")
        .catchError((error) => "Failed to updated: $error");
  }

  Future<dynamic> terverifikasi() async {
    await FirebaseFirestore.instance
        .collection("terverifikasi")
        .doc(widget.docId)
        .set({
      'docId': widget.docId,
      'uid': widget.uid,
      'tanggal kunjungan': widget.tanggalKunjungan,
      'nomor hp': widget.nomorHp,
      'nama mitra binaan': widget.namaMB,
      'nama lokasi': widget.namaLokasi,
      'koordinat lokasi': widget.koordinatLokasi,
      'kode mitra binaan': widget.kodeMB,
      'keterangan': widget.keterangan,
      'file foto': widget.fileFoto,
      'alamat': widget.alamat,
      'status verifikasi': statusVerifikasi1,
      'tanggal verifikasi': tglVerifikasi
    }).then((_) {
      updateStatusKunjungan1();
      updateStatusUsersKunjungan1();
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushNamed(context, '/verifikasi');
      });
    });
  }

  Future<dynamic> penolakan() async {
    await FirebaseFirestore.instance
        .collection("penolakan")
        .doc(widget.docId)
        .set({
      'docId': widget.docId,
      'uid': widget.uid,
      'tanggal kunjungan': widget.tanggalKunjungan,
      'nomor hp': widget.nomorHp,
      'nama mitra binaan': widget.namaMB,
      'nama lokasi': widget.namaLokasi,
      'koordinat lokasi': widget.koordinatLokasi,
      'kode mitra binaan': widget.kodeMB,
      'keterangan': widget.keterangan,
      'file foto': widget.fileFoto,
      'alamat': widget.alamat,
      'status verifikasi': statusVerifikasi2,
      'tanggal verifikasi': tglVerifikasi
    }).then((_) {
      updateStatusKunjungan2();
      updateStatusUsersKunjungan2();
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushNamed(context, '/penolakan');
      });
    });
  }
}
