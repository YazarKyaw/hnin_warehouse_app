import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Item with ChangeNotifier {
  final String id;
  final String itemCode;
  final String itemName;
  final String description;
  final int quantity;
  final String imageUrl;
  final DateTime dateTime;
  final String position;
  final String itemList;
  bool isFavorite;
  Item({
    @required this.id,
    @required this.itemCode,
    @required this.itemName,
    @required this.description,
    this.imageUrl,
    @required this.quantity,
    this.dateTime,
    this.itemList,
    this.position,
    this.isFavorite = false,
  });
  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token, String userId) async {
    final oldstatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://hninwarehouse.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldstatus);
      }
    } catch (error) {
      _setFavValue(oldstatus);
    }
  }
}
