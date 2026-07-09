import 'package:flutter/material.dart';

class AquaFlowFab extends StatelessWidget {
  const AquaFlowFab({
    required this.onPressed,
    super.key,
    this.tooltip,
    this.icon = Icons.add_rounded,
  });

  final VoidCallback? onPressed;
  final String? tooltip;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      child: Icon(icon),
    );
  }
}
