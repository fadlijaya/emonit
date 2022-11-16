import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:emonit/users/theme/colors.dart';
import 'package:emonit/users/utils/constant.dart';
import 'package:emonit/users/views/tambah_kunjungan/lokasi_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class TambahKunjunganPage extends StatefulWidget {
  const TambahKunjunganPage(
      {Key? key,})
      : super(key: key);

  @override
  _TambahKunjunganPageState createState() => _TambahKunjunganPageState();
}

class _TambahKunjunganPageState extends State<TambahKunjunganPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final Completer<GoogleMapController> _mapController = Completer();

  void onMapCreated(GoogleMapController _controller) {
    _mapController.complete(_controller);
  }

  final TextEditingController _controllerNamaMB = TextEditingController();
  final TextEditingController _controllerKodeMB = TextEditingController();
  final TextEditingController _controllerNomorHp = TextEditingController();
  final TextEditingController _controllerAlamat = TextEditingController();
  final TextEditingController _controllerKeterangan = TextEditingController();

  final String statusVerifikasi = "";
  final String tanggalVerifikasi = "";

  String? uid;
  String? namaPetugas;
  String? _imageURL;
  String dateNow = DateFormat('dd-MM-yyyy - kk:mm').format(DateTime.now());

  // ignore: prefer_typing_uninitialized_variables
  var _imageFile;
  //late AnimationController loadingController;

  LocationData? _currentPosition;
  String? _address, _dateTime;
  late GoogleMapController mapController;
  Marker? marker;
  Location location = Location();

  late GoogleMapController _controller;
  LatLng _initialcameraposition = const LatLng(0.5937, 0.9629);

  @override
  void initState() {
    getUser();
    getLoc();
    /*loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {});
      });*/
    super.initState();
  }

  /*_onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        ),
      );
    });
  }*/

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
    _initialcameraposition =
        LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
    location.onLocationChanged.listen((LocationData currentLocation) {
      if (!mounted) return;
      setState(() {
        _currentPosition = currentLocation;
        _initialcameraposition =
            LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);

        DateTime now = DateTime.now();
        _dateTime = DateFormat('EEE d MMM kk:mm:ss ').format(now);
        _getAddress(_currentPosition!.latitude!, _currentPosition!.longitude!)
            .then((value) {
          setState(() {
            _address = value.first.addressLine;
          });
        });
      });
    });
  }

  Future<List<Address>> _getAddress(double lat, double lang) async {
    final coordinates = Coordinates(lat, lang);
    List<Address> add = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return add;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(paddingDefault),
        child: SingleChildScrollView(
          child: Column(
            children: [
              header(),
              const SizedBox(height: 16),
              formKunjungan(),
              const SizedBox(
                height: 32,
              ),
              buttonSubmit(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      )),
    );
  }

  Widget header() {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () => Navigator.pushNamed(context, '/initialPage'),
                icon: const Icon(Icons.arrow_back, color: kGrey)),
          ],
        ),
        const Text('Kunjungan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(
          height: 32,
        ),
        Row(
          children: const [
            Text(
              'Informasi Kunjungan Mitra Binaan',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ],
        )
      ],
    );
  }

  Widget formKunjungan() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          /*GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LokasiPage())),
            child: Row(
              children: [
                Image.asset('assets/google-maps.png'),
                const SizedBox(
                  width: 8,
                ),
                widget.location == ""
                    ? const Text('Lokasi Anda')
                    : Flexible(child: Text(widget.location))
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          widget.coordinate.latitude == 0.0 &&
                  widget.coordinate.longitude == 0.0
              ? SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                  child: GoogleMap(
                      onMapCreated: onMapCreated,
                      initialCameraPosition: const CameraPosition(
                          zoom: 16.0, target: LatLng(0.0, 0.0))),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                  child: GoogleMap(
                      onMapCreated: onMapCreated,
                      markers: createMarker(),
                      initialCameraPosition: CameraPosition(
                          zoom: 16.0,
                          target: LatLng(widget.coordinate.latitude,
                              widget.coordinate.longitude)))),
          const SizedBox(
            height: 16,
          ),*/
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200]),
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 4),
            child: TextFormField(
              controller: _controllerNamaMB,
              cursorColor: kRed,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration.collapsed(
                  hintText: 'Nama Mitra Binaan'),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Masukkan Nama Mitra Binaan";
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200]),
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 4),
            child: TextFormField(
              controller: _controllerKodeMB,
              cursorColor: kRed,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration.collapsed(
                  hintText: 'Kode Mitra Binaan'),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Masukkan Kode Mitra Binaan";
                } else if (value.length < 6) {
                  return "Kode Mitra Binaan Salah";
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200]),
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 4),
            child: TextFormField(
              controller: _controllerNomorHp,
              cursorColor: kRed,
              keyboardType: TextInputType.phone,
              maxLength: 13,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration.collapsed(hintText: 'Nomor HP'),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Masukkan Nomor HP";
                } else if (value.length < 12) {
                  return "Nomor HP Salah";
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            width: double.infinity,
            height: 90,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200]),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: TextFormField(
              controller: _controllerAlamat,
              cursorColor: kRed,
              maxLines: 3,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration.collapsed(hintText: 'Alamat'),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Masukkan Alamat";
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200]),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: TextFormField(
              controller: _controllerKeterangan,
              cursorColor: kRed,
              maxLines: 5,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration.collapsed(
                  hintText: 'Keterangan Kunjungan'),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Masukkan Keterangan Kunjungan";
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            children: const [
              Text(
                'Upload Foto',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: selectImage,
            child: DottedBorder(
              borderType: BorderType.RRect,
              dashPattern: const [10, 4],
              radius: const Radius.circular(8),
              strokeCap: StrokeCap.round,
              color: Colors.grey.shade300,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blue.shade50.withOpacity(.3),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.photo_camera,
                      color: kRed,
                      size: 40,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Ambil Gambar',
                      style:
                          TextStyle(fontSize: 15, color: Colors.grey.shade400),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          _imageFile != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _imageFile,
                          fit: BoxFit.cover,
                        )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                      child: Text(
                        "Date/Time: $_dateTime",
                        style: const TextStyle(fontSize: 12, color: kBlack54),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 8),
                      child: Text(
                        "Latitude: ${_currentPosition?.latitude}, Longitude: ${_currentPosition?.longitude}",
                        style: const TextStyle(color: kBlack54),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                      child: Text(
                        "$_address",
                        style: const TextStyle(),
                      ),
                    ),
                  ],
                )
              : Container()
        ],
      ),
    );
  }

  Widget buttonSubmit() {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(kRed),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
      onPressed: kunjungan,
      child: Container(
        margin: const EdgeInsets.only(left: 24, right: 24),
        width: double.infinity,
        height: 48,
        child: const Center(
          child: Text(
            'Submit',
            style: TextStyle(color: kWhite, fontSize: 16.0),
          ),
        ),
      ),
    );
  }

  Future getUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((result) {
      if (result.docs.isNotEmpty) {
        setState(() {
          uid = result.docs[0].data()['uid'];
          namaPetugas = result.docs[0].data()['nama lengkap'];
        });
      }
    });
  }

  Future selectImage() async {
    final ImagePicker imagePicker = ImagePicker();
    PickedFile image;

    // ignore: deprecated_member_use
    image = (await imagePicker.getImage(source: ImageSource.camera))!;

    //final imagePlatform = await FilePicker.platform.pickFiles(
    //    type: FileType.custom, allowedExtensions: ['png', 'jpg', 'jpeg']);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        //_platformFile = imagePlatform!.files.first;
        uploadImageToFirebase();
      });
    }

    //loadingController.forward();
  }

  Future uploadImageToFirebase() async {
    File file = File(_imageFile.path);

    if (_imageFile != null) {
      firebase_storage.TaskSnapshot snapshot = await firebase_storage
          .FirebaseStorage.instance
          .ref('$_imageFile')
          .putFile(file);

      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        _imageURL = downloadUrl;
      });
    }
  }

  Set<Marker> createMarker() {
    return <Marker>{
      Marker(
        markerId: MarkerId(_currentPosition.toString()),
        position: LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!),
        icon: BitmapDescriptor.defaultMarker,
      )
    };
  }

  Future<dynamic> kunjungan() async {
    if (_formKey.currentState!.validate()) {
      if ((_imageURL == null) || (_address.toString() == "")) {
        alertDialogForm();
      } else {
        showAlertDialogLoading(context);
        final docId = await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("kunjungan")
            .add({
          'nama lokasi': _address.toString(),
          'koordinat lokasi': GeoPoint(_currentPosition!.latitude!, _currentPosition!.longitude!),
          'nama mitra binaan': _controllerNamaMB.text,
          'kode mitra binaan': _controllerKodeMB.text,
          'nomor HP': _controllerNomorHp.text,
          'alamat': _controllerAlamat.text,
          'keterangan': _controllerKeterangan.text,
          'file foto': _imageURL,
          'tanggal kunjungan': dateNow,
          'status verifikasi': statusVerifikasi,
          'tanggal verifikasi': tanggalVerifikasi,
          'nama petugas': namaPetugas.toString()
        });

        await FirebaseFirestore.instance
            .collection("kunjungan")
            .doc(docId.id)
            .set({
          'docId': docId.id,
          'uid': uid,
          'nama lokasi': _address.toString(),
          'koordinat lokasi': GeoPoint(_currentPosition!.latitude!, _currentPosition!.longitude!),
          'nama mitra binaan': _controllerNamaMB.text,
          'kode mitra binaan': _controllerKodeMB.text,
          'nomor HP': _controllerNomorHp.text,
          'alamat': _controllerAlamat.text,
          'keterangan': _controllerKeterangan.text,
          'file foto': _imageURL,
          'tanggal kunjungan': dateNow,
          'status verifikasi': statusVerifikasi,
          'tanggal verifikasi': tanggalVerifikasi,
          'nama petugas': namaPetugas.toString()
        });

        showAlertDialogSubmit();
      }
    }
  }

  showAlertDialogLoading(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 15),
              child: const Text(
                "Mengirim data..",
                style: TextStyle(fontSize: 12),
              )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogSubmit() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AlertDialog(
                content: Column(
                  children: [
                    Image.asset(
                      "assets/gif/success.gif",
                      width: 60,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        "Data berhasil disimpan",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/initialPage');
                      },
                      child: Text("Selesai"))
                ],
              ),
            ],
          );
        });
  }

  alertDialogForm() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.warning,
                  color: kRed,
                  size: 90,
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "Lokasi atau File Foto Tidak Boleh Kosong!",
                  style: TextStyle(color: kBlack54),
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "OK",
                    style: TextStyle(color: kBlack54),
                  ))
            ],
          );
        });
  }
}
