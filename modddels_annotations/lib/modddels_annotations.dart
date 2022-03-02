library modddels_annotations;

export 'src/errors.dart' show UnreachableError;
export 'src/modddel.dart' show Modddel, ValidModddel, InvalidModddel, Failure;
export 'src/annotations.dart'
    show
        ModddelAnnotation,
        modddel,
        ValidAnnotation,
        valid,
        WithGetterAnnotation,
        withGetter,
        ValidWithGetterAnnotation,
        validWithGetter,
        InvalidNull;

export 'src/value_object/value_object.dart'
    show ValueObject, ValidValueObject, InvalidValueObject, ValueFailure;
export 'src/value_object/nullable_value_object.dart' show NullableValueObject;

export 'src/entities/common.dart'
    show
        ValidEntity,
        InvalidEntity,
        InvalidEntityContent,
        InvalidEntityGeneral,
        InvalidEntitySize,
        GeneralFailure,
        SizeFailure;
export 'src/entities/simple_entity.dart' show SimpleEntity;
export 'src/entities/general_entity.dart' show GeneralEntity;
export 'src/entities/list_entity.dart' show ListEntity;
export 'src/entities/list_general_entity.dart' show ListGeneralEntity;
export 'src/entities/sized_list_entity.dart' show SizedListEntity;
export 'src/entities/sized_list_general_entity.dart'
    show SizedListGeneralEntity;

export 'src/testers/test_case.dart' show TestCase;
export 'src/testers/value_objects_testers/test_cases.dart'
    show
        TestIsSanitized,
        TestIsNotSanitized,
        TestIsValidValue,
        TestIsInvalidValue;
export 'src/testers/value_objects_testers/value_objects_testers.dart'
    show ValueObjectTester, NullableValueObjectTester;
export 'src/testers/entities_testers/test_cases.dart'
    show
        TestIsValidEntity,
        TestIsInvalidContent,
        TestIsInvalidGeneral,
        TestIsInvalidSize;
export 'src/testers/entities_testers/entities_testers.dart'
    show
        SimpleEntityTester,
        GeneralEntityTester,
        ListEntityTester,
        ListGeneralEntityTester,
        SizedListEntityTester,
        SizedListGeneralEntityTester;
