// ignore_for_file: depend_on_referenced_packages, unnecessary_import

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager/core/shared/enums/processing_status.dart';
import 'package:task_manager/domain/authentication/i_auth_facade.dart';
import 'package:task_manager/domain/model/custom_error/custom_error.dart';

part 'forget_password_event.dart';

part 'forget_password_state.dart';

part 'forget_password_bloc.freezed.dart';

@injectable
class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final IAuthFacade iAuthFacade;

  ForgotPasswordBloc({required this.iAuthFacade})
      : super(ForgotPasswordState.initial()) {
    on<ForgotPassword>(forgotPassword);
  }

  // forgot password
  Future<void> forgotPassword(
    ForgotPassword event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(
      state.copyWith(processingStatus: ProcessingStatus.waiting),
    );

    try {
      await iAuthFacade.forgotPassword(
        emailAddress: event.emailAddress,
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
