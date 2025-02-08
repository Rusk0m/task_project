import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authentication_state.dart';
part 'authentication_event.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(AuthenticationState(user: authenticationRepository.currentUser)) {
    on<AuthenticationUserSubscriptionRequested>(_onUserSubscriptionRequested);
    on<AuthenticationLogoutPressed>(_onLogoutPressed);
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _onUserSubscriptionRequested(
      AuthenticationUserSubscriptionRequested event,
      Emitter<AuthenticationState> emit,
      ) {
    return emit.onEach(
      _authenticationRepository.user,
      onData: (user) => emit(AuthenticationState(user: user)),
      onError: addError,
    );
  }

  void _onLogoutPressed(
      AuthenticationLogoutPressed event,
      Emitter<AuthenticationState> emit,
      ) {
    _authenticationRepository.logOut();
  }
}