import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager/core/dependency_injectables/injection.config.dart';

final GetIt getIt = GetIt.instance;

@injectableInit
void configureDependencies(String env) => getIt.init(environment: env);
