import 'package:flutter/material.dart';
import 'package:flutter_sample/tabs/first.dart';
import 'package:flutter_sample/tabs/second.dart';

void main() {
  runApp(new MaterialApp(
    // Title
      title: "Youtube Search",
      home: new HomeWidget()));
}

class HomeWidget extends StatefulWidget {
  @override
  HomeWidgetState createState() => new HomeWidgetState();
}

// SingleTickerProviderStateMixin is used for animation
class HomeWidgetState extends State<HomeWidget> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();

    // Initialize the Tab Controller
    controller = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  TabBar getTabBar() {
    return new TabBar(
      tabs: <Tab>[
        new Tab(
          text: "Flutter",
        ),
        new Tab(
        text: "Unity VR"
        ),
      ],
      // setup the controller
      controller: controller,
    );
  }

  TabBarView getTabBarView(var tabs) {
    return new TabBarView(
      children: tabs,
      controller: controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // Appbar
        appBar: new AppBar(
          // Title
            title: new Text("Youtube Search"),
            backgroundColor: Colors.blue,
            bottom: getTabBar()),
        body: getTabBarView(<Widget>[new First(), new Second()]));
  }
}