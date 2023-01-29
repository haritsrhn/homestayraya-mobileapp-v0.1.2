import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import '../../serverConfig.dart';
import '../../models/homestay.dart';
import '../../models/user.dart';
import '/views/shared/main_menu_widget.dart';
import 'package:http/http.dart' as http;

import 'home_homestay_details_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Homestays> homestayList = <Homestays>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  int rowCount = 2;
  TextEditingController searchController = TextEditingController();
  String search = "all";
  // ignore: prefer_typing_uninitialized_variables
  var seller;
  //for pagination
  // ignore: prefer_typing_uninitialized_variables
  var color;
  // ignore: prefer_typing_uninitialized_variables
  var numofpage, curpage = 1;
  int numberofresult = 0;
//for pagination
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadHomestays("all", 1);
    });
  }

  @override
  void dispose() {
    super.dispose();
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
          title: const Text('Home'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _loadSearchDialog();
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
                      "Current Homestay ($numberofresult found)",
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
                              _showDetails(index);
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
                                      "${ServerConfig.server}/assets/homestay_image/${homestayList[index].hsId}-1.png",
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
                  //Pagination Widget
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: numofpage,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        //build the list for text button with scroll
                        if ((curpage - 1) == index) {
                          //set current page number active
                          color = Colors.red;
                        } else {
                          color = Colors.black;
                        }
                        return TextButton(
                            onPressed: () =>
                                {_loadHomestays(search, index + 1)},
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(color: color, fontSize: 18),
                            ));
                      },
                    ),
                  ),
                ],
              ),
        drawer: MainMenuWidget(user: widget.user),
      ),
    );
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }

  void _loadHomestays(String search, int pageno) {
    curpage = pageno; //init current page
    numofpage ?? 1; //get total num of pages if not by default set to only 1

    http
        .get(
      Uri.parse(
          "${ServerConfig.server}/php/load_all_homestays.php?search=$search&pageno=$pageno"),
    )
        .then((response) {
      ProgressDialog progressDialog = ProgressDialog(
        context,
        blur: 5,
        message: const Text("Loading..."),
        title: null,
      );
      progressDialog.show();
      // wait for response from the request
      if (response.statusCode == 200) {
        //if statuscode OK
        var jsondata =
            jsonDecode(response.body); //decode response body to jsondata array
        if (jsondata['status'] == 'success') {
          //check if status data array is success
          var extractdata = jsondata['data']; //extract data from jsondata array

          if (extractdata['homestays'] != null) {
            numofpage = int.parse(jsondata['numofpage']); //get number of pages
            numberofresult = int.parse(jsondata[
                'numberofresult']); //get total number of result returned
            //check if  array object is not null
            homestayList = <Homestays>[]; //complete the array object definition
            extractdata['homestays'].forEach((v) {
              //traverse homestays array list and add to the list object array homestayList
              homestayList.add(Homestays.fromJson(
                  v)); //add each homestay array to the list object array homestayList
            });
            titlecenter = "Found";
          } else {
            titlecenter =
                "No Homestay Available"; //if no data returned show title center
            homestayList.clear();
          }
        }
      } else {
        titlecenter = "No Homestay Available"; //status code other than 200
        homestayList.clear(); //clear homestayList array
      }

      setState(() {}); //refresh UI
      progressDialog.dismiss();
    });
  }

  void _loadSearchDialog() {
    searchController.text = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Search",
                ),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: 'Search',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.0))),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      Navigator.of(context).pop();
                      _loadHomestays(search, 1);
                    },
                    child: const Text("Search"),
                  )
                ],
              );
            },
          );
        });
  }

  _showDetails(int index) async {
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please register an account",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    Homestays homestays = Homestays.fromJson(homestayList[index].toJson());
    loadSingleSeller(index);
    //todo update seller object with empty object.
    ProgressDialog progressDialog = ProgressDialog(
      context,
      blur: 5,
      message: const Text("Loading..."),
      title: null,
    );
    progressDialog.show();
    Timer(const Duration(seconds: 1), () {
      if (seller != null) {
        progressDialog.dismiss();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) => HomeHomestayDetails(
                      user: widget.user,
                      homestays: homestays,
                      seller: seller,
                    )));
      }
      progressDialog.dismiss();
    });
  }

  loadSingleSeller(int index) {
    http.post(Uri.parse("${ServerConfig.server}/php/load_user_seller.php"),
        body: {"sellerid": homestayList[index].userId}).then((response) {
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse['status'] == "success") {
        seller = User.fromJson(jsonResponse['data']);
      }
    });
  }
}
