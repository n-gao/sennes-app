import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

// Call "flutter packages pub run build_runner build" in command line after chaning this class
@JsonSerializable()
class Item extends Comparable<Item> {
  final String barcode;
  String name;
  String imageUrl;
  String size;
  String manufacturerNote;
  Map<String, String> attributes;
  int amount;
  List<DateTime> changed;

  Item({
    this.barcode,
    this.name,
    this.amount=0,
    this.size,
    this.imageUrl,
    this.manufacturerNote,
    this.attributes,
    this.changed
  });

  void updateData(Map<String, dynamic> json) {

  }

  @override
  int compareTo(Item other) {
    return this.name.toLowerCase().compareTo(other.name.toLowerCase());
  }

  get addedDate {
    return changed.last;
  }

  String get dateString {
    return DateFormat("dd.MM.yy").format(addedDate.toLocal());
  }

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
