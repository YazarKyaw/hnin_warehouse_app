import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hnin_warehouse_app/models/http_exception.dart';
import 'package:hnin_warehouse_app/providers/category.dart';
import 'package:hnin_warehouse_app/providers/item.dart';

import 'package:http/http.dart' as http;

class Items with ChangeNotifier {
  List<Item> _items = [];
  List<Item> _allItems = [];
  List<Categories> _categories = [];
  final String authToken;
  final String userId;
  Items(this.authToken, this.userId, this._allItems);
  List<Item> get items {
    return [..._items];
  }

  List<Item> get allItems {
    return [..._allItems];
  }

  List<Categories> get categories {
    return [..._categories];
  }

  List<Item> get favoriteItems {
    return _allItems.where((item) => item.isFavorite).toList();
  }

  List<Item> filterItem(String filter) {
    return _allItems.where((item) {
      return item.position == filter;
    }).toList();
  }

  List<Item> filterItemByList(String filter) {
    return _allItems.where((item) {
      return item.itemList == filter;
    }).toList();
  }

  Future<void> addItem(Item item, String categoryId) async {
    print('add');
    var url =
        "https://hninwarehouse.firebaseio.com/category/$categoryId/items.json?auth=$authToken";
    try {
      final timeStamp = DateTime.now();
      final response = await http.post(url,
          body: json.encode({
            'itemName': item.itemName,
            'itemCode': item.itemCode,
            'imageUrl': item.imageUrl,
            'description': item.description,
            'quantity': item.quantity,
            'dateTime': timeStamp.toIso8601String(),
            'creatorId': userId,
            'itemList': item.itemList,
            'position': item.position,
          }));
      final newItem = Item(
        id: json.decode(response.body)['name'],
        itemCode: item.itemCode,
        itemName: item.itemName,
        description: item.description,
        imageUrl: item.imageUrl,
        dateTime: timeStamp,
        quantity: item.quantity,
        itemList: item.itemList,
        position: item.position,
      );
      _items.add(newItem);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAndSetAllItems([bool filterByUser = false]) async {
    _allItems = [];
    await getCategoriesId();
    List<Item> loadedItems = [];
    categoryId.forEach((element) async {
      final filterString =
          filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
      var url =
          "https://hninwarehouse.firebaseio.com/category/$element/items.json?auth=$authToken&$filterString";

      try {
        final response = await http.get(url);
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        if (extractedData == null) {
          return;
        }
        url =
            'https://hninwarehouse.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
        final favoriteResponse = await http.get(url);
        final favoriteData = json.decode(favoriteResponse.body);
        extractedData.forEach((itemId, itemData) {
          loadedItems.add(
            Item(
              id: itemId,
              itemCode: itemData['itemCode'],
              itemName: itemData['itemName'],
              description: itemData['description'],
              quantity: itemData['quantity'],
              imageUrl: itemData['imageUrl'],
              position: itemData['position'],
              itemList: itemData['itemList'],
              dateTime: DateTime.parse(itemData['dateTime']),
              isFavorite:
                  favoriteData == null ? false : favoriteData[itemId] ?? false,
            ),
          );
        });
        _allItems = loadedItems;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    });
  }

  Future<void> updateItem(String id, Item item, String categoryId) async {
    print('update');
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      var url =
          "https://hninwarehouse.firebaseio.com/category/$categoryId/items/$id.json?auth=$authToken";
      await http.patch(url,
          body: json.encode({
            'itemCode': item.itemCode,
            'itemName': item.itemName,
            'description': item.description,
            'quantity': item.quantity,
            'imageUrl': item.imageUrl,
            'position': item.position,
            'itemList': item.itemList,
          }));
      _items[prodIndex] = item;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Item findById(String id) {
    return _allItems.firstWhere((item) => item.id == id, orElse: () => null);
  }

  Item findByItemId(String id) {
    return _items.firstWhere((item) => item.id == id, orElse: () => null);
  }

  Future<void> fetchAndSetItems(
      {bool filterByUser = false, String itemCategoryId = ''}) async {
    _items = [];
    List<Item> loadedItems = [];
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        "https://hninwarehouse.firebaseio.com/category/$itemCategoryId/items.json?auth=$authToken&$filterString";
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((itemId, itemData) {
        loadedItems.add(
          Item(
            id: itemId,
            itemCode: itemData['itemCode'],
            itemName: itemData['itemName'],
            description: itemData['description'],
            quantity: itemData['quantity'],
            imageUrl: itemData['imageUrl'],
            position: itemData['position'],
            itemList: itemData['itemList'],
            dateTime: DateTime.parse(itemData['dateTime']),
          ),
        );
      });
      _items = loadedItems;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addCategory(String categoryName) async {
    var url =
        "https://hninwarehouse.firebaseio.com/category.json?auth=$authToken";
    try {
      final timeStamp = DateTime.now();
      final response = await http.post(url,
          body: json.encode({
            'categoryName': categoryName,
            'dateTime': timeStamp.toIso8601String(),
            'creatorId': userId,
          }));
      final newCategory = Categories(
        categoryName: categoryName,
        dateTime: timeStamp,
        categoryId: json.decode(response.body)['name'],
      );
      _categories.add(newCategory);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  List<String> categoryId = [];
  Future<void> getCategoriesId() async {
    var url =
        "https://hninwarehouse.firebaseio.com/category.json?auth=$authToken";
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      List<String> categoriesId = [];
      extractedData.forEach((categoryId, categoryData) {
        categoriesId.add(categoryId);
      });
      categoryId = categoriesId;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAndSetCategory([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        "https://hninwarehouse.firebaseio.com/category.json?auth=$authToken&$filterString";

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      List<Categories> loadedCategories = [];
      extractedData.forEach((categoryId, categoryData) {
        loadedCategories.add(Categories(
          categoryId: categoryId,
          categoryName: categoryData['categoryName'],
          dateTime: DateTime.parse(categoryData['dateTime']),
        ));
      });
      _categories = loadedCategories;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    final url =
        "https://hninwarehouse.firebaseio.com/category/$categoryId.json?auth=$authToken";
    final existingCategoryIndex =
        _categories.indexWhere((cat) => cat.categoryId == categoryId);
    var existingCategory = _categories[existingCategoryIndex];
    _categories.removeAt(existingCategoryIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _categories.insert(existingCategoryIndex, existingCategory);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingCategory = null;
  }

  Future<void> deleteItem(String categoryId, String itemId) async {
    print(categoryId);
    print(itemId);
    final url =
        "https://hninwarehouse.firebaseio.com/category/$categoryId/items/$itemId.json?auth=$authToken";
    final existingItemIndex = _items.indexWhere((item) => item.id == itemId);
    var existingItem = _items[existingItemIndex];
    _items.removeAt(existingItemIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingItemIndex, existingItem);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingItem = null;
  }
}
