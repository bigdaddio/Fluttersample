import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'dart:io';
import 'dart:convert';

class First extends StatefulWidget {
  @override
  GetHttpDataState createState() => new GetHttpDataState();
}

class GetHttpDataState extends State<First> {
  final String base = "www.googleapis.com";
  final String url = "youtube/v3/search";
  List data;

  Future<String> getJSONData() async {

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    Object options = {
      // uncomment and add your API key
      'key': "AIzaSyASUo8U9U-BchtxsqHX-SdI4m4vZGCe3EE",
      'part': "snippet",
      'maxResults': "25",
      'q': "flutter",
      'type': ""
    };

    // This is a bit nasty, only fill in bundle ID if iOS.
    String packageName = "";
    if (Platform.isIOS)
      packageName = packageInfo.packageName;

    Uri searchUrl = new Uri.https(base, url, options);
    var response = await http.get( searchUrl,
        headers: {"Accept": "application/json", 'X-Ios-Bundle-Identifier': packageName});

    // Logs the response body to the console
    //print(response.body);

    setState(() {
      // Get the JSON data
      var dataConvertedToJSON = json.decode(response.body);
      // Extract the required part and assign it to the global variable named data
      data = dataConvertedToJSON['items'];
    });

    return "Successfull";
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (_, int index) => listItem(index)
      ),
    );
  }

  Widget listItem(index){
    return new Card(
      shape: RoundedRectangleBorder(  // rounded corners on card
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: new Container(
        margin: EdgeInsets.symmetric(vertical: 7.0),
        padding: EdgeInsets.all(12.0),
        child:new Row(
          children: <Widget>[
            new ClipRRect(  // round image corners
              borderRadius: new BorderRadius.circular(10.0),
              child: new Image.network(data[index]['snippet']["thumbnails"]["default"]["url"]),
            ),
            new Padding(padding: EdgeInsets.only(right: 20.0)),
            new Expanded(child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text( // Title
                    data[index]['snippet']["title"],
                    softWrap: true,
                    style: TextStyle(fontSize:16.0, fontWeight: FontWeight.bold),
                  ),
                  new Padding(padding: EdgeInsets.only(bottom: 1.5)),
                  new Text( // Channel
                    data[index]['snippet']["channelTitle"],
                    softWrap: true,
                    style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                  new Padding(padding: EdgeInsets.only(bottom: 3.0)),
                  new Text(
                    data[index]['snippet']["description"],
                    softWrap: true,
                    style: TextStyle(fontSize: 11.0),
                  ),
                ]
            ))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this.getJSONData();
  }
}