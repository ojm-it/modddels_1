<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

# Features
Available modddels :

- ValueObject
- Entity 
- ListEntity
- GeneralEntity
- ListGeneralEntity

# Getting started

You should have these packages installed :
- fpdart
- freezed

# Usage

## Value object :

1. Create a ValueObject, and annotate it with `@modddel`

```dart
@modddel
class Name extends ValueObject<String, NameValueFailure, InvalidName, ValidName>
    with $Name {
  factory Name(String input) {
    return $Name._create(input);
  }

  const Name._();

  @override
  Option<NameValueFailure> validate(String input) {
    // TODO: implement validate
    return none();
  }
}
```

2. Create a Freezed ValueFailure for your ValueObject

```dart
@freezed
class NameValueFailure extends ValueFailure<String> with _$NameValueFailure {
  const factory NameValueFailure.empty({
    required String failedValue,
  }) = _Empty;
}
```

3. Add the part statements

```dart
part 'name.g.dart';
part 'name.freezed.dart';
```

4. Implement the `validate` method :

```dart
  @override
  Option<NameValueFailure> validate(String input) {
    if (input.isEmpty) {
        return some(NameValueFailure.empty(failedValue: input));
    }
    return none();
  }
```

5. Run the generator

## Entity :
An `Entity` is a modddel that holds multiple modddels (ValueObjects, Entities...).

 - If any of its moddels is invalid, then the whole entity is Invalid. (It becomes an `InvalidEntityContent`).

 - If all the modddels are valid, then the entity is valid (It becomes a `ValidEntity`).

### Usage :

1. Create an Entity, and annotate it with `@modddel`

```dart
@modddel
class FullName extends Entity<InvalidFullNameContent, ValidFullName> with $FullName {
  factory FullName({
    required Name firstName,
    required Name lastName,
  }) {
    return $FullName._create(
      firstName: firstName,
      lastName: lastName,
    );
  }

  const FullName._();
}
```

2. Add the part statement

```dart
part 'fullname.g.dart';
```

3. Run the generator

### The valid annotation

Sometimes, you want an entity to contain a modddel that is always valid, or a parameter that isn't a modddel and that should considered as being valid. For example : a ValidValueObject, a ValidEntity, a boolean...

In that case, you can annotate it with `@valid`. Example :

```dart
factory FullName({
    required Name firstName,
    required Name lastName,
    @valid required bool hasMiddleName,
  }) { ...
```

### ListEntity
A ListEntity is similar to an Entity in a sense that it holds a List of other modddels (of the same type). Again :
 
 - If any of the modddels is invalid, then the whole entity is Invalid. (It becomes an `InvalidEntityContent`).

 - If all the modddels are valid, then the entity is valid (It becomes a `ValidEntity`).

NB: When empty, the ListEntity is considered valid. If you want a different behaviour, consider using a `ListGeneralEntity` and providing your own general validation.

## General Entity :

A GeneralEntity is an Entity that provides an extra validation step, that validates the whole entity as a whole.

When instantiated, it first verifies that all its modddels are valid.

 - If one of its modddels is invalid, then this `GeneralEntity` is invalid. It becomes an `InvalidEntityContent`.

 - If all the modddels are valid, then this `GeneralEntity` is validated with the
   `validateGeneral` method.

   - If it's invalid, then this `GeneralEntity` is invalid. It becomes an `InvalidEntityGeneral`.

   - If it's valid, then this `GeneralEntity` is valid (It becomes a `ValidEntity`)

### Usage

1. Create a General Entity, and annotate it with `@modddel`

```dart
@modddel
class FullName extends GeneralEntity<FullNameGeneralFailure, InvalidFullNameGeneral,
    InvalidFullNameContent, InvalidFullName, ValidFullName> with $FullName {
  factory FullName({
    required Name firstName,
    required Name lastName,
  }) {
    return $FullName._create(
      firstName: firstName,
      lastName: lastName,
    );
  }

  const FullName._();

  @override
  Option<FullNameGeneralFailure> validateGeneral(ValidFullName valid) {
    // TODO: implement validate
    return none();
  }
}
```

