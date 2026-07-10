import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_spacing.dart';
import '../../utils/debouncer.dart';
import '../widgets/app_screen.dart';
import '../widgets/aquaflow_fab.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/page_header.dart';
import '../widgets/search_field.dart';
import '../widgets/timed_loading_view.dart';

class BaseMasterPage<TItem> extends ConsumerStatefulWidget {
  const BaseMasterPage({
    required this.title,
    required this.subtitle,
    required this.searchLabel,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.emptyIcon,
    required this.loadItems,
    required this.buildItem,
    required this.buildLoading,
    required this.onRefresh,
    super.key,
    this.onAdd,
  });

  final String title;
  final String subtitle;
  final String searchLabel;
  final String emptyTitle;
  final String emptyMessage;
  final IconData emptyIcon;
  final AsyncValue<List<TItem>> Function(WidgetRef ref, String query) loadItems;
  final Widget Function(BuildContext context, TItem item) buildItem;
  final Widget Function() buildLoading;
  final Future<void> Function(WidgetRef ref, String query) onRefresh;
  final VoidCallback? onAdd;

  @override
  ConsumerState<BaseMasterPage<TItem>> createState() =>
      _BaseMasterPageState<TItem>();
}

class _BaseMasterPageState<TItem> extends ConsumerState<BaseMasterPage<TItem>> {
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(
    delay: const Duration(milliseconds: 350),
  );
  String _query = '';

  @override
  void dispose() {
    _debouncer.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.loadItems(ref, _query);

    return AppScreen(
      onRefresh: _refresh,
      floatingActionButton:
          widget.onAdd == null
              ? null
              : AquaFlowFab(tooltip: 'Add', onPressed: widget.onAdd),
      children: <Widget>[
        PageHeader(title: widget.title, subtitle: widget.subtitle),
        SearchField(
          label: widget.searchLabel,
          controller: _searchController,
          onChanged: _onSearchChanged,
        ),
        items.when(
          loading:
              () => TimedLoadingView(
                loading: widget.buildLoading(),
                onRetry: _refresh,
              ),
          error: (Object error, StackTrace stackTrace) {
            return ErrorStateWidget(
              title: 'Unable to load ${widget.title.toLowerCase()}',
              message: error.toString(),
              onRetry: _refresh,
            );
          },
          data: (List<TItem> data) {
            return _MasterList<TItem>(
              items: data,
              isSearching: _query.isNotEmpty,
              emptyTitle: widget.emptyTitle,
              emptyMessage: widget.emptyMessage,
              emptyIcon: widget.emptyIcon,
              buildItem: widget.buildItem,
            );
          },
        ),
      ],
    );
  }

  void _onSearchChanged(String value) {
    _debouncer.run(() {
      if (!mounted) {
        return;
      }
      setState(() => _query = value.trim());
    });
  }

  Future<void> _refresh() => widget.onRefresh(ref, _query);
}

class _MasterList<TItem> extends StatelessWidget {
  const _MasterList({
    required this.items,
    required this.isSearching,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.emptyIcon,
    required this.buildItem,
  });

  final List<TItem> items;
  final bool isSearching;
  final String emptyTitle;
  final String emptyMessage;
  final IconData emptyIcon;
  final Widget Function(BuildContext context, TItem item) buildItem;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return SizedBox(
        height: 420,
        child: EmptyStateWidget(
          title: isSearching ? 'No Matching Results' : emptyTitle,
          message: isSearching ? 'Try a different search term.' : emptyMessage,
          icon: isSearching ? Icons.search_off_rounded : emptyIcon,
        ),
      );
    }

    return Column(
      children: <Widget>[
        for (var index = 0; index < items.length; index++) ...<Widget>[
          buildItem(context, items[index]),
          if (index != items.length - 1) const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}
