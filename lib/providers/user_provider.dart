import 'package:flutter/material.dart';

class UserProvider extends InheritedWidget {
  final String userName;
  final Function(String) setUserName;

  const UserProvider({
    required this.userName,
    required this.setUserName,
    required Widget child,
    super.key,
  }) : super(child: child);

  static UserProvider of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<UserProvider>();
    assert(result != null, 'No UserProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(UserProvider oldWidget) {
    return userName != oldWidget.userName;
  }
}