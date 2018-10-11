class Item extends Comparable<Item> {
  DateTime addedDate;
  final String name;
  int amount;

  Item(this.name, {this.amount: 1, this.addedDate}){
    if (this.addedDate == null) {
      this.addedDate = DateTime.now();
    }
  }

  @override
    int compareTo(Item other) {
      return this.name.toLowerCase().compareTo(other.name.toLowerCase());
    }
}
