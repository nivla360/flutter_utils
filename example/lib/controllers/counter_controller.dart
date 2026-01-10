import 'package:flutter_utils/flutter_utils.dart';

/// Simple counter controller demonstrating basic RootController usage
class CounterController extends RootController {
  int _count = 0;
  
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners();
  }
  
  void decrement() {
    _count--;
    notifyListeners();
  }
  
  void reset() {
    _count = 0;
    notifyListeners();
  }
  
  void setCount(int value) {
    _count = value;
    notifyListeners();
  }
  
  void multiplyBy(int multiplier) {
    _count *= multiplier;
    notifyListeners();
  }
  
  bool get isEven => _count % 2 == 0;
  bool get isPositive => _count > 0;
  bool get isNegative => _count < 0;
  bool get isZero => _count == 0;
}