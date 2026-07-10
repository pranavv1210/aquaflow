import 'package:flutter/material.dart';
import '../../../../core/models/partner_tanker.dart';
import '../../../../core/shared/widgets/person_card.dart';

class PartnerTankerCard extends StatelessWidget {
  const PartnerTankerCard({required this.partnerTanker, super.key, this.onTap});
  final PartnerTanker partnerTanker;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => PersonCard(
    title: partnerTanker.ownerName,
    subtitle:
        '${partnerTanker.vehicleName} \u00b7 ${partnerTanker.registrationNumber}',
    icon: Icons.handshake_outlined,
    onTap: onTap,
  );
}
