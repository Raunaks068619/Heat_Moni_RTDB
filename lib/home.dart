import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final Future<FirebaseApp> future = Firebase.initializeApp();
  final dbrf = FirebaseDatabase.instance.ref();
  Map map = {};
  String temprature = "";
  String humidity = "";

  Future<void> getData() async {
    print("getData pressed");
    await dbrf.child("rtdb").onValue.listen((event) {
      setState(() {
        map = event.snapshot.value as Map;
        temprature = map["temprature"].toString();
        humidity = map["humidity"].toString();
      });
      print(temprature);
      print(humidity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Rtdb'),
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            height: 100,
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: Text(
                              temprature,
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.w600),
                            ),
                          )),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Container(
                            height: 100,
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: Text(
                              humidity,
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.w600),
                            ),
                          ))
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}