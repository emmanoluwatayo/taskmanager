// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager/core/shared/enums/processing_status.dart';
import 'package:task_manager/domain/authentication/i_auth_facade.dart';
import 'package:task_manager/domain/model/custom_error/custom_error.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final IAuthFacade iAuthFacade;

  LoginBloc({required this.iAuthFacade}) : super(LoginState.initial()) {
    on<LoginWithEmailAndPassword>(login);
  }

  // sign in
  Future<void> login(
    LoginWithEmailAndPassword event,
    Emitter<LoginState> emit,
  ) async {
    emit(
      state.copyWith(processingStatus: ProcessingStatus.waiting,),
    );

    try {
      await iAuthFacade.signInWithEmailAndPassword(
        emailAddress: event.emailAddress,
        password: event.password,
      );

      emit(
        state.copyWith(
          processingStatus: ProcessingStatus.success,
        ),
      );
    } on CustomError catch (e) {
      emit(
        state.copyWith(
          processingStatus: ProcessingStatus.error,
          error: e,
        ),
      );
    }
  }
}
