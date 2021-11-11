import 'package:flutter/material.dart';

class StateNode<T> {
  late T value;
  late final void Function(T) setValue;

  StateNode(T initialValue, StateSetter setState) {
    value = initialValue;
    setValue = (T newValue) {
      setState(() => value = newValue);
    };
  }
}
