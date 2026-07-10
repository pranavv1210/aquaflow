import 'dart:async';

import 'package:flutter/material.dart';

import 'error_state_widget.dart';

class TimedLoadingView extends StatefulWidget {
  const TimedLoadingView({
    required this.loading,
    required this.onRetry,
    super.key,
    this.timeout = const Duration(seconds: 10),
    this.title = 'Taking longer than expected',
    this.message = 'Please check your connection and try again.',
  });

  final Widget loading;
  final VoidCallback onRetry;
  final Duration timeout;
  final String title;
  final String message;

  @override
  State<TimedLoadingView> createState() => _TimedLoadingViewState();
}

class _TimedLoadingViewState extends State<TimedLoadingView> {
  bool _timedOut = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_timedOut) {
      return widget.loading;
    }

    return ErrorStateWidget(
      title: widget.title,
      message: widget.message,
      onRetry: () {
        setState(() => _timedOut = false);
        _startTimer();
        widget.onRetry();
      },
    );
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(widget.timeout, () {
      if (mounted) {
        setState(() => _timedOut = true);
      }
    });
  }
}
