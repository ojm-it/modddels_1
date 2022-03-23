import 'package:example/value_objects/1_single_value_object/name.dart';
import 'package:fpdart/fpdart.dart';
import 'package:kt_dart/collection.dart';
import 'package:modddels_annotations/modddels_annotations.dart';

part 'contact_list.modddel.dart';

@modddel
class ContactList
    extends ListEntity<InvalidContactListContent, ValidContactList>
    with $ContactList {
  factory ContactList(KtList<Name> list) {
    return $ContactList._create(list);
  }

  const ContactList._();
}
