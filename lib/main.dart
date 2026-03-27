import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sensors_plus/sensors_plus.dart';
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
