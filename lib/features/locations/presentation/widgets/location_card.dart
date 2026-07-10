import 'package:flutter/material.dart';
import '../../../../core/models/location.dart';
import '../../../../core/shared/widgets/person_card.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({required this.location, super.key, this.onTap});
  final Location location; final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => PersonCard(title: location.locationName, subtitle: location.notes ?? '', icon: Icons.location_on_outlined, onTap: onTap);
}
