import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'item.dart';
import 'server_api.dart';
import 'request.dart';
import 'response.dart';
import 'configuration.dart';
import 'item_update.dart';

typedef void InventoryChanged();

class ItemController {
  final cryptor = PlatformStringCryptor();
  final Configuration config;
  Map<String, Item> _inventoryMap;
  List<Item> _inventory;
  InventoryChanged _changedCallback;
  int _state;
  Set<ItemUpdate> _unconfirmedUpdates = Set();

  List<Item> get inventory {
    return _inventory.where((item) => item.amount > 0).toList(growable: false);
  }

  bool get confirmed {
    return _unconfirmedUpdates.length == 0;
  }

  static ItemController _instance;
  static Future<ItemController> getInstance() async {
    if (_instance == null) {
      _instance = ItemController();
      await _instance.readFromStorage();
    }
    return _instance;
  }

  ItemController() : config = Configuration.getInstance();

  Future readFromStorage() async {
    var localFile = await _inventoryFile;
    _inventoryMap = Map();
    try {
      var content = await localFile.readAsString();
      var stored = json.decode(content);
      _inventory = stored['inventory'] as List<Item>;
      _inventory.forEach((item) => _inventoryMap[item.barcode] = item);
      _state = stored['state'] as int;
    } catch(error){
      _inventory = [];
      _state = 0;
    }
    _unconfirmedUpdates = Set();
  }

  Future saveToStorage() async {
    if (!confirmed) throw Error();
    var localFile = await _inventoryFile;
    await localFile.writeAsString(json.encode({
      'inventory' : _inventory,
      'state' : _state
    }));
  }

  Future requstItemUpdates() async {
    Request request = Request.getUpdates(await config.getFridgeId(), _state);
    Response response = await ServerApi.getInstance().fetchRequest(request);
    var key = await config.getEncryptionKey();
    for (var update in response.updates) {
      var updateJson = json.decode(await cryptor.decrypt(update, key));
      var itemUpdate = ItemUpdate.fromJson(updateJson);
      _applyUpdate(itemUpdate);
    }
    _state = response.newState;
    saveToStorage();
    _changedCallback?.call();
  }

  Future requestItemInfos(List<Item> items) async {
    Request request = Request.barcodeInfo(items.map((item) => item.barcode));
    Response response = await ServerApi.getInstance().fetchRequest(request);
    for (var i=0; i<items.length; i++) {
      items[i].updateInfo(response.barcodeInfo[i]);
    }
    saveToStorage();
    _changedCallback?.call();
  }

  Future uploadUpdate(ItemUpdate update) async {
    var key = await config.getEncryptionKey();
    var blob = await cryptor.encrypt(json.encode(update), key);
    var fridgeId = await config.getFridgeId();
    await ServerApi.getInstance().fetchRequest(Request.addUpdate(fridgeId, blob));
    _unconfirmedUpdates.remove(update);
  }

  void applyUpdate(ItemUpdate update) {
    _unconfirmedUpdates.add(update);
    _applyUpdate(update);
    uploadUpdate(update);
  }

  void _applyUpdate(ItemUpdate update) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(update.timestamp);
    print(update.name);
    print(_inventoryMap.keys);
    if (_inventoryMap.containsKey(update.identifier)) {
      _inventoryMap[update.identifier].amount += update.method == 0 ? 1 : -1;
      _inventoryMap[update.identifier].changed.add(time);
    } else {
      add(Item(barcode: update.barcode, name: update.name, changed: [time]));
    }
    _changedCallback?.call();
  }

  void setChangedCallback(InventoryChanged callback) {
    this._changedCallback = callback;
  }
  
  void increase({String barcode, String name, int index}) {
    if (barcode == null && name == null && index != null) {
      barcode = _inventory[index].barcode;
      name = _inventory[index].name;
    }
    var update = ItemUpdate(
      name: name,
      barcode: barcode,
      method: 0,
      methodName: "increase",
      timestamp: DateTime.now().millisecondsSinceEpoch
    );
    applyUpdate(update);
  }
  
  void decrease({String barcode, String name, int index}) {
    if (barcode == null && name == null && index != null) {
      barcode = inventory[index].barcode;
      name = inventory[index].name;
    }
    var update = ItemUpdate(
      name: name,
      barcode: barcode,
      method: 1,
      methodName: "decrease",
      timestamp: DateTime.now().millisecondsSinceEpoch
    );
    applyUpdate(update);
  }

  void add(Item item) {
    if (!_inventoryMap.containsKey(item.identifier)) {
      _inventoryMap[item.identifier] = item;
      _inventory.add(item);
      _inventory.sort();
      _changedCallback?.call();
    }
  }

  Future<Item> operator [](dynamic index) async {
    if (index is int) {
      return inventory[index];
    }
    if (index is String) {
      return _inventoryMap[index];
    }
    throw TypeError();
  }

  int get length {
    return inventory.length;
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
