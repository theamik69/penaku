import 'package:flutter/material.dart';

class CategoriesProvider extends InheritedWidget {
  final List<String> categories;
  final Function(String) addCategory;

  const CategoriesProvider({
    required this.categories,
    required this.addCategory,
    required Widget child,
    super.key,
  }) : super(child: child);

  static CategoriesProvider of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<CategoriesProvider>();
    assert(result != null, 'No CategoriesProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(CategoriesProvider oldWidget) {
    return categories != oldWidget.categories;
  }
}