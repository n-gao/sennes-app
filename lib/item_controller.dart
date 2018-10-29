import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'item.dart';
import 'server_api.dart';
import 'request.dart';
import 'response.dart';

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

  Future requestItemInfos(List<Item> items) async {
    Request request = Request.barcodeInfo(items.map((item) => item.barcode));
    Response response = await ServerApi.getInstance().fetchRequest(request);
    // response.barcodeInfo
  }

  void add(Item item) {
    _inventory.add(item);
    _inventory.sort();
  }

  Item operator [](int index) {
    return _inventory[index];
  }

  Future<String> get _appDocDir async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _inventoryFile async {
    final path = await _appDocDir;
    return File('$path/inventory.json');
  }
}
