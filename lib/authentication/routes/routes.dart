import 'package:flutter/widgets.dart';
import 'package:task_project/authentication/authentication.dart';
import 'package:task_project/home/home.dart';
import 'package:task_project/login/login.dart';

List<Page<dynamic>> onGenerateAuthenticationViewPages(
    AuthenticationStatus state,
    List<Page<dynamic>> pages,
    ) {
  switch (state) {
    case AuthenticationStatus.authenticated:
      return [HomePage.page()];
    case AuthenticationStatus.unauthenticated:
      return [LoginPage.page()];
  }
}