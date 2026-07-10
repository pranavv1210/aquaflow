import 'package:flutter/material.dart';

import '../../../../core/shared/widgets/skeleton_loader.dart';

class ExpenseListSkeleton extends StatelessWidget {
  const ExpenseListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        SkeletonLoader(height: 124),
        SizedBox(height: 12),
        SkeletonLoader(height: 124),
        SizedBox(height: 12),
        SkeletonLoader(height: 124),
      ],
    );
  }
}
