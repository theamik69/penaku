import 'package:flutter/material.dart';
import 'providers/categories_provider.dart';
import 'providers/user_provider.dart';
import 'pages/home_page.dart';
import 'pages/welcome_page.dart';
import 'pages/add_note_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _userName = '';
  bool _userNameSet = false;

  final List<String> _categories = [
    'Pemrograman',
    'UI/UX',
    'Database',
    'DevOps',
  ];

  void _addCategory(String category) {
    if (!_categories.contains(category)) {
      setState(() {
        _categories.add(category);
      });
    }
  }

  void _setUserName(String name) {
    setState(() {
      _userName = name;
      _userNameSet = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return UserProvider(
      userName: _userName,
      setUserName: _setUserName,
      child: CategoriesProvider(
        categories: _categories,
        addCategory: _addCategory,
        child: MaterialApp(
          title: 'Learning Notes',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: _userNameSet
              ? const HomePage()
              : WelcomePage(onNameSubmit: _setUserName),
          routes: {
            '/home': (context) => const HomePage(),
            '/add': (context) => const AddNotePage(),
          },
        ),
      ),
    );
  }
}