import 'package:flutter/material.dart';
import 'item.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class ItemPage extends StatefulWidget {
  ItemPage({Key key, this.item}) : super(key: key);

  final Item item;

  @override
  _ItemPageState createState() => new _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: new Text(widget.item.name),
        leading: new IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
          Navigator.pop(context);
        }),
        backgroundColorStart: Colors.blue.shade900,
        backgroundColorEnd: Colors.blue.shade400,
      ),
      body: Column(
        children: <Widget>[
          new Text(widget.item.amount.toString()),
        ],
      ),
    );
  }

  @override
  void initState() {

  }

  @override
  void dispose() {

  }
}
