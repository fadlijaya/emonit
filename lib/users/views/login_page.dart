import 'package:emonit/admin/views/dashboard_page.dart';
import 'package:emonit/users/theme/colors.dart';
import 'package:emonit/users/utils/constant.dart';
import 'package:emonit/users/views/initial_page.dart';
import 'package:emonit/users/views/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  late bool _showPassword = true;
  late final bool _isLoading = false;

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const InitialPage()),
            (route) => false);
      });
    }
    super.initState();
  }

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
            children: [
              const SizedBox(
                height: 40,
              ),
              header(),
              const SizedBox(
                height: 40,
              ),
              formLogin(),
              const SizedBox(
                height: 40,
              ),
              buttonLogin(),
              const SizedBox(height: 12),
              signUp()
            ],
          ),
        ),
      )),
    );
  }

  Widget header() {
    return Column(
      children: [
        Image.asset(
          "assets/logo_telkom.png",
          width: 120,
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          "Selamat Datang di Aplikasi e-Monit",
          style: TextStyle(color: kWhite),
        ),
        const SizedBox(
          height: 4,
        ),
        const Text(
          "Telkom Regional 7 Makassar",
          style: TextStyle(color: kWhite),
        ),
      ],
    );
  }

  Widget formLogin() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: const [
                Text(
                  'Login',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24, color: kWhite),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            TextFormField(
              controller: _controllerEmail,
              style: const TextStyle(color: kWhite),
              cursorColor: kWhite,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                  hintStyle: TextStyle(color: kWhite),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kWhite)),
                  prefixIcon: Icon(
                    Icons.email,
                    color: kWhite,
                  ),
                  errorStyle: TextStyle(color: kWhite),
                  hintText: 'Email'),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Masukkan Email";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 40,
            ),
            TextFormField(
              controller: _controllerPassword,
              obscureText: _showPassword,
              cursorColor: kWhite,
              textInputAction: TextInputAction.done,
              style: const TextStyle(color: kWhite),
              decoration: InputDecoration(
                  hintStyle: const TextStyle(color: kWhite),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: kWhite)),
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: kWhite,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: togglePasswordVisibility,
                    child: _showPassword
                        ? const Icon(
                            Icons.visibility_off,
                            color: kWhite,
                          )
                        : const Icon(
                            Icons.visibility,
                            color: kWhite,
                          ),
                  ),
                  errorStyle: const TextStyle(color: kWhite),
                  hintText: 'Password'),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Masukkan Password";
                }
                return null;
              },
            ),
          ],
        ));
  }

  void togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Widget buttonLogin() {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(kWhite),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
      onPressed: login,
      child: Container(
        margin: const EdgeInsets.only(left: 24, right: 24),
        width: double.infinity,
        height: 48,
        child: const Center(
          child: Text(
            'Login',
            style: TextStyle(color: kRed, fontSize: 16.0),
          ),
        ),
      ),
    );
  }

  Widget signUp() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Belum Punya Akun ?',
            style: TextStyle(color: kWhite),
          ),
          const SizedBox(
            width: 8,
          ),
          TextButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SignUpPage())),
              child: const Text(
                'Sign Up',
                style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }

  Future<dynamic> login() async {
    if (!_isLoading) {
      if (_formKey.currentState!.validate()) {
        if (_controllerEmail.text == "admincdcreg7@gmail.com" &&
            _controllerPassword.text == "admincdcreg7") {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: _controllerEmail.text, password: _controllerPassword.text);
               Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashboardPage()),
                    (route) => false);
        } else {
          try {
            await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: _controllerEmail.text,
                    password: _controllerPassword.text)
                .then((user) {
              if (user.user!.email!.isNotEmpty) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InitialPage()),
                    (route) => false);
              }
            });
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              displaySnackBar("Email Tidak Terdaftar");
            } else if (e.code == 'wrong-password') {
              //print('Wrong password provided for that user.');
            }
          }
        }
      }
    }
  }

  displaySnackBar(text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
