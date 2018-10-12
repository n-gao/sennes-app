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
  void initState() {}

  @override
  void dispose() {}

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
                background:
                    Image.network(widget.item.imageUrl, fit: BoxFit.cover),
              ),
            )
          ];
        },
        body: Padding(
          padding: EdgeInsets.all(0.0),
          child: ListView(
            padding: EdgeInsets.only(left:16.0, right: 16.0, top: 16.0),
            children: <Widget>[
              Text(
                "Manufactor information",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              Container(
                height: 8.0,
              ),
              Text(
                "We select the highest quality Irish cheddar across our Ardagh range which is made with Irish milk and is produced and packed in Ireland.",
                textAlign: TextAlign.justify,
              ),
              Container(
                height: 8.0,
              ),
              Divider(),
              Container(
                height: 8.0,
              ),
              Text(
                "Nutrition Facts",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              Text(
                "per 100g",
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
              Container(
                height: 8.0,
              ),
              DataTable(
                columns: [
                  DataColumn(
                    label: Text("Attribute"),
                    numeric: false,
                  ),
                  DataColumn(
                    label: Text("Value"),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text("%Daily"),
                    numeric: true,
                  ),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text("Calories")),
                    DataCell(Text("402")),
                    DataCell(Text("18%")),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Total Fat")),
                    DataCell(Text("33g")),
                    DataCell(Text("50%")),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Cholesterol")),
                    DataCell(Text("105mg")),
                    DataCell(Text("35%")),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Sodium")),
                    DataCell(Text("621mg")),
                    DataCell(Text("25%")),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Potassium")),
                    DataCell(Text("98mg")),
                    DataCell(Text("2%")),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
