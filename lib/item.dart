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
  String thumbnail;
  String size;
  String manufacturerNote;
  String website;
  String brand;
  int amount;
  List<DateTime> changed;
  List<dynamic> ingredients;
  Map<String, dynamic> nutriments;
  bool dataComplete;

  Item({
    this.barcode,
    this.name,
    this.amount = 1,
    this.size = '',
    this.imageUrl,
    this.thumbnail,
    this.manufacturerNote = '',
    this.changed,
    this.website = '',
    this.brand = '',
    this.dataComplete = false,
    this.ingredients,
    this.nutriments,
  }) {
    changed = changed ?? [DateTime.now()];
  }

  readUpdate(Map<String, dynamic> update, key, missing) {
    return update.containsKey(key) ? update[key] : missing;
  }

  void updateInfo(Map<String, dynamic> update) {
    this.name = readUpdate(update, 'product_name', null);
    this.imageUrl = readUpdate(update, 'image_url', null);
    this.thumbnail = readUpdate(update, 'image_thumb_url', null);
    this.size = readUpdate(update, 'quantity', '');
    this.manufacturerNote =
        readUpdate(update, 'usage', 'No information provided');
    this.ingredients = readUpdate(update, 'ingredients', null);
    this.website = readUpdate(update, 'product_web_page', null);
    this.nutriments = readUpdate(update, 'nutriments', null);
    this.brand = readUpdate(update, 'brands', '');
    this.dataComplete = true;
  }

  @override
  int compareTo(Item other) {
    return this.displayName.toLowerCase().compareTo(other.displayName.toLowerCase());
  }

  get identifier {
    return barcode ?? name.toLowerCase();
  }

  get titleName {
    var result = fullName;
    return result.length > 20 ? name : result;
  }

  get displayName {
    return name ?? barcode;
  }

  get fullName {
    if (name != null) {
      if (brand != "" && brand != null) {
        return "$brand $name";
      }
      return name;
    }
    return barcode;
  }

  get addedDate {
    return DateTime.now();
  }

  String get dateString {
    return DateFormat("dd.MM.yy").format(addedDate.toLocal());
  }

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);

  bool operator ==(o) => o is Item && identifier == o.identifier;
  int get hashCode => identifier.hashCode;
}
