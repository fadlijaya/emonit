import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonit/users/theme/colors.dart';
import 'package:emonit/users/views/akun/akun_page.dart';
import 'package:emonit/users/views/home/home_page.dart';
import 'package:emonit/users/views/tambah_kunjungan/tambah_kunjungan_page.dart';
import 'package:emonit/users/views/kunjungan/kunjungan_page.dart';
import 'package:emonit/users/views/report/report_page.dart';
import 'package:flutter/material.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CategoryPage(),
    );
  }
}

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final GlobalKey _bottomNavigationKey = GlobalKey();
  int _selectedIndex = 0;

  final List<Widget> _pageList = [
    const HomePage(),
    const ReportPage(),
    const KunjunganPage(),
    const AkunPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageList.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        key: _bottomNavigationKey,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home, color: kRed,),
            label: 'Beranda',
            icon: Icon(
              Icons.home,
              color: kGrey,
            ),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.article_rounded, color: kRed,),
            label: 'Report',
            icon: Icon(
              Icons.article_rounded,
              color: kGrey,
            ),
          ),
           BottomNavigationBarItem(
            activeIcon: Icon(Icons.timelapse, color: kRed,),
            label: 'Kunjungan',
            icon: Icon(
              Icons.timelapse,
              color: kGrey,
            ),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.account_circle, color: kRed,),
              label: 'Akun Saya',
              icon: Icon(
                Icons.account_circle,
                color: kGrey,
              )),
        ],
        selectedItemColor: kRed,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
      floatingActionButton: FloatingActionButton(onPressed: bottomSheetKunjunganPage, child: const Icon(Icons.add), backgroundColor: kRed,),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

   void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bottomSheetKunjunganPage() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        context: context,
        builder: (_) {
          return Container(
            height: 120,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TambahKunjunganPage(
                                //coordinate: GeoPoint(0.0, 0.0),
                                //location: "",
                              ))),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                        color: kRed,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: const Center(
                        child: Text(
                      'Tambah Kunjungan',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: kWhite),
                    )),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Center(
                      child: Text(
                    'Batal',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  )),
                ),
              ],
            ),
          );
        });
  }
}
