import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/weather?format=json&key=4f963d06";

void main() async {
  http.Response response = await http.get(request);
  print(response.body);
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final color = const Color(0xffFDF6E6);
  String _search;

  Future<Map> _getData() async {
    http.Response response;

    if (_search == null) {
      response = await http.get(
          'https://api.hgbrasil.com/weather?key=4f963d06&city_name=Cacequi,RS');
      print('sdsdas');
    } else {
      http.Response response = await http.get(
          "https://api.hgbrasil.com/weather?key=4f963d06&city_name=$_search");
      print('1');
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {},
          child: Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 30.0, top: 20.0),
            child: Text(
              '°C',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0),
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: 'Search for a city',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  )),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getData(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return Stack(
                        children: <Widget>[
                          Positioned(
                            height: 140.0,
                            left: 135.0,
                            child: Center(
                                child: Text(
                              snapshot.data["results"]["city"]
                                  .toString()
                                  .substring(
                                      0,
                                      snapshot.data["results"]["city"].length -
                                          1),
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.bold),
                            )),
                          ),
                          Positioned(
                            height: 250.0,
                            left: 140.0,
                            child: Center(
                                child: Text(
                              snapshot.data["results"]["temp"].toString() + '°',
                              style: TextStyle(
                                  fontSize: 65.0, fontWeight: FontWeight.bold),
                            )),
                          ),
                        ],
                      );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
