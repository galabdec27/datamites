import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  String search_query = '';
  bool latestSelected = false;

  bool _refreshReferral = false;

  set setRefreshReferral(bool toset){
    _refreshReferral = toset;
    notifyListeners();
  }
  bool get refreshReferral => _refreshReferral;
  bool get _latestSelected => _latestSelected;

  set set_latestSelected(bool latesetSelected) {
    latestSelected = latesetSelected;
    if (kDebugMode) {
      print(latesetSelected);
    }
    notifyListeners();
  }

  set set_search_query(String searchQuery) {
    this.search_query = searchQuery;
    if (kDebugMode) {
      print(searchQuery);
    }
    notifyListeners();
  }
}
