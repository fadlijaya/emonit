import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonit/users/theme/colors.dart';
import 'package:emonit/users/utils/constant.dart';
import 'package:emonit/users/views/akun/profil_page.dart';
import 'package:emonit/users/views/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AkunPage extends StatefulWidget {
  const AkunPage({Key? key}) : super(key: key);

  @override
  _AkunPageState createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
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
          children: [
            header(),
            buttonProfil(),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: paddingDefault),
                child: Divider(
                  thickness: 1,
                )),
            buttonExit(),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: paddingDefault),
                child: Divider(
                  thickness: 1,
                )),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      width: double.infinity,
      height: 200,
      color: kRed,
      padding: const EdgeInsets.all(paddingDefault),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Akun Saya',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: kWhite)),
            const Icon(Icons.account_circle_rounded,
                size: 72.0, color: kWhite60),
            const SizedBox(
              height: 12,
            ),
            Text(
              '$_fullname',
              style: const TextStyle(
                  color: kWhite, fontWeight: FontWeight.bold, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }

  Widget buttonProfil() {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilPage(
                  uid: _uid.toString(),
                  fullname: _fullname.toString(),
                  username: _username.toString(),
                  email: _email.toString(),
                  nik: _nik.toString(),
                  phoneNumber: _phoneNumber.toString(),
                  workLocation: _workLocation.toString(),
                  noKtp: _noKtp.toString(),
                  noKk: _noKk.toString(),
                  gender: _gender.toString(),
                  religion: _religion.toString(),
                  placeBirth: _placeBirth.toString(),
                  address: _address.toString(),
                  isEdit: true))),
      child: ListTile(
        leading: const Icon(Icons.account_circle_rounded),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Data Pribadi'),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
            )
          ],
        ),
      ),
    );
  }

  Widget buttonExit() {
    return GestureDetector(
      onTap: exitDialog,
      child: ListTile(
        leading: const Icon(Icons.exit_to_app),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Log out'),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
            )
          ],
        ),
      ),
    );
  }

  exitDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text('Ingin Keluar ?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.grey),
                  )),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(kRed),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)))),
                  onPressed: signOut,
                  child: const Text(
                    'Ya',
                    style: TextStyle(color: kWhite),
                  )),
            ],
          );
        });
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false);
  }

  Future getUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
}
