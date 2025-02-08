import 'package:authentication_repository/authentication_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_project/authentication/authentication.dart';
import 'package:task_project/theme/themeApp.dart';

import '../bloc/authentication_bloc.dart';

class AuthenticationApp extends StatelessWidget {
  const AuthenticationApp({
    required AuthenticationRepository authenticationRepository,
    super.key,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        lazy: false,
        create: (_) => AuthenticationBloc(
          authenticationRepository: _authenticationRepository,
        )..add(const AuthenticationUserSubscriptionRequested()),
        child: const AuthenticationView(),
      ),
    );
  }
}
class AuthenticationView extends StatelessWidget {
  const AuthenticationView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlutterTodosTheme.light,
      home: FlowBuilder<AuthenticationStatus>(
        state: context.select((AuthenticationBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAuthenticationViewPages,
      ),
    );
  }
}
