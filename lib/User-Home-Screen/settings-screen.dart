import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybixbite/Controller-Provider/Theme-Controller/theme-controler-provider.dart';
import 'package:mybixbite/Routes/routes.dart';
import 'package:mybixbite/User-Home-Screen/show-map.dart';
import 'package:provider/src/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //remove arrow back icon
        centerTitle: true,
        title: const Text("Settings"),

        actions: [
          // Switch(
          //     value: isDark,
          //     onChanged: (newValue) {
          //       context.read<ThemeManager>().toggleTheme(newValue);
          //     }),
          TextButton(
              onPressed: () {
                NavigateRoute.gotoPage(context, ShowMap());
              },
              child: Text("Show Map"))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Expanded(
          child: Column(
            children: [
              Container(
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.work_outlined,
                            color: Colors.orange,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                              width: 300,
                              child: Text(
                                " Testing adasdasdasdad adadTesting adasdasdasdad adadTesting adasdasdasdad adad",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.add_location,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                              width: 300,
                              child: Text(
                                  "Talisay City Cebu Testing adasdasdasdad adad Testing adasdasdasdad adad")),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(Icons.watch),
                          SizedBox(
                            width: 20,
                          ),
                          Text("8:00 am - 5:00 pm"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
