import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonit/users/theme/colors.dart';
import 'package:emonit/users/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerfullName = TextEditingController();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPass = TextEditingController();

  final String? _nik = "";
  final String? _phoneNumber = "";
  final String? _workLocation = "";
  final String? _noKtp = "";
  final String? _noKk = "";
  final String? _gender = "";
  final String? _religion = "";
  final String? _placeBirth = "";
  final String? _address = "";

  late bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kRed,
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(paddingDefault),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(),
              const SizedBox(
                height: 60,
              ),
              formSignUp(),
              const SizedBox(
                height: 60,
              ),
              buttonSignUp()
            ],
          ),
        ),
      )),
    );
  }

  Widget header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            icon: const Icon(
              Icons.arrow_back,
              color: kWhite,
            )),
        const Center(
          child: Text('Sign Up',
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: kWhite)),
        )
      ],
    );
  }

  Widget formSignUp() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _controllerfullName,
            cursorColor: kWhite,
            style: const TextStyle(color: kWhite),
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Masukkan Nama Lengkap',
              hintStyle: TextStyle(color: kWhite),
              focusedBorder:
                  UnderlineInputBorder(borderSide: BorderSide(color: kWhite)),
              prefixIcon: Icon(
                Icons.account_circle,
                color: kWhite,
              ),
              errorStyle: TextStyle(color: kWhite),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Nama Lengkap Tidak Boleh Kosong";
              }
              return null;
            },
          ),
          TextFormField(
            controller: _controllerUsername,
            cursorColor: kWhite,
            style: const TextStyle(color: kWhite),
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Masukkan Username',
              hintStyle: TextStyle(color: kWhite),
              focusedBorder:
                  UnderlineInputBorder(borderSide: BorderSide(color: kWhite)),
              prefixIcon: Icon(
                Icons.account_circle,
                color: kWhite,
              ),
              errorStyle: TextStyle(color: kWhite),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Username Tidak Boleh Kosong";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 12,
          ),
          TextFormField(
            controller: _controllerEmail,
            style: const TextStyle(color: kWhite),
            cursorColor: kWhite,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
                hintStyle: TextStyle(color: kWhite),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: kWhite)),
                prefixIcon: Icon(
                  Icons.email,
                  color: kWhite,
                ),
                errorStyle: TextStyle(color: kWhite),
                labelText: 'Masukkan Email'),
            validator: (value) {
              if (value!.isEmpty) {
                return "Email Tidak Boleh Kosong";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _controllerPassword,
            obscureText: true,
            cursorColor: kWhite,
            textInputAction: TextInputAction.next,
            style: const TextStyle(color: kWhite),
            decoration: const InputDecoration(
                hintStyle: TextStyle(color: kWhite),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: kWhite)),
                prefixIcon: Icon(
                  Icons.lock,
                  color: kWhite,
                ),
                errorStyle: TextStyle(color: kWhite),
                hintText: 'Masukkan Password'),
            validator: (value) {
              if (value!.isEmpty) {
                return "Password Tidak Boleh Kosong";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _controllerConfirmPass,
            obscureText: true,
            cursorColor: kWhite,
            textInputAction: TextInputAction.done,
            style: const TextStyle(color: kWhite),
            decoration: const InputDecoration(
                hintStyle: TextStyle(color: kWhite),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: kWhite)),
                prefixIcon: Icon(
                  Icons.lock,
                  color: kWhite,
                ),
                errorStyle: TextStyle(color: kWhite),
                hintText: 'Konfirmasi Password'),
            validator: (value) {
              if (value!.isEmpty || value != _controllerPassword.text) {
                return "Password Salah";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget buttonSignUp() {
    return ElevatedButton(
      onPressed: signUp,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(kWhite),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
      child: Container(
        margin: const EdgeInsets.only(left: 24, right: 24),
        width: double.infinity,
        height: 48,
        child: const Center(
          child: Text(
            'Sign Up',
            style: TextStyle(color: kRed, fontSize: 16.0),
          ),
        ),
      ),
    );
  }

  Future<dynamic> signUp() async {
    if (!isLoading) {
      if (_formKey.currentState!.validate()) {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _controllerEmail.text, password: _controllerPassword.text);

          User? user = FirebaseAuth.instance.currentUser;

          await FirebaseFirestore.instance
              .collection("users")
              .doc(user!.uid)
              .set({
            'uid': user.uid,
            'nama lengkap': _controllerfullName.text,
            'username': _controllerUsername.text,
            'email': _controllerEmail.text,
            'nik': _nik,
            'nomor hp': _phoneNumber,
            'lokasi kerja': _workLocation,
            'ktp': _noKtp,
            'kk': _noKk,
            'jenis kelamin': _gender,
            'agama': _religion,
            'tempat tanggal lahir': _placeBirth,
            'alamat': _address
          });

          signUpDialog();
        } catch (e) {
          return e.toString();
        }
      }
    }
  }

  signUpDialog() {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.check_circle,
                  color: kGreen,
                  size: 72,
                ),
                SizedBox(
                  height: 16,
                ),
                Center(child: Text('Sign Up Berhasil')),
              ],
            ),
            actions: [
              Center(
                  child: TextButton(
                      onPressed: () =>
                          Navigator.popAndPushNamed(context, '/login'),
                      child: const Text(
                        'OK',
                        style: TextStyle(color: kGreen),
                      )))
            ],
          );
        });
  }
}
