import 'package:flutter/foundation.dart';

class Categories with ChangeNotifier {
  final String categoryId;
  final String categoryName;
  final DateTime dateTime;
  Categories({this.categoryId, this.categoryName, this.dateTime});
}
