import 'package:date_in_firebase/data/models/task_model.dart';
import 'package:date_in_firebase/presentation/screens/addtask_screen.dart';
import 'package:date_in_firebase/presentation/screens/login_page.dart';
import 'package:date_in_firebase/presentation/screens/my_homepage.dart';
import 'package:date_in_firebase/presentation/screens/onboarding.dart';
import 'package:date_in_firebase/presentation/screens/welcome_page.dart';
import 'package:date_in_firebase/shared/constants/strings.dart';
import 'package:flutter/material.dart';

import '../presentation/screens/signup_page.dart';


class AppRoute {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        {
          return MaterialPageRoute(builder: (_) => const OnboardingPage());
        }

      case welcomepage:
        {
          return MaterialPageRoute(builder: (_) => const WelcomePage());
        }

      case loginpage:
        {
          return MaterialPageRoute(builder: (_) => const LoginPage());
        }
      case signuppage:
        {
          return MaterialPageRoute(builder: (_) => const SignUpPage());
        }
      case homepage:
        {
          return MaterialPageRoute(builder: (_) => const MyHomePage());
        }
      case addtaskpage:
        {
          final task = settings.arguments as TaskModel?;
          return MaterialPageRoute(
              builder: (_) => AddTaskScreen(
                    task: task,
                  ));
        }
      default:
        throw 'No Page Found!!';
    }
  }
}
