import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager/core/shared/enums/processing_status.dart';
import 'package:task_manager/domain/authentication/i_auth_facade.dart';
import 'package:task_manager/domain/model/custom_error/custom_error.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@injectable
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final IAuthFacade iAuthFacade;
  late StreamSubscription authSubscription;

  AuthenticationBloc({required this.iAuthFacade})
      : super(
          AuthenticationState.unknown(),
        ) {
    authSubscription = iAuthFacade.user.listen((fb_auth.User? user) {
      add(AuthChangeEvent(user: user));
    });

    on<AuthChangeEvent>((event, emit) {
      if (event.user != null) {
        emit(
          state.copyWith(
            user: event.user,
          ),
        );
      } else {
        emit(
          state.copyWith(
            user: null,
          ),
        );
      }
    });

    // sign out event
    on<SignOutEvent>((event, emit) async {
      emit(
        state.copyWith(
          processingStatus: ProcessingStatus.waiting,
        ),
      );
      try {
        await iAuthFacade.signOut();
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
    });
  }
}
