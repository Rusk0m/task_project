import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:task_project/app/view/app_view.dart';
import 'package:task_project/edit_todo/bloc/edit_todo_bloc.dart';
import 'package:task_project/l10n/language.dart';
import 'package:task_project/theme/theme.dart';
import 'package:task_project/todos_overview/bloc/todos_overview_bloc.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:task_project/authentication/authentication.dart';

class App extends StatelessWidget {

  const App({
    required this.authenticationRepository,
    required this.todosRepository,
    required this.settingsRepository,
    super.key,
  });
  final SettingsRepository settingsRepository;
  final AuthenticationRepository authenticationRepository;
  final TodosRepository todosRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authenticationRepository),
        RepositoryProvider.value(value: todosRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
            )..add(const AuthenticationUserSubscriptionRequested()),
          ),
          BlocProvider(
            create: (_) => TodosOverviewBloc(todosRepository: todosRepository),
          ),
          BlocProvider(
            create: (_) => ThemeCubit(settingsRepository),
          ),
          BlocProvider(
            create: (_) => LocaleCubit(settingsRepository),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}