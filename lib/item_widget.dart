import 'package:flutter/material.dart';
import 'item.dart';
import 'item_page.dart';
import 'item_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'swipeable.dart';

class ItemWidget extends StatefulWidget {
  ItemWidget({Key key, this.index, this.item, this.animation})
      : super(key: key);

  final Item item;
  final dynamic index;
  final Animation<double> animation;

  @override
  State<StatefulWidget> createState() {
    return _ItemWidgetState();
  }
}

class _ItemWidgetState extends State<ItemWidget> {
  ItemController controller;
  Item _item;

  Item get item {
    return widget.item ?? _item;
  }

  get loaded {
    // return false;
    return item != null;
  }

  void requestItem() async {
    controller = controller ?? await ItemController.getInstance();
    var item = await controller[widget.index];
    setState(() {
      this._item = item;
    });
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
        child: loaded
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
      title: loaded ? Text(item.name) : Container(),
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
    print(loaded);
    if (loaded) {
      var swipeable = Swipeable(
          key: ObjectKey(item),
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
            setState(() {
              controller.decrease(index: widget.index);
            });
          },
          onSwipeLeft: () {
            setState(() {
              controller.increase(index: widget.index);
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
