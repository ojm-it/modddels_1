class ValueObjectClassInfo {
  ValueObjectClassInfo(this.valueTypeName, String className) {
    valueFailureName = '${className}ValueFailure';
    invalidValueObjectName = 'Invalid$className';
    validValueObjectName = 'Valid$className';
  }

  final String valueTypeName;
  late final String valueFailureName;
  late final String invalidValueObjectName;
  late final String validValueObjectName;
}
