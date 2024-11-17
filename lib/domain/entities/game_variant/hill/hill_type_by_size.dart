enum HillTypeBySize {
  skiFlying,
  big,
  large,
  normal,
  medium,
  small;

  static HillTypeBySize fromHsPoint(double hsPoint) {
    return switch (hsPoint) {
      <= 49 => HillTypeBySize.small,
      <= 84 => HillTypeBySize.medium,
      <= 109 => HillTypeBySize.normal,
      <= 149 => HillTypeBySize.large,
      <= 184 => HillTypeBySize.big,
      _ => HillTypeBySize.skiFlying,
    };
  }
}
