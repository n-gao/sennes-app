import 'package:flutter/material.dart';
import 'item.dart';
import 'main.dart';
import 'dart:math';

class ItemPage extends StatefulWidget {
  ItemPage({Key key, this.item}) : super(key: key);

  final Item item;

  @override
  _ItemPageState createState() => new _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  static const keys = [
    'energy',
    'fat',
    'saturated-fat',
    'carbohydrates',
    'sugars',
    'proteins',
    'salt'
  ];

  @override
  void initState() {}

  @override
  void dispose() {}

  @override
  Widget build(BuildContext context) {
    List<DataRow> nutritionRows = List<DataRow>();
    if (widget.item.nutriments != null) {
      for (var key in keys) {
        var value = widget.item.nutriments[key + "_100g"] ?? "—";
        var parts = key.split('-');
        var title = parts.map((p) => "${p[0].toUpperCase()}${p.substring(1)}").join(' ');
        var unit = widget.item.nutriments[key + "_unit"] ?? "";
        if (value is double)
          value = ((value*100).round()/100).toString();
        if (value == null)
          value = "--";
        unit = ' ' + unit;
        nutritionRows.add(DataRow(cells: [
          DataCell(Text(title)),
          // DataCell(Text(totalValue)),
          DataCell(Text(value + unit)),
        ]));
      }
      // widget.item.nutriments.forEach((key, value) {
      //   if (value != '' && key.endsWith('_100g')) {
      //     var totalKey = key.replaceAll('_100g', '');
      //     var parts = totalKey.split('-');
      //     var title = parts.map((p) => "${p[0].toUpperCase()}${p.substring(1)}").join(' ');
      //     var totalValue = widget.item.nutriments[totalKey];
      //     if (value is double)
      //       value = value.toStringAsPrecision(2);
      //     if (totalValue is double)
      //       totalValue = totalValue.toStringAsPrecision(2);
      //     nutritionRows.add(DataRow(cells: [
      //       DataCell(Text(title)),
      //       // DataCell(Text(totalValue)),
      //       DataCell(Text(value)),
      //     ]));
      //   }
      // });
    }
    if (widget.item.ingredients != null) {
      for (var ingredient in widget.item.ingredients) {
        print(ingredient);
      }
    }

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
                collapseMode: CollapseMode.parallax,
                centerTitle: true,
                title: Text(widget.item.displayName),
                background: widget.item.imageUrl != null
                    ? Image.network(widget.item.imageUrl, fit: BoxFit.cover)
                    : Container(
                        color: SennesApp.primaryColor,
                      ),
              ),
            )
          ];
        },
        body: Padding(
          padding: EdgeInsets.all(0.0),
          child: ListView(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            children: <Widget>[
              Text(
                "Manufacturer information",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              Container(
                height: 8.0,
              ),
              Text(
                widget.item.manufacturerNote,
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
              // Text(
              //   "per 100g",
              //   style: TextStyle(
              //     fontSize: 12.0,
              //   ),
              // ),
              Container(
                height: 8.0,
              ),
              DataTable(
                columns: [
                  DataColumn(
                    label: Text("Attribute"),
                    numeric: false,
                  ),
                  // DataColumn(
                  //   label: Text("Total"),
                  //   numeric: true,
                  // ),
                  DataColumn(
                    label: Text("per 100g"),
                    numeric: true,
                  ),
                  // DataColumn(
                  //   label: Text("%Daily"),
                  //   numeric: true,
                  // ),
                ],
                rows: nutritionRows,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
