part of 'authentication_bloc.dart';

enum AuthenticationStatus { authenticated, unauthenticated }

final class AuthenticationState extends Equatable {
  const AuthenticationState({User user = User.empty})
      : this._(
    status: user == User.empty
        ? AuthenticationStatus.unauthenticated
        : AuthenticationStatus.authenticated,
    user: user,
  );

  const AuthenticationState._({required this.status, this.user = User.empty});

  final AuthenticationStatus status;
  final User user;

  @override
  List<Object> get props => [status, user];
}