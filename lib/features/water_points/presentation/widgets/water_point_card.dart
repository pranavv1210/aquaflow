import 'package:flutter/material.dart';
import '../../../../core/models/water_point.dart';
import '../../../../core/shared/widgets/person_card.dart';

class WaterPointCard extends StatelessWidget {
  const WaterPointCard({required this.waterPoint, super.key, this.onTap});
  final WaterPoint waterPoint; final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => PersonCard(title: waterPoint.waterPointName, subtitle: waterPoint.locationId ?? '', icon: Icons.water_drop_outlined, onTap: onTap);
}
