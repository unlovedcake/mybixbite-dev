import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mybixbite/Routes/routes.dart';
import 'package:mybixbite/Theme/app-theme.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as pl;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mybixbite/widgets/bottom-navigationbar.dart';

import 'add-bixbite.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  User? user = FirebaseAuth.instance.currentUser;

  final TextEditingController _dropDownDate = TextEditingController();
  final TextEditingController _dropDownBixBite = TextEditingController();

  DateTime _now = DateTime.now();

  List loves = [];

  final listOfValueDropdown = [
    DateFormat.yMMMMd().format(DateTime.now()),
    "Last 7 Days",
    "Last 30 Days",
    "Current Month"
  ];

  final listOfValueBixBite = [
    'All',
    'Gratitude',
    'Live',
    'Laugh',
    'Love',
    'Learn',
    'Budget'
  ];

  bool bixBite = false;

  String dropdownValue = DateFormat.yMMMMd().format(DateTime.now());
  String dropdownValueBixBite = "All";

  QuerySnapshot? searchSnapshot;
  TextEditingController inputController = TextEditingController();
  int _numOfPress = 0;
  String lFData = '';
  final List<String> LF = [
    'All',
    'Gratitude',
    'Live',
    'Laugh',
    'Love',
    'Learn',
    'Budget'
  ];
  String sDData = '';
  final List<String> sampleData = [
    'sample1',
    'sample2',
    'sample3',
    'sample4',
    'sample5',
    'sample6',
    'sample7'
  ];

  double gratitude = 0.0;
  double live = 0.0;
  double laugh = 0.0;
  double love = 0.0;
  double learn = 0.0;
  double budget = 0.0;

  int? limit;

  bool sevenDays = false;

  bool dropDown = false;

  List dataAll = [];
  List dataAllSeven = [];

  Future<void> getData() async {
    DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
    double _gratitude = 0.0;
    double _live = 0.0;
    double _laugh = 0.0;
    double _love = 0.0;
    double _learn = 0.0;
    double _budget = 0.0;
    double sumAllData = 0.0;
    final result = await FirebaseFirestore.instance
        .collection("table-bixbite")
        .where("email", isEqualTo: user!.email)
        .where("dateCreated", isEqualTo: _start)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        dataAll.add(result.data());
        _gratitude += result.data()['gratitude'];
        _live += result.data()['live'];
        _love += result.data()['love'];
        _laugh += result.data()['laugh'];
        _learn += result.data()['learn'];
        _budget += result.data()['budget'];
        gratitude = _gratitude;
        live = _live;
        love = _love;
        learn = _learn;
        laugh = _laugh;
        budget = _budget;

        sumAllData = gratitude + live + love + laugh + learn + budget;
        if (!dropDown) {
          gratitude = sumAllData / 6 * 100;
          live = sumAllData / 6 * 100;
          love = sumAllData / 6 * 100;
          laugh = sumAllData / 6 * 100;
          learn = sumAllData / 6 * 100;
          budget = sumAllData / 6 * 100;
        } else {
          gratitude = gratitude / 6 * 100;
          live = live / 6 * 100;
          love = love / 6 * 100;
          laugh = laugh / 6 * 100;
          learn = learn / 6 * 100;
          budget = budget / 6 * 100;
        }
        setState(() {});
        final Timestamp timestamp = result.data()['dateCreated'] as Timestamp;
        final DateTime dateTime = timestamp.toDate();
        final dateString = DateFormat('yyyy-MM-dd').format(dateTime);

        DateTime myDateTime =
            DateTime.parse(result.data()['dateCreated'].toDate().toString());

        print(DateTime.now());

        print("${dateString}" + "OKEY");
        print("${_start}" + "OKEY");
        print("${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}" +
            "OKEY");
      });
    });

    if (dataAll.length == 0) {
      gratitude = 0.0;
      live = 0.0;
      love = 0.0;
      learn = 0.0;
      laugh = 0.0;
      budget = 0.0;
      dataAll.length = 0;
      Fluttertoast.showToast(msg: "You don't have answer today. ");
      setState(() {});
    } else {
      //filterMyBixBite();
      print(dataAll.length);
    }
  }

  Future<void> getLastSevenDays() async {
    DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);

    double _gratitude = 0.0;
    double _live = 0.0;
    double _laugh = 0.0;
    double _love = 0.0;
    double _learn = 0.0;
    double _budget = 0.0;
    double sumAllData = 0.0;

    final result = await FirebaseFirestore.instance
        .collection("table-bixbite")
        .where("email", isEqualTo: user!.email)
        .where("dateCreated", isLessThanOrEqualTo: _start)

        //.orderBy("dateCreated")
        .limit(7)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        dataAll.add(result.data());
        _gratitude += result.data()['gratitude'];
        _live += result.data()['live'];
        _love += result.data()['love'];
        _laugh += result.data()['laugh'];
        _learn += result.data()['learn'];
        _budget += result.data()['budget'];
        gratitude = _gratitude;
        live = _live;
        love = _love;
        learn = _learn;
        laugh = _laugh;
        budget = _budget;

        sumAllData = gratitude + live + love + laugh + learn + budget;

        if (!dropDown) {
          gratitude = sumAllData / 6 * 100;
          live = sumAllData / 6 * 100;
          love = sumAllData / 6 * 100;
          laugh = sumAllData / 6 * 100;
          learn = sumAllData / 6 * 100;
          budget = sumAllData / 6 * 100;
        } else {
          gratitude = gratitude / 6 * 100;
          live = live / 6 * 100;
          love = love / 6 * 100;
          laugh = laugh / 6 * 100;
          learn = learn / 6 * 100;
          budget = budget / 6 * 100;
        }
        setState(() {});
      });
    });
    if (dataAll.length == 0) {
      gratitude = 0.0;
      live = 0.0;
      love = 0.0;
      learn = 0.0;
      laugh = 0.0;
      budget = 0.0;
      dataAll.length = 0;
      Fluttertoast.showToast(msg: "You don't have answer today. ");
      setState(() {});
    } else {
      //filterMyBixBite();
      print(dataAll.length);
    }

    Fluttertoast.showToast(msg: "You answered " + "${dataAll.length}" + " out of 7 days");

    print("Data ALLs");
    print(dataAll.length);
  }

  Future<void> getLastThirtyDays() async {
    DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);

    double _gratitude = 0.0;
    double _live = 0.0;
    double _laugh = 0.0;
    double _love = 0.0;
    double _learn = 0.0;
    double _budget = 0.0;

    final result = await FirebaseFirestore.instance
        .collection("table-bixbite")
        .where("email", isEqualTo: user!.email)
        .where("dateCreated", isLessThanOrEqualTo: _start)

        //.orderBy("dateCreated")
        .limit(30)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        double sumAllData = 0.0;
        dataAll.add(result.data());
        _gratitude += result.data()['gratitude'];
        _live += result.data()['live'];
        _love += result.data()['love'];
        _laugh += result.data()['laugh'];
        _learn += result.data()['learn'];
        _budget += result.data()['budget'];
        gratitude = _gratitude;
        live = _live;
        love = _love;
        learn = _learn;
        laugh = _laugh;
        budget = _budget;

        sumAllData = gratitude + live + love + laugh + learn + budget;
        if (!dropDown) {
          gratitude = sumAllData / 6 * 100;
          live = sumAllData / 6 * 100;
          love = sumAllData / 6 * 100;
          laugh = sumAllData / 6 * 100;
          learn = sumAllData / 6 * 100;
          budget = sumAllData / 6 * 100;
          print("$gratitude asdadsadsa");
        } else {
          gratitude = gratitude / 6 * 100;
          live = live / 6 * 100;
          love = love / 6 * 100;
          laugh = laugh / 6 * 100;
          learn = learn / 6 * 100;
          budget = budget / 6 * 100;
        }
        setState(() {});
      });
    });
    if (dataAll.length == 0) {
      gratitude = 0.0;
      live = 0.0;
      love = 0.0;
      learn = 0.0;
      laugh = 0.0;
      budget = 0.0;
      dataAll.length = 0;
      Fluttertoast.showToast(msg: "You don't have answer today. ");
      setState(() {});
    } else {
      //filterMyBixBite();
      print(dataAll.length);
    }

    Fluttertoast.showToast(
        msg: "You answered " + "${dataAll.length}" + " out of 30 days");

    print("Data ALL");
    print(dataAll.length);
  }

  Future<void> currentMonth() async {
    DateTime _currentDate = DateTime.now();
    String currentMonth = new DateFormat.yMMMM().format(_currentDate);
    double _gratitude = 0.0;
    double _live = 0.0;
    double _laugh = 0.0;
    double _love = 0.0;
    double _learn = 0.0;
    double _budget = 0.0;
    double sumAllData = 0.0;
    final result = await FirebaseFirestore.instance
        .collection("table-bixbite")
        .where("email", isEqualTo: user!.email)
        .where("currentMonth", isEqualTo: currentMonth)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        dataAll.add(result.data());
        _gratitude += result.data()['gratitude'];
        _live += result.data()['live'];
        _love += result.data()['love'];
        _laugh += result.data()['laugh'];
        _learn += result.data()['learn'];
        _budget += result.data()['budget'];
        gratitude = _gratitude;
        live = _live;
        love = _love;
        learn = _learn;
        laugh = _laugh;
        budget = _budget;

        sumAllData = gratitude + live + love + laugh + learn + budget;
        if (!dropDown) {
          gratitude = sumAllData / 6 * 100;
          live = sumAllData / 6 * 100;
          love = sumAllData / 6 * 100;
          laugh = sumAllData / 6 * 100;
          learn = sumAllData / 6 * 100;
          budget = sumAllData / 6 * 100;
        } else {
          gratitude = gratitude / 6 * 100;
          live = live / 6 * 100;
          love = love / 6 * 100;
          laugh = laugh / 6 * 100;
          learn = learn / 6 * 100;
          budget = budget / 6 * 100;
        }
        setState(() {});
      });
    });
  }

  getAllData() {
    for (int i = 0; i < 1; i++) {
      gratitude += dataAll[i]['gratitude'];
      live += dataAll[i]['live'];
      love += dataAll[i]['love'];
      laugh += dataAll[i]['laugh'];
      learn += dataAll[i]['learn'];
      budget += dataAll[i]['budget'];

      // setState(() {
      //   sumAllData = gratitude + live + love + laugh + learn + budget;
      //   gratitude = gratitude / sumAllData * 100;
      //   live = live / sumAllData * 100;
      //   love = love / sumAllData * 100;
      //   laugh = laugh / sumAllData * 100;
      //   learn = learn / sumAllData * 100;
      //   budget = budget / sumAllData * 100;
      // });
    }
    // sumAllData = gratitude + live + love + laugh + learn + budget;
    // gratitude = gratitude / sumAllData * 100;
    // live = live / sumAllData * 100;
    // love = love / sumAllData * 100;
    // laugh = laugh / sumAllData * 100;
    // learn = learn / sumAllData * 100;
    // budget = budget / sumAllData * 100;
    print(gratitude);
  }

  Future getDataSevenDays() async {
    await FirebaseFirestore.instance
        .collection("table-bixbite")
        //.where("userServiceModel.email", isEqualTo: "s@gmail.com")
        //.where("dateCreated", isLessThanOrEqualTo: dropdownValue)
        //.orderBy("dateCreated")
        //.limit(7)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        dataAllSeven.add(result.data());
        print("${result.data()}" + "KKKKK");
        print(result.data());
      });
    });
    // getLastSevenDays();
  }

  @override
  void initState() {
    setState(() {
      _numOfPress = 0;
    });
    super.initState();

    getData();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    //  final email = Provider.of<UserData?>(context);
    return WillPopScope(
      onWillPop: () {
        if (_numOfPress == 0) {
          _numOfPress++;
          displayToastMessage("Press again to exit", context);
        } else if (_numOfPress == 1) {
          Timer(Duration(milliseconds: 500), () {
            SystemNavigator.pop();
          });
        }

        // print(numOfPress);
        //we need to return a future
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          toolbarHeight: 70,
          title: Container(
            height: 70,
            // width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              fit: BoxFit.fill,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'My',
                      style: TextStyle(
                          color: Color(0xffac4966),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      children: const <TextSpan>[
                        TextSpan(
                            text: 'Bixbite',
                            style: TextStyle(
                                color: Color(0xffcd6689), fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Text(
                    'Rebalance You',
                    style: TextStyle(color: Color(0xff78374e), fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),

        bottomNavigationBar: BottomNavBar(index: 0),
//         bottomNavigationBar: Container(
//           child: BottomAppBar(
//               elevation: 1,
//               child: Container(
//                 alignment: Alignment.bottomCenter,
//                 height: 50,
//                 width: MediaQuery.of(context).size.width,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pushReplacement(
//                             context,
//                             PageRouteBuilder(
//                               pageBuilder: (context, animation1, animation2) =>
//                                   FirstMainScreen(),
//                               transitionDuration: Duration.zero,
//                             ),
//                           );
//                         },
//                         child: Icon(
//                           Icons.home_outlined,
//                           size: 40,
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           //   Navigator.pushNamed(context, MainScreen.idScreen);
//                         },
//                         child: Icon(
//                           Icons.account_circle,
//                           //color: Colors.lightBlue,
//                           size: 40,
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {},
//                         child: Icon(
//                           Icons.favorite_outline,
//                           //  color: Colors.red,
//                           size: 40,
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () async {
//                           if (await HelperFunctions.getUserNameSharedPreference() == null ||
//                               await HelperFunctions.getNameSharedPreference() == null ||
//                               await HelperFunctions.getLastNameSharedPreference() ==
//                                   null ||
//                               await HelperFunctions.getUserEmailSharedPreference() ==
//                                   null ||
//                               await HelperFunctions.getUserImageUrlSharedPreference() ==
//                                   null ||
//                               await HelperFunctions
//                                       .getUserContactNumberSharedPreference() ==
//                                   null) {
//                             displayToastMessage(
//                                 "Please Sign Out and Relogin again...", context);
//                           } else {
//                             /*        print(await HelperFunctions
//                                 .getUserNameSharedPreference());
//                             print(
//                                 await HelperFunctions.getNameSharedPreference());
//
//                             print(await HelperFunctions
//                                 .getLastNameSharedPreference());
//
//                             print(await HelperFunctions
//                                 .getUserEmailSharedPreference());
//
//                             print(await HelperFunctions
//                                 .getUserImageUrlSharedPreference());
//
//                             print(await HelperFunctions
//                                 .getUserContactNumberSharedPreference());
// */
//                             Constants.myImageURL = (await HelperFunctions
//                                 .getUserImageUrlSharedPreference())!;
//
//                             Navigator.pushReplacement(
//                               context,
//                               PageRouteBuilder(
//                                 pageBuilder: (context, animation1, animation2) =>
//                                     ChatRoom(),
//                                 transitionDuration: Duration.zero,
//                               ),
//                             );
//                           }
//                         },
//                         child: Icon(
//                           Icons.message_outlined,
//                           //  color: Colors.lightBlue,
//                           size: 40,
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           //   Navigator.pushNamed(context, ResultScreen.idScreen);
//                         },
//                         child: Icon(
//                           Icons.settings_outlined,
//                           // color: Colors.grey,
//                           size: 40,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )),
        //),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),

                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.all(8),
                        width: 180,
                        child: DropdownButtonFormField(
                          value: dropdownValue,
                          icon: Icon(Icons.arrow_drop_down_circle_outlined),
                          decoration: InputDecoration(
                            labelText: "Filter Date",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          items: listOfValueDropdown.map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              dropdownValue = newValue.toString();

                              if (dropdownValue == "Last 7 Days") {
                                // context
                                //     .read<ShowPercent>()
                                //     .setDropDownValue(dropdownValue);
                                setState(() {
                                  sevenDays = true;
                                  dropDown = false;

                                  getLastSevenDays();

                                  dataAll.length = 0;
                                  print("$limit SEVEN DAYS");
                                });
                              } else if (dropdownValue == "Last 30 Days") {
                                setState(() {
                                  dropDown = false;
                                  getLastThirtyDays();
                                  dataAll.length = 0;

                                  print("Thirty DAYS");
                                });
                              } else if (dropdownValue ==
                                  DateFormat.yMMMMd().format(DateTime.now())) {
                                setState(() {});
                                dropDown = false;
                                limit = 1;
                                getData();
                                dataAll.length = 0;
                                print("Current DAYS");
                                print(DateTime.now());
                              } else {
                                setState(() {
                                  dropDown = false;
                                  currentMonth();
                                  dataAll.length = 0;
                                  print("Current Month");
                                });
                              }
                            });
                          },
                          validator: (value) {
                            if (value == "") {
                              return 'Please Select Date';
                            }
                            return null;
                          },
                        ),
                        // child: SelectFormField(
                        //   controller: _dropDownDate,
                        //   validator: (value) {
                        //     if (value!.isEmpty) {
                        //       return ("Choose One");
                        //     }
                        //   },
                        //   decoration: InputDecoration(
                        //     contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        //     hintText: 'Filter Date',
                        //     labelText: 'Filter Date',
                        //     // suffixIcon: IconButton(
                        //     //   icon: Icon(
                        //     //     Icons.ice_skating_rounded
                        //     //   ), onPressed: () {  },
                        //     // ),
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //   ),
                        //   type: SelectFormFieldType.dropdown, // or can be dialog
                        //   //initialValue: "Date",
                        //   // icon: Icon(Icons.format_shapes),
                        //
                        //   items: ServicesTypesOfDoctor.items,
                        //   onSaved: (val) {
                        //     setState(() {
                        //       _dropDownDate.text = val!;
                        //     });
                        //   },
                        //   onChanged: (val) {
                        //     print(val);
                        //     setState(() {
                        //       _dropDownDate.text = val;
                        //       getData();
                        //
                        //       // FirebaseFirestore.instance
                        //       //     .collection("table-bixbite")
                        //       //     //.where("userServiceModel.email", isEqualTo: "s@gmail.com")
                        //       //     .where("dateCreated", isEqualTo: _dropDownDate.text)
                        //       //     .get()
                        //       //     .then((value) {
                        //       //   value.docs.forEach((result) {
                        //       // dataAll.add(result.data());
                        //       // print("${result.data()['dateCreated']}" + "adasdada");
                        //       //
                        //       // dataMap.addAll({
                        //       //   "Gratitude": result.data()['gratitude'],
                        //       //   "Live": result.data()['live'],
                        //       //   "Love": result.data()['love'],
                        //       //   "Laugh": result.data()['laugh'],
                        //       //   "Learn": result.data()['learn'],
                        //       //   "Budget": result.data()['budget'],
                        //       // });
                        //       // });
                        //       //});
                        //     });
                        //   },
                        //   // onSaved: (val) {
                        //   //   print(val);
                        //   // },
                        // ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        width: 160,
                        child: DropdownButtonFormField(
                          value: dropdownValueBixBite,
                          icon: Icon(Icons.arrow_drop_down_circle_outlined),
                          decoration: InputDecoration(
                            labelText: "Filter MyBixBite",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          items: listOfValueBixBite.map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              dropDown = true;

                              print("$dropDown OKES");
                              dropdownValueBixBite = newValue.toString();
                              dataAll.length = 0;
                              if (dropdownValue ==
                                  DateFormat.yMMMMd().format(DateTime.now())) {
                                limit = 1;
                                getData();

                                print("Lovessss");
                              } else if (dropdownValue == "Last 7 Days") {
                                getLastSevenDays();

                                print("Last 7 Days");
                              } else if (dropdownValue == "Last 30 Days") {
                                getLastThirtyDays();
                                print("Last 30 Days");
                              } else if (dropdownValue == "Current Month") {
                                currentMonth();
                                print("Current Month");
                              }

                              print(dropdownValueBixBite);
                            });
                          },
                          validator: (value) {
                            if (value == "") {
                              return 'Please Select BixBite';
                            }
                            return null;
                          },
                        ),
                      ),

                      // Container(
                      //   margin: EdgeInsets.all(8),
                      //   width: 160,
                      //   child: SelectFormField(
                      //     controller: _dropDownBixBite,
                      //     validator: (value) {
                      //       if (value!.isEmpty) {
                      //         return ("Choose Type");
                      //       }
                      //     },
                      //     decoration: InputDecoration(
                      //       contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      //       hintText: 'Select BixBite',
                      //       labelText: 'Select BixBite',
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //     ),
                      //     type: SelectFormFieldType.dropdown, // or can be dialog
                      //     //initialValue: "One",
                      //     // icon: Icon(Icons.format_shapes),
                      //
                      //     items: ServicesTypesOfDoctor.bixbite,
                      //     onChanged: (val) {
                      //       print(val);
                      //     },
                      //     // onSaved: (val) {
                      //     //   print(val);
                      //     // },
                      //   ),
                      // ),

                      // Container(
                      //   color: Colors.blue,
                      //   height: 40,
                      //   width: MediaQuery.of(context).size.width / 2.2,
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //   ),
                      // ),
                      // Container(
                      //   color: Colors.blue,
                      //   height: 40,
                      //   width: MediaQuery.of(context).size.width / 2.2,
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //   ),
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // RaisedButton(
                //     color: Colors.white,
                //     child: Container(
                //       height: 25,
                //       width: MediaQuery.of(context).size.width / 2.6,
                //       child: FittedBox(
                //         fit: BoxFit.fill,
                //         child: Text(
                //           'Show MyBixbite',
                //           style: TextStyle(color: Colors.red[200]),
                //         ),
                //       ),
                //     ),
                //     onPressed: () {
                //       setState(() {
                //         if (!sevenDays) {
                //           sevenDays = true;
                //           getData();
                //           print("C");
                //         } else {
                //           sevenDays = false;
                //           getDataSevenDays();
                //           print("S");
                //         }
                //       });
                //     }),
                SizedBox(
                  height: 20,
                ),
                Image(
                  image: AssetImage("assets/images/bixbite_logo.png"),
                  width: 390.0,
                  height: 200.0,
                  alignment: Alignment.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 50,
                              width: 20,
                              color: Color(0xfff9a56d),
                            ),
                            Container(
                              height: 50,
                              width: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                  //shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Color(0xfff9a56d),
                                    width: 1,
                                  )),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "${gratitude.toStringAsFixed(1)}" "%",
                                    textAlign: TextAlign.right,
                                  ),
                                  Text(
                                    "Gratitude",
                                    textAlign: TextAlign.right,
                                    style:
                                        TextStyle(color: Color(0xfff9a56d), fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 50,
                              width: 20,
                              color: Color(0xffd16baa),
                            ),
                            Container(
                              height: 50,
                              width: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                  //shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Color(0xffd16baa),
                                    width: 1,
                                  )),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${live.toStringAsFixed(1)}" "%",
                                    textAlign: TextAlign.right,
                                  ),
                                  Text(
                                    "Live",
                                    textAlign: TextAlign.right,
                                    style:
                                        TextStyle(color: Color(0xffd16baa), fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 50,
                              width: 20,
                              color: Color(0xff59b4e5),
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                  //shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Color(0xff59b4e5),
                                    width: 1,
                                  )),
                              alignment: Alignment.center,
                              width: 80,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${love.toStringAsFixed(1)}" "%",
                                    textAlign: TextAlign.right,
                                  ),
                                  Text(
                                    "Love",
                                    textAlign: TextAlign.right,
                                    style:
                                        TextStyle(color: Color(0xff59b4e5), fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 50,
                              width: 20,
                              color: Color(0xff6dccd9),
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                  //shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Color(0xff6dccd9),
                                    width: 1,
                                  )),
                              alignment: Alignment.center,
                              width: 80,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${laugh.toStringAsFixed(1)}" "%",
                                    textAlign: TextAlign.right,
                                  ),
                                  Text(
                                    "Laugh",
                                    textAlign: TextAlign.right,
                                    style:
                                        TextStyle(color: Color(0xff6dccd9), fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 50,
                              width: 20,
                              color: Color(0xff74c36c),
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                  //shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Color(0xff74c36c),
                                    width: 1,
                                  )),
                              alignment: Alignment.center,
                              width: 80,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${learn.toStringAsFixed(1)}" "%",
                                    textAlign: TextAlign.right,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "Learn",
                                    textAlign: TextAlign.right,
                                    style:
                                        TextStyle(color: Color(0xff74c36c), fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 50,
                              width: 20,
                              color: Color(0xfff7d26c),
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                  //shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Color(0xfff7d26c),
                                    width: 1,
                                  )),
                              alignment: Alignment.center,
                              width: 80,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${budget.toStringAsFixed(1)}" "%",
                                    textAlign: TextAlign.right,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "Budget",
                                    textAlign: TextAlign.right,
                                    style:
                                        TextStyle(color: Color(0xfff7d26c), fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 40),

                Container(
                  margin: EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color(0xffcd6689),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade500,
                          offset: Offset(5, 5),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: Colors.grey[300]!,
                          offset: Offset(-2, -2),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ]),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      // onPrimary: Colors.white,
                      primary: Colors.white, // foreground
                    ),
                    onPressed: () {
                      NavigateRoute.gotoPage(context, const UserAddBixBite());
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Update My BixBite',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ),

                // RaisedButton(
                //     color: Colors.white,
                //     child: Container(
                //       height: 25,
                //       width: MediaQuery.of(context).size.width / 2.3,
                //       child: FittedBox(
                //         fit: BoxFit.fill,
                //         child: Text(
                //           'Update MyBixbite',
                //           //  style: TextStyle(color: Colors.red[200]),
                //         ),
                //       ),
                //     ),
                //     onPressed: () {
                //       print("Date");
                //       print(DateTime.now());
                //       RouteNavigator.gotoPage(context, UserAddBixBite());
                //
                //       // Constants.Status = 'started';
                //       // Navigator.pushNamed(
                //       //   context,
                //       //   GratitudeScreen.idScreen,
                //       // );
                //     }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  filterMyBixBite() {
    if (dropdownValueBixBite == "Gratitude") {
      live = 0.0;
      laugh = 0.0;
      love = 0.0;
      learn = 0.0;
      budget = 0.0;
    } else if (dropdownValueBixBite == "Live") {
      gratitude = 0.0;
      laugh = 0.0;
      love = 0.0;
      learn = 0.0;
      budget = 0.0;
    } else if (dropdownValueBixBite == "Laugh") {
      gratitude = 0.0;
      live = 0.0;
      love = 0.0;
      learn = 0.0;
      budget = 0.0;
    } else if (dropdownValueBixBite == "Love") {
      gratitude = 0.0;
      live = 0.0;
      laugh = 0.0;
      learn = 0.0;
      budget = 0.0;
    } else if (dropdownValueBixBite == "Learn") {
      gratitude = 0.0;
      live = 0.0;
      love = 0.0;
      laugh = 0.0;
      budget = 0.0;
    } else if (dropdownValueBixBite == "Budget") {
      gratitude = 0.0;
      live = 0.0;
      love = 0.0;
      learn = 0.0;
      laugh = 0.0;
    }
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
