import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ndialog/ndialog.dart';
import '../../config.dart';
import '../../models/user.dart';
import '/views/screens/registration_screen.dart';
import '/views/shared/main_menu_widget.dart';
import 'login_screen.dart';
import 'newhomestay_screen.dart';
import '../../models/homestay.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CatalogueScreen extends StatefulWidget {
  final User user;
  const CatalogueScreen({super.key, required this.user});

  @override
  State<CatalogueScreen> createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends State<CatalogueScreen> {
  late Position _position;
  List<Homestays> homestayList = <Homestays>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  int rowCount = 2;

  @override
  void dispose() {
    homestayList = [];
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadHomestay();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowCount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowCount = 3;
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Catalogue'),
          actions: [
            IconButton(
                onPressed: _registrationForm,
                icon: const Icon(Icons.app_registration)),
            IconButton(
              onPressed: _loginForm,
              icon: const Icon(Icons.login),
            ),
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("Add New Homestay"),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text("My Order"),
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                  _goToNewHomestay();
                } else if (value == 1) {
                  print("My Order is selected");
                }
              },
            ),
          ],
        ),
        body: homestayList.isEmpty
            ? Center(
                child: Text(titlecenter,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)))
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Your current homestay (${homestayList.length} found)",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: rowCount,
                      children: List.generate(homestayList.length, (index) {
                        return Card(
                          elevation: 8,
                          child: InkWell(
                            onTap: () {
                              // show details
                            },
                            onLongPress: () {
                              // delete
                            },
                            child: Column(children: [
                              const SizedBox(
                                height: 8,
                              ),
                              Flexible(
                                flex: 6,
                                child: CachedNetworkImage(
                                  width: resWidth / 2,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "${Config.server}/assets/homestay_image/${homestayList[index].hsId}-1.png",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Flexible(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          truncateString(
                                              homestayList[index]
                                                  .hsName
                                                  .toString(),
                                              15),
                                          style: const TextStyle(
                                              //fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            "RM ${double.parse(homestayList[index].hsPrice.toString()).toStringAsFixed(2)}"),
                                      ],
                                    ),
                                  ))
                            ]),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
        drawer: MainMenuWidget(user: widget.user),
      ),
    );
  }

  void _registrationForm() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const RegistrationScreen()));
  }

  void _loginForm() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  Future<void> _goToNewHomestay() async {
    ProgressDialog progressDialog = ProgressDialog(
      context,
      blur: 10,
      message: const Text("Searching your current location"),
      title: null,
    );
    progressDialog.show();
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please login/register to add new homestay",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      progressDialog.dismiss();
      return;
    }
    if (await _checkPermissionGetLoc()) {
      progressDialog.dismiss();
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) =>
                  NewHomestayScreen(user: widget.user, position: _position)));
      _loadHomestay();
    } else {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      progressDialog.dismiss();
    }
  }

  Future<bool> _checkPermissionGetLoc() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: "Please allow the app to access the location",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Geolocator.openLocationSettings();
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      Geolocator.openLocationSettings();
      return false;
    }
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    return true;
  }

  void _loadHomestay() {
    http
        .get(
      Uri.parse(
          "${Config.server}/php/load_homestay.php?userid=${widget.user.id}"),
    )
        .then((response) {
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          if (extractdata['homestays'] != null) {
            homestayList = <Homestays>[];
            extractdata['homestays'].forEach((v) {
              homestayList.add(Homestays.fromJson(v));
            });
            titlecenter = "Found";
          } else {
            titlecenter = "No Homestay Available";
            homestayList.clear();
          }
        }
      } else {
        titlecenter = "No Homestay Available";
        homestayList.clear();
      }
      setState(() {});
    });
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }
} //end of class
