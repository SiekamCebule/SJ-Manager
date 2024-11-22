mixin NameAndSurnameMixin {
  String get name;
  String get surname;

  String nameAndSurname({bool capitalizeSurname = false, bool reverse = false}) {
    var appropriateSurname = surname;
    if (capitalizeSurname) {
      appropriateSurname = appropriateSurname.toUpperCase();
    }
    return reverse ? '$appropriateSurname $name ' : '$name $appropriateSurname';
  }
}
