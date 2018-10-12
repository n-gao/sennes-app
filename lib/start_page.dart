import 'package:flutter/material.dart';
import 'item.dart';
import 'item_page.dart';
import 'scan_page.dart';
import 'package:rounded_modal/rounded_modal.dart';

class StartPage extends StatefulWidget {
  StartPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _StartPageState createState() => new _StartPageState();
}

enum _StartPagePopupMenu { Settings }

class _StartPageState extends State<StartPage> {
  final items = <Item>[
    Item("Coke",
        amount: 1,
        size: "2l",
        imageUrl: "https://cdn.huntoffice.ie/images/D/can-of-coke.jpg"),
    Item("Tomatoes",
        amount: 12,
        imageUrl:
            "https://images-na.ssl-images-amazon.com/images/I/81avkS31xRL._SY355_.jpg"),
    Item("Cream Cheese",
        amount: 1,
        size: "200ml",
        imageUrl: "https://pics.drugstore.com/prodimg/419651/900.jpg"),
    Item("Cheddar",
        amount: 2,
        imageUrl:
            "https://www.maggi.de/Lists/Maggi-Images/maggi-kochstudio/wissen/lexikon/MAGGI-lexikon-cheddar.jpg"),
    Item("Milk",
        amount: 3,
        size: "1l",
        imageUrl:
            "https://target.scene7.com/is/image/Target/GUEST_ebef1ac1-6e80-484b-aaff-36a1a74b9e82?wid=488&hei=488&fmt=pjpeg"),
    Item("Yogurt",
        amount: 6,
        size: "6 pack",
        imageUrl:
            "https://www.heb.com.mx/media/catalog/product/cache/20/image/d954a60aa48ef57022b0eb878e93bc1f/Y/o/455179_635013011.png"),
    Item("Orange Juice",
        amount: 1,
        size: "1l",
        imageUrl:
            "https://static.meijer.com/Media/000/16300/0001630016565_2_A1C1_0600.png"),
    Item("Strawberry Marmalade",
        amount: 1,
        size: "500g",
        imageUrl: "https://www.abelandcole.co.uk/media/1648_18063_z.jpg"),
  ];
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  PersistentBottomSheetController addDialog;
  String toAdd = "";

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: Text(widget.title),
          centerTitle: true,
          actions: [
            new PopupMenuButton(
              itemBuilder: (context) {
                return _StartPagePopupMenu.values
                    .map((option) => PopupMenuItem<_StartPagePopupMenu>(
                          value: option,
                          child: ListTile(
                            leading: Icon(_getStartPagePopupMenuIcon(option)),
                            title: Text(_getStartPagePopupMenuName(option)),
                          ),
                        ))
                    .toList();
              },
              onSelected: (option) =>
                  _getStartPagePopupMenuFunction(option)(context),
            ),
          ],
        ),
        body: RefreshIndicator(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: _buildItem,
            physics: PageScrollPhysics(),
          ),
          key: _refreshIndicatorKey,
          onRefresh: () {
            return new Future.delayed(const Duration(seconds: 1), () {});
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _openAddItemDialog,
          tooltip: 'Add Item',
          child: new Icon(Icons.add),
        ));
  }

  @override
  void initState() {
    super.initState();
    items.sort();
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      Navigator.pop(context);
      _formKey.currentState.save();
      setState(() {
        try {
          Item item = items.firstWhere((i) => i.name == toAdd);
          item.amount += 1;
        } catch (Exception) {
          items.add(Item(toAdd));
          items.sort();
        }
      });
    }
  }

  Dismissible _buildItem(context, index) {
    final item = items[index];
    return Dismissible(
      key: ObjectKey(item),
      onDismissed: (direction) {
        setState(() {
          items.removeAt(index);
        });
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("${item.name} has been dismised."),
        ));
      },
      background: Container(
        color: Colors.green,
        alignment: Alignment(-0.9, 0.0),
        child: Icon(Icons.add, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment(0.9, 0.0),
        child: Icon(Icons.remove, color: Colors.white),
      ),
      child: Container(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(item.imageUrl),
          ),
          title: Text(item.name),
          subtitle: Text("${item.amount}x ${item.size}"),
          trailing: Text("scanned ${item.dateString}"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ItemPage(item: item)),
            );
          },
        ),
        decoration: index + 1 < items.length
            ? BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              )
            : null,
      ),
    );
  }

  void _openAddItemDialog() {
    showRoundedModalBottomSheet(
        context: _scaffoldKey.currentContext,
        radius: 16.0,
        builder: (builder) {
          return new Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: () {},
                          color: Colors.grey.shade600,
                        ),
                        Expanded(
                          child: TextFormField(
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: "Enter product name",
                              hintText: "e.g. Milk",
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter a name.";
                              }
                            },
                            onSaved: (product) {
                              toAdd = product;
                            },
                            onFieldSubmitted: (value) {
                              _submit();
                            },
                          ),
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: Text("Add"),
                          onPressed: _submit,
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ));
        });
  }

  String _getStartPagePopupMenuName(_StartPagePopupMenu option) {
    switch (option) {
      case _StartPagePopupMenu.Settings:
        return "Settings";
      default:
        return option.toString();
    }
  }

  IconData _getStartPagePopupMenuIcon(_StartPagePopupMenu option) {
    switch (option) {
      case _StartPagePopupMenu.Settings:
        return Icons.settings;
      default:
        return Icons.border_all;
    }
  }

  _getStartPagePopupMenuFunction(_StartPagePopupMenu option) {
    switch (option) {
      case _StartPagePopupMenu.Settings:
        return (context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScanPage()),
          );
        };
      default:
        return (context) {};
    }
  }
}
