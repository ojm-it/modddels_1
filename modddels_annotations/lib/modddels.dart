library modddels;

/// ⚠️ This library will be imported by 'modddels_generator', so it shouldn't
/// contain any file that imports 'flutter_test', because it in turn imports
/// dart:ui, which is not allowed in a builder.

export 'src/modddels/errors.dart' show UnreachableError;
export 'src/modddels/modddel.dart'
    show Modddel, ValidModddel, InvalidModddel, Failure, Stringify;
export 'src/modddels/annotations.dart'
    show
        StringifyMode,
        ModddelAnnotation,
        modddel,
        ValidAnnotation,
        valid,
        InvalidAnnotation,
        invalid,
        WithGetterAnnotation,
        withGetter,
        ValidWithGetterAnnotation,
        validWithGetter,
        InvalidWithGetterAnnotation,
        invalidWithGetter,
        InvalidNull,
        TypeName;

export 'src/modddels/value_objects/value_object.dart'
    show ValueObject, ValidValueObject, InvalidValueObject, ValueFailure;
export 'src/modddels/value_objects/nullable_value_object.dart'
    show NullableValueObject;

export 'src/modddels/entities/common.dart'
    show
        ValidEntity,
        InvalidEntity,
        InvalidEntityContent,
        InvalidEntityGeneral,
        InvalidEntitySize,
        GeneralFailure,
        SizeFailure;
export 'src/modddels/entities/simple_entity.dart' show SimpleEntity;
export 'src/modddels/entities/general_entity.dart' show GeneralEntity;
export 'src/modddels/entities/list_entity.dart' show ListEntity;
export 'src/modddels/entities/list_general_entity.dart' show ListGeneralEntity;
export 'src/modddels/entities/sized_list_entity.dart' show SizedListEntity;
export 'src/modddels/entities/sized_list_general_entity.dart'
    show SizedListGeneralEntity;
