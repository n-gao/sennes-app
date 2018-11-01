import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:math';

part 'item.g.dart';

// Call "flutter packages pub run build_runner build" in command line after chaning this class
@JsonSerializable()
class Item extends Comparable<Item> {
  String barcode;
  String name;
  String imageUrl;
  String size;
  String manufacturerNote;
  String website;
  String nutrition;
  String brand;
  int amount;
  List<DateTime> changed;
  String ingredients;
  bool dataComplete;

  Item({
    this.barcode,
    this.name,
    this.amount=0,
    this.size,
    this.imageUrl,
    this.manufacturerNote,
    this.changed,
    this.website,
    this.ingredients,
    this.brand,
    this.nutrition,
    this.dataComplete=false
  }) {
    this.barcode = Random().nextInt(9000000).toString();
  }

  readUpdate(Map<String, dynamic> update, key, missing) {
    return update.containsKey(key) ? update[key] : missing;
  }

  void updateInfo(Map<String, dynamic> update) {
    this.name = readUpdate(update, 'description', '<missing>');
    this.imageUrl = readUpdate(update, 'imageUrl', '');
    this.size = readUpdate(update, 'uom', '');
    this.manufacturerNote = readUpdate(update, 'usage', 'No information provided');
    this.ingredients = readUpdate(update, 'ingredients', '');
    this.website = readUpdate(update, 'product_web_page', '');
    this.nutrition = readUpdate(update, 'nutrition', '');
    this.brand = readUpdate(update, 'brand', '');
    this.dataComplete = true;
  }

  @override
  int compareTo(Item other) {
    return this.name.toLowerCase().compareTo(other.name.toLowerCase());
  }

  get displayName {
    return name ?? barcode;
  }

  get addedDate {
    return DateTime.now();
  }

  String get dateString {
    return DateFormat("dd.MM.yy").format(addedDate.toLocal());
  }

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
