import 'package:flutter/material.dart';
import 'item.dart';
import 'item_page.dart';
import 'item_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'swipeable.dart';

class ItemWidget extends StatefulWidget {
  ItemWidget({Key key, this.index, this.item, this.leftSwipeAction, this.rightSwipeAction})
      : super(key: key);

  final Item item;
  final dynamic index;
  final VoidCallback leftSwipeAction;
  final VoidCallback rightSwipeAction;

  @override
  State<StatefulWidget> createState() {
    return _ItemWidgetState();
  }
}

class _ItemWidgetState extends State<ItemWidget> {
  Item item;

  get loaded {
    // return false;
    return item != null;
  }

  void requestItem() {
    this.item = null;
    if (widget.item != null) {
      this.item = widget.item;
    } else {
      if (widget.index != null) {
        ItemController.getInstance().then((controller) {
          var futureItem = controller[widget.index];
          futureItem.then((result) {
            setState(() {
              this.item = result;
            });
          }).catchError((error) {
            print("error when getting item");
            print(error);
          });
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    requestItem();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    requestItem();
  }

  @override
  Widget build(BuildContext context) {
    if (loaded) {
      return Swipeable(
        // onDismissed: (widget.dismissedAction),
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
        onSwipeRight: () {
          print("right " + widget.index.toString());
          if (widget.rightSwipeAction != null) {
            widget.rightSwipeAction.call();
            setState(() {});
          }
        },
        onSwipeLeft: () {
          print("left " + widget.index.toString());
          if (widget.leftSwipeAction != null) {
            widget.leftSwipeAction.call();
            setState(() {});
          }
        },
        threshold: 128.0,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Material(
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                elevation: 1.0,
                color: Colors.white,
                type: MaterialType.card,
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  item.imageUrl,
                  width: 48.0,
                  height: 48.0,
                  fit: BoxFit.cover,
                ),
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
            Padding(
              padding: EdgeInsets.only(left: 64.0, right: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Shimmer.fromColors(
        baseColor: Colors.grey[100],
        highlightColor: Colors.grey[300],
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Material(
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                elevation: 1.0,
                color: Colors.white,
                type: MaterialType.card,
                clipBehavior: Clip.antiAlias,
                child: Container(
                  width: 48.0,
                  height: 48.0,
                  color: Colors.white,
                ),
              ),
              title: Container(
                  width: double.infinity, height: 8.0, color: Colors.white),
              subtitle:
                  Container(width: 40.0, height: 8.0, color: Colors.white),
              trailing:
                  Container(width: 40.0, height: 8.0, color: Colors.white),
            ),
            Padding(
              padding: EdgeInsets.only(left: 64.0, right: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade300)),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
