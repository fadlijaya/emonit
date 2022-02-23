import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonit/users/theme/colors.dart';
import 'package:emonit/users/views/tambah_kunjungan/tambah_kunjungan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class LokasiPage extends StatefulWidget {
  const LokasiPage({Key? key}) : super(key: key);

  @override
  _LokasiPageState createState() => _LokasiPageState();
}

class _LokasiPageState extends State<LokasiPage> {
  LocationData? _currentPosition;
  String? _address, _dateTime;
  late GoogleMapController mapController;
  Marker? marker;
  Location location = Location();

  late GoogleMapController _controller;
  LatLng _initialcameraposition = const LatLng(0.5937, 0.9629);

  @override
  void initState() {
    getLoc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: Stack(
            children: [
              mapLokasi(),
              backPage(),
              ketLokasi(),
            ],
          ),
        ),
      ),
    );
  }

  Widget mapLokasi() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.4,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: _initialcameraposition, zoom: 100),
        mapType: MapType.normal,
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
      ),
    );
  }

  Widget backPage() {
    return Positioned(
      bottom: 220,
      left: 16,
      child: ClipOval(
        child: Material(
          color: kWhite, // button color
          child: InkWell(
            child: const SizedBox(
              width: 56,
              height: 56,
              child: Icon(
                Icons.arrow_back,
                color: kBlack54,
              ),
            ),
            onTap: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }

  Widget ketLokasi() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        width: double.infinity,
        height: 190,
        padding: const EdgeInsets.all(8),
        color: kWhite,
        child: Column(
          children: [
            if (_dateTime != null)
              Text(
                "Date/Time: $_dateTime",
                style: const TextStyle(fontSize: 12, color: kBlack54),
              ),
            const SizedBox(
              height: 8,
            ),
            if (_currentPosition != null)
              Text(
                "Latitude: ${_currentPosition?.latitude}, Longitude: ${_currentPosition?.longitude}",
                style: const TextStyle(color: kBlack54),
              ),
            const SizedBox(
              height: 8,
            ),
            if (_address != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "$_address",
                  style: const TextStyle(),
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            buttonSetLokasi()
          ],
        ),
      ),
    );
  }

  Widget buttonSetLokasi() {
    return ElevatedButton(
        onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => TambahKunjunganPage(
                      coordinate: GeoPoint(_currentPosition!.latitude!,
                          _currentPosition!.longitude!),
                      location: _address.toString(),
                    )),
            (route) => false),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(kRed),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)))),
        child: Container(
          width: 96,
          height: 48,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: const Center(
            child: Text(
              "Get Lokasi",
              style: TextStyle(color: kWhite),
            ),
          ),
        ));
  }

  _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        ),
      );
    });
  }

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
    List<Address> add =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return add;
  }
}
