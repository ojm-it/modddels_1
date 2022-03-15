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

Modddels are "validated" objects that can have two states : _Valid_ or _Invalid_.

Depending on the modddel, there are different types of validations, which are run in a specific order. If all the validations pass, then the modddel is _Valid_. Otherwise, it is _Invalid_ and holds a failure. The _Invalid_ state is further subdivided into multiple states, each one corresponding to a failed validation.

The different states a Modddel can have are represented with **Union Cases Classes**. This allows to deal with the different states of the Modddel in a compile-safe way, making impossible states impossible.

# Table of contents

- [Intro](#intro)
- [Table of contents](#table-of-contents)
- [Features](#features)
- [Getting started](#getting-started)
- [ValueObjects](#valueobjects)
  - [SingleValueObject](#singlevalueobject)
    - [Usage](#usage)
    - [The `NullFailure` annotation](#the-nullfailure-annotation)
  - [MultiValueObject](#multivalueobject)
    - [The `NullFailure` annotation](#the-nullfailure-annotation-1)
- [Entities](#entities)
  - [SimpleEntity](#simpleentity)
    - [Usage](#usage-1)
    - [Nullable parameters](#nullable-parameters)
    - [The `valid` annotation](#the-valid-annotation)
    - [The `invalid` annotation](#the-invalid-annotation)
  - [ListEntity](#listentity)
    - [Usage](#usage-2)
  - [SizedListEntity](#sizedlistentity)
    - [Usage](#usage-3)
  - [GeneralEntity](#generalentity)
    - [Usage](#usage-4)
    - [Fields getters](#fields-getters)
    - [The `valid` annotation](#the-valid-annotation-1)
    - [The `invalid` annotation](#the-invalid-annotation-1)
    - [The `NullFailure` annotation](#the-nullfailure-annotation-2)
  - [ListGeneralEntity](#listgeneralentity)
    - [Usage](#usage-5)
  - [SizedListGeneralEntity](#sizedlistgeneralentity)
    - [Usage](#usage-6)
  - [Remarks](#remarks)
    - [Optional and Nullable types](#optional-and-nullable-types)
    - [List getter](#list-getter)
- [Additional information](#additional-information)
  - [TypeName annotation](#typename-annotation)
  - [Sanitization](#sanitization)
  - [Asserts](#asserts)
  - [Special cases](#special-cases)
    - [Modddels that are always valid](#modddels-that-are-always-valid)
    - [Modddels that are always invalid](#modddels-that-are-always-invalid)
- [Testers](#testers)
  - [Testing Sanitization](#testing-sanitization)
- [VsCode snippets](#vscode-snippets)
- [Limitations](#limitations)

# Features

Available modddels :

- ValueObjects
  - SingleValueObject
  - MultiValueObject
- Entities
  - SimpleEntity
  - ListEntity
  - SizedListEntity
  - GeneralEntity
  - ListGeneralEntity
  - SizedListGeneralEntity

Each of these modddels has a dedicated `Tester` that makes unit tests easy and straight-forward.

# Getting started

You should have these packages installed :

- fpdart
- freezed

# ValueObjects

A `ValueObject` is a `Modddel` that holds a "value", which is validated via the `validateValue` method. This method returns `some` `ValueFailure` if the value is invalid, otherwise returns `none`.

When creating the ValueObject, the validation is made in this order :

1. **Value Validation** : If the value is invalid, this ValueObject becomes an `InvalidValueObject` that holds the `ValueFailure`.
2. **→ Validations passed** : This ValueObject is valid, and becomes a `ValidValueObject`.

## SingleValueObject

A SingleValueObject is a `ValueObject` that holds a single value.

### Usage

1. Create a SingleValueObject, and annotate it with `@modddel`

   ```dart
   @modddel
   class Name
     extends SingleValueObject<String, NameValueFailure, InvalidName, ValidName>
     with $Name {
    factory Name(String input) {
   	 return $Name._create(input);
    }

    const Name._();

    @override
    Option<NameValueFailure> validateValue(ValidName input) {
   	 // TODO: implement validateValue
   	 return none();
    }
   }
   ```

2. Create a Freezed ValueFailure for your SingleValueObject

   ```dart
   @freezed
   class NameValueFailure extends ValueFailure with _$NameValueFailure {
    const factory NameValueFailure.empty() = _Empty;
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
   Option<NameValueFailure> validateValue(ValidName input) {
     if (input.value.isEmpty) {
       return some(const NameValueFailure.empty());
     }
     return none();
   }
   ```

5. Run the generator

### The `NullFailure` annotation

Sometimes, the `SingleValueObject` may contain a nullable value that, when null, should make the `SingleValueObject` invalid. For this purpose, instead of making the check inside the `validateValue` method, you can annotate the `input` parameter with the `@NullFailure` annotation that contains the String of the `ValueFailure`. This is the recommended way, since it has the benefit of making the field non-nullable in the `ValidValueObject`.

_Example :_

```dart

@modddel
class Name
    extends SingleValueObject<String?, NameValueFailure, InvalidName, ValidName>
    with $Name {
  
  factory Name(
    @NullFailure('const NameValueFailure.none()') String? input) {
    ...

```

Here, if the value is null, then the `Name` value object will be an `InvalidValueObject`, with as a value failure `NameValueFailure.none()`. The field `value` in `ValidName` is non-nullable.

## MultiValueObject

A `MultiValueObject` is a `ValueObject` where the "value" is not represented by a single value, but rather a combination of multiple fields. Each field is valid separately, but when put together, they form a "value" that needs to be validated.

_Example :_

```dart
@modddel
class GeoPoint extends MultiValueObject<GeoPointValueFailure, InvalidGeoPoint,
    ValidGeoPoint> with $GeoPoint {
  factory GeoPoint({
    required double latitude,
    required double longitude,
  }) {
    return $GeoPoint._create(
      latitude: latitude,
      longitude: longitude,
    );
  }

  const GeoPoint._();

  @override
  Option<GeoPointValueFailure> validateValue(ValidGeoPoint valid) {
    if(latitude == 0 && longitude == 0){
      return const GeoPointValueFailure.nullIsland();
    }
    return none();
  }
}
```

In this example, a `GeoPoint` is invalid when both its `latitude` and `longitude` equal 0. Separately, the `latitude` and `longitude` fields are always valid.

Without a `MultiValueObject`, you would need to :

1. Create a Data class `GeoPointPrimitive`
2. Create a `SingleValueObject` named `GeoPoint`, which holds as a value a
   `GeoPointPrimitive`.

This would add a lot of boilerplate code, and would prevent the use of some features such as annotating a specific field with the `@NullFailure` annotation.

### The `NullFailure` annotation

Just like you would use the `@NullFailure` annotation to annotate the `input` parameter of a `SingleValueObject`, you can use it to annotate each separate parameter of a `MultiValueObject`.

_Example :_

```dart
@modddel
class Name extends MultiValueObject<NameValueFailure, InvalidName, ValidName>
    with $Name {
  factory Name({
    @NullFailure('const NameValueFailure.incomplete()')
        required String? lastName,
   ...
  }) {
    ...

```

Here, if the field `lastName` is null, then the `Name` value object will be an `InvalidValueObject`, with as a value failure `NameValueFailure.incomplete()`. The field `lastName` in `ValidName` is non-nullable.

---

# Entities

An `Entity` is a `Modddel` that holds multiple modddels (ValueObjects, Entities...).

In order to be valid, all the modddels inside the `Entity` must be valid too. This is called "Content Validation".

In addition to the "Content Validation", entities can have additionnal validations steps that can occur either before or after the "Content Validation" step.

## SimpleEntity

A `SimpleEntity` is an `Entity` that holds multiple modddels as separate fields. The only validation step is the "Content Validation", so if all the modddels are valid, the `SimpleEntity` is valid too.

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

### Nullable parameters

When a `SimpleEntity` contains a nullable modddel, when it is null, it is considered valid during the "Content Validation" step.

If you want a nullable modddel to make the Entity invalid when it's null, consider using a `GeneralEntity` and annotating the parameter with the [`@NullFailure` annotation.](#the-nullfailure-annotation)

### The `valid` annotation

Sometimes, you want a `SimpleEntity` to contain a modddel that is always valid, or a parameter that isn't a modddel and that should considered as being valid. For example : a ValidValueObject, a ValidEntity, a boolean...

In that case, you can annotate it with `@valid`. Example :

```dart
factory FullName({
    required Name firstName,
    required Name lastName,
    @valid required bool hasMiddleName,
  }) { ...
```

> **NB :** The parameters of a `SimpleEntity` can't all be annotated with `@valid`. That's because it would mean the Entity would always be valid, while fundamentally, an Entity can either be valid or invalid.
>
> For an alternative to this specific case, see [the related section in "Special Cases".](#modddels-that-are-always-valid)

### The `invalid` annotation

Sometimes, you want a `SimpleEntity` to contain a modddel that is always invalid, unless it is null. For example : an InvalidValueObject, an InvalidEntity...

In that case, you can annotate it with `@invalid`. Example :

```dart
factory FullName({
    required Name firstName,
    required Name lastName,
    @invalid @TypeName('InvalidName?') required InvalidName? middleName,
  }) { ...
```

> **NB :** The `invalid` annotation can only be used on nullable parameters. That 's because, as mentioned before, null parameters are considered valid. So a nullable parameter annotated with `@invalid` would be considered valid when it's null, and invalid when it isn't.
>
> On the other hand, a non-nullable parameter annotated with `@invalid` would always be considered invalid, which would mean the Entity would always be invalid, while fundamentally, an Entity can either be valid or invalid.
>
> For an alternative to this specific case, see [the related section in "Special Cases".](#modddels-that-are-always-invalid)

## ListEntity

A `ListEntity` is similar to a `SimpleEntity`, but the modddels are stored as a list (of the same type).

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

Nonetheless, if you want to have a direct getter for a field from the unvalidated GeneralEntity, you can use the `@withGetter` annotation.
A good usecase for this would be for an "id" field.

### The `valid` annotation

You can use the `@valid` annotation as you would with a `SimpleEntity`.

If you want to use both `@valid` and `@withGetter` annotation, you can use the shorthand `@validWithGetter` annotation.

> **NB :** The parameters of a `GeneralEntity` can't all be annotated with `@valid`. That's because it would mean the `GeneralEntity` will never be an `InvalidEntityContent`, while the code won't reflect that. This would violate the principle of making impossible states impossible.
>
> Instead, you should use a [`MultiValueObject`](#multivalueobject).

### The `invalid` annotation

You can use the `@invalid` annotation as you would with a `SimpleEntity`.

If you want to use both `@invalid` and `@withGetter` annotation, you can use the shorthand `@invalidWithGetter` annotation.

> **NB :** For the same reasons as for `SimpleEntity` [(mentioned here)](#the-invalid-annotation), the `invalid` annotation can only be used on nullable parameters.

### The `NullFailure` annotation

When a `GeneralEntity` contains a nullable modddel, when it is null, it is considered valid during the "Content Validation" step. If you want the `GeneralEntity` to be invalid when that parameter is null, you could :

- Verify if the parameter is null in the `validateGeneral` method, and if so, return a `GeneralFailure`. **(Not recommended)**
- Use the `@NullFailure` annotation with the String of the `GeneralFailure`. This is the recommended way, since it has the benefit of making the field non-nullable in the `ValidEntity`.

Example :

```dart
class FullName extends GeneralEntity<FullNameGeneralFailure, InvalidFullName,
    ValidFullName> with $FullName {
  factory FullName({
    @NullFailure('const FullNameGeneralFailure.incomplete()')
        required Name? lastName,
    ...
  }) {
    ...

```

Here, if the field `lastName` is null, then the `FullName` entity will be an `InvalidEntityGeneral`, with as a general failure `FullNameGeneralFailure.incomplete()`. The field `lastName` in `ValidFullName` is non-nullable.

> **NB 1:** This validation step of nullable fields marked with the `@NullFailure` annotation occurs just before the `validateGeneral` method is called. So the entity passed in the `validateGeneral` method will have those fields non-nullable.
>
> **NB 2:** The `@NullFailure` annotation can be used with any other annotation, except `@invalid`. That's because a nullable parameter annotated with both `@invalid` and `@NullFailure` will cause the `GeneralEntity` to never be valid, while fundamentally, an Entity can either be valid or invalid.
>
> For an alternative to this specific case, see [the related section in "Special Cases".](#modddels-that-are-always-invalid).

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

## Remarks

### Optional and Nullable types

`SimpleEntity` and `GeneralEntity` both support containing optional and nullable parameters, as well as default values.

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

# Additional information

## TypeName annotation

The types of the constructor parameter(s) of `SingleValueObject`, `MultiValueObject`, `SimpleEntity` and `GeneralEntity` need to be defined at the time of generation. If the type does not exist at the time of generation (which is usually the case when the type class itself is generated), you should manually provide it using the `@TypeName` annotation.

Example :

```dart
@modddel
class Person extends SimpleEntity<InvalidPersonContent, ValidPerson>
    with $Person {
  factory Person({
    required Age age,
    @TypeName('ValidName') @valid required ValidName validName,
  }) {
    return $Person._create(
	  age: age,
      validName: validName,
	);
  }

  const Person._();
}
```

Here, `ValidName` is a generated class so it's not defined during the generation. So we provided the type using `@TypeName('ValidName')`.

## Sanitization

The factory constructors of the modddels give you an opportunity to do all sort of data manipulation and sanitization.

_Example :_

```dart
factory Person({
    @valid required String id,
    required Name name,
  }) {
    // Your sanitization code goes here
    final sanitizedId = id.trim();

    return $Person._create(
      id: sanitizedId,
      name: name,
    );
  }
```

## Asserts

You can add your asserts inside the factory constructor of the modddel.

_Example :_

```dart
factory Person({
    @valid required String id,
    required Name name,
  }) {
    assert(id.length > 1);

    return $Person._create(
      id: sanitizedId,
      name: name,
    );
  }
```

## Special cases

There are a few special cases that you might encounter.

### Modddels that are always valid

Sometimes you may want to create a modddel that is always valid. For example :

- A `SingleValueObject` that is always valid and doesn't need validation
- A `SimpleEntity` with only `@valid` parameters [(See remark)](#the-valid-annotation)

However, modddels by definition have both a valid and invalid state, so this isn't allowed.

**Alternative :**

Create a dataclass and extend one of these classes :

- `ValidValueObject`
- `ValidEntity`

When using the dataclass as a parameter inside a `SimpleEntity` or `GeneralEntity`, don't forget to annotate the parameter with `@valid`.

_Example 1 :_ Creating a `ValidEntity` using freezed

```dart
@freezed
class ValidPerson1 extends ValidEntity with _$ValidPerson1 {
  const factory ValidPerson1({
    required int age,
    required String name,
  }) = _ValidPerson1;
}
```

_Example 2 :_ Creating a `ValidEntity` using Equatable

```dart
class ValidPerson2 extends ValidEntity with EquatableMixin, Stringify {
  const ValidPerson2({required this.age, required this.name});

  final int age;
  final String name;

  @override
  List<Object?> get props => [age, name];

  @override
  StringifyMode get stringifyMode => StringifyMode.always;
}
```

> **NB :** While extending `ValidEntity` or `ValidValueObject` doesn't offer any extra functionality to these dataclasses, it is a good practice to do so because it makes your code and intentions clear. It is also a good practice to start the names of these dataclasses with `"Valid"`.

### Modddels that are always invalid

Sometimes you may need to create a modddel that is always invalid. For example :

- A ValueObject that is always invalid and holds a Failure.
- A `SimpleEntity` or `GeneralEntity` with a non-nullable `@invalid` parameter [(See remark)](#the-invalid-annotation)
- A `GeneralEntity` with a nullable parameter annotated with both `@invalid` and `@NullFailure` [(See remark)](#the-nullfailure-annotation)

However, modddels by definition have both a valid and invalid state, so this isn't allowed.

**Alternative :**

Create a dataclass and extend one of these classes :

- `InvalidValueObject`
- `InvalidEntity`
- `InvalidEntityContent`
- `InvalidEntityGeneral`
- `InvalidEntitySize`

Then override the proper `failure` method.

When using the dataclass as a parameter inside a `SimpleEntity` or `GeneralEntity`, don't forget to annotate the parameter with `@invalid`.

> **NB :** It is a good practice to start the name of the dataclass with `"Invalid"`.

_Example 1 :_ Creating an `InvalidEntityContent` using freezed. This also demonstrates the alternative for the situation where we want to have a non-nullable `@invalid` parameter (`invalidName`).

```dart
@freezed
class InvalidPersonContent1 extends InvalidEntityContent
    with _$InvalidPersonContent1 {
  const factory InvalidPersonContent1({
    required Age age,
    required InvalidName invalidName,
  }) = _InvalidPersonContent1;

  const InvalidPersonContent1._();

  @override
  Failure get contentFailure => invalidName.failure;
}
```

There's no need to verify other fields since `invalidName` will be always invalid.

_Example 2 :_ Same example, this time using Equatable.

```dart
class InvalidPersonContent2 extends InvalidEntityContent
    with EquatableMixin, Stringify {
  InvalidPersonContent2(this.age, this.invalidName);

  final Age age;
  final InvalidName invalidName;

  @override
  Failure get contentFailure => invalidName.failure;

  @override
  List<Object?> get props => [contentFailure, age, invalidName];

  @override
  StringifyMode get stringifyMode => StringifyMode.always;
}
```

_Example 3 :_ Creating an `InvalidEntityGeneral` using freezed. This also demonstrates the alternative for the situation where we want to have a nullable parameter annotated with both `@invalid` and `@NullFailure`.

```dart
@freezed
class InvalidPerson extends InvalidEntityGeneral<PersonGeneralFailure>
    with _$InvalidPerson {
  const factory InvalidPerson({
    required Age age,
    required InvalidName? invalidName,
  }) = _InvalidPerson;

  const InvalidPerson._();

  @override
  PersonGeneralFailure get generalFailure => optionOf(invalidName).match(
      (some) => PersonGeneralFailure.hasName(invalidName: some),
      () => const PersonGeneralFailure.noName());
}

@freezed
class PersonGeneralFailure extends GeneralFailure with _$PersonGeneralFailure {
  const factory PersonGeneralFailure.hasName(
      {required InvalidName invalidName}) = _HasName;
  const factory PersonGeneralFailure.noName() = _NoName;
}
```

In this example, it's true that we aren't replicating the exact behaviour of having both an `InvalidEntityGeneral` and an `InvalidEntityContent`, but it's a good compromise since we know `invalidName` will always cause a failure.

---

# Testers

Every modddel mentioned above has a dedicated `Tester`, that makes unit testing easy and straight-forward.

For example, for a 'Name' `SingleValueObject` :

```dart
void main() {
  // (1)
  final nameTester = NameTester();

  // (2)
  nameTester.makeIsValidTestGroup(
    tests: [
      TestIsValid(Name('Josh')),
      TestIsValid(Name('Avi')),
    ],
  );

  // (3)
  nameTester.makeIsInvalidValueTestGroup(
    tests: [
      TestIsInvalidValue(Name(''), const NameValueFailure.empty()),
    ],
  );
}
```

The Tester **(1)** is automatically generated when using the `@modddel` annotation. You can disable its generation by using instead `@ModddelAnnotation(generateTester: false)`.

Each of the functions **(2)** and **(3)** create a group of tests. The group's `description` is automatically generated, but it can be modified by :

1. Providing it in the `Tester`'s arguments

   ```dart
   final nameTester = NameTester(
   	isValidGroupDescription: 'Should be valid when given a valid name',
   	isInvalidGroupDescription: 'Should be invalid when given an invalid name',
   );
   ```

2. Providing it in the function itself. _This takes priority over a description set in the `Tester`'s arguments._

   ```dart
   nameTester.makeIsValidTestGroup(
   	tests: ...,
   	description: 'Should be valid when given a valid name',
   );
   ```

Each test's description is also automatically created. It usually contains the String representation of the modddel SUT _(`modddel.toString()`)_. To keep these descriptions tidy, this String's length is limited to `maxSutDescriptionLength`, beyond which it is ellipsized. This `maxSutDescriptionLength` defaults to `100`, but it can be modified by :

1. Providing it in the modddel annotation :

   ```dart
   @ModddelAnnotation(maxSutDescriptionLength: 50)
   ```

2. Providing it in the `Tester`'s arguments. _This takes priority over `maxSutDescriptionLength` set in the `@ModddelAnnotation`._

   ```dart
   final nameTester = NameTester(
   	maxSutDescriptionLength: 50,
   );
   ```

3. Providing it in the function itself. _This takes priority over `maxSutDescriptionLength` set in the `Tester`'s arguments._

   ```dart
   nameTester.makeIsValidTestGroup(
   	tests: ...,
   	maxSutDescriptionLength: 50,
   );
   ```

> **NB 1:** This "ellipsisation" can be disabled by setting `maxSutDescriptionLength` value to `TesterUtils.noEllipsis` (Which equals `-1`).
>
> **NB 2:** The group description of `makeIsSanitizedTestGroup` contains two Strings (the input + the sanitizedValue), so each one's length is limited to _the half_ of `maxSutDescriptionLength`. This is so that all group descriptions have comparable lengths.

A test's description can be modified by providing the `customDescription` parameter.

```dart
nameTester.makeIsValidTestGroup(
  tests: [
    TestIsValid(
      Name('Josh'),
	  // We add a prefix to the description
      customDescription: const CustomDescription.addPrefix('- Important'),
    ),
    TestIsValid(
      Name('Avi'),
	  // We replace the description altogether
      customDescription:
          const CustomDescription.replaceDescription('- Boy name'),
    ),
  ],
);
```

All other usual `test()` and `group()` parameters (such as `skip`, `retry`...) can also be provided.

```dart
nameTester.makeIsValidTestGroup(
    tests: [
      TestIsValid(Name('Avi'), retry: 4),
    ],
    skip: true,
  );
```

## Testing Sanitization

You can test for sanitization, i.e the changes that are made to the input before being stored inside the modddel.

```dart
void main() {

  final nameTester = NameTester();
  // (1)
  final input = nameTester.makeInput;

  // (2)
  nameTester.makeIsSanitizedTestGroup(
    tests: [
      TestIsSanitized(input(' Josh  '), input('Josh')),
    ],
  );
}
```

Here, we're testing that when the `Name` modddel is given `' Josh '` as an input, it should hold the sanitized input `'Josh'`.

# VsCode snippets

```json
{
  "Single Value Object": {
    "prefix": "singlevalueobject",
    "body": [
      "@modddel",
      "class ${1} extends SingleValueObject<${2}, ${1}ValueFailure, Invalid${1}, Valid${1}>",
      "    with $${1} {",
      "  factory ${1}(${2} input) {",
      "    return $${1}._create(input);",
      "  }",
      "",
      "  const ${1}._();",
      "",
      "  @override",
      "  Option<${1}ValueFailure> validateValue(Valid${1} input) {",
      "    //TODO Implement validateValue",
      "    return none();",
      "  }",
      "}"
    ],
    "description": "Single Value Object"
  },
  "Multi Value Object": {
    "prefix": "multivalueobject",
    "body": [
      "@modddel",
      "class ${1} extends MultiValueObject<${1}ValueFailure, Invalid${1}, Valid${1}>",
      "    with $${1} {",
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
      "  Option<${1}ValueFailure> validateValue(Valid${1} input) {",
      "    //TODO Implement validateValue",
      "    return none();",
      "  }",
      "}"
    ],
    "description": "Multi Value Object"
  },
  "Value Failure": {
    "prefix": "valuefailure",
    "body": [
      "@freezed",
      "class ${1}ValueFailure extends ValueFailure with _$${1}ValueFailure {",
      "  const factory ${1}ValueFailure.${3}(${4}) = _${3/(^.)/${1:/upcase}/};",
      "}"
    ],
    "description": "Value Failure"
  },
  "Value Failure Union Case": {
    "prefix": "valuefailurecase",
    "body": [
      "const factory ${1}ValueFailure.${3}(${4}) = _${3/(^.)/${1:/upcase}/};"
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
      "}"
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
      "}"
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
      "}"
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
      "}"
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
      "}"
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
      "}"
    ],
    "description": "Sized List General Entity"
  },
  "General Failure": {
    "prefix": "generalfailure",
    "body": [
      "@freezed",
      "class ${1}GeneralFailure extends GeneralFailure with _$${1}GeneralFailure {",
      "  const factory ${1}GeneralFailure.${2}(${3}) = _${2/(^.)/${1:/upcase}/};",
      "}"
    ],
    "description": "General Failure"
  },
  "General Failure Union Case": {
    "prefix": "generalfailurecase",
    "body": [
      "const factory ${1}GeneralFailure.${2}(${3}) = _${2/(^.)/${1:/upcase}/};"
    ],
    "description": "General Failure Union Case"
  },
  "Size Failure": {
    "prefix": "sizefailure",
    "body": [
      "@freezed",
      "class ${1}SizeFailure extends SizeFailure with _$${1}SizeFailure {",
      "  const factory ${1}SizeFailure.${2}(${3}) = _${2/(^.)/${1:/upcase}/};",
      "}"
    ],
    "description": "Size Failure"
  },
  "Size Failure Union Case": {
    "prefix": "sizefailurecase",
    "body": [
      "const factory ${1}SizeFailure.${2}(${3}) = _${2/(^.)/${1:/upcase}/};"
    ],
    "description": "Size Failure Union Case"
  },
  "Test a Modddel": {
    "prefix": "testmodddel",
    "body": [
      "void main() {",
      "  const ${1/(^.)/${1:/downcase}/}Tester = ${1/(^.)/${1:/upcase}/}Tester();",
      "  final input = ${1/(^.)/${1:/downcase}/}Tester.makeInput;",
      "",
      "  ${1/(^.)/${1:/downcase}/}Tester.${0}",
      "",
      "}"
    ],
    "description": "Test a Modddel"
  }
}
```

# Limitations

Unlike packages like freezed, the generator doesn't parse the code, so the types that are not defined generation-time can't be retrieved.
As a result :

- The names of the different classes of a modddel such as `InvalidEntity`, `ValidEntity`, `ValueFailure`, `GeneralFailure`... can't be customized. So for example, for a modddel named `Age`, the name of the `ValidEntity` must be `ValidAge`... Using snippets is recommended to make your life easier.
- You sometimes need to use the `TypeName` annotation [(See relevant section).](#typename-annotation)

On the other hand, this makes this package's codebase much easier to maintain, and also it enforces a naming style that will hopefully make your code more readable.
