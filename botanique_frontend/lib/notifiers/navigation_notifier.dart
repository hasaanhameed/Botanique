import 'package:flutter/material.dart';

class NavigationNotifier {
  final ValueNotifier<int> currentIndex = ValueNotifier(0);

  void changePage(int index){
    currentIndex.value = index;
  }
}