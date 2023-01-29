import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../serverConfig.dart';
import '../../models/homestay.dart';
import '../../models/user.dart';

class HomeHomestayDetails extends StatefulWidget {
  final Homestays homestays;
  final User user;
  final User seller;
  const HomeHomestayDetails(
      {super.key,
      required this.homestays,
      required this.user,
      required this.seller});

  @override
  State<HomeHomestayDetails> createState() => _HomeHomestayDetailsState();
}

class _HomeHomestayDetailsState extends State<HomeHomestayDetails> {
  late double screenHeight, screenWidth, resWidth;
  // ignore: unused_field
  int _index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Details")),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 16,
          ),
          Center(
            child: SizedBox(
              height: 200,
              child: PageView.builder(
                  itemCount: 3,
                  controller: PageController(viewportFraction: 0.7),
                  onPageChanged: (int index) => setState(() => _index = index),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Image1();
                    } else if (index == 1) {
                      return Image2();
                    } else {
                      return Image3();
                    }
                  }),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.homestays.hsName.toString(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                border: TableBorder.all(
                    color: Colors.black, style: BorderStyle.none, width: 1),
                columnWidths: const {
                  0: FixedColumnWidth(110),
                  1: FixedColumnWidth(200),
                },
                children: [
                  TableRow(children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Description:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.homestays.hsDesc.toString(),
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ]),
                  TableRow(children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Price:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("RM${widget.homestays.hsPrice}",
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ]),
                  TableRow(children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Address:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.homestays.hsAddress.toString(),
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ]),
                  TableRow(children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Locality:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.homestays.hsLocal.toString(),
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ]),
                  TableRow(children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("State:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.homestays.hsState.toString(),
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ]),
                  TableRow(children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Seller Name:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.seller.name.toString(),
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ]),
                ],
              )),
        ]),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.call),
              onPressed: () => _makePhoneCall(),
            ),
            IconButton(
              icon: const Icon(Icons.message),
              onPressed: () => _makeSmS(),
            ),
            IconButton(
              icon: const Icon(Icons.whatsapp),
              onPressed: () => openwhatsapp(),
            ),
            IconButton(
              icon: const Icon(Icons.map),
              onPressed: () => _onRoute(),
            ),
            IconButton(
              icon: const Icon(Icons.maps_home_work),
              onPressed: () => _onShowMap(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: widget.seller.phone,
    );
    await launchUrl(launchUri);
  }

  Future<void> _makeSmS() async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: widget.seller.phone,
    );
    await launchUrl(launchUri);
  }

  Future<void> _onRoute() async {
    final Uri launchUri = Uri(
        scheme: 'https',
        // ignore: prefer_interpolation_to_compose_strings
        path: "www.google.com/maps/@" +
            widget.homestays.hsLat.toString() +
            "," +
            widget.homestays.hsLng.toString() +
            "20z");
    await launchUrl(launchUri);
  }

  openwhatsapp() async {
    var whatsapp = widget.seller.phone;
    var whatsappURlAndroid = "whatsapp://send?phone=$whatsapp&text=hello";
    var whatappURLIos = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      // ignore: deprecated_member_use
      if (await canLaunch(whatappURLIos)) {
        // ignore: deprecated_member_use
        await launch(whatappURLIos, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Whatsapp not installed")));
      }
    } else {
      // android , web
      // ignore: deprecated_member_use
      if (await canLaunch(whatsappURlAndroid)) {
        // ignore: deprecated_member_use
        await launch(whatsappURlAndroid);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Whatsapp not installed")));
      }
    }
  }

  int generateIds() {
    var rng = Random();
    int randomInt;
    randomInt = rng.nextInt(100);
    return randomInt;
  }

  void _onShowMap() {
    double lat = double.parse(widget.homestays.hsLat.toString());
    double lng = double.parse(widget.homestays.hsLng.toString());
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    int markerIdVal = generateIds();
    MarkerId markerId = MarkerId(markerIdVal.toString());
    final Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: LatLng(
        lat,
        lng,
      ),
    );
    markers[markerId] = marker;

    CameraPosition campos = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 16.4746,
    );
    Completer<GoogleMapController> ncontroller =
        Completer<GoogleMapController>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Location",
            style: TextStyle(),
          ),
          content: SizedBox(
            //color: Colors.red,
            height: screenHeight,
            width: screenWidth,
            child: GoogleMap(
              mapType: MapType.satellite,
              initialCameraPosition: campos,
              markers: Set<Marker>.of(markers.values),
              onMapCreated: (GoogleMapController controller) {
                ncontroller.complete(controller);
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  Widget Image1() {
    return Transform.scale(
      scale: 1,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          height: 200,
          width: 200,
          child: CachedNetworkImage(
            width: resWidth / 2,
            fit: BoxFit.cover,
            imageUrl:
                "${ServerConfig.server}/assets/homestay_image/${widget.homestays.hsId}-1.png",
            placeholder: (context, url) => const LinearProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Image2() {
    return Transform.scale(
      scale: 1,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          height: 200,
          width: 200,
          child: CachedNetworkImage(
            width: resWidth / 2,
            fit: BoxFit.cover,
            imageUrl:
                "${ServerConfig.server}/assets/homestay_image/${widget.homestays.hsId}-2.png",
            placeholder: (context, url) => const LinearProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Image3() {
    return Transform.scale(
      scale: 1,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          height: 200,
          width: 200,
          child: CachedNetworkImage(
            width: resWidth / 2,
            fit: BoxFit.cover,
            imageUrl:
                "${ServerConfig.server}/assets/homestay_image/${widget.homestays.hsId}-3.png",
            placeholder: (context, url) => const LinearProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
