import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../config.dart';
import '../../models/user.dart';
import 'package:http/http.dart' as http;

class NewHomestayScreen extends StatefulWidget {
  final User user;
  final Position position;
  const NewHomestayScreen(
      {super.key, required this.user, required this.position});

  @override
  State<NewHomestayScreen> createState() => _NewHomestayScreenState();
}

class _NewHomestayScreenState extends State<NewHomestayScreen> {
  @override
  void initState() {
    super.initState();
    _getAddress();
    _lat = widget.position.latitude.toString();
    _lng = widget.position.longitude.toString();
  }

  File? _image;
  var pathAsset = "assets/images/camera.png";
  final TextEditingController _hsnameEditingController =
          TextEditingController(),
      _hsdescEditingController = TextEditingController(),
      _hspriceEditingController = TextEditingController(),
      _hsstateEditingController = TextEditingController(),
      _hslocalEditingController = TextEditingController(),
      _hsaddressEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _lat, _lng;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Homestay")),
      body: SingleChildScrollView(
          child: Column(children: [
        GestureDetector(
          onTap: _selectImageDialog,
          child: Card(
            elevation: 8,
            child: Container(
                height: 150,
                width: 300,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: _image == null
                      ? AssetImage(pathAsset)
                      : FileImage(_image!) as ImageProvider,
                  fit: BoxFit.scaleDown,
                ))),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Add New Homestay",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) => val!.isEmpty || (val.length < 3)
                          ? "Homestay name must be longer than 3"
                          : null,
                      controller: _hsnameEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: 'Homestay Name',
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.person),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ))),
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) => val!.isEmpty || (val.length < 10)
                          ? "Homestay description must be longer than 10"
                          : null,
                      maxLines: 4,
                      controller: _hsdescEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: 'Description',
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(),
                          icon: Icon(
                            Icons.person,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ))),
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) => val!.isEmpty
                          ? "Homestay price must contain values"
                          : null,
                      controller: _hspriceEditingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Homestay Price',
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.money),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ))),
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) => val!.isEmpty || (val.length < 10)
                          ? "Homestay name must be longer than 10"
                          : null,
                      controller: _hsaddressEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: 'Homestay Address',
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.location_on),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ))),
                  Row(
                    children: [
                      Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Current States"
                                      : null,
                              controller: _hsstateEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Current States',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.flag),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  )))),
                      Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Current Locality"
                                      : null,
                              controller: _hslocalEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Current Locality',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.map),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  )))),
                    ],
                  ),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      child: const Text('Add Homestay'),
                      onPressed: () => {
                        _newHomestayDialog(),
                      },
                    ),
                  ),
                ],
              )),
        )
      ])),
    );
  }

  _newHomestayDialog() {
    if (_image == null) {
      Fluttertoast.showToast(
          msg: "Please insert a picture of your homestay",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the form",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text("Add Homestay"),
            content: const Text("Are you sure you want to add this homestay?"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _addHomestay();
                  },
                  child: const Text("Add")),
            ],
          );
        });
  }

  void _selectImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select from",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 100,
                  child: Column(
                    children: [
                      IconButton(
                          iconSize: 32,
                          onPressed: _onCamera,
                          icon: const Icon(Icons.camera_alt)),
                      const Text("Camera"),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: Column(
                    children: [
                      IconButton(
                          iconSize: 32,
                          onPressed: _onGallery,
                          icon: const Icon(Icons.camera)),
                      const Text("Gallery"),
                    ],
                  ),
                ),
              ],
            ));
      },
    );
  }

  Future<void> _onCamera() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
      setState(() {});
    } else {
      print('No image selected.');
    }
  }

  Future<void> _onGallery() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
      setState(() {});
    } else {
      print('No image selected.');
    }
  }

  Future<void> _cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      setState(() {});
    }
  }

  _getAddress() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.position.latitude, widget.position.longitude);
    setState(() {
      _hsstateEditingController.text =
          placemarks[0].administrativeArea.toString();
      _hslocalEditingController.text = placemarks[0].locality.toString();
    });
  }

  void _addHomestay() {
    String hsname = _hsnameEditingController.text.toString();
    String hsdesc = _hsdescEditingController.text.toString();
    String hsprice = _hspriceEditingController.text.toString();
    String hsaddress = _hsaddressEditingController.text.toString();
    String hsstate = _hsstateEditingController.text.toString();
    String hslocal = _hslocalEditingController.text.toString();
    String base64Image = base64Encode(_image!.readAsBytesSync());

    http.post(Uri.parse("${Config.server}/php/insert_homestay.php"), body: {
      "userid": widget.user.id,
      "hsname": hsname,
      "hsdesc": hsdesc,
      "hsprice": hsprice,
      "hsaddress": hsaddress,
      "state": hsstate,
      "loc": hslocal,
      "lat": _lat,
      "lng": _lng,
      "image": base64Image,
    }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Navigator.of(context).pop();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        return;
      }
    });
  }

  /*void _checkPermissionGetLoc() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(_position.latitude);
    print(_position.longitude);
    _getAddress(_position);
  }

  _getAddress(Position pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    setState(() {
      _prstateEditingController.text =
          placemarks[0].administrativeArea.toString();
      _prlocalEditingController.text = placemarks[0].locality.toString();
      //prlat = _position.latitude.toString();
      //prlong = _position.longitude.toString();
    });
  }*/
}
