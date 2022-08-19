import 'package:flutter/material.dart';

Color primaryColor = HexColor.fromHex("#0047AB");
const Color primaryColorOpacity = Color(0xFFFF7F50);
const Color hintTextColor = Color(0xFFE4E0E8);
const Color primaryTextColor = Color(0xFF1A1316);
const Color secondaryTextColor = Color(0xFF8391A0);
const Color tertiaryTextColor = Color(0xFFB5ADAC);
final Color greenColor = Colors.green.shade400;
const Color blueColor = Colors.lightBlueAccent;
const Color whiteColor = Colors.white;
const Color textFielBoxBorderColor = Colors.black38;
const Color textFielBoxFillColor = Colors.white;
const Color inspectionTableColor= Color(0xFFDBDBDB);
const Color claimedShiftColor = Colors.orange;
const Color claimedShiftApprovedColor = Color(0xFF0692C9);
const Color claimedShiftRejectColor = Color(0xFFD92C3C);
const Color cardShadow= Color(0x33959BA5);

MaterialColor primaryColorTheme = MaterialColor(primaryColor.value, <int, Color>{
  50: primaryColor,
  100:primaryColor,
  200: primaryColor,
  300: primaryColor,
  400: primaryColor,
  500: primaryColor,
  600: primaryColor,
  700: primaryColor,
  800: primaryColor,
  900: primaryColor,
},
);

List<Color> colorArray = [

   HexColor.fromHex("#9b19f5"),

   HexColor.fromHex("#fd7f6f"),
   HexColor.fromHex("#7eb0d5"),
   HexColor.fromHex("#b2e061"),
   HexColor.fromHex("#ffb55a"),
   HexColor.fromHex("#ffee65"),
   HexColor.fromHex("#beb9db"),
   HexColor.fromHex("#fdcce5"),
   HexColor.fromHex("#8bd3c7"),
   HexColor.fromHex("#8be04e"),
   HexColor.fromHex("#8bd3c7"),
   HexColor.fromHex("#dc0ab4"),
   HexColor.fromHex("#ff7800"),
   HexColor.fromHex("#e60049"),
   HexColor.fromHex("#0bb4ff"),
];





extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}