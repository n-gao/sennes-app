import 'package:flutter/material.dart';
import 'item.dart';
import 'item_page.dart';
import 'item_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'swipeable.dart';

class ItemWidget extends StatefulWidget {
  ItemWidget({Key key, this.index, this.item, this.animation})
      : super(key: key ?? ObjectKey(item) ?? ValueKey(index));

  final Item item;
  final dynamic index;
  final Animation<double> animation;

  @override
  State<StatefulWidget> createState() {
    return _ItemWidgetState();
  }
}

class _ItemWidgetState extends State<ItemWidget> {
  ItemController _controller;

  Item get item {
    return widget.item ??
        (_controller != null ? _controller[widget.index] : null);
  }

  get loaded {
    // return false;
    return item != null;
  }

  Future<ItemController> get controller async {
    return _controller ?? await ItemController.getInstance();
  }

  Future<void> requestItemData() async {
    if (item == null || item.dataComplete) return;
    var con = await controller;
    await con.requestItemInfos([item]);
    if (mounted) setState(() {});
  }

  Future<void> requestItem() async {
    if (widget.index != null) {
      var con = await controller;
      if (mounted)
        setState(() {
          this._controller = con;
          requestItemData();
        });
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
    Widget listTile = ListTile(
      leading: Material(
        shape:
            BeveledRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        elevation: 1.0,
        color: Colors.white,
        type: MaterialType.card,
        clipBehavior: Clip.antiAlias,
        child: loaded && (item.imageUrl != null || item.thumbnail != null)
            ? Image.network(
                item.thumbnail ?? item.imageUrl,
                width: 48.0,
                height: 48.0,
                fit: BoxFit.cover,
              )
            : Container(
                width: 48.0,
                height: 48.0,
                color: Colors.white,
              ),
      ),
      title: loaded ? Text(item.displayName) : Container(),
      subtitle: loaded ? Text("${item.amount}x ${item.size}") : Container(),
      trailing: loaded ? Text(item.dateString) : Container(),
      onTap: loaded
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ItemPage(item: item)),
              );
            }
          : null,
    );

    if (_controller != null && _controller.length != (widget.index??-1) + 1)
    listTile = Column(children: <Widget>[
      listTile,
      Padding(
        padding: EdgeInsets.only(left: 64.0, right: 16.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
          ),
        ),
      ),
    ]);

    if (loaded) {
      var swipeable = Swipeable(
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
          controller.then((con) {
            con.decrease(index: widget.index);
            setState(() {
              print(item.amount);
            });
          });
        },
        onSwipeLeft: () {
          controller.then((con) {
            con.increase(index: widget.index);
            setState(() {
              print(item.amount);
            });
          });
        },
        threshold: 96.0,
        child: listTile,
      );
      if (widget.animation != null) {
        return SizeTransition(
            axis: Axis.vertical,
            sizeFactor: widget.animation,
            child: swipeable);
      }
      return swipeable;
    } else {
      return Shimmer.fromColors(
          baseColor: Colors.grey[100],
          highlightColor: Colors.grey[300],
          child: listTile);
    }
  }
}
