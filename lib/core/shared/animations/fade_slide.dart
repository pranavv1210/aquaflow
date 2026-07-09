import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../theme/app_motion.dart';

extension FadeSlideAnimation on Widget {
  Widget fadeSlide({Duration delay = Duration.zero}) {
    return animate(
      delay: delay,
    ).fadeIn(duration: AppMotion.normal).slideY(begin: 0.04, end: 0);
  }
}
