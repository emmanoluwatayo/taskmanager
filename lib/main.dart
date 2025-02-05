import 'package:flutter/material.dart';
import 'package:task_manager/core/global_config.dart';
import 'package:task_manager/presentaion/core/app_widgets.dart';


Future<void> main() async {
  await GlobalConfig.initConfig();
  runApp(const AppWidget());
}
