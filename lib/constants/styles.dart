import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static final semiBold = GoogleFonts.chivo().copyWith(
    color: Colors.black,
    fontSize: 25,
    fontWeight: FontWeight.w400,
  );

  static final small = GoogleFonts.chivo().copyWith(
    color: Colors.black,
    fontSize: 15,
  );

  static final subtitleSmall = GoogleFonts.chivo().copyWith(
    color: Colors.white54,
    fontSize: 15,
  );

  static final text = GoogleFonts.chivo(fontSize: 13);
}
