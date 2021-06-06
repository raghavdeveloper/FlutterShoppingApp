//@dart=2.9
import 'package:flutter/cupertino.dart';

class OrderProvider with ChangeNotifier {
  String status;
  filterOrder(status) {
    this.status = status;
    notifyListeners();
  }
}
