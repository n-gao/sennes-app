import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

// Call "flutter packages pub run build_runner build" in command line after chaning this class
@JsonSerializable()
class Item extends Comparable<Item> {
  final String name;
  final String imageUrl;
  final String barcode = "1";
  String size;
  String manufacturerNote;
  Map<String, String> attributes;
  DateTime addedDate;
  int amount;

  Item(this.name,
      {this.amount: 1,
      this.size: "",
      this.imageUrl:
          "https://www.maggi.de/Lists/Maggi-Images/maggi-kochstudio/wissen/lexikon/MAGGI-lexikon-cheddar.jpg",
      this.addedDate,
      this.manufacturerNote,
      this.attributes}) {
    if (this.addedDate == null) {
      this.addedDate = DateTime.now();
    }
  }

  factory Item.from(Item item) {
    return Item(item.name,
        amount: item.amount,
        size: item.size,
        imageUrl: item.imageUrl,
        addedDate: item.addedDate,
        attributes: item.attributes,
        manufacturerNote: item.manufacturerNote);
  }

  @override
  int compareTo(Item other) {
    return this.name.toLowerCase().compareTo(other.name.toLowerCase());
  }

  String get dateString {
    return DateFormat("dd.MM.yy").format(addedDate.toLocal());
  }

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
