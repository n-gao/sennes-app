import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'item.dart';

class ItemController {
  List<Item> _inventory;

  Future readFromStorage() async {
    var localFile = await _inventoryFile;
    var content = await localFile.readAsString();
    _inventory = json.decode(content) as List<Item>;
  }

  Future saveToStorage() async {
    var localFile = await _inventoryFile;
    await localFile.writeAsString(json.encode(_inventory));
  }

  Future<String> get _appDocDir async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _inventoryFile async {
    final path = await _appDocDir;
    return File('$path/inventory.json');
  }

  void add(Item item) {
    _inventory.add(item);
    _inventory.sort();
  }

  Item operator [](int index) {
    return _inventory[index];
  }
}
