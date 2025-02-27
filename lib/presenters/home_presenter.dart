import 'package:djibly/pages/home/tabs/home_tab/home_tab.dart';
import 'package:djibly/pages/home/tabs/notifications_tab/notification_tab.dart';
import 'package:flutter/material.dart';

class HomePresenter with ChangeNotifier {

  static const AD_CAROUSEL_CODE = 'carousel';

  int _selectedTab = 0;

  int getSelectedTab(){
    return _selectedTab;
  }

  void setSelectedTab(int index){
    _selectedTab = index;
    notifyListeners();
  }

  void setSelectedTabByTagName(String tag){
    switch (tag){
      case HomeTab.Tag :
        _selectedTab = 0;
        notifyListeners();
        break;
      case NotificationTab.Tag:
        _selectedTab = 1;
        notifyListeners();
        break;
      default:
        break;
    }
  }
}