2. Create a Freezed GeneralFailure for your Entity

```dart
@freezed
class FullNameGeneralFailure extends GeneralFailure with _$FullNameGeneralFailure {
  const factory FullNameGeneralFailure.tooLong() = _TooLong;
}
```

3. Add the part statements

```dart
part 'fullname.g.dart';
part 'fullname.freezed.dart';
```

4. Implement the `validate` method :

```dart
  @override
  Option<FullNameGeneralFailure> validateGeneral(ValidFullName valid) {
    if (valid.firstName.value.length + valid.lastName.value.length > 30) {
      return some(const FullNameGeneralFailure.tooLong());
    }
    return none();
  }
```

5. Run the generator

### Fields getters

Unlike a normal Entity, the GeneralEntity hides its modddels inside `ValidEntity` and `InvalidEntity`, so you can ony access them after calling the "match" method. 
For example :

```dart
  final firstName = fullName.firstName;
  //ERROR : The getter 'firstName' isn't defined for the type 'FullName'.

  final firstName = fullName.match(
      valid: (valid) => valid.firstName,
      invalid: (invalid) => invalid.firstName);
  //No error.
```

That's because the GeneralEntity may have a `GeneralFailure`, which may be unnoticed by you the developer.

Nonetheless, if you want to have a direct getter for a field from the unvalidated GeneralEntity, you can use the @withGetter annotation.
A good usecase for this would be for an "id" field.

### The valid annotation

You can use the `@valid` annotation as you would with a normal Entity. If you want to use both `@valid` and `@withGetter` annotation, you can use the shorthand `@validWithGetter` annotation.

### ListGeneralEntity
A ListGeneralEntity is a `ListEntity` which provides an extra validation step, just like a `GeneralEntity`.

## Remarks

### Optional and Nullable types

`Entity` and `GeneralEntity` both support containing optional and nullable parameters, as well as default values.

### Modddels that are always valid

You can create a ValidValueObject or a ValidEntity by directly extending respectively the class `ValidValueObject` or `ValidEntity`.

When using them as parameters inside another Entity (or GeneralEntity), don't forget to annotate them with `@valid`.

# VsCode snippets

