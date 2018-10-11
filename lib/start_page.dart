import 'package:flutter/material.dart';
import 'item.dart';
import 'item_page.dart';
import 'scan_page.dart';

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
    Item("Coke 2L", amount: 1),
    Item("Tomatoes", amount: 12),
    Item("Cream Cheese", amount: 1),
    Item("Cheddar", amount: 2),
    Item("Milk", amount: 3),
    Item("Yogurt", amount: 6),
    Item("Orange Juice 1L", amount: 1),
    Item("Strawberry Marmelade", amount: 1),
  ];
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  PersistentBottomSheetController addDialog;
  final _formKey = GlobalKey<FormState>();
  String toAdd = "";

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

  void _openAddItemDialog() {
    showModalBottomSheet(
        context: _scaffoldKey.currentContext,
        builder: (builder) {
          return new Form(
              key: _formKey,
              child: Column(
                children: [
                  ListTile(
                    title: TextFormField(
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
                    trailing: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _submit,
                      color: Colors.blueAccent,
                    ),
                  )
                ],
              ));
        });
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
      ),
      secondaryBackground: Container(
        color: Colors.red,
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(item.amount.toString()),
        ),
        title: Text(item.name),
        trailing: Text(item.addedDate.toLocal().toString()),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ItemPage(item: item)),
          );
        },
      ),
    );
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
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: _buildItem,
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
}
