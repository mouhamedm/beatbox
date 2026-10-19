import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test BoxDecoration uniform border', () {
    expect(() {
      BoxDecoration(
        color: const Color(0xFF22040D),
        borderRadius: BorderRadius.circular(20),
        border: const Border(
          left: BorderSide(color: Colors.white, width: 0.8),
          right: BorderSide(color: Colors.white, width: 0.8),
          bottom: BorderSide(color: Colors.white, width: 0.8),
          top: BorderSide.none,
        ),
      );
    }, throwsAssertionError);
  });
}
