import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:task_project/authentication/authentication.dart';
import 'package:task_project/theme/theme.dart';

import '../../l10n/language.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    final l10n = AppLocalizations.of(context);
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);

    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 90,
            child: DrawerHeader(
              child: Center(
                  child: Column(
                children: [
                  Text(l10n!.todosSettingDrawerHeader),
                  Text(user.email??''),
                ],
              )),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          ListTile(
            title: Text(l10n.darkTheme),
            trailing: Switch(
              value: context.watch<ThemeCubit>().state == ThemeMode.dark,
              onChanged: (value) {
                final theme = value ? ThemeMode.dark : ThemeMode.light;
                context.read<ThemeCubit>().toggleTheme(theme);
              },
            ),
          ),
          ListTile(
            title: const Text('Русский'),
            trailing: Radio<Locale>(
              value: const Locale('ru'),
              groupValue: context.watch<LocaleCubit>().state,
              onChanged: (locale) {
                if (locale != null) {
                  context.read<LocaleCubit>().changeLocale(locale);
                }
              },
            ),
          ),
          ListTile(
            title: const Text('English'),
            trailing: Radio<Locale>(
              value: const Locale('en'),
              groupValue: context.watch<LocaleCubit>().state,
              onChanged: (locale) {
                if (locale != null) {
                  context.read<LocaleCubit>().changeLocale(locale);
                }
              },
            ),
          ),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  context
                      .read<AuthenticationBloc>()
                      .add(const AuthenticationLogoutPressed());
                },
                child: Text(l10n.titleLogOutButton)),
          ),
        ],
      ),
    );
  }
}
