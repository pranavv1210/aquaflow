import 'package:flutter/material.dart';

import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/person_card.dart';
import '../../../core/shared/widgets/search_field.dart';
import '../../../core/shared/widgets/ui_state_switcher.dart';

class PartnersPage extends StatelessWidget {
  const PartnersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UiStateSwitcher(
      state: UiContentState.populated,
      emptyTitle: 'No Partner Tankers Yet',
      emptyIcon: Icons.handshake_outlined,
      populated: AppScreen(
        children: <Widget>[
          PageHeader(title: 'Partner Tankers', subtitle: 'External fleet'),
          SearchField(label: 'Search partners'),
          PersonCard(
            title: 'Partner --',
            subtitle: 'Vehicle --',
            icon: Icons.handshake_outlined,
          ),
          PersonCard(
            title: 'Partner --',
            subtitle: 'Vehicle --',
            icon: Icons.handshake_outlined,
          ),
        ],
      ),
    );
  }
}
