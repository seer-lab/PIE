enum DesignPattern {
  flyweight,
  strategy,
  bridge,
  decorator,
  composite,
  facade,
  na
}

extension ParseToString on DesignPattern {
  String parseString() {
    String value = toString().split('.')[1];
    return "${value[0].toUpperCase()}${value.substring(1)}";
  }
}

DesignPattern stringToDP(String value) {
  const Map<String, DesignPattern> mapping = {
    "Flyweight": DesignPattern.flyweight,
    "Strategy": DesignPattern.strategy,
    "Bridge": DesignPattern.bridge,
    "Decorator": DesignPattern.decorator,
    "Composite": DesignPattern.composite,
    "Facade": DesignPattern.facade
  };
  if (mapping.containsKey(value)) {
    return mapping[value]!;
  }
  return DesignPattern.na;
}
