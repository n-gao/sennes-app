import 'package:intl/intl.dart';

class Item extends Comparable<Item> {
  DateTime addedDate;
  final String name;
  final String size;
  final String imageUrl;
  int amount;

  Item(this.name, {this.amount: 1, this.size : "", this.imageUrl : "https://www.maggi.de/Lists/Maggi-Images/maggi-kochstudio/wissen/lexikon/MAGGI-lexikon-cheddar.jpg", this.addedDate}){
    if (this.addedDate == null) {
      this.addedDate = DateTime.now();
    }
  }

  @override
    int compareTo(Item other) {
      return this.name.toLowerCase().compareTo(other.name.toLowerCase());
    }

  String get dateString {
    return DateFormat("dd.MM.yy").format(addedDate.toLocal());
  }
}
