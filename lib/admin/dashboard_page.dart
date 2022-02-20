import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonit/admin/drawer/kunjungan_page.dart';
import 'package:emonit/admin/drawer/petugas_page.dart';
import 'package:emonit/theme/colors.dart';
import 'package:emonit/utils/constant.dart';
import 'package:emonit/views/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final Stream<QuerySnapshot> _streamPetugas =
    FirebaseFirestore.instance.collection("users").snapshots();

final Stream<QuerySnapshot> _streamKunjungan =
    FirebaseFirestore.instance.collection("kunjungan").snapshots();

final Stream<QuerySnapshot> _streamVerifikasi =
    FirebaseFirestore.instance.collection("kunjungan").snapshots();

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? _uid;
  String? _name;
  String? _email;

  @override
  void initState() {
    getAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String title = "Dashboard";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: kRed,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            drawerHeader(),
            ListTile(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const PetugasPage())),
              leading: const Icon(Icons.account_circle),
              title: const Text(
                "Data Petugas",
                style: TextStyle(color: kBlack54),
              ),
            ),
            ListTile(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const KunjunganPage())),
              leading: const Icon(
                Icons.timelapse,
              ),
              title: const Text(
                "Data Kunjungan",
                style: TextStyle(color: kBlack54),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.verified),
              title: Text(
                "Verifikasi",
                style: TextStyle(color: kBlack54),
              ),
            ),
            const Divider(
              thickness: 1,
            ),
            ListTile(
              onTap: logout,
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                "Log out",
                style: TextStyle(color: kBlack54),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(8),
        child: GridView.count(
          crossAxisCount: 2,
          children: [cardPetugas(), cardKunjungan(), cardVerifikasi()],
        ),
      ),
    );
  }

  Widget drawerHeader() {
    return UserAccountsDrawerHeader(
        decoration: const BoxDecoration(color: kRed),
        currentAccountPicture: const ClipOval(
          child:
              Image(fit: BoxFit.cover, image: AssetImage("assets/admin.jpg")),
        ),
        accountName: Text(
          "$_name",
          style: const TextStyle(color: kWhite),
        ),
        accountEmail: Text(
          "$_email",
          style: const TextStyle(color: kWhite),
        ));
  }

  Widget cardPetugas() {
    return StreamBuilder<QuerySnapshot>(
        stream: _streamPetugas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error!"),
            );
          } else {
            int totalData = snapshot.data!.docs.length;
            return Card(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(
                            top: paddingDefault, left: paddingDefault),
                        child: Icon(
                          Icons.account_circle,
                          size: 48.0,
                          
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${int.parse(totalData.toString())}",
                    style: const TextStyle(
                       
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text('Petugas',
                      style:
                          TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
            );
          }
        });
  }

  Widget cardKunjungan() {
    return StreamBuilder<QuerySnapshot>(
        stream: _streamKunjungan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error!"),
            );
          } else {
            int totalData = snapshot.data!.docs.length;
            return Card(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(
                            top: paddingDefault, left: paddingDefault),
                        child: Icon(Icons.timelapse, size: 48.0, color: kBlue),
                      ),
                    ],
                  ),
                  Text(
                    "${int.parse(totalData.toString())}", //dashboardModel.totalProduct.toString(),
                    style: const TextStyle(
                        
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'Kunjungan',
                    style: TextStyle(
                         fontWeight: FontWeight.bold),
                  )
                ],
              ),
            );
          }
        });
  }

  Widget cardVerifikasi() {
    return StreamBuilder<QuerySnapshot>(
      stream: _streamVerifikasi,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error!"),);
        }
        return Card(
          elevation: 10.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            children: [
              Row(
                children: const [
                  Padding(
                    padding:
                        EdgeInsets.only(top: paddingDefault, left: paddingDefault),
                    child: Icon(Icons.verified,
                        size: 48.0, color: kGreen),
                  ),
                ],
              ),
              const Text(
                "", 
                style: TextStyle(
                    
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Verifikasi',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        );
      }
    );
  }

  Future getAdmin() async {
    await FirebaseFirestore.instance
        .collection('admin')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((result) {
      if (result.docs.isNotEmpty) {
        setState(() {
          _uid = result.docs[0].data()['uid'];
          _name = result.docs[0].data()['nama'];
          _email = result.docs[0].data()['email'];
        });
      }
    });
  }

  Future<void> logout() async {
    await FirebaseAuth.instance
        .signOut()
        .then((_) => Navigator.pushNamed(context, '/login'));
  }
}
