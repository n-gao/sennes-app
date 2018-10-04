import 'package:flutter/material.dart';
import 'item.dart';

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

class _StartPageState extends State<StartPage> {
  final items = List<Item>.generate(10, (i) => Item("Name", amount: i+1));
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool visible = true;
  PersistentBottomSheetController addDialog;
  final _formKey = GlobalKey<FormState>();
  String toAdd = "";

  String getTitle() {
    if (!visible) {
      return "Add Item";
    } else {
      return widget.title;
    }
  }

  List<Widget> getActions() {
    if (!visible) {
      return [
        new IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              setState(() {
                if (items.contains(toAdd)) {
                  items.firstWhere((i) => i.name == toAdd).amount += 1;
                } else {
                  items.add(Item(toAdd));
                }
                addDialog?.close();
                addDialog = null;
              });
            }
          },
        )
      ];
    }
    return [];
  }

  void addItem() {
    setState(() {
      visible = false;
    });

    addDialog = _scaffoldKey.currentState.showBottomSheet<Null>((builder) {
      return new Form(
          key: _formKey,
          child: new Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: "Enter product name",
                      hintText: "Milk",
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter a name.";
                      }
                    },
                    onSaved: (product) {
                      toAdd = product;
                    },
                  ),
                ],
              )));
    });

    addDialog.closed.whenComplete(() {
      setState(() {
        visible = true;
      });
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
          content: Text("$item has been dismised."),
        ));
      },
      background: Container(
        color: Colors.red,
      ),
      child: ListTile(
        leading: Text("${item.amount}"),
        title: Text("${item.name}"),
      ),
    );
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
        title: new Text(getTitle()),
        actions: getActions(),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: _buildItem,
      ),
      floatingActionButton: visible
          ? new FloatingActionButton(
              onPressed: addItem,
              tooltip: 'Add Item',
              child: new Icon(Icons.add),
            )
          : null,
    );
  }
}
