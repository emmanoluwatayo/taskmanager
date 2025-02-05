// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i973;
import 'package:task_manager/application/bloc/authentication/auth/auth_bloc.dart'
    as _i56;
import 'package:task_manager/application/bloc/authentication/complete_reg/complete_reg_bloc.dart'
    as _i1030;
import 'package:task_manager/application/bloc/authentication/forgot_password/forget_password_bloc.dart'
    as _i78;
import 'package:task_manager/application/bloc/authentication/login/login_bloc.dart'
    as _i1038;
import 'package:task_manager/application/bloc/authentication/profile/profile_bloc.dart'
    as _i346;
import 'package:task_manager/application/bloc/authentication/registration/registration_bloc.dart'
    as _i310;
import 'package:task_manager/core/utilities/network_info.dart' as _i419;
import 'package:task_manager/domain/authentication/i_auth_facade.dart' as _i826;
import 'package:task_manager/infrastructure/authentication/firebase_auth_facade.dart'
    as _i60;
import 'package:task_manager/infrastructure/core/injectable_module.dart'
    as _i658;
import 'package:uuid/uuid.dart' as _i706;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final injectableModule = _$InjectableModule();
    gh.lazySingleton<_i116.GoogleSignIn>(() => injectableModule.googleSignIn);
    gh.lazySingleton<_i59.FirebaseAuth>(() => injectableModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => injectableModule.firestore);
    gh.lazySingleton<_i457.FirebaseStorage>(
        () => injectableModule.firebaseStorage);
    gh.lazySingleton<_i706.Uuid>(() => injectableModule.uuid);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => injectableModule.secureStorage);
    gh.lazySingleton<_i895.Connectivity>(() => injectableModule.connectivity);
    gh.lazySingleton<_i973.InternetConnectionChecker>(
        () => injectableModule.internetConnectionChecker);
    gh.lazySingleton<_i419.NetworkInfoImpl>(() => injectableModule.networkInfo);
    gh.lazySingleton<_i419.NetworkInfo>(() => _i419.NetworkInfoImpl(
          connectivity: gh<_i895.Connectivity>(),
          internetConnectionChecker: gh<_i973.InternetConnectionChecker>(),
        ));
    gh.lazySingleton<_i826.IAuthFacade>(() => _i60.FirebaseAuthFacade(
          firebaseAuth: gh<_i59.FirebaseAuth>(),
          googleSignIn: gh<_i116.GoogleSignIn>(),
          firestore: gh<_i974.FirebaseFirestore>(),
        ));
    gh.factory<_i56.AuthenticationBloc>(
        () => _i56.AuthenticationBloc(iAuthFacade: gh<_i826.IAuthFacade>()));
    gh.factory<_i1030.CompleteRegBloc>(
        () => _i1030.CompleteRegBloc(iAuthFacade: gh<_i826.IAuthFacade>()));
    gh.factory<_i78.ForgotPasswordBloc>(
        () => _i78.ForgotPasswordBloc(iAuthFacade: gh<_i826.IAuthFacade>()));
    gh.factory<_i1038.LoginBloc>(
        () => _i1038.LoginBloc(iAuthFacade: gh<_i826.IAuthFacade>()));
    gh.factory<_i346.ProfileBloc>(
        () => _i346.ProfileBloc(iAuthFacade: gh<_i826.IAuthFacade>()));
    gh.factory<_i310.RegistrationBloc>(
        () => _i310.RegistrationBloc(iAuthFacade: gh<_i826.IAuthFacade>()));
    return this;
  }
}

class _$InjectableModule extends _i658.InjectableModule {}
