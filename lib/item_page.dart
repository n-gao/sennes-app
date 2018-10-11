import 'package:flutter/material.dart';
import 'item.dart';

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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              leading: BackButton(),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(widget.item.name),
                background: Image.network('https://www.planet-wissen.de/gesellschaft/lebensmittel/schokolade/introschokolademayagjpg100~_v-gseapremiumxl.jpg', fit: BoxFit.cover),
              ),
            ) 
          ];
        },
        body: Center(child: Text(widget.item.amount.toString())),
      ),
      // appBar: GradientAppBar(
      //   title: new Text(widget.item.name),
      //   leading: new IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
      //     Navigator.pop(context);
      //   }),
      //   backgroundColorStart: Colors.blue.shade900,
      //   backgroundColorEnd: Colors.blue.shade400,
      // ),
      // body: Column(
      //   children: <Widget>[
      //     Image.network('https://github.com/flutter/website/blob/master/src/_includes/code/layout/lakes/images/lake.jpg?raw=true'),
      //     Text(widget.item.amount.toString()),
      //   ],
      // ),
    );
  }

  @override
  void initState() {

  }

  @override
  void dispose() {

  }
}
