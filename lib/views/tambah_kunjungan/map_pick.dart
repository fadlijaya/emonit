import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonit/theme/colors.dart';
import 'package:emonit/utils/constant.dart';
import 'package:emonit/views/tambah_kunjungan/tambah_kunjungan_page.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_picker/map_picker.dart';

class MapPick extends StatefulWidget {
  const MapPick({
    Key? key,
  }) : super(key: key);

  @override
  _MapPickState createState() => _MapPickState();
}

class _MapPickState extends State<MapPick> {
  late GoogleMapController _googleMapController;
  MapPickerController mapPickerController = MapPickerController();

  late Position _currentPosition;

  final TextEditingController _controllerLocation = TextEditingController();

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(-5.1475787, 119.3977117),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;

        _googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      await getAddress();
    }).catchError((e) {
      e.toString();
    });
  }

  // Method for retrieving the address
  getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      // ignore: unused_local_variable
      Placemark place = p[0];

      setState(() {
      });
    } catch (e) {
      e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          MapPicker(
            iconWidget: Image.asset("assets/pin.png"),
            mapPickerController: mapPickerController,
            child: GoogleMap(
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: cameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _googleMapController = controller;
              },
              onCameraMoveStarted: () {
                mapPickerController.mapMoving!();
                _controllerLocation.text = "Checking ...";
              },
              onCameraMove: (cameraPosition) {
                this.cameraPosition = cameraPosition;
              },
              onCameraIdle: () async {
                mapPickerController.mapFinishedMoving!();
                List<Placemark> placemarks = await placemarkFromCoordinates(
                  cameraPosition.target.latitude,
                  cameraPosition.target.longitude,
                );

                _controllerLocation.text =
                    '${placemarks.first.street}, ${placemarks.first.subLocality}, ${placemarks.first.locality}, ${placemarks.first.subAdministrativeArea}';
              },
            ),
          ),
          Positioned(
            bottom: 180,
            right: 24,
            left: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipOval(
                  child: Material(
                    color: Colors.white, // button color
                    child: InkWell(
                      // inkwell color
                      child: const SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(
                          Icons.arrow_back,
                          color: kRed,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                ClipOval(
                  child: Material(
                    color: Colors.white, // button color
                    child: InkWell(
                      // inkwell color
                      child: const SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(
                          Icons.my_location,
                          color: kRed,
                        ),
                      ),
                      onTap: () {
                        _googleMapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(
                                _currentPosition.latitude,
                                _currentPosition.longitude,
                              ),
                              zoom: 18.0,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 160,
              padding: const EdgeInsets.all(paddingDefault),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24),
                      topLeft: Radius.circular(24)),
                  color: kWhite),
              child: Column(
                children: [
                  TextFormField(
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    readOnly: true,
                    style: const TextStyle(color: kBlack54),
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none),
                    controller: _controllerLocation,
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TambahKunjunganPage(
                                    coordinate: GeoPoint(
                                        cameraPosition.target.latitude,
                                        cameraPosition.target.longitude),
                                    location: _controllerLocation.text,
                                  )),
                          (route) => false);
                    },
                    child: Container(
                      width: 300,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: kRed,
                      ),
                      child: const Center(
                        child: Text(
                          "Pilih Lokasi",
                          style: TextStyle(
                            color: kWhite,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                            // height: 19/19,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
