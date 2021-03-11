// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:auto_ide/src/common/cyclic_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:auto_ide/main.dart';

void main() {

  test('CyclicList', (){
    final list = CyclicList<int>(3);
    list.add(1);
    expect(list.length,1);
    expect(list[0],1);

    list.add(2);
    expect(list.length,2);
    expect(list[0],1);
    expect(list[1],2);

    list.add(3);
    expect(list.length,3);
    expect(list[0],1);
    expect(list[1],2);
    expect(list[2],3);

    list.add(4);
    expect(list.length,3);
    expect(list[0],2);
    expect(list[1],3);
    expect(list[2],4);
  });

}
