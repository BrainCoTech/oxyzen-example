import 'package:flutter/foundation.dart';

class SafeChangeNotifier extends ChangeNotifier {
  @override
  void notifyListeners() {
    /// _listeners == null
    try {
      super.notifyListeners();
    } catch (e) {
      //print(e);
    }
  }
}
