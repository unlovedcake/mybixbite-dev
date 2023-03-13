import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';
import 'package:mybixbite/User-Home-Screen/navigation-home-screen.dart';

class UserAddBixBite extends StatefulWidget {
  const UserAddBixBite({Key? key}) : super(key: key);

  @override
  _UserAddBixBiteState createState() => _UserAddBixBiteState();
}

class _UserAddBixBiteState extends State<UserAddBixBite> {
  User? user = FirebaseAuth.instance.currentUser;
  DateTime _now = DateTime.now();

  final _controller = PageController();
  bool _islastPage = false;

  int indexPageView = 0;

  double? gratitude;
  double? live;
  double? laugh;
  double? love;
  double? learn;
  double? budget;
  DateTime _currentDate = DateTime.now();
  String? currentDate;
  bool? _isEmpty;
  String? val;

  getData() async {
    DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);

    await FirebaseFirestore.instance
        .collection("table-bixbite")
        .where("email", isEqualTo: user!.email)
        .where("dateCreated", isEqualTo: _start)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        print("OK");
        print(result.data()['currentMonth']);
        val = result.data()['currentMonth'];
      });
    });
    print(val);
    // print(result);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
      body: Container(
        padding: const EdgeInsets.only(bottom: 10),
        child: PageView(
          controller: _controller,
          onPageChanged: (index) => setState(() {
            //_islastPage = index == 5;

            indexPageView = index;

            print(index);
          }),
          children: [
            pageViewContent(
              "Did you \n Practice \n Gratitude?",
            ),
            pageViewContent(
              "Did you \n Take Care of \n You?",
            ),
            pageViewContent(
              "Did you \n Laugh with \n Friends?",
            ),
            pageViewContent(
              "Did you \n Nurture \n Relationships?",
            ),
            pageViewContent(
              "Did you \n Continue \n Learning?",
            ),
            pageViewContent(
              "Did you \n Manage Your \n Money?",
            ),
          ],
        ),
      ),
    );
  }

  Widget pageViewContent(String question) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 8.0),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 35.0,
            ),
            const Image(
              image: AssetImage("assets/images/bixbite_logo.png"),
              width: 150.0,
              height: 150.0,
              alignment: Alignment.center,
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              question,
              style: TextStyle(fontSize: 30.0, fontFamily: "Brand Bold"),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      _controller.jumpToPage(indexPageView - 1);
                    },
                    color: Color(0xffcd6689),
                    textColor: Colors.white,
                    child: Text('Back'),
                    padding: EdgeInsets.all(25),
                    shape: CircleBorder(),
                  ),
                  MaterialButton(
                    onPressed: () {
                      _controller.nextPage(
                        duration: const Duration(
                          microseconds: 500,
                        ),
                        curve: Curves.easeInOut,
                      );

                      if (indexPageView == 0) {
                        gratitude = 0;
                      } else if (indexPageView == 1) {
                        live = 0;
                      } else if (indexPageView == 2) {
                        laugh = 0;
                      } else if (indexPageView == 3) {
                        love = 0;
                      } else if (indexPageView == 4) {
                        learn = 0;
                      } else if (indexPageView == 5) {
                        setState(() {
                          budget = 0;
                          _islastPage = true;
                        });
                      }
                    },
                    color: Color(0xffcd6689),
                    textColor: Colors.white,
                    child: Text('No'),
                    padding: EdgeInsets.all(25),
                    shape: CircleBorder(),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      print(indexPageView);

                      _controller.nextPage(
                        duration: const Duration(
                          microseconds: 500,
                        ),
                        curve: Curves.easeInOut,
                      );

                      if (indexPageView == 0) {
                        gratitude = 1;
                      } else if (indexPageView == 1) {
                        live = 1;
                      } else if (indexPageView == 2) {
                        laugh = 1;
                      } else if (indexPageView == 3) {
                        love = 1;
                      } else if (indexPageView == 4) {
                        learn = 1;
                      } else if (indexPageView == 5) {
                        setState(() {
                          budget = 1;
                          _islastPage = true;
                        });
                      }

                      //addBixBite(bixBite!);
                    },
                    color: Color(0xffcd6689),
                    textColor: Colors.white,
                    child: Text('Yes'),
                    padding: EdgeInsets.all(25),
                    shape: CircleBorder(),
                  ),
                ],
              ),
            ),
            _islastPage
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.orange, onPrimary: Colors.black),
                    onPressed: () async {
                      if (val == null) {
                        await FirebaseFirestore.instance.collection("table-bixbite").add({
                          "gratitude": gratitude,
                          "live": live,
                          "laugh": laugh,
                          "love": love,
                          "learn": learn,
                          "budget": budget,
                          //"dateCreated": DateFormat.yMMMMd().format(_currentDate),
                          "dateCreated": DateUtils.dateOnly(_currentDate),
                          "currentMonth": new DateFormat.yMMMM().format(_currentDate),
                          //"dateCreated": berlinWallFellDate,
                          "email": user!.email,
                        }).then((result) {
                          Fluttertoast.showToast(msg: "Created successfully ");
                          print("Success!");
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (context) => NavigationHomeScreen()));
                        }).catchError((error) {
                          Fluttertoast.showToast(msg: "Something wnet wrong!!! ");
                          print("Error!");
                        });
                      } else {
                        Fluttertoast.showToast(msg: "You are already answered today. ");
                      }
                    },
                    child: const Text("Done"))
                : Container(),
          ],
        ),
      ),
    );
  }
}
