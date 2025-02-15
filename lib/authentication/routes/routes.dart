import 'package:flutter/widgets.dart';
import 'package:task_project/authentication/authentication.dart';
import 'package:task_project/screens/home/view/home_page.dart';
import 'package:task_project/screens/login/view/login_page.dart';

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