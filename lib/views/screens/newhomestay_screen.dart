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
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

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
  List<File> imageList = [];
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
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Homestay")),
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

  void _newHomestayDialog() {
    if (imageList.length < 2) {
      Fluttertoast.showToast(
          msg: "Please insert at least 3 pictures",
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
                  onPressed: () async {
                    Navigator.of(context).pop();
                    _addHomestay();
                  },
                  child: const Text("Add")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
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
            toolbarColor: Colors.brown,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      imageList.add(_image!);
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
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(msg: 'Uploading..', max: 100);

    String hsname = _hsnameEditingController.text.toString();
    String hsdesc = _hsdescEditingController.text.toString();
    String hsprice = _hspriceEditingController.text.toString();
    String hsaddress = _hsaddressEditingController.text.toString();
    String hsstate = _hsstateEditingController.text.toString();
    String hslocal = _hslocalEditingController.text.toString();
    String base64Image1 = base64Encode(imageList[0].readAsBytesSync());
    String base64Image2 = base64Encode(imageList[1].readAsBytesSync());
    String base64Image3 = base64Encode(imageList[2].readAsBytesSync());

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
      "image1": base64Image1,
      "image2": base64Image2,
      "image3": base64Image3,
    }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        pd.update(value: 100, msg: "Completed");
        pd.close();
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        pd.update(value: 0, msg: "Failed");
        pd.close();
      }
    });
  }

  Widget Image1() {
    return Transform.scale(
      scale: 1,
      child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: GestureDetector(
            onTap: _selectImageDialog,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: imageList.length > 0
                    ? FileImage(imageList[0]) as ImageProvider
                    : AssetImage(pathAsset),
                fit: BoxFit.cover,
              )),
            ),
          )),
    );
  }

  Widget Image2() {
    return Transform.scale(
      scale: 1,
      child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: GestureDetector(
            onTap: _selectImageDialog,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: imageList.length > 1
                    ? FileImage(imageList[1]) as ImageProvider
                    : AssetImage(pathAsset),
                fit: BoxFit.cover,
              )),
            ),
          )),
    );
  }

  Widget Image3() {
    return Transform.scale(
      scale: 1,
      child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: GestureDetector(
            onTap: _selectImageDialog,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: imageList.length > 2
                    ? FileImage(imageList[2]) as ImageProvider
                    : AssetImage(pathAsset),
                fit: BoxFit.cover,
              )),
            ),
          )),
    );
  }
}
