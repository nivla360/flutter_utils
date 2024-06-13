
// Custom type notifier for int
import 'package:flutter/foundation.dart';

class IntNotifier extends ValueNotifier<int> {
  IntNotifier(int value) : super(value);

  void increment() {
    value++;
    notifyListeners();
  }

  void decrement() {
    value--;
    notifyListeners();
  }
}

// Custom type notifier for double
class DoubleNotifier extends ValueNotifier<double> {
  DoubleNotifier(double value) : super(value);

  void increment() {
    value++;
    notifyListeners();
  }

  void decrement() {
    value--;
    notifyListeners();
  }
}

// Custom type notifier for String
class StringNotifier extends ValueNotifier<String> {
  StringNotifier(String value) : super(value);

  void append(String text) {
    value += text;
    notifyListeners();
  }
}

// Custom type notifier for bool
class BoolNotifier extends ValueNotifier<bool> {
  BoolNotifier(bool value) : super(value);

  void toggle() {
    value = !value;
    notifyListeners();
  }
}

// Custom type notifier for Map
class MapNotifier<K, V> extends ValueNotifier<Map<K, V>> {
  MapNotifier(Map<K, V> value) : super(value);

  void add(K key, V newValue) {
    value[key] = newValue;
    notifyListeners();
  }

  void remove(K key) {
    value.remove(key);
    notifyListeners();
  }
}

// Custom type notifier for List
class ListNotifier<T> extends ValueNotifier<List<T>> {
  ListNotifier(List<T> value) : super(value);

  void add(T item) {
    value.add(item);
    notifyListeners();
  }

  void remove(T item) {
    value.remove(item);
    notifyListeners();
  }

  void clear() {
    value.clear();
    notifyListeners();
  }

  void addAll(Iterable<T> items){
    value.addAll(items);
    notifyListeners();
  }
}
