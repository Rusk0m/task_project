import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:storage_todos_api/storage_todo_api.dart';
import 'package:task_project/api/firebase_api.dart';
import 'package:task_project/app/view/app.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:task_project/app/bloc_observer.dart';

import 'l10n/cubit/language_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  // Инициализация Firebase
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  // Инициализация репозиториев
  final authenticationRepository = AuthenticationRepository();
  //final todosApi = LocalStorageTodosApi(plugin: await SharedPreferences.getInstance(),); //Использование локольного хранилища
  final todosApi = FirestoreStorageTodoApi(FirebaseFirestore.instance);

  final todosRepository = TodosRepository(todosApi: todosApi);
  final settingsRepository = SettingsRepository();

  runApp(App(
      authenticationRepository: authenticationRepository,
      todosRepository: todosRepository,
      settingsRepository: settingsRepository));
}
