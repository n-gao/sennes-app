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
    return widget.item ?? (_controller != null ? _controller[widget.index] : null);
  }

  get loaded {
    // return false;
    return item != null;
  }

  Future<ItemController> get controller async {
    return _controller ?? await ItemController.getInstance();
  }

  Future<void> requestItemData() async {
    return;
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
    var listTile = ListTile(
      leading: Material(
        shape:
            BeveledRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        elevation: 1.0,
        color: Colors.white,
        type: MaterialType.card,
        clipBehavior: Clip.antiAlias,
        child: loaded && item.imageUrl != null
            ? Image.network(
                item.imageUrl,
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
      trailing: loaded ? Text("scanned ${item.dateString}") : Container(),
      onTap: loaded
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ItemPage(item: item)),
              );
            }
          : null,
    );
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
              setState(() {print(item.amount);});
            });
          },
          onSwipeLeft: () {
            controller.then((con) {
              con.increase(index: widget.index);
              print(widget.item);
              setState(() {print(item.amount);});
            });
          },
          threshold: 128.0,
          child: listTile);
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
