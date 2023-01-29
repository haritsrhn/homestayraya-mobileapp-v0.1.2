// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestayraya/serverConfig.dart';
import 'package:http/http.dart' as http;
import 'package:homestayraya/models/homestay.dart';
import 'package:homestayraya/models/user.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class DetailsScreen extends StatefulWidget {
  final Homestays homestays;
  final User user;
  const DetailsScreen({
    Key? key,
    required this.homestays,
    required this.user,
  }) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  List<Homestays> homestayList = <Homestays>[];
  var pathAsset = "assets/images/camera.png";
  final TextEditingController _hsnameEditingController =
          TextEditingController(),
      _hsdescEditingController = TextEditingController(),
      _hspriceEditingController = TextEditingController(),
      _hsstateEditingController = TextEditingController(),
      _hslocalEditingController = TextEditingController(),
      _hsaddressEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  int _index = 0;
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;

  @override
  void initState() {
    super.initState();
    _hsnameEditingController.text = widget.homestays.hsName.toString();
    _hsdescEditingController.text = widget.homestays.hsDesc.toString();
    _hspriceEditingController.text = widget.homestays.hsPrice.toString();
    _hsstateEditingController.text = widget.homestays.hsState.toString();
    _hslocalEditingController.text = widget.homestays.hsLocal.toString();
    _hsaddressEditingController.text = widget.homestays.hsAddress.toString();
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
      appBar: AppBar(title: const Text("Details/Edit")),
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
          "Update Homestay",
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
                          ? "Homestay address must be longer than 10"
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
                              enabled: false,
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
                              enabled: false,
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
                      child: const Text('Update Homestay'),
                      onPressed: () => {
                        _updateHomestayDialog(),
                      },
                    ),
                  ),
                ],
              )),
        )
      ])),
    );
  }

  _updateHomestayDialog() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the form first",
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
          title: const Text(
            "Update this Homestay?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _updateHomestay();
              },
            ),
            TextButton(
              child: const Text(
                "No",
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

  void _updateHomestay() {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(msg: 'Uploading..', max: 100);

    String hsname = _hsnameEditingController.text.toString();
    String hsdesc = _hsdescEditingController.text.toString();
    String hsprice = _hspriceEditingController.text.toString();
    String hsaddress = _hsaddressEditingController.text.toString();

    http.post(Uri.parse("${ServerConfig.server}/php/update_homestay.php"),
        body: {
          "hsid": widget.homestays.hsId,
          "userid": widget.user.id,
          "hsname": hsname,
          "hsdesc": hsdesc,
          "hsprice": hsprice,
          "hsaddress": hsaddress,
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
        return;
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
