// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager/core/shared/enums/processing_status.dart';
import 'package:task_manager/domain/authentication/i_auth_facade.dart';
import 'package:task_manager/domain/model/custom_error/custom_error.dart';

part 'registration_event.dart';
part 'registration_state.dart';
part 'registration_bloc.freezed.dart';

@injectable
class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final IAuthFacade iAuthFacade;

  RegistrationBloc({required this.iAuthFacade}) : super(RegistrationState.initial()) {
    on<RegisterWithEmailAndPassword>(register);
  }

  // sign up
  Future<void> register(
    RegisterWithEmailAndPassword event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(
      state.copyWith(processingStatus: ProcessingStatus.waiting),
    );

    try {
      await iAuthFacade.registerWithEmailAndPassword(
        emailAddress: event.emailAddress,
        password: event.password,
        phoneNumber: event.phoneNumber,
        fullName: event.fullName,
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
