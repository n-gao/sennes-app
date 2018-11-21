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
    this.name='',
    this.amount=1,
    this.size='',
    this.imageUrl=null,
    this.manufacturerNote='',
    this.changed,
    this.website='',
    this.ingredients='',
    this.brand='',
    this.nutrition='',
    this.dataComplete=false
  }) {
    changed = changed ?? [DateTime.now()];
  }

  readUpdate(Map<String, dynamic> update, key, missing) {
    return update.containsKey(key) ? update[key] : missing;
  }

  void updateInfo(Map<String, dynamic> update) {
    this.name = readUpdate(update, 'description', '<missing>');
    this.imageUrl = readUpdate(update, 'image', null);
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

  get identifier {
    return barcode ?? name.toLowerCase();
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

  void updateFrom(Item other) {
    this.barcode = other.barcode;
    this.amount = other.amount;
    this.brand = other.brand;
    this.changed = other.changed;
    this.dataComplete = other.dataComplete;
    this.imageUrl = other.imageUrl;
    this.ingredients = other.ingredients;
    this.manufacturerNote = other.manufacturerNote;
    this.name = other.name;
    this.nutrition = other.nutrition;
    this.size = other.size;
    this.website = other.website;
  }

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);

  bool operator == (o) => o is Item && identifier == o.identifier;
  int get hashCode => identifier.hashCode;
}
