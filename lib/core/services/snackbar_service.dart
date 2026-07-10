import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_elevation.dart';
import '../theme/app_glass.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

enum AppToastType { success, error, warning, info }

class SnackbarService {
  const SnackbarService._();

  static OverlayEntry? _currentEntry;
  static Timer? _dismissTimer;

  static void success(String message) {
    _show(message, type: AppToastType.success);
  }

  static void error(String message) {
    _show(message, type: AppToastType.error);
  }

  static void warning(String message) {
    _show(message, type: AppToastType.warning);
  }

  static void info(String message) {
    _show(message, type: AppToastType.info);
  }

  static void _show(String message, {required AppToastType type}) {
    final context = scaffoldMessengerKey.currentContext;
    if (context == null) {
      return;
    }
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) {
      return;
    }

    _dismissTimer?.cancel();
    _currentEntry?.remove();
    _currentEntry = OverlayEntry(
      builder: (BuildContext context) {
        return _PremiumToast(message: message, type: type);
      },
    );
    overlay.insert(_currentEntry!);
    _dismissTimer = Timer(const Duration(seconds: 3), dismiss);
  }

  static void dismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

class _PremiumToast extends StatefulWidget {
  const _PremiumToast({required this.message, required this.type});

  final String message;
  final AppToastType type;

  @override
  State<_PremiumToast> createState() => _PremiumToastState();
}

class _PremiumToastState extends State<_PremiumToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 240),
  )..forward();

  late final Animation<double> _opacity = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );

  late final Animation<Offset> _offset = Tween<Offset>(
    begin: const Offset(0, -0.25),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spec = _specFor(widget.type);
    return Positioned(
      top: MediaQuery.of(context).padding.top + AppSpacing.sm,
      left: AppSpacing.md,
      right: AppSpacing.md,
      child: IgnorePointer(
        child: SlideTransition(
          position: _offset,
          child: FadeTransition(
            opacity: _opacity,
            child: Material(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: AppGlass.heavyBlur,
                    sigmaY: AppGlass.heavyBlur,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.84),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: Colors.white70),
                      boxShadow: AppElevation.medium,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      child: Row(
                        children: <Widget>[
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: spec.color.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(
                                AppRadius.pill,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.xs),
                              child: Icon(
                                spec.icon,
                                color: spec.color,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              widget.message,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _ToastSpec _specFor(AppToastType type) {
    return switch (type) {
      AppToastType.success => const _ToastSpec(
        color: AppColors.emeraldGreen,
        icon: Icons.check_circle_outline_rounded,
      ),
      AppToastType.error => const _ToastSpec(
        color: AppColors.softRed,
        icon: Icons.error_outline_rounded,
      ),
      AppToastType.warning => const _ToastSpec(
        color: AppColors.amber,
        icon: Icons.warning_amber_rounded,
      ),
      AppToastType.info => const _ToastSpec(
        color: AppColors.deepOceanBlue,
        icon: Icons.info_outline_rounded,
      ),
    };
  }
}

class _ToastSpec {
  const _ToastSpec({required this.color, required this.icon});

  final Color color;
  final IconData icon;
}
