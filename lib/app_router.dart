import 'package:flutter/material.dart';
import 'package:test_flutter/modules/screens/add_notes_screen.dart';
import 'package:test_flutter/modules/screens/add_user_screen.dart';
import 'package:test_flutter/modules/screens/home_screen.dart';
import 'package:test_flutter/modules/screens/settings_screen.dart';
import 'package:test_flutter/modules/screens/users_screen.dart';

class AppRouter{

  static Route<dynamic>? getRoutes(RouteSettings settings) {
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (context) => const HomeScreen(),);
      case '/add/note':
        return MaterialPageRoute(builder: (context) => const AddNoteScreen(),);
      case '/users':
        return MaterialPageRoute(builder: (context) => const UsersScreen(),);
        case '/add/user':
          return MaterialPageRoute(builder: (context) => const AddUserScreen(),);
      case '/options':
        return MaterialPageRoute(builder: (context) => const SettingsScreen(),);
    }
  }
}