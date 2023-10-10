import 'package:flutter/foundation.dart';

class HomeFavProvider extends ChangeNotifier {
  bool _isFavourite = false;
  List<int> _favList = [];

  bool get isFavourite => _isFavourite;
  List get favList => _favList;

  void homeFavValue(bool isFav, int id) {
    _isFavourite = isFav;
    notifyListeners();
  }

  void checkFavorite(int id) {
    _favList.add(id);
    notifyListeners();
  }

  void removeFavorite(int id) {
    _favList.remove(id);
    notifyListeners();
  }
}
