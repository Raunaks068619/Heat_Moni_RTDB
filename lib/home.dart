import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbrf = FirebaseDatabase.instance.ref();
  Map map = {};
  double temprature = 0.0;
  double humidity = 0.0;
  int HeatIndex = 0;

  Future<void> getData() async {
    print("getData pressed");
    dbrf.child("HeatIndex").onValue.listen((event) {
      setState(() {
        map = event.snapshot.value as Map;
        temprature = double.parse(map["temperature"].toString());
        humidity = double.parse(map["humidity"].toString());
      });
      print(temprature);
      print(humidity);
    });
    heatIndex(temprature, humidity);
  }

  void heatIndex(double temp,double hum) {
    var fahrenheit = ((temp * 9 / 5) + 32);
    var T2 = pow(fahrenheit, 2);
    var T3 = pow(fahrenheit, 3);
    var H2 = pow(hum, 2);
    var H3 = pow(hum, 3);
    var C1 = [
      -42.379,
      2.04901523,
      10.14333127,
      -0.22475541,
      -6.83783e-03,
      -5.481717e-02,
      1.22874e-03,
      8.5282e-04,
      -1.99e-06
    ];
    var C2 = [
      0.363445176,
      0.988622465,
      4.777114035,
      -0.114037667,
      0.000850208,
      -0.020716198,
      0.000687678,
      0.000274954,
      0
    ];
    var C3 = [
      16.923,
      0.185212,
      5.37941,
      -0.100254,
      0.00941695,
      0.00728898,
      0.000345372,
      -0.000814971,
      0.0000102102,
      -0.000038646,
      0.0000291583,
      0.00000142721,
      0.000000197483,
      -0.0000000218429,
      0.000000000843296,
      -0.0000000000481975
    ];
    var index = C1[0] +
        (C1[1] * fahrenheit) +
        (C1[2] * hum) +
        (C1[3] * fahrenheit * hum) +
        (C1[4] * T2) +
        (C1[5] * H2) +
        (C1[6] * T2 * hum) +
        (C1[7] * fahrenheit * H2) +
        (C1[8] * T2 * H2);
    var cels = (index - 32.0) * 5.0 / 9.0;
    setState(() {
      HeatIndex = cels.round();
    });
    print(HeatIndex);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.grey[100],
            body: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromARGB(
                                              220, 229, 229, 229),
                                          blurRadius: 10,
                                          offset: Offset(2, 4),
                                        ),
                                      ],
                                    ),
                                    height: 150,
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Temperature",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                              Divider(
                                                color: Colors.grey,
                                              ),
                                            ]),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${temprature}", //temprature
                                              style: TextStyle(
                                                  fontSize: 50,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(" °C",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromARGB(
                                              255, 229, 229, 229),
                                          blurRadius: 10,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    height: 150,
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Humidity",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                              Divider(
                                                color: Colors.grey,
                                              ),
                                            ]),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              humidity.toString(), //humidity
                                              style: TextStyle(
                                                  fontSize: 50,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              " %", //humidity
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          HeatIndex.toString(),
                                          style: TextStyle(
                                              color: HeatIndex > 27 &&
                                                      HeatIndex < 32
                                                  ? Color.fromARGB(
                                                      255, 248, 235, 48)
                                                  : HeatIndex > 32 &&
                                                          HeatIndex < 41
                                                      ? Color.fromARGB(
                                                          255, 248, 168, 48)
                                                      : HeatIndex > 41 &&
                                                              HeatIndex < 54
                                                          ? Color.fromARGB(
                                                              255, 248, 121, 48)
                                                          : HeatIndex > 54
                                                              ? Color.fromARGB(
                                                                  255,
                                                                  248,
                                                                  71,
                                                                  48)
                                                              : Color.fromARGB(
                                                                  255,
                                                                  248,
                                                                  211,
                                                                  48),
                                              fontSize: 150,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(" °C",
                                            style: TextStyle(
                                                color: HeatIndex > 27 &&
                                                        HeatIndex < 32
                                                    ? Color.fromARGB(
                                                        255, 248, 235, 48)
                                                    : HeatIndex > 32 &&
                                                            HeatIndex < 41
                                                        ? Color.fromARGB(
                                                            255, 248, 168, 48)
                                                        : HeatIndex > 41 &&
                                                                HeatIndex < 54
                                                            ? Color.fromARGB(
                                                                255,
                                                                248,
                                                                121,
                                                                48)
                                                            : HeatIndex > 54
                                                                ? Color
                                                                    .fromARGB(
                                                                        255,
                                                                        248,
                                                                        71,
                                                                        48)
                                                                : Color
                                                                    .fromARGB(
                                                                        255,
                                                                        248,
                                                                        211,
                                                                        48),
                                                fontSize: 40,
                                                fontWeight: FontWeight.w500))
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          HeatIndex > 27 && HeatIndex < 32
                                              ? "CAUTION"
                                              : HeatIndex > 32 && HeatIndex < 41
                                                  ? "EXTREME CAUTION"
                                                  : HeatIndex > 41 &&
                                                          HeatIndex < 54
                                                      ? "DANGER"
                                                      : HeatIndex > 54
                                                          ? "EXTREME DANGER"
                                                          : "ALL IS WELL",
                                          style: TextStyle(
                                              color: HeatIndex > 27 &&
                                                      HeatIndex < 32
                                                  ? Color.fromARGB(
                                                      255, 248, 235, 48)
                                                  : HeatIndex > 32 &&
                                                          HeatIndex < 41
                                                      ? Color.fromARGB(
                                                          255, 248, 168, 48)
                                                      : HeatIndex > 41 &&
                                                              HeatIndex < 54
                                                          ? Color.fromARGB(
                                                              255, 248, 121, 48)
                                                          : HeatIndex > 54
                                                              ? Color.fromARGB(
                                                                  255,
                                                                  248,
                                                                  71,
                                                                  48)
                                                              : Color.fromARGB(
                                                                  255,
                                                                  248,
                                                                  211,
                                                                  48),
                                              fontSize: 30,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Text(
                                            HeatIndex > 27 && HeatIndex < 32
                                                ? "Fatigue is possible with prolong activity and exposure. Continuing activity could result in heat cramps."
                                                : HeatIndex > 32 &&
                                                        HeatIndex < 41
                                                    ? "Heat cramps and heat exhaustions are possible. Continuing activity could result in heat stroke."
                                                    : HeatIndex > 41 &&
                                                            HeatIndex < 54
                                                        ? "Heat cramps and heat exhaustions are likely, heat stroke is probable with continued activity."
                                                        : HeatIndex > 54
                                                            ? "Heat stroke is imminent"
                                                            : "NO need to worry just drink loads of water :)",
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                })));
  }
}
