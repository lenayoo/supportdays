// ignore_for_file: unnecessary_library_name

library supportdays_app;

import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'src/app/app_shell.dart';
part 'src/app/models.dart';
part 'src/app/painters.dart';
part 'src/app/shared_widgets.dart';
part 'src/app/steps.dart';
part 'src/app/strings.dart';

void main() {
  runApp(const SupportDaysApp());
}
