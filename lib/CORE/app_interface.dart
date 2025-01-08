import 'dart:io';

import 'package:flutter/material.dart';

abstract class AppInterface {
  Future<void> initApp();
  Future<File?> uploadFile(BuildContext context);
}
