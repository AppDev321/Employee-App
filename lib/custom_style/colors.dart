import 'package:flutter/material.dart';



Color borderColor = textFielBoxBorderColor;
const Color blackThemeTextColor = Color(0xECECECFF);
Color cardDarkThemeBg =HexColor.fromHex("#333333");
Color primaryDarkColor = HexColor.fromHex("#FFBF00");
Color primaryBlueColor = HexColor.fromHex("#0047AB");
Color cardThemeBaseColor = HexColor.fromHex("#FFBF00");

Color primaryColor = HexColor.fromHex("#0047AB");
const Color primaryColorOpacity = Color(0xFFFF7F50);
const Color hintTextColor = Color(0xFFE4E0E8);
const Color primaryTextColor = Color(0xFF1A1316);
const Color secondaryTextColor = Color(0xFF8391A0);
const Color tertiaryTextColor = Color(0xFFB5ADAC);
final Color greenColor = Colors.green.shade400;
const Color blueColor = Colors.lightBlueAccent;
const Color whiteColor = Colors.white;
const Color textFielBoxBorderColor =Colors.black38;







const Color inspectionTableColor= Color(0xFFDBDBDB);
const Color claimedShiftColor = Colors.orange;
 Color claimedShiftApprovedColor =HexColor.fromHex("#5cb85c");
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




MaterialColor primaryColorDarkTheme = MaterialColor(primaryDarkColor.value, <int, Color>{
  50: primaryDarkColor,
  100:primaryDarkColor,
  200: primaryDarkColor,
  300: primaryDarkColor,
  400: primaryDarkColor,
  500: primaryDarkColor,
  600: primaryDarkColor,
  700: primaryDarkColor,
  800: primaryDarkColor,
  900: primaryDarkColor,
},
);



List<List<Color>> gradientColorArray=[
  [ HexColor.fromHex("#6D80FE"), HexColor.fromHex("#23D2FD")], //blue
  [ HexColor.fromHex("#eb3349"), HexColor.fromHex("#f45c43")], //Cherry
  [ HexColor.fromHex("#42275a"), HexColor.fromHex("#734b6d")], //Mauve

  [ HexColor.fromHex("#707CFF"), HexColor.fromHex("#FA81E8")], //purple
  [ HexColor.fromHex("#ffafbd"), HexColor.fromHex("#ffc3a0")], //Roseanna
  [ HexColor.fromHex("#2193b0"), HexColor.fromHex("#6dd5ed")], //Sexy Blue
  [ HexColor.fromHex("#cc2b5e"), HexColor.fromHex("#753a88")], //Purple Love

  [ HexColor.fromHex("#ee9ca7"), HexColor.fromHex("#ffdde1")], //Piglet

  [ HexColor.fromHex("#bdc3c7"), HexColor.fromHex("#2c3e50")], // 50 Shades of Grey
  [ HexColor.fromHex("#09AFE8"), HexColor.fromHex("#29F499")], //green


  [ HexColor.fromHex("#de6262"), HexColor.fromHex("#ffb88c")], //A Lost Memory
  [ HexColor.fromHex("#06beb6"), HexColor.fromHex("#48b1bf")], //Socialive
  [ HexColor.fromHex("#FF998B"), HexColor.fromHex("#FF6D88")],

  [ HexColor.fromHex("#dd5e89"), HexColor.fromHex("#f7bb97")], //Pinky
  [ HexColor.fromHex("#56ab2f"), HexColor.fromHex("#a8e063")], //Lush
  [ HexColor.fromHex("#614385"), HexColor.fromHex("#516395")], //Kashmir


  [ HexColor.fromHex("#eecda3"), HexColor.fromHex("#ef629f")], //Tranquil
  [ HexColor.fromHex("#eacda3"), HexColor.fromHex("#d6ae7b")], //Pale Wood
  [ HexColor.fromHex("#02aab0"), HexColor.fromHex("#00cdac")], //Green Beach


  [ HexColor.fromHex("#d66d75"), HexColor.fromHex("#e29587")], //Sha La La
  [ HexColor.fromHex("#ddd6f3"), HexColor.fromHex("#faaca8")], //Almost
  [ HexColor.fromHex("#7b4397"), HexColor.fromHex("#dc2430")], // Virgin America



  [ HexColor.fromHex("#43cea2"), HexColor.fromHex("#185a9d")], //Endless River
  [ HexColor.fromHex("#ba5370"), HexColor.fromHex("#f4e2d8")], //Purple White
  [ HexColor.fromHex("#ff512f"), HexColor.fromHex("#dd2476")], //Bloody Mary


  [ HexColor.fromHex("#4568dc"), HexColor.fromHex("#b06ab3")], //love tonight
  [ HexColor.fromHex("#ec6f66"), HexColor.fromHex("#f3a183")], //Bourbon
  [ HexColor.fromHex("#ff5f6d"), HexColor.fromHex("#ffc371")], //Sweet Morning

  [ HexColor.fromHex("#36d1dc"), HexColor.fromHex("#5b86e5")], //Scooter
  [ HexColor.fromHex("#141e30"), HexColor.fromHex("#243b55")], //Royal
  [ HexColor.fromHex("#ff7e5f"), HexColor.fromHex("#feb47b")], //Sunset


  [ HexColor.fromHex("#ed4264"), HexColor.fromHex("#ffedbc")], //Peach
  [ HexColor.fromHex("#aa076b"), HexColor.fromHex("#61045f")], //Aubergine



];



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
    hexString = hexString.trim();
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