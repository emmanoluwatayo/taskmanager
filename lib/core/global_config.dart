import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager/application/services/shared_prefs_storage_services.dart';
import 'package:task_manager/core/dependency_injectables/injection.dart';
import 'package:task_manager/firebase_options.dart';


class GlobalConfig {
  static late SharedPrefsStorageService storageService;

  static Future<void> initConfig() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    configureDependencies(Environment.prod);
    storageService = await SharedPrefsStorageService().init();

    // await RemoteConfig.fetchApiKey(
    //   apiKeyName: AppStrings.NIN_VERIFICATION_API_KEY,
    // );

    // await RemoteConfig.fetchApiKey(
    //   apiKeyName: AppStrings.FLUTTERWAVE_API_PUBLIC_KEY,
    // );
  }
}
