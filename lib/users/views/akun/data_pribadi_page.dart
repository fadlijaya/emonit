import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonit/users/theme/colors.dart';
import 'package:emonit/users/utils/constant.dart';
import 'package:flutter/material.dart';

class DataPribadiPage extends StatefulWidget {
  final String uid;
  final String fullname;
  final String username;
  final String email;
  final String nik;
  final String phoneNumber;
  final String workLocation;
  final String noKtp;
  final String noKk;
  final String gender;
  final String religion;
  final String placeBirth;
  final String address;
  final bool isEdit;

  const DataPribadiPage({
    Key? key,
    required this.uid,
    required this.fullname,
    required this.username,
    required this.email,
    required this.nik,
    required this.phoneNumber,
    required this.workLocation,
    required this.noKtp,
    required this.noKk,
    required this.gender,
    required this.religion,
    required this.placeBirth,
    required this.address,
    required this.isEdit,
  }) : super(key: key);

  @override
  _DataPribadiPageState createState() => _DataPribadiPageState();
}

class _DataPribadiPageState extends State<DataPribadiPage> {
  final String title = 'Data Pribadi';
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerfullName = TextEditingController();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerNik = TextEditingController();
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  final TextEditingController _controllerWorkLocation = TextEditingController();
  final TextEditingController _controllerNoKtp = TextEditingController();
  final TextEditingController _controllerNoKk = TextEditingController();
  final TextEditingController _controllerGender = TextEditingController();
  final TextEditingController _controllerReligion = TextEditingController();
  final TextEditingController _controllerPlaceBirth = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();

  @override
  void initState() {
    if (widget.isEdit) {
      setState(() {
        _controllerfullName.text = widget.fullname;
        _controllerUsername.text = widget.username;
        _controllerEmail.text = widget.email;
        _controllerNik.text = widget.nik;
        _controllerPhoneNumber.text = widget.phoneNumber;
        _controllerWorkLocation.text = widget.workLocation;
        _controllerNoKtp.text = widget.noKtp;
        _controllerNoKk.text = widget.noKk;
        _controllerGender.text = widget.gender;
        _controllerReligion.text = widget.religion;
        _controllerPlaceBirth.text = widget.placeBirth;
        _controllerAddress.text = widget.address;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: kRed,
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(paddingDefault),
        child: SingleChildScrollView(
          child: Column(
            children: [
              formProfil(),
              const SizedBox(
                height: 24,
              ),
              buttonUpdate()
            ],
          ),
        ),
      ),
    );
  }

  Widget formProfil() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: const [
              Text(
                "Nama Lengkap",
                style: TextStyle(color: kGrey),
              ),
            ],
          ),
          TextFormField(
            controller: _controllerfullName,
            cursorColor: kRed,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
                hintStyle: TextStyle(color: kRed),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: kRed)),
                hintText: ''),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: const [
              Text(
                "Username",
                style: TextStyle(color: kGrey),
              ),
            ],
          ),
          TextFormField(
            controller: _controllerUsername,
            cursorColor: kRed,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
                hintStyle: TextStyle(color: kRed),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: kRed)),
                hintText: ''),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: const [
              Text(
                "Email",
                style: TextStyle(color: kGrey),
              ),
            ],
          ),
          TextFormField(
            controller: _controllerEmail,
            cursorColor: kRed,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
                hintStyle: TextStyle(color: kRed),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: kRed)),
                hintText: ''),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: const [
              Text(
                "NIK",
                style: TextStyle(color: kGrey),
              ),
            ],
          ),
          TextFormField(
            controller: _controllerNik,
            cursorColor: kRed,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                hintStyle: TextStyle(color: kRed),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: kRed)),
                hintText: ''),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: const [
              Text(
                "Nomor HP",
                style: TextStyle(color: kGrey),
              ),
            ],
          ),
          TextFormField(
            controller: _controllerPhoneNumber,
            cursorColor: kRed,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
                hintStyle: TextStyle(color: kRed),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: kRed)),
                hintText: ''),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: const [
              Text(
                "Lokasi Kerja",
                style: TextStyle(color: kGrey),
              ),
            ],
          ),
          TextFormField(
            controller: _controllerWorkLocation,
            cursorColor: kRed,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
                hintStyle: TextStyle(color: kRed),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: kRed)),
                hintText: ''),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: const [
              Text(
                "No. KTP",
                style: TextStyle(color: kGrey),
              ),
            ],
          ),
          TextFormField(
            controller: _controllerNoKtp,
            cursorColor: kRed,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                hintStyle: TextStyle(color: kRed),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: kRed)),
                hintText: ''),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: const [
              Text(
                "No. KK",
                style: TextStyle(color: kGrey),
              ),
            ],
          ),
          TextFormField(
            controller: _controllerNoKk,
            cursorColor: kRed,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                hintStyle: TextStyle(color: kRed),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: kRed)),
                hintText: ''),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: const [
              Text(
                "Jenis Kelamin",
                style: TextStyle(color: kGrey),
              ),
            ],
          ),
          TextFormField(
            controller: _controllerGender,
            cursorColor: kRed,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
                hintStyle: TextStyle(color: kRed),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: kRed)),
                hintText: ''),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: const [
              Text(
                "Agama",
                style: TextStyle(color: kGrey),
              ),
            ],
          ),
          TextFormField(
            controller: _controllerReligion,
            cursorColor: kRed,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
                hintStyle: TextStyle(color: kRed),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: kRed)),
                hintText: ''),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: const [
              Text(
                "Tempat Tanggal Lahir",
                style: TextStyle(color: kGrey),
              ),
            ],
          ),
          TextFormField(
            controller: _controllerPlaceBirth,
            cursorColor: kRed,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
                hintStyle: TextStyle(color: kRed),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: kRed)),
                hintText: ''),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: const [
              Text(
                "Alamat",
                style: TextStyle(color: kGrey),
              ),
            ],
          ),
          TextFormField(
            controller: _controllerAddress,
            cursorColor: kRed,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
                hintStyle: TextStyle(color: kRed),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: kRed)),
                hintText: ''),
          ),
        ],
      ),
    );
  }

  Widget buttonUpdate() {
    return ElevatedButton(
        onPressed: updateData,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(kRed),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)))),
        child: Container(
          width: double.infinity,
          height: 48,
          margin: const EdgeInsets.only(left: 24, right: 24),
          child: const Center(
            child: Text("Update"),
          ),
        ));
  }

  Future<dynamic> updateData() async {
    if (widget.isEdit) {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('users').doc(widget.uid);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot documentSnapshot =
            await transaction.get(documentReference);

        if (documentSnapshot.exists) {
          transaction.update(documentReference, <String, dynamic>{
            'nama lengkap': _controllerfullName.text,
            'username': _controllerUsername.text,
            'email': _controllerEmail.text,
            'nik': _controllerNik.text,
            'nomor hp': _controllerPhoneNumber.text,
            'lokasi kerja': _controllerWorkLocation.text,
            'ktp': _controllerNoKtp.text,
            'kk': _controllerNoKk.text,
            'jenis kelamin': _controllerGender.text,
            'agama': _controllerReligion.text,
            'tempat tanggal lahir': _controllerPlaceBirth.text,
            'alamat': _controllerAddress.text
          });
        }
      });

      infoUpdate();
    }

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  infoUpdate() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "Data Berhasil di Update",
                  style: TextStyle(color: kBlack54),
                ),
              ],
            ),
          );
        });
  }
}
