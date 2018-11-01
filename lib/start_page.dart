import 'package:flutter/material.dart';
import 'item.dart';
import 'item_controller.dart';
import 'scan_page.dart';
import 'main.dart';
import 'item_widget.dart';

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
    Item(
        name: "Coke",
        amount: 1,
        size: "2l",
        imageUrl: "https://cdn.huntoffice.ie/images/D/can-of-coke.jpg"),
    Item(
        name: "Tomatoes",
        amount: 12,
        imageUrl:
            "https://images-na.ssl-images-amazon.com/images/I/81avkS31xRL._SY355_.jpg"),
    Item(
        name: "Cream Cheese",
        amount: 1,
        size: "200ml",
        imageUrl: "https://pics.drugstore.com/prodimg/419651/900.jpg"),
    Item(
        name: "Cheddar",
        amount: 2,
        imageUrl:
            "https://www.maggi.de/Lists/Maggi-Images/maggi-kochstudio/wissen/lexikon/MAGGI-lexikon-cheddar.jpg"),
    Item(
        name: "Milk",
        amount: 3,
        size: "1l",
        imageUrl:
            "https://target.scene7.com/is/image/Target/GUEST_ebef1ac1-6e80-484b-aaff-36a1a74b9e82?wid=488&hei=488&fmt=pjpeg"),
    Item(
        name: "Yogurt",
        amount: 6,
        size: "6 pack",
        imageUrl:
            "https://www.heb.com.mx/media/catalog/product/cache/20/image/d954a60aa48ef57022b0eb878e93bc1f/Y/o/455179_635013011.png"),
    Item(
        name: "Orange Juice",
        amount: 1,
        size: "1l",
        imageUrl:
            "https://static.meijer.com/Media/000/16300/0001630016565_2_A1C1_0600.png"),
    Item(
        name: "Strawberry Marmalade",
        amount: 1,
        size: "500g",
        imageUrl: "https://www.abelandcole.co.uk/media/1648_18063_z.jpg"),
  ];
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  PersistentBottomSheetController addDialog;
  ItemController controller;
  String toAdd = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: Text(
            widget.title,
            style: TextStyle(
                fontFamily: 'Chakra_Petch',
                fontWeight: FontWeight.w700,
                fontSize: 24.0),
          ),
          // backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          actions: [
            new PopupMenuButton(
              itemBuilder: (context) {
                return _StartPagePopupMenu.values
                    .map((option) => PopupMenuItem<_StartPagePopupMenu>(
                          value: option,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_getStartPagePopupMenuIcon(option)),
                              Container(width: 8.0),
                              Text(_getStartPagePopupMenuName(option)),
                            ],
                          ),
                        ))
                    .toList();
              },
              onSelected: (option) =>
                  _getStartPagePopupMenuFunction(option)(context),
            ),
          ],
        ),
        body: Material(
          type: MaterialType.card,
          color: Colors.white,
          shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          )),
          elevation: 8.0,
          clipBehavior: Clip.antiAlias,
          child: RefreshIndicator(
            child: ListView.builder(
              itemCount: controller != null ? controller.length : 15,
              itemBuilder: _buildItem,
              physics: PageScrollPhysics(),
            ),
            key: _refreshIndicatorKey,
            onRefresh: () {
              return new Future.delayed(const Duration(seconds: 2), () {});
            },
          ),
        ),
        backgroundColor: SennesApp.primaryColor,
        floatingActionButton: FloatingActionButton(
          onPressed: _openAddItemDialog,
          tooltip: 'Add Item',
          child: new Icon(Icons.add),
          shape:
              BeveledRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
        ));
  }

  @override
  void initState() {
    super.initState();
    if (this.controller == null) {
      ItemController.getInstance().then((controller) {
        setState(() {
          this.controller = controller;
          controller.setChangedCallback(() {
            // setState(() {});
          });
          for (var item in items) {
            controller.add(item);
          }
        });
      }).catchError((error) {
        print("error when trying to get controller");
        print(error);
      });
    }
    items.sort();
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      Navigator.pop(context);
      _formKey.currentState.save();
      setState(() {
        controller?.increase(name: toAdd);
      });
    }
  }

  Widget _buildItem(context, index) {
    print(controller.inventory);
    return ItemWidget(
      index: controller != null ? index : null,
      leftSwipeAction: () {
        controller.increase(index: index);
      },
      rightSwipeAction: () {
        controller.decrease(index: index);
      },
    );
  }

  void _openAddItemDialog() {
    showModalBottomSheet(
        context: _scaffoldKey.currentContext,
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
                          child: Text("Add"),
                          onPressed: _submit,
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
