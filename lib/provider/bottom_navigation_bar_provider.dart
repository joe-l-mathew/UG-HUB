import 'package:flutter/cupertino.dart';

class BottomNavigationBarProvider with ChangeNotifier {
  int _pageNo = 0;
  set setPage(int page) {
    _pageNo = page;
    notifyListeners();
  }

  int get getPage {
    return _pageNo;
  }
}
