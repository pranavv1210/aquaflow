import 'package:flutter/material.dart';

import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/aqua_filter_chip.dart';
import '../../../core/shared/widgets/empty_state_widget.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/search_field.dart';

class GlobalSearchPage extends StatefulWidget {
  const GlobalSearchPage({super.key});

  @override
  State<GlobalSearchPage> createState() => _GlobalSearchPageState();
}

class _GlobalSearchPageState extends State<GlobalSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilter = 0;

  static const List<String> _filters = <String>[
    'All',
    'Orders',
    'Customers',
    'Vehicles',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      children: <Widget>[
        const PageHeader(title: 'Global Search', subtitle: 'Search AquaFlow'),
        SearchField(
          label: 'Search orders, customers, vehicles',
          controller: _searchController,
          onChanged: (_) => setState(() {}),
        ),
        AquaFilterChipBar(
          labels: _filters,
          selectedIndex: _selectedFilter,
          onSelected: (int index) => setState(() => _selectedFilter = index),
        ),
        EmptyStateWidget(
          title:
              _searchController.text.trim().isEmpty
                  ? 'Search Ready'
                  : 'No ${_filters[_selectedFilter]} Results',
          message:
              _searchController.text.trim().isEmpty
                  ? 'Enter a search term to view matching records.'
                  : 'No matching records were found.',
          icon: Icons.search_rounded,
        ),
      ],
    );
  }
}
