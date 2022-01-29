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

# Intro

Modddels are "validated" objects that can have two states : *Valid* or *Invalid*.

Depending on the modddel, there are different types of validations, which are run in a specific order. If all the validations pass, then the modddel is *Valid*. Otherwise, it is *Invalid* and holds a failure. The *Invalid* state is further subdivided into multiple states, each one corresponding to a failed validation.

The different states a Modddel can have are represented with **Union Cases Classes**. This allows to deal with the different states of the Modddel in a compile-safe way, making impossible states impossible.

# Table of contents

- [Intro](#intro)
- [Table of contents](#table-of-contents)
- [Features](#features)
- [Getting started](#getting-started)
- [Usage](#usage)
	- [ValueObject](#valueobject)
		- [Usage](#usage-1)
		- [NullableValueObject](#nullablevalueobject)
	- [SimpleEntity](#simpleentity)
		- [Usage](#usage-2)
		- [The valid annotation](#the-valid-annotation)
	- [ListEntity](#listentity)
		- [Usage](#usage-3)
	- [SizedListEntity](#sizedlistentity)
		- [Usage](#usage-4)
	- [GeneralEntity](#generalentity)
		- [Usage](#usage-5)
		- [Fields getters](#fields-getters)
		- [The `valid` annotation](#the-valid-annotation-1)
		- [The `InvalidNull` annotation](#the-invalidnull-annotation)
	- [ListGeneralEntity](#listgeneralentity)
		- [Usage](#usage-6)
	- [SizedListGeneralEntity](#sizedlistgeneralentity)
		- [Usage](#usage-7)
	- [Additionnal remarks](#additionnal-remarks)
		- [Optional and Nullable types](#optional-and-nullable-types)
		- [Modddels that are always valid](#modddels-that-are-always-valid)
		- [List getter](#list-getter)
- [VsCode snippets](#vscode-snippets)
- [Additional information](#additional-information)

# Features

Available modddels :

- ValueObject
- Entities
  - SimpleEntity
  - ListEntity
  - SizedListEntity
  - GeneralEntity
  - ListGeneralEntity
  - SizedListGeneralEntity

# Getting started

You should have these packages installed :

- fpdart
- freezed

# Usage

## ValueObject

A ValueObject is a Modddel that holds a single value, which is validated via the `validateValue` method. This method returns `some` `ValueFailure` if the value is invalid, otherwise returns `none`.

When creating the ValueObject, the validation is made in this order :

1. **Value Validation** : If the value is invalid, this ValueObject becomes an `InvalidValueObject` that holds the `ValueFailure`.
2. **→ Validations passed** : This ValueObject is valid, and becomes a `ValidValueObject`.
  
### Usage

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
	Option<NameValueFailure> validateValue(String input) {
		// TODO: implement validateValue
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

4. Implement the `validateValue` method :

	```dart
	@override
	Option<NameValueFailure> validateValue(String input) {
		if (input.isEmpty) {
			return some(NameValueFailure.empty(failedValue: input));
		}
		return none();
	}
	```

5. Run the generator

### NullableValueObject

If your ValueObject holds a nullable value that you want to be non-nullable in the `ValidValueObject`, then you should use instead a `NullableValueObject`.

Example :

```dart
@modddel
class Name2 extends NullableValueObject<String, Name2ValueFailure, InvalidName2,
    ValidName2> with $Name2 {
  factory Name2(String? input) {
    return $Name2._create(input);
  }

  const Name2._();

  @override
  Option<Name2ValueFailure> validateValue(String input) {
    ...
  }

  @override
  Name2ValueFailure nullFailure() {
    return const Name2ValueFailure.none(failedValue: null);
  }
}

@freezed
class Name2ValueFailure extends ValueFailure<String?> with _$Name2ValueFailure {
  const factory Name2ValueFailure.none({
    required String? failedValue,
  }) = _None;
}

```

Here, if the value is null, then the ValueObject will be an `InvalidValueObject` with a value failure `Name2ValueFailure.none`.

>**NB :** This null verification is done just before the `validateValue` method is called. So the value passed in the `validateValue` method will be non-nullable.

---

## SimpleEntity

A `SimpleEntity` is a modddel that holds multiple modddels (ValueObjects, Entities...).

When creating a SimpleEntity, the validation is made in this order :

1. **Content Validation** : If any of its modddels is invalid, then this `SimpleEntity` becomes an `InvalidEntityContent` that holds the `contentFailure` (which is the failure of the first encountered invalid modddel).
2. **→ Validations passed** : The entity is valid, and becomes a `ValidEntity` that holds the valid version of its modddels.

### Usage

1. Create a SimpleEntity, and annotate it with `@modddel`

	```dart
	@modddel
	class FullName extends SimpleEntity<InvalidFullNameContent, ValidFullName> with $FullName {
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

Sometimes, you want a `SimpleEntity` to contain a modddel that is always valid, or a parameter that isn't a modddel and that should considered as being valid. For example : a ValidValueObject, a ValidEntity, a boolean...

In that case, you can annotate it with `@valid`. Example :

```dart
factory FullName({
    required Name firstName,
    required Name lastName,
    @valid required bool hasMiddleName,
  }) { ...
```

## ListEntity

A ListEntity is similar to a `SimpleEntity` in a sense that it holds a List of other modddels (of the same type).

When creating a ListEntity, the validation is made in this order :

1. **Content validation** : If any of the modddels is invalid, then this ListEntity becomes an `InvalidEntityContent` that holds the `contentFailure` (which is the failure of the first encountered invalid modddel).
2. **→ Validations passed** : This ListEntity is valid, and becomes a `ValidEntity` that holds the valid version of its modddels.

> **NB:** When empty, the ListEntity is considered valid. If you want a different behaviour, consider using a `SizedListEntity` and providing your own size validation.

### Usage

1. Create a ListEntity, and annotate it with `@modddel`

	```dart
	@modddel
	class NameList extends ListEntity<InvalidNameListContent, ValidNameList> with $NameList {
		factory NameList(KtList<Name> list) {
			return $NameList._create(list);
		}

		const NameList._();
	}
	```

2. Add the part statement

	```dart
	part 'namelist.g.dart';
	```

3. Run the generator

## SizedListEntity

A SizedListEntity is similar to a `ListEntity`, but its size is validated via the `validateSize` method. This method returns `some` `SizeFailure` if the size is invalid, otherwise returns `none`.

When creating a SizedListEntity, the validation is made in this order :

1. **Size validation** : If the size is invalid, then this SizedListEntity becomes an `InvalidEntitySize` that holds the `sizeFailure`.
2. **Content validation** : If any of the modddels is invalid, then this SizedListEntity becomes an `InvalidEntityContent` that holds the `contentFailure` (which is the failure of the first encountered invalid modddel).
3. **→ Validations passed** : This SizedListEntity is valid, and becomes a `ValidEntity` that holds the valid version of its modddels.

### Usage

1. Create a SizedListEntity, and annotate it with `@modddel`

	```dart
	@modddel
	class NameList extends SizedListEntity<NameListSizeFailure,InvalidNameList, ValidNameList> with $NameList {
		factory NameList(KtList<Name> list) {
			return $NameList._create(list);
		}

		const NameList._();

		@override
		Option<NameListSizeFailure> validateSize(int listSize) {
			//TODO Implement validateSize
			return none();
		}
	}
	```

2. Create a Freezed SizeFailure for your entity

	```dart
	@freezed
	class NameListSizeFailure extends SizeFailure with _$NameListSizeFailure {
		const factory NameListSizeFailure.empty() = _Empty;
	}
	```

3. Add the part statements

	```dart
	part 'namelist.g.dart';
	part 'namelist.freezed.dart';
	```

4. Implement the `validateSize` method :

	```dart
	@override
	Option<NameListSizeFailure> validateSize(int listSize) {
		if (listSize == 0) {
		return some(const NameListSizeFailure.empty());
		}
		return none();
	}
	```

5. Run the generator

---

## GeneralEntity

A GeneralEntity is similar to an `SimpleEntity`, but it provides an extra validation step at the end that validates the entity as a whole, via the `validateGeneral` method. This method returns `some` `GeneralFailure` if the entity isn't valid as a whole, otherwise returns `none`.

When creating a GeneralEntity, the validation is made in this order :

1. **Content validation** : If any of the modddels is invalid, then this GeneralEntity becomes an `InvalidEntityContent` that holds the `contentFailure` (which is the failure of the first encountered invalid modddel).
2. **General validation** : If this GeneralEntity is invalid as a whole, then it becomes an `InvalidEntityGeneral` that holds the `GeneralFailure`.
3. **→ Validations passed** : This GeneralEntity is valid, and becomes a `ValidEntity` that holds the valid version of its modddels.

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
		// TODO: implement validateGeneral
		return none();
	}
	}
	```

2. Create a Freezed GeneralFailure for your entity

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

4. Implement the `validateGeneral` method :

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

Unlike a SimpleEntity, the GeneralEntity hides its modddels inside `ValidEntity` and `InvalidEntity`, so you can only access them after calling the "mapValidity" method (or other pattern matching methods).

For example :

```dart
  final firstName = fullName.firstName;
  //ERROR : The getter 'firstName' isn't defined for the type 'FullName'.

  final firstName = fullName.mapValidity(
      valid: (valid) => valid.firstName,
      invalid: (invalid) => invalid.firstName);
  //No error.
```

That's because the GeneralEntity may have a `GeneralFailure`, which otherwise may be unnoticed by you the developer.

Nonetheless, if you want to have a direct getter for a field from the unvalidated GeneralEntity, you can use the @withGetter annotation.
A good usecase for this would be for an "id" field.

### The `valid` annotation

You can use the `@valid` annotation as you would with a `SimpleEntity`.

If you want to use both `@valid` and `@withGetter` annotation, you can use the shorthand `@validWithGetter` annotation.

### The `InvalidNull` annotation

If your entity contains a nullable modddel that you want to be non-nullable in the `ValidEntity`, then you should use the `@InvalidNull` annotation.

Example :

```dart
class FullName extends GeneralEntity<FullNameGeneralFailure, InvalidFullName,
    ValidFullName> with $FullName {
  factory FullName({
    @InvalidNull('const FullNameGeneralFailure.incomplete()')
        required Name? lastName,
    ...
  }) {
    ...

```

Here, if the field `lastName` is null, then the FullName entity will be an `InvalidEntityGeneral`, with as a general failure `FullNameGeneralFailure.incomplete()`.

>**NB :** This validation step of nullable fields marked with the `@InvalidNull` annotation occurs just before the `validateGeneral` method is called. So the entity passed in the `validateGeneral` method will have those fields non-nullable.
>
>**NB :** You can use the `@InvalidNull` annotation with any other annotation.

## ListGeneralEntity

A ListGeneralEntity is the `GeneralEntity` version of a `ListEntity` : It provides an extra validation step at the end that validates the entity as a whole, via the `validateGeneral` method. This method returns `some` `GeneralFailure` if the entity isn't valid as a whole, otherwise returns `none`.

When creating a ListGeneralEntity, the validation is made in this order :

1. **Content validation** : If any of the modddels is invalid, then this ListGeneralEntity becomes an `InvalidEntityContent` that holds the `contentFailure` (which is the failure of the first encountered invalid modddel).
2. **General validation** : If this ListGeneralEntity is invalid as a whole, then it becomes an `InvalidEntityGeneral` that holds the `GeneralFailure`.
3. **→ Validations passed** : This ListGeneralEntity is valid, and becomes a `ValidEntity` that holds the valid version of its modddels.

### Usage

1. Create a ListGeneralEntity, and annotate it with `@modddel`

	```dart
	@modddel
	class NameList extends ListGeneralEntity<NameListGeneralFailure,
		InvalidNameList, ValidNameList> with $NameList {
		factory NameList(KtList<Name> list) {
			return $NameList._create(list);
		}

		const NameList._();

		@override
		Option<NameListGeneralFailure> validateGeneral(ValidNameList valid) {
			//TODO Implement validateGeneral
			return none();
		}
	}
	```

2. Create a Freezed GeneralFailure for your entity

	```dart
	@freezed
	class NameListGeneralFailure extends GeneralFailure
		with _$NameListGeneralFailure {
	const factory NameListGeneralFailure.duplicateName() = _DuplicateName;
	}
	```

3. Add the part statements

	```dart
	part 'namelist.g.dart';
	part 'namelist.freezed.dart';
	```

4. Implement the `validateGeneral` method :

	```dart
	@override
	Option<NameListGeneralFailure> validateGeneral(ValidNameList valid) {
		if (valid.list.distinct().size != valid.size) {
			return some(const NameListGeneralFailure.duplicateName());
		}
		return none();
	}
	```

5. Run the generator

## SizedListGeneralEntity

A SizedListGeneralEntity is similar to a `ListGeneralEntity`, but its size is validated via the `validateSize` method. This method returns `some` `SizeFailure` if the size is invalid, otherwise returns `none`.

When creating a SizedListGeneralEntity, the validation is made in this order :

1. **Size validation** : If the size is invalid, then this SizedListGeneralEntity becomes an `InvalidEntitySize`.
2. **Content validation** : If any of the modddels is invalid, then this SizedListGeneralEntity becomes an `InvalidEntityContent` that holds the `contentFailure` (which is the failure of the first encountered invalid modddel).
3. **General validation** : If this SizedListGeneralEntity is invalid as a whole, then it becomes an `InvalidEntityGeneral` that holds the `GeneralFailure`.
4. **→ Validations passed** : This SizedListGeneralEntity is valid, and becomes a `ValidEntity` that holds the valid version of its modddels.

> **NB :** You may notice that the **Size validation** occurs first, before the **Content validation**. This is so that no matter if this modddel's content is valid or not, if its size is invalid, it becomes an `InvalidEntitySize` holding a `SizeFailure`.
>
> If you want the size to be validated only if all the modddels are valid, you can do so in the **General validation** step, so that the size is validated last. In that case, if the size is invalid, then this modddel becomes an `InvalidEntityGeneral` holding a `GeneralFailure`.

### Usage

1. Create a SizedListGeneralEntity, and annotate it with `@modddel`

	```dart
	@modddel
	class NameList extends SizedListGeneralEntity<NameListSizeFailure, NameListGeneralFailure,
	InvalidNameList, ValidNameList> with $NameList {
		factory NameList(KtList<> list) {
			return $NameList._create(list);
		}

		const NameList._();

		@override
		Option<NameListSizeFailure> validateSize(int listSize) {
			//TODO Implement validateSize
			return none();
		}

		@override
		Option<NameListGeneralFailure> validateGeneral(ValidNameList valid) {
			//TODO Implement validateGeneral
			return none();
		}
	}
	```

2. Create a Freezed SizeFailure for your entity

	```dart
	@freezed
	class NameListSizeFailure extends SizeFailure with _$NameListSizeFailure {
		const factory NameListSizeFailure.empty() = _Empty;
	}
	```

3. Create a Freezed GeneralFailure for your entity

	```dart
	@freezed
	class NameListGeneralFailure extends GeneralFailure
		with _$NameListGeneralFailure {
	const factory NameListGeneralFailure.duplicateName() = _DuplicateName;
	}
	```

4. Add the part statements

	```dart
	part 'namelist.g.dart';
	part 'namelist.freezed.dart';
	```

5. Implement the `validateSize` method :

	```dart
	@override
	Option<NameListSizeFailure> validateSize(int listSize) {
		if (listSize == 0) {
			return some(const NameListSizeFailure.empty());
		}
		return none();
	}
	```

6. Implement the `validateGeneral` method :

	```dart
	@override
	Option<NameListGeneralFailure> validateGeneral(ValidNameList valid) {
		if (valid.list.distinct().size != valid.size) {
			return some(const NameListGeneralFailure.duplicateName());
		}
		return none();
	}
	```

7. Run the generator

---

## Additionnal remarks

### Optional and Nullable types

`SimpleEntity` and `GeneralEntity` both support containing optional and nullable parameters, as well as default values.

### Modddels that are always valid

You can create a ValidValueObject or a ValidEntity by directly extending respectively the class `ValidValueObject` or `ValidEntity`.

When using them as parameters inside a `SimpleEntity` or `GeneralEntity`, don't forget to annotate them with `@valid`.

### List getter

Unlike a ListEntity, ListGeneralEntity, SizedListEntity, and SizedListGeneralEntity hide the list inside `ValidEntity` and `InvalidEntity`, so you can only access it after calling the "mapValidity" method (or other pattern matching methods).

For example :

```dart
  final names = nameList.list;
  //ERROR : The getter 'list' isn't defined for the type 'NameList'.

  final names = nameList.mapValidity(
      valid: (valid) => valid.list,
      invalid: (invalid) => invalid.list);
  //No error.
```

That's because the entity may have a `GeneralFailure` or a `SizeFailure`, which otherwise may be unnoticed by you the developer.

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
			"  Option<${1}ValueFailure> validateValue(${2} input) {",
			"    //TODO Implement validateValue",
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
	"Simple Entity": {
		"prefix": "simpleentity",
		"body": [
			"@modddel",
			"class ${1} extends SimpleEntity<Invalid${1}Content, Valid${1}> with $${1} {",
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
		"description": "Simple Entity"
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
	"General Failure": {
		"prefix": "generalfailure",
		"body": [
			"@freezed",
			"class ${1}GeneralFailure extends GeneralFailure with _$${1}GeneralFailure {",
			"  const factory ${1}GeneralFailure.${2}(${4}) = _${3};",
			"}"
		],
		"description": "General Failure"
	},
	"General Failure Union Case": {
		"prefix": "generalfailurecase",
		"body": [
			"const factory ${1}GeneralFailure.${2}(${4}) = _${3};",
		],
		"description": "General Failure Union Case"
	},
	"Size Failure": {
		"prefix": "sizefailure",
		"body": [
			"@freezed",
			"class ${1}SizeFailure extends SizeFailure with _$${1}SizeFailure {",
			"  const factory ${1}SizeFailure.${2}(${4}) = _${3};",
			"}"
		],
		"description": "Size Failure"
	},
	"Size Failure Union Case": {
		"prefix": "sizefailurecase",
		"body": [
			"const factory ${1}SizeFailure.${2}(${4}) = _${3};",
		],
		"description": "Size Failure Union Case"
	},
}
```

# Additional information

TODO: Tell users more about the package: where to find more information, how to contribute to the package, how to file issues, what response they can expect from the package authors, and more.
