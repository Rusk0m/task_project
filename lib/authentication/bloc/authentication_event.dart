part of 'authentication_bloc.dart';

sealed class AuthenticationEvent {
  const AuthenticationEvent();
}

final class  AuthenticationUserSubscriptionRequested extends AuthenticationEvent {
  const  AuthenticationUserSubscriptionRequested();
}

final class  AuthenticationLogoutPressed extends AuthenticationEvent {
  const  AuthenticationLogoutPressed();
}