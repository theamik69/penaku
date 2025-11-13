import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final Widget? actions;

  const CustomAppBar({
    required this.title,
    this.onBackPressed,
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: onBackPressed != null
          ? IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
        onPressed: onBackPressed,
      )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1F2937),
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: actions != null ? [actions!] : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}