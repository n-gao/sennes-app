import 'package:flutter/material.dart';
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
import 'encrypt_util.dart';
import 'dart:core';

typedef void InventoryChanged();

class ItemController {
  final cryptor = PlatformStringCryptor();
  final Configuration config;
  Map<String, Item> _inventoryMap = Map();
  List<Item> _inventory = [];
  InventoryChanged _changedCallback;
  int _state = 0;

  List<Item> _safeInventory = [];
  int _safeState = -1;

  List<Item> get inventory {
    return _inventory.where((item) => item.amount > 0).toList();
  }

  bool confirmed;

  static ItemController _instance;
  static Future<ItemController> getInstance() async {
    if (_instance == null) {
      _instance = ItemController();
      await _instance.readFromStorage();
      await _instance.requestItemUpdates();
    }
    return _instance;
  }

  ItemController() : config = Configuration.getInstance();

  void restoreToSafeState() {
    _state = _safeState;
    _inventory = _safeInventory.map((i) => Item.fromJson(i.toJson())).toList();
    _inventoryMap = Map();
    _inventory.forEach((item) => _inventoryMap[item.identifier] = item);
    confirmed = true;
  }

  Future readFromStorage() async {
    final localFile = await _inventoryFile;
    try {
      final content = await localFile.readAsString();
      final stored = json.decode(content);
      _safeInventory =
          (stored['inventory'] as List).map((i) => Item.fromJson(i)).toList();
      _safeState = stored['state'] as int;
      restoreToSafeState();
      print("[Inventory] Read from storage.");
    } catch (error) {
      print("[Inventory] No storage present.");
    }
  }

  Future saveToStorage() async {
    if (!confirmed) return;
    _safeState = _state;
    _safeInventory = _inventory.map((i) => Item.fromJson(i.toJson())).toList();
    try {
      var localFile = await _inventoryFile;
      await localFile.writeAsString(
          json.encode({'inventory': _inventory, 'state': _state}));
      print("[Inventory] Saved inventory");
    } catch (e) {
      print("[Inventory] Failed to save inventory");
      throw Exception();
    }
  }

  Future requestItemUpdates() async {
    Request request = Request.getUpdates(await config.getFridgeId(), _state);
    Response response;
    try {
      response = await ServerApi.getInstance().fetchRequest(request);
    } catch (e) {
      print("[Inventory] Failed to reach server");
      return;
    }
    if (_state == response.newState) {
      return;
    }
    restoreToSafeState();
    var key = await config.getEncryptionKey();
    for (var update in response.updates) {
      var decrypted = decrypt(update, key);
      var updateJson = json.decode(decrypted);
      var itemUpdate = ItemUpdate.fromJson(updateJson);
      _applyUpdate(itemUpdate);
    }
    print("[Inventory] Updated state from " +
        _state.toString() +
        " to " +
        response.newState.toString());
    _state = response.newState;
    _changedCallback?.call();
    await saveToStorage();
  }

  Future requestItemInfos(List<Item> items) async {
    Request request =
        Request.barcodeInfo(items.map((item) => item.barcode).toList());
    Response response = await ServerApi.getInstance().fetchRequest(request);
    for (var i = 0; i < items.length; i++) {
      items[i].updateInfo(response.barcodeInfo[i]['info']);
    }
    _changedCallback?.call();
    saveToStorage();
  }

  Future uploadUpdate(ItemUpdate update) async {
    final key = await config.getEncryptionKey();
    final updateS = json.encode(update);
    final blob = encrypt(updateS, key);
    final fridgeId = await config.getFridgeId();
    await ServerApi.getInstance().fetchRequest(
        Request.addUpdate(fridgeId, Uri.encodeQueryComponent(blob)));
  }

  void applyUpdate(ItemUpdate update) {
    confirmed = false;
    _applyUpdate(update);
    uploadUpdate(update);
    _changedCallback?.call();
  }

  void _applyUpdate(ItemUpdate update) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(update.timestamp);
    if (_inventoryMap.containsKey(update.identifier)) {
      _inventoryMap[update.identifier].amount += update.method == 0 ? 1 : -1;
      _inventoryMap[update.identifier].changed.add(time);
    } else {
      add(Item(barcode: update.barcode, name: update.name, changed: [time]));
    }
  }

  void setChangedCallback(InventoryChanged callback) {
    this._changedCallback = callback;
  }

  void increase({String barcode, String name, int index}) {
    if (barcode == null && name == null && index != null) {
      barcode = inventory[index].barcode;
      name = inventory[index].name;
    }
    var update = ItemUpdate(
        name: name,
        barcode: barcode,
        method: 0,
        methodName: "increase",
        timestamp: DateTime.now().millisecondsSinceEpoch);
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
        timestamp: DateTime.now().millisecondsSinceEpoch);
    applyUpdate(update);
  }

  void add(Item item) {
    if (!_inventoryMap.containsKey(item.identifier)) {
      _inventoryMap[item.identifier] = item;
      _inventory.add(item);
      _inventory.sort();
    }
  }

  Item operator [](dynamic index) {
    try {
      if (index is int) {
        return inventory[index];
      }
      if (index is String) {
        return _inventoryMap[index];
      }
    } catch (e) {}
    return null;
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
    final fridgeId = await config.getFridgeId();
    return File('$path/inventory_$fridgeId.json');
  }
}

class ItemListModel {
  final ItemController controller;
  final GlobalKey<AnimatedListState> listKey;
  final dynamic removedItemBuilder;
  List<Item> inventoryCopy;

  ItemListModel(this.controller, this.listKey, this.removedItemBuilder) {
    inventoryCopy = List<Item>.from(controller.inventory);
    controller.setChangedCallback(_updateAnimatedList);
  }

  void _updateAnimatedList() {
    var newCpy = controller.inventory;
    var added = List<Item>.from(newCpy);
    added.removeWhere((item) => inventoryCopy.contains(item));
    var removed = List<Item>.from(inventoryCopy);
    removed.removeWhere((item) => newCpy.contains(item));
    var oldCpy = inventoryCopy;
    removed.forEach((item) {
      var index = oldCpy.indexOf(item);
      oldCpy.remove(item);
      _animatedList?.removeItem(index, (context, animation) {
        return removedItemBuilder(item, context, animation);
      });
    });
    inventoryCopy = newCpy;
    added.forEach((item) {
      _animatedList?.insertItem(newCpy.indexOf(item));
    });
  }

  AnimatedListState get _animatedList => listKey.currentState;

  int get length => inventoryCopy.length;

  Item operator [](int index) => inventoryCopy[index];

  int indexOf(Item item) => inventoryCopy.indexOf(item);
}
