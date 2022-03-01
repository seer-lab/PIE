import 'package:flutter/material.dart';

enum DesignPattern {
  flyweight,
  strategy,
  bridge,
  decorator,
  composite,
  facade,
  proxy,
  mediator,
  na
}

extension ParseToString on DesignPattern {
  String parseString() {
    String value = toString().split('.')[1];
    return "${value[0].toUpperCase()}${value.substring(1)}";
  }
}

extension ToColour on DesignPattern {
  Color toColour() {
    final Map<DesignPattern, Color> colourMapping = {
      DesignPattern.flyweight: Colors.amber.shade400,
      DesignPattern.strategy: Colors.blue.shade400,
      DesignPattern.bridge: Colors.green.shade400,
      DesignPattern.composite: Colors.red.shade400,
      DesignPattern.decorator: Colors.indigo.shade400,
      DesignPattern.mediator: Colors.purple.shade400,
      DesignPattern.facade: Colors.teal.shade400,
      DesignPattern.proxy: Colors.orange.shade400,
      DesignPattern.na: Colors.grey.shade400
    };
    if (!colourMapping.containsKey(DesignPattern.values[index])) {
      return Colors.grey;
    }
    return colourMapping[DesignPattern.values[index]]!;
  }
}

DesignPattern stringToDP(String value) {
  const Map<String, DesignPattern> mapping = {
    "Flyweight": DesignPattern.flyweight,
    "Strategy": DesignPattern.strategy,
    "Bridge": DesignPattern.bridge,
    "Decorator": DesignPattern.decorator,
    "Composite": DesignPattern.composite,
    "Facade": DesignPattern.facade,
    "Proxy": DesignPattern.proxy,
    "Mediator": DesignPattern.mediator
  };
  if (mapping.containsKey(value)) {
    return mapping[value]!;
  }
  return DesignPattern.na;
}
