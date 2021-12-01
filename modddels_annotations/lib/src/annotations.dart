class ModddelAnnotation {
  const ModddelAnnotation();
}

const modddel = ModddelAnnotation();

class ValidAnnotation {
  ///When [true], it will generate a getter for the valid field to directly access
  ///it from the not validated entity.
  ///
  ///Defaults to [false]
  final bool generateGetter;

  const ValidAnnotation({this.generateGetter = false});
}

///Use this annotation when you want an element of the entity is not a modddel.
///(for example a simple bool).
const valid = ValidAnnotation();
