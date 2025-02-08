import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:task_project/authentication/authentication.dart';
import 'package:task_project/home/home.dart';
import 'package:task_project/login/login.dart';
import 'package:task_project/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:task_project/l10n/language.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return BlocBuilder<LocaleCubit, Locale?>(
          builder: (context, locale) {
            return MaterialApp(
              theme: FlutterTodosTheme.light,
              darkTheme: FlutterTodosTheme.dark,
              themeMode: themeMode, // Передаем актуальный themeMode
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'), // English
                Locale('ru'), // Russian
              ],
              locale: locale, // Устанавливаем текущий язык
              home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  switch (state.status) {
                    case AuthenticationStatus.authenticated:
                      return const HomePage();
                    case AuthenticationStatus.unauthenticated:
                      return const LoginPage();
                    default:
                      return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}