```json
{
	"Value Object": {
		"prefix": "valueobject",
		"body": [
			"@modddel",
			"class ${1} extends ValueObject<${2}, ${1}ValueFailure, Invalid${1}, Valid${1}>",
			"    with $${1} {",
			"  factory ${1}(${2} input) {",
			"    return $${1}._create(input);",
			"  }",
			"",
			"  const ${1}._();",
			"",
			"  @override",
			"  Option<${1}ValueFailure> validate(${2} input) {",
			"    //TODO Implement validate",
			"    return none();",
			"  }",
			"}"
		],
		"description": "Value Object"
	},
	"Value Failure": {
		"prefix": "valuefailure",
		"body": [
			"@freezed",
			"class ${1}ValueFailure extends ValueFailure<${2}> with _$${1}ValueFailure {",
			"  const factory ${1}ValueFailure.${3}({",
			"    required ${2} failedValue,${5}",
			"  }) = _${4};",
			"}"
		],
		"description": "Value Failure"
	},
	"Value Failure Union Case": {
		"prefix": "valuefailurecase",
		"body": [
			"const factory ${1}ValueFailure.${3}({",
			"  required ${2} failedValue,${5}",
			"}) = _${4};",
		],
		"description": "Value Failure Union Case"
	},
	"Entity": {
		"prefix": "entity",
		"body": [
			"@modddel",
			"class ${1} extends Entity<Invalid${1}Content, Valid${1}> with $${1} {",
			"  factory ${1}({",
			"    ${2}",
			"  }) {",
			"    return $${1}._create(",
			"      ${3}",
			"    );",
			"  }",
			"",
			"  const ${1}._();",
			"",
			"}",
		],
		"description": "Entity"
	},
	"List Entity": {
		"prefix": "listentity",
		"body": [
			"@modddel",
			"class ${1} extends ListEntity<Invalid${1}Content, Valid${1}> with $${1} {",
			"  factory ${1}(KtList<${2}> list) {",
			"    return $${1}._create(list);",
			"  }",
			"",
			"  const ${1}._();",
			"",
			"}",
		],
		"description": "List Entity"
	},
	"Sized List Entity": {
		"prefix": "sizedlistentity",
		"body": [
			"@modddel",
			"class ${1} extends SizedListEntity<${1}SizeFailure, Invalid${1},",
			" Valid${1}> with $${1} {",
			"  factory ${1}(KtList<${2}> list) {",
			"    return $${1}._create(list);",
			"  }",
			"",
			"  const ${1}._();",
			"",
			"  @override",
			"  Option<${1}SizeFailure> validateSize(int listSize) {",
			"    //TODO Implement validateSize",
			"    return none();",
			"  }",
			"}",
		],
		"description": "Sized List Entity"
	},
	"General Entity": {
		"prefix": "generalentity",
		"body": [
			"@modddel",
			"class ${1} extends GeneralEntity<${1}GeneralFailure,",
			"    Invalid${1}, Valid${1}> with $${1} {",
			"  factory ${1}({",
			"    ${2}",
			"  }) {",
			"    return $${1}._create(",
			"      ${3}",
			"    );",
			"  }",
			"",
			"  const ${1}._();",
			"",
			"  @override",
			"  Option<${1}GeneralFailure> validateGeneral(Valid${1} valid) {",
			"    //TODO Implement validateGeneral",
			"    return none();",
			"  }",
			"}",
		],
		"description": "General Entity"
	},
	"List General Entity": {
		"prefix": "listgeneralentity",
		"body": [
			"@modddel",
			"class ${1} extends ListGeneralEntity<${1}GeneralFailure,",
			"    Invalid${1}, Valid${1}> with $${1} {",
			"  factory ${1}(KtList<${2}> list) {",
			"    return $${1}._create(list);",
			"  }",
			"",
			"  const ${1}._();",
			"",
			"  @override",
			"  Option<${1}GeneralFailure> validateGeneral(Valid${1} valid) {",
			"    //TODO Implement validateGeneral",
			"    return none();",
			"  }",
			"}",
		],
		"description": "List General Entity"
	},
	"Sized List General Entity": {
		"prefix": "sizedlistgeneralentity",
		"body": [
			"@modddel",
			"class ${1} extends SizedListGeneralEntity<${1}SizeFailure, ${1}GeneralFailure,",
			" Invalid${1}, Valid${1}> with $${1} {",
			"  factory ${1}(KtList<${2}> list) {",
			"    return $${1}._create(list);",
			"  }",
			"",
			"  const ${1}._();",
			"",
			"  @override",
			"  Option<${1}SizeFailure> validateSize(int listSize) {",
			"    //TODO Implement validateSize",
			"    return none();",
			"  }",
			"",
			"  @override",
			"  Option<${1}GeneralFailure> validateGeneral(Valid${1} valid) {",
			"    //TODO Implement validateGeneral",
			"    return none();",
			"  }",
			"}",
		],
		"description": "Sized List General Entity"
	},
	"General Entity Failure": {
		"prefix": "generalfailure",
		"body": [
			"@freezed",
			"class ${1}GeneralFailure extends GeneralFailure with _$${1}GeneralFailure {",
			"  const factory ${1}GeneralFailure.${2}(${4}) = _${3};",
			"}"
		],
		"description": "General Entity Failure"
	},
	"General Entity Failure Union Case": {
		"prefix": "generalfailurecase",
		"body": [
			"const factory ${1}GeneralFailure.${2}(${4}) = _${3};",
		],
		"description": "Value Failure Union Case"
	},
}
```


# Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
